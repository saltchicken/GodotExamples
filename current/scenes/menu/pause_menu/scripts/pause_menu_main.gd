extends CanvasLayer

@onready var player = get_parent()

@onready var tabs: Array = [%InventoryMenu, %SpellsMenu, %QuestMenu, %SystemMenu]
@onready var selected_tab = %InventoryMenu

@onready var purse_label = get_node('%InventoryMenu/PurseLabel')

func _ready():
	self.visible = false
	get_node('BlurRect').set_size(get_viewport().get_visible_rect().size)
	set_purse_text()
	
func _process(_delta):
	# TODO: Move this to main function with other inputs
	if Input.is_action_just_pressed('inventory') or Input.is_action_just_pressed('escape'):
		if self.visible:
			close_pause_menu()
		else:
			open_pause_menu()
			
func open_pause_menu():
	self.visible = true
	get_tree().paused = true
	
func close_pause_menu():
	self.visible = false
	get_tree().paused = false
	
func get_inventory():
	print('TODO: Implement checking inventory')
	for slot in %InventoryMenu.item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				print(item.data.get_path())
			
func save_inventory():
	var inventory_list = []
	for slot in %InventoryMenu.item_slot_reference:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				inventory_list.append(item.data.get_path())
	return inventory_list
	
func save_equipment():
	var equipment_list = []
	var slotsCheck = %InventoryMenu.equipment_slot_reference
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				equipment_list.append(item.data.get_path())
	return equipment_list
		
			
func is_in_inventory(): # TODO: Implement 
	pass

func set_purse_text():
	purse_label.text = 'Purse: %s' % str(player.purse)
	
func _on_player_update_purse() -> void:
	set_purse_text()
