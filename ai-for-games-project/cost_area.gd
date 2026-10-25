@tool
class_name CostArea
extends Node2D

@export var _blocking := false:
	set(value):
		_blocking = value
		update_shape_params(_blocking, _cost, _size)


@export var _cost := 0.0:
	set(value):
		_cost = value
		update_shape_params(_blocking, _cost, _size)


@export var _size := Vector2(100.0, 100.0):
	set(value):
		_size = value
		update_shape_params(_blocking, _cost, _size)


func _ready() -> void:
	$Area/Shape.shape = $Area/Shape.shape.duplicate()
	update_shape_params(_blocking, _cost, _size)


func contains_point(point: Vector2) -> bool:
	var local: Vector2 = $Area/Shape.to_local(point)
	var half := _size * 0.5
	return abs(local.x) <= half.x and abs(local.y) <= half.y


func get_area() -> Rect2:
	var shape := $Area/Shape
	var local := Rect2(-_size * 0.5, _size)
	var world : Rect2 = shape.global_transform * local
	return world


func update_shape_params(blocking: bool, cost: float, size: Vector2):
	if $Area/Shape == null or $Label == null or $Area/Shape.shape == null or not $Area/Shape.shape is RectangleShape2D:
		return
	
	$Area/Shape.debug_color = Color(1, 0, 0, 0.2) if blocking else Color(0, 1, 0, 0.2)
	
	$Label.text = str(cost)
	
	$Area/Shape.shape.size = size
