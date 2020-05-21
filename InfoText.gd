extends Node2D

export var offset:Vector2 = Vector2.ZERO
onready var original_pos:Vector2 = self.position

var duration:float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	original_pos = self.position
	pass # Replace with function body.

func set_duration(duration):
	self.duration = duration

func _process(delta):
	self.position = original_pos + offset

func set_text(text:String):
	$Label.set_text(text)

func start():
	set_process(true)
	$AnimationPlayer.play("float")
	yield(get_tree().create_timer(self.duration), "timeout")
	queue_free()
