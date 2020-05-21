extends "res://PPGObject.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.obj_name = "Lever"
	self.event_name = "UseLever"
	pass # Replace with function body.

func ppg_on_state_change(new_state):
	if new_state == "Used":
		$AnimatedSprite.play("used")
	if new_state == "Unused":
		$AnimatedSprite.play("unused")
	pass
