class_name PathfindingNode

var _position := Vector2(0.0, 0.0)

var _existingCost := INF
var _heuristicCost := 0.0
var _finalCost: float:
	get:
		return _existingCost + _heuristicCost

var _closed := false
var _previous: PathfindingNode = null

func _init(position: Vector2):
	_position = position
