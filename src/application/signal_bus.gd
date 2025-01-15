extends Node


######################################
##           Event Signals          ##
######################################
signal enqueue_event(type: Globals.EventType, data)

#  Listener Dictionary Hint:
#     {
#       "event_type_1": {
#            "event_id_1": [  listener_1, listener_2, ... ],
#            ...
#       },
#       ...
#     }
signal add_event_listener(listener: Node, event_type: Globals.EventType, event_id: StringName)


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
signal set_input_mode(mode: Globals.FocusState)


######################################
##          Level Signals           ##
######################################
#Signal emitted with the current loading progress (0 to 1) and description
signal loading_progress(progress: float, description: String)
