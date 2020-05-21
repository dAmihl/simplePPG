extends "res://PPGObject.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.obj_name = "TristateLever"
	self.event_name = "UseTristate"
	pass # Replace with function body.

func ppg_on_state_change(new_state):
	if new_state == "Left":
		$AnimatedSprite.play("left")
	if new_state == "Top":
		$AnimatedSprite.play("top")
	if new_state == "Right":
		$AnimatedSprite.play("right")
	pass
