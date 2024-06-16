extends PlayerState

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var use_area_collision = $"../../UseArea/CollisionShape2D"

@onready var arrow_scene = preload('res://scenes/projectile/arrow/arrow.tscn')

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").start('bow_attack')
	animation_tree.set("parameters/bow_attack/BlendSpace2D/blend_position", character_body.direction)
	use_area_collision.disabled = true
	
func Exit():
	use_area_collision.disabled = false
	
func Update(_delta:float):
	character_body.velocity = Vector2(0.0, 0.0)

func _on_animation_tree_animation_finished(anim_name):
	if anim_name in ["bow_attack_left", "bow_attack_right", "bow_attack_up", "bow_attack_down"]:
		var arrow = arrow_scene.instantiate()
		arrow.position = character_body.position
		get_tree().current_scene.add_child(arrow)
		arrow.direction = character_body.direction
		arrow.velocity = arrow.direction * 600 # TODO: Set this to be the speed of the bow
		if character_body.movement:
			if character_body.walk:
				state_transition.emit(self, 'walk')
			else:
				state_transition.emit(self, 'run')
		else:
			state_transition.emit(self, 'idle')
