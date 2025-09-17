<?php
// Indentación con TABS
// public/api.php

header('Content-Type: application/json');
session_start();

// --- Dependencias y Configuración ---
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/classes/ApiDataBase.php';
require_once __DIR__ . '/../app/classes/SchemaBuilder.php';

// --- Función de Utilidad para Respuestas ---
function send_response($data, $statusCode = 200) {
	http_response_code($statusCode);
	echo json_encode($data);
	exit;
}

// --- Inicialización ---
try {
	$db = new ApiDataBase(DB_HOST, DB_USER, DB_PASS, DB_NAME);
} catch (Exception $e) {
	send_response(['error' => 'Error de conexión con la base de datos', 'message' => $e->getMessage()], 500);
}

// --- Router Principal de la API ---
$action = $_GET['action'] ?? null;

// --- Verificación de Autenticación (para la mayoría de las acciones) ---
// (Lógica original preservada)
$acciones_publicas = ['login', 'status', 'get_hydrated_schema']; // 'get_hydrated_schema' ahora es público
if (!in_array($action, $acciones_publicas) && !isset($_SESSION['user_id'])) {
	send_response(['error' => 'No autorizado. Se requiere inicio de sesión.'], 401);
}

switch ($action) {

	// ---------------------------------------------------------------------
	// ENDPOINTS DE SESIÓN (Lógica original preservada)
	// ---------------------------------------------------------------------
	case 'login':
		$credentials = json_decode(file_get_contents('php://input'), true);
		$nick = $credentials['nick'] ?? '';
		$password = $credentials['password'] ?? '';

		$user = $db->query("SELECT * FROM usuarios WHERE nick = ? AND activo = 1 AND is_deleted = 0", [$nick], 'single');

		// --- SOLUCIÓN DE FONDO ---
		// 1. Verificamos que se haya encontrado UN usuario.
		// 2. Verificamos que el campo 'password_hash' exista antes de usarlo.
		if (!is_array($user) || empty($user) || !isset($user['password_hash'])) {
			// Si no se encuentra el usuario o faltan datos, devolvemos el error 401.
			send_response(['error' => 'Credenciales incorrectas o usuario inactivo.'], 401);
		}

		// Si el usuario fue encontrado, procedemos a verificar la contraseña.
		if (password_verify($password, $user['password_hash'])) {
			$_SESSION['user_id'] = $user['id'];
			$_SESSION['user_nick'] = $user['nick'];
			$_SESSION['user_role_id'] = $user['rol_id'];
			unset($user['password_hash']); // Nunca devolver el hash
			send_response($user);
		} else {
			send_response(['error' => 'Credenciales incorrectas o usuario inactivo.'], 401);
		}
		break;

	case 'status':
		if (isset($_SESSION['user_id'])) {
			send_response([
				'loggedIn' => true,
				'user' => [
					'id' => $_SESSION['user_id'],
					'nick' => $_SESSION['user_nick'],
					'role_id' => $_SESSION['user_role_id']
				]
			]);
		} else {
			send_response(['loggedIn' => false]);
		}
		break;

	// ---------------------------------------------------------------------
	// ENDPOINT DE ESQUEMA (NUEVA ARQUITECTURA)
	// Reemplaza el antiguo 'get_schema'
	// ---------------------------------------------------------------------
	case 'get_hydrated_schema':
		try {
			// Ya no necesita el rol_id, devuelve el esquema público completo
			$schemaBuilder = new SchemaBuilder($db);
			$hydratedSchemas = $schemaBuilder->buildAllHydratedSchemas(); // Sin parámetros
			send_response($hydratedSchemas);
		} catch (Exception $e) {
			send_response(['error' => 'No se pudo construir el esquema de la aplicación.', 'message' => $e->getMessage()], 500);
		}
		break;

	// ---------------------------------------------------------------------
	// ENDPOINTS CRUD (Lógica original preservada)
	// NOTA: Esta lógica será movida a la clase CrudHandler.php en un paso futuro.
	// ---------------------------------------------------------------------
	case 'get_table_data':
		$table = $_GET['table'] ?? null;
		if (!$table || !preg_match('/^[a-zA-Z0-9_]+$/', $table)) {
			send_response(['error' => 'Nombre de tabla no válido.'], 400);
		}
		try {
			$data = $db->query("SELECT * FROM `$table` WHERE is_deleted = 0");
			send_response($data);
		} catch (Exception $e) {
			send_response(['error' => "Error al obtener datos de la tabla $table.", 'message' => $e->getMessage()], 500);
		}
		break;

	case 'get_record_by_id':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) {
			send_response(['error' => 'Parámetros no válidos.'], 400);
		}
		try {
			$record = $db->query("SELECT * FROM `$table` WHERE id = ? AND is_deleted = 0", [$id], 'single');
			send_response($record);
		} catch (Exception $e) {
			send_response(['error' => "Error al obtener el registro de $table.", 'message' => $e->getMessage()], 500);
		}
		break;

	case 'create_record':
		$table = $_GET['table'] ?? null;
		if (!$table || !preg_match('/^[a-zA-Z0-9_]+$/', $table)) {
			send_response(['error' => 'Nombre de tabla no válido.'], 400);
		}
		$data = json_decode(file_get_contents('php://input'), true);
		if (empty($data)) {
			send_response(['error' => 'No se recibieron datos para crear.'], 400);
		}

		$columns = array_keys($data);
		$placeholders = array_map(fn($c) => ":$c", $columns);
		$sql = sprintf(
			"INSERT INTO `%s` (`%s`) VALUES (%s)",
			$table,
			implode('`, `', $columns),
			implode(', ', $placeholders)
		);

		try {
			$newId = $db->executeAndGetId($sql, $data);
			send_response(['success' => true, 'id' => $newId], 201);
		} catch (Exception $e) {
			send_response(['error' => "Error al crear el registro en $table.", 'message' => $e->getMessage()], 500);
		}
		break;

	case 'update_record':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) {
			send_response(['error' => 'Parámetros no válidos.'], 400);
		}
		$data = json_decode(file_get_contents('php://input'), true);
		if (empty($data)) {
			send_response(['error' => 'No se recibieron datos para actualizar.'], 400);
		}

		$set_parts = [];
		foreach ($data as $column => $value) {
			$set_parts[] = "`$column` = :$column";
		}
		$sql = sprintf(
			"UPDATE `%s` SET %s WHERE id = :id",
			$table,
			implode(', ', $set_parts)
		);
		$data['id'] = $id;

		try {
			$affectedRows = $db->executeAndGetAffectedRows($sql, $data);
			send_response(['success' => true, 'affectedRows' => $affectedRows]);
		} catch (Exception $e) {
			send_response(['error' => "Error al actualizar el registro en $table.", 'message' => $e->getMessage()], 500);
		}
		break;

	case 'delete_record':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) {
			send_response(['error' => 'Parámetros no válidos.'], 400);
		}

		$sql = "UPDATE `$table` SET is_deleted = 1, deleted_by = ?, fecha_eliminacion = NOW() WHERE id = ?";
		$params = [$_SESSION['user_id'] ?? null, $id];

		try {
			$affectedRows = $db->executeAndGetAffectedRows($sql, $params);
			send_response(['success' => true, 'affectedRows' => $affectedRows]);
		} catch (Exception $e) {
			send_response(['error' => "Error al eliminar el registro en $table.", 'message' => $e->getMessage()], 500);
		}
		break;

	default:
		send_response(['error' => 'Acción no válida o no especificada.'], 400);
		break;
}