extends StaticBody2D

@export var initial_state : State
@onready var state_machine = $StateMachine
@onready var area_2d: Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Bonfires")
	area_2d.body_entered.connect(bonfire_visible)
	area_2d.body_exited.connect(bonfire_not_visible)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use():
	if state_machine.current_state.name == 'off':
		state_machine.current_state.state_transition.emit(state_machine.current_state, 'on')
		var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
		area_2d.body_entered.emit(player)
		
func bonfire_visible(body):
	if body.get_script() == Player:
		print('bonfire_visible')
		if state_machine.current_state.name == 'on':
			for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.get_node("VisibleOnScreenNotifier2D").is_on_screen() == false:
					enemy.despawn()
				else:
					if enemy.has_method("run_away"):
						enemy.run_away()
					else:
						print("Error: Enemy doesn't have run_away method")
	
func bonfire_not_visible(body):
	if body.get_script() == Player:
		print('bonfire not visible')
		if state_machine.current_state.name == 'on':
			for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.state_machine.current_state.name == 'run_away':
					#print('Disconnecting despawn')
					enemy.get_node('VisibleOnScreenNotifier2D').screen_exited.disconnect(enemy.despawn)
					enemy.idle()
