extends Area2D

@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
@onready var timer = get_node('Timer')

@onready var cast_direction

@export var default_stats: SpellData
@onready var stats: SpellData = default_stats.duplicate()

func _ready():
	animation_tree.get("parameters/playback").start('cast')
	cast_direction = player.direction
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += cast_direction * delta * stats.cast_speed
	var bodies = self.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				body.get_hit(self)

func _on_timer_timeout():
	queue_free()
