extends Node2D

signal ppg_object_used(obj_name, event_name)

onready var obj_name:String = "DEFAULT"
onready var event_name:String = "DEFAULT"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	

func on_use():
	emit_signal("ppg_object_used", obj_name, event_name)
