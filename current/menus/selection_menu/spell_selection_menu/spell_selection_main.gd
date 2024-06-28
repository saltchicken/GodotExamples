extends Node

@onready var player = get_owner()
@onready var cast_input
@onready var cast_held
@onready var cast_held_duration: float = 0.0
@onready var spell_selection_menu_open: bool = false
#@onready var selected_spell
@onready var selected_spell: int = 0: set = _set_selected_spell
@onready var spell_choices: Array = get_children()
@onready var current_selected_spell = null

@onready var pause_menu = player.get_node('PauseMenu')
@onready var spell_menu = pause_menu.get_node('MenuTabs/Spells/SpellsMenu')

@onready var style_box = preload('res://menus/selection_menu/spell_selection_menu/spell_selection_unselected.tres')
@onready var selected_style_box = preload('res://menus/selection_menu/spell_selection_menu/spell_selection_selected.tres')

func _set_selected_spell(new_value):
	var previous_spell = selected_spell
	if new_value < 0:
		selected_spell = 3
	elif new_value > 3:
		selected_spell = 0
	else:
		selected_spell = new_value
	select_new_slot(previous_spell, selected_spell)
	select_current_spell()
	
func select_new_slot(previous_spell, new_spell):
	spell_choices[previous_spell].add_theme_stylebox_override('panel', style_box)
	spell_choices[new_spell].add_theme_stylebox_override('panel', selected_style_box)

func _ready() -> void:
	add_to_group('Persist')
	self.visible = false
	select_new_slot(0, selected_spell)
	
	for slot in spell_menu.spell_slots:
		slot.change_spell.connect(spell_menu_spell_changed.bind(slot))
	
	for slot in spell_menu.current_spells_slots:
		slot.change_spell.connect(spell_menu_spell_changed.bind(slot))
	
func spell_menu_spell_changed(_slot):
	get_current_spells()
	select_current_spell()
	
		
func select_current_spell():
	var current_selected_spell_slot = spell_choices[selected_spell]
	if current_selected_spell_slot.get_child_count() > 0:
		current_selected_spell = load(current_selected_spell_slot.get_children()[0].data.scene)
	else:
		current_selected_spell = null

func _physics_process(delta: float) -> void:
	player.cast = cast_held_logic(delta)
	if self.visible and !pause_menu.visible:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_spell = 3
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_spell = 1
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			selected_spell = 0
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			selected_spell = 2
		# TODO: Leaving commented code in case spell selection should act as a wheel.
		#if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			#selected_spell -= 1
		#if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			#selected_spell += 1
		#if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			#selected_spell += 2
		#if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			#selected_spell -= 2
				
func get_current_spells():
	var spell_menu_current_spells = pause_menu.get_node('MenuTabs/Spells/SpellsMenu/CurrentSpells').get_children()
	
	# TODO: Do I really have to clear out all of the values everytime?
	for spell_choice in spell_choices:
		if spell_choice.get_child_count() > 0:
			var child_to_remove = spell_choice.get_children()[0]
			spell_choice.remove_child(child_to_remove)
			child_to_remove.queue_free()
	# TODO: Maybe add some checking to make sure there are four current spells. That is the current hardcode. With flexibility can add to the spell wheel. SPELL WHEEL SHOULD BE THE NAME.
	for i in range(spell_menu_current_spells.size()):
		if spell_menu_current_spells[i].get_child_count() > 0:
			spell_choices[i].add_child(spell_menu_current_spells[i].get_children()[0].duplicate())
			#print(spell_choices[i])
			#print(spell_menu_current_spells[i].get_children()[0])
			#if spell_choices[i].get_child_count() > 0:
				#print(spell_choices[i].get_children()[0])
			
		
func open_spell_menu():
	spell_selection_menu_open = true
	self.visible = true
	get_tree().paused = true

func close_spell_menu():
	spell_selection_menu_open = false
	self.visible = false
	get_tree().paused = false
	
func cast_held_logic(delta):
	if !pause_menu.visible:
		cast_held = Input.is_action_pressed('cast')
		cast_input = false
		if cast_held:
			cast_held_duration += delta
			if cast_held_duration > 0.33 and !spell_selection_menu_open:
				open_spell_menu()
		else:
			if cast_held_duration <= 0.33 and cast_held_duration > 0.0:
				cast_input = true
			else:
				if spell_selection_menu_open:
					close_spell_menu()		
			cast_held_duration = 0.0
		return cast_input
	else:
		return false
		
func save():
	var save_dict = {
		"node_name" : self.name,
		"selected_spell" : selected_spell
	}
	return save_dict
	
func load(node_data):
	selected_spell = node_data["selected_spell"]
