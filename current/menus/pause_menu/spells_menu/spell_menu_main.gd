extends Node

@onready var player = get_owner().get_owner() # TODO: Better way to reference player for applying equipment modifiers

@onready var spell_slots: Array = get_node('Spells/VBoxContainer/HBoxContainer').get_children()
@onready var current_spells_slots: Array = get_node('CurrentSpells').get_children()

func _ready() -> void:
	add_to_group('Persist')
	for slot in spell_slots:
		slot.change_spell.connect(spell_changed.bind(slot))
	
	for slot in current_spells_slots:
		slot.change_spell.connect(spell_changed.bind(slot))
		
	# FOR TESTING
	#load_item_into_spell("res://spells/whirlwind/whirlwind.tres", 0)
	#load_item_into_spell("res://spells/fireball/fireball.tres", 1)
	#load_item_into_spell("res://spells/lightning_bolt/lightning_bolt.tres", 4)
	
func load_item_into_spell(path_to_item, slot_index):
	var spell := SpellItem.new()
	spell.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	spell_slots[slot_index].add_child(spell)
	
func load_item_into_current_spells(path_to_item, slot_index):
	var spell := SpellItem.new()
	spell.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	#%Inventory.get_child(slot_index).add_child(item)
	current_spells_slots[slot_index].add_child(spell)
	
func spell_changed(slot):
	print('%s changed. Is there a way to check where it changed from?' % slot) # TODO: Check where slot changed from
	#if slot == current_spell:
		#print('Current Spell changed. Currently no logic is being applied')
	#if current_spell.get_child_count() > 0:
		#player.current_spell = load(slot.get_children()[0].data.scene)
	#else:
		#player.current_spell = null
		
func save():
	var save_dict = {
		"node_name" : self.name,
		"spell_slots" : SceneManager.save_slots_to_dict(spell_slots),
		"current_spells_slots" : SceneManager.save_slots_to_dict(current_spells_slots)
	}
	return save_dict
	
func load(node_data):
	for item in node_data['spell_slots'].keys():
		load_item_into_spell(item, node_data['spell_slots'][item])
	for item in node_data['current_spells_slots'].keys():
		load_item_into_current_spells(item, node_data['current_spells_slots'][item])
	player.get_node('SpellSelectionMenu').spell_menu_spell_changed(null) #TODO: Shouldn't be passing null here.
	
#func save_spells():
	#var spell_dict = {}
	#for i in range(spell_slots.size()):
		#var slot = spell_slots[i]
		#if slot.get_child_count() > 0:
			#var spell = slot.get_child(0)
			#if spell:
				#spell_dict[spell.data.get_path()] = i
	#return spell_dict
	#
#func save_current_spells():
	#var current_spells_dict = {}
	#for i in range(current_spells_slots.size()):
		#var slot = current_spells_slots[i]
		#if slot.get_child_count() > 0:
			#var spell = slot.get_child(0)
			#if spell:
				#current_spells_dict[spell.data.get_path()] = i
	#return current_spells_dict
	
	#func save_inventory():
	#var inventory_dict = {}
	#for i in range(item_slots.size()):
		#var slot = item_slots[i]
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item:
				#inventory_dict[item.data.get_path()] = i
	#return inventory_dict
	#
#func save_equipment():
	#var equipment_dict = {}
	#for i in range(equipment_slots.size()):
		#var slot = equipment_slots[i]
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item:
				#equipment_dict[item.data.get_path()] = i
	#return equipment_dict
	
