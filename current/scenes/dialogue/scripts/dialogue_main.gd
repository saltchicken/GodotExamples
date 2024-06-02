extends CanvasLayer

@onready var panel = get_node('Panel')
@onready var label = get_node("Panel/RichTextLabel")
#signal finished_dialogue
#signal line_changed_dialogue(current_line)

var current_line: int = 0
@export var story_text: PackedStringArray
@onready var timer = get_node("Panel/Timer")

@onready var letter_per_second = 30.0

func _ready():
	panel.hide()

func set_text(text_array: Array):
	story_text = text_array

func type():
	get_tree().paused = true
	if current_line < story_text.size():
		#var lines = round((story_text[current_line].length()/1.0))
		#print("Lines: '%s'" %lines)
		var time_length = round((story_text[current_line].length() / letter_per_second))
		label.text = ""
		label.visible_ratio = 0
		var tween = create_tween()
		label.text = "[center]" + story_text[current_line] + "[/center]" 
		tween.tween_property(label, "visible_ratio", 1, time_length)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(start_timer)
		
		#panel.position.y -= lines * 2
		#panel.size.y = label.size.y + lines * 4 + 5
	else:
		finish()
	
func main():
	panel.show()
	type()
		
func start_timer():
	timer.start()
	
func finish():
	panel.hide()
	get_tree().paused = false
	queue_free()
	#finished_dialogue.emit()
	
func _on_timer_timeout():
	current_line += 1
	timer.stop()
	type()
