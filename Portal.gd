extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_active(new_active:bool):
	self.active = new_active
	if self.active:
		$AnimatedSprite.play("active")
	else:
		$AnimatedSprite.play("inactive")

func on_use():

	if active:
		find_parent("PPGManager").reload()
