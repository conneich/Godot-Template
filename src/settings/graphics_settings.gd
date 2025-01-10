extends Resource
class_name GraphicsSettings

@export var Settings: Dictionary

func get_data() -> Dictionary:
	return Settings

func save_data(data: Dictionary):
	Settings = data
