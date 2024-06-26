extends CharacterBody2D
class_name Player
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var use_hitbox = $UseArea
#@onready var attack_hitbox = $AttackArea

var DEFAULT_DIRECTION = Vector2(0.0, 1.0) # Down
@onready var direction = DEFAULT_DIRECTION		
@onready var movement
@onready var run
@onready var attack
@onready var use

@onready var player_health = 100
@onready var use_reach = 10
@onready var attack_reach = 15
@onready var attack_damage = 12

@onready var health = 120

func _ready():
	add_to_group('Players')

func _physics_process(delta):
	_get_input()
	move_and_collide(self.velocity * delta)

func _get_input():
	movement = Input.get_vector("left", "right", "up", "down")
	run = Input.is_action_pressed('run')
	attack = Input.is_action_just_pressed('attack')
	use = Input.is_action_just_pressed('use')
	
func _get_direction():
	# TODO: Handle input from a joystick so that it conforms to (1, 0)
	if movement:
		if movement.x < 0 and movement.y == 0:
			direction = movement
		elif movement.x > 0 and movement.y == 0:
			direction = movement
		elif movement.y < 0 and movement.x == 0:
			direction = movement
		elif movement.y > 0 and movement.x == 0:
			direction = movement
			
func _handle_use_hitbox_direction():
	use_hitbox.position = direction * use_reach
	
func _get_hit(damage):
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		health -= damage
		if health <= 0:
			health = 0
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'death')
		else:
			state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit')
	
func _use_objects():
	var useable_objects = use_hitbox.get_overlapping_bodies()
	if useable_objects:
		#var useable_object = useable_objects.front()
		for obj in useable_objects:
			#print(obj)
			if obj.get_script() == Chest:
				obj._use()
