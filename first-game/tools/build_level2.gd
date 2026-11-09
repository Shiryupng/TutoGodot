extends SceneTree

# Generador del nivel 2. Ejecutar con:
# godot --headless --path . --script res://tools/build_level2.gd

const TILE := 16
const GRASS_TOP := Vector2i(0, 0)
const DIRT := Vector2i(0, 1)
const DIRT_CRACKED := Vector2i(0, 2)

var game_scene: PackedScene
var player_scene: PackedScene
var coin_scene: PackedScene
var slime_scene: PackedScene
var purple_slime_scene: PackedScene
var killzone_scene: PackedScene
var platform_scene: PackedScene
var moving_platform_scene: PackedScene
var crumbling_platform_scene: PackedScene
var checkpoint_scene: PackedScene
var goal_scene: PackedScene

var level_root: Node2D
var platforms: Node2D
var coins: Node2D
var enemies: Node2D
var checkpoints: Node2D


func _initialize() -> void:
	game_scene = load("res://scenes/game.tscn")
	player_scene = load("res://scenes/player.tscn")
	coin_scene = load("res://scenes/coin.tscn")
	slime_scene = load("res://scenes/slime.tscn")
	purple_slime_scene = load("res://scenes/slime_purple.tscn")
	killzone_scene = load("res://scenes/killzone.tscn")
	platform_scene = load("res://scenes/platform.tscn")
	moving_platform_scene = load("res://scenes/moving_platform.tscn")
	crumbling_platform_scene = load("res://scenes/crumbling_platform.tscn")
	checkpoint_scene = load("res://scenes/checkpoint.tscn")
	goal_scene = load("res://scenes/level_goal.tscn")

	build_level()
	quit()


func build_level() -> void:
	level_root = Node2D.new()
	level_root.name = "Level2"
	level_root.set_script(load("res://scripts/level2.gd"))

	add_sky()
	add_tilemap()
	add_killzone()

	platforms = add_group("Platforms")
	coins = add_group("Coins")
	enemies = add_group("Enemies")
	checkpoints = add_group("Checkpoints")

	# Islas principales: [x, y_superficie, ancho, profundidad]
	add_island(0, 12, 12, 4)
	add_island(16, 12, 7, 4)
	add_island(27, 10, 7, 5)
	add_island(40, 10, 7, 4)
	add_island(58, 8, 9, 5)
	add_island(73, 3, 7, 4)
	add_island(103, 2, 8, 4)
	add_island(130, -2, 8, 4)
	add_island(150, 0, 9, 4)
	add_island(182, -5, 8, 4)

	# Plataformas simples (una sola dirección).
	add_platform(114, 1, "PlatformZigZag1")
	add_platform(118, -1, "PlatformZigZag2")
	add_platform(122, 1, "PlatformZigZag3")
	add_platform(126, -1, "PlatformZigZag4")

	add_platform(163, -2, "PlatformFinal1")
	add_platform(168, -4, "PlatformFinal2")
	add_platform(173, -1, "PlatformFinal3")
	add_platform(178, -4, "PlatformFinal4")

	# Plataformas móviles.
	add_moving_platform(49, 10, Vector2(8, 0), 2.6, 0.6, "MovingPlatformHorizontal")
	add_moving_platform(70, 9, Vector2(0, -6), 2.8, 0.8, "MovingPlatformVertical")
	add_moving_platform(141, -2, Vector2(7, 0), 3.2, 0.6, "MovingPlatformFinal")

	# Plataformas que se desmoronan.
	add_crumbling_platform(84, 3, "CrumblingPlatform1")
	add_crumbling_platform(89, 4, "CrumblingPlatform2")
	add_crumbling_platform(94, 2, "CrumblingPlatform3")
	add_crumbling_platform(99, 3, "CrumblingPlatform4")

	# Monedas.
	add_coin(6, 10)
	add_coin(9, 9)
	add_coin(19, 10)
	add_coin(30, 8)
	add_coin(43, 8)
	add_coin(61, 6)
	add_coin(65, 5)
	add_coin(76, 1)
	add_coin(85, 2)
	add_coin(90, 1)
	add_coin(95, 1)
	add_coin(100, 0)
	add_coin(105, 0)
	add_coin(114, -1)
	add_coin(118, -3)
	add_coin(122, -1)
	add_coin(126, -3)
	add_coin(134, -4)
	add_coin(137, -4)
	add_coin(144, -4)
	add_coin(152, -2)
	add_coin(157, -2)
	add_coin(163, -4)
	add_coin(168, -6)
	add_coin(173, -3)
	add_coin(178, -6)
	add_coin(188, -7)

	# Enemigos. Los morados son más rápidos.
	add_slime(20, 12, false, "SlimeGreen1")
	add_slime(31, 10, false, "SlimeGreen2")
	add_slime(44, 10, false, "SlimeGreen3")
	add_slime(62, 8, true, "SlimePurple1")
	add_slime(77, 3, false, "SlimeGreen4")
	add_slime(108, 2, false, "SlimeGreen5")
	add_slime(133, -2, true, "SlimePurple2")
	add_slime(153, 0, false, "SlimeGreen6")
	add_slime(157, 0, true, "SlimePurple3")

	# Checkpoints.
	add_checkpoint(42, 10, "Checkpoint1")
	add_checkpoint(105, 2, "Checkpoint2")
	add_checkpoint(136, -2, "Checkpoint3")
	add_checkpoint(155, 0, "Checkpoint4")

	add_goal(186, -5, "res://scenes/win.tscn")
	add_player(Vector2(40, 172))

	# Las conexiones internas de las escenas instanciadas se vuelven a crear al cargarlas.
	# Si se dejan activas, PackedScene las guarda duplicadas en el nivel.
	disconnect_all_signals(level_root)
	assign_owners(level_root)

	var packed := PackedScene.new()
	var error := packed.pack(level_root)
	if error != OK:
		push_error("No se pudo empaquetar el nivel: %s" % error_string(error))
		return

	error = ResourceSaver.save(packed, "res://scenes/level2.tscn")
	if error != OK:
		push_error("No se pudo guardar el nivel: %s" % error_string(error))
		return

	print("Nivel 2 generado: %d plataformas, %d monedas, %d enemigos, %d checkpoints." % [
		platforms.get_child_count(), coins.get_child_count(), enemies.get_child_count(), checkpoints.get_child_count()
	])

	level_root.free()


