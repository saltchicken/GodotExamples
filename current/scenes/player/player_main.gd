extends CharacterBody2D
class_name Player
@onready var state_machine = $StateMachine
#@onready var animation_tree = $AnimationTree
@onready var use_hitbox = $UseArea
@onready var pickup_hitbox = $PickupArea
#@onready var attack_hitbox = $AttackArea

@onready var inventory = $PauseMenu/MenuTabs/Inventory/InventoryMenu
@onready var quests = $PauseMenu/MenuTabs/Quests/QuestMenu

@export var initial_state : State

var JOYSTICK_DEADZONE: float = 0.2

var DEFAULT_DIRECTION = Vector2(0.0, 1.0) # Down
@onready var direction = DEFAULT_DIRECTION		
@onready var movement
@onready var joystick_movement
@onready var walk
@onready var attack

@onready var cast
@onready var use
@onready var dash
@onready var dash_cooldown = 0.0

@export var default_stats: PlayerStats
@onready var stats: PlayerStats = default_stats.duplicate()

@onready var hit_indicator_offset: Vector2 = Vector2(3.0, 20.0)

signal update_purse
@onready var purse: int = 0: set = set_purse

func set_purse(new_value):
	purse = new_value
	update_purse.emit()
	
func _ready():
	add_to_group('Players')
	update_purse.connect(get_node('PauseMenu/MenuTabs/Inventory/InventoryMenu')._on_player_update_purse)
	inventory.update_stats.connect(calculate_stats)

func _physics_process(delta):
	get_input()
	pickup_items()
	if dash_cooldown > 0.0:
		dash_cooldown -= delta
	move_and_collide(self.velocity * delta)
	
func pickup_items():
	var pickupable_objects = pickup_hitbox.get_overlapping_areas()
	if pickupable_objects:
		for body in pickupable_objects:
			if body != use_hitbox:
				if body.get_script() == Coins:
					collect(body)

# TODO: Add checking for a collectable body
func collect(body):
	purse += body.value
	body.collected()
	
func get_input():
	movement = Input.get_vector("left", "right", "up", "down")
	joystick_movement = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	walk = Input.is_action_pressed('walk')
	attack = Input.is_action_just_pressed('attack')
	use = Input.is_action_just_pressed('use')
	dash = Input.is_action_just_pressed('dash')
	
func get_direction():
	if !handle_joystick_movement():
		if movement:
			if movement.x < 0 and movement.y == 0:
				direction = movement
			elif movement.x > 0 and movement.y == 0:
				direction = movement
			elif movement.y < 0 and movement.x == 0:
				direction = movement
			elif movement.y > 0 and movement.x == 0:
				direction = movement
			
func handle_joystick_movement():
	# TODO: There should be a more elegant way to calculate direction from joystick
	if joystick_movement:
		var magnitude_joystick_movement = abs(joystick_movement)
		if magnitude_joystick_movement.x > magnitude_joystick_movement.y:
			if joystick_movement.x > 0:
				direction = Vector2(1, 0)
			else:
				direction = Vector2(-1, 0)
		else:
			if joystick_movement.y > 0:
				direction = Vector2(0, 1)
			else:
				direction = Vector2(0, -1)
				
		if joystick_movement.x > JOYSTICK_DEADZONE:
			movement.x = 1
		elif joystick_movement.x < -JOYSTICK_DEADZONE:
			movement.x = -1
		else:
			movement.x = 0
		if joystick_movement.y > JOYSTICK_DEADZONE:
			movement.y = 1
		elif joystick_movement.y < -JOYSTICK_DEADZONE:
			movement.y = -1
		else:
			movement.y = 0
		return true
	return false
		#movement = round(joystick_movement)
	
			
func handle_use_hitbox_direction():
	use_hitbox.position = direction * stats.use_reach
	
func get_hit(attacking_body):
	if state_machine.current_state.name != 'hit' and state_machine.current_state.name != 'death':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'hit', {'attacking_body': attacking_body})
		return true
	else:
		return false
		
func killed_enemy(body):
	var objective = OBJECTIVE.new()
	objective.action = 'killed_enemy'
	objective.value = body.stats.name
	quests.handle_objective(objective)
	
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

func calculate_stats():
	var new_stats = default_stats.duplicate()
	for slot in inventory.equipment_slots:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				item.data.apply_upgrade(new_stats)
			else:
				print("Error: Issue with getting equipment")
	stats = new_stats
	
				
#func save():
	#var save_dict = {
		#"filename" : get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		#"pos_x" : position.x,
		#"pos_y" : position.y,
		#"inventory" : inventory.save_inventory(),
		#"equipment" : inventory.save_equipment()
		##"current_state" : state_machine.current_state.name
	#}
	#return save_dict

#func load_player(node_data):
	#if node_data.has('current_state'):
		#initial_state = get_node('StateMachine').get_node(node_data['current_state'])
		#node_data.erase('current_state')
	#
	#
	#position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
	## Now we set the remaining variables.
	#for i in node_data.keys():
		#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "inventory" or i == "equipment":
			#continue
		#set(i, node_data[i])
		#
	#print(node_data['inventory'])
	#print(node_data['equipment'])
