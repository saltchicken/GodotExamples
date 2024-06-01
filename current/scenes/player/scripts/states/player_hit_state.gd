extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var DECELERATION_SPEED = 10.0 # TODO: This should be a knockback protection stat.

func Enter():
	print('Player has been hit. Health remaining: ' + str(character_body.stats.health)) # TODO: Implement way of monitoring health
	animation_tree.get("parameters/playback").start('hit')
	#animation_tree.set("parameters/hit/BlendSpace2D/blend_position", character_body.direction_to_player)
	character_body.velocity = character_body.direction_from_enemy * 200.0
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'hit':
		state_transition.emit(self, 'idle')
