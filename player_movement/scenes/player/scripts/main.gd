extends CharacterBody2D
@onready var state_machine = $StateMachine
@onready var animation_player = $AnimationPlayer

var DEFAULT_DIRECTION = 'down'
@onready var direction = DEFAULT_DIRECTION:
	set(new_direction):
		direction = new_direction
		Callable(self, "_" + state_machine.current_state.name).call()
		
@onready var movement
@onready var run

func _ready():
	add_to_group('Players')

func _physics_process(delta):
	_get_input()
	_get_direction()
	move_and_collide(self.velocity * delta)

func _get_input():
	movement = Input.get_vector("left", "right", "up", "down")
	run = Input.is_action_pressed('run')
	
func _get_direction():
	if movement:
		if movement.x < 0 and movement.y == 0:
			direction = 'left'
		elif movement.x > 0 and movement.y == 0:
			direction = 'right'
		elif movement.y < 0 and movement.x == 0:
			direction = 'up'
		elif movement.y > 0 and movement.x == 0:
			direction = 'down'

func _idle():
	animation_player.play('idle_' + direction)
	
func _walk():
	animation_player.play('walk_' + direction)	
	
func _run():
	animation_player.play('run_' + direction)
