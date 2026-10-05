
#var enemyBase:EnemyScript
const EnemyScript = preload("res://enemy_script.gd")
var enemyBase:EnemyScript

enum States{
	
	PATROLLING,
	CHASING,
	DAMAGED,
	KILLED,
	FLEEING
}

class EnemyState:
	pass
