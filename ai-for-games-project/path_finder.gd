class_name PathFinder
extends Node2D

enum Heuristic
{
	Euclidean,
	Manhattan,
	Chebyshev
}

const _maxIterations := 10000


static func get_directions(stepSize: float, allowDiagonal: bool) -> Array[Vector2]:
	return [
	Vector2(stepSize, 0.0),
	Vector2(-stepSize, 0.0),
	Vector2(0.0, stepSize),
	Vector2(0.0, -stepSize),
	Vector2(stepSize, stepSize),
	Vector2(-stepSize, stepSize),
	Vector2(stepSize, -stepSize),
	Vector2(-stepSize, -stepSize) 
	] if allowDiagonal else [
	Vector2(stepSize, 0.0),
	Vector2(-stepSize, 0.0),
	Vector2(0.0, stepSize),
	Vector2(0.0, -stepSize)
	]


static func euclidean_heuristic(v1: Vector2, v2: Vector2, stepSize: float):
	return v1.distance_to(v2) / (stepSize * sqrt(2.0))


static func manhattan_heuristic(v1: Vector2, v2: Vector2, stepSize: float):
	return (abs(v2.x - v1.x) + abs(v2.y - v1.y)) / stepSize


static func chebyshev_heuristic(v1: Vector2, v2: Vector2, stepSize: float):
	return max(abs(v2.x - v1.x), abs(v2.y - v1.y)) / stepSize


static func get_heuristic(heuristic: Heuristic) -> Callable:
	if heuristic == Heuristic.Euclidean:
		return euclidean_heuristic
	elif heuristic == Heuristic.Manhattan:
		return manhattan_heuristic
	elif heuristic == Heuristic.Chebyshev:
		return chebyshev_heuristic
	else:
		return euclidean_heuristic


static func find_path(
	start: Vector2, 
	goal: Vector2, 
	environment: Array, 
	heuristic := Heuristic.Euclidean,
	stepSize := 20.0,
	allowDiagonal := true) -> Array[Vector2]:
		
		var heuristicFuncion := get_heuristic(heuristic)
		var directions = get_directions(stepSize, allowDiagonal)
		
		var open := PriorityQueue.new(func(A: PathfindingNode, B: PathfindingNode): return A._finalCost < B._finalCost)
		var nodes := {}
		
		var startNode := PathfindingNode.new(start)
		startNode._existingCost = 0.0
		startNode._heuristicCost = heuristicFuncion.call(start, goal, stepSize)
		nodes[Vector2i.ZERO] = startNode
		open.push(startNode)
		
		var currentIteration := 0
		while not open.is_empty() and currentIteration < _maxIterations:
			currentIteration += 1
			
			var currentNode: PathfindingNode = open.pop()
			if currentNode._closed:
				continue
			currentNode._closed = true
			
			if currentNode._position.distance_squared_to(goal) <= stepSize * stepSize:
				var path: Array[Vector2] = [goal]
				var n := currentNode
				while n != null:
					path.push_back(n._position)
					n = n._previous
				return path
			
			for direction in directions:
				var pos: Vector2 = currentNode._position + direction
				var key := Vector2i(((pos - start) / stepSize).round())
				
				var node: PathfindingNode = nodes.get(key)
				if node != null and node._closed:
					continue
				
				var totalAreaCost := 0.0
				var blocked := false
				for area in environment:
					if area._blocking:
						if area.contains_point(pos):
							blocked = true
							break
					elif area.contains_point(pos):
						totalAreaCost += area._cost
				if blocked:
					continue
				
				if node == null:
					node = PathfindingNode.new(pos)
					nodes[key] = node
				
				var newCost := currentNode._existingCost + direction.length() / stepSize + totalAreaCost
				if newCost < node._existingCost:
					node._existingCost = newCost
					node._heuristicCost = heuristicFuncion.call(pos, goal, stepSize)
					node._previous = currentNode
					open.push(node)
					
		return []
