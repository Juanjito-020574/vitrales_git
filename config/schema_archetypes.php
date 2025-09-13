<?php
// /config/schema_archetypes.php

return [
	/**
	 * Arquetipos a nivel de Tabla.
	 * Definen el comportamiento por defecto para tipos comunes de tablas.
	 */
	'table_archetypes' => [
		'CATALOGO_BASICO' => [
			'defaultSortColumn' => 'nombre',
			'actions' => [
				'table' => [['label' => 'Nuevo', 'action' => 'openCreateForm']],
				'row' => [
					['label' => 'Editar', 'action' => 'openEditForm'],
					['label' => 'Eliminar', 'action' => 'triggerDelete']
				]
			]
		],
		'ENTIDAD_PRINCIPAL' => [
			'defaultSortColumn' => 'id',
			'actions' => [
				'table' => [['label' => 'Nuevo', 'action' => 'openCreateForm']],
				'row' => [
					['label' => 'Editar', 'action' => 'openEditForm'],
					['label' => 'Eliminar', 'action' => 'triggerDelete']
				]
			]
		],
		'TABLA_SISTEMA' => [
			'isEditable' => false,
			'actions' => []
		]
	],

	/**
	 * Arquetipos a nivel de Columna.
	 * Definen el comportamiento por defecto para tipos comunes de columnas.
	 */
	'column_archetypes' => [
		'PRIMARY_KEY' => [
			'showInCreateForm' => false,
			'isEditable' => false,
			'visible' => false // Por defecto, los IDs no se muestran en las tablas
		],
		'AUDIT_USER' => [
			'visible' => false,
			'showInCreateForm' => false,
			'showInEditForm' => false,
			'isEditable' => false
		],
		'AUDIT_TIMESTAMP' => [
			'visible' => false,
			'showInCreateForm' => false,
			'showInEditForm' => true,
			'isEditable' => false
		],
		'SYSTEM_FLAG' => [
			'visible' => false,
			'showInCreateForm' => false,
			'showInEditForm' => false,
			'isEditable' => false
		],
		'TEXT_GENERAL' => [
			'inputType' => 'text'
		],
		'TEXT_REQUIRED' => [
			'inputType' => 'text',
			'validation' => ['required' => true]
		],
		'SELECT_API' => [
			'inputType' => 'select',
			'optionsSource' => ['type' => 'api']
		],
		'SELECT_STATIC' => [
			'inputType' => 'select',
			'optionsSource' => ['type' => 'static']
		],
		'NUMBER' => [
			'inputType' => 'number'
		],
		'TEXTAREA' => [
			'inputType' => 'textarea'
		],
		'CHECKBOX' => [
			'inputType' => 'checkbox'
		],
		'HIDDEN' => [
			'inputType' => 'hidden',
			'showInCreateForm' => true,
			'showInEditForm' => true,
			'visible' => false
		]
	]
];