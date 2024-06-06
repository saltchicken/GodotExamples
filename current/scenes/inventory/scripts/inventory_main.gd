extends CanvasLayer

@onready var player = get_parent()
@onready var style_box = preload('res://scenes/inventory/themes/item_slot.tres')
@onready var selected_style_box = preload('res://scenes/inventory/themes/highlighted_item_slot.tres')

var InvSize = 24
@onready var item_slot_reference: Array = get_inventory_slots()
@onready var equipment_slot_reference: Array = %Equipment.get_children()
@onready var selected_slot: int = 0: set = _set_selected_slot

func _set_selected_slot(new_value):
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= InvSize:
		selected_slot = InvSize - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
		
func select_new_slot(previous_slot, new_slot):
	item_slot_reference[previous_slot].add_theme_stylebox_override('panel', style_box)
	item_slot_reference[new_slot].add_theme_stylebox_override('panel', selected_style_box)
	
func get_inventory_slots():
	return %Inventory.get_node('VBoxContainer/HBoxContainer').get_children() + %Inventory.get_node('VBoxContainer/HBoxContainer2').get_children()
	
func _ready():
	self.visible = false
		
	#_load_items_from_file()
	#get_inventory()
	#check_inventory.connect(get_inventory)
	
func _process(_delta):
	#if Input.is_action_just_pressed('inventory'):
	#if Input.is_action_just_pressed('TESTTESTTEST'):
		#get_inventory()
		#get_equipment()
	# TODO: Move this to main function with other inputs
	if Input.is_action_just_pressed('inventory') or Input.is_action_just_pressed('escape'):
		toggle_inventory()
	if self.visible:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_slot -= 1
			print(selected_slot)
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_slot += 1
			print(selected_slot)
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			selected_slot -= InvSize / 2
			print(selected_slot)
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			selected_slot += InvSize / 2
			print(selected_slot)
		
func toggle_inventory():
	self.visible = !self.visible
	item_slot_reference[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	get_tree().paused = !get_tree().paused

func get_first_open_slot():
	for i in item_slot_reference.size():
		if item_slot_reference[i].get_child_count() == 0:
			return i
	return -1 # TODO: Better error handling for when inventory is full

func load_item_into_inventory(path_to_item, slot_index):
	var item := InventoryItem.new()
	item.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	item_slot_reference[slot_index].add_child(item)
	
#func _load_items_from_file():
	#var itemsLoad = [
	#"res://scenes/inventory/item/sword.tres",
	#"res://scenes/inventory/item/bow.tres"
#]
	#for i in itemsLoad.size():
		#_load_item_into_inventory(itemsLoad[i], i)
		##_load_item_into_inventory(itemsLoad[i], _get_first_open_slot())
		##item.add_to_group('items')

func collect_item(item):
	print(get_first_open_slot())
	load_item_into_inventory(item, get_first_open_slot())
	

		
func get_inventory():
	print('TODO: Implement checking inventory')
	for slot in item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				print(item.data.get_path())
			
func save_inventory():
	var inventory_list = []
	for slot in item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				inventory_list.append(item.data.get_path())
	return inventory_list
	
func save_equipment():
	var equipment_list = []
	var slotsCheck = %Equipment.get_children()
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				equipment_list.append(item.data.get_path())
	return equipment_list
	
func apply_equipment_modifiers():
	for slot in equipment_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				item.data.apply_upgrade(player)
	print('Applied equipment modifiers')
		
			
func is_in_inventory(): # TODO: Implement 
	pass

func _on_resume_pressed():
	toggle_inventory()

func _on_restart_pressed():
	#print('This is not implemented')
	# TODO: Add a confirmation pop up to make sure user wants to restart
	toggle_inventory()
	Global.restart()
	
func _on_quit_pressed():
	# TODO: Add a confirmation pop up to make sure user wants to restart
	toggle_inventory()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
	
func _on_load_latest_save_pressed():
	Global.load_game()
	pass # Replace with function body.

func _on_head_slot_change_inventory():
	print('Inventory head_slot changed')
	apply_equipment_modifiers()

func _on_weapon_slot_change_inventory():
	print('Inventory weapon_slot changed')
	apply_equipment_modifiers()


func _on_chest_slot_change_inventory():
	print('Inventory chest_slot changed')
	apply_equipment_modifiers()


func _on_legs_slot_change_inventory():
	print('Inventory legs_slot changed')
	apply_equipment_modifiers()


func _on_feet_slot_change_inventory():
	print('Inventory feet_slot changed')
	apply_equipment_modifiers()
