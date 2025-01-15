extends Node

# Input Key Map
var Keymap: Dictionary
var Settings: Dictionary


var _using_controller: bool = false
var _last_action: Dictionary = {}

func _ready():
	set_process_input(true)
	
	_last_action["key"] = ""
	_last_action["start"] = -1

func check(version: StringName) -> bool:
	if not Settings.has("Version"):
		return false
	print("Input::Check -  Settings Version:  " + Settings["Version"])
	return Settings["Version"] == version

func set_default():
	Settings = get_default_settings()

func set_keymap_default():
	Keymap = get_project_default_keymapping()

func load_settings():
	if FileAccess.file_exists(Game.input_settings_path):
		var input_res = ResourceLoader.load(Game.input_settings_path)
		if (input_res and input_res.has_method("get_keymap")):
			Settings = input_res.get_settings()
			Keymap = input_res.get_keymap()
			_apply_input()
			return
	
	Keymap = get_project_default_keymapping()
	Settings = get_default_settings()
	save_settings()

func save_settings():
	var input_res = InputSettings.new()
	input_res.save_data(Settings, Keymap)
	ResourceSaver.save(input_res, Game.input_settings_path)

func get_project_default_keymapping():
	# Loading keymap from project settings
	var default_map = {}
	
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		default_map[action] = []
		for event in events:
			default_map[action].append(event)
	return default_map

func get_default_settings() -> Dictionary:
	var default_settings = {}
	
	##TODO: Update on game version change
	default_settings["Version"] = "0.0.1"
	
	default_settings["InvertLook"] = false
	
	return default_settings


func get_action_value(key: String) -> float:
	if key in Keymap.keys() and Input.is_action_pressed(key):
		return Input.get_action_raw_strength(key)
	return 0.0

func get_action_just_pressed(key: String) -> bool:
	if key in Keymap.keys() and Input.is_action_just_pressed(key):
		_set_last_action(key)
		return true
	return false

func get_is_action_held(key: String) -> bool:
	return key in Keymap.keys() and Input.is_action_pressed(key)

func get_action_held_duraction(key: String) -> float:
	if key == _last_action["key"] and get_is_action_held(key):
		return _get_last_action_duration()
	return -1

func get_action_just_released(key: String) -> bool:
	if key in Keymap.keys() and Input.is_action_just_released(key):
		_set_last_action()
		return true
	return false

func _set_last_action(key: String = ""):
	if not key in Keymap.keys():
		return
	
	if key == "":
		_last_action["key"] = ""
		_last_action["start"] = -1
		return
	
	_last_action["key"] = key
	_last_action["start"] = Time.get_ticks_msec()

func _get_last_action() -> String:
	return _last_action["key"]

func _get_last_action_duration() -> float:
	if _last_action["key"] == "":
		return -1
	
	return Time.get_ticks_msec() - _last_action["start"]

func _apply_input():
	# Clear existing input map
	for action in InputMap.get_actions():
		InputMap.erase_action(action)
	
	#Apply loaded key mappings
	for action_name in Keymap.keys():
		InputMap.add_action(action_name)
		for event in Keymap[action_name]:
			InputMap.action_add_event(action_name, event)

func set_controller(new_setting: bool):
	_using_controller = new_setting


func _input(event: InputEvent):
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action) and event.is_pressed():
			SignalBus.emit_signal("input_action_triggered", action, "pressed")
		if Input.is_action_just_released(action):
			SignalBus.emit_signal("input_action_triggered", action, "released")
