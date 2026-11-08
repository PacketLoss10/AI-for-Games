@tool
class_name CostArea
extends Node2D


@export var _blocking := false:
	set(value):
		_blocking = value
		update_shape_params(_blocking, _cost, _size, _visible)


@export var _cost := 0.0:
	set(value):
		_cost = value
		update_shape_params(_blocking, _cost, _size, _visible)
	
	get:
		if _blocking:
			return INF
		else:
			return _cost


@export var _size := Vector2(100.0, 100.0):
	set(value):
		_size = value
		update_shape_params(_blocking, _cost, _size, _visible)


@export var _visible := true:
	set(value):
		_visible = value
		update_shape_params(_blocking, _cost, _size, _visible)


@onready var _shape: CollisionShape2D = $Area/Shape
@onready var _label: Label = $Label
@onready var _icon: ColorRect = $Area/ColorRect


func _ready() -> void:
	$Area/Shape.shape = $Area/Shape.shape.duplicate()
	update_shape_params(_blocking, _cost, _size, _visible)


func contains_point(point: Vector2) -> bool:
	var local: Vector2 = $Area/Shape.to_local(point)
	var half := _size * 0.5
	return abs(local.x) <= half.x and abs(local.y) <= half.y


func get_shape_transform() -> Transform2D:
	return _shape.global_transform


func get_area() -> Rect2:
	var shape := $Area/Shape
	var local := Rect2(-_size * 0.5, _size)
	var world : Rect2 = shape.global_transform * local
	return world


func update_shape_params(blocking: bool, cost: float, size: Vector2, isVisible: bool):
	if not is_node_ready() or _shape == null or _label == null or not _shape.shape is RectangleShape2D:
		return
	
	_shape.debug_color = Color(1, 0, 0, 0.2) if blocking else Color(0, 1, 0, 0.2)
	_shape.shape.size = size
	
	_label.text = str(cost)
	_label.visible = isVisible
	
	_icon.size = size
	_icon.position = -size * 0.5
	_icon.color = Color(1, 0, 0, 0.2) if blocking else Color(0, 1, 0, 0.2)
	_icon.visible = isVisible
