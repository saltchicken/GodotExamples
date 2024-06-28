extends CanvasLayer

@onready var player = get_parent()

@onready var tabs: Array = [%InventoryMenu, %SpellsMenu, %QuestMenu, %SystemMenu]
@onready var selected_tab = %InventoryMenu

func _ready():
	self.visible = false
	get_node('BlurRect').set_size(get_viewport().get_visible_rect().size)
	
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
