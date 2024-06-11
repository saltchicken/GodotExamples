func process(parent, delta):
	parent.position += parent.cast_direction * delta * parent.stats.cast_speed
	var bodies = parent.get_overlapping_bodies()
	if bodies:
		for body in bodies:
			if body.is_in_group('Enemies'): # TODO: Add proto to all entities in enemies to make sure 'hit' is implemented.
				body.get_hit(parent)
