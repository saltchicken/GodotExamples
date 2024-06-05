class_name ItemData
extends Resource

enum Type {HEAD, CHEST, LEGS, FEET, WEAPON, ACCESSORY, MAIN}

@export var type: Type
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var attack_damage: int
@export var defense: int

func apply_upgrade(body: CharacterBody2D):
	body.attack_damage = body.base_attack_damage + attack_damage
	body.defense = body.base_defense + defense
