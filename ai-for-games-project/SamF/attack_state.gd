class_name EnemyAttackState
extends EnemyState



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy.line_of_sight.player_pos
	
	pass