# Asigna dueño a los nodos creados desde código para que se guarden en la escena.
func assign_owners(node: Node) -> void:
	for child in node.get_children():
		if child.owner == null:
			child.owner = level_root
		assign_owners(child)


func disconnect_all_signals(node: Node) -> void:
	for signal_info in node.get_signal_list():
		var signal_name: StringName = signal_info.name
		for connection in node.get_signal_connection_list(signal_name):
			node.disconnect(signal_name, connection.callable)
	for child in node.get_children():
		disconnect_all_signals(child)


func add_group(group_name: String) -> Node2D:
	var group := Node2D.new()
	group.name = group_name
	level_root.add_child(group)
	return group


func add_sky() -> void:
	var sky := Polygon2D.new()
	sky.name = "Sky"
	sky.polygon = PackedVector2Array([
		Vector2(-400, -500),
		Vector2(3600, -500),
		Vector2(3600, 700),
		Vector2(-400, 700),
	])
	sky.color = Color(0.055, 0.075, 0.15, 1.0)
	sky.z_index = -100
	level_root.add_child(sky)


func add_tilemap() -> void:
	var source_game := game_scene.instantiate()
	var source_tilemap: TileMap = source_game.get_node("TileMap")
	var tile_set: TileSet = source_tilemap.tile_set

	var tilemap := TileMap.new()
	tilemap.name = "TileMap"
	tilemap.tile_set = tile_set
	tilemap.z_index = -10

	while tilemap.get_layers_count() > 0:
		tilemap.remove_layer(0)
	tilemap.add_layer(-1)
	tilemap.set_layer_name(0, "background")
	tilemap.add_layer(-1)
	tilemap.set_layer_name(1, "mid")

	level_root.add_child(tilemap)

	# Fondo: mismo patrón visual que el nivel 1, extendido a todo el nivel.
	for x in range(-10, 200):
		for y in range(-15, 23):
			tilemap.set_cell(0, Vector2i(x, y), 0, background_atlas(y))

	source_game.free()


