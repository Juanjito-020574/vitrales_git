// /public/js/ui/renderer.js (Versión Final Completa)

import { state } from '../app.js';
import { getSchema, apiFetch } from '../api/client.js';

const appContainer = document.getElementById('app-container');
const navContainer = document.getElementById('main-nav');
const userInfoContainer = document.getElementById('user-info');

export function renderNavigation() {
	let navHTML = '';
	let userInfoHTML = '';

	if (state.menuItems && state.menuItems.length > 0) {
		state.menuItems.forEach(item => {
			navHTML += `<a href="${item.href}">${item.label}</a>`;
		});
	} else {
		navHTML = '<a href="#/inicio">Inicio</a><a href="#/contactos">Contactos</a>';
	}

	if (state.currentUser && state.currentUser.rol_id < 1000) {
		userInfoHTML = `<a href="#/app/perfil" class="button-profile">Mi Perfil</a><span><strong>${state.currentUser.nick}</strong></span><button id="logout-button">Cerrar Sesión</button>`;
	} else {
		userInfoHTML = '<a href="#/login" class="button">Iniciar Sesión</a>';
	}
	navContainer.innerHTML = navHTML;
	userInfoContainer.innerHTML = userInfoHTML;
}

export function updateActiveLink(currentRoute) {
	const navLinks = document.querySelectorAll('#main-nav a');
	let bestMatchLink = null;
	let longestMatchLength = 0;

	navLinks.forEach(link => link.classList.remove('active'));
	const normalizedCurrentRoute = currentRoute.startsWith('/') ? currentRoute : '/' + currentRoute;

	navLinks.forEach(link => {
		let linkRoute = link.hash.substring(1);
		if (!linkRoute.startsWith('/')) { linkRoute = '/' + linkRoute; }
		if (normalizedCurrentRoute.startsWith(linkRoute) && linkRoute.length > longestMatchLength) {
			longestMatchLength = linkRoute.length;
			bestMatchLink = link;
		}
	});
	if (bestMatchLink) { bestMatchLink.classList.add('active'); }
}

export function renderInicioView() { appContainer.innerHTML = '<div class="content-box"><h2>Bienvenido</h2><p>Sistema Vitrales v2.</p></div>'; }
export function renderContactosView() { appContainer.innerHTML = '<div class="content-box"><h2>Contacto</h2></div>'; }

export function renderLoginView(loginHandler) {
	appContainer.innerHTML = `
		<div class="login-box">
			<h2>Iniciar Sesión</h2>
			<form id="login-form">
				<div class="form-group"><label for="nick">Usuario:</label><input type="text" id="nick" name="nick" required></div>
				<div class="form-group"><label for="password">Contraseña:</label><input type="password" id="password" name="password" required></div>
				<div id="login-error" class="error-message" style="display:none;"></div>
				<button type="submit">Acceder</button>
			</form>
		</div>
	`;
	document.getElementById('login-form').addEventListener('submit', loginHandler);
}

export async function renderDynamicView(tableName) {
	appContainer.innerHTML = '<div class="loader"></div>';
	// Pasamos la URL completa al actualizador de links
	updateActiveLink(location.hash.substring(1));

	try {
		state.currentSchema = getSchema(tableName);
		if (!state.currentSchema) {
			throw new Error(`Esquema para la tabla '${tableName}' no encontrado. Posiblemente no tienes permiso para ver esta sección.`);
		}

		const data = await apiFetch(tableName);
		let html = `<div class="content-box" data-table-name="${tableName}">`;

		html += '<div class="table-actions">';
		if (state.currentSchema.actions?.table && state.currentSchema.actions.table.length > 0) {
			state.currentSchema.actions.table.forEach(action => { html += `<button class="action-button" data-action="${action.action}">${action.label}</button>`; });
		}
		html += '</div>';

		html += `<h2>${state.currentSchema.labelPlural || `Lista de ${tableName}`}</h2>`;
		html += '<table class="data-table"><thead><tr>';
		for (const columnKey in state.currentSchema.columns) {
			const colConfig = state.currentSchema.columns[columnKey];
			if (colConfig.visible !== false) {
				html += `<th>${colConfig.title || columnKey}</th>`;
			}
		}
		if (state.currentSchema.actions?.row && state.currentSchema.actions.row.length > 0) {
			html += '<th>Acciones</th>';
		}
		html += '</tr></thead><tbody>';

		if (data.length === 0) {
			const colCount = Object.keys(state.currentSchema.columns).filter(key => state.currentSchema.columns[key].visible !== false).length + (state.currentSchema.actions?.row?.length ? 1 : 0);
			html += `<tr><td colspan="${colCount}">No hay registros.</td></tr>`;
		} else {
			data.forEach(row => {
				html += '<tr>';
				for (const columnKey in state.currentSchema.columns) {
					const colConfig = state.currentSchema.columns[columnKey];
					if (colConfig.visible !== false) {
						const originalValue = row[columnKey] ?? '';
						let displayValue = originalValue;

						if (colConfig.optionsSource?.staticData && originalValue !== '') {
							const option = colConfig.optionsSource.staticData.find(opt => opt.value == originalValue);
							if (option) {
								displayValue = option.label;
							}
						}

						html += `<td data-value="${originalValue}">${displayValue}</td>`;
					}
				}

				if (state.currentSchema.actions?.row && state.currentSchema.actions.row.length > 0) {
					html += '<td>';
					const primaryKey = state.currentSchema.primaryKey || 'id';
					state.currentSchema.actions.row.forEach(action => {
						html += `<button class="action-button-row" data-action="${action.action}" data-id="${row[primaryKey]}">${action.label}</button> `;
					});
					html += '</td>';
				}
				html += '</tr>';
			});
		}
		html += '</tbody></table></div>';
		appContainer.innerHTML = html;
	} catch (error) {
		appContainer.innerHTML = `<p class="error-message">Error al renderizar la vista: ${error.message}</p>`;
	}
}

export async function renderPerfilView() {
	appContainer.innerHTML = '<div class="loader"></div>';
	updateActiveLink('/app/perfil');
	try {
		const [userData, userProfileData, userSchema, profileSchema] = await Promise.all([
			getRecordById('usuarios', state.currentUser.id),
			getRecordById('perfiles_usuario', state.currentUser.id),
			getSchema('usuarios'),
			getSchema('perfiles_usuario')
		]);

		// TODO: Construir dos formularios para editar los datos.
		// Por ahora, solo mostramos la información.
		let html = `
			<div class="content-box">
				<h2>Mi Perfil</h2>
				<p>Aquí podrás editar tu información personal y de cuenta.</p>
				<hr>
				<h3>Datos de Cuenta (Tabla: usuarios)</h3>
				<p><strong>Nick:</strong> ${userData.nick}</p>
				<p><strong>Email:</strong> ${userData.email}</p>
				<hr>
				<h3>Datos Personales (Tabla: perfiles_usuario)</h3>
				<p><strong>Nombres:</strong> ${userProfileData.nombres}</p>
				<p><strong>Apellidos:</strong> ${userProfileData.apellidos}</p>
				<p><strong>Cargo:</strong> ${userProfileData.cargo}</p>
			</div>
		`;
		appContainer.innerHTML = html;
	} catch (error) {
		appContainer.innerHTML = `<p class="error-message">Error al cargar el perfil: ${error.message}</p>`;
	}
}