class_name Boid
extends CharacterBody2D

var _boidSpeed := 100.0

var _priority := 1.0
var _avoidanceRadius := 40.0
var _avoidance := 0.75
var _matching := 0.05
var _centering := 0.02
var _turning := 10.0

var _nearbyBoids: Array


func boid_entered(body: Node2D):
	var boid := body as Boid
	if boid != null and boid != self:
		_nearbyBoids.push_back(boid)


func boid_exited(body: Node2D):
	var boid := body as Boid
	if boid != null and boid != self:
		_nearbyBoids.erase(boid)


func separation():
	if _nearbyBoids.is_empty():
		return
	
	var close_dx := 0.0
	var close_dy := 0.0
	
	for other: Boid in _nearbyBoids:
		if (position - other.position).length_squared() >= _avoidanceRadius * _avoidanceRadius:
			continue
		
		close_dx += position.x - other.position.x
		close_dy += position.y - other.position.y
		
	velocity += Vector2(close_dx, close_dy) * _avoidance * _priority


func alignment():
	if _nearbyBoids.is_empty():
		return
	
	var averageVelocity := Vector2(0.0, 0.0)
	
	for other: Boid in _nearbyBoids:
		averageVelocity += other.velocity
		
	averageVelocity /= _nearbyBoids.size()
	
	if averageVelocity.length_squared() > 0.0:
		velocity += (averageVelocity.normalized() - velocity.normalized()) * _matching * _priority


func cohesion():
	if _nearbyBoids.is_empty():
		return
		
	var averagePosition := Vector2(0.0, 0.0)
	
	for other: Boid in _nearbyBoids:
		averagePosition += other.position
		
	averagePosition /= _nearbyBoids.size()
	
	var direction := averagePosition - position
	if direction.length_squared() > 0.0:
		velocity += direction.normalized() * _centering * _priority


func edge_avoidance():
	if position.x < 0.0:
		velocity.x += _turning
	if position.x > 1152.0:
		velocity.x -= _turning
	
	if position.y < 0.0:
		velocity.y += _turning
	if position.y > 648.0:
		velocity.y -= _turning


func _ready() -> void:
	$Detection.body_entered.connect(boid_entered)
	$Detection.body_exited.connect(boid_exited)
	
	var initialVelocityX := randf_range(-1.0, 1.0)
	var initialVelocityY := randf_range(-1.0, 1.0)
	
	velocity = Vector2(initialVelocityX, initialVelocityY).normalized()
	_priority = 1.0


func _physics_process(delta: float) -> void:
	separation()
	alignment()
	cohesion()
	edge_avoidance()
	
	velocity = velocity.normalized() * _boidSpeed
	
	move_and_slide()
