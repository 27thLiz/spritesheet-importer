tool
extends Node2D

const WHITE = Color(1, 1, 1)
const TILE_RECT = 0
const TILE_NAME = 1
const TILE_SKIP = 2

onready var start = get_node("StartPos").get_pos()
onready var rect = Rect2(start, Vector2(size_x, size_y))
onready var TilesetDiag = get_node("TilesetDialog")
onready var PathDiag = get_node("FileDialog")

var tileset = preload("res://stoneblocks.png")
var tilesize_x = 96
var tilesize_y = 96
var rows = 2
var columns = 5
var spacing = 0
var margin = 0
var size_x = columns * tilesize_x
var size_y = rows * tilesize_y
var clicked = false
var draw_curr = false
var draw_perm = false
var have_tileset = false
var currentSelection = {}
var permanentSelection = {}
var tiles = {}
var dir
var base_name = ""
var line_width = 1.0
func _ready():
	TilesetDiag.set_mode(TilesetDiag.MODE_OPEN_FILE)
	#set_fixed_process(true)
	#set_process_input(true)
	#makeTiles()
	pass

func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and !event.is_pressed()):
		clicked = true

func _fixed_process(delta):
	var mpos = get_global_mouse_pos()
	
	if have_tileset and rect.has_point(mpos):
		draw_curr = true
		
		var x = int((mpos.x - start.x) / tilesize_x)
		var y = int((mpos.y - start.y) / tilesize_y)
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
	if have_tileset:
		for key in tiles:
			draw_box(tiles[key][TILE_RECT], WHITE)
		if draw_curr:
			draw_box(currentSelection[TILE_RECT], Color(0.85, 0, 0.7))
		if draw_perm:
			draw_box(permanentSelection[TILE_RECT], Color(0.4, 1, 0.7))
	
func draw_box(rect, color):
	var pos = start + rect.pos
	var end = start + rect.end
	var upright = Vector2(pos.x + tilesize_x, pos.y)
	var downleft = Vector2(pos.x, end.y)
	#var downright = Vector2(.x + tilesize, rect.pos.y + tilesize)
	
	draw_line(pos, downleft, color, line_width)
	draw_line(pos, upright, color, line_width)
	draw_line(downleft, end, color, line_width)
	draw_line(upright, end, color, line_width)

func _on_Import_released():
	for key in tiles:
		if tiles[key][TILE_SKIP]:
			continue
		var rect = tiles[key][TILE_RECT]
		var tex = AtlasTexture.new()
		tex.set_name(tiles[key][TILE_NAME])
		tex.set_atlas(tileset)
		tex.set_region(rect)
		ResourceSaver.save(dir + "/" + tiles[key][TILE_NAME] +".atex", tex)

func makeTiles():
	tiles = {}
	var count = 0
	for x in range(columns):
		for y in range(rows):
			tiles[Vector2(x, y)] = {TILE_RECT: Rect2(Vector2(x * tilesize_x + x * spacing + margin, y * tilesize_y + y * spacing + margin), Vector2(tilesize_x, tilesize_y)),
									TILE_NAME: base_name + "_" + str(count),
									TILE_SKIP: false}
			count += 1

func _on_path_button_pressed():
	get_node("FileDialog").show()

func _on_FileDialog_confirmed():
	dir = get_node("FileDialog").get_current_dir()
	get_node("Label").set_text("Path: " + dir)

func update_vars():
	size_x = columns * tilesize_x
	size_y = rows * tilesize_y
	rect = Rect2(start, Vector2(size_x, size_y))
	makeTiles()

func _on_tilesize_x_value_changed( value ):
	tilesize_x = int(value)
	update_vars()

func _on_rows_value_changed( value ):
	rows = int(value)
	update_vars()

func _on_columns_value_changed( value ):
	columns = int(value)
	update_vars()

func _on_tilesize_y_value_changed( value ):
	tilesize_y = int(value)
	update_vars()

func _on_spacing_value_changed( value ):
	spacing = int(value)
	update_vars()

func _on_margin_value_changed( value ):
	margin = int(value)
	update_vars()

func _on_load_pressed():
	get_node("TilesetDialog").show()

func _on_TilesetDialog_confirmed():
	print("!!!!!!")
	tileset = load(get_node("TilesetDialog").get_current_file())
	get_node("View").set_texture(tileset)
	makeTiles()
	have_tileset = true
	set_process_input(true)
	set_fixed_process(true)
