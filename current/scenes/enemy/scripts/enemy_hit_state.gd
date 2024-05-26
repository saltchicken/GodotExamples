extends State

@onready var character_body = self.get_owner()

#var DECELERATION_SPEED = 25.0

func Enter():
	character_body._hit()
	character_body.velocity = -character_body.direction_to_player * 10.0
	
func Exit():
	pass
	
func Update(_delta:float):
	# TODO: Implement taking damage
	pass

func _on_animation_player_animation_finished(_anim_name):
	state_transition.emit(self, 'idle') # TODO: Should this revert to the previous state and not just idle
