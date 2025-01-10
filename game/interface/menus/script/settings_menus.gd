extends MarginContainer

const GAMEPLAY_TAB: int = 0
const GRAPHICS_TAB: int = 1
const AUDIO_TAB: int    = 2
const INPUT_TAB: int    = 3
const KEYMAP_TAB: int   = 4


var current_btn: BaseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_btn = %Gameplay_btn


func _on_gameplay_btn_toggled(_toggled_on: bool) -> void:
	if current_btn != %Gameplay_btn:
		current_btn = %Gameplay_btn
		save_settings_tab(%SettingTabs.get_current_tab())
		%SettingTabs.set_current_tab(GAMEPLAY_TAB)
		%SettingTabs.get_current_tab_control().refresh_settings()


func _on_graphics_btn_toggled(_toggled_on: bool) -> void:
	if current_btn != %Graphics_btn:
		current_btn = %Graphics_btn
		save_settings_tab(%SettingTabs.get_current_tab())
		%SettingTabs.set_current_tab(GRAPHICS_TAB)
		%SettingTabs.get_current_tab_control().refresh_settings()


func _on_audio_btn_toggled(_toggled_on: bool) -> void:
	if current_btn != %Audio_btn:
		current_btn = %Audio_btn
		save_settings_tab(%SettingTabs.get_current_tab())
		%SettingTabs.set_current_tab(AUDIO_TAB)
		%SettingTabs.get_current_tab_control().refresh_settings()


func _on_input_btn_toggled(_toggled_on: bool) -> void:
	if current_btn != %Input_btn:
		current_btn = %Input_btn
		%SettingTabs.set_current_tab(INPUT_TAB)
		%SettingTabs.get_current_tab_control().refresh_settings()


func _on_back_btn_pressed() -> void:
	save_settings_tab(%SettingTabs.get_current_tab())
	Interface.pop_menu()

func save_settings_tab(tab: int) -> void:
	match(tab):
		GAMEPLAY_TAB: save_gameplay_settings()
		GRAPHICS_TAB: save_graphics_settings()
		AUDIO_TAB:    save_audio_settings()
		INPUT_TAB:    save_input_settings()
		KEYMAP_TAB:   return

func save_gameplay_settings() -> void:
	Game.save_settings()

func save_graphics_settings() -> void:
	Graphics.save_settings()

func save_audio_settings() -> void:
	Audio.save_settings()

func save_input_settings() -> void:
	GameInput.save_settings()


func _on_default_btn_pressed() -> void:
	default_settings_tab(%SettingTabs.get_current_tab())

func default_settings_tab(tab: int):
	match(tab):
		GAMEPLAY_TAB: Game.set_default()
		GRAPHICS_TAB: Graphics.set_default()
		AUDIO_TAB:    Audio.set_default()
		INPUT_TAB:    GameInput.set_default()
		KEYMAP_TAB:   return
	%SettingTabs.get_current_tab_control().refresh_settings()
