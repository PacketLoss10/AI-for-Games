class_name EnemyScript
#var enemyBase:EnemyScript
const EnemyScript = preload("res://SamF/enemy_script.gd")
var enemyBase:EnemyScript


enum States{
	
	PATROLLING,
	CHASING,
	DAMAGED,
	KILLED,
	FLEEING
}
