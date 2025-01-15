extends Node

# TODO: Set game dimension type
const GAME_IS_3D: bool = false
const GAME_VERSION: Dictionary = {
	"major": 0,
	"minor": 0,
	"build": 1
}

enum ApplicationState {
	Initializing,
	Running,
	Paused,
	Loading,
	Stopping
}

enum GameAudioBus {
	Master = 0,
	Music,
	Ambient,
	SFX,
	Dialog
}

enum EventType {
	Misc
}

enum FocusState {
	GameOnly,
	GameAndUI,
	UIOnly
}

const SupportedScreenSizes: Dictionary = {
	"640x480":   Vector2i(640,  480),
	"800x600":   Vector2i(800,  600),
	"1024x768":  Vector2i(1024, 768),
	"1280x720":  Vector2i(1280, 720),
	"1280x800":  Vector2i(1280, 800),
	"1366x768":  Vector2i(1366, 768),
	"1440x900":  Vector2i(1440, 900),
	"1680x1050": Vector2i(1680, 1050),
	"1760x990":  Vector2i(1760, 990),
	"1920x1080": Vector2i(1920, 1080),
	"1920x1200": Vector2i(1920, 1200),
	"2560x1440": Vector2i(2560, 1440),
	"2560x1600": Vector2i(2560, 1600),
	"3072x1728": Vector2i(3072, 1728),
	"3200x1800": Vector2i(3200, 1800),
	"3840x2160": Vector2i(3840, 2160),
}

const SupportedRenderQuality: Array = [
	{"text": "Ultra",   "value": 0.77},
	{"text": "High",    "value": 0.67},
	{"text": "Medium",  "value": 0.59},
	{"text": "Low",     "value": 0.50}
]
