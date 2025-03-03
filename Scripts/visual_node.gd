class_name VisualNode
extends NinePatchRect

enum NodeTypes {NEUTRAL = 0, HEAD, BODY, CSS, JS, HTML_ARGS, CSS_PARAMS, FINAL}

const typeColours = {
	NodeTypes.NEUTRAL: Color("#ffffff"),
	NodeTypes.HEAD: Color("#9ef0af"),
	NodeTypes.BODY: Color("#ebd48a"),
	NodeTypes.CSS: Color("#78a0f0"),
	NodeTypes.JS: Color("#e47af0"),
	NodeTypes.HTML_ARGS: Color("#eb9875"),
	NodeTypes.CSS_PARAMS: Color("#8df0f0"),
	NodeTypes.FINAL: Color("#3944e3")
}

@export var type : NodeTypes = NodeTypes.NEUTRAL
@export var code : String = "<p> {0} </p>"
@export var visibleText : String = "Paragraph: {0}"
@export var mapping : Dictionary = {"0": ""}
@export var disabled : bool = false

var connections_to : Dictionary = {"0": null}

@onready var connContainer : Container = $VBoxContainer

var mousedOn : bool = false
@export var dragged : bool = false

func _ready() -> void:
	update_mapping()
	$ConnectorPoint.disabled = disabled
	$TextEdit.editable = not disabled
	for i in $VBoxContainer.get_children():
		if i is not ConnectorPoint:
			continue
		i.disabled = disabled

func _setup(new_code : String = ""):
	code = new_code
	update_mapping()

func _process(delta: float) -> void:
	var rootNode = get_tree().get_first_node_in_group("RootNode")
	if rootNode.SelectedPoint != null:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mousedOn:
		if rootNode.draggedElement not in [null, self]:
			dragged = false
			return
		rootNode.draggedElement = self
		self.global_position = get_global_mouse_position()
		dragged = true
	else:
		dragged = false
		if rootNode.draggedElement == self:
			rootNode.draggedElement = null
		if $TextEdit.has_focus():
			if not get_global_rect().has_point(get_global_mouse_position()):
				$TextEdit.release_focus()

func update_mapping():
	self.custom_minimum_size = Vector2(448, 160)
	self.size = self.custom_minimum_size
	$TextEdit.size = Vector2(315, 45)
	
	for i in $VBoxContainer.get_children():
		i.queue_free()
	var placeholders : Array[String] = []
	var counter : int = 0
	$Label.text = visibleText.c_unescape()
	self.modulate = typeColours[type]
	
	if type == NodeTypes.FINAL:
		$ConnectorPoint.visible = false
	
	$TextEdit.visible = code.contains("{text}")
	$Label.visible = not $TextEdit.visible
	
	while true:
		if code.contains("{" + str(counter) + "}"):
			placeholders.append(str(counter))
			counter += 1
		else:
			break
	
	mapping = {}
	connections_to = {}
	for i in placeholders:
		mapping[i] = ""
		connections_to[i] = null
		add_connector(i)
	
	if $TextEdit.visible:
		mapping["text"] = ""
		connections_to["text"] = $TextEdit

func add_connector(key : String = "") -> void:
	if key not in mapping:
		return
	
	var new_conn = preload("res://Scenes/connector_point.tscn").instantiate()
	$VBoxContainer.add_child(new_conn)
	new_conn.key = key
	new_conn.updateIcon()
	if key != "0":
		self.size.y += 40
		$TextEdit.size.y += 40
	self.custom_minimum_size = self.size

func connect_to(node : VisualNode, key : String = "") -> void:
	if key not in mapping:
		return
	connections_to[key] = node
	print(_get_code())

func disconnect_from(node : VisualNode) -> void:
	if node in connections_to.keys():
		connections_to[node] = null

func _get_code() -> String:
	for i in mapping.keys():
		if connections_to[i] == null:
			continue
		if i == "text":
			mapping[i] = connections_to[i].text
			continue
		mapping[i] = connections_to[i]._get_code()
	
	var final_code = code.format(mapping)
	return final_code


func _on_mouse_entered() -> void:
	#print("Mouse on")
	mousedOn = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if dragged:
		return
	mousedOn = false
	#print("Mouse Off")
	pass # Replace with function body.
