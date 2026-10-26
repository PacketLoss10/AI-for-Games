class_name PathfinderAgent
extends Node2D

var _currentPath: Array[Vector2]
var _currentGoal :=  Vector2(0.0, 0.0)
var _hasGoal := false
var _speed := 100.0

@onready var _owner = self


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if _owner == null or not _hasGoal:
		return
	
	if _currentPath.is_empty():
		_hasGoal = false
		return
	
	if _owner.global_position.distance_squared_to(_currentGoal) < 10.0:
		_currentGoal = _currentPath.pop_back()
		
	var toGoal = (_currentGoal - _owner.global_position).normalized()
	_owner.global_position += toGoal * _speed * delta


func find_path(goal: Vector2, environment: Array):
	if _owner == null:
		return
	
	_currentPath = PathFinder.find_path(_owner.global_position, goal, environment, PathFinder.Heuristic.Euclidean, 20.0, true)
	_hasGoal = true
