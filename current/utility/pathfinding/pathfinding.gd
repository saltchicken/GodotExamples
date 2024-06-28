@tool
extends Node2D

@onready var terrain = $"../TileMapLayer"

var astar_grid = AStarGrid2D.new()

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool
@export var centered : bool = true

var path = []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

func _draw():
	print("redrawing")
	if len(path) > 0:
		for i in range(len(path) - 1):
			draw_line(path[i], path[i+1], Color.PURPLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if calculate:
		calculate = false
		InitPathfinding()
		RequestPath(start, end)
		if len(path) == 0:
			print("Unable to get there")
		
func RequestPath(start_pos: Vector2i, end_pos: Vector2i):
	path = astar_grid.get_point_path(start_pos, end_pos)
	
	for i in range(len(path)):
		path[i] += Vector2(terrain.rendering_quadrant_size/2, terrain.rendering_quadrant_size/2)
	
	queue_redraw()
	
	return path
	
func InitPathfinding():
	if centered:
		astar_grid.region = Rect2i(-terrain.mapWidth / 2, -terrain.mapHeight / 2, terrain.mapWidth, terrain.mapHeight)
	else:
		astar_grid.region = Rect2i(0, 0, terrain.mapWidth, terrain.mapHeight)
	print(astar_grid)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	for x in range(terrain.mapWidth):
		if centered:
			x -= terrain.mapWidth / 2
		for y in range(terrain.mapHeight):
			if centered:
				y -= terrain.mapHeight / 2	
			if GetTerrainDifficulty(Vector2i(x,y)) == -1:
				astar_grid.set_point_solid(Vector2i(x,y))
			else:
				astar_grid.set_point_weight_scale(Vector2i(x,y), GetTerrainDifficulty(Vector2i(x, y)))
			
			
			
	
	
func GetTerrainDifficulty(coords : Vector2i):
	var source_id = terrain.get_cell_source_id(coords)
	var source: TileSetAtlasSource = terrain.tile_set.get_source(source_id)
	var atlas_coords = terrain.get_cell_atlas_coords(coords)
	var tile_data = source.get_tile_data(atlas_coords, 0)
	
	return tile_data.get_custom_data("walk_difficulty")
#func GetTerrainDifficulty(coords : Vector2i):
	#
	#return 1
