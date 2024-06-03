extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter(params: Dictionary = {}):
	if params.has('damage'):
		Global.hit_indicator(self, str(params['damage']), 3.0, 20.0)
	animation_tree.get("parameters/playback").travel('death')
	#animation_tree.set("parameters/death/BlendSpace2D/blend_position", character_body.direction_to_player) # TODO: Direction of death to be implemented here and in AnimationTree
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	
func Exit():
	pass
	
func Update(_delta:float):
	# TODO: Implement taking damage
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == 'death':
		print('Handle death properly. If use queue_free then enemy calculations error')
		#character_body.queue_free()
