extends CharacterBody2D
class_name Enemy
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

@export var idle_direction = Vector2(0.0, 1.0)
		
@onready var distance_to_player
@onready var direction_to_player

@export var stats: EnemyStats

func _ready():
	add_to_group('Enemies')

func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position)
	direction_to_player = self.global_position.direction_to(player.global_position)
	move_and_collide(self.velocity * delta)

func get_hit(damage):
	print('Enemy took ' + str(damage) + ' damage')
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		stats.health -= damage
		if stats.health <= 0:
			stats.health = 0
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
		else:
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
			

