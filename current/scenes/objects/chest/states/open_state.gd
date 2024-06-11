extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func Enter():
	#print('Chest open now')
	animation_tree.get("parameters/playback").travel('open')
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
