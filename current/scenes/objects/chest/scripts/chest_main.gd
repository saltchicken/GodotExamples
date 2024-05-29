extends StaticBody2D
class_name Chest

@export var item: ItemData
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character


func _use():
	if state_machine.current_state.name == 'closed':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'open')
