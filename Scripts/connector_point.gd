class_name ConnectorPoint
extends Button

const icons : Array[Texture2D] = [
	preload("res://Assets/ConnectorIn.tres"),
	preload("res://Assets/ConnectorOut.tres")
]

@export var sending : bool = false

@export var connected_to : ConnectorPoint = null
@export var key : String = "0"

var tracking : bool = false
var mousedOver : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateIcon()
	pass # Replace with function body.

func updateIcon() -> void:
	if sending:
		icon = icons[1]
	else:
		icon = icons[0]
		$Label.text = key


func _process(_delta) -> void:
	if tracking:
		line_towards(get_local_mouse_position())
		if Input.is_key_pressed(KEY_ESCAPE):
			tracking = false
			$Line2D.visible = false
	else:
		point_check()

func point_check():
	var self_parent
	if not self.sending:
		self_parent = get_parent().get_parent()
	else:
		self_parent = get_parent()
	if self_parent is not VisualNode or connected_to == null:
		return
	
	var conn_parent
	if not connected_to.sending:
		conn_parent = connected_to.get_parent().get_parent()
	else:
		conn_parent = connected_to.get_parent()
	
	
	if self_parent.dragged or conn_parent.dragged:
		line_towards($Line2D.to_local(connected_to.global_position + Vector2(21, 21)))


func line_towards(pos : Vector2 = Vector2.ZERO):
	var temp_points = [
		$Line2D.points[0], Vector2(0, 0),
		Vector2(0, 0), pos
		]
	var mid_point = temp_points[0].x + temp_points[-1].x / 2.
	temp_points[1] = Vector2(mid_point, temp_points[0].y)
	temp_points[2] = Vector2(mid_point, temp_points[-1].y)
	$Line2D.points = temp_points

func connect_to(point : ConnectorPoint) -> bool:
	var self_parent
	if not self.sending:
		self_parent = get_parent().get_parent()
	else:
		self_parent = get_parent()
	var conn_parent = point.get_parent().get_parent()
	if self_parent == conn_parent:
		return false
	connected_to = point
	tracking = false
	line_towards($Line2D.to_local(connected_to.global_position + Vector2(21, 21)))
	if self_parent is VisualNode and conn_parent is VisualNode:
		conn_parent.connect_to(self_parent, connected_to.key)
		print("YES")
	
	return true
	

func _on_pressed() -> void:
	var root = get_tree().get_first_node_in_group("RootNode")
	if root == null:
		return
	if sending:
		root.set("SelectedPoint", self)
		$Line2D.visible = true
		tracking = true
	else:
		var con_point = root.get("SelectedPoint")
		if con_point == null:
			print("NO POINT")
			return
		if con_point.connect_to(self):
			root.set("SelectedPoint", null)
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	mousedOver = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mousedOver = false
	pass # Replace with function body.
