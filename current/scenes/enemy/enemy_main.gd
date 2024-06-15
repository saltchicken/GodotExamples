extends CharacterBody2D
class_name Enemy
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

@export var idle_direction = Vector2(0.0, 1.0)
		
@onready var distance_to_player
@onready var direction_to_player

@export var default_stats: EnemyStats
@onready var stats: EnemyStats = default_stats.duplicate()

@onready var attack_reach = stats.attack_reach
@onready var attack_damage = stats.attack_damage
@onready var attack_knockback = stats.attack_knockback
@onready var defense = stats.defense
@onready var health = stats.health
@onready var chase_distance = stats.chase_distance
@onready var chase_speed = stats.chase_speed
@onready var knockback_protection = stats.knockback_protection

@onready var hit_indicator_offset: Vector2 = stats.hit_indicator_offset

@onready var collision

func _ready():
	add_to_group('Enemies')

func _physics_process(delta):
	distance_to_player = self.global_position.distance_to(player.global_position)
	direction_to_player = self.global_position.direction_to(player.global_position)
	collision = move_and_collide(self.velocity * delta)

func get_hit(attacking_body):
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', {'attacking_body': attacking_body})
		
func handle_collision_with_player():
	if collision:
		var body = collision.get_collider()
		#print(body)
		if body.has_method('get_hit') and body.get_script() == Player:
			#if obj.state_machine.current_state.name != 'hit' and obj.state_machine.current_state.name != 'death': # TODO: Should this check be added even though its already handled in player.get_hit()
			self.state_machine.current_state.state_transition.emit(self.state_machine.current_state, 'collision_attack')
			#add_collision_exception_with(body)
			body.get_hit(self)
