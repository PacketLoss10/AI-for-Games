class_name EnemyIdleState
extends EnemyState

func transition_to_attack() -> bool:
	return true
	

func on_enter_state() -> void:
	var velocity = 0
	pass


func on_exit_state() -> void:
	pass


func process_state(delta: float) -> void:
	# wait two seconds
	# move to random location
	pass

func _ready():
	transitions.push_back(transition_to_attack)
