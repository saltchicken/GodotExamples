extends CanvasLayer

var InvSize = 24
	
func _ready():
	self.visible = false
	for i in InvSize:
		var slot := InventorySlot.new()
		slot.init(ItemData.Type.MAIN, Vector2(32, 32))
		%Inventory.add_child(slot)
		
	_load_items_from_file()		
	#get_inventory()
	#check_inventory.connect(get_inventory)
	
func _process(delta):
	if Input.is_action_just_pressed('inventory'):
		# TODO: Add pausing the game, and change process for this node to always active.
		self.visible = !self.visible

func _get_first_open_slot():
	var slots = %Inventory.get_children()
	for i in slots.size():
		if slots[i].get_child_count() == 0:
			return i
	return -1 # TODO: Better error handling for when inventory is full

func _load_item_into_inventory(path_to_item, slot_index):
	var item := InventoryItem.new()
	item.init(load(path_to_item))
	#var item_index = _get_first_open_slot()
	%Inventory.get_child(slot_index).add_child(item)
	
func _load_items_from_file():
	var itemsLoad = [
	"res://scenes/inventory/item/sword.tres",
	"res://scenes/inventory/item/bow.tres"
]
	for i in itemsLoad.size():
		_load_item_into_inventory(itemsLoad[i], i)
		#_load_item_into_inventory(itemsLoad[i], _get_first_open_slot())
		#item.add_to_group('items')

func _collect_item(item):
	_load_item_into_inventory(item, _get_first_open_slot())
	

		
#func get_inventory():
	#print('TODO: Implement checking inventory')
	#var slotsCheck = %Inventory.get_children()
	#for slots in slotsCheck:
		#var item = slots.get_child(0)
		#if item:
			#print(item.data.name)
			
func _is_in_inventory(): # TODO: Implement 
	pass

