<?php
// /public/scripts/sync_schema.php

// --- Medida de seguridad simple ---
// Puedes añadir una contraseña aquí para que solo tú puedas ejecutarlo.
// Ejemplo: if (($_GET['password'] ?? '') !== 'mi_clave_secreta') { die('Acceso denegado.'); }

header('Content-Type: text/plain; charset=utf-8');

require_once dirname(__DIR__, 2) . '/config/config.php';
require_once dirname(__DIR__, 2) . '/app/classes/ApiDataBase.php';

try {
	echo "Iniciando sincronización de esquemas...\n\n";
	$db = new ApiDataBase(DB_HOST, DB_USER, DB_PASS, DB_NAME);

	// 1. Obtener todas las tablas
	$tables = $db->query("SELECT table_name, table_comment FROM information_schema.tables WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE' AND table_name NOT IN ('app_schema', 'historial_cambios', 'permisos')");

	$schemasSynced = 0;
	foreach ($tables as $table) {
		$tableName = $table['table_name'];
		$tableComment = $table['table_comment'];

		echo "Procesando tabla: {$tableName}...\n";

		// 2. Obtener los comentarios de las columnas para esta tabla
		$columnsData = $db->query("SELECT COLUMN_NAME, COLUMN_COMMENT FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? ORDER BY ORDINAL_POSITION", [$tableName]);

		$columnsSchema = [];
		foreach ($columnsData as $column) {
			$columnName = $column['COLUMN_NAME'];
			// Usamos json_decode para validar y convertir el comentario de la columna
			$columnCommentJson = !empty($column['COLUMN_COMMENT']) ? json_decode($column['COLUMN_COMMENT'], true) : [];

			// Si json_decode falla, devuelve null. Lo convertimos a un objeto vacío.
			if (is_null($columnCommentJson)) {
				echo "  -> ADVERTENCIA: JSON inválido en el comentario de la columna '{$columnName}'. Usando objeto vacío.\n";
				$columnCommentJson = [];
			}
			$columnsSchema[$columnName] = $columnCommentJson;
		}

		// 3. Construir el esquema final
		$tableSchema = !empty($tableComment) ? json_decode($tableComment, true) : [];
		if (is_null($tableSchema)) {
			echo "  -> ADVERTENCIA: JSON inválido en el comentario de la tabla '{$tableName}'. Usando objeto vacío.\n";
			$tableSchema = [];
		}

		$finalSchema = $tableSchema;
		$finalSchema['columns'] = $columnsSchema;

		// 4. Usar json_encode de PHP, que es 100% fiable
		$finalJsonString = json_encode($finalSchema, /*JSON_PRETTY_PRINT | */JSON_UNESCAPED_UNICODE);

		// 5. Insertar/Actualizar en app_schema
		$db->executeAndGetAffectedRows(
			"INSERT INTO app_schema (table_name, schema_json, fecha_modificacion) VALUES (?, ?, NOW())
			 ON DUPLICATE KEY UPDATE schema_json = ?, fecha_modificacion = NOW()",
			[$tableName, $finalJsonString, $finalJsonString]
		);

		echo "  -> ¡Sincronizada!\n";
		$schemasSynced++;
	}

	echo "\nSincronización completada. Se procesaron {$schemasSynced} tablas.\n";

} catch (Exception $e) {
	echo "\n\nERROR FATAL: " . $e->getMessage();
}