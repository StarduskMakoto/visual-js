extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $ScrollContainer/GridContainer.get_children():
		if i is not VisualNode:
			continue
		var button : Button = i.get_node_or_null("Button")
		if button == null:
			continue
		button.pressed.connect(_button_pressed.bind(i))
	pass # Replace with function body.


func _button_pressed(parent : VisualNode) -> void:
	var params : Dictionary = {
		"code": parent.code,
		"visibleText": parent.visibleText,
		"type": parent.type
	}
	self.get_parent().add_visual_node(params)
	pass
