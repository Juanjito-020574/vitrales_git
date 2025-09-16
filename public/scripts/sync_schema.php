<?php
// -----------------------------------------------------------------------------
// ESTE SCRIPT SINCRONIZA EL ESQUEMA DE LA BASE DE DATOS (DESDE LOS COMMENTS)
// A LA TABLA DE CACHÉ `app_schema`.
//
// Refactorizado para usar la vista `v_schema_con_checksum` y operar
// de forma selectiva o completa.
// -----------------------------------------------------------------------------

// Asumimos que la configuración de la base de datos está en un archivo central
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../app/classes/ApiDataBase.php';

try {
	// 1. CONEXIÓN A LA BD (Reutilizado de tu script original)
	$db = new ApiDataBase(DB_HOST, DB_USER, DB_PASS, DB_NAME);

	// 2. LÓGICA DE REFACTORIZACIÓN: DETERMINAR QUÉ TABLAS NECESITAN ACTUALIZACIÓN

	// Por defecto, asumimos que no hay que actualizar ninguna tabla.
	$tablasParaActualizar = [];

	// Si la variable $tablasParaSincronizar está definida (llamada desde SchemaBuilder),
	// esas son las tablas que debemos actualizar.
	if (isset($tablasParaSincronizar) && is_array($tablasParaSincronizar) && !empty($tablasParaSincronizar)) {
		$tablasParaActualizar = $tablasParaSincronizar;
		$modo = "SELECTIVO";
	} else {
		// Si no, estamos en modo completo. Obtenemos TODAS las tablas de la vista.
		$todasLasTablas = $db->query("SELECT table_name FROM v_schema_con_checksum");
		// Extraemos solo los nombres de las tablas
		$tablasParaActualizar = array_column($todasLasTablas, 'table_name');
		$modo = "COMPLETO";
	}

	// Mensaje para depuración cuando se ejecuta manualmente
	if (php_sapi_name() !== 'cli' && !isset($silenciarSalida)) {
		echo "Modo de Sincronización: $modo.<br>";
		if (empty($tablasParaActualizar)) {
			echo "No se encontraron tablas para procesar.<br>";
		} else {
			echo "Tablas a procesar: " . implode(', ', $tablasParaActualizar) . "<br>";
		}
	}

	// Si no hay nada que hacer, salimos.
	if (empty($tablasParaActualizar)) {
		if (php_sapi_name() !== 'cli' && !isset($silenciarSalida)) {
			echo "Sincronización no necesaria.<br>";
		}
		return;
	}

	// 3. OBTENER ESQUEMAS ACTUALIZADOS (Usando la nueva vista)
	// Creamos placeholders (?, ?, ?) para una consulta preparada segura
	$placeholders = implode(',', array_fill(0, count($tablasParaActualizar), '?'));

	$sql_select_schemas = "
		SELECT
			table_name,
			schema_json_completo,
			ultimo_cambio AS checksum
		FROM
			v_schema_con_checksum
		WHERE
			table_name IN ($placeholders)
	";

	$nuevosSchemas = $db->query($sql_select_schemas, $tablasParaActualizar);

	// 4. ACTUALIZAR LA TABLA app_schema (Lógica similar a tu script original)
	$sql_update_cache = "
		INSERT INTO app_schema (table_name, schema_json, checksum, fecha_modificacion)
		VALUES (:table_name, :schema_json, :checksum, NOW())
		ON DUPLICATE KEY UPDATE
			schema_json = VALUES(schema_json),
			checksum = VALUES(checksum),
			fecha_modificacion = NOW()
	";

	$updated_count = 0;
	foreach ($nuevosSchemas as $schema) {
		$db->execute($sql_update_cache, [
			':table_name' => $schema['table_name'],
			':schema_json' => $schema['schema_json_completo'],
			':checksum' => $schema['checksum']
		]);
		$updated_count++;
	}

	if (php_sapi_name() !== 'cli' && !isset($silenciarSalida)) {
		echo "Sincronización completada. Se procesaron $updated_count esquemas.<br>";
	}

} catch (Exception $e) {
	// Manejo de errores (similar a tu script)
	http_response_code(500);
	header('Content-Type: application/json');
	echo json_encode([
		'error' => 'Error durante la sincronización del esquema.',
		'message' => $e->getMessage()
	]);
	exit;
}