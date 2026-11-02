class_name PathfindingNode

var _hash := -1

# saved values
var _position := Vector2(0.0, 0.0)
var _existingCost := INF

# per call values
var _movementCost := INF
var _heuristicCost := 0.0
var _finalCost: float:
	get:
		return _movementCost + _heuristicCost
	
	set(value):
		pass

var _closed := false
var _previous: PathfindingNode = null


func reset(hash: int):
	if hash == _hash:
		return
	_hash = hash
	
	_movementCost = INF
	_heuristicCost = 0.0
	
	_closed = false
	_previous = null


func _init(position: Vector2, existingCost: float):
	_position = position
	_existingCost = existingCost
