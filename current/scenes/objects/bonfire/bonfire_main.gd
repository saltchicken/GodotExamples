extends StaticBody2D

@export var initial_state : State
@onready var state_machine = $StateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use():
	if state_machine.current_state.name == 'off':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'on')
