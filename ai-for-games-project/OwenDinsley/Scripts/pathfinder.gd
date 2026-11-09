#class_name PathFinder
#extends Node2D
#
#enum Heuristic { Euclidean, Manhattan, Chebyshev }
#
#const MAX_ITERATIONS := 10000
#const SQRT2 := 1.4142135623
#const CARDINAL: Array[Vector2i] = [
	#Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
#]
#const DIAGONAL: Array[Vector2i] = [
	#Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)
#]
#const _BLOCKED := -2
#
#
### Snapshot of the environment, built once per search.
#class Terrain:
	#var block_inv: Array[Transform2D] = []
	#var block_half := PackedVector2Array()
	#var cost_inv: Array[Transform2D] = []
	#var cost_half := PackedVector2Array()
	#var cost_val := PackedFloat32Array()
#
	#func _init(areas: Array) -> void:
		#for a in areas:
			#var inv: Transform2D = a.get_shape_transform().affine_inverse()
			#var half: Vector2 = a._size * 0.5
			#if a._blocking:
				#block_inv.push_back(inv)
				#block_half.push_back(half)
			#elif a._cost != 0.0:
				#cost_inv.push_back(inv)
				#cost_half.push_back(half)
				#cost_val.push_back(a._cost)
#
	### Returns -1.0 if blocked, otherwise the summed area cost.
	#func cost_at(p: Vector2) -> float:
		#for i in block_inv.size():
			#var l := block_inv[i] * p
			#var h := block_half[i]
			#if absf(l.x) <= h.x and absf(l.y) <= h.y:
				#return -1.0
		#var total := 0.0
		#for i in cost_inv.size():
			#var l := cost_inv[i] * p
			#var h := cost_half[i]
			#if absf(l.x) <= h.x and absf(l.y) <= h.y:
				#total += cost_val[i]
		#return total
#
#
### Distance in units of steps.
#func _heuristic(kind: Heuristic, dx: float, dy: float) -> float:
	#dx = absf(dx)
	#dy = absf(dy)
	#match kind:
		#Heuristic.Manhattan:
			#return dx + dy
		#Heuristic.Chebyshev:
			#return maxf(dx, dy)
		#_:
			#return sqrt(dx * dx + dy * dy)
#
#
#func find_path(
		#start: Vector2,
		#goal: Vector2,
		#environment: Array,
		#heuristic := Heuristic.Euclidean,
		#stepSize := 20.0,
		#allowDiagonal := true) -> Array[Vector2]:
#
	#var dirs: Array[Vector2i] = CARDINAL + DIAGONAL if allowDiagonal else CARDINAL
	#var inv_step := 1.0 / stepSize
	#var goal_dist_sq := stepSize * stepSize
	#var terrain := Terrain.new(environment)
#
	## Node storage (struct of arrays, indexed by node id)
	#var positions := PackedVector2Array([start])
	#var area_cost := PackedFloat32Array([0.0])
	#var g := PackedFloat32Array([0.0])
	#var prev := PackedInt32Array([-1])
	#var closed := PackedByteArray([0])
	#var keys: Array[Vector2i] = [Vector2i.ZERO]
	#var index := {Vector2i.ZERO: 0}   # grid key -> node id (or _BLOCKED)
#
	#var open := PriorityQueue.new()
	#open.push(0, _heuristic(heuristic, (goal.x - start.x) * inv_step, (goal.y - start.y) * inv_step))
#
	#var iterations := 0
	#while not open.is_empty() and iterations < MAX_ITERATIONS:
		#iterations += 1
#
		#var cur := open.pop()
		#if closed[cur] == 1:
			#continue
		#closed[cur] = 1
#
		#if positions[cur].distance_squared_to(goal) <= goal_dist_sq:
			#return _build_path(cur, goal, positions, prev)
#
		#var cur_key := keys[cur]
		#var cur_g := g[cur]
#
		#for d in dirs:
			#var key := cur_key + d
			#var id: int = index.get(key, -1)
#
			#if id == _BLOCKED:
				#continue
			#if id >= 0 and closed[id] == 1:
				#continue
#
			#if id == -1:  # first time we see this cell: evaluate terrain once
				#var p := start + Vector2(key) * stepSize
				#var tc := terrain.cost_at(p)
				#if tc < 0.0:
					#index[key] = _BLOCKED
					#continue
				#id = positions.size()
				#index[key] = id
				#positions.push_back(p)
				#area_cost.push_back(tc)
				#g.push_back(INF)
				#prev.push_back(-1)
				#closed.push_back(0)
				#keys.push_back(key)
			#
			#var step := SQRT2 if (d.x != 0 and d.y != 0) else 1.0
			#var new_g := cur_g + step + area_cost[id]
			#if new_g < g[id]:
				#g[id] = new_g
				#prev[id] = cur
				#var p := positions[id]
				#open.push(id, new_g + _heuristic(heuristic, (goal.x - p.x) * inv_step, (goal.y - p.y) * inv_step))
	#
	#return []
