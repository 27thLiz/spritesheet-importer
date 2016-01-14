tool
extends Node2D

const WHITE = Color(1, 1, 1)

onready var start = get_node("StartPos").get_pos()
onready var rect = Rect2(start, Vector2(size_x, size_y))
var tileset = preload("res://stoneblocks.png")
var TILESIZE = 96
var rows = 2
var columns = 5
var size_x = columns * TILESIZE
var size_y = rows * TILESIZE
var clicked = false
var draw_curr = true
var draw_perm = false
var currentSelection = Rect2()
var permanentSelection = Rect2()
var tiles = {}
var dir

func _ready():
	update()
	draw_curr = false
	set_fixed_process(true)
	set_process_input(true)
	for x in range(columns):
		for y in range(rows):
			tiles[Vector2(x, y)] = Rect2(Vector2(x * TILESIZE, y * TILESIZE), Vector2(TILESIZE, TILESIZE))
	pass


func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and !event.is_pressed()):
		clicked = true

func _fixed_process(delta):
	var mpos = get_global_mouse_pos()
	
	if (rect.has_point(mpos)):
		draw_curr = true
		
		var x = int((mpos.x - start.x) / TILESIZE)
		var y = int((mpos.y - start.y) / TILESIZE)
		currentSelection = tiles[Vector2(x, y)]
		
		if clicked:
			if (currentSelection == permanentSelection):
				draw_perm = false
			else:
				permanentSelection = currentSelection
				draw_perm = true
			clicked = false
	else:
		draw_curr = false
	update()


func _draw():
	for key in tiles:
		draw_box(tiles[key], WHITE)
	if (draw_curr):
		draw_box(currentSelection, Color(0.85, 0, 0.7))
	if (draw_perm):
		draw_box(permanentSelection, Color(0.4, 1, 0.7))

func draw_box(rect, color):
	var pos = start + rect.pos
	var end = start + rect.end
	var upright = Vector2(pos.x + TILESIZE, pos.y)
	var downleft = Vector2(pos.x, end.y)
	#var downright = Vector2(.x + TILESIZE, rect.pos.y + TILESIZE)
	
	draw_line(pos, downleft, color)
	draw_line(pos, upright, color)
	draw_line(downleft, end, color)
	draw_line(upright, end, color)

func _on_Import_released():
	var count = 0
	for key in tiles:
		var rect = tiles[key]
		var tex = AtlasTexture.new()
		tex.set_name(str(count))
		tex.set_atlas(tileset)
		tex.set_region(rect)
		ResourceSaver.save(dir + "/" + str(count)+".atex", tex)
		count += 1
		

func _on_path_button_pressed():
	get_node("FileDialog").show()

func _on_FileDialog_confirmed():
	dir = get_node("FileDialog").get_current_dir()
	get_node("Label").set_text("Path: " + dir)