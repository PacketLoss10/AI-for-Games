extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PathfindingGrid.create(Vector2.ZERO, 300, 300, Pathfinder.GRID_SIZE)
	Pathfinder.init_grid(300, 300, $Environment.get_children())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event is InputEventMouseButton:
		for enemy: EnemyLeader in $Enemies.get_children():
			enemy.find_path(event.position, $Environment.get_children())
