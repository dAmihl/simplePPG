extends TextureRect

var tex = preload("res://assets/interaction_menu_item.png")

func set_selected(new_selected:bool):
	if !new_selected:
		self.texture = null
	else:
		self.texture = tex

func set_text(new_text:String):
	$CenterContainer/Label.text = new_text
