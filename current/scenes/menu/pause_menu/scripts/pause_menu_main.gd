extends CanvasLayer

@onready var player = get_parent()
@onready var style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/item_slot.tres')
@onready var selected_style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/highlighted_item_slot.tres')

@onready var selected_slot: int = 0: set = _set_selected_slot

@onready var tabs: Array = [%InventoryMenu, %SpellsMenu, %QuestMenu, %SystemMenu]
@onready var selected_tab = %InventoryMenu

@onready var purse_label = get_node('%InventoryMenu/PurseLabel')

func _set_selected_slot(new_value):
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= %InventoryMenu.InvSize and previous_slot < %InventoryMenu.InvSize:
		selected_slot = 24
	elif new_value >= %InventoryMenu.InventoryEquipmentSize:
		selected_slot = %InventoryMenu.InventoryEquipmentSize - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
		
func select_new_slot(previous_slot, new_slot):
	%InventoryMenu.item_and_equipment_slot_reference[previous_slot].add_theme_stylebox_override('panel', style_box)
	%InventoryMenu.item_and_equipment_slot_reference[new_slot].add_theme_stylebox_override('panel', selected_style_box)
	
func _ready():
	self.visible = false
	get_node('BlurRect').set_size(get_viewport().get_visible_rect().size)
	set_purse_text()
	
func _process(_delta):
	# TODO: Move this to main function with other inputs
	if Input.is_action_just_pressed('inventory') or Input.is_action_just_pressed('escape'):
		if self.visible:
			close_pause_menu()
		else:
			open_pause_menu()
	if self.visible:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_slot -= 1
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_slot += 1
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			if selected_slot <= %InventoryMenu.InvSize:
				selected_slot -= %InventoryMenu.InvSize / 2
			else:
				selected_slot -= 2
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			if selected_slot < %InventoryMenu.InvSize:
				selected_slot += %InventoryMenu.InvSize / 2
			else:
				selected_slot += 2
			
func open_pause_menu():
	self.visible = true
	%InventoryMenu.item_and_equipment_slot_reference[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	get_tree().paused = true
	
func close_pause_menu():
	self.visible = false
	#%InventoryMenu.item_and_equipment_slot_reference[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	get_tree().paused = false
	

	
func get_inventory():
	print('TODO: Implement checking inventory')
	for slot in %InventoryMenu.item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				print(item.data.get_path())
			
func save_inventory():
	var inventory_list = []
	for slot in %InventoryMenu.item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				inventory_list.append(item.data.get_path())
	return inventory_list
	
func save_equipment():
	var equipment_list = []
	var slotsCheck = %InventoryMenu.equipment_slot_reference
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				equipment_list.append(item.data.get_path())
	return equipment_list
		
			
func is_in_inventory(): # TODO: Implement 
	pass

func set_purse_text():
	purse_label.text = 'Purse: %s' % str(player.purse)
	
func _on_player_update_purse() -> void:
	set_purse_text()
