extends CanvasLayer

var filters : Array[VisualNode.NodeTypes] = []

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

func filter_changed(type : VisualNode.NodeTypes, toggled_on : bool = false) -> void:
	if type not in filters and toggled_on:
		filters.append(type)
	elif type in filters and not toggled_on:
		filters.erase(type)
	recalc_filters()

func recalc_filters():
	for i in $ScrollContainer/GridContainer.get_children():
		if i is not VisualNode:
			continue
		i.visible = (i.type in filters) or filters.is_empty()


func _on_filter_show_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Path2D/PathFollow2D/FilterShow.set_pressed_no_signal(false)
		$Path2D/PathFollow2D/FilterShow.disabled = true
		var moveTween = create_tween()
		moveTween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0.5, 0.3)
		moveTween.tween_callback(
			func():
			$Filters.visible = false
			$Path2D/PathFollow2D/FilterShow.set_pressed_no_signal(true)
			)
		moveTween.tween_property($Path2D/PathFollow2D, "progress_ratio", 1, 0.3)
		moveTween.tween_callback(func(): $Path2D/PathFollow2D/FilterShow.disabled = false)
	else:
		$Path2D/PathFollow2D/FilterShow.set_pressed_no_signal(true)
		$Path2D/PathFollow2D/FilterShow.disabled = true
		var moveTween = create_tween()
		moveTween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0.5, 0.3)
		moveTween.tween_callback(
			func():
			$Filters.visible = true
			$Path2D/PathFollow2D/FilterShow.set_pressed_no_signal(false)
			)
		moveTween.tween_property($Path2D/PathFollow2D, "progress_ratio", 0, 0.3)
		moveTween.tween_callback(func(): $Path2D/PathFollow2D/FilterShow.disabled = false)
	pass # Replace with function body.
