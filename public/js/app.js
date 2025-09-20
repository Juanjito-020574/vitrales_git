// public/js/app.js (indentación con TABS)

import { apiClient } from './api/client.js';
import { renderer } from './ui/renderer.js';
import { modal } from './ui/modal.js';

// Objeto global para almacenar el estado de la aplicación.
const AppState = {
	config: null, // Almacenará la configuración completa (menú, tablas, sesión)
	currentView: {
		tableName: null,
		data: [],
	},
};

/**
 * Punto de entrada principal. Se ejecuta una vez que el DOM está cargado.
 */
async function main() {
	console.log('Inicializando la aplicación...');

	try {
		// --- CAMBIO --- El flujo ahora es secuencial y robusto.

		// 1. Intentamos cargar la configuración desde el caché para una carga inicial rápida.
		const cachedConfig = localStorage.getItem('app_config');
		if (cachedConfig) {
			try { AppState.config = JSON.parse(cachedConfig); } catch (e) { localStorage.removeItem('app_config'); }
		}

		// 2. Verificamos el estado de la sesión REAL con el servidor.
		const sessionStatus = await apiClient.checkStatus();

		// 3. Basado en el estado, decidimos si necesitamos cargar la configuración completa.
		if (sessionStatus.loggedIn) {
			// Si el usuario está logueado, nos aseguramos de tener la configuración más fresca.
			await loadAppConfig();
		} else {
			// Si no está logueado, nos aseguramos de que no haya datos de sesión antiguos.
			AppState.config = null;
			localStorage.removeItem('app_config');
		}

		// 4. AHORA, y solo ahora que estamos seguros de tener los datos (o no tenerlos),
		//    construimos la interfaz y el router.
		setupUI();
		setupRouter();
		handleRouteChange(); // Renderizar la ruta actual.

	} catch (error) {
		console.error("Error crítico de inicialización:", error);
		// El renderer ahora mostrará el mensaje de error que ves en la pantalla.
		renderer.renderError("No se pudo conectar con el servidor.");
	}
}

/**
 * Carga la configuración de la aplicación desde el servidor y la guarda.
 */
async function loadAppConfig() {
	try {
		const appConfig = await apiClient.getAppConfig();
		AppState.config = appConfig;
		localStorage.setItem('app_config', JSON.stringify(appConfig));
		console.log("Configuración fresca del servidor cargada y guardada.");
	} catch (error) {
		console.error("No se pudo sincronizar la configuración:", error);
		// En este caso, la app podría seguir funcionando con la versión en caché.
	}
}

/**
 * Configura los elementos estáticos de la UI y los manejadores de eventos.
 */
function setupUI() {
	document.body.addEventListener('click', handleAppClick);
	renderer.renderUserNav(AppState.config?.session); // Renderiza el menú de usuario.
	renderer.renderNavigation(AppState.config); // Renderiza el menú principal.
}

function setupRouter() {
	window.addEventListener('hashchange', handleRouteChange);
}

/**
 * Maneja el cambio de ruta (navegación).
 */
