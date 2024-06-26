extends StaticBody2D
class_name Chest

@export var item: ItemData
@onready var item_taken = false
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

func init(item_name, initial_state):
	item = item_name
	#initial_state = get_node('StateMachine').get_node('open')
	#print('initial state should be ' + initial_state)
	#state_machine.current_state = get_node('StateMachine').get_node(initial_state)
	#print("Initial state " + initial_state)
	#var initial_state_node = get_node('StateMachine/' + initial_state)
	#initial_state = initial_state_node
	#state_machine.change_state(state_machine.current_state, initial_state)
	#state_machine.current_state.Enter()
	#add_to_group("Persist")
	
func _ready():
	add_to_group("Persist") # TODO: Should this be done in the UI instead

func _use():
	#print("Current state is " + state_machine.current_state.name)
	if state_machine.current_state.name == 'closed':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'opening')
		
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"current_state" : state_machine.current_state.name,
		"item" : item.get_path(),
		"item_taken" : item_taken
	}
	return save_dict
