class_name PPGObject
	
var object_name: String
var transitions: Dictionary
var states: Array
var default_state: String
var events_reversible: Dictionary

func add_event(event_name: String, reversible: bool = true):
	self.transitions[event_name] = []
	self.events_reversible[event_name] = reversible

func get_object_name():
	return self.object_name
	
func get_transitions():
	return self.transitions
	
func get_events_reversible():
	return self.events_reversible
	
func get_states():
	return self.states
	
func get_default_state():
	return self.default_state
	
func set_transition(event_name: String, from_state: String, to_state: String):
	self.transitions[event_name].append([from_state, to_state])
	#self.transitions[event_name] = [from_state, to_state]
	
func set_object_name(name: String):
	self.object_name = name
	pass
	
func set_states(s: Array):
	self.states = s
	pass

func set_default_state(ds: String):
	self.default_state = ds
	pass
