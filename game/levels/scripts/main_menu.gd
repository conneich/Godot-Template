extends Control

@onready var continue_btn: Button = $VBoxContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Continue_btn
@onready var load_game_btn_2: Button = $VBoxContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/LoadGame_btn2


func set_continue_btn_enabled(value: bool) -> void:
	continue_btn.set_enabled(value)

func set_load_game_btn_enabled(value: bool) -> void:
	load_game_btn_2.set_enabled(value)


func _on_quit_btn_pressed() -> void:
	Game.shutdown_application()


func _on_continue_btn_pressed() -> void:
	if not continue_btn.enabled:
		return


func _on_new_game_btn_pressed() -> void:
	pass # Replace with function body.


func _on_load_game_btn_2_pressed() -> void:
	if not load_game_btn_2.enabled:
		return


func _on_settings_btn_pressed() -> void:
	Interface.add_menu(Game._settings_scene)
