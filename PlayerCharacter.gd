extends CharacterBody2D

var move_dir:int = 0
var move_speed:float = 120.0
var sprint_speed:float = 180.0

@onready var fsm: StateMachine = StateMachine.new()

@onready var info_text_scn = preload("res://InfoText.tscn")


var use_object:Node2D

func _ready():
	fsm.enter_state("idle")
	fsm._on_enter_state.connect(self._on_fsm_enter_state);
	fsm._on_exit_state.connect(self._on_fsm_exit_state);
	fsm._on_transition.connect(self._on_fsm_transition);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var collider = $RayCast2D.get_collider()
	if collider != use_object: # new collision
		if is_instance_valid(collider) and collider.has_method("get_interaction_methods"):
			var interaction_methods = collider.get_interaction_methods()
			$InteractionMenu.set_interaction_methods(interaction_methods)
		else:
			$InteractionMenu.clear_interactions()
	use_object = collider
	
	if Input.is_action_just_pressed("ui_accept") and (fsm.is_state("idle") or fsm.is_state("walk") or fsm.is_state("sprint")):
		if is_instance_valid(use_object):
			var interaction_method = $InteractionMenu.get_currently_selected_methodname()
			if use_object.has_method(interaction_method):
				use_object.call(interaction_method)
				fsm.enter_state("use")
			else:
				fsm.enter_state("shrug")
		else:
			fsm.enter_state("shrug")
	
	if fsm.is_state("walk") || fsm.is_state("idle") || fsm.is_state("sprint"):
		var move_dir = 0
		var actual_speed = move_speed
		
		
		if Input.is_action_pressed("ui_right"):
			move_dir = 1
			$AnimatedSprite.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			move_dir = -1
			$AnimatedSprite.flip_h = true
		else:
			move_dir = 0
		
		if abs(move_dir) > 0:
			if Input.is_action_pressed("sprint"):
				fsm.enter_state("sprint")
				actual_speed = sprint_speed
			else:
				fsm.enter_state("walk")
		elif fsm.is_state("walk") || fsm.is_state("sprint"):
			fsm.enter_state("idle")
		
		if fsm.is_state("walk") || fsm.is_state("sprint"):
			move_and_collide(Vector2(move_dir * actual_speed * delta, 0))
			#self.position = self.position + Vector2(move_dir * actual_speed * delta, 0)
	pass


func display_info_text(info_text:String, duration:float = 1.0)->void:
	var infoText = info_text_scn.instantiate()
	infoText.set_text(info_text)
	infoText.set_duration(duration)
	self.add_child(infoText)
	infoText.start()


func _on_fsm_enter_state(new_state):
	if new_state == "walk":
		$AnimatedSprite.play("walk")
	if new_state == "sprint":
		$AnimatedSprite.play("walk")
		$AnimatedSprite.speed_scale = 1.3
	if new_state == "idle":
		$AnimatedSprite.play("idle")
	if new_state == "use":
		$AnimatedSprite.play("use")
	if new_state == "shrug":
		$AnimatedSprite.play("shrug")
		display_info_text("There is nothing here.", 1.0)
	pass

func _on_fsm_exit_state(old_state):
	if old_state == "sprint":
		$AnimatedSprite.speed_scale = 1.0
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
	pass # Replace with function body.


func _on_PPGManager_ppg_node_active(obj_name):
	#display_info_text("I think this did something!", 1.5)
	pass # Replace with function body.


func _on_PPGManager_ppg_node_inactive(obj_name):
	display_info_text("Hmm.. is this right?", 1.5)
	pass # Replace with function body.


func _on_PPGManager_ppg_node_complete(obj_name):
	#display_info_text("This should be it", 1.5)
	pass # Replace with function body.
