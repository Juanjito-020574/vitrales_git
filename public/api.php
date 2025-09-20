<?php
// /public/api.php

// Inicia o reanuda la sesión en CADA petición.
session_start();

// Habilitar errores para depuración (comentar o poner a 0 en producción).
ini_set('display_errors', 1);
error_reporting(E_ALL);

// --- Dependencias y Configuración ---
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../app/classes/ApiDataBase.php';
// --- CAMBIO --- Reemplazamos SchemaBuilder con nuestro nuevo orquestador AppBuilder.
require_once __DIR__ . '/../app/classes/AppBuilder.php';

// --- Funciones de Utilidad ---

/**
 * Estandariza las respuestas JSON de la API.
 */
function send_response($data, $statusCode = 200) {
	http_response_code($statusCode);
	header('Content-Type: application/json; charset=utf-8'); // Especificamos charset

	// Usamos JSON_THROW_ON_ERROR para que los errores de codificación lancen una excepción.
	try {
		$json_data = json_encode($data, JSON_THROW_ON_ERROR);
		echo $json_data;
	} catch (JsonException $e) {
		// Si json_encode falla, enviamos un error 500 y logueamos el problema.
		http_response_code(500);
		error_log("Error de JSON en send_response: " . $e->getMessage());
		echo json_encode(['error' => 'Error interno del servidor al codificar la respuesta.']);
	}
	exit;
}

/**
 * Obtiene los datos de entrada de la petición (POST, PUT, etc.).
 */
function get_input_data(): array {
	$method = $_SERVER['REQUEST_METHOD'];
	if ($method === 'GET') { return $_GET; }

	$input = file_get_contents('php://input');
	if (strpos($_SERVER['CONTENT_TYPE'] ?? '', 'application/json') !== false) {
		return json_decode($input, true) ?: [];
	}
	parse_str($input, $data);
	return $data;
}

// --- Inicialización ---
try {
	$db = new ApiDataBase(DB_HOST, DB_USER, DB_PASS, DB_NAME);
	// --- CAMBIO --- Instanciamos AppBuilder.
	$appBuilder = new AppBuilder($db);
} catch (Exception $e) {
	send_response(['error' => 'Error de conexión con la base de datos', 'message' => $e->getMessage()], 500);
}

// --- Router Principal de la API ---
$action = $_GET['action'] ?? null;

// --- Verificación de Autenticación ---
// Definimos qué acciones no requieren que el usuario haya iniciado sesión.
$acciones_publicas = ['login', 'status'];
if (!in_array($action, $acciones_publicas) && !isset($_SESSION['user_id'])) {
	send_response(['error' => 'No autorizado. Se requiere inicio de sesión.'], 401);
}

