extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers

@onready var item_slot_reference: Array = get_inventory_slots()
@onready var equipment_slot_reference: Array = get_equipment_slots()
@onready var item_and_equipment_slot_reference: Array = item_slot_reference + equipment_slot_reference
@onready var InvSize = item_slot_reference.size()
@onready var InventoryEquipmentSize = item_and_equipment_slot_reference.size()

@onready var weapon_slot = get_node('Equipment/WeaponSlot')
@onready var current_weapon: get = _get_current_weapon

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
