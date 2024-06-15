extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var default_stats: ProjectileStats
@onready var stats: ProjectileStats = default_stats.duplicate()

@onready var direction: Vector2 = Vector2.ZERO: set = _set_arrow_direction
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

func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, 10)
	velocity.y = move_toward(velocity.y, 0, 10)
	if abs(velocity.x) <= 250 and abs(velocity.y) <= 250:
		queue_free()
	var collision = move_and_collide(velocity * delta)
	if collision:
		#print(collision)
		var body = collision.get_collider()
		if body.has_method('get_hit'):
				add_collision_exception_with(body)
				body.get_hit(self)
				handle_piercing()
				
func handle_piercing():
	stats.piercing -= 1
	if stats.piercing <= 0:
		queue_free()