switch ($action) {

	// =========================================================================
	// ENDPOINTS DE SESIÓN Y CONFIGURACIÓN
	// =========================================================================

	case 'status':
		if (isset($_SESSION['user_id'])) {
			send_response([
				'loggedIn' => true,
				'user' => [
					'id' => $_SESSION['user_id'],
					'nick' => $_SESSION['user_nick'] ?? 'N/A',
					'rol_id' => $_SESSION['user_rol_id'] ?? null
				]
			]);
		} else {
			send_response(['loggedIn' => false]);
		}
		break;

	case 'login':
		$data = get_input_data();
		$nick = $data['nick'] ?? '';
		$password = $data['password'] ?? '';

		if (empty($nick) || empty($password)) {
			send_response(['error' => 'Usuario y contraseña son requeridos.'], 400);
			break;
		}

		$user = $db->query("SELECT * FROM usuarios WHERE nick = ? AND activo = 1 AND is_deleted = 0", [$nick], 'single');

		if (!$user || !password_verify($password, $user['password_hash'])) {
			send_response(['error' => 'Credenciales incorrectas o usuario inactivo.'], 401);
			break;
		}

		$_SESSION['user_id'] = $user['id'];
		$_SESSION['user_nick'] = $user['nick'];
		$_SESSION['user_rol_id'] = $user['rol_id'];

		unset($user['password_hash']);
		send_response($user);
		break;

	case 'logout':
		session_destroy();
		send_response(['message' => 'Sesión cerrada exitosamente.']);
		break;

	// --- CAMBIO --- Este es el nuevo y único endpoint para obtener la configuración completa.
	case 'get_app_config':
		$userRoleId = (int)$_SESSION['user_rol_id'];
		$userId = (int)$_SESSION['user_id'];

		$appConfig = $appBuilder->buildAppConfigForUser($userRoleId, $userId);
		send_response($appConfig);
		break;

	// =========================================================================
	// ENDPOINTS CRUD GENÉRICOS
	// =========================================================================

	case 'get_table_data':
		$table = $_GET['table'] ?? null;
		if (!$table || !preg_match('/^[a-zA-Z0-9_]+$/', $table)) { send_response(['error' => 'Nombre de tabla no válido.'], 400); }

		// TODO: Aplicar filtros de visibilidad ('server_side_rules') aquí.
		$data = $db->query("SELECT * FROM `{$table}` WHERE is_deleted = 0");
		send_response($data);
		break;

	case 'get_record_by_id':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) { send_response(['error' => 'Parámetros no válidos.'], 400); }

		$record = $db->query("SELECT * FROM `{$table}` WHERE id = ? AND is_deleted = 0", [$id], 'single');
		send_response($record);
		break;

	case 'create_record':
		$table = $_GET['table'] ?? null;
		if (!$table || !preg_match('/^[a-zA-Z0-9_]+$/', $table)) { send_response(['error' => 'Nombre de tabla no válido.'], 400); }

		$data = get_input_data();
		if (empty($data)) { send_response(['error' => 'No se recibieron datos para crear.'], 400); }

		// --- ¡ESTA ES LA NUEVA LÓGICA DE AUDITORÍA! ---
		// Inyectamos automáticamente los datos del usuario de la sesión.
		if (isset($_SESSION['user_id'])) {
			$data['creado_por'] = $_SESSION['user_id'];
			$data['modificado_por'] = $_SESSION['user_id']; // En la creación, ambos son el mismo.
		}
		// ---------------------------------------------

		$columns = array_keys($data);
		$placeholders = implode(', ', array_fill(0, count($columns), '?'));
		$sql = sprintf("INSERT INTO `%s` (`%s`) VALUES (%s)", $table, implode('`, `', $columns), $placeholders);

		$newId = $db->executeAndGetId($sql, array_values($data));
		send_response(['success' => true, 'id' => $newId], 201);
		break;

	case 'update_record':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) { send_response(['error' => 'Parámetros no válidos.'], 400); }

		$data = get_input_data();
		if (empty($data)) { send_response(['error' => 'No se recibieron datos para actualizar.'], 400); }

		// --- ¡NUEVA LÓGICA DE AUDITORÍA PARA ACTUALIZACIÓN! ---
		if (isset($_SESSION['user_id'])) {
			$data['modificado_por'] = $_SESSION['user_id'];
		}
		// ---------------------------------------------------

		$set_parts = array_map(fn($col) => "`{$col}` = ?", array_keys($data));
		$sql = sprintf("UPDATE `%s` SET %s WHERE id = ?", $table, implode(', ', $set_parts));

		$params = array_values($data);
		$params[] = $id;

		$affectedRows = $db->executeAndGetAffectedRows($sql, $params);
		send_response(['success' => true, 'affectedRows' => $affectedRows]);
		break;

	case 'delete_record':
		$table = $_GET['table'] ?? null;
		$id = $_GET['id'] ?? null;
		if (!$table || !$id || !preg_match('/^[a-zA-Z0-9_]+$/', $table) || !is_numeric($id)) { send_response(['error' => 'Parámetros no válidos.'], 400); }

		$sql = "UPDATE `{$table}` SET is_deleted = 1, deleted_by = ?, fecha_eliminacion = NOW() WHERE id = ?";
		$params = [$_SESSION['user_id'], $id];

		$affectedRows = $db->executeAndGetAffectedRows($sql, $params);
		send_response(['success' => true, 'affectedRows' => $affectedRows]);
		break;

	default:
		send_response(['error' => 'Acción no válida o no especificada.'], 400);
		break;
}