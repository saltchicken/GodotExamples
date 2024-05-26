extends State

@onready var character_body = self.get_owner()

var DECELERATION_SPEED = 25.0

func Enter():
	character_body._idle()
	
func Exit():
	pass
	
func Update(_delta:float):
	if character_body.distance_to_player < 100:
		state_transition.emit(self, 'chase')
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
		character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