func background_atlas(y: int) -> Vector2i:
	if y <= -9:
		return Vector2i(0, 9)
	if y == -8:
		return Vector2i(0, 10)
	if y <= 0:
		return Vector2i(0, 11)
	if y == 1:
		return Vector2i(0, 12)
	if y <= 6:
		return Vector2i(0, 13)
	if y == 7:
		return Vector2i(0, 14)
	return Vector2i(0, 15)


func add_island(x: int, top_y: int, width: int, depth: int) -> void:
	var tilemap: TileMap = level_root.get_node("TileMap")
	for cell_x in range(x, x + width):
		for cell_y in range(top_y, top_y + depth):
			var atlas := GRASS_TOP
			if cell_y == top_y + depth - 1:
				atlas = DIRT_CRACKED
			elif cell_y > top_y:
				atlas = DIRT
			tilemap.set_cell(1, Vector2i(cell_x, cell_y), 0, atlas)


func add_killzone() -> void:
	var killzone := killzone_scene.instantiate()
	killzone.name = "Killzone"
	killzone.position = Vector2(95 * TILE, 290)

	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	collision.shape = WorldBoundaryShape2D.new()
	killzone.add_child(collision)

	level_root.add_child(killzone)


func add_platform(center_x: int, top_y: int, node_name: String) -> void:
	var platform := platform_scene.instantiate()
	platform.name = node_name
	platform.position = Vector2(center_x * TILE, top_y * TILE + 5)
	platforms.add_child(platform)


func add_moving_platform(center_x: int, top_y: int, travel: Vector2, duration: float, wait_time: float, node_name: String) -> void:
	var platform = moving_platform_scene.instantiate()
	platform.name = node_name
	platform.position = Vector2(center_x * TILE, top_y * TILE + 5)
	platform.travel = travel * TILE
	platform.duration = duration
	platform.wait_time = wait_time
	platforms.add_child(platform)


func add_crumbling_platform(center_x: int, top_y: int, node_name: String) -> void:
	var platform = crumbling_platform_scene.instantiate()
	platform.name = node_name
	platform.position = Vector2(center_x * TILE, top_y * TILE + 5)
	platforms.add_child(platform)


func add_coin(tile_x: int, tile_y: int) -> void:
	var coin := coin_scene.instantiate()
	coin.name = "Coin%d" % (coins.get_child_count() + 1)
	coin.position = Vector2(tile_x * TILE + 8, tile_y * TILE + 8)
	coins.add_child(coin)


func add_slime(tile_x: int, top_y: int, purple: bool, node_name: String) -> void:
	var slime = purple_slime_scene.instantiate() if purple else slime_scene.instantiate()
	slime.name = node_name
	slime.position = Vector2(tile_x * TILE + 8, top_y * TILE - 12)
	enemies.add_child(slime)


func add_checkpoint(tile_x: int, top_y: int, node_name: String) -> void:
	var checkpoint := checkpoint_scene.instantiate()
	checkpoint.name = node_name
	checkpoint.position = Vector2(tile_x * TILE + 8, top_y * TILE)
	checkpoints.add_child(checkpoint)


func add_goal(tile_x: int, top_y: int, next_scene: String) -> void:
	var goal := goal_scene.instantiate()
	goal.name = "Goal"
	goal.position = Vector2(tile_x * TILE + 8, top_y * TILE - 40)
	goal.next_scene = next_scene
	level_root.add_child(goal)


func add_player(spawn_position: Vector2) -> void:
	var player := player_scene.instantiate()
	player.name = "Player"
	player.position = spawn_position

	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = Vector2(-1, 4)
	camera.zoom = Vector2(4, 4)
	camera.limit_left = -16
	camera.limit_right = 196 * TILE
	camera.limit_top = -220
	camera.limit_bottom = 330
	camera.limit_smoothed = true
	camera.position_smoothing_enabled = true
	player.add_child(camera)

	level_root.add_child(player)
