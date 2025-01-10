extends Node


var Settings: Dictionary = {}


func _ready() -> void:
	pass

func check(version: StringName) -> bool:
	if not Settings.has("Version"):
		push_error("Settings didn't have a version field!")
		return false
	print("Audio::Check -  Settings Version:  " + Settings["Version"])
	return Settings["Version"] == version


func get_volume(bus_idx: int) -> float:
	var volume: float = 0.0
	match bus_idx:
		Globals.GameAudioBus.Master:   volume = db_to_linear(Settings["Master"])
		Globals.GameAudioBus.Music:    volume = db_to_linear(Settings["Music"])
		Globals.GameAudioBus.Ambient:  volume = db_to_linear(Settings["Ambient"])
		Globals.GameAudioBus.SFX:      volume = db_to_linear(Settings["SFX"])
		Globals.GameAudioBus.Dialog:   volume = db_to_linear(Settings["Dialog"])
	return volume

func set_volume(bus_idx: int, volume: float):
	clamp(volume, 0.0, 1.0)
	match bus_idx:
		Globals.GameAudioBus.Master:   Settings["Master"]  = linear_to_db(volume)
		Globals.GameAudioBus.Music:    Settings["Music"]   = linear_to_db(volume)
		Globals.GameAudioBus.Ambient:  Settings["Ambient"] = linear_to_db(volume)
		Globals.GameAudioBus.SFX:      Settings["SFX"]     = linear_to_db(volume)
		Globals.GameAudioBus.Dialog:   Settings["Dialog"]  = linear_to_db(volume)
	apply_settings()

func set_default():
	Settings = get_default_settings()

func load_settings():
	if FileAccess.file_exists(Game.audio_settings_path):
		var audio_settings_res = ResourceLoader.load(Game.audio_settings_path)
		
		if audio_settings_res and audio_settings_res.has_method("get_data"):
			Settings = audio_settings_res.get_data()
			apply_settings()
			return
	Settings = get_default_settings()
	save_settings()

func save_settings():
	var audio_settings_res = AudioSettings.new()
	audio_settings_res.save_data(Settings)
	ResourceSaver.save(audio_settings_res, Game.audio_settings_path)

func apply_settings():
	AudioServer.set_bus_volume_db(Globals.GameAudioBus.Master,  Settings["Master"])
	AudioServer.set_bus_volume_db(Globals.GameAudioBus.Music,   Settings["Music"])
	AudioServer.set_bus_volume_db(Globals.GameAudioBus.Ambient, Settings["Ambient"])
	AudioServer.set_bus_volume_db(Globals.GameAudioBus.SFX,     Settings["SFX"])
	AudioServer.set_bus_volume_db(Globals.GameAudioBus.Dialog,  Settings["Dialog"])

func get_default_settings() -> Dictionary:
	var default_settings: Dictionary = {}
	
	##TODO: Update on game version
	default_settings["Version"] = "0.0.1"
	
	default_settings["Master"]   = linear_to_db(0.7)
	default_settings["Music"]    = linear_to_db(1.0)
	default_settings["Ambient"]  = linear_to_db(1.0)
	default_settings["SFX"]      = linear_to_db(1.0)
	default_settings["Dialog"]   = linear_to_db(1.0)
	
	return default_settings
