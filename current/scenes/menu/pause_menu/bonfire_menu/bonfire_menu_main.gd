extends Node

#@onready var active_quests: Array[QuestResource]
#@onready var active_quests_container = get_node('VBoxContainer')

#@onready var bonfire = load('res://scenes/objects/bonfire/Grasslands.tres')
#@onready var known_bonfires: Array[Bonfire] = [bonfire]
#@onready var green_slime_quest = load('res://scenes/menu/pause_menu/quest_menu/quests/green_slime_quest.tres')
#@onready var active_quests: Array[QuestResource] = [red_slime_quest, green_slime_quest]

@onready var known_bonfires: Array = []
@onready var known_bonfires_container = get_node('VBoxContainer')

func _ready():
	add_to_group('Persist')

#func handle_objective(objective: OBJECTIVE):
	#for quest in active_quests:
		#if quest.action == objective.action and quest.requirement == objective.value:
			#quest.increment()
			
#func update_quest(quest):
	#quest.update_label()
	
func save():
	var save_dict = {
		"node_name" : self.name,
		"known_bonfires" : get_bonfires()
	}
	return save_dict
	
func load(node_data):
	#pass
	for bonfire in node_data['known_bonfires'].keys():
		known_bonfires.append(bonfire)
	load_known_bonfires()
	#for quest in node_data['quests'].keys():
		#var quest_instance = load(quest)
		#quest_instance.status = node_data['quests'][quest]
		#active_quests.append(quest_instance)
	#load_active_quests()
	
func load_known_bonfires():
	for bonfire in known_bonfires:
		var bonfire_instance = load(bonfire)
		bonfire_instance.update_label()
		known_bonfires_container.add_child(bonfire_instance.label)
		#quest.quest_updated.connect(update_quest)
		
func get_bonfires():
	var dict = {}
	for bonfire in known_bonfires:
		var bonfire_instance = load(bonfire)
		dict[bonfire] = bonfire_instance.status
	return dict
		

#func load_active_quests():
	#for quest in active_quests:
		#active_quests_container.add_child(quest.label)
		#quest.update_label()
		#quest.quest_updated.connect(update_quest)

#func load_quest_into_container(path_to_quest):
	#var quest := load(path_to_quest)
	#activeQuestsContainer.add_child(quest.label)
	#quest.update_label()
	#quest.quest_updated.connect(update_quest)
	
			
