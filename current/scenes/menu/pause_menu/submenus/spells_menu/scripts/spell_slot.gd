class_name SpellSlot
extends PanelContainer

signal change_spell
@export var type: SpellData.Type

#func init(t: ItemData.Type, cms: Vector2) -> void:
	#type = t
	#custom_minimum_size = cms

func _can_drop_data(_at_position, data):
	if data is SpellItem:
		if type == SpellData.Type.ATTACK: # TODO: What type checking should be done here for spells
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
				return get_child(0).data.type == data.data.type
		else:
			if data.data:
				return data.data.type == type
			else:
				return false
	else:
		return false
	
func _drop_data(_at_position, data):
	if get_child_count() > 0:
		var item := get_child(0)
		if item == data:
			return
		else:
			item.reparent(data.get_parent())
	data.reparent(self)
	change_spell.emit()
