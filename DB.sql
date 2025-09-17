-- --------------------------------------------------------
-- Host:                         librosandinos.com
-- Versión del servidor:         10.5.29-MariaDB - MariaDB Server
-- SO del servidor:              Linux
-- HeidiSQL Versión:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para librosandinos_vitrales_v2
DROP DATABASE IF EXISTS `librosandinos_vitrales_v2`;
CREATE DATABASE IF NOT EXISTS `librosandinos_vitrales_v2` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `librosandinos_vitrales_v2`;

-- Volcando estructura para tabla librosandinos_vitrales_v2.app_schema
DROP TABLE IF EXISTS `app_schema`;
CREATE TABLE IF NOT EXISTS `app_schema` (
  `table_name` varchar(64) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Tabla", "isEditable": false}',
  `schema_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Esquema JSON", "isEditable": false}' CHECK (json_valid(`schema_json`)),
  `checksum` timestamp NULL DEFAULT NULL COMMENT 'Checksum de la última modificación estructural (UPDATE_TIME)',
  `creado_por` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `modificado_por` int(11) DEFAULT NULL,
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_by` int(11) DEFAULT NULL,
  `fecha_eliminacion` datetime DEFAULT NULL,
  PRIMARY KEY (`table_name`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_app_schema_creado_por` (`creado_por`),
  KEY `fk_app_schema_modificado_por` (`modificado_por`),
  KEY `fk_app_schema_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_app_schema_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_app_schema_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_app_schema_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "TABLA_SISTEMA", "tableName": "app_schema", "primaryKey": "table_name", "label": "Esquema de App", "labelPlural": "Esquemas de App"}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.app_schema: ~22 rows (aproximadamente)
INSERT INTO `app_schema` (`table_name`, `schema_json`, `checksum`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	('clientes', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"clientes","label":"Cliente","labelPlural":"Clientes","defaultSortColumn":"nombre_razon_social","actions":{"table":[{"label":"Nuevo Cliente"}],"row":[{"label":"Ver Proyectos","icon":"folder-open","targetRoute":"\\/app\\/clientes\\/{primaryKey}\\/proyectos"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"cotizador_asignado_id":{"archetype":"SELECT_API","title":"Cotizador Asignado","optionsSource":{"endpoint":"usuarios","params":{"rol_id":400},"valueKey":"id","labelKey":"nick"}},"nombre_razon_social":{"archetype":"TEXT_REQUIRED","title":"Nombre o Razón Social","validation":{"minLength":3}},"nit_ci":{"archetype":"TEXT_GENERAL","title":"NIT\\/CI"},"telefono":{"archetype":"TEXT_GENERAL","title":"Teléfono","inputType":"tel"},"email":{"archetype":"TEXT_GENERAL","title":"Email","inputType":"email"},"direccion":{"archetype":"TEXTAREA","title":"Dirección"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('config_cotizacion', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"config_cotizacion","label":"Configuración de Cotización","labelPlural":"Configuraciones de Cotización","actions":{"table":[{"label":"Añadir Regla"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"cotizacion_id":{"archetype":"SELECT_API","title":"Cotización","optionsSource":{"endpoint":"cotizaciones","valueKey":"id","labelKey":"nombre_version"},"validation":{"required":true}},"familia_id":{"archetype":"SELECT_API","title":"Para la Familia","optionsSource":{"endpoint":"familias","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"producto_proveedor_id_preferido":{"archetype":"SELECT_API","title":"Usar Producto\\/Proveedor Específico","optionsSource":{"endpoint":"productos_proveedor","valueKey":"id","labelKey":"id"},"validation":{"required":true}},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('cotizacion_detalle', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"cotizacion_detalle","label":"Ítem de Cotización","labelPlural":"Detalle de Cotización","actions":{"table":[{"label":"Añadir Ítem"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"cotizacion_id":{"archetype":"SELECT_API","title":"Cotización","optionsSource":{"endpoint":"cotizaciones","valueKey":"id","labelKey":"nombre_version"},"validation":{"required":true}},"vano_id":{"archetype":"SELECT_API","title":"Vano Medido","optionsSource":{"endpoint":"vanos","valueKey":"id","labelKey":"codigo_vano"},"validation":{"required":true}},"tipologia_id":{"archetype":"SELECT_API","title":"Producto (Tipología)","optionsSource":{"endpoint":"tipologias","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"costo_calculado":{"archetype":"NUMBER","title":"Costo Calculado","isEditable":false},"precio_venta":{"archetype":"NUMBER","title":"Precio de Venta"},"notas":{"archetype":"TEXTAREA","title":"Notas del Ítem"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('cotizaciones', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"cotizaciones","label":"Cotización","labelPlural":"Cotizaciones","actions":{"table":[{"label":"Nueva Cotización"}],"row":[{"label":"Ver Detalle","targetRoute":"\\/app\\/cotizaciones\\/{primaryKey}\\/detalle"},{"label":"Generar OT","action":"triggerGenerateOT","condition":{"field":"estado","value":"Aprobada"}},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"proyecto_id":{"archetype":"SELECT_API","title":"Proyecto","optionsSource":{"endpoint":"proyectos","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"nombre_version":{"archetype":"TEXT_REQUIRED","title":"Nombre de la Versión","placeholder":"Ej: Opción A: Aluminio Blanco"},"total_costo":{"archetype":"NUMBER","title":"Costo Total","isEditable":false},"total_venta":{"archetype":"NUMBER","title":"Venta Total","isEditable":false},"estado":{"archetype":"SELECT_STATIC","title":"Estado","optionsSource":{"staticData":[{"value":"En Borrador","label":"En Borrador"},{"value":"Presentada","label":"Presentada"},{"value":"Aprobada","label":"Aprobada"},{"value":"Rechazada","label":"Rechazada"}]}},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('familia_tipos', '{"archetype":"CATALOGO_BASICO","tableName":"familia_tipos","label":"Tipo de Familia","labelPlural":"Tipos de Familia","actions":{"table":[{"label":"Nuevo Tipo"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre del Tipo"},"descripcion":{"archetype":"TEXTAREA","title":"Descripción"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('familias', '{"archetype":"CATALOGO_BASICO","tableName":"familias","label":"Familia","labelPlural":"Familias","actions":{"table":[{"label":"Nueva Familia"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre de Familia"},"familia_tipo_id":{"archetype":"SELECT_API","title":"Tipo","optionsSource":{"endpoint":"familia_tipos","valueKey":"id","labelKey":"nombre"}},"descripcion":{"archetype":"TEXTAREA","title":"Descripción"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('historial_cambios', '{"archetype":"TABLA_SISTEMA","tableName":"historial_cambios","primaryKey":"id","label":"Historial de Cambio","labelPlural":"Historial de Cambios","columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"fecha_hora":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha y Hora","visible":true,"showInEditForm":true},"usuario_id":{"archetype":"SELECT_API","title":"Usuario","isEditable":false,"optionsSource":{"endpoint":"usuarios","valueKey":"id","labelKey":"nick"}},"accion":{"archetype":"TEXT_GENERAL","title":"Acción","isEditable":false},"tabla_afectada":{"archetype":"TEXT_GENERAL","title":"Tabla Afectada","isEditable":false},"registro_id":{"archetype":"NUMBER","title":"ID del Registro","isEditable":false},"valor_anterior":{"archetype":"TEXTAREA","title":"Valor Anterior","isEditable":false,"visible":false},"valor_nuevo":{"archetype":"TEXTAREA","title":"Valor Nuevo","isEditable":false,"visible":false}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('materiales', '{"archetype":"CATALOGO_BASICO","tableName":"materiales","label":"Material","labelPlural":"Materiales","actions":{"table":[{"label":"Nuevo Material"}],"row":[{"label":"Ver Precios","targetRoute":"\\/app\\/materiales\\/{primaryKey}\\/precios"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"familia_id":{"archetype":"SELECT_API","title":"Familia","optionsSource":{"endpoint":"familias","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"codigo_interno":{"archetype":"TEXT_REQUIRED","title":"Código Interno"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre del Material"},"unidad_calculo_id":{"archetype":"SELECT_API","title":"Unidad de Cálculo","optionsSource":{"endpoint":"unidades","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"unidad_calculo":{"archetype":"SYSTEM_FLAG"},"descripcion":{"archetype":"TEXTAREA","title":"Descripción"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('medidas_produccion', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"medidas_produccion","label":"Medida de Producción","labelPlural":"Medidas de Producción","actions":{"table":[],"row":[{"label":"Editar Medida","action":"openEditForm"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"orden_trabajo_id":{"archetype":"NUMBER","title":"OT ID","isEditable":false},"vano_cotizado_id":{"archetype":"NUMBER","title":"Vano ID","isEditable":false},"ancho_cotizado":{"archetype":"NUMBER","title":"Ancho Cotizado","isEditable":false},"alto_cotizado":{"archetype":"NUMBER","title":"Alto Cotizado","isEditable":false},"ancho_final":{"archetype":"NUMBER","title":"Ancho Final"},"alto_final":{"archetype":"NUMBER","title":"Alto Final"},"medido_por_id":{"archetype":"SELECT_API","title":"Medido Por","isEditable":false,"optionsSource":{"endpoint":"usuarios","params":{"rol_id":500},"valueKey":"id","labelKey":"nick"}},"fecha_medicion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Medición"},"estado_medicion":{"archetype":"TEXT_GENERAL","title":"Estado","isEditable":false},"notas_fabricacion":{"archetype":"TEXTAREA","title":"Notas para Taller"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('ordenes_trabajo', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"ordenes_trabajo","label":"Orden de Trabajo","labelPlural":"Órdenes de Trabajo","actions":{"table":[],"row":[{"label":"Medición Final","targetRoute":"\\/app\\/ordenes-trabajo\\/{primaryKey}\\/medicion"},{"label":"Ver Despiece","targetRoute":"\\/app\\/ordenes-trabajo\\/{primaryKey}\\/despiece"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"cotizacion_aprobada_id":{"archetype":"NUMBER","title":"Cotización de Origen","isEditable":false},"codigo_orden":{"archetype":"TEXT_REQUIRED","title":"Código OT"},"responsable_id":{"archetype":"SELECT_API","title":"Jefe de Producción","optionsSource":{"endpoint":"usuarios","valueKey":"id","labelKey":"nick","filterByRole":{"300":{"rol_id_in":[500]},"200":{"rol_id_gt":200},"default":{"rol_id":300}}}},"fecha_inicio_produccion":{"archetype":"TEXT_GENERAL","title":"Inicio Producción","inputType":"date"},"estado":{"archetype":"TEXT_GENERAL","title":"Estado","isEditable":false},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('perfiles_usuario', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"perfiles_usuario","primaryKey":"usuario_id","label":"Perfil de Usuario","labelPlural":"Perfiles de Usuario","actions":{"table":[],"row":[{"label":"Editar Perfil","action":"openEditForm"}]},"columns":{"usuario_id":{"archetype":"SELECT_API","title":"Usuario","isEditable":false,"optionsSource":{"endpoint":"usuarios","valueKey":"id","labelKey":"nick"}},"nombres":{"archetype":"TEXT_REQUIRED","title":"Nombres"},"apellidos":{"archetype":"TEXT_REQUIRED","title":"Apellidos"},"cargo":{"archetype":"TEXT_GENERAL","title":"Cargo"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('permisos', '{"archetype":"CATALOGO_BASICO","tableName":"permisos","label":"Regla de Permiso","labelPlural":"Reglas de Permisos","primaryKey":"id","actions":{"table":[{"label":"Nueva Regla"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"rol_id":{"archetype":"SELECT_API","title":"Rol Afectado","optionsSource":{"endpoint":"roles","valueKey":"id","labelKey":"nombre"}},"tabla_afectada":{"archetype":"TEXT_REQUIRED","title":"Tabla Afectada"},"tipo_regla":{"archetype":"SELECT_STATIC","title":"Tipo de Regla","optionsSource":{"staticData":[{"value":"visibility","label":"Visibilidad (Filtra Filas)"},{"value":"schema","label":"Esquema (Oculta Columnas\\/Botones)"},{"value":"action","label":"Acción (Valida Escritura)"}]}},"regla_json":{"archetype":"TEXTAREA","title":"Definición de la Regla (JSON)"},"descripcion":{"archetype":"TEXTAREA","title":"Descripción"},"is_active":{"archetype":"CHECKBOX","title":"Activa"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('productos_proveedor', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"productos_proveedor","label":"Producto de Proveedor","labelPlural":"Productos de Proveedor","actions":{"table":[{"label":"Nuevo Precio"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"material_id":{"archetype":"SELECT_API","title":"Material","optionsSource":{"endpoint":"materiales","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"proveedor_id":{"archetype":"SELECT_API","title":"Proveedor","optionsSource":{"endpoint":"proveedores","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"color":{"archetype":"TEXT_GENERAL","title":"Color"},"codigo_proveedor":{"archetype":"TEXT_GENERAL","title":"Cód. Proveedor"},"precio":{"archetype":"NUMBER","title":"Precio","validation":{"required":true}},"moneda":{"archetype":"SELECT_STATIC","title":"Moneda","optionsSource":{"staticData":[{"value":"Bs","label":"Bolivianos (Bs)"},{"value":"USD","label":"Dólares (USD)"}]}},"unidad_compra_id":{"archetype":"SELECT_API","title":"Unidad de Compra","optionsSource":{"endpoint":"unidades","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"unidad_compra":{"archetype":"SYSTEM_FLAG"},"dimension_compra":{"archetype":"NUMBER","title":"Dimensión de Compra","placeholder":"Ej: 6.0 para una barra de 6m"},"es_preferido":{"archetype":"CHECKBOX","title":"Preferido"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('proveedores', '{"archetype":"CATALOGO_BASICO","tableName":"proveedores","label":"Proveedor","labelPlural":"Proveedores","actions":{"table":[{"label":"Nuevo Proveedor"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre del Proveedor"},"direccion":{"archetype":"TEXTAREA","title":"Dirección"},"telefono":{"archetype":"TEXT_GENERAL","title":"Teléfono","inputType":"tel"},"email":{"archetype":"TEXT_GENERAL","title":"Email","inputType":"email"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('proyectos', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"proyectos","label":"Proyecto","labelPlural":"Proyectos","defaultSortColumn":"nombre","actions":{"table":[{"label":"Nuevo Proyecto"}],"row":[{"label":"Relevamiento","icon":"ruler-combined","targetRoute":"\\/app\\/proyectos\\/{primaryKey}\\/relevamiento"},{"label":"Ver Cotizaciones","icon":"file-invoice-dollar","targetRoute":"\\/app\\/proyectos\\/{primaryKey}\\/cotizaciones"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"cliente_id":{"archetype":"SELECT_API","title":"Cliente","optionsSource":{"endpoint":"clientes","valueKey":"id","labelKey":"nombre_razon_social"},"validation":{"required":true}},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre del Proyecto"},"direccion":{"archetype":"TEXTAREA","title":"Dirección del Proyecto"},"estado":{"archetype":"SELECT_STATIC","title":"Estado","optionsSource":{"staticData":[{"value":"En Relevamiento","label":"En Relevamiento"},{"value":"En Cotización","label":"En Cotización"},{"value":"Aprobado","label":"Aprobado"},{"value":"En Producción","label":"En Producción"},{"value":"Finalizado","label":"Finalizado"},{"value":"Cancelado","label":"Cancelado"}]}},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('recetas_despiece', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"recetas_despiece","label":"Ítem de Receta","labelPlural":"Receta de Despiece","actions":{"table":[{"label":"Añadir Material"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"tipologia_id":{"archetype":"SELECT_API","title":"Tipología","optionsSource":{"endpoint":"tipologias","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"material_id":{"archetype":"SELECT_API","title":"Material","optionsSource":{"endpoint":"materiales","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"descripcion_item":{"archetype":"TEXT_GENERAL","title":"Descripción del Ítem","placeholder":"Ej: Perfil de jamba lateral"},"formula_cantidad":{"archetype":"TEXT_REQUIRED","title":"Fórmula Cantidad","placeholder":"Ej: 2, $Dv"},"formula_corte_ancho":{"archetype":"TEXT_GENERAL","title":"Fórmula Corte Ancho (X)","placeholder":"Ej: $A + $c"},"formula_corte_alto":{"archetype":"TEXT_GENERAL","title":"Fórmula Corte Alto (Y)","placeholder":"Ej: $h \\/ 2"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('roles', '{"archetype":"CATALOGO_BASICO","tableName":"roles","label":"Rol","labelPlural":"Roles","defaultSortColumn":"id","actions":{"table":[{"label":"Nuevo Rol"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"Nivel (ID)","visible":true},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre del Rol"},"descripcion":{"archetype":"TEXTAREA","title":"Descripción"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('tipologias', '{"archetype":"CATALOGO_BASICO","tableName":"tipologias","label":"Tipología","labelPlural":"Tipologías","actions":{"table":[{"label":"Nueva Tipología"}],"row":[{"label":"Editar Receta","icon":"blender","targetRoute":"\\/app\\/tipologias\\/{primaryKey}\\/receta"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre de Tipología"},"familia_principal_id":{"archetype":"SELECT_API","title":"Familia Principal","optionsSource":{"endpoint":"familias","valueKey":"id","labelKey":"nombre"}},"num_divisiones_verticales":{"archetype":"NUMBER","title":"Divisiones Verticales","defaultValue":1},"num_divisiones_horizontales":{"archetype":"NUMBER","title":"Divisiones Horizontales","defaultValue":1},"num_hojas_moviles":{"archetype":"NUMBER","title":"Hojas Móviles","defaultValue":0},"imagen_path":{"archetype":"TEXT_GENERAL","title":"Ruta de Imagen","placeholder":"Ej: \\/images\\/disenos\\/L25-V-C-2-1-1.png"},"notas_diseno":{"archetype":"TEXTAREA","title":"Notas de Diseño"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('ubicaciones', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"ubicaciones","label":"Ubicación","labelPlural":"Ubicaciones","defaultSortColumn":"piso","actions":{"table":[{"label":"Nueva Ubicación"}],"row":[{"label":"Añadir Vanos","targetRoute":"\\/app\\/ubicaciones\\/{primaryKey}\\/vanos"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"proyecto_id":{"archetype":"SELECT_API","title":"Proyecto","optionsSource":{"endpoint":"proyectos","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"piso":{"archetype":"TEXT_GENERAL","title":"Piso \\/ Nivel","placeholder":"Ej: Planta Baja, Piso Tipo"},"departamento":{"archetype":"TEXT_GENERAL","title":"Departamento \\/ Bloque","placeholder":"Ej: Dpto A, Bloque B"},"ambiente":{"archetype":"TEXT_REQUIRED","title":"Ambiente","placeholder":"Ej: Cocina, Sala"},"referencia":{"archetype":"TEXT_GENERAL","title":"Referencia Adicional","placeholder":"Ej: Fachada Oeste"},"cantidad":{"archetype":"NUMBER","title":"Ubicaciones Iguales","defaultValue":1,"validation":{"required":true}},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('unidades', '{"archetype":"CATALOGO_BASICO","tableName":"unidades","label":"Unidad","labelPlural":"Unidades","actions":{"table":[{"label":"Nueva Unidad"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nombre":{"archetype":"TEXT_REQUIRED","title":"Nombre de Unidad"},"abreviatura":{"archetype":"TEXT_REQUIRED","title":"Abreviatura"},"tipo":{"archetype":"SELECT_STATIC","title":"Tipo de Unidad","optionsSource":{"staticData":[{"value":"Longitud","label":"Longitud"},{"value":"Superficie","label":"Superficie"},{"value":"Peso","label":"Peso"},{"value":"Volumen","label":"Volumen"},{"value":"Cantidad","label":"Cantidad"},{"value":"Conjunto","label":"Conjunto"}]}},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('usuarios', '{"archetype":"CATALOGO_BASICO","tableName":"usuarios","label":"Usuario","labelPlural":"Usuarios","defaultSortColumn":"nick","actions":{"table":[{"label":"Nuevo Usuario"}],"row":[{"label":"Ver Perfil","targetRoute":"\\/app\\/usuarios\\/{primaryKey}\\/perfil"},{"label":"Editar","action":"openEditForm"},{"label":"Eliminar","action":"triggerDelete"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"nick":{"archetype":"TEXT_REQUIRED","title":"Nick de Usuario"},"password_hash":{"archetype":"TEXT_GENERAL","title":"Contraseña","inputType":"password","visible":false,"showInEditForm":false,"showInCreateForm":true},"email":{"archetype":"TEXT_GENERAL","title":"Email","inputType":"email"},"rol_id":{"archetype":"SELECT_API","title":"Rol de Usuario","optionsSource":{"endpoint":"roles","valueKey":"id","labelKey":"nombre"},"validation":{"required":true}},"activo":{"archetype":"CHECKBOX","title":"Activo","defaultValue":true},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL),
	('vanos', '{"archetype":"ENTIDAD_PRINCIPAL","tableName":"vanos","label":"Vano","labelPlural":"Vanos","defaultSortColumn":"codigo_vano","actions":{"table":[{"label":"Nuevo Vano"}]},"columns":{"id":{"archetype":"PRIMARY_KEY","title":"ID"},"ubicacion_id":{"archetype":"SELECT_API","title":"Ubicación","optionsSource":{"endpoint":"ubicaciones","valueKey":"id","labelKey":"ambiente"},"validation":{"required":true}},"codigo_vano":{"archetype":"TEXT_REQUIRED","title":"Código del Vano","placeholder":"Ej: V1, P1, Ventana Cocina"},"ancho":{"archetype":"NUMBER","title":"Ancho (m)","validation":{"required":true}},"alto":{"archetype":"NUMBER","title":"Alto (m)","validation":{"required":true}},"cantidad":{"archetype":"NUMBER","title":"Vanos Iguales","defaultValue":1,"validation":{"required":true}},"notas":{"archetype":"TEXTAREA","title":"Notas"},"creado_por":{"archetype":"AUDIT_USER"},"fecha_creacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Creación"},"modificado_por":{"archetype":"AUDIT_USER"},"fecha_modificacion":{"archetype":"AUDIT_TIMESTAMP","title":"Última Modificación"},"is_deleted":{"archetype":"SYSTEM_FLAG"},"deleted_by":{"archetype":"AUDIT_USER"},"fecha_eliminacion":{"archetype":"AUDIT_TIMESTAMP","title":"Fecha Eliminación"}}}', NULL, NULL, '2025-09-03 05:50:39', NULL, '2025-09-02 14:33:03', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.clientes
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `cotizador_asignado_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Cotizador Asignado", "optionsSource": {"endpoint": "usuarios", "params": {"rol_id": 400}, "valueKey": "id", "labelKey": "nick"}}',
  `nombre_razon_social` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre o Razón Social", "validation": {"minLength": 3}}',
  `nit_ci` varchar(50) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "NIT/CI"}',
  `telefono` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Teléfono", "inputType": "tel"}',
  `email` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Email", "inputType": "email"}',
  `direccion` varchar(500) DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Dirección"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_nit_ci_unico` (`nit_ci`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_clientes_creado_por` (`creado_por`),
  KEY `fk_clientes_modificado_por` (`modificado_por`),
  KEY `fk_clientes_deleted_by` (`deleted_by`),
  KEY `idx_cotizador_activo` (`cotizador_asignado_id`,`is_deleted`),
  KEY `idx_clientes_nombre` (`nombre_razon_social`),
  CONSTRAINT `fk_clientes_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_clientes_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_clientes_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_clientes_usuarios` FOREIGN KEY (`cotizador_asignado_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "clientes", "label": "Cliente", "labelPlural": "Clientes", "defaultSortColumn": "nombre_razon_social", "actions": {"table": [{"label": "Nuevo Cliente"}], "row": [{"label": "Ver Proyectos", "icon": "folder-open", "targetRoute": "/app/clientes/{primaryKey}/proyectos"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.clientes: ~16 rows (aproximadamente)
INSERT INTO `clientes` (`id`, `cotizador_asignado_id`, `nombre_razon_social`, `nit_ci`, `telefono`, `email`, `direccion`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 5, 'Sr. Marcelino Rocabado', '1528963014', '747785896', '', '', NULL, '2025-08-14 04:09:45', NULL, '2025-09-04 02:45:00', 0, NULL, NULL),
	(2, 5, 'Arq. Julio Aramayo', '54158962', '78954654', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:17', 0, NULL, NULL),
	(3, 5, 'Ing. Froilan Morales', '12345', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:19', 0, NULL, NULL),
	(4, 5, 'Sr. Jose Rivadeneira', '23456', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:21', 0, NULL, NULL),
	(5, 5, 'Sr. Ramon Mercado', '45812', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:23', 0, NULL, NULL),
	(6, 5, 'Ing Ernesto Cardona', '34567', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:26', 0, NULL, NULL),
	(7, 5, 'Srs UNIVALLE Universidad', '45678', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:29', 0, NULL, NULL),
	(8, 3, 'Sr. Roger Choque', '56789', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:46', 0, NULL, NULL),
	(9, 3, 'Srs  Frutillar', '67890', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:50', 0, NULL, NULL),
	(10, 3, 'Arq.  Hinojosa', '78901', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:52', 0, NULL, NULL),
	(11, 3, 'Sra. 3pisos  casa', '89012', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:53', 0, NULL, NULL),
	(12, 3, 'Sra.  Carolina Terrazas', '90123', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:55', 0, NULL, NULL),
	(13, 3, 'Sr Juan Carlos Medina', '01234', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:57', 0, NULL, NULL),
	(14, 3, 'Sr Alejandro Zurita', '00123', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:04:59', 0, NULL, NULL),
	(15, 3, 'arq think think', '00234', '', NULL, NULL, NULL, '2025-08-14 04:09:45', NULL, '2025-08-24 20:05:03', 0, NULL, NULL),
	(19, 5, 'prueba 123', '0129822', '123456', 'prueba123@vitrales.com', NULL, NULL, '2025-08-27 05:25:11', NULL, '2025-09-10 05:34:27', 1, 3, '2025-09-10 01:34:27');

-- Volcando estructura para tabla librosandinos_vitrales_v2.config_cotizacion
DROP TABLE IF EXISTS `config_cotizacion`;
CREATE TABLE IF NOT EXISTS `config_cotizacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `cotizacion_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Cotización", "optionsSource": {"endpoint": "cotizaciones", "valueKey": "id", "labelKey": "nombre_version"}, "validation": {"required": true}}',
  `familia_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Para la Familia", "optionsSource": {"endpoint": "familias", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `producto_proveedor_id_preferido` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Usar Producto/Proveedor Específico", "optionsSource": {"endpoint": "productos_proveedor", "valueKey": "id", "labelKey": "id"}, "validation": {"required": true}}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_cotizacion_familia` (`cotizacion_id`,`familia_id`),
  KEY `fk_config_cotizacion_cotizaciones` (`cotizacion_id`),
  KEY `fk_config_cotizacion_familias` (`familia_id`),
  KEY `fk_config_cotizacion_productos_proveedor` (`producto_proveedor_id_preferido`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_config_cotizacion_creado_por` (`creado_por`),
  KEY `fk_config_cotizacion_modificado_por` (`modificado_por`),
  KEY `fk_config_cotizacion_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_config_cotizacion_cotizaciones` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_config_cotizacion_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_config_cotizacion_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_config_cotizacion_familias` FOREIGN KEY (`familia_id`) REFERENCES `familias` (`id`),
  CONSTRAINT `fk_config_cotizacion_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_config_cotizacion_productos_proveedor` FOREIGN KEY (`producto_proveedor_id_preferido`) REFERENCES `productos_proveedor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "config_cotizacion", "label": "Configuración de Cotización", "labelPlural": "Configuraciones de Cotización", "actions": {"table": [{"label": "Añadir Regla"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.config_cotizacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.cotizaciones
DROP TABLE IF EXISTS `cotizaciones`;
CREATE TABLE IF NOT EXISTS `cotizaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `proyecto_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Proyecto", "optionsSource": {"endpoint": "proyectos", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `nombre_version` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de la Versión", "placeholder": "Ej: Opción A: Aluminio Blanco"}',
  `total_costo` decimal(14,4) DEFAULT 0.0000 COMMENT '{"archetype": "NUMBER", "title": "Costo Total", "isEditable": false}',
  `total_venta` decimal(14,4) DEFAULT 0.0000 COMMENT '{"archetype": "NUMBER", "title": "Venta Total", "isEditable": false}',
  `estado` varchar(50) NOT NULL DEFAULT 'En Borrador' COMMENT '{"archetype": "SELECT_STATIC", "title": "Estado", "optionsSource": {"staticData": [{"value": "En Borrador", "label": "En Borrador"}, {"value": "Presentada", "label": "Presentada"}, {"value": "Aprobada", "label": "Aprobada"}, {"value": "Rechazada", "label": "Rechazada"}]}}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_cotizaciones_creado_por` (`creado_por`),
  KEY `fk_cotizaciones_modificado_por` (`modificado_por`),
  KEY `fk_cotizaciones_deleted_by` (`deleted_by`),
  KEY `idx_proyecto_activo` (`proyecto_id`,`is_deleted`),
  KEY `idx_cotizaciones_fecha_creacion` (`fecha_creacion`),
  CONSTRAINT `fk_cotizaciones_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizaciones_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizaciones_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizaciones_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "cotizaciones", "label": "Cotización", "labelPlural": "Cotizaciones", "actions": {"table": [{"label": "Nueva Cotización"}], "row": [{"label": "Ver Detalle", "targetRoute": "/app/cotizaciones/{primaryKey}/detalle"}, {"label": "Generar OT", "action": "triggerGenerateOT", "condition": {"field": "estado", "value": "Aprobada"}}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.cotizaciones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.cotizacion_detalle
DROP TABLE IF EXISTS `cotizacion_detalle`;
CREATE TABLE IF NOT EXISTS `cotizacion_detalle` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `cotizacion_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Cotización", "optionsSource": {"endpoint": "cotizaciones", "valueKey": "id", "labelKey": "nombre_version"}, "validation": {"required": true}}',
  `vano_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Vano Medido", "optionsSource": {"endpoint": "vanos", "valueKey": "id", "labelKey": "codigo_vano"}, "validation": {"required": true}}',
  `tipologia_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Producto (Tipología)", "optionsSource": {"endpoint": "tipologias", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `costo_calculado` decimal(12,4) DEFAULT 0.0000 COMMENT '{"archetype": "NUMBER", "title": "Costo Calculado", "isEditable": false}',
  `precio_venta` decimal(12,4) DEFAULT 0.0000 COMMENT '{"archetype": "NUMBER", "title": "Precio de Venta"}',
  `notas` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Notas del Ítem"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_cotizacion_vano` (`cotizacion_id`,`vano_id`),
  KEY `fk_cotizacion_detalle_cotizaciones` (`cotizacion_id`),
  KEY `fk_cotizacion_detalle_vanos` (`vano_id`),
  KEY `fk_cotizacion_detalle_tipologias` (`tipologia_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_cotizacion_detalle_creado_por` (`creado_por`),
  KEY `fk_cotizacion_detalle_modificado_por` (`modificado_por`),
  KEY `fk_cotizacion_detalle_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_cotizacion_detalle_cotizaciones` FOREIGN KEY (`cotizacion_id`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cotizacion_detalle_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizacion_detalle_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizacion_detalle_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cotizacion_detalle_tipologias` FOREIGN KEY (`tipologia_id`) REFERENCES `tipologias` (`id`),
  CONSTRAINT `fk_cotizacion_detalle_vanos` FOREIGN KEY (`vano_id`) REFERENCES `vanos` (`id`),
  CONSTRAINT `chk_precios_positivos` CHECK (`costo_calculado` >= 0 and `precio_venta` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "cotizacion_detalle", "label": "Ítem de Cotización", "labelPlural": "Detalle de Cotización", "actions": {"table": [{"label": "Añadir Ítem"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.cotizacion_detalle: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.familias
DROP TABLE IF EXISTS `familias`;
CREATE TABLE IF NOT EXISTS `familias` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nombre` varchar(100) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Familia"}',
  `familia_tipo_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Tipo", "optionsSource": {"endpoint": "familia_tipos", "valueKey": "id", "labelKey": "nombre"}}',
  `descripcion` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Descripción"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_nombre_familia_unico` (`nombre`),
  KEY `fk_familias_familia_tipos` (`familia_tipo_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_familias_creado_por` (`creado_por`),
  KEY `fk_familias_modificado_por` (`modificado_por`),
  KEY `fk_familias_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_familias_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_familias_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_familias_familia_tipos` FOREIGN KEY (`familia_tipo_id`) REFERENCES `familia_tipos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_familias_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "familias", "label": "Familia", "labelPlural": "Familias", "actions": {"table": [{"label": "Nueva Familia"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.familias: ~25 rows (aproximadamente)
INSERT INTO `familias` (`id`, `nombre`, `familia_tipo_id`, `descripcion`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'Accesorios', 3, 'Accesorios varios. Ruedas, felpas, seguros, etc', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:05:59', 0, NULL, NULL),
	(2, 'Canal U', 2, 'Canales de U', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:07', 0, NULL, NULL),
	(3, 'S70 PVC Corredera FIRAT', 1, 'Puertas y Ventanas Correderas S70 FIRAT PVC', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:20', 0, NULL, NULL),
	(4, 'Corredera Templado', 1, 'Ventanas correderas de vidrio templado', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:26', 0, NULL, NULL),
	(5, 'Herrajes', 3, 'Herrajeria. Chapas, bisagras, seguros, etc', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:40', 0, NULL, NULL),
	(6, 'Linea 20', 1, 'Perfiles y accesorios para ventanas correderas de aluminio Linea 20', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:49', 0, NULL, NULL),
	(7, 'Linea 25', 1, 'Perfiles y accesorios para ventanas correderas de aluminio Linea 25', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:53', 0, NULL, NULL),
	(8, 'Linea 32', 1, 'Perfiles y accesorios para ventanas fijas con proyectantes de aluminio Linea 32', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:06:59', 0, NULL, NULL),
	(9, 'Linea 35', 1, 'Perfiles y accesorios para ventanas fijas con proyectantes de aluminio Linea 35', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:03', 0, NULL, NULL),
	(10, 'Linea 35 - Reforzada', 1, 'BORRAR NO SIRVE YA', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:09', 0, NULL, NULL),
	(11, 'Linea Maxima', 1, 'Perfiles y accesorios para ventanas correderas de aluminio Linea Maxima (corte 45º)', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:15', 0, NULL, NULL),
	(12, 'Mano de Obra', 6, 'Mano de Obra por Instalación', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:21', 0, NULL, NULL),
	(13, 'Serie S3000', 1, 'Perfiles y accesorios para ventanas batientes de aluminio Linea S-3000 (corte 45º)', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:27', 0, NULL, NULL),
	(14, 'S60 PVC Batiente Firat', 1, 'Puertas Batientes; Ventanas Proyectante, Batiente, Oscilobatiente, Fija, Abatible.', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:32', 0, NULL, NULL),
	(15, 'STD', 1, 'Familia estandar', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:47', 0, NULL, NULL),
	(16, 'Serie T45', 1, 'Perfiles y accesorios para ventanas correderas de aluminio linea T45 (Corte 45º)', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:53', 0, NULL, NULL),
	(17, 'Serie T45 Liviano', 1, 'Perfiles y accesorios para ventanas correderas de aluminio linea T45 liviano (Corte 45º)', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:07:58', 0, NULL, NULL),
	(18, 'Tubo Circular', 2, 'Tubos Circulares', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:04', 0, NULL, NULL),
	(19, 'Tubo Cuadrado', 2, 'Tubos Cuadrados', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:13', 0, NULL, NULL),
	(20, 'Tubo Rectangular', 2, 'Tubos Rectangulares', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:18', 0, NULL, NULL),
	(21, 'Vidrio', 4, 'Vidrio', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:24', 0, NULL, NULL),
	(22, 'Paño FIjo Vidrio Templado', 1, 'Paño Fijo de vidrio templado', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:34', 0, NULL, NULL),
	(23, 'Tornillos', 5, 'Tornillos', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:41', 0, NULL, NULL),
	(24, 'Silicona', 5, 'Selladores y espumas', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:47', 0, NULL, NULL),
	(25, 'Utilidad', 7, 'Utilidad por la contratacion', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 20:08:56', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.familia_tipos
DROP TABLE IF EXISTS `familia_tipos`;
CREATE TABLE IF NOT EXISTS `familia_tipos` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nombre` varchar(100) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Tipo"}',
  `descripcion` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Descripción"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_nombre_unico` (`nombre`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_familia_tipos_creado_por` (`creado_por`),
  KEY `fk_familia_tipos_modificado_por` (`modificado_por`),
  KEY `fk_familia_tipos_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_familia_tipos_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_familia_tipos_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_familia_tipos_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "familia_tipos", "label": "Tipo de Familia", "labelPlural": "Tipos de Familia", "actions": {"table": [{"label": "Nuevo Tipo"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.familia_tipos: ~7 rows (aproximadamente)
INSERT INTO `familia_tipos` (`id`, `nombre`, `descripcion`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'Sistema', 'Agrupación principal de perfiles y accesorios que conforman un producto.', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(2, 'Perfiles', 'Materiales que se miden y cortan longitudinalmente.', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(3, 'Accesorios', 'Componentes que se usan por pieza o juego. rodamientos, chapas, burletería, etc', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(4, 'Vidrio', 'Paneles de vidrio o materiales similares. Incolor 4mm, templado 10mm, laminado 6mm(3+3), etc', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(5, 'Consumible', 'Materiales como silicona, tornillos, etc.', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(6, 'Servicios', 'Conceptos no físicos como la mano de obra, transporte, etc.', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL),
	(7, 'Costos', 'Utilidad, descuentos, otros costos sin contraprestacion', NULL, '2025-08-24 19:27:51', NULL, '2025-08-24 19:27:51', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.historial_cambios
DROP TABLE IF EXISTS `historial_cambios`;
CREATE TABLE IF NOT EXISTS `historial_cambios` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `fecha_hora` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha y Hora", "visible": true, "showInEditForm": true}',
  `usuario_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Usuario", "isEditable": false, "optionsSource": {"endpoint": "usuarios", "valueKey": "id", "labelKey": "nick"}}',
  `accion` enum('CREAR','MODIFICAR','ELIMINAR') NOT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Acción", "isEditable": false}',
  `tabla_afectada` varchar(64) NOT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Tabla Afectada", "isEditable": false}',
  `registro_id` int(11) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "ID del Registro", "isEditable": false}',
  `valor_anterior` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Valor Anterior", "isEditable": false, "visible": false}' CHECK (json_valid(`valor_anterior`)),
  `valor_nuevo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Valor Nuevo", "isEditable": false, "visible": false}' CHECK (json_valid(`valor_nuevo`)),
  PRIMARY KEY (`id`),
  KEY `idx_auditoria_general` (`tabla_afectada`,`registro_id`),
  KEY `idx_auditoria_usuario` (`usuario_id`,`fecha_hora`),
  CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "TABLA_SISTEMA", "tableName": "historial_cambios", "primaryKey": "id", "label": "Historial de Cambio", "labelPlural": "Historial de Cambios"}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.historial_cambios: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.materiales
DROP TABLE IF EXISTS `materiales`;
CREATE TABLE IF NOT EXISTS `materiales` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `familia_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Familia", "optionsSource": {"endpoint": "familias", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `codigo_interno` varchar(50) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Código Interno"}',
  `nombre` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Material"}',
  `unidad_calculo_id` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "SELECT_API", "title": "Unidad de Cálculo", "optionsSource": {"endpoint": "unidades", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `unidad_calculo` enum('ml','m2','pza','kg','tubo','jgo') NOT NULL COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `descripcion` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Descripción"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_codigo_interno_unico` (`codigo_interno`),
  KEY `fk_materiales_unidades` (`unidad_calculo_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_materiales_creado_por` (`creado_por`),
  KEY `fk_materiales_modificado_por` (`modificado_por`),
  KEY `fk_materiales_deleted_by` (`deleted_by`),
  KEY `idx_familia_activo` (`familia_id`,`is_deleted`),
  CONSTRAINT `fk_materiales_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_materiales_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_materiales_familias` FOREIGN KEY (`familia_id`) REFERENCES `familias` (`id`),
  CONSTRAINT `fk_materiales_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_materiales_unidades` FOREIGN KEY (`unidad_calculo_id`) REFERENCES `unidades` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "materiales", "label": "Material", "labelPlural": "Materiales", "actions": {"table": [{"label": "Nuevo Material"}], "row": [{"label": "Ver Precios", "targetRoute": "/app/materiales/{primaryKey}/precios"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.materiales: ~82 rows (aproximadamente)
INSERT INTO `materiales` (`id`, `familia_id`, `codigo_interno`, `nombre`, `unidad_calculo_id`, `unidad_calculo`, `descripcion`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 3, '111_270_1000', 'Marco 2 S70 Corrediza Blanco', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(2, 3, '121_270_1000', 'Marco 2 S70 Corrediza Nogal', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(3, 3, '141_270_1000', 'Marco 2 S70 Corrediza Negro', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(4, 13, '3540', 'S-3000 Marco', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(5, 13, '3541', 'S-3000 Hoja (pierna)', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(6, 13, '3544', 'S-3000 Zocalo', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(7, 13, '3545', 'S-3000 Entrecierre (inversor de hoja)', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(8, 13, '3590', 'S-3000 Pisavidrio (junquillo)', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(9, 1, 'A010', 'Felpa', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(10, 1, 'A020', 'Burlete', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(11, 1, 'A030', 'Silicon', 5, 'tubo', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(12, 1, 'A040', 'Tornillo', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(13, 1, 'A050', 'Remache', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(14, 1, 'A060', 'Brazo Proyectante', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(15, 1, 'A090', 'Tarugos', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(16, 1, 'A100', 'Pico de Loro', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(17, 1, 'A110', 'Tranca Linea 35', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(18, 6, 'A2090', 'Ruedas', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(19, 7, 'A2590', 'Ruedas', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(20, 16, 'A45KC', 'Kit cierre', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(21, 16, 'A45KCLL', 'Kit cierre con llave', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(22, 17, 'A45KC_L', 'Kit cierres(lite)', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(23, 16, 'A45KHF', 'Kit Hoja Fija', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(24, 17, 'A45KHF_L', 'Kit Hoja Fijas(lite)', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(25, 16, 'A45KHM30', 'Kit Hoja Movil 30kg', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(26, 17, 'A45KHM30_L', 'Kit Hoja Movil 30kgs(lite)', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(27, 16, 'A45KHM80', 'Kit Hoja Movil 80Kg', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(28, 17, 'A45KHM80_L', 'Kit Hoja Movil 80Kgs(lite)', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(29, 16, 'A45KM1', 'Kit marco', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(30, 17, 'A45KM1_L', 'Kit marcos(lite)', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(31, 1, 'L35UNI', 'Union de Perfiles a 90º', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(32, 12, 'MO01', 'Mano de Obra', 2, 'm2', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(33, 6, 'P2001', 'Riel Superior', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(34, 6, 'P2002', 'Riel inferior', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(35, 6, 'P2003', 'Jamba', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(36, 6, 'P2004', 'Cabezal', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(37, 6, 'P2005', 'Zocalo', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(38, 6, 'P2006', 'Pierna', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(39, 6, 'P2007A', 'Gancho', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(40, 6, 'P2008', 'encuentro', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(41, 7, 'P2501', 'Riel Superior', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(42, 7, 'P2502', 'Riel Inferior', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(43, 7, 'P2503', 'Jamba', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(44, 7, 'P2504', 'Cabezal', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(45, 7, 'P2505', 'Zocalo', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(46, 7, 'P2507', 'Gancho', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(47, 7, 'P2508', 'encuentro', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(48, 7, 'P2510', 'Pierna', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(49, 17, 'P3415', 'Marco lite', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(50, 17, 'P3416', 'Hojas lite', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(51, 17, 'P3417', 'Entrecierres lite', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(52, 16, 'P3418', 'Marco', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(53, 16, 'P3419', 'Adaptador riel', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(54, 16, 'P3420', 'Hoja', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(55, 16, 'P3421', 'Entrecierre', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(56, 16, 'P3422', 'Malla', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(57, 16, 'P3426', 'Adaptador Hoja', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(58, 16, 'P3427', 'Doble Entrecierre', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(59, 17, 'P3428', 'Adaptador Hojas lite', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(60, 9, 'P3501', 'L35 Marco', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(61, 9, 'P3502', 'Hoja', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(62, 9, 'P3503', 'L35 Pilar T', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(63, 9, 'P3505', 'L35 Junquillo', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(64, 9, 'P35080', 'Escuadra', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(65, 1, 'S3000V1', 'Burlete', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(66, 20, 'T25x50', 'Tubo de 50 x 25', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(67, 20, 'T30x60', 'Tubo de 30 x 60mm', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(68, 20, 'T40x80', 'Tubo de 40 x 80mm', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(69, 2, 'U_12x12', 'U- Canals u 12 x 12', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(70, 2, 'U_15x25', 'Can al U 15x25 mm', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(71, 21, 'V04', 'Vidrio 4mm', 2, 'm2', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(72, 22, 'VT008', 'Vidrio Templado de 8mm', 2, 'm2', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(73, 22, 'VT010', 'Vidrio templado 10mm', 2, 'm2', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(74, 22, 'VT8_CAB_001', 'Cabezal para ventana corredera 8mm en vidrio templado', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(75, 22, 'VT8_CAB_002', 'Tapa Cabezal para ventana corredera 8m en vidrio templado', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(76, 1, 'VT8_CHAP', 'Chapa para ventana corredera 8mm', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(77, 1, 'VT8_FELP', 'Felpa para ventana corredera 8m vidrio templado', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(78, 1, 'VT8_RUED', 'Ruedas para ventana corredera 8mm', 3, 'pza', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(79, 22, 'VT8_TRILL_002', 'Tapa trillo o riel para ventana corredera de 8m en vidrio templado', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(80, 22, 'VT8_TRIL_001', 'Trillo o riel para ventana corredera de 8mm en vidrio templado', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(81, 22, 'VT8_Ved', 'Vedapre', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(82, 1, 'Z999', 'Perfile para union 90ª', 1, 'ml', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.medidas_produccion
DROP TABLE IF EXISTS `medidas_produccion`;
CREATE TABLE IF NOT EXISTS `medidas_produccion` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `orden_trabajo_id` int(11) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "OT ID", "isEditable": false}',
  `vano_cotizado_id` int(11) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Vano ID", "isEditable": false}',
  `ancho_cotizado` decimal(10,4) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Ancho Cotizado", "isEditable": false}',
  `alto_cotizado` decimal(10,4) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Alto Cotizado", "isEditable": false}',
  `ancho_final` decimal(10,4) DEFAULT NULL COMMENT '{"archetype": "NUMBER", "title": "Ancho Final"}',
  `alto_final` decimal(10,4) DEFAULT NULL COMMENT '{"archetype": "NUMBER", "title": "Alto Final"}',
  `medido_por_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Medido Por", "isEditable": false, "optionsSource": {"endpoint": "usuarios", "params": {"rol_id": 500}, "valueKey": "id", "labelKey": "nick"}}',
  `fecha_medicion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Medición"}',
  `estado_medicion` varchar(50) NOT NULL DEFAULT 'Pendiente' COMMENT '{"archetype": "TEXT_GENERAL", "title": "Estado", "isEditable": false}',
  `notas_fabricacion` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Notas para Taller"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_medidas_ot` (`orden_trabajo_id`),
  KEY `fk_medidas_vano` (`vano_cotizado_id`),
  KEY `fk_medidas_usuario` (`medido_por_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_medidas_produccion_creado_por` (`creado_por`),
  KEY `fk_medidas_produccion_modificado_por` (`modificado_por`),
  KEY `fk_medidas_produccion_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_medidas_ot` FOREIGN KEY (`orden_trabajo_id`) REFERENCES `ordenes_trabajo` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_medidas_produccion_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_medidas_produccion_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_medidas_produccion_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_medidas_usuario` FOREIGN KEY (`medido_por_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `fk_medidas_vano` FOREIGN KEY (`vano_cotizado_id`) REFERENCES `vanos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "medidas_produccion", "label": "Medida de Producción", "labelPlural": "Medidas de Producción", "actions": {"table": [], "row": [{"label": "Editar Medida", "action": "openEditForm"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.medidas_produccion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.ordenes_trabajo
DROP TABLE IF EXISTS `ordenes_trabajo`;
CREATE TABLE IF NOT EXISTS `ordenes_trabajo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `cotizacion_aprobada_id` int(11) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Cotización de Origen", "isEditable": false}',
  `codigo_orden` varchar(50) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Código OT"}',
  `responsable_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Jefe de Producción", "optionsSource": {"endpoint": "usuarios", "valueKey": "id", "labelKey": "nick", "filterByRole": {"300": {"rol_id_in": [500]}, "200": {"rol_id_gt": 200}, "default": {"rol_id": 300}}}}',
  `fecha_inicio_produccion` date DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Inicio Producción", "inputType": "date"}',
  `estado` varchar(50) NOT NULL DEFAULT 'Pendiente Medición Final' COMMENT '{"archetype": "TEXT_GENERAL", "title": "Estado", "isEditable": false}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_codigo_orden_unico` (`codigo_orden`),
  KEY `fk_ot_cotizacion` (`cotizacion_aprobada_id`),
  KEY `fk_ot_responsable` (`responsable_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_ordenes_trabajo_creado_por` (`creado_por`),
  KEY `fk_ordenes_trabajo_modificado_por` (`modificado_por`),
  KEY `fk_ordenes_trabajo_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_ordenes_trabajo_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ordenes_trabajo_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ordenes_trabajo_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ot_cotizacion` FOREIGN KEY (`cotizacion_aprobada_id`) REFERENCES `cotizaciones` (`id`),
  CONSTRAINT `fk_ot_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "ordenes_trabajo", "label": "Orden de Trabajo", "labelPlural": "Órdenes de Trabajo", "actions": {"table": [], "row": [{"label": "Medición Final", "targetRoute": "/app/ordenes-trabajo/{primaryKey}/medicion"}, {"label": "Ver Despiece", "targetRoute": "/app/ordenes-trabajo/{primaryKey}/despiece"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.ordenes_trabajo: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.perfiles_usuario
DROP TABLE IF EXISTS `perfiles_usuario`;
CREATE TABLE IF NOT EXISTS `perfiles_usuario` (
  `usuario_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Usuario", "isEditable": false, "optionsSource": {"endpoint": "usuarios", "valueKey": "id", "labelKey": "nick"}}',
  `nombres` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombres"}',
  `apellidos` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Apellidos"}',
  `cargo` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Cargo"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`usuario_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_', p_table_name, '_creado_por` (`creado_por`),
  KEY `fk_', p_table_name, '_modificado_por` (`modificado_por`),
  KEY `fk_', p_table_name, '_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_', p_table_name, '_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_', p_table_name, '_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_', p_table_name, '_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_perfiles_usuario_usuarios` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "perfiles_usuario", "primaryKey": "usuario_id", "label": "Perfil de Usuario", "labelPlural": "Perfiles de Usuario", "actions": {"table": [], "row": [{"label": "Editar Perfil", "action": "openEditForm"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.perfiles_usuario: ~8 rows (aproximadamente)
INSERT INTO `perfiles_usuario` (`usuario_id`, `nombres`, `apellidos`, `cargo`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'Juan Jose', 'Arandia Avila', 'Programador', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(2, 'Juan Jose', 'Arandia Avila', 'administrador', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(3, 'Juan Jose', 'Arandia Avila', 'administrador', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(4, 'Pedro', 'Picapiedra', 'Jefe de Producción', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(5, 'Pablo', 'Marmol', 'Cotizador / Vendedor', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(6, 'Mario', 'Arandia Avila', 'Técnico de Campo', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(7, 'Clark', 'Kent', 'Cliente Ejemplo', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL),
	(8, 'Visitor', 'Loading', 'Visitante', NULL, '2025-08-25 18:20:50', NULL, '2025-08-25 18:20:50', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.permisos
DROP TABLE IF EXISTS `permisos`;
CREATE TABLE IF NOT EXISTS `permisos` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `rol_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Rol Afectado", "optionsSource": {"endpoint": "roles", "valueKey": "id", "labelKey": "nombre"}}',
  `tabla_afectada` varchar(64) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Tabla Afectada"}',
  `tipo_regla` enum('visibility','schema','action') NOT NULL COMMENT '{"archetype": "SELECT_STATIC", "title": "Tipo de Regla", "optionsSource": {"staticData": [{"value": "visibility", "label": "Visibilidad (Filtra Filas)"}, {"value": "schema", "label": "Esquema (Oculta Columnas/Botones)"}, {"value": "action", "label": "Acción (Valida Escritura)"}]}}',
  `regla_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Definición de la Regla (JSON)"}' CHECK (json_valid(`regla_json`)),
  `descripcion` varchar(255) DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Descripción"}',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '{"archetype": "CHECKBOX", "title": "Activa"}',
  `creado_por` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `modificado_por` int(11) DEFAULT NULL,
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_by` int(11) DEFAULT NULL,
  `fecha_eliminacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unica_regla` (`rol_id`,`tabla_afectada`,`tipo_regla`),
  KEY `idx_permisos_activos` (`rol_id`,`tabla_afectada`,`is_active`),
  KEY `fk_permisos_creado_por` (`creado_por`),
  KEY `fk_permisos_modificado_por` (`modificado_por`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_permisos_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_permisos_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_permisos_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_permisos_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_permisos_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "permisos", "label": "Regla de Permiso", "labelPlural": "Reglas de Permisos", "primaryKey": "id", "actions": {"table": [{"label": "Nueva Regla"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.permisos: ~112 rows (aproximadamente)
INSERT INTO `permisos` (`id`, `rol_id`, `tabla_afectada`, `tipo_regla`, `regla_json`, `descripcion`, `is_active`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 4, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Admin: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(2, 6, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(3, 10, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(4, 11, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(5, 14, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(6, 15, 'app_schema', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a la tabla interna de esquemas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(7, 10, 'clientes', 'visibility', '{"type": "field_match", "field": "cotizador_asignado_id", "value": "{userId}"}', 'Cotizador: Solo puede ver los clientes que tiene asignados.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(8, 10, 'clientes', 'schema', '{"hide_columns_in_table": ["cotizador_asignado_id"], "field_overrides": {"cotizador_asignado_id": {"showInCreateForm": false, "showInEditForm": false, "defaultValueOnCreate": "{userId}"}}}', 'Cotizador: Oculta columna de cotizador y auto-asigna al crear.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(9, 6, 'clientes', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a la tabla de clientes.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(10, 14, 'clientes', 'visibility', '{"type": "field_match", "field": "id", "value": "{clientId}"}', 'Cliente: Solo puede ver su propia información de cliente.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(11, 6, 'config_cotizacion', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a la configuración de cotizaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(12, 11, 'config_cotizacion', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(13, 14, 'config_cotizacion', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(14, 15, 'config_cotizacion', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(15, 6, 'cotizaciones', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a cotizaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(16, 10, 'cotizaciones', 'action', '{"prevent_update_if": {"field": "estado", "not_in": ["En Borrador"]}, "prevent_delete_if": {"field": "estado", "not_in": ["En Borrador"]}}', 'Cotizador: No puede modificar cotizaciones que no estén en borrador.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(17, 11, 'cotizaciones', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a cotizaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(18, 14, 'cotizaciones', 'visibility', '{"type": "subquery", "field": "proyecto_id", "operator": "IN", "subquery": {"from_table": "proyectos", "select_field": "id", "where": {"field": "cliente_id", "value": "{clientId}"}}}', 'Cliente: Solo ve cotizaciones de sus proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(19, 15, 'cotizaciones', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a cotizaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(20, 6, 'cotizacion_detalle', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a detalle de cotización.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(21, 10, 'cotizacion_detalle', 'action', '{"prevent_write_if_parent_status": {"parent_table": "cotizaciones", "parent_key": "cotizacion_id", "status_field": "estado", "not_in": ["En Borrador"]}}', 'Cotizador: No puede modificar el detalle de cotizaciones que no estén en borrador.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(22, 11, 'cotizacion_detalle', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a detalle de cotización.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(23, 15, 'cotizacion_detalle', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a detalle de cotización.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(24, 10, 'familias', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura al catálogo de familias.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(25, 11, 'familias', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a familias.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(26, 14, 'familias', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a familias.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(27, 15, 'familias', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a familias.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(28, 6, 'familia_tipos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a tipos de familia.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(29, 10, 'familia_tipos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a tipos de familia.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(30, 11, 'familia_tipos', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a tipos de familia.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(31, 14, 'familia_tipos', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a tipos de familia.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(32, 15, 'familia_tipos', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a tipos de familia.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(33, 10, 'materiales', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura al catálogo de materiales.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(34, 11, 'materiales', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a materiales.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(35, 14, 'materiales', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a materiales.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(36, 15, 'materiales', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a materiales.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(37, 6, 'productos_proveedor', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a precios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(38, 10, 'productos_proveedor', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a precios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(39, 11, 'productos_proveedor', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a precios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(40, 14, 'productos_proveedor', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a precios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(41, 15, 'productos_proveedor', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a precios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(42, 6, 'proveedores', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a proveedores.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(43, 10, 'proveedores', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a proveedores.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(44, 11, 'proveedores', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a proveedores.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(45, 14, 'proveedores', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a proveedores.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(46, 15, 'proveedores', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a proveedores.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(47, 6, 'unidades', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a unidades.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(48, 10, 'unidades', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a unidades.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(49, 11, 'unidades', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a unidades.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(50, 14, 'unidades', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a unidades.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(51, 15, 'unidades', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a unidades.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(52, 4, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Admin: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(53, 6, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(54, 10, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(55, 11, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(56, 14, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(57, 15, 'historial_cambios', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado al historial de cambios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(58, 4, 'permisos', 'visibility', '{"type": "deny_all"}', 'Admin: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(59, 6, 'permisos', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(60, 10, 'permisos', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(61, 11, 'permisos', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(62, 14, 'permisos', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(63, 15, 'permisos', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a la gestión de permisos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(64, 4, 'roles', 'visibility', '{"type": "deny_all"}', 'Admin: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(65, 6, 'roles', 'visibility', '{"type": "deny_all"}', 'Jefe de Prod: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(66, 10, 'roles', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(67, 11, 'roles', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(68, 14, 'roles', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(69, 15, 'roles', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a la gestión de roles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(70, 10, 'medidas_produccion', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado a las medidas de producción.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(71, 11, 'medidas_produccion', 'schema', '{"hide_actions": ["openCreateForm", "triggerDelete"]}', 'Técnico: Solo puede editar medidas, no crearlas ni eliminarlas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(72, 14, 'medidas_produccion', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a las medidas de producción.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(73, 15, 'medidas_produccion', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a las medidas de producción.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(74, 6, 'ordenes_trabajo', 'schema', '{"hide_actions": ["openCreateForm", "triggerDelete"]}', 'Jefe de Prod: Puede editar OTs, pero no crearlas ni eliminarlas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(75, 10, 'ordenes_trabajo', 'visibility', '{"type": "deny_all"}', 'Cotizador: Acceso denegado a las órdenes de trabajo.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(76, 11, 'ordenes_trabajo', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Técnico: Acceso de solo lectura a las órdenes de trabajo.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(77, 14, 'ordenes_trabajo', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cliente: Acceso de solo lectura a sus OTs.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(78, 15, 'ordenes_trabajo', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a las órdenes de trabajo.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(79, 10, 'recetas_despiece', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a las recetas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(80, 11, 'recetas_despiece', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a las recetas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(81, 14, 'recetas_despiece', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a las recetas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(82, 15, 'recetas_despiece', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a las recetas.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(83, 10, 'tipologias', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cotizador: Acceso de solo lectura a las tipologías.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(84, 11, 'tipologias', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a las tipologías.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(85, 14, 'tipologias', 'visibility', '{"type": "deny_all"}', 'Cliente: Acceso denegado a las tipologías.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(86, 15, 'tipologias', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a las tipologías.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(87, 6, 'proyectos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(88, 11, 'proyectos', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(89, 14, 'proyectos', 'visibility', '{"type": "field_match", "field": "cliente_id", "value": "{clientId}"}', 'Cliente: Solo ve sus propios proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(90, 14, 'proyectos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cliente: Acceso de solo lectura a proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(91, 15, 'proyectos', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a proyectos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(92, 6, 'ubicaciones', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a ubicaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(93, 11, 'ubicaciones', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a ubicaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(94, 14, 'ubicaciones', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cliente: Acceso de solo lectura a ubicaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(95, 15, 'ubicaciones', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a ubicaciones.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(96, 6, 'vanos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a vanos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(97, 11, 'vanos', 'visibility', '{"type": "deny_all"}', 'Técnico: Acceso denegado a vanos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(98, 14, 'vanos', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Cliente: Acceso de solo lectura a vanos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(99, 15, 'vanos', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a vanos.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(100, 6, 'perfiles_usuario', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a perfiles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(101, 10, 'perfiles_usuario', 'visibility', '{"type": "field_match", "field": "usuario_id", "value": "{userId}"}', 'Cotizador: Solo ve su propio perfil.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(102, 11, 'perfiles_usuario', 'visibility', '{"type": "field_match", "field": "usuario_id", "value": "{userId}"}', 'Técnico: Solo ve su propio perfil.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(103, 14, 'perfiles_usuario', 'visibility', '{"type": "field_match", "field": "usuario_id", "value": "{userId}"}', 'Cliente: Solo ve su propio perfil.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(104, 15, 'perfiles_usuario', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a perfiles.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(105, 6, 'usuarios', 'schema', '{"hide_actions": ["openCreateForm", "openEditForm", "triggerDelete"]}', 'Jefe de Prod: Acceso de solo lectura a usuarios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(106, 10, 'usuarios', 'visibility', '{"type": "field_match", "field": "id", "value": "{userId}"}', 'Cotizador: Solo ve su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(107, 10, 'usuarios', 'schema', '{"hide_actions": ["openCreateForm", "triggerDelete"]}', 'Cotizador: Solo puede editar su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(108, 11, 'usuarios', 'visibility', '{"type": "field_match", "field": "id", "value": "{userId}"}', 'Técnico: Solo ve su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(109, 11, 'usuarios', 'schema', '{"hide_actions": ["openCreateForm", "triggerDelete"]}', 'Técnico: Solo puede editar su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(110, 14, 'usuarios', 'visibility', '{"type": "field_match", "field": "id", "value": "{userId}"}', 'Cliente: Solo ve su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(111, 14, 'usuarios', 'schema', '{"hide_actions": ["openCreateForm", "triggerDelete"]}', 'Cliente: Solo puede editar su propio usuario.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL),
	(112, 15, 'usuarios', 'visibility', '{"type": "deny_all"}', 'Visitante: Acceso denegado a usuarios.', 1, NULL, '2025-09-03 05:58:43', NULL, '2025-09-03 05:58:43', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.productos_proveedor
DROP TABLE IF EXISTS `productos_proveedor`;
CREATE TABLE IF NOT EXISTS `productos_proveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `material_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Material", "optionsSource": {"endpoint": "materiales", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `proveedor_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Proveedor", "optionsSource": {"endpoint": "proveedores", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `color` varchar(50) NOT NULL DEFAULT 'Estándar' COMMENT '{"archetype": "TEXT_GENERAL", "title": "Color"}',
  `codigo_proveedor` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Cód. Proveedor"}',
  `precio` decimal(12,4) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Precio", "validation": {"required": true}}',
  `moneda` enum('Bs','USD') NOT NULL DEFAULT 'Bs' COMMENT '{"archetype": "SELECT_STATIC", "title": "Moneda", "optionsSource": {"staticData": [{"value": "Bs", "label": "Bolivianos (Bs)"}, {"value": "USD", "label": "Dólares (USD)"}]}}',
  `unidad_compra_id` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "SELECT_API", "title": "Unidad de Compra", "optionsSource": {"endpoint": "unidades", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `unidad_compra` enum('Barra','Plancha','Caja','Unidad','Kg','m') NOT NULL COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `dimension_compra` decimal(10,4) DEFAULT NULL COMMENT '{"archetype": "NUMBER", "title": "Dimensión de Compra", "placeholder": "Ej: 6.0 para una barra de 6m"}',
  `es_preferido` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "CHECKBOX", "title": "Preferido"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_productos_proveedor_proveedores` (`proveedor_id`),
  KEY `fk_productos_proveedor_unidades` (`unidad_compra_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_productos_proveedor_creado_por` (`creado_por`),
  KEY `fk_productos_proveedor_modificado_por` (`modificado_por`),
  KEY `fk_productos_proveedor_deleted_by` (`deleted_by`),
  KEY `idx_material_activo` (`material_id`,`is_deleted`),
  CONSTRAINT `fk_productos_proveedor_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_productos_proveedor_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_productos_proveedor_materiales` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_productos_proveedor_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_productos_proveedor_proveedores` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`),
  CONSTRAINT `fk_productos_proveedor_unidades` FOREIGN KEY (`unidad_compra_id`) REFERENCES `unidades` (`id`),
  CONSTRAINT `chk_precio_positivo` CHECK (`precio` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "productos_proveedor", "label": "Producto de Proveedor", "labelPlural": "Productos de Proveedor", "actions": {"table": [{"label": "Nuevo Precio"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.productos_proveedor: ~227 rows (aproximadamente)
INSERT INTO `productos_proveedor` (`id`, `material_id`, `proveedor_id`, `color`, `codigo_proveedor`, `precio`, `moneda`, `unidad_compra_id`, `unidad_compra`, `dimension_compra`, `es_preferido`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 1, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Unidad', 5.9500, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(2, 2, 1, 'Nogal', NULL, 0.0000, 'Bs', 1, 'Unidad', 5.9500, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(3, 3, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', 5.9500, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(4, 4, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(5, 5, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(6, 6, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(7, 7, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(8, 8, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(9, 9, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(10, 10, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(11, 11, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(12, 11, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(13, 11, 1, 'transparente', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(14, 12, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(15, 13, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(16, 14, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(17, 15, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(18, 16, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(19, 16, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(20, 16, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(21, 16, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(22, 16, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(23, 16, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(24, 17, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(25, 18, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(26, 19, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(27, 20, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(28, 21, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(29, 22, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(30, 23, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(31, 24, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(32, 25, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(33, 26, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(34, 27, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(35, 28, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(36, 29, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(37, 30, 1, 'estandar', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(38, 31, 1, 'ninguno', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(39, 32, 1, 'ninguno', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(40, 33, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(41, 33, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(42, 33, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(43, 33, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(44, 33, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(45, 33, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(46, 34, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(47, 34, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(48, 34, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(49, 34, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(50, 34, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(51, 34, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(52, 35, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(53, 35, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(54, 35, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(55, 35, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(56, 35, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(57, 35, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(58, 36, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(59, 36, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(60, 36, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(61, 36, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(62, 36, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(63, 36, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(64, 37, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(65, 37, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(66, 37, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(67, 37, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(68, 37, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(69, 37, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(70, 38, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(71, 38, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(72, 38, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(73, 38, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(74, 38, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(75, 38, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(76, 39, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(77, 39, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(78, 39, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(79, 39, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(80, 39, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(81, 39, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(82, 40, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(83, 40, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(84, 40, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(85, 40, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(86, 40, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(87, 40, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(88, 41, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(89, 41, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(90, 41, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(91, 41, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(92, 41, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(93, 41, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(94, 42, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(95, 42, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(96, 42, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(97, 42, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(98, 42, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(99, 42, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(100, 43, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(101, 43, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(102, 43, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(103, 43, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(104, 43, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(105, 43, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(106, 44, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(107, 44, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(108, 44, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(109, 44, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(110, 44, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(111, 44, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(112, 45, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(113, 45, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(114, 45, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(115, 45, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(116, 45, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(117, 45, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(118, 46, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(119, 46, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(120, 46, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(121, 46, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(122, 46, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(123, 46, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(124, 47, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(125, 47, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(126, 47, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(127, 47, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(128, 47, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(129, 47, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(130, 48, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(131, 48, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(132, 48, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(133, 48, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(134, 48, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(135, 48, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(136, 49, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(137, 49, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(138, 49, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(139, 49, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(140, 49, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(141, 49, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(142, 50, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(143, 50, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(144, 50, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(145, 50, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(146, 50, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(147, 50, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(148, 51, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(149, 51, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(150, 51, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(151, 51, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(152, 51, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(153, 51, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(154, 52, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(155, 52, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(156, 52, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(157, 52, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(158, 52, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(159, 52, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(160, 53, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(161, 53, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(162, 53, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(163, 53, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(164, 53, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(165, 53, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(166, 54, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(167, 54, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(168, 54, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(169, 54, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(170, 54, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(171, 54, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(172, 55, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(173, 55, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(174, 55, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(175, 55, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(176, 55, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(177, 55, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(178, 56, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(179, 56, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(180, 56, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(181, 56, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(182, 56, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(183, 56, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(184, 57, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(185, 57, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(186, 57, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(187, 57, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(188, 57, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(189, 57, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(190, 58, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(191, 58, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(192, 58, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(193, 58, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(194, 58, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(195, 58, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(196, 59, 1, 'blanco', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(197, 59, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(198, 59, 1, 'champagne', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(199, 59, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(200, 59, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(201, 59, 1, 'titanio', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(202, 60, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(203, 61, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(204, 62, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(205, 63, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Barra', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(206, 64, 1, 'ninguno', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(207, 65, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', NULL, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(208, 66, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(209, 67, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(210, 68, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(211, 69, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(212, 70, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(213, 71, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 3.3000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(214, 72, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(215, 72, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(216, 72, 1, 'transparente', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(217, 73, 1, 'bronce', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(218, 73, 1, 'transparente', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(219, 74, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(220, 75, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(221, 76, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(222, 77, 1, 'negro', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(223, 78, 1, 'ninguno', NULL, 0.0000, 'Bs', 1, 'Unidad', 1.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(224, 79, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(225, 80, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(226, 81, 1, 'mate', NULL, 0.0000, 'Bs', 1, 'Unidad', 6.0000, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(227, 82, 1, 'Estándar', NULL, 0.0000, 'Bs', 1, 'Unidad', 0.0500, 0, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.proveedores
DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE IF NOT EXISTS `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nombre` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Proveedor"}',
  `direccion` varchar(500) DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Dirección"}',
  `telefono` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Teléfono", "inputType": "tel"}',
  `email` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Email", "inputType": "email"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_proveedores_creado_por` (`creado_por`),
  KEY `fk_proveedores_modificado_por` (`modificado_por`),
  KEY `fk_proveedores_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_proveedores_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proveedores_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proveedores_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "proveedores", "label": "Proveedor", "labelPlural": "Proveedores", "actions": {"table": [{"label": "Nuevo Proveedor"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.proveedores: ~3 rows (aproximadamente)
INSERT INTO `proveedores` (`id`, `nombre`, `direccion`, `telefono`, `email`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'Aluvi', 'Av. Blanco Galindo', NULL, NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(2, 'MetalVid', 'Cerca UMSS', NULL, NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(3, 'Carlos Flores', 'El Pueblito', NULL, NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.proyectos
DROP TABLE IF EXISTS `proyectos`;
CREATE TABLE IF NOT EXISTS `proyectos` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `cliente_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Cliente", "optionsSource": {"endpoint": "clientes", "valueKey": "id", "labelKey": "nombre_razon_social"}, "validation": {"required": true}}',
  `nombre` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Proyecto"}',
  `direccion` varchar(500) DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Dirección del Proyecto"}',
  `estado` varchar(50) NOT NULL DEFAULT 'En Relevamiento' COMMENT '{"archetype": "SELECT_STATIC", "title": "Estado", "optionsSource": {"staticData": [{"value": "En Relevamiento", "label": "En Relevamiento"}, {"value": "En Cotización", "label": "En Cotización"}, {"value": "Aprobado", "label": "Aprobado"}, {"value": "En Producción", "label": "En Producción"}, {"value": "Finalizado", "label": "Finalizado"}, {"value": "Cancelado", "label": "Cancelado"}]}}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_proyectos_creado_por` (`creado_por`),
  KEY `fk_proyectos_modificado_por` (`modificado_por`),
  KEY `fk_proyectos_deleted_by` (`deleted_by`),
  KEY `idx_cliente_activo` (`cliente_id`,`is_deleted`),
  CONSTRAINT `fk_proyectos_clientes` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `fk_proyectos_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proyectos_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proyectos_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "proyectos", "label": "Proyecto", "labelPlural": "Proyectos", "defaultSortColumn": "nombre", "actions": {"table": [{"label": "Nuevo Proyecto"}], "row": [{"label": "Relevamiento", "icon": "ruler-combined", "targetRoute": "/app/proyectos/{primaryKey}/relevamiento"}, {"label": "Ver Cotizaciones", "icon": "file-invoice-dollar", "targetRoute": "/app/proyectos/{primaryKey}/cotizaciones"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.proyectos: ~13 rows (aproximadamente)
INSERT INTO `proyectos` (`id`, `cliente_id`, `nombre`, `direccion`, `estado`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 1, 'Proyecto Principal Cliente ID 1', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(2, 2, 'Proyecto Principal Cliente ID 2', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(3, 3, 'Proyecto Principal Cliente ID 3', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(4, 4, 'Proyecto Principal Cliente ID 4', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(5, 6, 'Proyecto Principal Cliente ID 6', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(6, 7, 'Proyecto Principal Cliente ID 7', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(7, 8, 'Proyecto Principal Cliente ID 8', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(8, 9, 'Proyecto Principal Cliente ID 9', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(9, 10, 'Proyecto Principal Cliente ID 10', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(10, 12, 'Proyecto Principal Cliente ID 12', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(11, 13, 'Proyecto Principal Cliente ID 13', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(12, 14, 'Proyecto Principal Cliente ID 14', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL),
	(13, 15, 'Proyecto Principal Cliente ID 15', NULL, 'En Relevamiento', NULL, '2025-08-14 04:09:46', NULL, '2025-08-24 19:26:55', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.recetas_despiece
DROP TABLE IF EXISTS `recetas_despiece`;
CREATE TABLE IF NOT EXISTS `recetas_despiece` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `tipologia_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Tipología", "optionsSource": {"endpoint": "tipologias", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `material_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Material", "optionsSource": {"endpoint": "materiales", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `descripcion_item` varchar(255) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Descripción del Ítem", "placeholder": "Ej: Perfil de jamba lateral"}',
  `formula_cantidad` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Fórmula Cantidad", "placeholder": "Ej: 2, $Dv"}',
  `formula_corte_ancho` varchar(255) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Fórmula Corte Ancho (X)", "placeholder": "Ej: $A + $c"}',
  `formula_corte_alto` varchar(255) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Fórmula Corte Alto (Y)", "placeholder": "Ej: $h / 2"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_recetas_despiece_tipologias` (`tipologia_id`),
  KEY `fk_recetas_despiece_materiales` (`material_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_recetas_despiece_creado_por` (`creado_por`),
  KEY `fk_recetas_despiece_modificado_por` (`modificado_por`),
  KEY `fk_recetas_despiece_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_recetas_despiece_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_recetas_despiece_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_recetas_despiece_materiales` FOREIGN KEY (`material_id`) REFERENCES `materiales` (`id`),
  CONSTRAINT `fk_recetas_despiece_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_recetas_despiece_tipologias` FOREIGN KEY (`tipologia_id`) REFERENCES `tipologias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "recetas_despiece", "label": "Ítem de Receta", "labelPlural": "Receta de Despiece", "actions": {"table": [{"label": "Añadir Material"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.recetas_despiece: ~151 rows (aproximadamente)
INSERT INTO `recetas_despiece` (`id`, `tipologia_id`, `material_id`, `descripcion_item`, `formula_cantidad`, `formula_corte_ancho`, `formula_corte_alto`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 2, 41, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(2, 2, 42, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(3, 2, 43, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(4, 2, 44, NULL, '2', '($A/2)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(5, 2, 45, NULL, '2', '($A/2)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(6, 2, 48, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(7, 2, 46, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(8, 2, 19, NULL, '2', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(9, 2, 9, NULL, '2', '($A*2)+($h*(2+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(10, 2, 10, NULL, '1', '(($A*2)+($h*2)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(11, 2, 16, NULL, '1', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(12, 2, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(13, 2, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(14, 2, 71, NULL, '2', '($A/2)x($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(15, 3, 41, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(16, 2, 15, NULL, '12', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(17, 2, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(18, 3, 42, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(19, 3, 43, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(20, 3, 44, NULL, '3', '($A/3)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(21, 3, 45, NULL, '3', '($A/3)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(22, 3, 48, NULL, '4', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(23, 3, 46, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(24, 3, 47, NULL, '1', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(25, 3, 19, NULL, '2', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(26, 3, 9, NULL, '2', '($A*2)+($h*(3+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(27, 3, 10, NULL, '1', '(($A*2)+($h*3)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(28, 3, 16, NULL, '1', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(29, 3, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(30, 3, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(31, 3, 15, NULL, '12', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(32, 3, 71, NULL, '3', '(($A/3))x(($h))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(33, 3, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(34, 4, 49, NULL, '2', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(35, 4, 49, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(36, 4, 50, NULL, '4', '((($A/2)+0.01)+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(37, 4, 50, NULL, '4', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(38, 4, 51, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(39, 4, 22, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(40, 4, 24, NULL, '1', '(2-1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(41, 4, 26, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(42, 4, 30, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(43, 4, 9, NULL, '2', '($A*2)+($h*(2+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(44, 4, 10, NULL, '1', '(($A*2)+($h*2)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(45, 4, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(46, 4, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(47, 4, 13, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(48, 4, 15, NULL, '15', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(49, 4, 71, NULL, '2', '(($A/2))x(($h))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(50, 4, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(51, 5, 49, NULL, '2', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(52, 5, 49, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(53, 5, 50, NULL, '6', '(($A/3)+$c)+.01', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(54, 5, 50, NULL, '6', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(55, 5, 51, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(56, 5, 22, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(57, 5, 59, NULL, '1', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(58, 5, 24, NULL, '1', '(3-1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(59, 5, 26, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(60, 6, 33, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(61, 5, 30, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(62, 5, 9, NULL, '2', '($A*2)+($h*(3+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(63, 5, 10, NULL, '1', '(($A*2)+($h*3)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(64, 5, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(65, 5, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(66, 5, 15, NULL, '12', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(67, 5, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(68, 5, 71, NULL, '3', '($A/3)x($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(69, 5, 13, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(70, 7, 41, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(71, 7, 42, NULL, '1', '($A+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(72, 7, 43, NULL, '2', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(73, 7, 44, NULL, '4', '($A/4)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(74, 7, 45, NULL, '4', '($A/4)+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(75, 7, 46, NULL, '4', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(76, 7, 47, NULL, '1', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(77, 7, 48, NULL, '4', '($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(78, 7, 9, NULL, '2', '($A*2)+($h*(4+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(79, 7, 10, NULL, '1', '(($A*2)+($h*4)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(80, 7, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(81, 7, 12, NULL, '40', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(82, 7, 13, NULL, '40', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(83, 7, 15, NULL, '20', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(84, 7, 16, NULL, '2', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(85, 7, 19, NULL, '4', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(86, 7, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(87, 7, 71, NULL, '4', '($A/4)x($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(88, 8, 4, NULL, '2', '($A)+($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(89, 8, 5, NULL, '2', '($A)+($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(90, 8, 6, NULL, '1', '$A', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(91, 8, 8, NULL, '1', '($A*2)+($h*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(92, 9, 66, NULL, '2', 'A', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(93, 9, 66, NULL, '2', 'H', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(94, 9, 13, NULL, '20', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(95, 9, 82, NULL, '4', 'x', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(96, 10, 60, NULL, '2', '$h', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(97, 10, 60, NULL, '2', '$A', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(98, 10, 61, NULL, '2', '$h', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(99, 10, 61, NULL, '2', '$A', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(100, 10, 63, NULL, '2', '$h+$A', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(101, 10, 9, NULL, '2', '($A*2)+($h*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(102, 10, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(103, 10, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(104, 10, 15, NULL, '12', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(105, 10, 14, NULL, '2', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(106, 10, 17, NULL, '1', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(107, 11, 60, NULL, '2', '$A+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(108, 11, 60, NULL, '2', '$h+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(109, 11, 63, NULL, '4', '$A+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(110, 11, 63, NULL, '2', '$h+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(111, 11, 62, NULL, '1', '$A+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(112, 11, 9, NULL, '1', '($A*4)+($h*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(113, 11, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(114, 11, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(115, 11, 15, NULL, '12', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(116, 11, 13, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(117, 11, 71, NULL, '2', '($h/2)x($A)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(118, 11, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(119, 11, 31, NULL, '6', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(120, 12, 69, NULL, '2', '($h*2)+($A*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(121, 12, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(122, 12, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(123, 15, 60, NULL, '2', '($A+$c)+($h+$c)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(124, 15, 67, NULL, '2', '((($A/2)+$c)*2+(($h+$c)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(125, 15, 70, NULL, '2', '((($A/2)+$c))*2+(($h+$c)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(126, 15, 9, NULL, '4', '((($A/2)+$c))*2+(($h+$c)*2)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(127, 15, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(128, 15, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(129, 15, 64, NULL, '4', '3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(130, 15, 71, NULL, '2', '($A/2)x($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(131, 15, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(132, 15, 17, NULL, '1', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(133, 15, 62, NULL, '1', '$A+$c', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(134, 14, 74, NULL, '1', '($A)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(135, 14, 75, NULL, '1', '($A)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(136, 14, 80, NULL, '1', '($A)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(137, 14, 79, NULL, '1', '($A)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(138, 14, 81, NULL, '2', '(3-1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(139, 14, 70, NULL, '2', '($h)+2', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(140, 14, 76, NULL, '1', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(141, 14, 9, NULL, '2', '($A*2)+($h*(3+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(142, 14, 78, NULL, '2', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(143, 14, 72, NULL, '1', '(($A+50)*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(144, 14, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(145, 14, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(146, 8, 71, NULL, '1', '($A)x($h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(147, 8, 12, NULL, '30', '1', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(148, 8, 11, NULL, '1', '($A*$h)/3', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(149, 8, 9, NULL, '2', '($A*2)+($h*(1+1))', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(150, 8, 21, NULL, '1', '(1)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL),
	(151, 8, 32, NULL, '1', '($A*$h)', NULL, NULL, '2025-08-24 19:27:53', NULL, '2025-08-24 19:27:53', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` mediumtext DEFAULT NULL,
  `nivel_jerarquia` int(11) NOT NULL,
  `creado_por` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `modificado_por` int(11) DEFAULT NULL,
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_by` int(11) DEFAULT NULL,
  `fecha_eliminacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_codigo_unico` (`codigo`),
  UNIQUE KEY `idx_nombre_unico` (`nombre`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_roles_creado_por` (`creado_por`),
  KEY `fk_roles_modificado_por` (`modificado_por`),
  KEY `fk_roles_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_roles_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_roles_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_roles_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla librosandinos_vitrales_v2.roles: ~15 rows (aproximadamente)
INSERT INTO `roles` (`id`, `codigo`, `nombre`, `descripcion`, `nivel_jerarquia`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'DEVELOPER', 'Desarrollador', 'Control total del sistema para desarrollo y mantenimiento.', 10000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(2, 'SUPERADMIN', 'SuperAdmin', 'Rol técnico/administrativo de alto nivel para gestión de la plataforma.', 9500, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(3, 'GERENTE_GENERAL', 'Gerente General', 'Visibilidad total de todos los módulos del negocio para la toma de decisiones.', 9000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(4, 'ADMINISTRADOR', 'Administrador', 'Gestiona usuarios, roles, permisos y catálogos maestros del sistema.', 8000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(5, 'JEFE_FINANZAS', 'Jefe de Finanzas', 'Supervisa la contabilidad, aprueba compras y gestiona la facturación.', 7500, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(6, 'JEFE_PRODUCCION', 'Jefe de Producción', 'Gestiona el flujo de trabajo de producción y las órdenes de trabajo.', 7000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(7, 'JEFE_VENTAS', 'Jefe de Ventas', 'Supervisa al equipo de ventas y sus proyectos.', 7000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(8, 'JEFE_LOGISTICA', 'Jefe de Compras/Logística', 'Gestiona proveedores, órdenes de compra e inventario.', 7000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(9, 'CONTADOR', 'Contador', 'Gestiona la facturación, pagos y registros contables diarios.', 5000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(10, 'COTIZADOR', 'Cotizador', 'Gestiona su cartera de clientes y genera cotizaciones.', 4000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(11, 'TECNICO_DE_CAMPO', 'Técnico de Campo', 'Realiza las mediciones finales de los vanos en obra.', 4000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(12, 'ENCARGADO_ALMACEN', 'Encargado de Almacén', 'Registra las entradas y salidas de material del inventario.', 3000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(13, 'OPERARIO_TALLER', 'Operario de Taller', 'Consulta y actualiza el estado de las tareas de producción asignadas.', 2000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(14, 'CLIENTE', 'Cliente', 'Accede a su portal personal para ver el estado de sus proyectos.', 1000, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(15, 'VISITANTE', 'Visitante', 'Rol por defecto para usuarios no autenticados.', 0, NULL, '2025-09-03 05:28:40', NULL, '2025-09-03 05:28:40', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.tipologias
DROP TABLE IF EXISTS `tipologias`;
CREATE TABLE IF NOT EXISTS `tipologias` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nombre` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Tipología"}',
  `familia_principal_id` int(11) DEFAULT NULL COMMENT '{"archetype": "SELECT_API", "title": "Familia Principal", "optionsSource": {"endpoint": "familias", "valueKey": "id", "labelKey": "nombre"}}',
  `num_divisiones_verticales` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "NUMBER", "title": "Divisiones Verticales", "defaultValue": 1}',
  `num_divisiones_horizontales` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "NUMBER", "title": "Divisiones Horizontales", "defaultValue": 1}',
  `num_hojas_moviles` int(11) NOT NULL DEFAULT 0 COMMENT '{"archetype": "NUMBER", "title": "Hojas Móviles", "defaultValue": 0}',
  `imagen_path` varchar(255) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Ruta de Imagen", "placeholder": "Ej: /images/disenos/L25-V-C-2-1-1.png"}',
  `notas_diseno` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Notas de Diseño"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_tipologias_familias` (`familia_principal_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_tipologias_creado_por` (`creado_por`),
  KEY `fk_tipologias_modificado_por` (`modificado_por`),
  KEY `fk_tipologias_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_tipologias_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_tipologias_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_tipologias_familias` FOREIGN KEY (`familia_principal_id`) REFERENCES `familias` (`id`),
  CONSTRAINT `fk_tipologias_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `chk_divisiones_positivas` CHECK (`num_divisiones_verticales` >= 1 and `num_divisiones_horizontales` >= 1)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "tipologias", "label": "Tipología", "labelPlural": "Tipologías", "actions": {"table": [{"label": "Nueva Tipología"}], "row": [{"label": "Editar Receta", "icon": "blender", "targetRoute": "/app/tipologias/{primaryKey}/receta"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.tipologias: ~15 rows (aproximadamente)
INSERT INTO `tipologias` (`id`, `nombre`, `familia_principal_id`, `num_divisiones_verticales`, `num_divisiones_horizontales`, `num_hojas_moviles`, `imagen_path`, `notas_diseno`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'FAMILIA STANDART', 15, 1, 1, 1, 'images/disenos/standar.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(2, 'Ventana corredera de dos divisiones verticales una fija y una movil Linea 25', 7, 2, 1, 1, 'images/disenos/L25-V-C-2-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(3, 'Ventana corredera de tres divisiones verticales dos fijas una movil Linea 25', 7, 3, 1, 1, 'images/disenos/L25-V-C-3-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(4, 'Ventana corredera dos divisiones verticales 1 hoja movil T45Lite', 17, 2, 1, 1, 'images/disenos/T45L-V-C-2-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(5, 'Ventana corredera de tres divisiones verticales dos fijas una movil T45 Lite', 17, 3, 1, 1, 'images/disenos/T45L-V-C-3-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(6, 'Ventana corredera de dos divisiones verticales una fija y una movil Linea 20', 6, 2, 1, 1, 'images/disenos/L20-V-C-2-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(7, 'Ventana corredera de 4 divisiones verticales dos fijas y dos moviles', 7, 4, 1, 2, 'images/disenos/L25-V-C-4-2-2.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(8, 'Puertas batientes Linea S-3000 de Una Hoja Vidrio 6mm', 13, 1, 1, 1, 'images/disenos/S300-P-B-1-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(9, 'Pre marcos con tubo 50 x 25', 20, 1, 1, 1, 'images/disenos/PM-T5025.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(10, 'Ventana Proyectante una hoja', 9, 1, 1, 1, 'images/disenos/L35-V-P-1-1-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(11, 'Ventana Paño Fijo Dos divisiones horizontales Linea 35', 9, 1, 2, 1, 'images/disenos/L35-V-F-1-2-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(12, 'Ventana paño fijo con canal de U', 2, 1, 1, 0, 'images/disenos/U-PF-1-1-0.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(13, 'Venatana corredera dos divisiones verticales con vidrio templado de 8mm', 22, 2, 1, 1, 'images/disenos/V-C-T8-1-2-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(14, 'Ventana corredera tres divisiones verticales con vidrio templado de 8mm', 22, 3, 1, 1, 'images/disenos/V-C-T8-1-3-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(15, 'Puerta Batiente dos divisiones verticales vidrio 6mm crudo', 9, 2, 1, 2, 'images/disenos/L35-PB-1-2-1.png', NULL, NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.ubicaciones
DROP TABLE IF EXISTS `ubicaciones`;
CREATE TABLE IF NOT EXISTS `ubicaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `proyecto_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Proyecto", "optionsSource": {"endpoint": "proyectos", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `piso` varchar(100) DEFAULT 'Planta Baja' COMMENT '{"archetype": "TEXT_GENERAL", "title": "Piso / Nivel", "placeholder": "Ej: Planta Baja, Piso Tipo"}',
  `departamento` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Departamento / Bloque", "placeholder": "Ej: Dpto A, Bloque B"}',
  `ambiente` varchar(100) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Ambiente", "placeholder": "Ej: Cocina, Sala"}',
  `referencia` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Referencia Adicional", "placeholder": "Ej: Fachada Oeste"}',
  `cantidad` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "NUMBER", "title": "Ubicaciones Iguales", "defaultValue": 1, "validation": {"required": true}}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_ubicaciones_proyectos` (`proyecto_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_ubicaciones_creado_por` (`creado_por`),
  KEY `fk_ubicaciones_modificado_por` (`modificado_por`),
  KEY `fk_ubicaciones_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_ubicaciones_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ubicaciones_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ubicaciones_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ubicaciones_proyectos` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_cantidad_positiva` CHECK (`cantidad` >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "ubicaciones", "label": "Ubicación", "labelPlural": "Ubicaciones", "defaultSortColumn": "piso", "actions": {"table": [{"label": "Nueva Ubicación"}], "row": [{"label": "Añadir Vanos", "targetRoute": "/app/ubicaciones/{primaryKey}/vanos"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.ubicaciones: ~0 rows (aproximadamente)

-- Volcando estructura para tabla librosandinos_vitrales_v2.unidades
DROP TABLE IF EXISTS `unidades`;
CREATE TABLE IF NOT EXISTS `unidades` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nombre` varchar(50) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Unidad"}',
  `abreviatura` varchar(10) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Abreviatura"}',
  `tipo` enum('Longitud','Superficie','Peso','Volumen','Cantidad','Conjunto') NOT NULL COMMENT '{"archetype": "SELECT_STATIC", "title": "Tipo de Unidad", "optionsSource": {"staticData": [{"value": "Longitud", "label": "Longitud"}, {"value": "Superficie", "label": "Superficie"}, {"value": "Peso", "label": "Peso"}, {"value": "Volumen", "label": "Volumen"}, {"value": "Cantidad", "label": "Cantidad"}, {"value": "Conjunto", "label": "Conjunto"}]}}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_abreviatura_unica` (`abreviatura`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_unidades_creado_por` (`creado_por`),
  KEY `fk_unidades_modificado_por` (`modificado_por`),
  KEY `fk_unidades_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_unidades_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_unidades_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_unidades_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "unidades", "label": "Unidad", "labelPlural": "Unidades", "actions": {"table": [{"label": "Nueva Unidad"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.unidades: ~11 rows (aproximadamente)
INSERT INTO `unidades` (`id`, `nombre`, `abreviatura`, `tipo`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'Metro Lineal', 'ml', 'Longitud', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(2, 'Metro Cuadrado', 'm2', 'Superficie', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(3, 'Pieza', 'pza', 'Cantidad', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(4, 'Kilogramo', 'kg', 'Peso', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(5, 'Tubo', 'tubo', 'Conjunto', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(6, 'Juego', 'jgo', 'Conjunto', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(7, 'Barra', 'Barra', 'Conjunto', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(8, 'Plancha', 'Plancha', 'Superficie', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(9, 'Caja', 'Caja', 'Conjunto', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(10, 'Unidad', 'Unidad', 'Cantidad', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL),
	(11, 'Metro', 'm', 'Longitud', NULL, '2025-08-24 19:27:52', NULL, '2025-08-24 19:27:52', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.usuarios
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `nick` varchar(50) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nick de Usuario"}',
  `password_hash` varchar(255) NOT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Contraseña", "inputType": "password", "visible": false, "showInEditForm": false, "showInCreateForm": true}',
  `email` varchar(100) DEFAULT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Email", "inputType": "email"}',
  `rol_id` int(11) NOT NULL DEFAULT 400 COMMENT '{"archetype": "SELECT_API", "title": "Rol de Usuario", "optionsSource": {"endpoint": "roles", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
  `activo` tinyint(1) NOT NULL DEFAULT 1 COMMENT '{"archetype": "CHECKBOX", "title": "Activo", "defaultValue": true}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_nick_unico` (`nick`),
  UNIQUE KEY `idx_email_unico` (`email`),
  KEY `fk_usuarios_roles` (`rol_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_usuarios_creado_por` (`creado_por`),
  KEY `fk_usuarios_modificado_por` (`modificado_por`),
  KEY `fk_usuarios_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_usuarios_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_usuarios_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_usuarios_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_usuarios_roles` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "CATALOGO_BASICO", "tableName": "usuarios", "label": "Usuario", "labelPlural": "Usuarios", "defaultSortColumn": "nick", "actions": {"table": [{"label": "Nuevo Usuario"}], "row": [{"label": "Ver Perfil", "targetRoute": "/app/usuarios/{primaryKey}/perfil"}, {"label": "Editar", "action": "openEditForm"}, {"label": "Eliminar", "action": "triggerDelete"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.usuarios: ~8 rows (aproximadamente)
INSERT INTO `usuarios` (`id`, `nick`, `password_hash`, `email`, `rol_id`, `activo`, `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `is_deleted`, `deleted_by`, `fecha_eliminacion`) VALUES
	(1, 'juanjito', '$argon2id$v=19$m=65536,t=4,p=1$dkR2azk1bUVHZTBpYmxqVw$N/CvLZtW23Ltr3H/VgUOmCqK5I4Jyk/+jPnyBfiSTXk', 'j_j_a_a74@hotmail.com', 1, 1, NULL, '2025-08-14 16:24:49', NULL, '2025-09-03 05:30:17', 0, NULL, NULL),
	(2, 'sadmin', '$argon2id$v=19$m=65536,t=4,p=1$NURYSy95WURUNy5ueExiZw$hLnmgCbAsXVuSjRmvkwE4vuGYKdHKbwsJB+BIkKeXaU', 'sadmin@vitrales.com', 2, 1, NULL, '2025-08-14 16:24:49', NULL, '2025-09-03 05:30:29', 0, NULL, NULL),
	(3, 'admin', '$argon2id$v=19$m=65536,t=4,p=1$OUNlTTYxZ1R0SXY1b0paWg$QqfEHPlLr235eBih8PZQ1gjlO2zKTi3+jZXybE+EJnA', 'admin@vitrales.com', 4, 1, NULL, '2025-08-14 16:24:49', NULL, '2025-09-03 05:28:40', 0, NULL, NULL),
	(4, 'jproduccion', '$argon2id$v=19$m=65536,t=4,p=1$NUZlRFUwL0pKYjg3b1E0Yg$0SSGOrA4gay+moADBG4Aa+Qed+SzyldlgJwXulLFskY', 'produccion@vitrales.com', 6, 1, NULL, '2025-08-24 19:29:14', NULL, '2025-09-03 05:30:50', 0, NULL, NULL),
	(5, 'vendedor', '$argon2id$v=19$m=65536,t=4,p=1$NUZlRFUwL0pKYjg3b1E0Yg$0SSGOrA4gay+moADBG4Aa+Qed+SzyldlgJwXulLFskY', 'vendedor@vitrales.com', 10, 1, NULL, '2025-08-24 19:29:14', NULL, '2025-09-03 05:31:01', 0, NULL, NULL),
	(6, 'tecnico', '$argon2id$v=19$m=65536,t=4,p=1$NUZlRFUwL0pKYjg3b1E0Yg$0SSGOrA4gay+moADBG4Aa+Qed+SzyldlgJwXulLFskY', 'tecnico@vitrales.com', 11, 1, NULL, '2025-08-24 19:29:14', NULL, '2025-09-03 05:31:09', 0, NULL, NULL),
	(7, 'cliente', '$argon2id$v=19$m=65536,t=4,p=1$NUZlRFUwL0pKYjg3b1E0Yg$0SSGOrA4gay+moADBG4Aa+Qed+SzyldlgJwXulLFskY', 'cliente@ejemplo.com', 14, 1, NULL, '2025-08-24 19:29:14', NULL, '2025-09-03 05:31:18', 0, NULL, NULL),
	(8, 'visitante', '$argon2id$v=19$m=65536,t=4,p=1$NUZlRFUwL0pKYjg3b1E0Yg$0SSGOrA4gay+moADBG4Aa+Qed+SzyldlgJwXulLFskY', 'visitante@ejemplo.com', 15, 1, NULL, '2025-08-25 05:51:00', NULL, '2025-09-03 05:31:26', 0, NULL, NULL);

-- Volcando estructura para tabla librosandinos_vitrales_v2.vanos
DROP TABLE IF EXISTS `vanos`;
CREATE TABLE IF NOT EXISTS `vanos` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
  `ubicacion_id` int(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Ubicación", "optionsSource": {"endpoint": "ubicaciones", "valueKey": "id", "labelKey": "ambiente"}, "validation": {"required": true}}',
  `codigo_vano` varchar(50) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Código del Vano", "placeholder": "Ej: V1, P1, Ventana Cocina"}',
  `ancho` decimal(10,4) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Ancho (m)", "validation": {"required": true}}',
  `alto` decimal(10,4) NOT NULL COMMENT '{"archetype": "NUMBER", "title": "Alto (m)", "validation": {"required": true}}',
  `cantidad` int(11) NOT NULL DEFAULT 1 COMMENT '{"archetype": "NUMBER", "title": "Vanos Iguales", "defaultValue": 1, "validation": {"required": true}}',
  `notas` text DEFAULT NULL COMMENT '{"archetype": "TEXTAREA", "title": "Notas"}',
  `creado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
  `modificado_por` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_modificacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '{"archetype": "SYSTEM_FLAG"}',
  `deleted_by` int(11) DEFAULT NULL COMMENT '{"archetype": "AUDIT_USER"}',
  `fecha_eliminacion` datetime DEFAULT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
  PRIMARY KEY (`id`),
  KEY `fk_vanos_ubicaciones` (`ubicacion_id`),
  KEY `idx_is_deleted` (`is_deleted`),
  KEY `fk_vanos_creado_por` (`creado_por`),
  KEY `fk_vanos_modificado_por` (`modificado_por`),
  KEY `fk_vanos_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_vanos_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_vanos_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_vanos_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_vanos_ubicaciones` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicaciones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_medidas_positivas` CHECK (`ancho` > 0 and `alto` > 0 and `cantidad` >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{"archetype": "ENTIDAD_PRINCIPAL", "tableName": "vanos", "label": "Vano", "labelPlural": "Vanos", "defaultSortColumn": "codigo_vano", "actions": {"table": [{"label": "Nuevo Vano"}]}}';

-- Volcando datos para la tabla librosandinos_vitrales_v2.vanos: ~0 rows (aproximadamente)

-- Volcando estructura para vista librosandinos_vitrales_v2.usuarios_all
DROP VIEW IF EXISTS `usuarios_all`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `usuarios_all` (
	`id` INT(11) NOT NULL COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
	`nick` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nick de Usuario"}' COLLATE 'utf8mb4_unicode_ci',
	`password_hash` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Contraseña", "inputType": "password", "visible": false, "showInEditForm": false, "showInCreateForm": true}' COLLATE 'utf8mb4_unicode_ci',
	`email` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Email", "inputType": "email"}' COLLATE 'utf8mb4_unicode_ci',
	`rol_id` INT(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Rol de Usuario", "optionsSource": {"endpoint": "roles", "valueKey": "id", "labelKey": "nombre"}, "validation": {"required": true}}',
	`activo` TINYINT(1) NOT NULL COMMENT '{"archetype": "CHECKBOX", "title": "Activo", "defaultValue": true}',
	`creado_por` INT(11) NULL COMMENT '{"archetype": "AUDIT_USER"}',
	`fecha_creacion` TIMESTAMP NOT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Creación"}',
	`modificado_por` INT(11) NULL COMMENT '{"archetype": "AUDIT_USER"}',
	`fecha_modificacion` TIMESTAMP NOT NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Última Modificación"}',
	`is_deleted` TINYINT(1) NOT NULL COMMENT '{"archetype": "SYSTEM_FLAG"}',
	`deleted_by` INT(11) NULL COMMENT '{"archetype": "AUDIT_USER"}',
	`fecha_eliminacion` DATETIME NULL COMMENT '{"archetype": "AUDIT_TIMESTAMP", "title": "Fecha Eliminación"}',
	`usuario_id` INT(11) NOT NULL COMMENT '{"archetype": "SELECT_API", "title": "Usuario", "isEditable": false, "optionsSource": {"endpoint": "usuarios", "valueKey": "id", "labelKey": "nick"}}',
	`nombres` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombres"}' COLLATE 'utf8mb4_unicode_ci',
	`apellidos` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Apellidos"}' COLLATE 'utf8mb4_unicode_ci',
	`cargo` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Cargo"}' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Volcando estructura para vista librosandinos_vitrales_v2.vista_materiales_completos
DROP VIEW IF EXISTS `vista_materiales_completos`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vista_materiales_completos` (
	`material_id` INT(11) NOT NULL COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
	`codigo_interno` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Código Interno"}' COLLATE 'utf8mb4_unicode_ci',
	`nombre_material` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Material"}' COLLATE 'utf8mb4_unicode_ci',
	`unidad_calculo` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Abreviatura"}' COLLATE 'utf8mb4_unicode_ci',
	`familia_id` INT(11) NOT NULL COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
	`nombre_familia` VARCHAR(1) NOT NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Familia"}' COLLATE 'utf8mb4_unicode_ci',
	`tipo_familia` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Tipo"}' COLLATE 'utf8mb4_unicode_ci',
	`producto_proveedor_id` INT(11) NULL COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
	`color` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_GENERAL", "title": "Color"}' COLLATE 'utf8mb4_unicode_ci',
	`precio` DECIMAL(12,4) NULL COMMENT '{"archetype": "NUMBER", "title": "Precio", "validation": {"required": true}}',
	`moneda` ENUM('Bs','USD') NULL COMMENT '{"archetype": "SELECT_STATIC", "title": "Moneda", "optionsSource": {"staticData": [{"value": "Bs", "label": "Bolivianos (Bs)"}, {"value": "USD", "label": "Dólares (USD)"}]}}' COLLATE 'utf8mb4_unicode_ci',
	`unidad_compra` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre de Unidad"}' COLLATE 'utf8mb4_unicode_ci',
	`dimension_compra` DECIMAL(10,4) NULL COMMENT '{"archetype": "NUMBER", "title": "Dimensión de Compra", "placeholder": "Ej: 6.0 para una barra de 6m"}',
	`es_preferido` TINYINT(1) NULL COMMENT '{"archetype": "CHECKBOX", "title": "Preferido"}',
	`proveedor_id` INT(11) NULL COMMENT '{"archetype": "PRIMARY_KEY", "title": "ID"}',
	`nombre_proveedor` VARCHAR(1) NULL COMMENT '{"archetype": "TEXT_REQUIRED", "title": "Nombre del Proveedor"}' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Volcando estructura para vista librosandinos_vitrales_v2.v_schema_con_checksum
DROP VIEW IF EXISTS `v_schema_con_checksum`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `v_schema_con_checksum` (
	`table_name` VARCHAR(1) NOT NULL COLLATE 'utf8_general_ci',
	`ultimo_cambio` DATETIME NULL,
	`schema_json_completo` LONGTEXT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Volcando estructura para procedimiento librosandinos_vitrales_v2.sp_add_audit_columns
DROP PROCEDURE IF EXISTS `sp_add_audit_columns`;
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` PROCEDURE `sp_add_audit_columns`(IN p_table_name VARCHAR(64))
BEGIN
    -- Define el COMMENT JSON estándar para todas las columnas de auditoría
    SET @json_comment = ' COMMENT ''{"visible": false, "isEditable": false}''';

    -- Construye y ejecuta la sentencia ALTER TABLE
    SET @sql = CONCAT(
        'ALTER TABLE `', p_table_name, '` ',
        'ADD COLUMN `creado_por` INT(11) NULL DEFAULT NULL', @json_comment, ' AFTER `id`, ',
        'ADD COLUMN `fecha_creacion` TIMESTAMP NOT NULL DEFAULT current_timestamp()', @json_comment, ' AFTER `creado_por`, ',
        'ADD COLUMN `modificado_por` INT(11) NULL DEFAULT NULL', @json_comment, ' AFTER `fecha_creacion`, ',
        'ADD COLUMN `fecha_modificacion` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()', @json_comment, ' AFTER `modificado_por`, ',
        'ADD COLUMN `is_deleted` TINYINT(1) NOT NULL DEFAULT 0', @json_comment, ' AFTER `fecha_modificacion`, ',
        'ADD COLUMN `deleted_by` INT(11) NULL DEFAULT NULL', @json_comment, ' AFTER `is_deleted`, ',
        'ADD COLUMN `fecha_eliminacion` DATETIME NULL DEFAULT NULL', @json_comment, ' AFTER `deleted_by`, ',
        'ADD INDEX `idx_is_deleted` (`is_deleted`), ',
        'ADD CONSTRAINT `fk_', p_table_name, '_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL, ',
        'ADD CONSTRAINT `fk_', p_table_name, '_modificado_por` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL, ',
        'ADD CONSTRAINT `fk_', p_table_name, '_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

-- Volcando estructura para procedimiento librosandinos_vitrales_v2.sp_move_audit_columns_to_end
DROP PROCEDURE IF EXISTS `sp_move_audit_columns_to_end`;
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` PROCEDURE `sp_move_audit_columns_to_end`(IN p_table_name VARCHAR(64))
BEGIN
    DECLARE last_business_column VARCHAR(64);

    -- Encontrar la última columna ANTES de las de auditoría
    SELECT COLUMN_NAME INTO last_business_column
    FROM information_schema.columns
    WHERE table_schema = DATABASE() 
      AND table_name = p_table_name 
      AND COLUMN_NAME NOT IN (
          'creado_por', 'fecha_creacion', 'modificado_por', 'fecha_modificacion', 
          'is_deleted', 'deleted_by', 'fecha_eliminacion'
      )
    ORDER BY ORDINAL_POSITION DESC
    LIMIT 1;

    -- Construir y ejecutar la sentencia ALTER TABLE para mover todas las columnas de auditoría
    -- Usamos MODIFY para cambiar la posición de la columna. Es importante re-declarar su tipo y atributos.
    SET @sql = CONCAT(
        'ALTER TABLE `', p_table_name, '` ',
        'MODIFY COLUMN `creado_por` INT(11) NULL DEFAULT NULL COMMENT ''{"visible": false, "isEditable": false}'' AFTER `', last_business_column, '`, ',
        'MODIFY COLUMN `fecha_creacion` TIMESTAMP NOT NULL DEFAULT current_timestamp() COMMENT ''{"visible": false, "isEditable": false}'' AFTER `creado_por`, ',
        'MODIFY COLUMN `modificado_por` INT(11) NULL DEFAULT NULL COMMENT ''{"visible": false, "isEditable": false}'' AFTER `fecha_creacion`, ',
        'MODIFY COLUMN `fecha_modificacion` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT ''{"visible": false, "isEditable": false}'' AFTER `modificado_por`, ',
        'MODIFY COLUMN `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT ''{"visible": false, "isEditable": false}'' AFTER `fecha_modificacion`, ',
        'MODIFY COLUMN `deleted_by` INT(11) NULL DEFAULT NULL COMMENT ''{"visible": false, "isEditable": false}'' AFTER `is_deleted`, ',
        'MODIFY COLUMN `fecha_eliminacion` DATETIME NULL DEFAULT NULL COMMENT ''{"visible": false, "isEditable": false}'' AFTER `deleted_by`;'
    );

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END//
DELIMITER ;

-- Volcando estructura para procedimiento librosandinos_vitrales_v2.sp_sync_schema
DROP PROCEDURE IF EXISTS `sp_sync_schema`;
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` PROCEDURE `sp_sync_schema`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(64);
    DECLARE tbl_comment TEXT;
    
    DECLARE cur_tables CURSOR FOR 
        SELECT table_name, table_comment 
        FROM information_schema.tables 
        WHERE table_schema = DATABASE() 
        AND table_type = 'BASE TABLE' 
        AND table_name NOT IN ('app_schema', 'historial_cambios', 'permisos');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET SESSION group_concat_max_len = 1000000;

    OPEN cur_tables;
    table_loop: LOOP
        FETCH cur_tables INTO tbl_name, tbl_comment;
        IF done THEN
            LEAVE table_loop;
        END IF;

        -- Paso 1: Construir la cadena de texto de las columnas
        SELECT 
            GROUP_CONCAT(
                CONCAT('"', COLUMN_NAME, '":', IFNULL(COLUMN_COMMENT, '{}'))
            ORDER BY ORDINAL_POSITION)
        INTO @columns_string
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tbl_name;

        -- Paso 2: Obtener el comentario de la tabla
        SET @table_comment_str = IF(tbl_comment = '' OR tbl_comment IS NULL, '{}', tbl_comment);
        
        -- Paso 3: Unir todo como cadenas de texto
        SET @final_json_string = CONCAT(
            SUBSTRING(@table_comment_str, 1, CHAR_LENGTH(@table_comment_str) - 1), -- Quita el '}' final
            ', "columns": {',
            IFNULL(@columns_string, ''),
            '}}'
        );

        -- Paso 4: Insertar o actualizar en app_schema
        INSERT INTO app_schema (table_name, schema_json, fecha_modificacion)
        VALUES (tbl_name, @final_json_string, NOW())
        ON DUPLICATE KEY UPDATE schema_json = @final_json_string, fecha_modificacion = NOW();

    END LOOP table_loop;
    CLOSE cur_tables;
END//
DELIMITER ;

-- Volcando estructura para disparador librosandinos_vitrales_v2.trg_after_cotizacion_detalle_delete
DROP TRIGGER IF EXISTS `trg_after_cotizacion_detalle_delete`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` TRIGGER `trg_after_cotizacion_detalle_delete` AFTER DELETE ON `cotizacion_detalle` FOR EACH ROW
BEGIN
    UPDATE cotizaciones 
    SET 
        total_costo = (SELECT SUM(costo_calculado) FROM cotizacion_detalle WHERE cotizacion_id = OLD.cotizacion_id),
        total_venta = (SELECT SUM(precio_venta) FROM cotizacion_detalle WHERE cotizacion_id = OLD.cotizacion_id)
    WHERE id = OLD.cotizacion_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador librosandinos_vitrales_v2.trg_after_cotizacion_detalle_insert
DROP TRIGGER IF EXISTS `trg_after_cotizacion_detalle_insert`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` TRIGGER `trg_after_cotizacion_detalle_insert` AFTER INSERT ON `cotizacion_detalle` FOR EACH ROW
BEGIN
    UPDATE cotizaciones 
    SET 
        total_costo = (SELECT SUM(costo_calculado) FROM cotizacion_detalle WHERE cotizacion_id = NEW.cotizacion_id),
        total_venta = (SELECT SUM(precio_venta) FROM cotizacion_detalle WHERE cotizacion_id = NEW.cotizacion_id)
    WHERE id = NEW.cotizacion_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador librosandinos_vitrales_v2.trg_after_cotizacion_detalle_update
DROP TRIGGER IF EXISTS `trg_after_cotizacion_detalle_update`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE DEFINER=`librosandinos_mysql`@`200.%.%.%` TRIGGER `trg_after_cotizacion_detalle_update` AFTER UPDATE ON `cotizacion_detalle` FOR EACH ROW
BEGIN
    UPDATE cotizaciones 
    SET 
        total_costo = (SELECT SUM(costo_calculado) FROM cotizacion_detalle WHERE cotizacion_id = NEW.cotizacion_id),
        total_venta = (SELECT SUM(precio_venta) FROM cotizacion_detalle WHERE cotizacion_id = NEW.cotizacion_id)
    WHERE id = NEW.cotizacion_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `usuarios_all`;
CREATE ALGORITHM=UNDEFINED DEFINER=`librosandinos_mysql`@`200.%.%.%` SQL SECURITY DEFINER VIEW `usuarios_all` AS select `usuarios`.`id` AS `id`,`usuarios`.`nick` AS `nick`,`usuarios`.`password_hash` AS `password_hash`,`usuarios`.`email` AS `email`,`usuarios`.`rol_id` AS `rol_id`,`usuarios`.`activo` AS `activo`,`usuarios`.`creado_por` AS `creado_por`,`usuarios`.`fecha_creacion` AS `fecha_creacion`,`usuarios`.`modificado_por` AS `modificado_por`,`usuarios`.`fecha_modificacion` AS `fecha_modificacion`,`usuarios`.`is_deleted` AS `is_deleted`,`usuarios`.`deleted_by` AS `deleted_by`,`usuarios`.`fecha_eliminacion` AS `fecha_eliminacion`,`perfiles_usuario`.`usuario_id` AS `usuario_id`,`perfiles_usuario`.`nombres` AS `nombres`,`perfiles_usuario`.`apellidos` AS `apellidos`,`perfiles_usuario`.`cargo` AS `cargo` from (`usuarios` join `perfiles_usuario` on(`usuarios`.`id` = `perfiles_usuario`.`usuario_id`))
;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vista_materiales_completos`;
CREATE ALGORITHM=UNDEFINED DEFINER=`librosandinos_mysql`@`200.%.%.%` SQL SECURITY DEFINER VIEW `vista_materiales_completos` AS select `m`.`id` AS `material_id`,`m`.`codigo_interno` AS `codigo_interno`,`m`.`nombre` AS `nombre_material`,`u_calc`.`abreviatura` AS `unidad_calculo`,`f`.`id` AS `familia_id`,`f`.`nombre` AS `nombre_familia`,`ft`.`nombre` AS `tipo_familia`,`pp`.`id` AS `producto_proveedor_id`,`pp`.`color` AS `color`,`pp`.`precio` AS `precio`,`pp`.`moneda` AS `moneda`,`u_compra`.`nombre` AS `unidad_compra`,`pp`.`dimension_compra` AS `dimension_compra`,`pp`.`es_preferido` AS `es_preferido`,`prov`.`id` AS `proveedor_id`,`prov`.`nombre` AS `nombre_proveedor` from ((((((`materiales` `m` join `familias` `f` on(`m`.`familia_id` = `f`.`id`)) join `unidades` `u_calc` on(`m`.`unidad_calculo_id` = `u_calc`.`id`)) left join `familia_tipos` `ft` on(`f`.`familia_tipo_id` = `ft`.`id`)) left join `productos_proveedor` `pp` on(`m`.`id` = `pp`.`material_id`)) left join `proveedores` `prov` on(`pp`.`proveedor_id` = `prov`.`id`)) left join `unidades` `u_compra` on(`pp`.`unidad_compra_id` = `u_compra`.`id`))
;

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `v_schema_con_checksum`;
CREATE ALGORITHM=UNDEFINED DEFINER=`librosandinos_mysql`@`200.%.%.%` SQL SECURITY DEFINER VIEW `v_schema_con_checksum` AS select `T`.`TABLE_NAME` AS `table_name`,`T`.`UPDATE_TIME` AS `ultimo_cambio`,json_object('tableName',`T`.`TABLE_NAME`,'tableComment',json_extract(`T`.`TABLE_COMMENT`,'$'),'columns',coalesce(`C`.`columns_json`,json_object())) AS `schema_json_completo` from (`information_schema`.`TABLES` `T` left join (select `information_schema`.`COLUMNS`.`TABLE_NAME` AS `TABLE_NAME`,json_objectagg(`information_schema`.`COLUMNS`.`COLUMN_NAME`,json_extract(`information_schema`.`COLUMNS`.`COLUMN_COMMENT`,'$')) AS `columns_json` from `information_schema`.`COLUMNS` where `information_schema`.`COLUMNS`.`TABLE_SCHEMA` = database() group by `information_schema`.`COLUMNS`.`TABLE_NAME`) `C` on(`T`.`TABLE_NAME` = `C`.`TABLE_NAME`)) where `T`.`TABLE_SCHEMA` = database()
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
