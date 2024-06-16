extends Node

@onready var red_slime_quest = load('res://scenes/menu/pause_menu/quest_menu/quests/red_slime_quest.tres')
@onready var green_slime_quest = load('res://scenes/menu/pause_menu/quest_menu/quests/green_slime_quest.tres')

@onready var activeQuests: Array[QuestResource] = [red_slime_quest, green_slime_quest]
@onready var activeQuestsContainer = get_node('VBoxContainer')

func _ready():
	for quest in activeQuests:
		activeQuestsContainer.add_child(quest.label)
		quest.update_label()
		quest.quest_updated.connect(update_quest)

func handle_objective(objective: OBJECTIVE):
	for quest in activeQuests:
		if quest.action == objective.action and quest.requirement == objective.value:
			quest.increment()
			
func update_quest(quest):
	quest.update_label()
	
			
