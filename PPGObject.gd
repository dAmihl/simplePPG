extends Area2D

signal ppg_object_used(obj_name, event_name)

var obj_name:String = "DEFAULT"
var event_name:String = "DEFAULT"
var tpl_name:String = "DEFAULT"
var info_text_scn = preload("res://InfoText.tscn")

var interaction_methods = {
	"Use" : "on_use"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_obj_name(obj_n:String):
	self.obj_name = obj_n

func set_tpl_name(tpl_n:String):
	self.tpl_name = tpl_n

func ppg_set_init_state(new_state):
	pass

func ppg_on_state_change(new_state):
	pass

func ppg_on_complete():
	print("I am complete!")
	print(obj_name)
	pass
	
func ppg_on_no_effect():
	pass
	
func ppg_on_active():
	pass

func ppg_on_inactive():
	pass

func get_interaction_methods():
	return self.interaction_methods

func on_use():
	emit_signal("ppg_object_used", obj_name, event_name)
	
