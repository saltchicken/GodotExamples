class_name Bonfire
extends Resource

@export var name: String
@export_multiline var description: String
@export var status: String = 'off'

var label

func _init():
	label = Label.new()
	
func update_label():
	label.text = name
