extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers

@onready var spell_slot_reference: Array = get_spell_slots()
@onready var current_spells_slot_reference: Array = get_current_spells_slots()
#@onready var current_spell = get_node('CurrentSpell')
#@onready var equipment_slot_reference: Array = get_equipment_slots()
#@onready var item_and_equipment_slot_reference: Array = item_slot_reference + equipment_slot_reference
#@onready var InvSize = item_slot_reference.size()
#@onready var InventoryEquipmentSize = item_and_equipment_slot_reference.size()

func _ready() -> void:
	for slot in spell_slot_reference:
		slot.change_spell.connect(spell_changed.bind(slot))
	
	for slot in current_spells_slot_reference:
		slot.change_spell.connect(spell_changed.bind(slot))
		
	# FOR TESTING
	load_item_into_spell("res://scenes/spell/whirlwind/resources/whirlwind.tres", 0)
	load_item_into_spell("res://scenes/spell/fireball/resources/fireball.tres", 1)

func get_spell_slots():
	return get_node('Spells/VBoxContainer/HBoxContainer').get_children()

func get_current_spells_slots():
	return get_node('CurrentSpells').get_children()
	
func load_item_into_spell(path_to_item, slot_index):
	var spell := SpellItem.new()
	spell.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	spell_slot_reference[slot_index].add_child(spell)
	
#func get_equipment_slots():
	#return get_node('Equipment').get_children()
	
func spell_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	#if slot == current_spell:
		#print('Current Spell changed. Currently no logic is being applied')
	#if current_spell.get_child_count() > 0:
		#player.current_spell = load(slot.get_children()[0].data.scene)
	#else:
		#player.current_spell = null
		
	
#func apply_equipment_modifiers():
	#for slot in item_and_equipment_slot_reference:
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item:
				#item.data.apply_upgrade(player)
	#print('Applied equipment modifiers')
