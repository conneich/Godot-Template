extends Node


var event_queue: Array
var listeners: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enqueue_event.connect(_enqueue_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enqueue_event(event):
	pass

func _pop_event():
	return event_queue.pop_front()
