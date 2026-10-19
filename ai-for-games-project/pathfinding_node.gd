class_name PathFindingNode

var _position := Vector2(0.0, 0.0)
var _fCost := 0.0
var _gCost := 0.0

func _init(fCost: float, position: Vector2):
	_fCost = fCost
	_position = position
