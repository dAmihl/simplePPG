extends Node

class_name StateMachine

var states:Array

var current_state:String

signal _on_exit_state(state_name)
signal _on_enter_state(state_name)
signal _on_transition(old_state, new_state)


func enter_state(state_name:String)->void:
	if current_state == state_name:
		return
	if current_state:
		emit_signal("_on_exit_state", current_state)
	current_state = state_name
	emit_signal("_on_enter_state", current_state)

func is_state(state_name:String)->bool:
	return state_name == current_state
