// /public/js/app.js (Versión Final Completa y Refactorizada)

import { apiFetch, syncSchemas, getSchema, createRecord, updateRecord, deleteRecord, getRecordById } from './api/client.js';
import { closeModal, renderForm } from './ui/modal.js';
import { renderNavigation, renderInicioView, renderContactosView, renderLoginView, renderDynamicView, updateActiveLink, renderPerfilView } from './ui/renderer.js';

export const state = {
	currentUser: null,
	allSchemas: null,
	currentSchema: null,
	menuItems: [] // Guardará los elementos del menú para el usuario actual
};

export async function handleLogin(event) {
	event.preventDefault();
	const form = event.target;
	try {
		await apiFetch('login', {}, { body: JSON.stringify({ nick: form.nick.value, password: form.password.value }) });
		// Forzamos una recarga completa. El router se encargará de llevar al usuario a la página correcta.
		// Esto limpia cualquier estado/caché anterior y asegura que se carguen los permisos y esquemas correctos para el nuevo rol.
		window.location.href = '/#/app/clientes';
		window.location.reload();
	} catch (error) {
		const errorElement = document.getElementById('login-error');
		if (errorElement) {
			errorElement.textContent = error.message;
			errorElement.style.display = 'block';
		}
	}
}

async function handleLogout() {
	try {
		// ¡CAMBIO CLAVE! Esperamos a que la petición termine.
		await apiFetch('logout', {}, { method: 'POST' });
	} catch (error) {
		console.error("Error al cerrar sesión en el servidor", err);
	}

	state.currentUser = null;
	localStorage.removeItem('hydratedSchemas');
	sessionStorage.removeItem('schemaVersions');

	// Ahora que la sesión del servidor está cerrada, redirigimos.
	window.location.href = '/';
}

export async function handleFormSubmit(event) {
	event.preventDefault();
	const form = event.target;
	const formData = new FormData(form);
	const data = Object.fromEntries(formData.entries());

	const tableName = form.dataset.tableName;
	const mode = form.dataset.mode;
	const recordId = form.dataset.id;

	if (!tableName) {
		alert("Error crítico: No se pudo determinar la tabla.");
		return;
	}

	const schema = getSchema(tableName);
	// Corregir valores de checkbox que no se envían si están desmarcados
	for (const key in schema.columns) {
		const col = schema.columns[key];
		if (col.inputType === 'checkbox') {
			data[key] = formData.has(key) ? '1' : '0';
		}
		// Aplicar valores por defecto desde el esquema (enviado por el backend)
		if (mode === 'create' && col.defaultValueOnCreate) {
			if (col.defaultValueOnCreate === '{userId}') {
				data[key] = state.currentUser.id;
			} else {
				data[key] = col.defaultValueOnCreate;
			}
		}
	}

	try {
		if (mode === 'create') {
			await createRecord(tableName, data);
		} else {
			await updateRecord(tableName, recordId, data);
		}
		closeModal();
		await renderDynamicView(tableName);
	} catch (error) {
		console.error(`Error al guardar en ${tableName}:`, error);
		alert(`Error al guardar: ${error.message}`);
	}
}

async function handleAppClick(event) {
	const button = event.target.closest('[data-action]');
	if (button) {
		event.preventDefault();
		const action = button.dataset.action;
		const id = button.dataset.id;

		// Ahora podemos confiar en el estado global
		if (!state.currentSchema && !['logout'].includes(action)) return;

		switch (action) {
			case 'openCreateForm':
				// La lógica es simple: si hay un esquema actual, crea un formulario para él.
				await renderForm(state.currentSchema);
				break;
			case 'openEditForm':
				if (id) {
					const recordData = await getRecordById(state.currentSchema.tableName, id);
					await renderForm(state.currentSchema, recordData);
				}
				break;
			case 'triggerDelete':
				if (id) {
					if (confirm(`¿Estás seguro...?`)) {
						await deleteRecord(state.currentSchema.tableName, id);
						await renderDynamicView(state.currentSchema.tableName);
					}
				}
				break;
		}
	}
	if (event.target.id === 'modal-close-btn') closeModal();
	if (event.target.id === 'logout-button') await handleLogout();
}

function router() {
	const route = window.location.hash.substring(1) || '/';
	document.getElementById('app-container').innerHTML = '';
	closeModal();

	state.currentSchema = null;

	// Registrar punto de entrada al historial
	if ((route.startsWith('/app/') || route.startsWith('/system/')) && sessionStorage.getItem('appEntryLength') === null) {
		sessionStorage.setItem('appEntryLength', history.length);
	}
	if (!route.startsWith('/app/') && !route.startsWith('/system/')) {
		sessionStorage.removeItem('appEntryLength');
	}

	// Rutas de la Aplicación
	if (route.startsWith('/app/')) {
		if (state.currentUser && state.currentUser.rol_id < 1000) {
			const resource = route.split('/')[2] || 'dashboard';
			if (resource === 'dashboard') {
				document.getElementById('app-container').innerHTML = '<h2>Dashboard</h2>'; // Placeholder para la página de inicio de la app
			} else if (resource === 'perfil') {
				renderPerfilView();
			} else {
				renderDynamicView(resource);
			}
		} else {
			location.replace('#/login');
		}
		return;
	}

	// Rutas del Sistema
	if (route.startsWith('/system/')) {
		if (state.currentUser && state.currentUser.rol_id <= 100) {
			const resource = route.split('/')[2];
			document.getElementById('app-container').innerHTML = `<h2>Sección de Sistema: ${resource}</h2>`;
		} else {
			document.getElementById('app-container').innerHTML = '<h2>Error 403: Acceso Denegado</h2>';
		}
		return;
	}

	// Rutas Públicas
	switch (route) {
		case '/': case '/inicio': renderInicioView(); break;
		case '/contactos': renderContactosView(); break;
		case '/login':
			if (state.currentUser) {
				history.replaceState(null, '', '#/app/clientes');
				router();
			} else {
				renderLoginView(handleLogin);
			}
			break;
		default:
			document.getElementById('app-container').innerHTML = '<h2>Error 404</h2><p>Página no encontrada.</p>';
			break;
	}
	updateActiveLink(route);
}

// REEMPLAZA la función initializeApp
async function initializeApp() {
	document.getElementById('app-container').innerHTML = '<div class="loader"></div>';
	try {
		// PASO 1: Primero y ante todo, restaurar la sesión.
		// Esto es CRÍTICO para que las siguientes peticiones usen el rol correcto.
		const sessionData = await apiFetch('session-status');
		if (sessionData.authenticated) {
			state.currentUser = sessionData.user;
		} else {
			state.currentUser = null;
		}

		// PASO 2: Ahora que sabemos quién es el usuario, pedimos esquemas y menú en paralelo.
		// `syncSchemas` y `apiFetch('navigation')` usarán la sesión que acabamos de establecer.
		const [_, menuData] = await Promise.all([
			syncSchemas(),
			apiFetch('navigation')
		]);
		state.menuItems = menuData;

		// PASO 3: Renderizar y activar la aplicación.
		renderNavigation();
		window.addEventListener('hashchange', router);
		document.body.addEventListener('click', handleAppClick);
		router();

	} catch (error) {
		console.error("Error fatal durante la inicialización:", error);
		state.currentUser = null;
		state.menuItems = []; // Asegurarse de limpiar el menú en caso de error
		renderNavigation();
		location.replace('#/login'); // Forzar al login si la inicialización falla
		router();
	}
}

window.addEventListener('pageshow', function(event) {
	if (event.persisted) {
		window.location.reload();
	}
});

initializeApp();