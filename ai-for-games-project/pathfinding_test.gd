extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.find_path(Vector2(800.0, 500.0), $Environment.get_children())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		$Sprite2D.find_path(event.position, $Environment.get_children())
		
