class_name StartScreen extends Control

func _ready() -> void:
	get_node("VBoxContainer/HBoxContainer/MarginContainer/Button").button_up.connect(_on_button_button_up)
	
	# deferral/no unload examples
#	SceneManager.swap_scenes("res://Gameplay/player.tscn",get_tree().root,null,"no_transition")
#	SceneManager.call_deferred("swap_scenes","res://Gameplay/player.tscn",get_tree().root,null,"no_transition")

func _on_button_button_up() -> void:
	SceneManager.swap_scenes("res://Gameplay/gameplay.tscn",get_tree().root,self,"fade_to_black")		
