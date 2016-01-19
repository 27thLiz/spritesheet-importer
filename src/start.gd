tool
extends EditorPlugin

var button
var window
var windowclass = preload("plugin.tscn")
var instanced = false

func _enter_tree():
	button = Button.new()
	button.set_text("Import Spritesheet")
	button.connect("pressed", self, "_clicked")
	add_custom_control(CONTAINER_TOOLBAR, button)

func _clicked():
	if !instanced:
		window = windowclass.instance()
		add_child(window)
		window.set_pos(Vector2(20, 20))
		instanced = true
	window.show()
	
func _ready():
	# Initialization here
	pass


