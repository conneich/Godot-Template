extends MarginContainer

func _ready():
	refresh_settings()

func refresh_settings():
	%GS_TestSetting_btn.set_pressed(Game.get_setting("TestSetting"))

func _on_gs_test_setting_btn_toggled(toggled_on: bool) -> void:
	Game.set_setting("TestSetting", toggled_on)
