extends CharacterBody2D
@onready var state_machine = $StateMachine
@onready var animated_sprite = $AnimationPlayer
@onready var use_hitbox = $UseArea

var DEFAULT_DIRECTION = 'down'
@onready var direction = DEFAULT_DIRECTION:
	set(new_direction):
		direction = new_direction
		Callable(self, "_" + state_machine.current_state.name).call()
		
@onready var movement
@onready var run
@onready var use

@onready var use_reach = 10

func _ready():
	add_to_group('Players')

func _physics_process(delta):
	_get_input()
	_get_direction()
	_handle_use_hitbox_direction()
	move_and_collide(self.velocity * delta)

func _get_input():
	movement = Input.get_vector("left", "right", "up", "down")
	run = Input.is_action_pressed('run')
	use = Input.is_action_just_pressed('use')
	
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
			
func _handle_use_hitbox_direction():
	if direction == 'down':
		use_hitbox.position.x = 0
		use_hitbox.position.y = use_reach
	elif direction == 'up':
		use_hitbox.position.x = 0
		use_hitbox.position.y = -use_reach
	elif direction == 'left':
		use_hitbox.position.x = -use_reach
		use_hitbox.position.y = 0
	elif direction == 'right':
		use_hitbox.position.x = use_reach
		use_hitbox.position.y = 0

func _idle():
		animated_sprite.play('idle_' + direction)
		#
func _walk():
	animated_sprite.play('walk_' + direction)	
	#
func _run():
	animated_sprite.play('run_' + direction)
	
func _use_objects():
	var useable_objects = use_hitbox.get_overlapping_bodies()
	if useable_objects:
		#var useable_object = useable_objects.front()
		for obj in useable_objects:
			print(obj)
			#if obj.get_script() == Chest:
				#obj.use()
