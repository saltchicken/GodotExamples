class_name Player extends CharacterBody2D

@export var input_enabled:bool = true

@onready var animation_tree: AnimationTree = %AnimationTree

#var move_dir:Vector2

#const SPEED = 100.0

@onready var movement

func _physics_process(delta: float) -> void:
	if not input_enabled:
		return
	
	### TESTING.
	movement = Input.get_vector("left", "right", "up", "down")
	
	velocity.x = movement.x * 50
	velocity.y = movement.y * 50
	###
		
	move_and_collide(self.velocity * delta)

func disable():
	input_enabled = false
	#animation_player.play("idle")
	
func enable():
	input_enabled = true
	visible = true
