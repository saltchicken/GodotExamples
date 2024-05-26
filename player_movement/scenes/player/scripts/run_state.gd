extends State

@onready var character_body = self.get_owner()
@export var sprite : AnimatedSprite2D

var SPEED = 100.0

func Enter():
	character_body._run()	
	
func Exit():
	pass
	
func Update(_delta:float):
	if character_body.movement:
		if !character_body.run:
			state_transition.emit(self, 'walk')
		else:
			character_body.velocity.x = character_body.movement.x * SPEED
			character_body.velocity.y = character_body.movement.y * SPEED
	else:
		state_transition.emit(self, 'idle')
