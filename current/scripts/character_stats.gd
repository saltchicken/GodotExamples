class_name Stats
extends Resource

#enum Type {HEAD, CHEST, LEGS, FEET, WEAPON, ACCESSORY, MAIN}

#@export var name: String
#@export_multiline var description: String
#@export var texture: Texture2D
@export var base_attack_damage: int
@export var base_defense: int

#func apply_upgrade(body: CharacterBody2D):
	#pass
