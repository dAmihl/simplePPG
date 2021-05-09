extends "res://PPGObject.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.obj_name = "Door"
	self.event_name = "UseDoor"
	self.interaction_methods = {
		"Open" : "on_use"
	}
	pass # Replace with function body.

func ppg_on_state_change(new_state):
	if new_state == "Open":
		$StaticBody2D/CollisionShape2D.disabled = true
		$AnimatedSprite.play("open")
	if new_state == "Closed":
		$StaticBody2D/CollisionShape2D.disabled = false
		$AnimatedSprite.play("closed")
	pass
	
func ppg_on_active():
	$AnimatedSprite.play("unlocked")
	
func ppg_on_inactive():
	$AnimatedSprite.play("closed")
