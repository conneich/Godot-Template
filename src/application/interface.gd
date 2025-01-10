extends Node

var _hud_layer: Node = null
var _menu_layer: Node = null
var _modal_layer: Node = null
var _prompt_layer: Node = null

const info_modal_duration: float = 1.2
const important_modal_duration: float = 4.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _has_children(node: Control) -> bool:
	if node.get_child_count() > 0:
		return true
	return false


func set_hud_layer(layer_node: Node) -> void:
	_hud_layer = layer_node

func set_menu_layer(layer_node: Node) -> void:
	_menu_layer = layer_node

func set_modal_layer(layer_node: Node) -> void:
	_modal_layer = layer_node

func set_prompt_layer(layer_node: Node) -> void:
	_prompt_layer = layer_node


func add_hud(hud: PackedScene):
	_hud_layer.add_child(hud.instantiate())

func add_menu(menu: PackedScene):
	_menu_layer.add_child(menu.instantiate())

func add_modal(modal: PackedScene):
	var timer = Timer.new()
	timer.timeout.connect(func timeout(): pop_modal())
	
	var modal_ref = modal.instantiate()
	modal_ref.add_child(timer)
	
	_modal_layer.add_child(modal_ref)
	timer.start(0.77)

func add_prompt(prompt: PackedScene):
	_prompt_layer.add_child(prompt.instantiate())

func pop_menu():
	if not _has_children(_menu_layer):
		return
	
	_menu_layer.get_child(0).queue_free()

func pop_modal():
	if not _has_children(_modal_layer):
		return
	
	_modal_layer.get_child(0).queue_free()

func pop_prompt():
	if not _has_children(_prompt_layer):
		return
	
	_prompt_layer.get_child(0).queue_free()

func clear_hud():
	if not _has_children(_hud_layer):
		return
	
	for c: Control in _hud_layer.get_children():
		c.set_visible(false)
		c.queue_free()

func clear_menus():
	if not _has_children(_menu_layer):
		return
	
	for c: Control in _menu_layer.get_children():
		c.set_visible(false)
		c.queue_free()

func clear_modals():
	if not _has_children(_modal_layer):
		return
	
	for c: Control in _modal_layer.get_children():
		c.set_visible(false)
		c.queue_free()

func clear_prompts():
	if not _has_children(_prompt_layer):
		return
	
	for c: Control in _prompt_layer.get_children():
		c.set_visible(false)
		c.queue_free()
