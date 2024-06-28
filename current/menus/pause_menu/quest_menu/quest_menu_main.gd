extends Node

## FOR TESTING
#@onready var red_slime_quest = load('res://menus/pause_menu/quest_menu/quests/red_slime_quest.tres')
#@onready var green_slime_quest = load('res://menus/pause_menu/quest_menu/quests/green_slime_quest.tres')
#@onready var active_quests: Array[QuestResource] = [red_slime_quest, green_slime_quest]
##

@onready var active_quests: Array[QuestResource]
@onready var active_quests_container = get_node('VBoxContainer')

func _ready():
	add_to_group('Persist')

func handle_objective(objective: OBJECTIVE):
	for quest in active_quests:
		if quest.action == objective.action and quest.requirement == objective.value:
			quest.increment()
			
func update_quest(quest):
	quest.update_label()
	
func save():
	var save_dict = {
		"node_name" : self.name,
		"quests" : get_quests()
	}
	return save_dict
	
func load(node_data):
	for quest in node_data['quests'].keys():
		var quest_instance = load(quest)
		quest_instance.status = node_data['quests'][quest]
		active_quests.append(quest_instance)
	load_active_quests()
		
func get_quests():
	var dict = {}
	for quest in active_quests:
		dict[quest.get_path()] = quest.status
	return dict
		

func load_active_quests():
	for quest in active_quests:
		active_quests_container.add_child(quest.label)
		quest.update_label()
		quest.quest_updated.connect(update_quest)

#func load_quest_into_container(path_to_quest):
	#var quest := load(path_to_quest)
	#activeQuestsContainer.add_child(quest.label)
	#quest.update_label()
	#quest.quest_updated.connect(update_quest)
	
			
