class_name EnemyIdleState
extends EnemyState

func transition_to_attack() -> bool:
	#

func on_enter_state() -> void:
	# velocity = 0
	# or
	# clear path
	pass


func on_exit_state() -> void:
	pass


func process_state(delta: float) -> void:
	# wait two seconds
	# move to random location
	pass

func _ready():
	transitions.push_back(transition_to_attack)
