extends Node2D

@export var Boid = preload("res://utility/steering_behavior/boids/boid.tscn")

#var velocity
@onready var amount = 100
@onready var speed = 800

@onready var level = get_parent()

@onready var separation_amount = 15

var cohesion_vec:Vector2
var allignment_vec:Vector2
var seperation_vec:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	print('boid manager running')
	for x in amount:
		var boid = Boid.instantiate()
		boid.position = Vector2(randf_range(-100,100),randf_range(-100,100))
		boid.rotation = randf_range(0,6.28)
		#level.add_child(boid)
		level.add_child.call_deferred(boid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for boid in get_tree().get_nodes_in_group("boids"):
		
		var velocity = boid.transform.y * -1 * speed
		
		cohesion_vec = cohesion_rule(boid)
		seperation_vec = seperation_rule(boid)
		allignment_vec = allignment_rule(boid)
		
		
		velocity = velocity + cohesion_vec + allignment_vec + seperation_vec
		boid.velocity = velocity * delta
		boid.look_at(boid.velocity)
		#boid.position += boid.velocity * delta
		boid.move_and_slide()
		

func cohesion_rule(individual_boid) -> Vector2:
	var perceived_centre:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			perceived_centre = perceived_centre + boid.position
	
	perceived_centre = perceived_centre / (amount-1)
	
	return (perceived_centre-individual_boid.position) / 10
	

func seperation_rule(individual_boid) -> Vector2:
	var seperation_vec:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			if (boid.position - individual_boid.position).length() < separation_amount:
				seperation_vec = seperation_vec - (boid.position - individual_boid.position)
	
	return seperation_vec
	
func allignment_rule(individual_boid) -> Vector2:
	var perceived_velocity:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			perceived_velocity = perceived_velocity + boid.velocity
	
	perceived_velocity = perceived_velocity / (amount-1)
	
	return (perceived_velocity-individual_boid.velocity) / 2
