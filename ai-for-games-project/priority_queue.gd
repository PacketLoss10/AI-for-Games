class_name PriorityQueue

var _data : Array = []
var _compare : Callable

func _init(compare: Callable):
	_compare = compare

func push(value):
	_data.push_back(value)
	_sift_up(_data.size() - 1)

func pop():
	if _data.is_empty():
		return null
		
	var result = _data[0]
	
	if _data.size() == 1:
		_data.pop_back()
		return result
		
	_data[0] = _data.pop_back()
	_sift_down(0)
	
	return result

func top():
	if _data.is_empty():
		return null
		
	return _data[0]

func is_empty():
	return _data.is_empty()

func size():
	return _data.size()

func clear():
	_data.clear()
	
func print_contents():
	for element in _data:
		print(element)

func _sift_up(index: int):
	while index > 0:
		var parent := (index - 1) >> 1
		
		if not _compare.call(_data[index], _data[parent]):
			break
			
		_swap(index, parent)
		index = parent

func _sift_down(index: int):
	var count := _data.size()
	
	while true:
		var left := (index << 1) + 1
		var right := left + 1
		var best := index
		
		if left < count and _compare.call(_data[left], _data[best]):
			best = left
		
		if right < count and _compare.call(_data[right], _data[best]):
			best = right
			
		if best == index:
			break
			
		_swap(index, best)
		index = best

func _swap(A: int, B: int):
	var temp = _data[A]
	_data[A] = _data[B]
	_data[B] = temp
