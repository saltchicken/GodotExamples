extends StaticBody2D

@export var initial_state : State
@onready var state_machine = $StateMachine
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Bonfires")
	visible_on_screen_notifier_2d.screen_entered.connect(bonfire_visible)
	visible_on_screen_notifier_2d.screen_exited.connect(bonfire_not_visible)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use():
	if state_machine.current_state.name == 'off':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'on')
		visible_on_screen_notifier_2d.screen_entered.emit()
		
func bonfire_visible():
	print('bonfire_visible')
	if state_machine.current_state.name == 'on':
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if enemy.has_method("run_away"):
				enemy.run_away()
			else:
				print("Error: Enemy doesn't have run_away method")
	
func bonfire_not_visible():
	print('bonfire not visible')
	if state_machine.current_state.name == 'on':
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if enemy.state_machine.current_state.name == 'run_away':
				enemy.idle()
