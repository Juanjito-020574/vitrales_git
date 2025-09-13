<?php
// /app/classes/SchemaBuilder.php (Versión Final Corregida)

declare(strict_types=1);

class SchemaBuilder
{
	private ApiDataBase $db;
	private int $rolId;
	private array $permissions_fallback;
	private array $table_archetypes;
	private array $column_archetypes;

	public function __construct(ApiDataBase $db, int $rolId)
	{
		$this->db = $db;
		$this->rolId = $rolId;
		$this->permissions_fallback = require(dirname(__DIR__, 2) . '/config/permissions.php');
		$archetypes = require(dirname(__DIR__, 2) . '/config/schema_archetypes.php');
		$this->table_archetypes = $archetypes['table_archetypes'];
		$this->column_archetypes = $archetypes['column_archetypes'];
	}

	public function buildAllHydratedSchemas(): array
	{
		$rawSchemas = $this->db->query("SELECT table_name, schema_json, fecha_modificacion FROM app_schema");
		$db_schema_rules_raw = $this->db->query("SELECT tabla_afectada, regla_json FROM permisos WHERE rol_id = ? AND tipo_regla = 'schema' AND is_active = 1", [$this->rolId]);

		$db_schema_rules = [];
		foreach ($db_schema_rules_raw as $r) {
			$db_schema_rules[$r['tabla_afectada']] = json_decode($r['regla_json'], true);
		}

		$hydratedSchemas = [];
		foreach ($rawSchemas as $row) {
			$tableName = $row['table_name'];
			$schemaObject = json_decode($row['schema_json'], true);
			if (is_null($schemaObject)) continue;

			$hydratedSchema = $this->hydrateSchema($schemaObject);
			$rule = $db_schema_rules[$tableName] ?? $this->permissions_fallback[$tableName]['schema_rules'][$this->rolId] ?? null;
			$finalSchema = $this->applyPermissionRule($hydratedSchema, $rule);

			// Asegurarnos de que las propiedades clave siempre estén presentes
			$finalSchema['tableName'] = $tableName;
			$finalSchema['last_updated'] = $row['fecha_modificacion'];

			$hydratedSchemas[$tableName] = $finalSchema;
		}

		return $hydratedSchemas;
	}

	private function hydrateSchema(array $rawSchema): array
	{
		// --- PASO 1: Hidratar la Tabla ---
		$tableArchetypeKey = $rawSchema['archetype'] ?? null;
		$tableArchetype = $this->table_archetypes[$tableArchetypeKey] ?? [];

		// Usamos array_replace_recursive para que las claves específicas (como 'actions') reemplacen las del arquetipo, no se fusionen.
		$hydratedSchema = array_replace_recursive($tableArchetype, $rawSchema);
		// Casos especiales donde la fusión recursiva no es deseada (ej. actions)
		if (isset($rawSchema['actions'])) {
			$hydratedSchema['actions'] = $rawSchema['actions'];
		}


		// --- PASO 2: Hidratar las Columnas y Resolver Opciones de Select ---
		if (isset($hydratedSchema['columns'])) {
			foreach ($hydratedSchema['columns'] as &$columnConfig) {
				// 2.A: Hidratar columna con su arquetipo
				$columnArchetypeKey = $columnConfig['archetype'] ?? 'TEXT_GENERAL';
				$columnArchetype = $this->column_archetypes[$columnArchetypeKey] ?? [];
				$columnConfig = array_merge($columnArchetype, $columnConfig);

				// 2.B: Si es un select API, resolverlo y convertirlo a staticData
				if (($columnConfig['inputType'] ?? '') === 'select' && ($columnConfig['optionsSource']['type'] ?? '') === 'api') {
					try {
						$this->resolveSelectOptions($columnConfig);
					} catch (Exception $e) {
						$columnConfig['optionsSource']['type'] = 'static';
						$columnConfig['optionsSource']['staticData'] = [['value' => '', 'label' => 'Error al cargar']];
					}
				}
			}
		}
		unset($columnConfig);

		return $hydratedSchema;
	}

	private function resolveSelectOptions(array &$columnConfig): void
	{
		$source = $columnConfig['optionsSource'];
		$endpoint = $source['endpoint'];
		$sql = "SELECT * FROM `{$endpoint}` WHERE is_deleted = 0 AND activo = 1";
		$params = [];

		if (isset($source['filterByRole'])) {
			$filterRules = $source['filterByRole'];
			$ruleForRole = $filterRules[$this->rolId] ?? $filterRules['default'] ?? null;
			if ($ruleForRole) {
				foreach ($ruleForRole as $filterKey => $filterValue) {
					switch ($filterKey) {
						case 'rol_id_in':
							$placeholders = implode(',', array_fill(0, count($filterValue), '?'));
							$sql .= " AND rol_id IN ({$placeholders})";
							$params = array_merge($params, $filterValue);
							break;
						case 'rol_id_gt':
							$sql .= " AND rol_id > ?";
							$params[] = $filterValue;
							break;
						case 'rol_id':
							$sql .= " AND rol_id = ?";
							$params[] = $filterValue;
							break;
					}
				}
			}
		}

		if ($endpoint === 'usuarios') {
			$sql = str_replace("SELECT *", "SELECT u.id, u.nick, u.rol_id, CONCAT(p.nombres, ' ', p.apellidos) AS nombre_completo", $sql);
			$sql = str_replace("FROM `usuarios`", "FROM `usuarios` u LEFT JOIN `perfiles_usuario` p ON u.id = p.usuario_id", $sql);
			$sql = str_replace("rol_id", "u.rol_id", $sql);
			$source['labelKey'] = 'nombre_completo';
			$sql .= " ORDER BY nombre_completo";
		}

		$optionsData = $this->db->query($sql, $params);
		$staticData = [];
		foreach ($optionsData as $row) {
			$label = trim($row[$source['labelKey']] ?? '');
			if (empty($label)) { $label = $row['nick'] ?? 'Usuario ' . ($row[$source['valueKey']] ?? ''); }
			$staticData[] = ['value' => $row[$source['valueKey']], 'label' => $label];
		}

		$columnConfig['optionsSource']['type'] = 'static';
		$columnConfig['optionsSource']['staticData'] = $staticData;
		unset($columnConfig['optionsSource']['endpoint'], $columnConfig['optionsSource']['params'], $columnConfig['optionsSource']['filterByRole']);
	}

	private function applyPermissionRule(array $schema, ?array $rule): array
	{
		if (is_null($rule)) { return $schema; }

		if (!empty($rule['hide_columns_in_table'])) {
			foreach ($rule['hide_columns_in_table'] as $col) unset($schema['columns'][$col]);
		}
		if (!empty($rule['hide_actions'])) {
			if(isset($schema['actions']['table'])) $schema['actions']['table'] = array_filter($schema['actions']['table'], fn($a) => !in_array($a['action'], $rule['hide_actions']));
			if(isset($schema['actions']['row'])) $schema['actions']['row'] = array_filter($schema['actions']['row'], fn($a) => !in_array($a['action'], $rule['hide_actions']));
		}
		if (!empty($rule['field_overrides'])) {
			foreach ($rule['field_overrides'] as $fieldKey => $overrides) {
				if (isset($schema['columns'][$fieldKey])) {
					$schema['columns'][$fieldKey] = array_merge($schema['columns'][$fieldKey], $overrides);
				}
			}
		}
		return $schema;
	}
}