class_name EnemyLeader
extends CharacterBody2D


var _speed := 300.0
var _hasPath := false
var _currentPath: Array[Vector2] = []
var _nextPosition := Vector2(0.0, 0.0)
var _pathAcceptance := 5.0


func find_path(goal: Vector2, environment: Array):
	_currentPath = PathFinder.find_path(global_position, goal, environment)
	
	if _currentPath.is_empty():
		_hasPath = false
		velocity = Vector2.ZERO
		return
	
	_hasPath = true
	_nextPosition = _currentPath.pop_back()


func _physics_process(delta: float) -> void:
	if not _hasPath:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	while global_position.distance_squared_to(_nextPosition) < _pathAcceptance * _pathAcceptance:
		if _currentPath.is_empty():
			_hasPath = false
			velocity = Vector2.ZERO
			move_and_slide()
			return
		
		_nextPosition = _currentPath.pop_back()
	
	var direction := global_position.direction_to(_nextPosition)
	velocity = direction * _speed
	
	if velocity.x > 0.0:
		$Sprite.flip_h = false
	elif velocity.x < 0.0:
		$Sprite.flip_h = true
	
	move_and_slide()
	return
