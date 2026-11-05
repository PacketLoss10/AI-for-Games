class_name PathfindingGridCell
extends ColorRect


func _init(cellPosition: Vector2, cellSize: float) -> void:
	size = Vector2(cellSize, cellSize)
	position = cellPosition + size / 2.0
