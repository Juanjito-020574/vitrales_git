<?php
// /public/api.php (Refactorizado con SchemaBuilder)

declare(strict_types=1);

if (session_status() === PHP_SESSION_NONE) { session_start(); }
ob_start();

header("Content-Type: application/json; charset=UTF-8");
require_once dirname(__DIR__) . '/config/config.php';
require_once dirname(__DIR__) . '/app/classes/ApiDataBase.php';
require_once dirname(__DIR__) . '/app/classes/CrudHandler.php';
// ¡NUEVO! Incluimos el constructor de esquemas
require_once dirname(__DIR__) . '/app/classes/SchemaBuilder.php';

function json_response(int $code, $data): void {
	ob_end_clean();
	http_response_code($code);
	echo json_encode($data, JSON_UNESCAPED_UNICODE);
	exit();
}

try {
	$db = new ApiDataBase(DB_HOST, DB_USER, DB_PASS, DB_NAME);
	$endpoint = $_GET['endpoint'] ?? '';
	$method = $_SERVER['REQUEST_METHOD'];

	// --- Endpoints Públicos (No requieren autenticación) ---

	if ($endpoint === 'login' && $method === 'POST') {
		$input = json_decode(file_get_contents('php://input'), true);
		$nick = $input['nick'] ?? '';
		$password = $input['password'] ?? '';
		if (empty($nick) || empty($password)) { json_response(400, ['error' => 'Usuario y contraseña requeridos.']); }
		$user_data = $db->query("SELECT id, nick, password_hash, rol_id FROM usuarios WHERE nick = ? AND activo = 1 AND is_deleted = 0", [$nick]);
		if (count($user_data) === 1 && $db->verifyPassword($password, $user_data[0]['password_hash'])) {
			$_SESSION['user_id'] = $user_data[0]['id'];
			$_SESSION['user_nick'] = $user_data[0]['nick'];
			$_SESSION['user_rol_id'] = $user_data[0]['rol_id'];
			json_response(200, ['user' => ['id' => $user_data[0]['id'], 'nick' => $user_data[0]['nick'], 'rol_id' => $user_data[0]['rol_id']]]);
		}
		json_response(401, ['error' => 'Credenciales no válidas.']);
	}

	if ($endpoint === 'session-status') {
		if (isset($_SESSION['user_id'])) {
			json_response(200, ['authenticated' => true, 'user' => ['id' => $_SESSION['user_id'], 'nick' => $_SESSION['user_nick'], 'rol_id' => $_SESSION['user_rol_id']]]);
		} else {
			json_response(200, ['authenticated' => false, 'user' => null]);
		}
	}

	// --- Endpoints de Esquemas y Configuración ---
	// ¡REFACTORIZADO!
	switch ($endpoint) {
		case 'schema_versions':
			$versionsData = $db->query("SELECT table_name, fecha_modificacion AS last_updated FROM app_schema");
			$versionsMap = array_reduce($versionsData, fn($c, $i) => $c + [$i['table_name'] => $i['last_updated']], []);
			json_response(200, $versionsMap);

		case 'schemas/hydrated': // ¡NUEVO ENDPOINT PRINCIPAL!
			$rolId = $_SESSION['user_rol_id'] ?? 1000; // Rol Visitante por defecto
			$schemaBuilder = new SchemaBuilder($db, $rolId);
			$hydratedSchemas = $schemaBuilder->buildAllHydratedSchemas();

			// Además, añadimos las versiones para que el frontend tenga todo en una llamada
			$versionsData = $db->query("SELECT table_name, fecha_modificacion AS last_updated FROM app_schema");
			$versionsMap = array_reduce($versionsData, fn($c, $i) => $c + [$i['table_name'] => $i['last_updated']], []);

			json_response(200, [
				'schemas' => $hydratedSchemas,
				'versions' => $versionsMap
			]);

		case 'navigation':
			$rolId = $_SESSION['user_rol_id'] ?? 1000;
			$ruleData = $db->query("SELECT regla_json FROM permisos WHERE rol_id = ? AND tabla_afectada = 'navigation' AND tipo_regla = 'action' AND is_active = 1", [$rolId]);
			$allowedPages = [];
			if (!empty($ruleData)) {
				$rule = json_decode($ruleData[0]['regla_json'], true);
				$allowedPages = $rule['allow'] ?? [];
			}
// EN: /public/api.php, dentro del `case 'navigation'`

// Definimos todos los posibles elementos del menú de la aplicación
			$allItems = [
				// Sección Pública
				['key' => 'inicio', 'label' => 'Inicio', 'href' => '#/inicio', 'section' => 'public'],
				['key' => 'contactos', 'label' => 'Contactos', 'href' => '#/contactos', 'section' => 'public'],

				// Sección de Aplicación (App)
				['key' => 'clientes', 'label' => 'Clientes', 'href' => '#/app/clientes', 'section' => 'app'],
				['key' => 'proyectos', 'label' => 'Proyectos', 'href' => '#/app/proyectos', 'section' => 'app'],
				['key' => 'cotizaciones', 'label' => 'Cotizaciones', 'href' => '#/app/cotizaciones', 'section' => 'app'],
				['key' => 'ordenes_trabajo', 'label' => 'Órdenes de T.', 'href' => '#/app/ordenes_trabajo', 'section' => 'app'],
				['key' => 'medidas_produccion', 'label' => 'Medidas Prod.', 'href' => '#/app/medidas_produccion', 'section' => 'app'],
				['key' => 'materiales', 'label' => 'Materiales', 'href' => '#/app/materiales', 'section' => 'app'],
				['key' => 'familias', 'label' => 'Familias', 'href' => '#/app/familias', 'section' => 'app'],
				['key' => 'tipologias', 'label' => 'Tipologías', 'href' => '#/app/tipologias', 'section' => 'app'],
				['key' => 'recetas_despiece', 'label' => 'Recetas', 'href' => '#/app/recetas_despiece', 'section' => 'app'],
				['key' => 'proveedores', 'label' => 'Proveedores', 'href' => '#/app/proveedores', 'section' => 'app'],
				['key' => 'unidades', 'label' => 'Unidades', 'href' => '#/app/unidades', 'section' => 'app'],
				['key' => 'usuarios', 'label' => 'Usuarios', 'href' => '#/app/usuarios', 'section' => 'app'],
				['key' => 'roles', 'label' => 'Roles', 'href' => '#/app/roles', 'section' => 'app'],
				['key' => 'perfil', 'label' => 'Mi Perfil', 'href' => '#/app/perfil', 'section' => 'app'],

				// Sección de Sistema (System)
				['key' => 'permisos', 'label' => 'Permisos', 'href' => '#/system/permisos', 'section' => 'system'],
				['key' => 'historial_cambios', 'label' => 'Historial', 'href' => '#/system/historial_cambios', 'section' => 'system'],
				['key' => 'app_schema', 'label' => 'Esquemas', 'href' => '#/system/app_schema', 'section' => 'system'],
			];
			$finalMenu = array_filter($allItems, fn($item) => in_array($item['key'], $allowedPages));
			json_response(200, array_values($finalMenu));
	}

	// --- Barrera de Seguridad ---
	if (!isset($_SESSION['user_id'])) {
		json_response(403, ['error' => 'Acceso denegado. Se requiere autenticación.']);
	}

	// --- Endpoints Protegidos ---
	if ($endpoint === 'logout') {
		session_unset(); session_destroy();
		json_response(200, ['message' => 'Sesión cerrada.']);
	}

	$crudHandler = new CrudHandler($db, (int)$_SESSION['user_id'], (int)$_SESSION['user_rol_id']);
	$id = isset($_GET['id']) ? (int)$_GET['id'] : null;
	$inputData = ($method === 'POST' || $method === 'PUT') ? json_decode(file_get_contents('php://input'), true) : [];
	if (is_null($inputData) && ($method === 'POST' || $method === 'PUT')) { json_response(400, ['error' => 'Cuerpo de la petición JSON inválido.']); }

	$allowedTables = [ 'clientes', 'config_cotizacion', 'cotizaciones', 'cotizacion_detalle', 'familias', 'familia_tipos', 'historial_cambios', 'materiales', 'medidas_produccion', 'ordenes_trabajo', 'perfiles_usuario', 'permisos', 'productos_proveedor', 'proveedores', 'proyectos', 'recetas_despiece', 'roles', 'tipologias', 'ubicaciones', 'unidades', 'usuarios', 'vanos' ];

	if (in_array($endpoint, $allowedTables)) {
		switch ($method) {
			case 'GET':
				if ($id) $crudHandler->handleGetSingle($endpoint, $id);
				else $crudHandler->handleGetList($endpoint);
				break;
			case 'POST':
				$crudHandler->handleCreate($endpoint, $inputData);
				break;
			case 'PUT':
				$id = $inputData['id'] ?? $id;
				if ($id) $crudHandler->handleUpdate($endpoint, (int)$id, $inputData);
				else json_response(400, ['error' => 'Se requiere un ID para actualizar.']);
				break;
			case 'DELETE':
				if ($id) $crudHandler->handleDelete($endpoint, $id);
				else json_response(400, ['error' => 'Se requiere un ID para eliminar.']);
				break;
			default:
				json_response(405, ['error' => "Método {$method} no permitido."]);
		}
	} else {
		json_response(404, ['error' => "Endpoint '{$endpoint}' no encontrado."]);
	}

} catch (Exception $e) {
	json_response(500, ['error' => 'Error interno del servidor.', 'details' => $e->getMessage()]);
}
ob_end_flush();