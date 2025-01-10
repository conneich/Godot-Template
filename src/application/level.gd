extends Node

#Path to the loading screen scene
var _loading_screen_scene: PackedScene
var _level_node: Node = null

# Node reference for the loading screen
var _loading_scene_instance: Node = null

#Current loading state
var _loading: bool = false
var _progress: float = 0.0
var _description: String = ""
var _level_path: String = ""

func set_level_node(node: Node) -> void:
	_level_node = node

func load_level(level_path: String):
	"""
	Asynchronously load a new level, displaying a loading screen until progress is finished
	"""
	
	if _loading:
		push_error("Already loading a level. Wait until the current operation completes.")
		return
	
	_loading = true
	_progress = 0.0
	_description = "Preparing to load level..."
	SignalBus.emit_signal("loading_progress", _progress, _description)
	
	#TODO: Uncomment once loading screen is ready
	# Show loading screen
	#if _loading_screen_scene:
	#	_loading_scene_instance = _loading_screen_scene.instantiate()
	#	get_tree().root.add_child(_loading_scene_instance)
	
	# Start the loading coroutine
	_start_async_loading(level_path)

func _start_async_loading(level_path: String):
	var loader = ResourceLoader.load_threaded_request(level_path)
	if loader:
		push_error("Failed to load level.")
		_finish_loading()
		return
	_level_path = level_path
	
	_description = "Starting level loading..."
	SignalBus.emit_signal("loading_progress", _progress, _description)

func _process_loading():
	var step_result = ResourceLoader.load_threaded_get_status(_level_path, [_progress])
	_description = "Loading..."
	if step_result == ResourceLoader.THREAD_LOAD_LOADED:
		# Loading completed successfully
		_progress = 1.0
		_description = "Loading completed"
		SignalBus.emit_signal("loading_progress", _progress, _description)
		
		var new_scene = ResourceLoader.load_threaded_get(_level_path)
		_finish_loading(new_scene)
		return
	elif step_result == ResourceLoader.THREAD_LOAD_FAILED or step_result == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		# Handle errors during loading
		push_error("Failed to load level at path: " + _level_path)
		_finish_loading()
		return
	else:
		SignalBus.emit_signal("loading_progress", _progress, _description)
	

func _finish_loading(scene: PackedScene = null):
	# Hide and remove the loading screen if it exists
	if _loading_scene_instance:
		_loading_scene_instance.queue_free()
		_loading_scene_instance = null
		
	# Transtion to the loaded scene
	if scene:
		for nodes in _level_node.get_children():
			nodes.queue_free()
		
		_level_node.add_child(scene.instantiate())
	
	_loading = false
	_progress = 0.0
	_description = ""
	_level_path = ""

func is_loading() -> bool:
	return _loading

func get_progress() -> float:
	return _progress

func get_description() -> String:
	return _description

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	if _loading:
		_process_loading()
