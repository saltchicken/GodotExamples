extends Area2D

@onready var animation_tree = $AnimationTree
@onready var player = get_tree().get_first_node_in_group('Players') # TODO: Better way to reference character
@onready var timer = get_node('Timer')

@onready var cast_direction

@export var default_stats: SpellData
@onready var stats: SpellData = default_stats.duplicate()

@onready var scene_script = stats.scene_script.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_tree.get("parameters/playback").start('casted')
	cast_direction = player.direction
	animation_tree.set("parameters/casted/BlendSpace2D/blend_position", cast_direction)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene_script.process(self, delta)


func _on_timer_timeout() -> void:
	queue_free()
