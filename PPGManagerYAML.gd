extends Node2D

var ppg: GdPPG

var puzzle_done = false

onready var ppg_door = preload("res://PPG_Door.tscn")
onready var ppg_lever = preload("res://PPGLever.tscn")
onready var ppg_tristate = preload("res://PPGTristate.tscn")
onready var ppg_object = preload("res://PPGObject.tscn")

signal ppg_no_effect(obj_name)
signal ppg_state_change(obj_name, new_state)

var obj_name_node_map: Dictionary

var spawn_offset:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	load_new_puzzle()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("reload"):
		reload()

func reload():
	get_tree().reload_current_scene()

func puzzle_finished():
	self.puzzle_done = true
	var finish = Label.new()
	finish.text = "Puzzle FInished! Space to continue"
	finish.set_position(Vector2(300, 20))
	self.add_child(finish)

func load_new_puzzle():
	ppg = GdPPG.new()
	spawn_offset = Vector2.ZERO
	ppg.connect("ppg_puzzle_complete", self, "on_puzzle_complete")
	ppg.connect("ppg_event_no_effect", self, "on_puzzle_callback_no_effect")
	ppg.connect("ppg_node_active", self, "on_puzzle_callback_node_active")
	ppg.connect("ppg_node_complete", self, "on_puzzle_callback_node_complete")
	ppg.connect("ppg_node_incomplete", self, "on_puzzle_callback_node_inactive")
	ppg.connect("ppg_object_state_change", self, "on_puzzle_callback_object_state_change")
	
	var file = File.new()
	file.open("universes/universe2.yaml", File.READ)
	var content = file.get_as_text()
	file.close()

	ppg.generate_puzzle_by_yaml_string(content)
	
	print(ppg.get_puzzle_textual_representation())
	
	var ppgref = ppg.get_puzzle_graph_representation()
	interpret_puzzle(ppgref)
	pass

func interpret_puzzle(root: PPGNodeRef):
	
	if not is_instance_valid(root):
		return
	
	var node_type = ppg_object
	var obj_name = root.get_object_name()
	
	# The node is not yet created
	print(obj_name)
	if !self.obj_name_node_map.has(obj_name):
		obj_name_node_map.get(obj_name)
		if obj_name == "Door":
			node_type = ppg_door
		elif obj_name == "Lever":
			node_type = ppg_lever
		elif obj_name == "TristateLever":
			node_type = ppg_tristate
		
		if node_type != ppg_object:
			var tmpGdNode = node_type.instance()
			tmpGdNode.connect("ppg_object_used", self, "on_ppg_object_used")
			tmpGdNode.position += spawn_offset
			spawn_offset += Vector2(100,0)
			self.add_child(tmpGdNode)
			self.obj_name_node_map[root.get_object_name()] = tmpGdNode

	if root.get_children().size() > 0:
		for c in root.get_children():
			interpret_puzzle(c)
	pass

func handle_event(event_name: String):
	ppg.handle_event(event_name)
	pass

func on_puzzle_complete():
	self.puzzle_finished()
	pass

func on_puzzle_callback_arg(arg):
	print("puzzle callback: " + arg)
	pass

func on_puzzle_callback_no_effect(arg):
	self.obj_name_node_map[arg].ppg_on_no_effect()
	emit_signal("ppg_no_effect", arg)
	pass
	
func on_puzzle_callback_node_complete(arg: PPGNodeRef):
	self.obj_name_node_map[arg.get_object_name()].ppg_on_complete()
	pass
	
func on_puzzle_callback_node_active(arg: PPGNodeRef):
	self.obj_name_node_map[arg.get_object_name()].ppg_on_active()
	pass
	
func on_puzzle_callback_node_inactive(arg: PPGNodeRef):
	self.obj_name_node_map[arg.get_object_name()].ppg_on_inactive()
	pass
	
func on_puzzle_callback_object_state_change(obj, state):
	self.obj_name_node_map[obj].ppg_on_state_change(state)
	emit_signal("ppg_state_change", obj, state)
	pass

func on_ppg_object_used(obj_name, event_name):
	handle_event(event_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