#
#
#func _build_path(last: int, goal: Vector2, positions: PackedVector2Array, prev: PackedInt32Array) -> Array[Vector2]:
	#var path: Array[Vector2] = [goal]
	#var n := last
	#while n != -1:
		#path.push_back(positions[n])
		#n = prev[n]
	#return path

class_name PathFinder
extends RefCounted
 
enum Heuristic { Euclidean, Manhattan, Chebyshev }
 
const MAX_ITERATIONS := 10000
const SQRT2 := 1.4142135623
const CARDINAL: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
]
const DIAGONAL: Array[Vector2i] = [
	Vector2i(1, 1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(-1, -1)
]
 
static var active_environment := NavigationEnvironment.new()
 
 
class SearchGraph:
	const UNSEEN := -1
	const BLOCKED := -2
	
	var positions := PackedVector2Array()
	var area_cost := PackedFloat32Array()
	var g := PackedFloat32Array()
	var prev := PackedInt32Array()
	var closed := PackedByteArray()
	var keys: Array[Vector2i] = []
	var _index := {}
	
	func _init(start: Vector2) -> void:
		add_node(Vector2i.ZERO, start, 0.0)
		g[0] = 0.0
	
	func add_node(key: Vector2i, pos: Vector2, cost: float) -> int:
		var id := positions.size()
		_index[key] = id
		positions.push_back(pos)
		area_cost.push_back(cost)
		g.push_back(INF)
		prev.push_back(-1)
		closed.push_back(0)
		keys.push_back(key)
		return id
	func lookup(key: Vector2i) -> int:
		return _index.get(key, UNSEEN)
	func mark_blocked(key: Vector2i) -> void:
		_index[key] = BLOCKED 
	func build_path(last: int, goal: Vector2) -> Array[Vector2]:
		var path: Array[Vector2] = [goal]
		var n := last
		while n != -1:
			path.push_back(positions[n])
			n = prev[n]
		return path


static func _heuristic(kind: Heuristic, dx: float, dy: float) -> float:
	dx = absf(dx)
	dy = absf(dy)
	match kind:
		Heuristic.Manhattan:
			return dx + dy
		Heuristic.Chebyshev:
			return maxf(dx, dy)
		_:
			return sqrt(dx * dx + dy * dy)
 
 
static func find_path(
		start: Vector2,
		goal: Vector2,
		heuristic := Heuristic.Euclidean,
		step_size := 20.0,
		allow_diagonal := true) -> Array[Vector2]:
			
	var dirs: Array[Vector2i] = CARDINAL + DIAGONAL if allow_diagonal else CARDINAL
	var inv_step := 1.0 / step_size
	var goal_dist_sq := step_size * step_size
	
	var graph := SearchGraph.new(start)
	var open := PriorityQueue.new()
	open.push(0, _heuristic(heuristic, (goal.x - start.x) * inv_step, (goal.y - start.y) * inv_step))
	var iterations := 0
	while not open.is_empty() and iterations < MAX_ITERATIONS:
		iterations += 1
		
		var cur := open.pop()
		if graph.closed[cur] == 1:
			continue
		graph.closed[cur] = 1
		
		if graph.positions[cur].distance_squared_to(goal) <= goal_dist_sq:
			return graph.build_path(cur, goal)
			
		var cur_key := graph.keys[cur]
		var cur_g := graph.g[cur]
		
		for d in dirs:
			var key := cur_key + d
			var id := graph.lookup(key)
			
			if id == SearchGraph.BLOCKED:
				continue
			if id >= 0 and graph.closed[id] == 1:
				continue
			
			if id == SearchGraph.UNSEEN:
				var p := start + Vector2(key) * step_size
				var tc := active_environment.cost_at(p)
				if tc == NavigationEnvironment.BLOCKED:
					graph.mark_blocked(key)
					continue
				id = graph.add_node(key, p, tc)
				
			var step := SQRT2 if (d.x != 0 and d.y != 0) else 1.0
			var new_g := cur_g + step + graph.area_cost[id]
			if new_g < graph.g[id]:
				graph.g[id] = new_g
				graph.prev[id] = cur
				var pos := graph.positions[id]
				open.push(id, new_g + _heuristic(heuristic, (goal.x - pos.x) * inv_step, (goal.y - pos.y) * inv_step))
				
	return []
