extends State

@onready var character_body = self.get_owner()
@onready var animated_sprite = $"../../AnimatedSprite2D"

func Enter():
	animated_sprite.play("off")
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
