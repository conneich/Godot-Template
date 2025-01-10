extends Resource
class_name InputSettings

@export var Settings: Dictionary

@export var Keymap: Dictionary

func get_settings() -> Dictionary:
	return Settings

func get_keymap() -> Dictionary:
	return Keymap

func save_data(settings: Dictionary, keymap: Dictionary):
	Settings = settings
	Keymap = keymap
