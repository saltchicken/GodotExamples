extends State

@onready var character_body = self.get_owner()

var SPEED = 25.0

func Enter():
	character_body._chase()	
	
func Exit():
	pass
	
func Update(_delta:float):
	if character_body.distance_to_player < character_body.CHASE_DISTANCE:
		character_body.velocity.x = character_body.direction_to_player.x * SPEED
		character_body.velocity.y = character_body.direction_to_player.y * SPEED
	else:
		state_transition.emit(self, 'idle')
