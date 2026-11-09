class_name Player

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction:= Input.get_vector("player_move_left","plyer_move_right","player_move_back","player_move_forward")
	var velocity = direction*SPEED
	move_and_slide()
