extends CharacterBody2D
@onready var state_machine = $StateMachine
@onready var animated_sprite = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group('Players')
#@onready var use_hitbox = $UseArea

var DEFAULT_DIRECTION = 'down'
@onready var direction = DEFAULT_DIRECTION:
	set(new_direction):
		direction = new_direction
		Callable(self, "_" + state_machine.current_state.name).call()
		
@onready var movement
@onready var distance_to_player
@onready var direction_to_player


func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position + Vector2(0.0, 23.0))
	direction_to_player = self.global_position.direction_to(player.global_position  + Vector2(0.0, 23.0))
	_get_direction()
	#_handle_use_hitbox_direction()
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
			
#func _handle_use_hitbox_direction():
	#if direction == 'down':
		#use_hitbox.position.x = 0
		#use_hitbox.position.y = use_reach
	#elif direction == 'up':
		#use_hitbox.position.x = 0
		#use_hitbox.position.y = -use_reach
	#elif direction == 'left':
		#use_hitbox.position.x = -use_reach
		#use_hitbox.position.y = 0
	#elif direction == 'right':
		#use_hitbox.position.x = use_reach
		#use_hitbox.position.y = 0

func _idle():
	animated_sprite.play('idle_' + direction)
		#
func _chase():
	animated_sprite.play('chase_' + direction)	