async function handleRouteChange() {
	const hash = window.location.hash.slice(1) || '/app/inicio';
	const pathParts = hash.split('/');
	const view = pathParts[2] || 'inicio';

	// --- LÓGICA DE RUTAS PÚBLICAS Y PROTEGIDAS ---

	// 1. Definimos qué vistas son públicas.
	const publicViews = ['inicio', 'contactos', 'login'];
	const isViewPublic = publicViews.includes(view);

	// 2. Comprobamos si el usuario está intentando acceder a una ruta protegida sin haber iniciado sesión.
	if (!AppState.config?.session?.userId && !isViewPublic) {
		console.log(`Acceso denegado a la ruta protegida '/${view}'. Redirigiendo a login.`);
		// Si es así, lo enviamos al login.
		window.location.hash = '/app/login';
		return;
	}

	// 3. Si llegamos aquí, el usuario tiene permiso para ver la página solicitada. Procedemos a renderizar.
	switch(view) {
		case 'login':
			// Si ya está logueado y va a 'login', lo mandamos al inicio para que no vea el formulario.
			if (AppState.config?.session?.userId) {
				window.location.hash = '/app/inicio';
				return;
			}
			renderer.renderLogin();
			break;
		case 'inicio':
			const welcomeTitle = AppState.config?.session?.userNick ? `¡Bienvenido, ${AppState.config.session.userNick}!` : 'Bienvenido a Vitrales v2';
			renderer.renderDashboard(welcomeTitle, 'Este es el panel principal.');
			break;
		case 'contactos':
			renderer.renderDashboard('Información de Contacto', 'Aquí irá la info de contacto.');
			break;
		default:
			// Si la vista no es pública, es una tabla.
			const tableName = view;
			const tableSchema = AppState.config?.tables?.[tableName];

			if (tableSchema) {
				AppState.currentView.tableName = tableName;
				try {
					const data = await apiClient.getData(tableName);

					console.log(`Datos recibidos para la tabla '${tableName}':`, data);

					AppState.currentView.data = data;
					renderer.renderTable(tableSchema, data);
				} catch(error) {
					renderer.renderError(`No se pudieron cargar los datos para ${tableName}.`);
				}
			} else {
				// Si la tabla no existe en el esquema, es una ruta no válida.
				renderer.renderError(`La sección "${tableName}" no es válida.`);
			}
			break;
	}
}

/**
 * Manejador de eventos global para todas las acciones de la aplicación.
 */
async function handleAppClick(event) {
	const actionElement = event.target.closest('[data-action]');
	if (!actionElement) return;

	const action = actionElement.dataset.action;
	const id = actionElement.dataset.id;
	const tableName = AppState.currentView.tableName;
	const tableSchema = AppState.config?.tables?.[tableName];

	switch (action) {
		// --- ¡ESTE ES EL BLOQUE QUE FALTABA! ---
		case 'show-login':
			window.location.hash = '/app/login';
			break;
		// -----------------------------------------
		case 'logout':
			await apiClient.logout();
			localStorage.removeItem('app_config');
			window.location.reload();
			break;
		case 'submit-login':
			event.preventDefault();
			const form = document.getElementById('login-form');
			const errorContainer = document.getElementById('login-error');
			try {
				const credentials = {
					nick: form.elements['nick'].value,
					password: form.elements['password'].value
				};
				await apiClient.login(credentials);
				window.location.reload(); // Recargamos para que se inicialice todo.
			} catch (error) {
				errorContainer.textContent = error.message || 'Credenciales incorrectas.';
				errorContainer.classList.remove('is-hidden');
			}
			break;
		case 'open-create-form':
			if (tableSchema) {
				// 1. Definimos la función que se ejecutará al guardar.
				const createSubmitCallback = async (formData) => {
					try {
						const newRecord = await apiClient.createRecord(tableName, formData);
						console.log('Registro creado con éxito:', newRecord);
						modal.close();
						handleRouteChange(); // Recargar la tabla para ver el nuevo registro.
					} catch (error) {
						alert(`Error al crear el registro: ${error.message}`);
					}
				};
				// 2. Abrimos el modal, pasándole la función.
				modal.openForm(tableSchema, null, createSubmitCallback);
			}
			break;
		case 'open-edit-form':
			if (tableSchema && id) {
				const recordData = AppState.currentView.data.find(item => item.id == id);

				// 1. Definimos la función para la edición.
				const editSubmitCallback = async (formData) => {
					try {
						await apiClient.updateRecord(tableName, id, formData);
						console.log('Registro actualizado con éxito');
						modal.close();
						handleRouteChange(); // Recargar la tabla.
					} catch (error) {
						alert(`Error al actualizar el registro: ${error.message}`);
					}
				};
				// 2. Abrimos el modal con los datos y la función.
				modal.openForm(tableSchema, recordData, editSubmitCallback);
			}
			break;
		case 'trigger-delete':
			if (tableName && id && confirm('¿Está seguro?')) {
				try {
					await apiClient.deleteRecord(tableName, id);
					handleRouteChange(); // Recargar la vista de la tabla.
				} catch (err) {
					alert(`Error al eliminar: ${err.message}`);
				}
			}
			break;
	}
}

// Iniciar la aplicación.
document.addEventListener('DOMContentLoaded', main);