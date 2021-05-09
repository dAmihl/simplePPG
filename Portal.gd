extends Area2D


var interaction_methods = {
	"Enter" : "on_use"
}

var active:bool = false
var interaction_methods

# Called when the node enters the scene tree for the first time.
func _ready():
	self.interaction_methods = {
		"Leave" : "on_use"
	}
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

func get_interaction_methods():
	return self.interaction_methods
