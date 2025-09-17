<?php
// /config/config.php

// Fichero de configuración para la base de datos vitrales_v2
// Es recomendable mover este archivo fuera del directorio público en un entorno de producción.

define('DB_HOST', '[DB_HOST]');
define('DB_USER', '[DB_USER]');
define('DB_PASS', '[DB_PASS]');
define('DB_NAME', '[DB_NAME]');

// (Opcional) Para mostrar errores detallados en el backend durante el desarrollo
// En producción, esto debería ser 'production' o estar comentado.
// getenv('APP_ENV') es una forma segura de leer variables de entorno del servidor.
// define('APP_ENV', getenv('APP_ENV') ?: 'production');