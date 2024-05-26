extends State

@onready var character_body = self.get_owner()

var DECELERATION_SPEED = 25.0

func Enter():
	character_body._idle()
	
func Exit():
	pass
	
func Update(_delta:float):
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'walk')
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
		character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
