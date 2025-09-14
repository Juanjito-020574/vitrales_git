<?php
// /app/classes/ApiDataBase.php

declare(strict_types=1);

class ApiDataBase {
	private mysqli $connection;

	private accion_my=null;
	//Esta es la función constructora para ApiDataBase
	// Sigue
	public function __construct(string $host, string $user, string $pass, string $name) {
		// Reporta errores de MySQL como excepciones de PHP
		mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

		try {
			$this->connection = new mysqli($host, $user, $pass, $name);
			$this->connection->set_charset('utf8mb4');
		} catch (mysqli_sql_exception $e) {
			// Maneja el error de conexión de forma más controlada
			// En un entorno de producción, loguear el error en lugar de mostrarlo.
			throw new Exception("Error de conexión a la base de datos: " . $e->getMessage());
		}
	}

	/**
	 * Ejecuta una consulta SELECT y devuelve un array de resultados.
	 * @param string $sql La sentencia SQL con '?' como placeholders.
	 * @param array $params Los parámetros para la sentencia preparada.
	 * @return array Los resultados como un array asociativo.
	 */
	public function query(string $sql, array $params = []): array {
		$stmt = $this->connection->prepare($sql);
		if ($params) {
			// 's' es el tipo más seguro y genérico, mysqli lo convierte si es necesario.
			$types = str_repeat('s', count($params));
			$stmt->bind_param($types, ...$params);
		}
		$stmt->execute();
		$result = $stmt->get_result();
		$data = $result->fetch_all(MYSQLI_ASSOC);
		$stmt->close();
		return $data;
	}

	/**
	 * Ejecuta una sentencia INSERT, UPDATE, o DELETE. (Método original)
	 * @param string $sql La sentencia SQL con '?' como placeholders.
	 * @param array $params Los parámetros para la sentencia preparada.
	 * @return bool True si la ejecución fue exitosa, false si no.
	 */
	public function execute(string $sql, array $params = []): bool {
		$stmt = $this->connection->prepare($sql);
		if (!empty($params)) {
			$types = str_repeat('s', count($params));
			$stmt->bind_param($types, ...$params);
		}
		$success = $stmt->execute();
		$stmt->close();
		return $success;
	}

	// ¡NUEVO! Similar a execute, pero devuelve el ID del nuevo registro para operaciones INSERT.
	public function executeAndGetId(string $sql, array $params = []): int {
		$stmt = $this->connection->prepare($sql);
		if (!empty($params)) {
			$types = str_repeat('s', count($params));
			$stmt->bind_param($types, ...$params);
		}
		$stmt->execute();
		$newId = $this->connection->insert_id;
		$stmt->close();
		return (int)$newId;
	}

	// ¡NUEVO! Similar a execute, pero devuelve el número de filas afectadas para UPDATE y DELETE.
	public function executeAndGetAffectedRows(string $sql, array $params = []): int {
		$stmt = $this->connection->prepare($sql);
		if (!empty($params)) {
			$types = str_repeat('s', count($params));
			$stmt->bind_param($types, ...$params);
		}
		$stmt->execute();
		$affectedRows = $stmt->affected_rows;
		$stmt->close();
		return $affectedRows;
	}

	/**
	 * Crea un hash de contraseña seguro.
	 * @param string $password La contraseña en texto plano.
	 * @return string El hash de la contraseña.
	 */
	public function hashPassword(string $password): string {
		return password_hash($password, PASSWORD_ARGON2ID);
	}

	/**
	 * Verifica una contraseña en texto plano contra un hash.
	 * @param string $password La contraseña en texto plano.
	 * @param string $hashedPassword El hash guardado en la base de datos.
	 * @return bool True si la contraseña es correcta, false si no.
	 */
	public function verifyPassword(string $password, string $hashedPassword): bool {
		return password_verify($password, $hashedPassword);
	}

	// Cierra la conexión al destruir el objeto.
	public function __destruct() {
		// Usamos isset para evitar errores si la conexión falló en el constructor.
		if (isset($this->connection)) {
			$this->connection->close();
		}
	}
}