// Indentación con TABS
// public/js/api/client.js

const API_BASE_URL = 'api.php'; // URL base de nuestra API

/**
 * Función central para realizar todas las peticiones a la API.
 * Maneja la configuración de fetch, el cuerpo de la petición y los errores comunes.
 * @param {string} action - El endpoint de la API a llamar.
 * @param {object} params - Parámetros para la URL (ej. { table: 'clientes' }).
 * @param {string} method - Método HTTP (GET, POST, PUT, DELETE).
 * @param {object|null} body - El cuerpo de la petición para POST o PUT.
 * @returns {Promise<any>} - La respuesta de la API en formato JSON.
 */
async function performRequest(action, params = {}, method = 'GET', body = null) {
	const url = new URL(API_BASE_URL, window.location.origin);
	url.searchParams.set('action', action);
	for (const key in params) {
		url.searchParams.set(key, params[key]);
	}

	const options = {
		method: method,
		headers: {
			'Content-Type': 'application/json',
			'Accept': 'application/json',
		},
	};

	if (body) {
		options.body = JSON.stringify(body);
	}

	try {
		const response = await fetch(url, options);

		if (!response.ok) {
			const errorData = await response.json().catch(() => ({ error: 'Error de red o respuesta no válida.' }));
			throw new Error(errorData.error || `Error ${response.status}: ${response.statusText}`);
		}

		return await response.json();

	} catch (error) {
		console.error(`Error en la llamada a la API [${action}]:`, error);
		// Relanzamos el error para que el llamador pueda manejarlo.
		throw error;
	}
}

// Objeto que exporta todos los métodos de la API para ser usados en la aplicación.
export const apiClient = {

	// --- MÉTODOS DE ESQUEMA Y NAVEGACIÓN (NUEVA ARQUITECTURA) ---

	/**
	 * Descarga el esquema completo, hidratado y procesado de la aplicación.
	 * Esta es la llamada principal al iniciar la aplicación.
	 */
	syncApplicationSchema: function() {
		return performRequest('get_hydrated_schema');
	},

	// --- MÉTODOS DE SESIÓN ---

	login: function(credentials) {
		return performRequest('login', {}, 'POST', credentials);
	},

	logout: function() {
		return performRequest('logout', {}, 'POST');
	},

	checkStatus: function() {
		return performRequest('status');
	},

	// --- MÉTODOS CRUD (LÓGICA PRESERVADA) ---

	/**
	 * Obtiene todos los registros de una tabla específica.
	 * @param {string} tableName - El nombre de la tabla.
	 */
	getData: function(tableName) {
		return performRequest('get_table_data', { table: tableName });
	},

	/**
	 * Obtiene un único registro por su ID.
	 * @param {string} tableName - El nombre de la tabla.
	 * @param {number} id - El ID del registro.
	 */
	getRecordById: function(tableName, id) {
		return performRequest('get_record_by_id', { table: tableName, id: id });
	},

	/**
	 * Crea un nuevo registro en una tabla.
	 * @param {string} tableName - El nombre de la tabla.
	 * @param {object} data - Los datos del nuevo registro.
	 */
	createRecord: function(tableName, data) {
		return performRequest('create_record', { table: tableName }, 'POST', data);
	},

	/**
	 * Actualiza un registro existente.
	 * @param {string} tableName - El nombre de la tabla.
	 * @param {number} id - El ID del registro a actualizar.
	 * @param {object} data - Los campos a actualizar.
	 */
	updateRecord: function(tableName, id, data) {
		return performRequest('update_record', { table: tableName, id: id }, 'PUT', data); // Usamos PUT para actualizaciones
	},

	/**
	 * Realiza un borrado lógico de un registro.
	 * @param {string} tableName - El nombre de la tabla.
	 * @param {number} id - El ID del registro a eliminar.
	 */
	deleteRecord: function(tableName, id) {
		return performRequest('delete_record', { table: tableName, id: id }, 'DELETE'); // Usamos DELETE para borrados
	},
};