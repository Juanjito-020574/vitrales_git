// Indentación con TABS
// public/js/app.js

import { apiClient } from './api/client.js';
import { renderer } from './ui/renderer.js';
import { modal } from './ui/modal.js';

const state = {
	session: {
		isLoggedIn: false,
		user: null,
	},
	schema: null,
	currentView: {
		tableName: null,
		data: [],
	},
};

async function init() {
	console.log('Inicializando la aplicación...');
	document.body.addEventListener('click', handleAppClick);

	const cachedSchema = localStorage.getItem('application_schema');
	if (cachedSchema) {
		state.schema = JSON.parse(cachedSchema);
	}

	try {
		const sessionStatus = await apiClient.checkStatus();
		state.session.isLoggedIn = sessionStatus.loggedIn;
		state.session.user = sessionStatus.user;

		// 1. Renderizar SIEMPRE la cáscara de la UI (botones y menús)
		renderer.renderUserNav(state.session);
		renderer.renderNavigation(state.schema, state.session);

		// 2. Si el usuario está logueado, sincronizamos en segundo plano
		if (state.session.isLoggedIn) {
			// Usamos .then() para no bloquear la carga inicial de la vista
			syncApplication().catch(err => console.error("Sincronización en segundo plano falló:", err));
		}

		// 3. Configurar el router y cargar la vista inicial
		setupRouter();

		// CORREGIDO: La lógica de la ruta por defecto ahora es más simple
		if (!window.location.hash || window.location.hash === '#') {
			// Si no hay ruta, SIEMPRE vamos a 'inicio'
			window.location.hash = '/app/inicio';
		} else {
			// Si ya hay una ruta, la renderizamos
			handleRouteChange();
		}

	} catch (error) {
		console.error("Error crítico de inicialización:", error);
		renderer.renderError("No se pudo conectar con el servidor.");
	}
}

async function syncApplication() {
	try {
		const appSchema = await apiClient.syncApplicationSchema();
		state.schema = appSchema;
		localStorage.setItem('application_schema', JSON.stringify(appSchema));
		// Volvemos a renderizar la navegación para añadir los menús dinámicos
		renderer.renderNavigation(state.schema, state.session);
	} catch (error) {
		console.error("No se pudo sincronizar el esquema:", error);
		// No mostramos un error en la UI, ya que es un proceso de fondo
	}
}

function setupRouter() {
	window.addEventListener('hashchange', handleRouteChange);
}

async function handleRouteChange() {
	const hash = window.location.hash.slice(1);
	const path = hash.split('/')[2];

	switch(path) {
		case 'login':
			renderer.renderLogin(); // Esto ahora llama a renderView internamente
			break;
		case 'inicio':
			const welcomeTitle = state.session.isLoggedIn ? `¡Bienvenido, ${state.session.user.nick}!` : '¡Bienvenido a Vitrales v2!';
			renderer.renderDashboard(welcomeTitle, 'Este es el panel principal.');
			break;
		case 'contactos':
			renderer.renderDashboard('Información de Contacto', 'Aquí irá la información de contacto de la empresa.');
			break;
		default:
			const tableName = path;
			if (!state.session.isLoggedIn) {
				window.location.hash = '#/app/login';
				return;
			}

			if (state.schema && state.schema[tableName]) {
				const tableSchema = state.schema[tableName];
				state.currentView.tableName = tableName;
				try {
					const data = await apiClient.getData(tableName);
					state.currentView.data = data;
					// Llamada simplificada
					renderer.renderTable(tableSchema, data);
				} catch(error) {
					renderer.renderError(`No se pudieron cargar los datos para ${tableName}.`);
				}
			} else {
				renderer.renderError(`La sección "${tableName}" no es válida o aún no ha sido cargada.`);
			}
			break;
	}
}

async function handleAppClick(event) {
	const action = event.target.closest('[data-action]')?.dataset.action;
	if (!action) return;

	const id = event.target.closest('[data-id]')?.dataset.id;
	const tableName = state.currentView.tableName;
	const tableSchema = state.schema ? state.schema[tableName] : null;

	switch (action) {
		case 'show-login':
			window.location.hash = '#/app/login';
			break;
		case 'logout':
			await apiClient.logout();
			window.location.reload();
			break;
		case 'submit-login':
			event.preventDefault();
			const form = document.getElementById('login-form');
			const errorContainer = document.getElementById('login-error');
			const nick = form.elements['nick'].value;
			const password = form.elements['password'].value;
			if (!nick || !password) {
				errorContainer.textContent = 'Por favor, ingrese usuario y contraseña.';
				errorContainer.classList.remove('is-hidden');
				return;
			}
			try {
				await apiClient.login({ nick, password });
				window.location.reload();
			} catch (error) {
				errorContainer.textContent = 'Credenciales incorrectas. Por favor, intente de nuevo.';
				errorContainer.classList.remove('is-hidden');
			}
			break;
		case 'open-create-form':
			if (tableSchema) {
				modal.openForm(tableSchema, null);
			}
			break;
		case 'open-edit-form':
			if (tableSchema && id) {
				const recordData = state.currentView.data.find(item => item.id == id);
				modal.openForm(tableSchema, recordData);
			}
			break;
		case 'trigger-delete':
			if (tableName && id) {
				if (confirm('¿Está seguro de que desea eliminar este registro?')) {
					apiClient.deleteRecord(tableName, id)
						.then(() => handleRouteChange())
						.catch(err => alert(`Error al eliminar: ${err.message}`));
				}
			}
			break;
	}
}

document.addEventListener('DOMContentLoaded', init);