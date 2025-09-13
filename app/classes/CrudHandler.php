<?php
// /app/classes/CrudHandler.php

declare(strict_types=1);

class CrudHandler
{
	private ApiDataBase $db;
	private int $userId;
	private int $rolId;
	private array $permissions_fallback;

	public function __construct(ApiDataBase $db, int $userId = 0, int $rolId = 0)
	{
		$this->db = $db;
		$this->userId = $userId;
		$this->rolId = $rolId;
		$this->permissions_fallback = require(dirname(__DIR__, 2) . '/config/permissions.php');
	}

	private function getVisibilityRule(string $tableName): ?array
	{
		// 1. Buscar primero en la base de datos
		$sql = "SELECT regla_json FROM permisos WHERE rol_id = ? AND tabla_afectada = ? AND tipo_regla = 'visibility' AND is_active = 1";
		$result = $this->db->query($sql, [$this->rolId, $tableName]);

		if (!empty($result)) {
			return json_decode($result[0]['regla_json'], true);
		}

		// 2. Si no hay nada, buscar en el archivo de fallback
		return $this->permissions_fallback[$tableName]['visibility_rules'][$this->rolId] ?? null;
	}

	private function buildWhereClauseForRule(?array $rule): array
	{
		if (is_null($rule)) {
			return ['sql' => '', 'params' => []];
		}

		if (is_callable($rule)) {
			return ['sql' => $rule($this->userId, $this->db), 'params' => []];
		}

		$params = [];
		$sqlClause = '';

		$ruleJson = json_encode($rule);
		$ruleJson = str_replace('"{userId}"', (string)$this->userId, $ruleJson);
		$rule = json_decode($ruleJson, true);

		switch ($rule['type'] ?? '') {
			case 'field_match':
				$sqlClause = "`{$rule['field']}` = ?";
				$params[] = $rule['value'];
				break;

			case 'deny_all':
				$sqlClause = "1 = 0";
				break;

			case 'subquery':
				// Nota: Soporta un nivel de subconsulta por ahora.
				$sub = $rule['subquery'];
				$sqlClause = sprintf(
					"`%s` %s (SELECT `%s` FROM `%s` WHERE `%s` = ?)",
					$rule['field'],
					$rule['operator'],
					$sub['select_field'],
					$sub['from_table'],
					$sub['where']['field']
				);
				$params[] = $sub['where']['value'];
				break;
		}

		return ['sql' => $sqlClause, 'params' => $params];
	}

	public function handleGetList(string $tableName): void
	{
		$sql = "SELECT * FROM `{$tableName}` WHERE is_deleted = 0";
		$params = [];

		$rule = $this->getVisibilityRule($tableName);
		$clauseResult = $this->buildWhereClauseForRule($rule);

		if (!empty($clauseResult['sql'])) {
			$sql .= " AND " . $clauseResult['sql'];
			$params = array_merge($params, $clauseResult['params']);
		}

		$data = $this->db->query($sql, $params);
		$this->jsonResponse(200, $data);
	}

	public function handleGetSingle(string $tableName, int $id): void
	{
		// Podríamos añadir lógica de permisos aquí también, para asegurar que el usuario puede ver este registro específico.
		$sql = "SELECT * FROM `{$tableName}` WHERE id = ? AND is_deleted = 0";
		$data = $this->db->query($sql, [$id]);
		if (empty($data)) {
			$this->jsonResponse(404, ['error' => 'Registro no encontrado.']);
		}
		$this->jsonResponse(200, $data[0]);
	}

	public function handleCreate(string $tableName, array $data): void
	{
		unset($data['id']);

		foreach ($data as $key => &$value) {
			if ($value === '') {
				$value = null;
			}
		}

		$data['creado_por'] = $this->userId;
		$data['modificado_por'] = $this->userId;

		$columns = array_keys($data);
		$placeholders = array_fill(0, count($columns), '?');

		$sql = sprintf("INSERT INTO `%s` (`%s`) VALUES (%s)", $tableName, implode('`, `', $columns), implode(', ', $placeholders));
		$params = array_values($data);

		try {
			$newId = $this->db->executeAndGetId($sql, $params);
			if ($newId) {
				$newData = $this->db->query("SELECT * FROM `{$tableName}` WHERE id = ?", [$newId]);
				$this->jsonResponse(201, $newData[0]);
			} else {
				$this->jsonResponse(500, ['error' => 'No se pudo crear el registro.']);
			}
		} catch (Exception $e) {
			if (str_contains($e->getMessage(), 'Duplicate entry')) {
				$this->jsonResponse(409, ['error' => 'Conflicto: ya existe un registro con datos similares.']);
			}
			$this->jsonResponse(500, ['error' => 'Error de base de datos.', 'details' => $e->getMessage()]);
		}
	}

	public function handleUpdate(string $tableName, int $id, array $data): void
	{
		unset($data['id'], $data['creado_por'], $data['fecha_creacion']);

		$data['modificado_por'] = $this->userId;

		foreach ($data as $key => &$value) {
			if ($value === '') {
				$value = null;
			}
		}

		$setParts = [];
		foreach (array_keys($data) as $column) {
			$setParts[] = "`{$column}` = ?";
		}

		$sql = sprintf("UPDATE `%s` SET %s WHERE id = ? AND is_deleted = 0", $tableName, implode(', ', $setParts));
		$params = array_values($data);
		$params[] = $id;

		$affectedRows = $this->db->executeAndGetAffectedRows($sql, $params);
		if ($affectedRows >= 0) { // >= 0 para manejar el caso en que se guarde sin cambios
			$updatedData = $this->db->query("SELECT * FROM `{$tableName}` WHERE id = ?", [$id]);
			$this->jsonResponse(200, $updatedData[0]);
		} else {
			$this->jsonResponse(500, ['error' => 'No se pudo actualizar el registro.']);
		}
	}

	public function handleDelete(string $tableName, int $id): void
	{
		// TODO: Implementar la anulación de campos UNIQUE
		$sql = "UPDATE `{$tableName}` SET is_deleted = 1, deleted_by = ?, fecha_eliminacion = NOW() WHERE id = ? AND is_deleted = 0";
		$params = [$this->userId, $id];
		$affectedRows = $this->db->executeAndGetAffectedRows($sql, $params);

		if ($affectedRows > 0) {
			$this->jsonResponse(204, null);
		} else {
			$this->jsonResponse(404, ['error' => 'Registro no encontrado o ya eliminado.']);
		}
	}

	private function jsonResponse(int $code, $data): void
	{
		http_response_code($code);
		if ($data !== null) {
			echo json_encode($data, JSON_UNESCAPED_UNICODE);
		}
		exit();
	}
}