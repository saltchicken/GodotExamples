extends Area2D

@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
@onready var timer = get_node('Timer')

@onready var cast_direction
@onready var cast_speed = 150.0
@onready var attack_damage = 10.0
@onready var attack_knockback = 50.0

func _ready():
	animation_tree.get("parameters/playback").start('cast')
	cast_direction = player.direction
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += cast_direction * delta * cast_speed
	var bodies = self.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				body.get_hit(self)

func _on_timer_timeout():
	queue_free()
