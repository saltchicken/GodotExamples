extends State

@onready var character_body = self.get_owner()
@onready var animation_tree = $"../../AnimationTree"

func _ready():
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func Enter():
	animation_tree.get("parameters/playback").travel(self.name)
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == self.name:
		if character_body.item and !character_body.item_taken:
			SceneManager.dialogue(self, ["You received a %s" %character_body.item.name])
			character_body.player.inventory.collect_item(character_body.item.resource_path)
			character_body.item_taken = true
		else:
			
			print('no item')
		state_transition.emit(self, 'open')
