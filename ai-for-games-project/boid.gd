class_name Boid
extends Node2D

var _boidPosition := Vector2(0.0, 0.0)
var _boidVelocity := Vector2(1.0, 0.0)
var _boidSpeed := 100.0

var _priority: float
var _avoidanceRadius := 40.0
var _avoidance := 0.75
var _matching := 0.05
var _centering := 0.02

var _nearbyBoids: Array


func boid_entered(area: Area2D):
	var boid := area.get_parent() as Boid
	if boid != null and boid != self:
		add_nearby_boid(boid)


func boid_exited(area: Area2D):
	var boid := area.get_parent() as Boid
	if boid != null and boid != self:
		remove_nearby_boid(boid)


func add_nearby_boid(boid: Boid):
	_nearbyBoids.push_back(boid)


func remove_nearby_boid(boid: Boid):
	_nearbyBoids.erase(boid)


func separation():
	if _nearbyBoids.is_empty():
		return
	
	var close_dx := 0.0
	var close_dy := 0.0
	
	for other: Boid in _nearbyBoids:
		if (_boidPosition - other._boidPosition).length_squared() >= _avoidanceRadius * _avoidanceRadius:
			continue
		
		close_dx += _boidPosition.x - other._boidPosition.x
		close_dy += _boidPosition.y - other._boidPosition.y
		
	_boidVelocity += Vector2(close_dx, close_dy) * _avoidance


func alignment():
	if _nearbyBoids.is_empty():
		return
	
	var averageVelocity := Vector2(0.0, 0.0)
	
	for other: Boid in _nearbyBoids:
		averageVelocity += other._boidVelocity
		
	averageVelocity /= _nearbyBoids.size()
	
	if averageVelocity.length_squared() > 0.0:
		_boidVelocity += (averageVelocity.normalized() - _boidVelocity.normalized()) * _matching


func cohesion():
	if _nearbyBoids.is_empty():
		return
		
	var averagePosition := Vector2(0.0, 0.0)
	
	for other: Boid in _nearbyBoids:
		averagePosition += other._boidPosition
		
	averagePosition /= _nearbyBoids.size()
	
	var direction := averagePosition - _boidPosition
	if direction.length_squared() > 0.0:
		_boidVelocity += direction.normalized() * _centering


func _ready() -> void:
	_boidPosition = position
	$Detection.area_entered.connect(boid_entered)
	$Detection.area_exited.connect(boid_exited)


func _process(delta: float) -> void:
	separation()
	alignment()
	cohesion()
	
	_boidVelocity = _boidVelocity.normalized()
	_boidPosition += _boidVelocity * _boidSpeed * delta
	
	position = _boidPosition
