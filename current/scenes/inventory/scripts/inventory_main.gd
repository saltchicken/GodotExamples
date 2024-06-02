extends CanvasLayer

@onready var player = get_parent()

var InvSize = 24
	
func _ready():
	self.visible = false
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		%Inventory.add_child(slot)
		
	#_load_items_from_file()
	#get_inventory()
	#check_inventory.connect(get_inventory)
	
func _process(_delta):
	#if Input.is_action_just_pressed('inventory'):
	#if Input.is_action_just_pressed('TESTTESTTEST'):
		#get_inventory()
		#get_equipment()
	# TODO: Move this to main function with other inputs
	if Input.is_action_just_pressed('inventory') or Input.is_action_just_pressed('escape'):
		# TODO: Add pausing the game, and change process for this node to always active.
		toggle()
		
func toggle():
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused

func get_first_open_slot():
	var slots = %Inventory.get_children()
	for i in slots.size():
		if slots[i].get_child_count() == 0:
			return i
	return -1 # TODO: Better error handling for when inventory is full

func load_item_into_inventory(path_to_item, slot_index):
	var item := InventoryItem.new()
	item.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	%Inventory.get_child(slot_index).add_child(item)
	
#func _load_items_from_file():
	#var itemsLoad = [
	#"res://scenes/inventory/item/sword.tres",
	#"res://scenes/inventory/item/bow.tres"
#]
	#for i in itemsLoad.size():
		#_load_item_into_inventory(itemsLoad[i], i)
		##_load_item_into_inventory(itemsLoad[i], _get_first_open_slot())
		##item.add_to_group('items')

func _collect_item(item):
	load_item_into_inventory(item, get_first_open_slot())
	

		
func get_inventory():
	print('TODO: Implement checking inventory')
	var slotsCheck = %Inventory.get_children()
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				print(item.data.get_path())
			
func save_inventory():
	var inventory_list = []
	var slotsCheck = %Inventory.get_children()
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				inventory_list.append(item.data.get_path())
	return inventory_list
	
func save_equipment():
	var equipment_list = []
	var slotsCheck = %Equipment.get_children()
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				equipment_list.append(item.data.get_path())
	return equipment_list
			
			
func get_equipment():
	var slotsCheck = %Equipment.get_children()
	for slot in slotsCheck:
		if slot.get_child_count() > 0:
			var item = slot.get_child(0)
			if item:
				item.data.apply_upgrade(player)
				#print(item.data.name)
	print('Applied equipment modifiers')
			
func is_in_inventory(): # TODO: Implement 
	pass



func _on_resume_pressed():
	toggle()


func _on_restart_pressed():
	print('This is not implemented')
	# TODO: Add a confirmation pop up to make sure user wants to restart
	#toggle()
	##Global.restart()
	#get_tree().reload_current_scene()


func _on_quit_pressed():
	# TODO: Add a confirmation pop up to make sure user wants to restart
	toggle()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")


func _on_head_slot_change_inventory():
	print('Inventory head_slot changed')
	get_equipment()


func _on_weapon_slot_change_inventory():
	print('Inventory weapon_slot changed')
	get_equipment()


func _on_chest_slot_change_inventory():
	print('Inventory chest_slot changed')
	get_equipment()


func _on_legs_slot_change_inventory():
	print('Inventory legs_slot changed')
	get_equipment()


func _on_feet_slot_change_inventory():
	print('Inventory feet_slot changed')
	get_equipment()


func _on_load_latest_save_pressed():
	Global.load_game()
	pass # Replace with function body.
