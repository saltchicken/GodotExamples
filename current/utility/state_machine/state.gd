extends Node
class_name State

signal state_transition

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func take_damage_check_death(receiving_body, attacking_body):
	var damage = attacking_body.stats.attack_damage
	SceneManager.hit_indicator(self, str(damage), receiving_body.hit_indicator_offset.x, receiving_body.hit_indicator_offset.y)
	receiving_body.stats.health -= damage
	if receiving_body.stats.health <= 0:
		receiving_body.stats.health = 0
		return true
	else:
		return false
