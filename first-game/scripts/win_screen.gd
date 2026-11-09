extends Control

@onready var coins_label: Label = $Center/Info/Coins
@onready var bonus_label: Label = $Center/Info/Bonus


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var counts := GameState.get_total_coin_counts()
	coins_label.text = "Monedas recogidas: %d / %d" % [counts.x, counts.y]
	bonus_label.visible = GameState.all_coins_collected()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		GameState.reset_run()
		get_tree().change_scene_to_file("res://scenes/game.tscn")
