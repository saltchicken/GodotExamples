extends Control

func _ready():
	self.visible = false

func resume():
	self.visible = false
	get_tree().paused = false
	
func pause():
	self.visible = true
	get_tree().paused = true

func _process(_delta):
	captureEsc()
	
func captureEsc():
	var esc = Input.is_action_just_pressed("escape")
	if esc and !get_tree().paused:
		pause()
	elif esc and get_tree().paused:
		resume()
		
func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu/main_menu.tscn")
	#get_tree().quit()
