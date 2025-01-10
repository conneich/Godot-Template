extends Node

@export_category("Interface Nodes")
@export var hud_layer: Node
@export var menu_layer: Node
@export var modal_layer: Node
@export var prompt_layer: Node

@export_category("Main Nodes")
@export var systems_node: Node
@export var playerstate_node: Node
@export var level_node: Node

@export_category("Menus")
@export_file("*.tscn") var main_menu_scene_path: String = ""
@export_file("*.tscn") var settings_scene_path: String = ""

@export_category("Settings")
@export_file("*.tres") var audio_settings_path: String = ""
@export_file("*.tres") var input_settings_path: String = ""
@export_file("*.tres") var graphics_settings_path: String = ""
@export_file("*.tres") var gameplay_settings_path: String = ""

func load_assets():
	return true


func _ready():
	SignalBus.emit_signal("main_ready", self)
