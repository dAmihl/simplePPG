extends Node2D

export var sprite_path: String = "res://icon.png"
export var left_click_event = "UseDoor"

var ppg_manager

var sprite: Sprite
var node_ref: PPGNodeRef
var offset = Vector2.ZERO
var centered = true
var object_name: String
var current_state: String

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = Sprite.new()
	sprite.texture = load(sprite_path)
	self.add_child(sprite)
	
	var label = Label.new()
	label.text = self.object_name
	self.add_child(label)
	label.set_position(Vector2(0,-50))
	pass # Replace with function body.


func _on_click():
	self.ppg_manager.handle_event(self.left_click_event)
	pass

func on_no_effect():
	print("No effect.")
	pass
	
func on_complete():
	print("I Am complete!")
	pass
	
func on_state_change(new_state):
	print ("I have a new state: "+new_state)
	pass

func _unhandled_input(event):
	var texture = sprite.texture
	if event is InputEventMouseButton and event.pressed and not event.is_echo() and event.button_index == BUTTON_LEFT:
		var pos = position + offset - ( (texture.get_size() / 2.0) if centered else Vector2() ) # added this 2
		if Rect2(pos, texture.get_size()).has_point(event.position): # added this
			self._on_click()
			get_tree().set_input_as_handled()
