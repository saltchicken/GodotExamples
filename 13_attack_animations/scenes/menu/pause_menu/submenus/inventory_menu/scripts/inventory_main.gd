extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers
@onready var pause_menu = get_owner()
@onready var inventory_tab = get_parent()

@onready var style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/item_slot.tres')
@onready var selected_style_box = preload('res://scenes/menu/pause_menu/submenus/inventory_menu/themes/highlighted_item_slot.tres')

@onready var item_slot_reference: Array = get_inventory_slots()
@onready var equipment_slot_reference: Array = get_equipment_slots()
@onready var item_and_equipment_slot_reference: Array = item_slot_reference + equipment_slot_reference
@onready var InvSize = item_slot_reference.size()
@onready var InventoryEquipmentSize = item_and_equipment_slot_reference.size()

@onready var weapon_slot = get_node('Equipment/WeaponSlot')
@onready var current_weapon: get = _get_current_weapon

@onready var selected_slot: int = 0: set = _set_selected_slot

func _set_selected_slot(new_value):
	print(new_value)
	var previous_slot = selected_slot
	if new_value < 0:
		selected_slot = 0
	elif new_value >= InvSize and previous_slot < InvSize:
		selected_slot = 24
	elif new_value >= InventoryEquipmentSize:
		selected_slot = InventoryEquipmentSize - 1
	else:
		selected_slot = new_value
	select_new_slot(previous_slot, selected_slot)
	
func select_new_slot(previous_slot, new_slot):
	item_and_equipment_slot_reference[previous_slot].add_theme_stylebox_override('panel', style_box)
	item_and_equipment_slot_reference[new_slot].add_theme_stylebox_override('panel', selected_style_box)

func _get_current_weapon():
	var child_count = weapon_slot.get_child_count()
	if child_count == 0:
		return null
	elif child_count == 1:
		return weapon_slot.get_children()[0].data
	else:
		print('Issue with get_current_weapon. Return null for safety')
		return null
	return "hello"


#@onready var selected_slot: int = 0: set = _set_selected_slot

func _ready() -> void:
	for slot in item_and_equipment_slot_reference:
		slot.change_inventory.connect(inventory_changed.bind(slot))
		
	item_and_equipment_slot_reference[selected_slot].add_theme_stylebox_override('panel', selected_style_box)
	
	# THIS IS FOR TESTING A DEFAULT ITEM
	load_item_into_inventory("res://resources/items/sword.tres", 0)
	load_item_into_inventory("res://resources/items/bow.tres", 1)
	
func _process(_delta):
	if pause_menu.visible and inventory_tab.visible:
		if Input.is_action_just_pressed('left') or Input.is_action_just_pressed('joystick_left'):
			selected_slot -= 1
		if Input.is_action_just_pressed('right') or Input.is_action_just_pressed('joystick_right'):
			selected_slot += 1
		if Input.is_action_just_pressed('up') or Input.is_action_just_pressed('joystick_up'):
			if selected_slot <= InvSize:
				selected_slot -= InvSize / 2
			else:
				selected_slot -= 2
		if Input.is_action_just_pressed('down') or Input.is_action_just_pressed('joystick_down'):
			if selected_slot < InvSize:
				selected_slot += InvSize / 2
			else:
				selected_slot += 2

func get_inventory_slots():
	return get_node('Inventory/VBoxContainer/HBoxContainer').get_children() + get_node('Inventory/VBoxContainer/HBoxContainer2').get_children()
	
func get_equipment_slots():
	return get_node('Equipment').get_children()
	
func inventory_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	#if current_weapon:
		#print(current_weapon.attack_type)
	#else:
		#print('current weapon is null')
	apply_equipment_modifiers()
	
func apply_equipment_modifiers():
	for slot in item_and_equipment_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				item.data.apply_upgrade(player)
	print('Applied equipment modifiers')
	
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
	#print(get_first_open_slot())
	load_item_into_inventory(item, get_first_open_slot())
	
func get_first_open_slot():
	for i in item_slot_reference.size():
		if item_slot_reference[i].get_child_count() == 0:
			return i
	return -1 # TODO: Better error handling for when inventory is full
