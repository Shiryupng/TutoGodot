extends Node

signal coins_changed

# Guarda el punto de reaparición del jugador entre recargas de escena.
var checkpoint_position := Vector2.ZERO
var checkpoint_scene := ""

# Monedas por nivel: { ruta_escena: { "total": {ruta_moneda: true}, "collected": {...} } }
var _level_coins := {}


func set_checkpoint(scene_path: String, position: Vector2) -> void:
	checkpoint_scene = scene_path
	checkpoint_position = position


func clear_checkpoint() -> void:
	checkpoint_scene = ""
	checkpoint_position = Vector2.ZERO


# Registra una moneda del nivel. Devuelve true si ya había sido recogida
# (por ejemplo, al recargar la escena después de morir).
func register_coin(scene_path: String, coin_path: String) -> bool:
	if scene_path == "":
		return false

	var info: Dictionary = _level_coins.get(scene_path, {})
	if info.is_empty():
		info = {"total": {}, "collected": {}}
		_level_coins[scene_path] = info

	info["total"][coin_path] = true
	coins_changed.emit()
	return info["collected"].has(coin_path)


func collect_coin(scene_path: String, coin_path: String) -> void:
	if scene_path == "":
		return

	var info: Dictionary = _level_coins.get(scene_path, {})
	if info.is_empty():
		info = {"total": {}, "collected": {}}
		_level_coins[scene_path] = info

	info["collected"][coin_path] = true
	coins_changed.emit()


# Devuelve (recogidas, total) del nivel indicado.
func get_level_coin_counts(scene_path: String) -> Vector2i:
	var info: Dictionary = _level_coins.get(scene_path, {})
	if info.is_empty():
		return Vector2i.ZERO
	return Vector2i(info["collected"].size(), info["total"].size())


# Devuelve (recogidas, total) de toda la partida.
func get_total_coin_counts() -> Vector2i:
	var collected := 0
	var total := 0
	for info in _level_coins.values():
		collected += info["collected"].size()
		total += info["total"].size()
	return Vector2i(collected, total)


func all_coins_collected() -> bool:
	var counts := get_total_coin_counts()
	return counts.y > 0 and counts.x >= counts.y


# Empieza una partida nueva: borra checkpoint y monedas.
func reset_run() -> void:
	clear_checkpoint()
	_level_coins.clear()
	coins_changed.emit()
