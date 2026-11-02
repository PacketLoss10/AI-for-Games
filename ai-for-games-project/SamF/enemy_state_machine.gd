class_name EnemyStateMachine

var currentState: EnemyState = null

func _process(delta: float) -> void:
	if currentState == null:
		return
	
	currentState.process_state(delta)
	
	# either program state transitions in here, e.g if currentState.type == Idle and player_in_line_of_sight() == true, then change_state(AttackState)
	# OR withing each of your own states, created a set of functions that return bools, and run each of them in here. if any return true, switch to the state corresponding to that function
	# e.g
	# (situation where currentState is Idle)
	# currentState.check_transitions()
	# and inside check_transitions():
	# for each transition in transitions:
	# if transition() == true:
	# then emit signal transition_to(state)
