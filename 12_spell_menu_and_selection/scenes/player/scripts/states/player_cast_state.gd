extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var spell_selection_menu = character_body.get_node('SpellSelectionMenu')

func Enter():
	animation_tree.get("parameters/playback").travel('cast')
	animation_tree.set("parameters/cast/BlendSpace2D/blend_position", character_body.direction)
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func cast_spell():
	if spell_selection_menu.current_selected_spell != null:
		var current_spell = spell_selection_menu.current_selected_spell.instantiate()
		current_spell.position = character_body.position + character_body.direction * 20 # TODO: Add attribute for spell location in reference to character_body
		get_tree().current_scene.add_child(current_spell)
	else:
		print('No spell selected')



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["cast_left", "cast_right", "cast_up", "cast_down"]:
		cast_spell()
		if character_body.movement:
			if character_body.run:
				state_transition.emit(self, 'run')
			else:
				state_transition.emit(self, 'walk')
		else:
			state_transition.emit(self, 'idle')
