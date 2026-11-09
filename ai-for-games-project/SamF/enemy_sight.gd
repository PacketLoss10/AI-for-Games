class_name EnemySight
extends Area2D


var player_seen := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_seen = true


func on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_seen = false
