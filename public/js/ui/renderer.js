// Indentación con TABS
// public/js/ui/renderer.js

// CORREGIDO: Usamos los IDs exactos de tu spa_shell.php
const appContainer = document.getElementById('app-container');
const navigationContainer = document.getElementById('main-nav');
const userNavContainer = document.getElementById('user-info');

export const renderer = {

	/**
	 * Renderiza un título y contenido dentro del contenedor principal.
	 * CORREGIDO: El título ahora es opcional.
	 * @param {string|null} title - El título a mostrar en un <h2>, o null para no mostrarlo.
	 * @param {string} contentHtml - El contenido HTML a renderizar.
	 */
	renderView: function(title, contentHtml) {
		if (!appContainer) return;

		// Si se proporciona un título, se añade el <h2>. Si no, se omite.
		const titleHtml = title ? `<h2 class="title">${title}</h2>` : '';

		appContainer.innerHTML = titleHtml + contentHtml;
	},


	renderUserNav: function(session) {
		if (!userNavContainer) return;

		const isLoggedIn = session?.isLoggedIn;
		const userNick = session?.userNick;

		let userNavHtml = `
			<button class="button" data-action="show-login">
				<strong>Iniciar Sesión</strong>
			</button>
		`;

		if (isLoggedIn) {
			// ESTA ES LA ESTRUCTURA CORRECTA Y DEFINITIVA
			userNavHtml = `
				<div class="navbar-item has-dropdown is-hoverable">
					<a class="navbar-link">
						<span class="icon"><i class="fas fa-user"></i></span>
						<span>${userNick}</span>
					</a>
					<div class="navbar-dropdown is-right">
						<button id="logout-button" data-action="logout">
							Cerrar Sesión
						</button>
					</div>
				</div>
			`;
		}
		userNavContainer.innerHTML = userNavHtml;
	},

	renderNavigation: function(appConfig) {
		if (!navigationContainer) return;

		// 1. Empezamos con los menús estáticos que siempre están visibles.
		let navHtml = `
			<a href="#/app/inicio" class="nav-link">Inicio</a>
			<a href="#/app/contactos" class="nav-link">Contactos</a>
		`;

		// 2. Verificamos si el usuario está logueado Y si la estructura del menú existe.
		//    Usamos "optional chaining" (?.) para máxima seguridad.
		if (appConfig?.session?.isLoggedIn && appConfig?.menu) {

			// 3. Iteramos sobre el array 'menu' que nos ha preparado el backend. ¡YA NO ADIVINAMOS!
			appConfig.menu.forEach(item => {

				// Lógica para renderizar un menú desplegable (submenu).
				if (item.submenu) {
					navHtml += `<div class="nav-item dropdown">`; // Usamos div para nav-items
					navHtml += `  <a href="#" class="nav-link dropdown-toggle">${item.label}</a>`;
					navHtml += `  <div class="dropdown-content">`;
					item.submenu.forEach(subItem => {
						const route = `#/app/${subItem.table}`;
						navHtml += `<a href="${route}" class="dropdown-item">${subItem.label}</a>`;
					});
					navHtml += `  </div>`;
					navHtml += `</div>`;
				}
				// Lógica para renderizar un enlace simple.
				else if (item.table) {
					const label = item.label || item.table;
					const route = `#/app/${item.table}`;
					navHtml += `<a href="${route}" class="nav-link">${label}</a>`;
				}
				// Aquí se podría añadir lógica para otros tipos de item.action si los hubiera.
			});
		}

		navigationContainer.innerHTML = navHtml;
	},

	/**
	- * Muestra el formulario de login.
	- */
	renderLogin: function() {
		const formHtml = `
			<div class="login-box">
				<h2>Iniciar Sesión</h2>
				<form id="login-form">
					<div class="form-group">
						<label for="nick">Usuario:</label>
						<input type="text" id="nick" name="nick" required>
					</div>
					<div class="form-group">
						<label for="password">Contraseña:</label>
						<input type="password" id="password" name="password" required>
					</div>
					<div id="login-error" class="error-message is-hidden" ></div>
					<button class="button" type="submit" data-action="submit-login">Acceder</button>
				</form>
			</div>
		`;
		// Usamos nuestra función central, pero ahora no le pasamos título,
		// ya que el propio HTML del formulario ya lo incluye con <h2>.
		// Para ello, modificamos ligeramente renderView para que el título sea opcional.
		this.renderView(null, formHtml);
	},

	renderTable: function(tableSchema, data) {
		const columns = tableSchema.columns || {};
		const tableTitle = tableSchema.labelPlural || tableSchema.tableName || 'Registros';

		let headerHtml = `
			<div class="table-header">
				<button class="button is-primary" data-action="open-create-form">
					<span>Nuevo</span>
				</button>
			</div>
		`;

		let tableHtml = '<table class="table is-fullwidth is-striped is-hoverable"><thead><tr>';
		for (const columnName in columns) {
			const columnSchema = columns[columnName];
			if (columnSchema.visible !== false) {
				tableHtml += `<th>${columnSchema.title || columnName}</th>`;
			}
		}
		tableHtml += '<th>Acciones</th></tr></thead>';

		tableHtml += '<tbody>';
		if (!data || data.length === 0) {
			const columnCount = Object.values(columns).filter(c => c.visible !== false).length + 1;
			tableHtml += `<tr><td colspan="${columnCount}" class="has-text-centered">No hay datos para mostrar.</td></tr>`;
		} else {
			data.forEach(row => {
				tableHtml += `<tr data-id="${row.id}">`;
				for (const columnName in columns) {
					const columnSchema = columns[columnName];
					if (columnSchema.visible !== false) {
						tableHtml += `<td>${row[columnName] ?? ''}</td>`;
					}
				}

				// --- ¡NUEVA LÓGICA DE BOTONES ROBUSTA! ---
				tableHtml += `<td class="actions-cell">`;
				if (tableSchema.actions && tableSchema.actions.row) {
					tableSchema.actions.row.forEach(action => {
						// Usamos optional chaining (?.) y valores por defecto para evitar errores.
						const actionName = action.action || '';
						const buttonClass = actionName.includes('delete') ? 'is-danger' : 'is-info';
						const iconClass = action.icon || 'fas fa-question-circle';

						if (action.targetRoute) {
							const route = action.targetRoute.replace('{primaryKey}', row.id);
							tableHtml += `
								<a href="${route}" class="button is-small ${buttonClass}" title="${action.label || ''}">
									<span class="icon"><i class="${iconClass}"></i></span>
								</a>
							`;
						} else if (action.action) {
							tableHtml += `
								<button class="button is-small ${buttonClass}" data-action="${actionName}" data-id="${row.id}" title="${action.label || ''}">
									<span class="icon"><i class="${iconClass}"></i></span>
								</button>
							`;
						}
					});
				}
				tableHtml += `</td>`;

				tableHtml += '</tr>';
			});
		}
		tableHtml += '</tbody></table>';

		this.renderView(tableTitle, headerHtml + tableHtml);
	},


	renderDashboard: function(title, subtitle) {
		this.renderView(title, `<p>${subtitle}</p>`);
	},

	renderError: function(message) {
		this.renderView('Error', `<div class="notification is-danger">${message}</div>`);
	},
};