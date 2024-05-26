extends CharacterBody2D
@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group('Players')

var DEFAULT_DIRECTION = 'down'
@onready var direction = DEFAULT_DIRECTION:
	set(new_direction):
		direction = new_direction
		Callable(self, "_" + state_machine.current_state.name).call()
		
@onready var movement
@onready var distance_to_player
@onready var direction_to_player

@onready var hitable = true

@onready var CHASE_DISTANCE = 100.0

func _ready():
	add_to_group('Enemies')

func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position + Vector2(0.0, 23.0))
	direction_to_player = self.global_position.direction_to(player.global_position  + Vector2(0.0, 23.0))
	_get_direction()
	move_and_collide(self.velocity * delta)
	
func _get_direction():
	if direction_to_player and state_machine.current_state.name == 'chase':
		if direction_to_player.x < 0 and abs(direction_to_player.x) > abs(direction_to_player.y):
			direction = 'left'
		elif direction_to_player.x > 0 and  abs(direction_to_player.x) > abs(direction_to_player.y):
			direction = 'right'
		elif direction_to_player.y < 0 and  abs(direction_to_player.y) > abs(direction_to_player.x):
			direction = 'up'
		elif direction_to_player.y > 0 and abs(direction_to_player.y) > abs(direction_to_player.x):
			direction = 'down'

func _idle():
	animation_player.play('idle_' + direction)
		#
func _chase():
	animation_player.play('chase_' + direction)	
	
func _hit():
	if hitable:
		hitable = false
		print('Slime hit')
		print(-direction_to_player)
		self.velocity = -direction_to_player * 1000.0
		# TODO: Implement hit animation
		await get_tree().create_timer(1.0).timeout
		hitable = true
		
