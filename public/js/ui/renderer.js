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

		let userNavHtml = `
			<button class="button is-primary" data-action="show-login">
				<strong>Iniciar Sesión</strong>
			</button>
		`;
		if (session.isLoggedIn) {
			userNavHtml = `
				<div class="navbar-item has-dropdown is-hoverable">
					<a class="navbar-link">
						<span class="icon"><i class="fas fa-user"></i></span>
						<span>${session.user.nick}</span>
					</a>
					<div class="navbar-dropdown is-right">
						<a class="navbar-item" data-action="logout">
							Cerrar Sesión
						</a>
					</div>
				</div>
			`;
		}
		userNavContainer.innerHTML = userNavHtml;
	},

	renderNavigation: function(appSchema, session) {
		if (!navigationContainer) return;

		let navHtml = `
			<a href="#/app/inicio" class="nav-link">Inicio</a>
			<a href="#/app/contactos" class="nav-link">Contactos</a>
		`;

		if (session.isLoggedIn && appSchema) {
			for (const tableName in appSchema) {
				const tableSchema = appSchema[tableName];
				const tableComment = tableSchema.tableComment || {};

				if (tableComment.archetype === 'ENTIDAD_PRINCIPAL') {
					const label = tableComment.labelPlural || tableName;
					const route = `#/app/${tableName}`;
					navHtml += `<a href="${route}" class="nav-link">${label}</a>`;
				}
			}
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
		const tableComment = tableSchema.tableComment || {};
		const columns = tableSchema.columns || {};

		let headerHtml = `
			<div class="table-header">
				<button class="button is-primary" data-action="open-create-form">
					<span class="icon"><i class="fas fa-plus"></i></span>
					<span>${tableComment.actions?.table[0]?.label || 'Nuevo'}</span>
				</button>
			</div>
		`;

		let tableHtml = '<table class="table is-fullwidth is-striped is-hoverable"><thead><tr>';
		for (const columnName in columns) {
			const columnSchema = columns[columnName];
			if (columnSchema.visible !== false) { tableHtml += `<th>${columnSchema.title || columnName}</th>`; }
		}
		tableHtml += '<th>Acciones</th></tr></thead>';

		tableHtml += '<tbody>';
		if (data.length === 0) {
			const columnCount = Object.keys(columns).filter(c => columns[c].visible !== false).length + 1;
			tableHtml += `<tr><td colspan="${columnCount}" class="has-text-centered">No hay datos para mostrar.</td></tr>`;
		} else {
			data.forEach(row => {
				tableHtml += `<tr data-id="${row.id}">`;
				for (const columnName in columns) {
					const columnSchema = columns[columnName];
					if (columnSchema.visible !== false) { tableHtml += `<td>${row[columnName] ?? ''}</td>`; }
				}
				tableHtml += `
					<td class="actions-cell">
						<button class="button is-small is-info" data-action="open-edit-form" data-id="${row.id}"><span class="icon"><i class="fas fa-edit"></i></span></button>
						<button class="button is-small is-danger" data-action="trigger-delete" data-id="${row.id}"><span class="icon"><i class="fas fa-trash"></i></span></button>
					</td>
				`;
				tableHtml += '</tr>';
			});
		}
		tableHtml += '</tbody></table>';

		const tableTitle = tableComment.labelPlural || tableSchema.tableName;
		this.renderView(tableTitle, headerHtml + tableHtml);
	},

	renderDashboard: function(title, subtitle) {
		this.renderView(title, `<p>${subtitle}</p>`);
	},

	renderError: function(message) {
		this.renderView('Error', `<div class="notification is-danger">${message}</div>`);
	},
};