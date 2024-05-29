extends Node

var chest = preload("res://scenes/objects/chest/chest.tscn")
var bow = preload("res://scenes/inventory/item/bow.tres")

func _ready():
	# TODO: Put this in a better place
	# Fix for ugly cursors in inventory
	var can_drop_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	var forbidden_cursor_img = load("res://assets/cursors/invisible_cursor.png")
	Input.set_custom_mouse_cursor(can_drop_cursor_img,7)
	Input.set_custom_mouse_cursor(forbidden_cursor_img,8)
	
	#var chest = chest.instantiate()
	#chest.init(bow)
	#chest.global_position = Vector2(100.0, 10.0)
	#add_child(chest)
