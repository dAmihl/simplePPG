extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ppg_object = preload("res://ppg/ppg_object.gd")
var ppg_node = preload("res://ppg/PPG_Node.gd")
var ppg_node_lever = preload("res://PPG_Lever.gd")
var ppg_node_door = preload("res://ppg_door.gd")
var ppg_node_key = preload("res://PPG_Key.gd")
var ppg_node_button = preload("res://PPG_Button.gd")
var ppg_node_compass = preload("res://PPG_Compass.gd")
var ppg_rule = preload("res://ppg/ppg_rule.gd")
var object_event_map: Dictionary

var obj_name_node_map: Dictionary

var ppg: GdPPG

var puzzle_done = false

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
	var o1 = ppg_object.new()
	o1.set_object_name("Door")
	o1.set_states(["Open", "Closed"])
	o1.add_event("UseDoor", false)
	o1.set_transition("UseDoor", "Closed", "Open")
	#o1.set_transition("UseDoor", "Open", "Closed")
	o1.set_default_state("Closed")
	object_event_map["Door"] = ["UseDoor"]
	
	var o2 = ppg_object.new()
	o2.set_object_name("Lever")
	o2.set_states(["On", "Off"])
	o2.add_event("UseLever", false)
	o2.set_transition("UseLever", "Off", "On")
	o2.set_default_state("Off")
	object_event_map["Lever"] = ["UseLever"]
	
	var o3 = ppg_object.new()
	o3.set_object_name("Key")
	o3.set_states(["PickedUp", "Dropped"])
	o3.add_event("UseKey", false)
	o3.set_transition("UseKey", "Dropped", "PickedUp")
	#o3.set_transition("UseKey", "PickedUp", "Dropped")
	o3.set_default_state("Dropped")
	object_event_map["Key"] = ["UseKey"]
	
	var o4 = ppg_object.new()
	o4.set_object_name("Compass")
	o4.set_states(["North", "East", "South", "West"])
	o4.add_event("Turn", false)
	o4.set_transition("Turn", "North", "East")
	o4.set_transition("Turn", "East", "South")
	o4.set_transition("Turn", "South", "West")
	o4.set_transition("Turn", "West", "North")
	o4.set_default_state("North")
	object_event_map["Compass"] = ["Turn"]
	
	var o5 = ppg_object.new()
	o5.set_object_name("Button")
	o5.set_states(["Pressed", "NotPressed"])
	o5.add_event("Press", false)
	o5.set_transition("Press", "Pressed", "NotPressed")
	o5.set_default_state("NotPressed")
	object_event_map["Button"] = ["Press"]
	
	ppg = GdPPG.new()
	ppg.add_object(o1)
	ppg.add_object(o2)
	ppg.add_object(o3)
	ppg.add_object(o4)
	ppg.add_object(o5)
	
	ppg.connect("ppg_puzzle_complete", self, "on_puzzle_complete")
	ppg.connect("ppg_event_no_effect", self, "on_puzzle_callback_no_effect")
	ppg.connect("ppg_node_active", self, "on_puzzle_callback_node_active")
	ppg.connect("ppg_node_complete", self, "on_puzzle_callback_node_complete")
	ppg.connect("ppg_node_incomplete", self, "on_puzzle_callback_node_inactive")
	ppg.connect("ppg_object_state_change", self, "on_puzzle_callback_object_state_change")
	
	
	# (Key,*) BEFORE (Door,Open)
	var r1 = ppg_rule.new()
	r1.lh_object="Key"
	r1.rh_object="Door"
	r1.rh_state="Open"
	r1.rule_type="BEFORE"
	
	var r2 = ppg_rule.new()
	r2.lh_object = "Lever"
	r2.rh_object = "Door"
	
	var r3 = ppg_rule.new()
	r3.lh_object="Door"
	r3.lh_state="Open"
	r3.rh_object="Door"
	r3.rh_state="Closed"
	r3.rule_type = "AFTER"
	
	ppg.add_rule(r2)
	ppg.add_rule(r1)
	ppg.add_rule(r3)
	
	ppg.generate_puzzle()
	
	
	var ppgref = ppg.get_puzzle_graph_representation()
	interpret_puzzle(ppgref)
	pass

func interpret_puzzle(root: PPGNodeRef):
	if not is_instance_valid(root):
		return
	if self.obj_name_node_map.has(root.get_object_name()):
		return
	
	var node_type = ppg_node
	var obj_name = root.get_object_name()
	if obj_name == "Door":
		node_type = ppg_node_door
	elif obj_name == "Lever":
		node_type = ppg_node_lever
	elif obj_name == "Key":
		node_type = ppg_node_key
	elif obj_name == "Button":
		node_type = ppg_node_button
	elif obj_name == "Compass":
		node_type = ppg_node_compass
		
	var tmpGdNode = node_type.new()
	tmpGdNode.object_name = root.get_object_name()
	tmpGdNode.left_click_event = object_event_map[root.get_object_name()]
	tmpGdNode.ppg_manager = self
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
	self.obj_name_node_map[arg].on_no_effect()
	pass
	
func on_puzzle_callback_node_complete(arg: PPGNodeRef):
	self.obj_name_node_map[arg.get_object_name()].on_complete()
	pass
	
func on_puzzle_callback_node_active(arg: PPGNodeRef):
	print("puzzle callback node active: "+arg.get_object_name())
	pass
	
func on_puzzle_callback_node_inactive(arg: PPGNodeRef):
	print("puzzle callback node inactive: "+arg.get_object_name())
	pass
	
func on_puzzle_callback_object_state_change(obj, state):
	self.obj_name_node_map[obj].on_state_change(state)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
