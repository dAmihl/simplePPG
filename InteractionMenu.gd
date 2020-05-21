extends Control

var interactions:Dictionary = {}

var currently_selected_index = 0

onready var menu_container = $TextureRect/VBoxContainer
var menu_item_scn = preload("res://InteractionMenuItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_up"):
		select_next()
	if event.is_action_pressed("ui_down"):
		select_previous()

func clear_interactions():
	self.interactions = {}
	self.currently_selected_index = 0
	update_interaction_menu()
	self.visible = false

func set_interaction_methods(var interactions):
	self.interactions = interactions
	self.currently_selected_index = 0
	if self.interactions.size() > 0:
		self.visible = true
	update_interaction_menu()
	pass

func select_previous():
	var old_value = currently_selected_index
	if interactions.size() == 0:
		currently_selected_index = 0
	else:
		currently_selected_index = (currently_selected_index - 1)
		if currently_selected_index < 0:
			currently_selected_index = interactions.size() - 1
		update_currently_selected(old_value, currently_selected_index)

func select_next():
	var old_value = currently_selected_index
	if interactions.size() == 0:
		currently_selected_index = 0
	else:
		currently_selected_index = (currently_selected_index + 1) % interactions.size()
		update_currently_selected(old_value, currently_selected_index)

func update_currently_selected(old_value, new_value):
	if old_value >= 0:
		menu_container.get_child(old_value).set_selected(false)
	if self.interactions.size() > 0:
		menu_container.get_child(new_value).set_selected(true)
	
func update_interaction_menu():
	for c in menu_container.get_children():
		menu_container.remove_child(c)
		c.queue_free()
	for interaction in self.interactions.keys():
		var tmp_menu_item = menu_item_scn.instance()
		tmp_menu_item.set_text(interaction)
		menu_container.add_child(tmp_menu_item)
	update_currently_selected(-1,currently_selected_index)

func get_currently_selected_methodname():
	var method_name = self.interactions.values()[currently_selected_index]
	print("getting method name "+method_name)
	return method_name
