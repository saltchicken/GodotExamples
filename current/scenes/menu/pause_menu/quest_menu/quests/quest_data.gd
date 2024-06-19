class_name QuestResource
extends Resource

signal quest_updated

@export var name: String
@export_multiline var description: String
@export var status: String = '0'
@export var action: String
@export var requirement: String

var label

func _init():
	label = Label.new()

func increment():
	status = str(int(status) + 1)
	quest_updated.emit(self)
	
func update_label():
	label.text = name + ': ' + status
