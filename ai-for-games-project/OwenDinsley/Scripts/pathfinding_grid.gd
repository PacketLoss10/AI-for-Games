class_name PathfindingGrid
extends Node2D

var columns := 0
var rows := 0
var cellSize := 0.0


func create(center: Vector2, width: int, height: int, size: float) -> void:
	columns = width
	rows = height
	cellSize = size
	
	for child in get_children():
		if child != null:
			child.queue_free()
	get_children().clear()
	
	for x in range(width):
		for y in range(height):
			var cellPosition := Vector2(x + center.x / 2.0, y + center.y / 2.0)
			var newCell := PathfindingGridCell.new(cellPosition, cellSize)
			add_child(newCell)
