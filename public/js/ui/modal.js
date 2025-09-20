// public/js/ui/modal.js (indentación con TABS)

const modalContainer = document.getElementById('modal-container');

// Estado interno del módulo
let _onSubmitCallback = null;

export const modal = {

	openForm: function(tableSchema, recordData, onSubmit) {
		if (!modalContainer) return;

		// Usamos TU clase 'modal-open' en el BODY para bloquear el scroll.
		document.body.classList.add('modal-open');

		// Hacemos visible el contenedor principal.
		modalContainer.classList.remove('modal-hidden');

		_onSubmitCallback = onSubmit;

		const isEditing = recordData !== null;
		const title = isEditing ? `Editar ${tableSchema.label || ''}` : `Nuevo ${tableSchema.label || ''}`;

		// --- ¡ESTE ES EL HTML SINCRONIZADO CON TU CSS! ---
		let formHtml = `
			<div class="modal-background" data-action="close-modal"></div>
			<div id="modal-content">
				<header class="modal-header">
					<h2>${title}</h2>
					<button id="modal-close-btn" aria-label="close" data-action="close-modal">&times;</button>
				</header>

				<form id="dynamic-form" class="form-box">
					<section class="modal-body">
						${this.buildFormFields(tableSchema.columns, recordData)}
					</section>
				</form>

				<footer class="modal-footer">
					<button class="button" type="button" data-action="close-modal">Cancelar</button>

					<button
						class="button is-primary"
						type="submit"
						form="dynamic-form"  // <-- ¡LA MAGIA DE HTML5!
						data-action="submit-form"
					>
						Guardar
					</button>
				</footer>
			</div>
		`;
		modalContainer.innerHTML = formHtml;
		this.addEventListeners();
	},

	buildFormFields: function(columnsSchema, recordData) {
		let fieldsHtml = '';
		for (const columnName in columnsSchema) {
			const column = columnsSchema[columnName];
			const isEditing = recordData !== null;

			// Determina si el campo debe mostrarse en el formulario actual (Crear o Editar).
			const showInForm = isEditing ? column.showInEditForm !== false : column.showInCreateForm !== false;
			if (!showInForm) continue;

			const value = recordData ? (recordData[columnName] ?? '') : (column.defaultValue ?? '');
			const label = column.title || columnName;
			const isRequired = column.validation?.required ? 'required' : '';

			// --- ¡NUEVO! MOTOR DE RENDERIZADO DE CAMPOS ---
			fieldsHtml += `<div class="field"><label class="label">${label}</label><div class="control">`;

			switch (column.inputType) {
				case 'textarea':
					fieldsHtml += `
						<textarea class="textarea" name="${columnName}" ${isRequired}>${value}</textarea>
					`;
					break;

				case 'select':
					// 1. Obtenemos la clave de la lista de opciones desde el esquema.
					const sourceKey = column.optionsSource?.sourceKey;
					// 2. Buscamos esa lista en nuestro cache global de opciones.
					const optionsList = _APP.optionsCache?.[sourceKey] || [];

					fieldsHtml += `<div class="select is-fullwidth"><select name="${columnName}" ${isRequired}>`;
					fieldsHtml += `<option value="">-- Seleccionar --</option>`; // Opción por defecto

					optionsList.forEach(option => {
						// 3. Comprobamos si esta opción debe estar pre-seleccionada.
						const isSelected = option.value == value ? 'selected' : '';
						fieldsHtml += `<option value="${option.value}" ${isSelected}>${option.label}</option>`;
					});

					fieldsHtml += `</select></div>`;
					break;

				default: // 'text', 'number', 'email', 'password', etc.
					fieldsHtml += `
						<input class="input" type="${column.inputType || 'text'}" name="${columnName}" value="${value}" ${isRequired}>
					`;
			}

			fieldsHtml += `</div></div>`;
		}
		return fieldsHtml;
	},

	getFormData: function() {
		const form = modalContainer.querySelector('#dynamic-form');
		if (!form) return null;
		const formData = new FormData(form);
		const data = {};
		for (const [key, value] of formData.entries()) { data[key] = value; }
		return data;
	},

	close: function() {
		if (modalContainer) {
			// Quitamos TU clase 'modal-open' del BODY para desbloquear el scroll.
			document.body.classList.remove('modal-open');
			modalContainer.classList.add('modal-hidden');
			modalContainer.innerHTML = '';
		}
	},

	addEventListeners: function() {
		const form = modalContainer.querySelector('#dynamic-form');

		// El listener ahora se añade al contenedor principal para capturar los clics de cierre.
		if (modalContainer) {
			modalContainer.addEventListener('click', (event) => {
				if (event.target.closest('[data-action="close-modal"]')) {
					this.close();
				}
			});
		}

		if (form) {
			form.addEventListener('submit', (event) => {
				event.preventDefault();
				if (typeof _onSubmitCallback === 'function') {
					const data = this.getFormData();
					_onSubmitCallback(data);
				}
			});
		}
	}
};