extends "res://PPGObject.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.obj_name = "Door"
	self.event_name = "UseDoor"
	pass # Replace with function body.

func ppg_on_state_change(new_state):
	if new_state == "Open":
		$AnimatedSprite.play("open")
	pass
	
func ppg_on_active():
	$AnimatedSprite.play("unlocked")
	
func ppg_on_inactive():
	$AnimatedSprite.play("closed")
