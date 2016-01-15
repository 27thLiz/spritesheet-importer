
extends Sprite
var rect setget rectchanged
var name
var skip = false
var line_width = 1.0
var mouseover = false
var selected = false
var clicked = false

func rectchanged(value):
	rect = value
	set_region_rect(rect)
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and !event.is_pressed():
		clicked = true

func _fixed_process(delta):
	if clicked:
		clicked = false
		if mouseover:
			selected = !selected
	update()

func _draw():
	draw_box(Color(1, 1, 1))
	if selected:
		draw_box(Color(0, 0, 1))
	if mouseover:
		draw_box(Color(1, 0 , 0))
func draw_box(color):
	var x = rect.size.x
	var y = rect.size.y
	var upright = Vector2(x, 0)
	var downleft = Vector2(0, y)
	var downright = Vector2(x, y)

	draw_line(Vector2(), downleft, color, line_width)
	draw_line(Vector2(), upright, color, line_width)
	draw_line(downleft, downright, color, line_width)
	draw_line(upright, downright, color, line_width)

func _on_Area2D_mouse_enter():
	mouseover = true

func _on_Area2D_mouse_exit():
	mouseover = false