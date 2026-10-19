class_name PathFinder
extends Node2D

enum Heuristic
{
	Euclidean,
	Manhattan,
	Chebyshev
}
var activeHeuristic := Heuristic.Euclidean

const _stepSize := 20.0
const _allDirections := [
	Vector2(_stepSize, 0.0),
	Vector2(-_stepSize, 0.0),
	Vector2(0.0, _stepSize),
	Vector2(0.0, -_stepSize),
	Vector2(_stepSize, _stepSize),
	Vector2(-_stepSize, _stepSize),
	Vector2(_stepSize, -_stepSize),
	Vector2(-_stepSize, -_stepSize)
]
const _noDiagonalDirections := [
	Vector2(_stepSize, 0.0),
	Vector2(-_stepSize, 0.0),
	Vector2(0.0, _stepSize),
	Vector2(0.0, -_stepSize)
]
var _validDirections = _allDirections

const _maxIterations := 10000


func euclidean_heuristic(v1: Vector2, v2: Vector2):
	return (v1 - v2).length_squared()


func manhattan_heuristic(v1: Vector2, v2: Vector2):
	return abs(v2.x - v1.x) + abs(v2.y - v1.y)


func chebyshev_heuristic(v1: Vector2, v2: Vector2):
	return max(abs(v2.x - v1.x), abs(v2.y - v1.y))


func compare_nodes(node1: PathFindingNode, node2: PathFindingNode):
	return node1._fCost > node2._fCost


func get_heuristic():
	if activeHeuristic == Heuristic.Euclidean:
		return euclidean_heuristic
	elif activeHeuristic == Heuristic.Manhattan:
		return manhattan_heuristic
	elif activeHeuristic == Heuristic.Chebyshev:
		return chebyshev_heuristic
	else:
		return euclidean_heuristic


func get_given_cost(position: Vector2):
	# COST AREA DETECTION
	pass


func valid_adjacent_nodes(currentNode: PathFindingNode, useCollision: bool, collision: CollisionObject2D):
	if useCollision and collision == null:
		return
		
	var adjacentNodes := Array()
	for direction in _validDirections:
		var adjacentNode := PathFindingNode.new(get_given_cost(currentNode._position + direction), currentNode._position + direction)
		# COLLISION DETECTION
		adjacentNodes.push_back(adjacentNode)
	
	return adjacentNodes

func find_path(start: Vector2, end: Vector2, useCollision: bool = false, collision: CollisionObject2D = null):
	var currentIteration := 0
	
	var open := PriorityQueue.new(compare_nodes)
	var visited := Dictionary()
	var gCosts := Dictionary()
	var fCosts := Dictionary()
	
	gCosts[start] = 0.0
	fCosts[start] = get_heuristic().call(start, end)
	
	open.push(PathFindingNode.new(fCosts[start], start))
	while not open.is_empty() and currentIteration < _maxIterations:
		currentIteration += 1
		var currentNode : PathFindingNode = open.top()
		open.pop()
		
		if get_heuristic().call(currentNode, end) < 1.0:
			var path := Array()
			while visited.values().count(currentNode):
				path.push_back(currentNode)
				currentNode = visited[currentNode]
			return path
			
		for adjacentNode in valid_adjacent_nodes(currentNode, useCollision, collision):
			var tentativeG = gCosts[currentNode._position] + adjacentNode._gCost
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
