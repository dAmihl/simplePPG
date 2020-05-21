extends KinematicBody2D


var move_dir:int = 0
var move_speed:float = 80.0

onready var fsm: StateMachine = StateMachine.new()

var use_object:Node2D

func _ready():
	fsm.enter_state("idle")
	fsm.connect("_on_enter_state", self, "_on_fsm_enter_state")
	fsm.connect("_on_exit_state", self, "_on_fsm_exit_state")
	fsm.connect("_on_transition", self, "_on_fsm_transition")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var collider = $RayCast2D.get_collider()
	use_object = collider
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_instance_valid(use_object) and use_object.has_method("on_use"):
			use_object.on_use()
			fsm.enter_state("use")
		else:
			fsm.enter_state("shrug")
	
	if fsm.is_state("walk") || fsm.is_state("idle"):
		var move_dir = 0
		if Input.is_action_pressed("ui_right"):
			move_dir = 1
			$AnimatedSprite.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			move_dir = -1
			$AnimatedSprite.flip_h = true
		else:
			move_dir = 0
			
		if abs(move_dir) > 0:
			fsm.enter_state("walk")
		elif fsm.is_state("walk"):
			fsm.enter_state("idle")
		
		if fsm.is_state("walk"):
			self.position = self.position + Vector2(move_dir * move_speed * delta, 0)
	pass


func display_info_text(info_text:String, duration:float = 1.0)->void:
	$InfoText.text = info_text
	$InfoText.visible = true
	yield(get_tree().create_timer(duration), "timeout")
	$InfoText.visible = false


func _on_fsm_enter_state(new_state):
	if new_state == "walk":
		$AnimatedSprite.play("walk")
	if new_state == "idle":
		$AnimatedSprite.play("idle")
	if new_state == "use":
		$AnimatedSprite.play("use")
	if new_state == "shrug":
		$AnimatedSprite.play("shrug")
		display_info_text("There is nothing here.", 1.0)
	pass

func _on_fsm_exit_state(old_state):
	pass
	
func _on_fsm_transition(old_state, new_state):
	pass


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "shrug":
		fsm.enter_state("idle")
	if $AnimatedSprite.animation == "use":
		fsm.enter_state("idle")
	pass # Replace with function body.


func _on_PPGManager_ppg_no_effect(obj_name):
	display_info_text("This did nothing.", 1.5)
	pass # Replace with function body.


func _on_PPGManager_ppg_state_change(obj_name, new_state):
	display_info_text("Yes, something happened!", 1.0)
	pass # Replace with function body.
