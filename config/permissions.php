<?php
// /config/permissions.php

return [
	'app_schema' => [
		'visibility_rules' => [
			200 => ['type' => 'deny_all'],
			300 => ['type' => 'deny_all'],
			400 => ['type' => 'deny_all'],
			500 => ['type' => 'deny_all'],
			600 => ['type' => 'deny_all'],
			1000 => ['type' => 'deny_all'],
		]
	],

	'config_cotizacion' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				// Esta función construye y devuelve la condición SQL para el WHERE.
				// Es mucho más legible y mantenible que un JSON anidado.
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id IN ({$subqueryClientes})";
				$subqueryCotizaciones = "SELECT id FROM cotizaciones WHERE proyecto_id IN ({$subqueryProyectos})";

				return "cotizacion_id IN ({$subqueryCotizaciones})";
			}
		]
	],

	'cotizaciones' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id IN ({$subqueryClientes})";

				return "proyecto_id IN ({$subqueryProyectos})";
			}
		]
	],

	'cotizacion_detalle' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id IN ({$subqueryClientes})";
				$subqueryCotizaciones = "SELECT id FROM cotizaciones WHERE proyecto_id IN ({$subqueryProyectos})";

				return "cotizacion_id IN ({$subqueryCotizaciones})";
			},

			// ¡NUEVO! Regla para el Cliente (rol 600)
			600 => function($userId, $db) {
				// Primero, necesitamos encontrar el ID del cliente asociado a este usuario.
				// Esto asume una relación en la tabla 'clientes' o 'usuarios'.
				// Por ahora, asumiremos que el `usuario_id` del cliente está en una columna `usuario_id` en la tabla `clientes`.
				$clienteData = $db->query("SELECT id FROM clientes WHERE usuario_id = ?", [$userId]);
				if (empty($clienteData)) {
					return "1 = 0"; // Si no se encuentra un cliente, no puede ver nada.
				}
				$clientId = $clienteData[0]['id'];

				// Ahora construimos la consulta de visibilidad
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id = {$clientId}";
				$subqueryCotizaciones = "SELECT id FROM cotizaciones WHERE proyecto_id IN ({$subqueryProyectos})";

				return "cotizacion_id IN ({$subqueryCotizaciones})";
			}
			// La nueva regla para el rol 600 asume que hay una forma de vincular un usuario_id a un cliente_id.
			// He supuesto una columna usuario_id en la tabla clientes. Si la relación es diferente, necesitaríamos ajustar esa primera
			// consulta. Este es un ejemplo perfecto de una lógica demasiado compleja para JSON, que encaja perfectamente en permissions.php.
		]
	],

	// --- REGLAS PARA ORDENES_TRABAJO ---
	'ordenes_trabajo' => [
		'visibility_rules' => [
			// Regla para el Cliente (rol 600)
			600 => function($userId, $db) {
				// Buscar el cliente_id asociado a este usuario_id
				$clienteData = $db->query("SELECT id FROM clientes WHERE usuario_id = ?", [$userId]);
				if (empty($clienteData)) {
					return "1 = 0"; // No puede ver nada si no es un cliente.
				}
				$clientId = $clienteData[0]['id'];

				// Condición SQL: La OT debe pertenecer a una cotización, que a su vez pertenece a un proyecto de este cliente.
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id = {$clientId}";
				$subqueryCotizaciones = "SELECT id FROM cotizaciones WHERE proyecto_id IN ({$subqueryProyectos})";

				return "cotizacion_aprobada_id IN ({$subqueryCotizaciones})";
			}
		]
	],

	// --- REGLAS PARA PERMISOS ---
	// Estas reglas son críticas para la seguridad y están "grabadas en piedra" aquí.
	'permisos' => [
		'visibility_rules' => [
			// Denegar acceso a todos los roles por debajo de SuperAdmin (ID 100).
			// La ausencia de una regla para el rol 100 le concede acceso total.
			200 => ['type' => 'deny_all'],
			300 => ['type' => 'deny_all'],
			400 => ['type' => 'deny_all'],
			500 => ['type' => 'deny_all'],
			600 => ['type' => 'deny_all'],
			1000 => ['type' => 'deny_all'],
		]
	],

	// --- REGLAS PARA PROYECTOS ---
	'proyectos' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				return "cliente_id IN ({$subqueryClientes})";
			}
		]
	],

	// --- REGLAS PARA ROLES ---
	// Reglas críticas "grabadas en piedra" para la gestión de roles.
	'roles' => [
		'visibility_rules' => [
			// Denegar acceso a todos los roles por debajo de SuperAdmin (ID 100).
			// La ausencia de una regla para el rol 100 le concede acceso total.
			200 => ['type' => 'deny_all'],
			300 => ['type' => 'deny_all'],
			400 => ['type' => 'deny_all'],
			500 => ['type' => 'deny_all'],
			600 => ['type' => 'deny_all'],
			1000 => ['type' => 'deny_all'],
		]
	],

	// --- REGLAS PARA UBICACIONES ---
	'ubicaciones' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id IN ({$subqueryClientes})";
				return "proyecto_id IN ({$subqueryProyectos})";
			},

			// Regla para el Cliente (rol 600)
			600 => function($userId, $db) {
				$clienteData = $db->query("SELECT id FROM clientes WHERE usuario_id = ?", [$userId]);
				if (empty($clienteData)) { return "1 = 0"; }
				$clientId = $clienteData[0]['id'];
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id = {$clientId}";
				return "proyecto_id IN ({$subqueryProyectos})";
			}
		]
	],

	// --- REGLAS PARA VANOS ---
	'vanos' => [
		'visibility_rules' => [
			// Regla para el Cotizador (rol 400)
			400 => function($userId, $db) {
				$subqueryClientes = "SELECT id FROM clientes WHERE cotizador_asignado_id = {$userId}";
				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id IN ({$subqueryClientes})";
				$subqueryUbicaciones = "SELECT id FROM ubicaciones WHERE proyecto_id IN ({$subqueryProyectos})";
				return "ubicacion_id IN ({$subqueryUbicaciones})";
			},

			// Regla para el Cliente (rol 600)
			600 => function($userId, $db) {
				$clienteData = $db->query("SELECT id FROM clientes WHERE usuario_id = ?", [$userId]);
				if (empty($clienteData)) { return "1 = 0"; }
				$clientId = $clienteData[0]['id'];

				$subqueryProyectos = "SELECT id FROM proyectos WHERE cliente_id = {$clientId}";
				$subqueryUbicaciones = "SELECT id FROM ubicaciones WHERE proyecto_id IN ({$subqueryProyectos})";
				return "ubicacion_id IN ({$subqueryUbicaciones})";
			}
		]
	],

];