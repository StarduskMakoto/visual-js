class_name MenuFilterButton
extends CheckButton

@export var type : VisualNode.NodeTypes = VisualNode.NodeTypes.NEUTRAL
@export var parent : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.toggled.connect(_on_toggled)
	
	var color_rect = self.get_node_or_null("ColorRect")
	if color_rect == null:
		return
	color_rect.color = VisualNode.typeColours[type]
	pass # Replace with function body.


func _on_toggled(toggled_on : bool = false):
	if parent == null:
		return
	parent.filter_changed(type, toggled_on)
