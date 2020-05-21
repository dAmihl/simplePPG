extends Node


var lh_object: String
var lh_state: String
var rh_object: String
var rh_state: String
var rule_type: String = "BEFORE" #AFTER, STRICT_BEFORE, STRICT_AFTER


func get_lh_object():
	return lh_object

func get_lh_state():
	return lh_state
	
func get_rh_object():
	return rh_object
	
func get_rh_state():
	return rh_state
	
func get_rule_type():
	return rule_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
