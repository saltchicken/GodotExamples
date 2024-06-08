extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers

@onready var item_slot_reference: Array = get_inventory_slots()
@onready var equipment_slot_reference: Array = get_equipment_slots()
@onready var item_and_equipment_slot_reference: Array = item_slot_reference + equipment_slot_reference
@onready var InvSize = item_slot_reference.size()
@onready var InventoryEquipmentSize = item_and_equipment_slot_reference.size()

func _ready() -> void:
	print(player)
	for slot in item_and_equipment_slot_reference:
		slot.change_inventory.connect(inventory_changed.bind(slot))

func get_inventory_slots():
	return get_node('Inventory/VBoxContainer/HBoxContainer').get_children() + get_node('Inventory/VBoxContainer/HBoxContainer2').get_children()
	
func get_equipment_slots():
	return get_node('Equipment').get_children()
	
func inventory_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	apply_equipment_modifiers()
	
func apply_equipment_modifiers():
	for slot in item_and_equipment_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				item.data.apply_upgrade(player)
	print('Applied equipment modifiers')
