class_name EnemyStateMachine
extends Node

var current_state: EnemyState = null
var time := 0.0
@onready var enemy: Enemy = get_parent() as Enemy

func _ready() -> void:
	if enemy == null:
		push_error("parent of state machine is not enemy")
		return

func _process(delta: float) -> void:
	
	
	time += delta
	if time >= 1.0:
		if current_state == null:
			return
		
		if current_state is EnemyIdleState and enemy.line_of_sight.player_seen == true:
			current_state = EnemyAttackState.new()
		
		if current_state is EnemyAttackState and enemy.line_of_sight.player_seen == false:
			current_state = EnemyIdleState.new()

		
		
		if enemy.enemyHP == 0:
			current_state = EnemyDeadState.new()

		
		current_state.process_state(delta)
		time = 0
	# either program state transitions in here, e.g if currentState.type == Idle and player_in_line_of_sight() == true, then change_state(AttackState)
	# OR withing each of your own states, created a set of functions that return bools, and run each of them in here. if any return true, switch to the state corresponding to that function
	# e.g
	# (situation where currentState is Idle)
	# currentState.check_transitions()
	# and inside check_transitions():
	# for each transition in transitions:
	# if transition() == true:
	# then emit signal transition_to(state)
