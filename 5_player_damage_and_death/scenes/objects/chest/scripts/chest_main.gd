extends StaticBody2D
class_name Chest
@onready var state_machine = $StateMachine
@onready var animation_tree = $AnimationTree
	
func _use():
	if state_machine.current_state.name == 'closed':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'open')
