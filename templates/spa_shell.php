<?php
session_start();
// /templates/spa_shell.php
?>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Vitrales v2 - Sistema de Cotizaciones</title>
	<link rel="stylesheet" href="/css/style.css">
</head>
<body>

	<header>
		<h1>Sistema de Cotizaciones Vitrales v2</h1>
		<div><?PHP //print_r($_SESSION);?></div>
		<div id="user-info">
			<!-- El botón de login/logout y el nombre de usuario se generan aquí -->
		</div>
	</header>

	<nav id="main-nav">
		<!-- El menú principal se genera aquí dinámicamente -->
	</nav>

	<!-- Contenedor principal que cambiará de contenido -->
	<main id="app-container">
		<!-- Aquí se renderizará el login o el contenido principal (tablas, etc.) -->
	</main>

	<!-- Contenedor para el Modal de Formularios -->
	<div id="modal-container" class="modal-hidden">
		<div id="modal-content">
			<!-- El formulario dinámico se renderizará aquí -->
		</div>
	</div>

	<footer>
		<p>&copy; <?= date('Y') ?> - Vitrales</p>
	</footer>

	<!-- IMPORTANTE: El script se carga como 'module' para habilitar import/export -->
	<script type="module" src="/js/app.js"></script>

</body>
</html>