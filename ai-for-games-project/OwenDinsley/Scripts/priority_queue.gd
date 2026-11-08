class_name PriorityQueue


var values: Array[int] = []
var priorities: Array[float] = []


func push(value: int, priority: float) -> void:
	# add value and priority to heap as a whole
	priorities.push_back(priority)
	values.push_back(value)
	
	# start from bottom of heap, then work up, comparing until not greater than priority before it in the array, swapping every time it is
	var current_index := values.size() - 1
	while current_index > 0:
		# compare
		var parent_index := (current_index - 1) / 2
		if priorities[parent_index] <= priority:
			break
		
		# swap
		priorities[current_index] = priorities[parent_index]
		values[current_index] = values[parent_index]
		current_index = parent_index
	
	priorities[current_index] = priority
	values[current_index] = value


func pop() -> int:
	var return_value := values[0]
	
	# stores value and priority at the end of the array, removes from array 
	var last_index := values.size() - 1
	var last_value := values[last_index]
	var last_priority := priorities[last_index]
	values.remove_at(last_index)
	priorities.remove_at(last_index)
	
	# checks if sifting is required, if empty then no sifting needed, just returns the first element of the array immediately
	if values.is_empty():
		return return_value
	
	# start at top of heap, then travel down the children of smallest priority and move them up
	var current_index := 0
	while true:
		# get two children of the current node in the tree,
		var left_child := current_index * 2 + 1
		var right_child := left_child * 2 + 2
		
		# checks if children exist, if left child index is bigger than size of array, then the current node has no children
		if left_child >= values.size():
			break
		
		# gets the index of the child that corresponds to the smallest priority
		var smallest := left_child
		if right_child < values.size() and priorities[right_child] < priorities[left_child]:
			smallest = right_child
		
		if last_priority <= priorities[smallest]:
			break
		
		# move smallest child up, go to children of smallest child
		priorities[current_index] = priorities[smallest]
		values[current_index] = values[smallest]
		current_index = smallest
	
	priorities[current_index] = last_priority
	values[current_index] = last_value
	
	return return_value


func is_empty() -> bool:
	return values.is_empty()
