class_name Pathfinder

const MAX_ITERATIONS := 10000





enum Heuristic
{
	Euclidean,
	Manhattan,
	Chebyshev
}

static func euclidean(v1: Vector2, v2: Vector2):
	return v1.distance_to(v2)

static func manhattan(v1: Vector2, v2: Vector2):
	return abs(v2.x - v1.x) + abs(v2.y - v1.y)

static func chebyshev(v1: Vector2, v2: Vector2):
	return max(abs(v2.x - v1.x), abs(v2.y - v1.y))

static func get_heuristic_function(heuristic: Heuristic) -> Callable:
	match heuristic:
		Heuristic.Euclidean:
			return euclidean
		Heuristic.Manhattan:
			return manhattan
		Heuristic.Chebyshev:
			return chebyshev
		_:
			return euclidean





const GRID_SIZE := 20.0

static func allign_to_grid(position: Vector2) -> Vector2i:
	return Vector2i(roundi(position.x / GRID_SIZE), roundi(position.y / GRID_SIZE))

static func allign_to_world(position: Vector2i) -> Vector2:
	return Vector2(position) * GRID_SIZE

static func get_directions(allowDiagonal: bool) -> Array[Vector2]:
	return [
	Vector2(1.0, 0.0),
	Vector2(-1.0, 0.0),
	Vector2(0.0, 1.0),
	Vector2(0.0, -1.0),
	Vector2(1.0, 1.0),
	Vector2(-1.0, 1.0),
	Vector2(1.0, -1.0),
	Vector2(-1.0, -1.0) 
	] if allowDiagonal else [
	Vector2(1.0, 0.0),
	Vector2(-1.0, 0.0),
	Vector2(0.0, 1.0),
	Vector2(0.0, -1.0)
	]





static var _cachedNodes: Dictionary[Vector2i, PathfindingNode] = {}
static var _hash := 0

static func get_node(position: Vector2i, environment: Array) -> PathfindingNode:
	var node: PathfindingNode
	
	if _cachedNodes.has(position):
		node = _cachedNodes[position]
	else:
		var nodePosition := allign_to_world(position)
		node = PathfindingNode.new(nodePosition, calculate_cost(nodePosition, environment))
		_cachedNodes[position] = node
	
	node.reset(_hash)
	return node

static func calculate_cost(position: Vector2, environment: Array) -> float:
	var cost := 0.0
	
	for area: CostArea in environment:
		if area.contains_point(position):
			cost += area._cost
	
	return cost





static func construct_path(current: PathfindingNode) -> Array[Vector2]:
	var path: Array[Vector2] = []
	
	var previous := current
	while previous != null:
		path.push_back(previous._position)
		previous = previous._previous
	
	return path





static func find_path(start: Vector2, goal: Vector2, environment: Array) -> Array[Vector2]:
	_hash += 1
	
	var heuristicFunction := get_heuristic_function(Heuristic.Euclidean)
	var directions = get_directions(true)
	var open := PriorityQueue.new(func(A: PathfindingNode, B: PathfindingNode): return A._finalCost < B._finalCost)
	
	var startPosition := allign_to_grid(start)
	var goalPosition := allign_to_grid(goal)
	
	var startNode := get_node(startPosition, environment)
	if startNode._existingCost == INF:
		return []
	
	startNode._movementCost = 0.0
	startNode._heuristicCost = heuristicFunction.call(Vector2(startPosition), Vector2(goalPosition)) * GRID_SIZE
	open.push(startNode)
	
	var it := 0
	while not open.is_empty() and it < MAX_ITERATIONS:
		it += 1
		
		var currentNode: PathfindingNode = open.pop()
		if currentNode._closed:
			continue
		currentNode._closed = true
		
		var currentPosition := allign_to_grid(currentNode._position)
		if currentPosition == goalPosition:
			return construct_path(currentNode)
		
		for direction: Vector2i in directions:
			var nextPosition := currentPosition + direction
			var nextNode := get_node(nextPosition, environment)
			if nextNode._closed or nextNode._existingCost == INF:
				continue
			
			var movementDistance := Vector2(direction).length() * GRID_SIZE
			var totalCost := (currentNode._movementCost + movementDistance * (1.0 +  nextNode._existingCost))
			if totalCost >= nextNode._movementCost:
				continue
			
			nextNode._previous = currentNode
			nextNode._movementCost = totalCost
			nextNode._heuristicCost = heuristicFunction.call(Vector2(nextPosition), Vector2(goalPosition)) * GRID_SIZE
			
			open.push(nextNode)
	
	return []


static func init_grid(width: int, height: int, environment: Array) -> void:
	for x in range(-width, width):
		for y in range(-height, height):
			get_node(Vector2i(x, y), environment)
