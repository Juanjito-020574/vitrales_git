<?php
// /app/classes/AppBuilder.php

class AppBuilder {
	private $db;
	private $archetypes;

	public function __construct(ApiDataBase $db) {
		$this->db = $db;
		$this->archetypes = require_once __DIR__ . '/../../config/schema_archetypes.php';
	}

	/**
	 * Orquesta el proceso completo para construir la configuración de la aplicación para un usuario.
	 * @param int $userRoleId
	 * @param int $userId
	 * @return array La configuración final lista para el frontend.
	 */
	public function buildAppConfigForUser(int $userRoleId, int $userId): array {
		// FASE 1: Sincronizar el esquema base si es necesario.
		if ($this->isSchemaOutOfSync()) {
			$this->synchronizeSchema();
		}
		$baseSchemaData = $this->getBaseSchemaFromCache();

		// FASE 2: Obtener todas las reglas de permisos relevantes.
		$dbPermissions = $this->db->query(
			"SELECT tabla_afectada, tipo_regla, regla_json, usuario_id FROM permisos WHERE (rol_id = ? AND usuario_id IS NULL) OR (usuario_id = ?)",
			[$userRoleId, $userId]
		);
		$filePermissionsConfig = require_once __DIR__ . '/../../config/permissions.php';

		// FASE 3: Hidratar el esquema y construir el menú en un solo paso.
		$hydratedData = $this->hydrateSchemaAndBuildMenu($baseSchemaData, $dbPermissions, $filePermissionsConfig, $userRoleId, $userId);

		// FASE 4: Devolver la estructura final y limpia.
		return [
			'menu' => $hydratedData['menu'],
			'tables' => $hydratedData['schema'],
			'session' => [
				'isLoggedIn' => true,
				'userId' => $userId,
				'userRoleId' => $userRoleId,
				'userNick' => $_SESSION['user_nick'] ?? ''
			]
		];
	}

	// =========================================================================
	// MÉTODOS PRIVADOS: LA CADENA DE MONTAJE
	// =========================================================================

	/**
	 * El "motor" principal que fusiona todo en un resultado final.
	 */
	private function hydrateSchemaAndBuildMenu(array $baseSchemaData, array $dbPermissions, array $filePermissionsConfig, int $userRoleId, int $userId): array {
		$finalSchema = [];
		$menuStructure = [];
		$baseSchema = array_column($baseSchemaData, 'schema_json', 'table_name');

		foreach ($baseSchema as $tableName => $schemaJson) {
			$tableSchema = json_decode($schemaJson, true) ?: [];

			// 1. Fusión de Arquetipos (Tabla y Columnas)
			$hydratedTable = $this->applyArchetypes($tableSchema);

			// 2. Fusión de Permisos de la DB
			// Damos prioridad a las reglas de usuario sobre las de rol.
			$userSpecificDbRules = array_filter($dbPermissions, fn($p) => $p['tabla_afectada'] === $tableName && $p['usuario_id'] == $userId);
			$roleSpecificDbRules = array_filter($dbPermissions, fn($p) => $p['tabla_afectada'] === $tableName && $p['usuario_id'] === null);

			$tableDbPermissions = array_merge($roleSpecificDbRules, $userSpecificDbRules);

			foreach ($tableDbPermissions as $perm) {
				if ($perm['tipo_regla'] === 'menu_item') {
					$menuRule = json_decode($perm['regla_json'], true);
					$menuRule['table'] = $tableName;
					$menuStructure[] = $menuRule;
				} else {
					$hydratedTable = $this->applyPermissionRule($hydratedTable, $perm['tipo_regla'], json_decode($perm['regla_json'], true));
				}
			}

			// 3. Fusión de Permisos del Archivo (Reglas Complejas)
			if (isset($filePermissionsConfig[$tableName])) {
				// (Esta sección se puede expandir para manejar reglas más complejas del archivo)
			}

			$finalSchema[$tableName] = $hydratedTable;
		}

		// Ordenar el menú final.
		usort($menuStructure, fn($a, $b) => ($a['order'] ?? 99) <=> ($b['order'] ?? 99));

		return ['schema' => $finalSchema, 'menu' => $menuStructure];
	}

