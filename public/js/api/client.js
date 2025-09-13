// /public/js/api/client.js (Refactorizado para usar SchemaBuilder)

import { state } from '../app.js';

export async function apiFetch(endpoint, params = {}, options = {}) {
	const queryString = new URLSearchParams(params).toString();
	const url = `/api.php?endpoint=${endpoint}${queryString ? '&' + queryString : ''}`;

	if (options.body && !options.method) options.method = 'POST';
	if (options.body && !options.headers) options.headers = { 'Content-Type': 'application/json' };

	const response = await fetch(url, options);

	if (response.status === 204) return null; // 204 No Content (para DELETE)

	// Manejar errores de JSON inválido
	const responseText = await response.text();
	let data;
	try {
		data = JSON.parse(responseText);
	} catch (e) {
		console.error("Error al analizar JSON:", responseText);
		throw new Error("La respuesta del servidor no es un JSON válido.");
	}

	if (!response.ok) {
		throw new Error(data.error || `Error ${response.status}`);
	}
	return data;
}

/**
 * ¡REFACTORIZADO!
 * Sincroniza los esquemas de la interfaz usando el nuevo endpoint 'schemas/hydrated'.
 * La lógica de actualización ahora es "todo o nada" para mayor simplicidad y robustez.
 */
export async function syncSchemas() {
	const localVersionsRaw = sessionStorage.getItem('schemaVersions');
	const localSchemasRaw = localStorage.getItem('hydratedSchemas');
	let localVersions = localVersionsRaw ? JSON.parse(localVersionsRaw) : null;

	if (!localVersions || !localSchemasRaw) {
		console.log("Caché de esquemas vacía. Realizando carga completa...");
		const data = await apiFetch('schemas/hydrated');
		localStorage.setItem('hydratedSchemas', JSON.stringify(data.schemas));
		sessionStorage.setItem('schemaVersions', JSON.stringify(data.versions));
		state.allSchemas = data.schemas;
		return;
	}

	console.log("Verificando actualizaciones de esquemas...");
	const serverVersions = await apiFetch('schema_versions');
	let allSchemas = JSON.parse(localSchemasRaw);
	let needsUpdate = false;

	for (const tableName in serverVersions) {
		if (localVersions[tableName] !== serverVersions[tableName]) {
			needsUpdate = true;
			break;
		}
	}
	if (!needsUpdate && Object.keys(localVersions).length !== Object.keys(serverVersions).length) {
		needsUpdate = true;
	}

	if (needsUpdate) {
		console.log("Se detectaron cambios. Actualizando todos los esquemas...");
		const data = await apiFetch('schemas/hydrated');
		localStorage.setItem('hydratedSchemas', JSON.stringify(data.schemas));
		sessionStorage.setItem('schemaVersions', JSON.stringify(data.versions));
		state.allSchemas = data.schemas;
	} else {
		console.log("Caché de esquemas al día.");
		state.allSchemas = allSchemas;
	}
}

/**
 * ¡REFACTORIZADO!
 * Obtiene un esquema ya procesado ("hidratado") de la caché.
 */
export function getSchema(tableName) {
	if (!state.allSchemas) {
		const cached = localStorage.getItem('hydratedSchemas');
		if (cached) {
			state.allSchemas = JSON.parse(cached);
		} else {
			throw new Error("Los esquemas no han sido cargados.");
		}
	}
	return state.allSchemas[tableName];
}


// --- FUNCIONES CRUD AUXILIARES (Mantenidas y Mejoradas) ---

export function getData(tableName) {
	return apiFetch(tableName);
}

export function createRecord(tableName, data) {
	return apiFetch(tableName, {}, {
		method: 'POST',
		body: JSON.stringify(data)
	});
}

export function updateRecord(tableName, recordId, data) {
	return apiFetch(tableName, {}, {
		method: 'PUT',
		body: JSON.stringify({ ...data, id: recordId })
	});
}

export function deleteRecord(tableName, id) {
	return apiFetch(tableName, { id: id }, {
		method: 'DELETE'
	});
}

export function getRecordById(tableName, id) {
	return apiFetch(tableName, { id: id });
}