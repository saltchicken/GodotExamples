extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../AttackArea"
@onready var attack_collision = $"../../AttackArea/CollisionShape2D"
@onready var use_area_collision = $"../../UseArea/CollisionShape2D"
@onready var down_sword_sprite = $"../../DownSwordSprite"

func Enter():
	animation_tree.get("parameters/playback").start('attack')
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", character_body.direction)
	attack_collision.disabled = false
	use_area_collision.disabled = true
	handle_attack_hitbox_direction()
	
func Exit():
	attack_collision.disabled = true
	use_area_collision.disabled = false
	down_sword_sprite.visible = false # TODO: Make animation smart enough to make this invisible or have a position it goes to on hit.
	
func Update(_delta:float):
	#character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	#character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	character_body.velocity = Vector2(0.0, 0.0)
	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				body.get_hit(character_body.stats.attack_damage)
		
func handle_attack_hitbox_direction():
	if character_body.direction == Vector2(0, 1):
		attack_hitbox.position.x = 0
		attack_hitbox.position.y = character_body.stats.attack_reach
	elif character_body.direction == Vector2(0, -1):
		attack_hitbox.position.x = 0
		attack_hitbox.position.y = -character_body.stats.attack_reach
	elif character_body.direction == Vector2(-1, 0):
		attack_hitbox.position.x = -character_body.stats.attack_reach
		attack_hitbox.position.y = 0
	elif character_body.direction == Vector2(1, 0):
		attack_hitbox.position.x = character_body.stats.attack_reach
		attack_hitbox.position.y = 0

func _on_animation_tree_animation_finished(anim_name):
	if 'attack' in anim_name:
		if character_body.movement:
			if character_body.run:
				state_transition.emit(self, 'run')
			else:
				state_transition.emit(self, 'walk')
		else:
			state_transition.emit(self, 'idle')
