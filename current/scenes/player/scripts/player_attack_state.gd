extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var attack_hitbox = $"../../AttackArea"
@onready var attack_collision = $"../../AttackArea/CollisionShape2D"
@onready var use_area_collision = $"../../UseArea/CollisionShape2D"


var DECELERATION_SPEED = 10.0

func Enter():
	animation_tree.get("parameters/playback").start('attack')
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", character_body.direction)
	attack_collision.disabled = false
	use_area_collision.disabled = true
	_handle_attack_hitbox_direction()
	
func Exit():
	attack_collision.disabled = true
	use_area_collision.disabled = false
	
func Update(_delta:float):
	character_body.velocity.x = move_toward(character_body.velocity.x, 0, DECELERATION_SPEED)
	character_body.velocity.y = move_toward(character_body.velocity.y, 0, DECELERATION_SPEED)
	
	var bodies = attack_hitbox.get_overlapping_bodies()
	if bodies:
		#var useable_object = useable_objects.front()
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				body._get_hit()
				#var body_current_state = body.state_machine.current_state
				#if body_current_state.name != 'hit':
					## TODO: Handle logic better to decide what states can be hit
					#if body_current_state.name == 'idle':
						##print(body.name + ' is ' + body_current_state.name)
						#body.state_machine.current_state.state_transition.emit(body_current_state, 'hit')
					#elif body_current_state.name == 'chase':
						##print(body.name + ' is ' + body_current_state.name)
						#body.state_machine.current_state.state_transition.emit(body_current_state, 'hit')
					#else:
						#print('unhandled enemy state')
					#body._hit()
					#body.state_machine.current_state.state_transition.emit(self, 'test')
					#body.hitable = false
					#print('Hit ' + body.name)
			#if obj.get_script() == Chest:
				#obj.use()

#func _on_animation_player_animation_finished(_anim_name):
	#if character_body.movement:
		#if character_body.run:
			#state_transition.emit(self, 'run')
		#else:
			#state_transition.emit(self, 'walk')
	#else:
		#state_transition.emit(self, 'idle')
		
func _handle_attack_hitbox_direction():
	if character_body.direction == Vector2(0, 1):
		attack_hitbox.position.x = 0
		attack_hitbox.position.y = character_body.attack_reach
	elif character_body.direction == Vector2(0, -1):
		attack_hitbox.position.x = 0
		attack_hitbox.position.y = -character_body.attack_reach
	elif character_body.direction == Vector2(-1, 0):
		attack_hitbox.position.x = -character_body.attack_reach
		attack_hitbox.position.y = 0
	elif character_body.direction == Vector2(1, 0):
		attack_hitbox.position.x = character_body.attack_reach
		attack_hitbox.position.y = 0


func _on_animation_tree_animation_finished(_anim_name):
	if character_body.movement:
		if character_body.run:
			state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'walk')
	else:
		state_transition.emit(self, 'idle')
