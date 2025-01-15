extends Node


var event_queue: Array
var listeners: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enqueue_event.connect(_enqueue_event)
	SignalBus.add_event_listener.connect(_add_listener)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.app_state in [Globals.ApplicationState.Initializing, 
		Globals.ApplicationState.Stopping, 
		Globals.ApplicationState.Loading]:
		return
	
	#TODO: Put this on its own thread
	if not event_queue.is_empty():
		_process_event(_pop_event())

func _process_event(event):
	for listener in listeners[event["type"]][event["id"]]:
		listener.receive_event(event["data"])

func _enqueue_event(type: Globals.EventType, id: StringName, data):
	event_queue.append({"type": type, "id": id, "data": data})

func _add_listener(listener: Node, event_type: Globals.EventType, event_id: StringName):
	listeners[event_type][event_id].append(listener)

func _pop_event():
	return event_queue.pop_front()
