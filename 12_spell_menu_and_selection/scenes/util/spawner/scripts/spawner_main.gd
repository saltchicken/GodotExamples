extends Area2D

@onready var space_occupied: bool = true

func _process(delta):
	var bodies = self.get_overlapping_bodies()
	if bodies:
		space_occupied = true
	else:
		space_occupied = false
	#if Input.is_action_just_pressed("rightclick"):
		#var enemy_position = Vector2(100.0, 100.0) 
		##Global.check_if_space_occupied(self, enemy_position)
		#Global.spawn_enemy(self, enemy_position)
