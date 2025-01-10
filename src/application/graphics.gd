extends Node

var Settings: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func check(version: StringName) -> bool:
	if not Settings.has("Version"):
		return false
	print("Graphics::Check -  Settings Version:  " + Settings["Version"])
	return Settings["Version"] == version

func set_screen_size(width: int, height: int):
	Settings["ScreenSize"] = Vector2i(width, height)
	apply_settings()

func set_fullscreen(enabled: bool):
	Settings["Fullscreen"] = enabled
	apply_settings()

func set_vsync(enabled: bool):
	Settings["Vsync"] = enabled
	apply_settings()
	
func set_antialiasing(option: String):
	if option in ["MSAA_2X", "MSAA_4X", "MSAA_8X", "OFF"]:
		Settings["AntiAliasing"] = option
		apply_settings()

# Will come from a render quality options box which can just pass in the selected option
func set_render_quality(scale: int):
	Settings["RenderQuality"] = Globals.SupportedRenderQuality[scale - 1]["value"]
	apply_settings()

func set_default():
	Settings = get_default_settings()

func load_settings():
	if FileAccess.file_exists(Game.graphics_settings_path):
		var graphics_res = ResourceLoader.load(Game.graphics_settings_path)
		if graphics_res and graphics_res.has_method("get_data"):
			Settings = graphics_res.get_data()
			return
	Settings = get_default_settings()
	save_settings()

func save_settings():
	var graphics_res = GraphicsSettings.new()
	graphics_res.save_data(Settings)
	ResourceSaver.save(graphics_res, Game.graphics_settings_path)

func apply_settings():
	Engine.set_max_fps(Settings["FPS"])
	# TODO:  Impl. the rest of the modes
	if Settings["Fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		#https://www.youtube.com/watch?v=NY5ZkBSGpEA
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Settings["ScreenSize"])
	# TODO: Impl. the rest of the options
	if Settings["Vsync"]:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	_apply_antialiasing(Settings["AntiAliasing"])
	_apply_texture_quality(Settings["RenderQuality"])

func _apply_antialiasing(option: String):
	"""
	Applies the selected anti-aliasing option.
	"""
	match option:
		"MSAA_2X":
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 2)
			if Globals.GAME_IS_3D:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 2)
		"MSAA_4X":
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 4)
			if Globals.GAME_IS_3D:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 4)
		"MSAA_8X":
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 8)
			if Globals.GAME_IS_3D:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 8)
		"OFF":
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 0)
			if Globals.GAME_IS_3D:
				ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)

func _apply_texture_quality(scale: float):
	#TODO: Apply texture quality
	pass

func get_default_settings() -> Dictionary:
	var default_settings = {}
	
	##TODO:  Update on game version update
	default_settings["Version"] = "0.0.1"
	
	default_settings["ScreenSize"]     = Globals.SupportedScreenSizes["1280x720"]
	default_settings["FPS"]            = 60
	default_settings["Fullscreen"]     = false
	default_settings["Vsync"]          = true
	default_settings["AntiAliasing"]   = "MSAA_2X"
	default_settings["RenderMode"]     = RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2
	default_settings["RenderQuality"]  = 0.77  # Ultra Quality
	
	return default_settings
