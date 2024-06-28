@tool
extends TileMapLayer

@export var generateTerrain : bool
@export var clearTerrain : bool

@export var mapWidth : int
@export var mapHeight : int
@export var centered : bool = true

@export var terrainSeed : int

@export var grassThreshold : float
@export var grass2Threshold : float
@export var dirtThreshold : float
@export var rockThreshold : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if generateTerrain:
		generateTerrain = false
		GenerateTerrain()
		
	if clearTerrain:
		clearTerrain = false
		clear()
		
	
	
func GenerateTerrain():	
	print("Generating Terrain...")
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	
	
	var rng = RandomNumberGenerator.new()
	
	if terrainSeed == 0:
		noise.seed = rng.randi()
	else:
		noise.seed = terrainSeed
	
	
	for x in range(mapWidth):
		if centered:
			@warning_ignore("integer_division")
			x -= mapWidth / 2
		for y in range(mapHeight):
			if centered:
				@warning_ignore("integer_division")
				y -= mapHeight / 2
			#set_cell(Vector2i(x, y), 4, Vector2i(0,0), 0)
			if noise.get_noise_2d(x, y) > grassThreshold:
				set_cell(Vector2i(x, y), 4, Vector2i(0,0), 0)
			elif noise.get_noise_2d(x, y) > grass2Threshold:
				set_cell(Vector2i(x, y), 3, Vector2i(0,0), 0)
			elif noise.get_noise_2d(x, y) > dirtThreshold:
				set_cell(Vector2i(x, y), 3, Vector2i(0,1), 0)
			elif noise.get_noise_2d(x, y) > rockThreshold:
				set_cell(Vector2i(x, y), 3, Vector2i(0,2), 0)
			else: 
				set_cell(Vector2i(x, y), 3, Vector2i(0,3), 0)
