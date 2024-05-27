extends CharacterBody2D
class_name Enemy
@onready var state_machine = $StateMachine
#@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players')

var DEFAULT_DIRECTION = Vector2(0.0, 1.0) # Down
@onready var direction = DEFAULT_DIRECTION
		
@onready var distance_to_player
@onready var direction_to_player

@onready var HEALTH = 30

func _ready():
	add_to_group('Enemies')

func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position + Vector2(0.0, 23.0))
	direction_to_player = self.global_position.direction_to(player.global_position  + Vector2(0.0, 23.0))
	_get_direction()
	move_and_collide(self.velocity * delta)
	
func _get_direction():
	#if direction_to_player and state_machine.current_state.name == 'chase':
	if direction_to_player.x < 0 and abs(direction_to_player.x) > abs(direction_to_player.y):
		direction = Vector2(-1, 0)
	elif direction_to_player.x > 0 and  abs(direction_to_player.x) > abs(direction_to_player.y):
		direction = Vector2(1, 0)
	elif direction_to_player.y < 0 and  abs(direction_to_player.y) > abs(direction_to_player.x):
		direction = Vector2(0, -1)
	elif direction_to_player.y > 0 and abs(direction_to_player.y) > abs(direction_to_player.x):
		direction = Vector2(0, 1)

func _get_hit():
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		HEALTH -= player.attack_damage
		print(HEALTH)
		if HEALTH <= 0:
			HEALTH = 0
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
		else:
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
