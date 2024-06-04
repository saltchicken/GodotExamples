extends Node

var chest = preload("res://scenes/objects/chest/chest.tscn")
var bow = preload("res://scenes/inventory/item/bow.tres")

var rng = RandomNumberGenerator.new()

func _ready():
	# TODO: Put this in a better place
	# Fix for ugly cursors in inventory
	var can_drop_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	var forbidden_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	Input.set_custom_mouse_cursor(can_drop_cursor_img, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(forbidden_cursor_img, Input.CURSOR_FORBIDDEN)
	
	#var chest = chest.instantiate()
	#chest.init(bow)
	#chest.global_position = Vector2(100.0, 10.0)
	#add_child(chest)
	
# TODO: These are just for testing remove both '1' and '2'
func _process(_delta):
	if Input.is_action_just_pressed("rightclick"):
		var enemy_position = Vector2(100.0, 100.0) 
		#Global.check_if_space_occupied(self, enemy_position)
		Global.spawn_enemy(self, enemy_position)
		
	#if Input.is_action_just_pressed('TESTTESTTEST'):
		#var dialogue = get_node('DialogueLayer')
		#dialogue.set_text(['hello'])
		#dialogue.main()
	#if Input.is_action_just_pressed('1'):
		#print('saving game')
		#Global.save_game()
	#
	#if Input.is_action_just_pressed('2'):
		#print('loading game')
		#Global.load_game()
	
