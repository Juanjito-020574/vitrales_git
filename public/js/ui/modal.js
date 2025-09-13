// /public/js/ui/modal.js (Versión Final Simplificada)

import { handleFormSubmit } from '../app.js';

const modalContainer = document.getElementById('modal-container');
const modalContent = document.getElementById('modal-content');

export function openModal() {
	modalContainer.classList.remove('modal-hidden');
	document.body.classList.add('modal-open');
}

export function closeModal() {
	modalContainer.classList.add('modal-hidden');
	modalContent.innerHTML = '';
	document.body.classList.remove('modal-open');
}

/**
 * ¡REFACTORIZADO Y SIMPLIFICADO!
 * Función síncrona que solo depende del esquema que se le pasa.
 * No realiza llamadas a la API ni accede al estado global.
 */
export function renderForm(schema, data = {}) {
	const isEditMode = Object.keys(data).length > 0;
	let formFieldsHtml = '';

	// Itera sobre las columnas definidas en el esquema para construir los campos
	for (const key in schema.columns) {
		const col = schema.columns[key];

		// Aplica las reglas de visibilidad del formulario
		if (
			(isEditMode && col.showInEditForm === false) ||
			(!isEditMode && col.showInCreateForm === false)
		) {
			continue;
		}

		const value = data[key] ?? col.defaultValue ?? '';
		const isDisabled = col.isEditable === false ? 'disabled' : '';
		const placeholder = col.placeholder ? `placeholder="${col.placeholder}"` : '';
		const inputType = col.inputType || 'text';
		let fieldHtml = '';

		if (inputType === 'hidden') {
			formFieldsHtml += `<input type="hidden" id="${key}" name="${key}" value="${value}">`;
			continue;
		}

		fieldHtml += `<div class="form-group"><label for="${key}">${col.title || key}</label>`;

		if (inputType === 'select') {
			fieldHtml += `<select id="${key}" name="${key}" ${isDisabled}>`;
			fieldHtml += '<option value="">Seleccione una opción</option>';
			if (col.optionsSource?.staticData) {
				col.optionsSource.staticData.forEach(opt => {
					const isSelected = opt.value == value ? 'selected' : '';
					fieldHtml += `<option value="${opt.value}" ${isSelected}>${opt.label}</option>`;
				});
			}
			fieldHtml += `</select>`;
		} else {
			switch (inputType) {
				case 'textarea':
					fieldHtml += `<textarea id="${key}" name="${key}" ${placeholder} ${isDisabled}>${value}</textarea>`;
					break;
				case 'checkbox':
					fieldHtml += `<input type="checkbox" id="${key}" name="${key}" ${value == '1' ? 'checked' : ''} ${isDisabled}>`;
					break;
				default:
					fieldHtml += `<input type="${inputType}" id="${key}" name="${key}" value="${value}" ${placeholder} ${isDisabled}>`;
					break;
			}
		}
		fieldHtml += '</div>';
		formFieldsHtml += fieldHtml;
	}

	const finalHtml = `
		<div class="modal-header">
			<h2>${isEditMode ? 'Editar ' + schema.label : 'Nuevo ' + schema.label}</h2>
			<button id="modal-close-btn">&times;</button>
		</div>
		<form id="dynamic-form" class="form-box"
			data-table-name="${schema.tableName}"
			data-mode="${isEditMode ? 'edit' : 'create'}"
			data-id="${isEditMode ? data[schema.primaryKey || 'id'] : ''}">
			${formFieldsHtml}
		</form>
		<div class="modal-footer">
			<button type="submit" form="dynamic-form" class="action-button">${isEditMode ? 'Guardar Cambios' : 'Crear'}</button>
		</div>`;

	modalContent.innerHTML = finalHtml;
	document.getElementById('dynamic-form').addEventListener('submit', handleFormSubmit);
}