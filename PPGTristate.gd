extends "res://PPGObject.gd"


var spritesheets: Array = [
	"TristateLever",
	"TristateFlag"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.event_name = "UseTristate"
	var frame_index = randi() % spritesheets.size()
	var frames = load("res://spriteframes/"+spritesheets[frame_index]+".tres")
	$AnimatedSprite.set_sprite_frames(frames)
	pass # Replace with function body.

func ppg_set_init_state(new_state):
	update_sprite_on_state(new_state)
	pass

func ppg_on_state_change(new_state):
	update_sprite_on_state(new_state)
	pass

func ppg_on_active():
	display_info_text("*click*")
	pass

func ppg_on_no_effect():
	display_info_text("*the mechanism doesn't move a bit*")
	pass	

func ppg_on_complete():
	display_info_text("!")
	pass

func ppg_on_inactive():
	display_info_text("*clack*")
	pass

func display_info_text(info_text:String, duration:float = 1.0)->void:
	var infoText = info_text_scn.instance()
	infoText.set_text(info_text)
	infoText.set_duration(duration)
	infoText.position = Vector2(0, 15)
	self.add_child(infoText)
	infoText.start()

func update_sprite_on_state(new_state):
	if new_state == "0":
		$AnimatedSprite.play("0")
	if new_state == "1":
		$AnimatedSprite.play("1")
	if new_state == "2":
		$AnimatedSprite.play("2")
