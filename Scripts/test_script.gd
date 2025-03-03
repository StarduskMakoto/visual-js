class_name VisualManager
extends Control

# https://github.com/doceazedo/godot_wry

@export var SelectedPoint : ConnectorPoint = null
@export var draggedElement : VisualNode = null

var webViewToggle : bool = true
var menuToggle : bool = false

var browser : GDBrowserView = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("BEGIN!")
	
	# Set application dimension
	var h = get_viewport().size.x
	var w = get_viewport().size.y
	set_position(Vector2(0,0))
	set_size(Vector2(h, w))

	### CEF ####################################################################

	# CEF Configuration are:
	#   resource_path := {"artifacts", CEF_ARTIFACTS_FOLDER}
	#   resource_path := {"exported_artifacts", application_real_path()}
	#   {"incognito":false}
	#   {"cache_path", resource_path / "cache"}
	#   {"root_cache_path", resource_path / "cache"}
	#   {"browser_subprocess_path", resource_path / SUBPROCESS_NAME }
	#   {"log_file", resource_path / "debug.log"}
	#   {log_severity", "warning"}
	#   {"remote_debugging_port", 7777}
	#   {"exception_stack_size", 5}
	#   {"enable_media_stream", false}
	#
	# Configurate CEF. In incognito mode cache directories not used and in-memory
	# caches are used instead and no data is persisted to disk.
	#
	# artifacts: allows path such as "build" or "res://cef_artifacts/". Note that "res://"
	# will use ProjectSettings.globalize_path but exported projects don't support globalize_path:
	# https://docs.godotengine.org/en/3.5/classes/class_projectsettings.html#class-projectsettings-method-globalize-path
	if !$GDCef.initialize({"incognito":true, "locale":"en-US"}):
		push_error("Failed initializing CEF")
		get_tree().quit()
	else:
		push_warning("CEF version: " + $GDCef.get_full_version())
		pass

	### Browsers ###############################################################

	# Split vertically the windows
	$WebView.set_position(Vector2(0,0))
	$WebView.set_size(Vector2(h, w))

	# Wait one frame for the texture rect to get its size
	await get_tree().process_frame

	# Left browser is displaying the first webpage with a 3D scene, we are
	# enabling webgl. Other default configuration are:
	#   {"frame_rate": 30}
	#   {"javascript": true}
	#   {"javascript_close_windows": false}
	#   {"javascript_access_clipboard": false}
	#   {"javascript_dom_paste": false}
	#   {"image_loading": true}
	#   {"databases": true}
	#   {"webgl": true}
	browser = $GDCef.create_browser("", $WebView, {"javascript": true, "webgl": true})

	browser.name = "browser"
	browser.load_data_uri("<body bgcolor='#FFFFFF'><h1>TEST</h1></body>", "text/html")
	$WebviewCamera.make_current()
	pass # Replace with function body.

func compile_code():
	var final_node = get_tree().get_first_node_in_group("FinalNode")
	if final_node == null or final_node is not VisualNode:
		return
	
	var data_string = final_node._get_code()
	browser.load_data_uri(data_string, "text/html")

func toggleWeb():
	if webViewToggle:
		#$WebView.size = Vector2(1152, 648)
		$WebView.visible = false
		$NodeCamera.make_current()
		pass
	else:
		#$WebView.size = Vector2.ZERO
		$WebView.visible = true
		$WebviewCamera.make_current()
		compile_code()
		
		#$WebView.set_html("")
		pass
	webViewToggle = not webViewToggle

func toggleMenu():
	if menuToggle:
		$VisualNodeMenu.visible = false
		$Marker.visible = false
	else:
		$VisualNodeMenu.visible = true
		$Marker.visible = true
		$Marker.global_position = get_global_mouse_position() + Vector2(-40, -40)
	
	menuToggle = not menuToggle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_webview"):
		toggleWeb()
	
	if Input.is_action_just_pressed("toggle_menu") and not webViewToggle:
		toggleMenu()
	
	if not webViewToggle:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			moveScreen()
		preMouse = DisplayServer.mouse_get_position()
		$DebugMouseMarker.global_position = get_global_mouse_position()
	pass

var preMouse : Vector2 = Vector2.ZERO

func moveScreen():
	var currentMouse = DisplayServer.mouse_get_position()
	
	#$DebugMouseMarker.global_position = currentMouse
	
	var dir = preMouse.direction_to(currentMouse)
	var dist = preMouse.distance_to(currentMouse)
	
	if dist > 5.:
		#print(dist)
		$NodeCamera.global_position -= dir * dist
	
	preMouse = Vector2(currentMouse) - dir * dist

# Params
# code
# type
# visible text
func add_visual_node(params : Dictionary = {}):
	var node = preload("res://Scenes/visual_node.tscn").instantiate()
	
	self.add_child(node)
	
	node.visibleText = params["visibleText"]
	node.type = params["type"]
	node._setup(params["code"])
	
	if node.type == VisualNode.NodeTypes.FINAL:
		node.add_to_group("FinalNode")
	
	node.global_position = $Marker.global_position #- Vector2(-40, -40)
	toggleMenu()
