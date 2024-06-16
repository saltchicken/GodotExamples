extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter(params: Dictionary = {}):
	#print('Player has been hit. Health remaining: ' + str(character_body.stats.health)) # TODO: Implement way of monitoring health
	if params.has('attacking_body'):
		if take_damage_check_death(character_body, params['attacking_body']):
			state_transition.emit(character_body.state_machine.current_state, 'death')
			return
		else:
			animation_tree.get("parameters/playback").start('hit')
			var direction_from_enemy = params['attacking_body'].direction_to_player
			animation_tree.set("parameters/hit/BlendSpace2D/blend_position", -direction_from_enemy)
			var knockback = params['attacking_body'].stats.attack_knockback
			character_body.velocity = direction_from_enemy * (knockback / character_body.stats.knockback_protection)
	
func Exit():
	pass
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, 5.0)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, 5.0)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name in ["hit_left", "hit_right", "hit_up", "hit_down"]:
		state_transition.emit(self, 'idle')
