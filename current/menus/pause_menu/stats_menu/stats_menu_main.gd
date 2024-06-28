extends Node

@onready var player = get_owner().get_owner()

func _ready() -> void:
	#await owner.owner.ready
	#for entry in player.stats.get_property_list():
		#if entry['usage'] == 4102:
			#print(entry)
	#await owner.owner.ready
	#update_stats()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# TODO: Make sure this runs evertime stats change
func update_stats():
	var container = get_node('VBoxContainer')
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	for entry in player.stats.get_property_list():
		if entry['usage'] == 4102:
			var label = Label.new()
			label.text = entry['name'] + ": " + str(player.stats.get(entry['name']))
			container.add_child(label)
			
			
