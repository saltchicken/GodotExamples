extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers

@onready var spell_slots: Array = get_node('Spells/VBoxContainer/HBoxContainer').get_children()
@onready var current_spells_slots: Array = get_node('CurrentSpells').get_children()

func _ready() -> void:
	for slot in spell_slots:
		slot.change_spell.connect(spell_changed.bind(slot))
	
	for slot in current_spells_slots:
		slot.change_spell.connect(spell_changed.bind(slot))
		
	# FOR TESTING
	load_item_into_spell("res://scenes/spell/whirlwind/whirlwind.tres", 0)
	load_item_into_spell("res://scenes/spell/fireball/fireball.tres", 1)
	
func load_item_into_spell(path_to_item, slot_index):
	var spell := SpellItem.new()
	spell.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	spell_slots[slot_index].add_child(spell)
	
func spell_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	#if slot == current_spell:
		#print('Current Spell changed. Currently no logic is being applied')
	#if current_spell.get_child_count() > 0:
		#player.current_spell = load(slot.get_children()[0].data.scene)
	#else:
		#player.current_spell = null
	
