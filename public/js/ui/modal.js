// Indentación con TABS
// public/js/ui/modal.js

const modalContainer = document.getElementById('modal-container');

// Estado interno del módulo del modal
let _currentSchema = null;
let _currentData = null;

export const modal = {

	/**
	 * Abre el modal y construye un formulario basado en un esquema y datos.
	 * @param {object} tableSchema - El esquema de la tabla para construir el formulario.
	 * @param {object|null} recordData - Los datos del registro para rellenar el formulario (null si es nuevo).
	 */
	openForm: function(tableSchema, recordData) {
		if (!modalContainer) return;

		_currentSchema = tableSchema;
		_currentData = recordData;

		const isEditing = recordData !== null;
		const title = isEditing
			? `Editar ${tableSchema.tableComment.label || ''}`
			: `Nuevo ${tableSchema.tableComment.label || ''}`;

		let formHtml = `
			<div class="modal is-active">
				<div class="modal-background" data-action="close-modal"></div>
				<div class="modal-card">
					<header class="modal-card-head">
						<p class="modal-card-title">${title}</p>
						<button class="delete" aria-label="close" data-action="close-modal"></button>
					</header>
					<section class="modal-card-body">
						${this.buildFormFields(tableSchema.columns, recordData)}
					</section>
					<footer class="modal-card-foot">
						<button class="button is-success" data-action="submit-form">Guardar</button>
						<button class="button" data-action="close-modal">Cancelar</button>
					</footer>
				</div>
			</div>
		`;

		modalContainer.innerHTML = formHtml;
		this.addEventListeners();
	},

	/**
	 * Construye los campos del formulario a partir del esquema de columnas.
	 * @param {object} columnsSchema - El objeto con la configuración de todas las columnas.
	 * @param {object|null} recordData - Los datos para rellenar los campos.
	 * @returns {string} - El HTML de los campos del formulario.
	 */
	buildFormFields: function(columnsSchema, recordData) {
		let fieldsHtml = '';
		for (const columnName in columnsSchema) {
			const column = columnsSchema[columnName];

			// No mostrar campos que no son editables o están marcados como no visibles en el formulario
			if (column.isEditable === false || column.showInEditForm === false) {
				continue;
			}

			const value = recordData ? (recordData[columnName] ?? '') : (column.defaultValue ?? '');
			const label = column.title || columnName;
			const placeholder = column.placeholder || '';
			const isRequired = column.validation?.required ? 'required' : '';

			// Aquí se podría tener un switch más complejo para diferentes tipos de input
			// (SELECT, TEXTAREA, CHECKBOX, etc.) basado en column.archetype
			fieldsHtml += `
				<div class="field">
					<label class="label">${label}</label>
					<div class="control">
						<input
							class="input"
							type="text"
							name="${columnName}"
							value="${value}"
							placeholder="${placeholder}"
							${isRequired}
						>
					</div>
				</div>
			`;
		}
		return fieldsHtml;
	},

	close: function() {
		if (modalContainer) {
			modalContainer.innerHTML = '';
		}
	},

	handleModalClick: function(event) {
		const action = event.target.closest('[data-action]')?.dataset.action;
		if (action === 'close-modal') {
			this.close();
		}
		if (action === 'submit-form') {
			// Lógica para recolectar y enviar el formulario (que podría vivir en app.js)
			alert('Formulario enviado (lógica pendiente)');
			this.close();
		}
	},

	addEventListeners: function() {
		// Asegurarse de que el listener se añade al contenedor del modal
		const activeModal = modalContainer.querySelector('.modal');
		if (activeModal) {
			activeModal.addEventListener('click', this.handleModalClick.bind(this));
		}
	}
};