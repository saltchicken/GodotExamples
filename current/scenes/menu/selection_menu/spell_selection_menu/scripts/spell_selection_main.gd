extends Node

@onready var player = get_owner()
@onready var cast_input
@onready var cast_held
@onready var cast_held_duration: float = 0.0
@onready var spell_selection_menu_open: bool = false
#@onready var selected_spell
@onready var selected_spell: int = 0: set = _set_selected_spell
@onready var spell_choices: Array = get_children()

@onready var pause_menu = player.get_node('PauseMenu')

@onready var style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/item_slot.tres')
@onready var selected_style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/highlighted_item_slot.tres')

func _set_selected_spell(new_value):
	var previous_spell = selected_spell
	if new_value < 0:
		selected_spell = 3
	elif new_value > 3:
		selected_spell = 0
	else:
		selected_spell = new_value
	select_new_slot(previous_spell, selected_spell)
	
func select_new_slot(previous_spell, selected_spell):
	spell_choices[previous_spell].add_theme_stylebox_override('panel', style_box)
	spell_choices[selected_spell].add_theme_stylebox_override('panel', selected_style_box)
	
	
	#var previous_slot = selected_slot
	#if new_value < 0:
		#selected_slot = 0
	#elif new_value >= %InventoryMenu.InvSize and previous_slot < %InventoryMenu.InvSize:
		#selected_slot = 24
	#elif new_value >= %InventoryMenu.InventoryEquipmentSize:
		#selected_slot = %InventoryMenu.InventoryEquipmentSize - 1
	#else:
		#selected_slot = new_value
	#select_new_slot(previous_slot, selected_slot)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(player)
	
	self.visible = false
	select_new_slot(0, selected_spell)

func _physics_process(delta: float) -> void:
	player.cast = cast_held_logic(delta)
	if self.visible and !pause_menu.visible:
		#if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			#selected_spell -= 1
		#if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			#selected_spell += 1
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_spell = 3
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_spell = 1
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			selected_spell = 0
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			selected_spell = 2
		#if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			#if selected_spell <= %InventoryMenu.InvSize:
				#selected_spell -= %InventoryMenu.InvSize / 2
			#else:
				#selected_spell -= 2
		#if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			#if selected_spell < %InventoryMenu.InvSize:
				#selected_spell += %InventoryMenu.InvSize / 2
			#else:
				#selected_spell += 2
				
func get_current_spells():
	var spell_menu_current_spells = pause_menu.get_node('CenteredPanel/SpellsMenu/CurrentSpells').get_children()
	
	# TODO: Do I really have to clear out all of the values everytime?
	for spell_choice in spell_choices:
		if spell_choice.get_child_count() > 0:
			spell_choice.get_children()[0].queue_free()
	# TODO: Maybe add some checking to make sure there are four current spells. That is the current hardcode. With flexibility can add to the spell wheel. SPELL WHEEL SHOULD BE THE NAME.
	for i in range(spell_menu_current_spells.size()):
		if spell_menu_current_spells[i].get_child_count() > 0:
			spell_choices[i].add_child(spell_menu_current_spells[i].get_children()[0].duplicate())
			#print(spell_choices[i])
			#print(spell_menu_current_spells[i].get_children()[0])
			#if spell_choices[i].get_child_count() > 0:
				#print(spell_choices[i].get_children()[0])
			
		
func open_spell_menu():
	print('Open up spell menu')
	get_current_spells()
	spell_selection_menu_open = true
	self.visible = true
	get_tree().paused = true

func close_spell_menu():
	print('Close spell menu')
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
