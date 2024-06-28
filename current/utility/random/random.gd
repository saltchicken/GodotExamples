class_name RANDOM

var rng = RandomNumberGenerator.new()

func weighted_random():
	var weights = [75, 20, 5]
	var sum_of_weight = 0
	for choice in range(weights.size()):
		sum_of_weight += weights[choice]
	var random_choice = rng.randi_range(0, sum_of_weight)
	for choice in range(weights.size()):
		if random_choice < weights[choice]:
			return choice
		random_choice -= weights[choice]
	print(random_choice)
	print('something bad happend with weighted_random. Return 0 by default to prevent error')
	return 0
