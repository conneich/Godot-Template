extends Node


######################################
##           Event Signals          ##
######################################
signal enqueue_event
signal add_event_listener(listener: Node, event_type: StringName, event_id: StringName)


######################################
##		Game/Application Signals    ##
######################################
signal main_ready
signal application_paused
signal application_running


######################################
##          Input Signals           ##
######################################
signal input_action_triggered(action_name, event_type)


######################################
##          Level Signals           ##
######################################
#Signal emitted with the current loading progress (0 to 1) and description
signal loading_progress(progress: float, description: String)
