<?php
class SchemaBuilder {
	private $db;
	private $archetypes;
	private $permissionRules;

	public function __construct(ApiDataBase $db) {
		$this->db = $db;
		$this->archetypes = require __DIR__ . '/../../config/schema_archetypes.php';
		$this->permissionRules = require __DIR__ . '/../../config/permissions.php';
	}

	/**
	 * Método principal refactorizado Y SIMPLIFICADO.
	 * Orquesta la sincronización, lee la caché, hidrata arquetipos y resuelve selects.
	 * YA NO APLICA PERMISOS.
	 */
	public function buildAllHydratedSchemas() { // <--- PARÁMETRO $roleId ELIMINADO
		// ---------------------------------------------------------------------
		// PASO 1: VERIFICAR LA INTEGRIDAD DE LA CACHÉ `app_schema`
		// (Esta parte es correcta y se mantiene)
		// ---------------------------------------------------------------------
		$sql_check_cache = "
			SELECT
				v.table_name
			FROM
				v_schema_con_checksum v
			LEFT JOIN
				app_schema a ON v.table_name = a.table_name
			WHERE
				a.checksum IS NULL OR v.ultimo_cambio > a.checksum
		";
		$tablasDesactualizadas = $this->db->query($sql_check_cache);

		// ---------------------------------------------------------------------
		// PASO 2: SI HAY DISCREPANCIAS, LLAMAR AL SCRIPT DE SINCRONIZACIÓN
		// (Esta parte es correcta y se mantiene)
		// ---------------------------------------------------------------------
		if (!empty($tablasDesactualizadas)) {
			$tablasParaSincronizar = array_column($tablasDesactualizadas, 'table_name');
			$silenciarSalida = true;
			require __DIR__ . '/../../public/scripts/sync_schema.php';
		}

		// ---------------------------------------------------------------------
		// PASO 3: LEER DE LA CACHÉ Y CONSTRUIR ESQUEMA BASE
		// (Esta parte es correcta y se mantiene)
		// ---------------------------------------------------------------------
		$rawSchemas = $this->db->query("SELECT table_name, schema_json FROM app_schema WHERE is_deleted = 0");

		$hydratedSchemas = [];
		foreach ($rawSchemas as $row) {
			$tableName = $row['table_name'];
			$schema = json_decode($row['schema_json'], true);
			if (json_last_error() !== JSON_ERROR_NONE) { continue; }

			$hydrated = $this->hydrateSchema($schema);
			$hydratedSchemas[$tableName] = $hydrated;
		}

		// ---------------------------------------------------------------------
		// PASO 4: RESOLVER SELECTS (LA LÓGICA DE PERMISOS SE ELIMINA)
		// ---------------------------------------------------------------------
		// Se elimina el bloque que leía la tabla `permisos` y aplicaba las reglas.

		foreach ($hydratedSchemas as $tableName => &$schema) {
			$schema = $this->resolveSelectOptions($schema);
		}

		return $hydratedSchemas;
	}

	private function hydrateSchema(array $schema): array {
		// Hidratar comentario de tabla
		if (isset($schema['tableComment']['archetype']) && isset($this->archetypes[$schema['tableComment']['archetype']])) {
			$schema['tableComment'] = array_merge($this->archetypes[$schema['tableComment']['archetype']], $schema['tableComment']);
		}

		// Hidratar comentarios de columnas
		if (isset($schema['columns'])) {
			foreach ($schema['columns'] as $columnName => &$column) {
				if (isset($column['archetype']) && isset($this->archetypes[$column['archetype']])) {
					$column = array_merge($this->archetypes[$column['archetype']], $column);
				}
			}
		}

		return $schema;
	}

	private function applyPermissionRule(array $schema, array $rule): array {
		// Lógica para ocultar tabla completa
		if (!$rule['can_read']) {
			$schema['permissions']['can_read'] = false;
			// Podríamos devolver un esquema vacío o marcado como no visible
			return $schema;
		}

		// Aplicar permisos a nivel de tabla (crear, actualizar, eliminar)
		$schema['permissions']['can_create'] = (bool) $rule['can_create'];
		$schema['permissions']['can_update'] = (bool) $rule['can_update'];
		$schema['permissions']['can_delete'] = (bool) $rule['can_delete'];

		// Aplicar permisos a nivel de columna
		if (!empty($rule['hidden_columns'])) {
			$hidden = json_decode($rule['hidden_columns'], true);
			foreach ($hidden as $colName) {
				if (isset($schema['columns'][$colName])) {
					$schema['columns'][$colName]['visible'] = false;
				}
			}
		}

		// Aplicar filtros de datos
		if (!empty($rule['filtros'])) {
			$schema['filter'] = json_decode($rule['filtros'], true);
		}

		return $schema;
	}

	private function resolveSelectOptions(array $schema): array {
		if (isset($schema['columns'])) {
			foreach ($schema['columns'] as &$column) {
				if (isset($column['archetype']) && $column['archetype'] === 'SELECT_API' && isset($column['optionsSource']['endpoint'])) {

					$endpoint = $column['optionsSource']['endpoint'];
					$valueKey = $column['optionsSource']['valueKey'] ?? 'id';
					$labelKey = $column['optionsSource']['labelKey'] ?? 'nombre';
					$params = $column['optionsSource']['params'] ?? [];

					// Construir la consulta de forma segura (simplificado)
					$sql = "SELECT `$valueKey`, `$labelKey` FROM `$endpoint` WHERE is_deleted = 0";

					$options = $this->db->query($sql);

					// Formatear para el frontend
					$formattedOptions = [];
					foreach($options as $option) {
						$formattedOptions[] = ['value' => $option[$valueKey], 'label' => $option[$labelKey]];
					}

					// Reemplazar la fuente dinámica con los datos estáticos
					unset($column['optionsSource']['endpoint']);
					$column['optionsSource']['staticData'] = $formattedOptions;
					$column['archetype'] = 'SELECT_STATIC';
				}
			}
		}
		return $schema;
	}
}