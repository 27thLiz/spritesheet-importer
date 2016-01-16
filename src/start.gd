tool
extends EditorPlugin

var button
var windowclass = preload("plugin.tscn")

func _enter_tree():
	button = Button.new()
	button.set_text("Import Spritesheet")
	button.connect("pressed", self, "_clicked")
	add_custom_control(CONTAINER_TOOLBAR, button)

func _clicked():
	var window = windowclass.instance()
	add_child(window)
	window.set_pos(Vector2(20, 20))
	
	
func _ready():
	# Initialization here
	pass