	/**
	 * Aplica una regla de permiso específica a un esquema de tabla.
	 */
	private function applyPermissionRule(array $tableSchema, string $ruleType, array $ruleParams): array {
		if ($ruleType === 'schema') {
			if (isset($ruleParams['hide_columns_in_table'])) {
				foreach ($ruleParams['hide_columns_in_table'] as $colName) {
					if (isset($tableSchema['columns'][$colName])) {
						$tableSchema['columns'][$colName]['visible'] = false;
					}
				}
			}
			if (isset($ruleParams['field_overrides'])) {
				foreach ($ruleParams['field_overrides'] as $colName => $overrides) {
					if (isset($tableSchema['columns'][$colName])) {
						$tableSchema['columns'][$colName] = array_merge_recursive($tableSchema['columns'][$colName], $overrides);
					}
				}
			}
			 if (isset($ruleParams['hide_actions'])) {
				if (isset($tableSchema['actions']['row'])) {
					$tableSchema['actions']['row'] = array_filter($tableSchema['actions']['row'], fn($action) => !in_array($action['action'], $ruleParams['hide_actions']));
				}
				if (isset($tableSchema['actions']['table'])) {
					$tableSchema['actions']['table'] = array_filter($tableSchema['actions']['table'], fn($action) => !in_array($action['action'], $ruleParams['hide_actions']));
				}
			 }
		}

		// Añadir 'server_side_rules' para reglas de visibilidad que deben manejarse en el servidor.
		if ($ruleType === 'visibility' && isset($ruleParams['type']) && $ruleParams['type'] !== 'allow_all') {
			if (!isset($tableSchema['server_side_rules'])) {
				$tableSchema['server_side_rules'] = [];
			}
			$tableSchema['server_side_rules']['visibility'][] = $ruleParams;
		}

		return $tableSchema;
	}

	/**
	 * Aplica los arquetipos de tabla y columna a un esquema base.
	 * ESTA VERSIÓN CORRIGE LA FUSIÓN DE ACCIONES.
	 */
	private function applyArchetypes(array $tableSchema): array {
		if (!isset($tableSchema['archetype'])) return $tableSchema;

		$tableArchetype = $this->archetypes['table_archetypes'][$tableSchema['archetype']] ?? [];

		// 1. Hacemos la fusión recursiva, que funciona bien para casi todo.
		$hydratedTable = array_merge_recursive($tableArchetype, $tableSchema);

		// 2. ¡LA CORRECCIÓN CLAVE!
		// Si el esquema original de la tabla (desde el TABLE_COMMENT) tenía su propia
		// sección de 'actions', significa que quería REEMPLAZAR las del arquetipo, no añadirlas.
		if (isset($tableSchema['actions'])) {
			$hydratedTable['actions'] = $tableSchema['actions'];
		}

		// 3. La hidratación de columnas ya es correcta y no necesita cambios.
		$hydratedTable['columns'] = [];
		if (isset($tableSchema['columns'])) {
			foreach ($tableSchema['columns'] as $columnName => $columnSchema) {
				if (!isset($columnSchema['archetype'])) {
					$hydratedTable['columns'][$columnName] = $columnSchema;
					continue;
				}
				$columnArchetype = $this->archetypes['column_archetypes'][$columnSchema['archetype']] ?? [];
				$hydratedTable['columns'][$columnName] = array_merge_recursive($columnArchetype, $columnSchema);
			}
		}

		return $hydratedTable;
	}

	// --- Métodos de Sincronización (Antes en SchemaBuilder) ---

	private function isSchemaOutOfSync(): bool {
		$sql = "
			SELECT v.table_name
			FROM v_schema_con_checksum v
			LEFT JOIN app_schema a ON v.table_name = a.table_name
			WHERE a.table_name IS NULL OR NOT (v.ultimo_cambio <=> a.checksum)
		";
		$diff = $this->db->query($sql);
		return !empty($diff);
	}

	private function synchronizeSchema(): void {
		$tablesData = $this->db->query("
			SELECT
				v.table_name,
				v.ultimo_cambio,
				t.TABLE_COMMENT as table_comment
			FROM
				v_schema_con_checksum v
			JOIN
				information_schema.TABLES t ON v.table_name = t.TABLE_NAME AND t.TABLE_SCHEMA = DATABASE()
		");

		$this->db->execute("DELETE FROM app_schema");

		$sql = "INSERT INTO app_schema (table_name, schema_json, checksum) VALUES (?, ?, ?)";
		$stmt = $this->db->getConnection()->prepare($sql);

		foreach ($tablesData as $table) {
			$tableName = $table['table_name'];
			$tableComment = $table['table_comment'];
			$tableChecksum = $table['ultimo_cambio'];

			// Creamos el JSON base solo con el comentario de la tabla.
			$schemaBase = json_decode($tableComment, true) ?: [];

			// Obtenemos las columnas y sus comentarios.
			$columnsData = $this->db->query("
				SELECT column_name, column_comment
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE table_schema = DATABASE() AND table_name = ?
			", [$tableName]);

			$columnsSchema = [];
			foreach ($columnsData as $column) {
				$columnsSchema[$column['column_name']] = json_decode($column['column_comment'], true) ?: [];
			}

			// Añadimos las columnas al schema base.
			$schemaBase['columns'] = $columnsSchema;
			$finalJson = json_encode($schemaBase);

			$stmt->bind_param('sss', $tableName, $finalJson, $tableChecksum);
			$stmt->execute();
		}
		$stmt->close();
	}

	private function getBaseSchemaFromCache(): array {
		return $this->db->query("SELECT table_name, schema_json FROM app_schema");
	}
}