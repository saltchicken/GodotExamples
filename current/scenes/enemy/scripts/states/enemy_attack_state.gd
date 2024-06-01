extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../AttackArea"
@onready var attack_collision = $"../../AttackArea/CollisionShape2D"

func Enter():
	animation_tree.get("parameters/playback").start('attack')
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", character_body.direction_to_player)
	
func Exit():
	pass
	
func Update(_delta:float):	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.get_script() == Player: 
				body.get_hit(character_body.stats.attack_damage, character_body.direction_to_player) 

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'attack':
		state_transition.emit(self, 'idle')
