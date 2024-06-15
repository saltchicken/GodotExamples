extends CharacterBody2D

@export var arrow_speed: float = 600
@onready var direction: Vector2 = Vector2.ZERO: set = _set_arrow_direction

@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var default_stats: ProjectileStats
@onready var stats: ProjectileStats = default_stats.duplicate()

@onready var start_slowing_down = false

func _set_arrow_direction(new_direction):
	direction = new_direction
	if direction == Vector2(0,1):
		self.rotation = deg_to_rad(225)
	elif direction == Vector2(1,0):
		self.rotation = deg_to_rad(135)
	elif direction == Vector2(0,-1):
		self.rotation = deg_to_rad(45)
	elif direction == Vector2(-1, 0):
		self.rotation = deg_to_rad(315)
	else:
		print('_set_arrow_direction is broken')


func _ready() -> void:
	self.position.y -= 15
	add_collision_exception_with(player)
	
# TODO: Arrow needs to queue_free after either time or leaving the screen
# TODO: Add piercing

func _physics_process(delta: float) -> void:
	if !start_slowing_down:
		velocity.x = move_toward(velocity.x, direction.x * arrow_speed, 40)
		velocity.y = move_toward(velocity.y, direction.y * arrow_speed, 40)
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(velocity.y, 0, 10)
	if abs(velocity.x) == abs(direction.x * arrow_speed) and abs(velocity.y) == abs(direction.y * arrow_speed):
		start_slowing_down = true
		print('start slowing down')
	if abs(velocity.x) <= 250 and abs(velocity.y) <= 250 and start_slowing_down:
		queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		print(collision)
		var body = collision.get_collider()
		if body.has_method('get_hit') and collision != player: # TODO: Do not need collision != player due to add_collision_exception_with
			#if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				add_collision_exception_with(body)
				body.get_hit(self)
