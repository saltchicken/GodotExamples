extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"
@onready var spell_selection_menu = character_body.get_node('SpellSelectionMenu')

func Enter():
	animation_tree.get("parameters/playback").travel('cast')
	#animation_tree.set("parameters/death/BlendSpace2D/blend_position", character_body.direction_to_player) # TODO: Direction of death to be implemented here and in AnimationTree
	#character_body.velocity = -character_body.direction_to_player * 10.0
	character_body.velocity = Vector2(0.0, 0.0)
	
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func cast_spell():
	#var spell_selection_menu = character_body.get_node('SpellSelectionMenu')
	#var current_selected_spell_slot = spell_selection_menu.spell_choices[spell_selection_menu.selected_spell]
	#var current_selected_spell = null
	#if current_selected_spell_slot.get_child_count() > 0:
		#current_selected_spell = current_selected_spell_slot.get_children()[0]
	if spell_selection_menu.current_selected_spell != null:
		var current_spell = load(spell_selection_menu.current_selected_spell.data.scene).instantiate()
		current_spell.position = character_body.position + character_body.direction * 40 # TODO: Add attribute for spell location in reference to character_body
		get_tree().current_scene.add_child(current_spell)
	else:
		print('No spell selected')
	#game_scene.add_child(current_spell)



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cast":
		cast_spell()
		if character_body.movement:
			if character_body.run:
				state_transition.emit(self, 'run')
			else:
				state_transition.emit(self, 'walk')
		else:
			state_transition.emit(self, 'idle')
