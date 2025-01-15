extends Node

## Game is called last in the AutoLoad Globals
## This should mean all other Global scripts are active
## and set up.

# Game Variables
var app_state :Globals.ApplicationState = Globals.ApplicationState.Initializing
var focus_state: Globals.FocusState = Globals.FocusState.GameAndUI

# Settings
var Settings: Dictionary

var audio_settings_path: String
var graphics_settings_path: String
var input_settings_path: String
var game_settings_path: String


#  Scene References
var _main_scene: Node
var _settings_scene: PackedScene

# Save Game References
var _save_game_list: Array[String]
var _save_game_slot: int = -1


###   Public Methods   ###
func get_game_version_str() -> StringName:
	return str(Globals.GAME_VERSION["major"]) + "." + \
		   str(Globals.GAME_VERSION["minor"]) + "." + \
		   str(Globals.GAME_VERSION["build"])


# Save Game Methods
func get_save_game_slot() -> int:
	return _save_game_slot

func is_save_game_loaded() -> bool:
	return _save_game_slot >= 0

func has_saves() -> bool:
	return _save_game_list.size() > 0

# Settings Methods
func load_settings():
	if FileAccess.file_exists(game_settings_path):
		var game_res = ResourceLoader.load(game_settings_path)
		if game_res and game_res.has_method("get_data"):
			Settings = game_res.get_data()
			return
	Settings = _get_default_settings()
	save_settings()

func save_settings():
	var game_res = GameplaySettings.new()
	game_res.save_data(Settings)
	ResourceSaver.save(game_res, game_settings_path)

func set_setting(key: String, value) ->void:
	if not Settings.has(key):
		print("Gameplay Settings:  Couldn't find key '" + key + "' in settings.")
		return
	Settings[key] = value

func get_setting(key: String):
	if not Settings.has(key):
		print("Gameplay Settings:  Couldn't find key '" + key + "' in settings.")
		return null
	return Settings[key]



func get_settings_scene() -> PackedScene:
	return _settings_scene

func shutdown_application() -> void:
	_set_state(Globals.ApplicationState.Stopping)
	
	#TODO: Save current game state data
	get_tree().quit()



# Private Methods
func _ready() -> void:
	#TODO: Uncomment on release
	#This disables Godot handling a call for the window to close
	#allowing us to call custom logic before shutdown.
	#get_tree().set_auto_accept_quit(false)
	_set_state(Globals.ApplicationState.Initializing)
	
	SignalBus.main_ready.connect(_on_main_ready)
	SignalBus.set_input_mode.connect(_on_input_mode_changed)

func _on_main_ready(main_node: Node) -> void:
	_set_state(Globals.ApplicationState.Loading)
	_main_scene = main_node
	
	#if not _main_scene:
	#	push_error("Unable to find 'Main' scene. Force loading...")
	#	_main_scene = (load("res://entry.tscn") as PackedScene).instantiate()
	#	get_tree().root.add_child.call_deferred(_main_scene)
	
	## Settings ##
	_settings_scene = (ResourceLoader.load(_main_scene.settings_scene_path) as PackedScene)
	audio_settings_path    = _main_scene.audio_settings_path
	graphics_settings_path = _main_scene.graphics_settings_path
	input_settings_path    = _main_scene.input_settings_path
	game_settings_path     = _main_scene.gameplay_settings_path 
	
	Audio.load_settings()
	Graphics.load_settings()
	GameInput.load_settings()
	load_settings()
	
	#TODO: Handle a bad start
	if not _assert_settings_loaded():
		push_error("Failed to initialize application settings. Shutting down!")
		shutdown_application()
	
	
	# Setup Interface
	Interface.set_hud_layer(_main_scene.hud_layer)
	Interface.set_menu_layer(_main_scene.menu_layer)
	Interface.set_modal_layer(_main_scene.modal_layer)
	Interface.set_prompt_layer(_main_scene.prompt_layer)
	
	# Setup Level
	Level.set_level_node(_main_scene.level_node)
	
	# May not need?
	#await _main_scene.load_assets()
	
	_load_save_game_list()
	
	Level.load_level(_main_scene.main_menu_scene_path)
	
	_set_state(Globals.ApplicationState.Running)
	
	
func _on_input_mode_changed(mode: Globals.FocusState):
	focus_state = mode

func _set_state(new_state: Globals.ApplicationState):
	print("App State Changed:\nOld - " + str(app_state) + "\nNew - " + str(new_state))
	app_state = new_state
	
	# If the application is paused, we should disable any AI
	# logic, timing events, etc. This should not affect initialization
	# loading, or stopping application processes.
	if app_state == Globals.ApplicationState.Running:
		SignalBus.emit_signal("application_running")
	else:
		SignalBus.emit_signal("application_paused")

## Each Settings file will have a Version field.
## This Version field should match with the current
## Game Version
func _assert_settings_loaded() -> bool:
	return (Audio and Audio.check(get_game_version_str())) and \
		   (GameInput and GameInput.check(get_game_version_str())) and \
		   (Graphics and Graphics.check(get_game_version_str())) and \
		   _check_settings()

func _load_save_game_list() -> void:
	if has_saves():
		_save_game_list.clear()
	
	if DirAccess.dir_exists_absolute("res://game/saves/"):
		var _packed_string_array = DirAccess.get_files_at("res://game/saves/")
		for file in _packed_string_array:
			_save_game_list.append(file)

func _get_default_settings() -> Dictionary:
	var settings: Dictionary = {}
	
	settings["Version"]       = "0.0.1"
	settings["TestSetting"]   = false
	
	
	return settings

func _check_settings() -> bool:
	return Settings.has("Version") and Settings["Version"] == get_game_version_str()
