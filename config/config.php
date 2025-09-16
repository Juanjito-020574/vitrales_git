<?php
// /config/config.php

// Fichero de configuración para la base de datos vitrales_v2
// Es recomendable mover este archivo fuera del directorio público en un entorno de producción.

define('DB_HOST', '72.29.64.235');
define('DB_USER', 'librosandinos_mysql');
define('DB_PASS', 'mysql_2019');
define('DB_NAME', 'librosandinos_vitrales_v2');

// (Opcional) Para mostrar errores detallados en el backend durante el desarrollo
// En producción, esto debería ser 'production' o estar comentado.
// getenv('APP_ENV') es una forma segura de leer variables de entorno del servidor.
// define('APP_ENV', getenv('APP_ENV') ?: 'production');