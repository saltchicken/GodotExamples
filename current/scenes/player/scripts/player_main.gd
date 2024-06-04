extends CharacterBody2D
class_name Player
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var use_hitbox = $UseArea
#@onready var attack_hitbox = $AttackArea

@onready var inventory = $InventoryMenu

@export var initial_state : State

var DEFAULT_DIRECTION = Vector2(0.0, 1.0) # Down
@onready var direction = DEFAULT_DIRECTION		
@onready var movement
@onready var run
@onready var attack
@onready var cast
@onready var use

@export var stats: PlayerStats

@onready var base_attack_damage = stats.base_attack_damage
@onready var attack_damage = stats.base_attack_damage
@onready var base_defense = stats.base_defense
@onready var defense = stats.base_defense

@onready var use_reach = stats.use_reach
@onready var attack_reach = stats.attack_reach
@onready var health = stats.health

@onready var walk_speed = stats.walk_speed
@onready var run_speed = stats.run_speed

@onready var knockback_protection = stats.knockback_protection

@onready var current_spell = preload("res://scenes/spell/tornado/tornado.tscn")

func _ready():
	add_to_group('Players')
	add_to_group('Persist')

func _physics_process(delta):
	get_input()
	move_and_collide(self.velocity * delta)

func get_input():
	movement = Input.get_vector("left", "right", "up", "down")
	run = Input.is_action_pressed('run')
	attack = Input.is_action_just_pressed('attack')
	cast = Input.is_action_just_pressed('cast')
	use = Input.is_action_just_pressed('use')
	
func get_direction():
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
			
func handle_use_hitbox_direction():
	use_hitbox.position = direction * use_reach
	
func get_hit(attacking_body):
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', {'attacking_body': attacking_body})
	
func use_objects():
	var useable_objects = use_hitbox.get_overlapping_bodies()
	if useable_objects:
		#var obj = useable_objects[0]
		#obj._use()
		#var obj = useable_objects.front()
		#if obj.get_script() == Chest:
			#obj._use()
		for obj in useable_objects: # TODO: This needs better logic to choose the closest chest or useable object.
			#print(obj)
			if obj.get_script() == Chest:
				obj.use()
				break
				
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"inventory" : inventory.save_inventory(),
		"equipment" : inventory.save_equipment()
		#"current_state" : state_machine.current_state.name
	}
	return save_dict

func load_player(node_data):
	if node_data.has('current_state'):
		initial_state = get_node('StateMachine').get_node(node_data['current_state'])
		node_data.erase('current_state')
	
	
	position = Vector2(node_data["pos_x"], node_data["pos_y"])

	# Now we set the remaining variables.
	for i in node_data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "inventory" or i == "equipment":
			continue
		set(i, node_data[i])
		
	print(node_data['inventory'])
	print(node_data['equipment'])
