extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	print('Player has been hit. Health remaining: ' + str(character_body.stats.health)) # TODO: Implement way of monitoring health
	animation_tree.get("parameters/playback").start('hit')
	#animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
	character_body.velocity = character_body.direction_from_enemy * (200.0 / character_body.stats.knockback_protection)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, 5.0)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, 5.0)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'hit':
		state_transition.emit(self, 'idle')
