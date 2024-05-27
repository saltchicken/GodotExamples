extends CharacterBody2D
class_name Enemy
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players')

@export var idle_direction = Vector2(0.0, 1.0)
@export var health: int
		
@onready var distance_to_player
@onready var direction_to_player

@onready var attack_reach = 15
@onready var attack_damage = 45

func _ready():
	add_to_group('Enemies')

func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position + Vector2(0.0, 23.0))
	direction_to_player = self.global_position.direction_to(player.global_position  + Vector2(0.0, 23.0))
	move_and_collide(self.velocity * delta)

func _get_hit(damage):
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		health -= damage
		if health <= 0:
			health = 0
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
		else:
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
			

