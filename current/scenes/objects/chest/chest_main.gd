extends StaticBody2D
class_name Chest

@export var item: ItemData
@onready var item_taken = false
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character

@export var initial_state : State

func use():
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
