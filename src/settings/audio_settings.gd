extends Resource
class_name AudioSettings

@export var _settings: Dictionary

func get_data():
	return _settings

func save_data(data: Dictionary):
	_settings = data
