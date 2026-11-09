class_name NavigationEnvironment


const BLOCKED := INF
const ARC_SEGMENTS := 24

var bounds: Array[Rect2] = []
var polygons: Array[PackedVector2Array] = []
var costs := PackedFloat32Array()


func add_shape(shape: Shape2D, xform: Transform2D, cost: float) -> void:
	var points := shape_to_points(shape)
	if points.size() < 3:
		return
	
	add_polygon(points, xform, cost)


func add_polygon(points: PackedVector2Array, xform: Transform2D, cost: float) -> void:
	if cost == 0.0 or points.size() < 3:
		return
	
	var polygon := xform * points
	var lowest := polygon[0]
	var highest := polygon[0]
	for point in polygon:
		lowest = lowest.min(point)
		highest = highest.max(point)
	var rect := Rect2(lowest, highest - lowest)
	
	if is_inf(cost):
		bounds.push_front(rect)
		polygons.push_front(polygon)
		costs.insert(0, cost)
	else:
		bounds.push_back(rect)
		polygons.push_back(polygon)
		costs.push_back(cost)


func cost_at(point: Vector2) -> float:
	var total := 0.0
	
	for i in costs.size():
		if bounds[i].has_point(point):
			if Geometry2D.is_point_in_polygon(point, polygons[i]):
				total += costs[i]
				if total == BLOCKED:
					return BLOCKED
	
	return total


func shape_to_points(shape: Shape2D) -> PackedVector2Array:
	var points := PackedVector2Array()
	
	if shape is RectangleShape2D:
		var half_size: Vector2 = shape.size * 0.5
		points.append_array([Vector2(-half_size.x, -half_size.y), Vector2(half_size.x, -half_size.y), Vector2(half_size.x, half_size.y), Vector2(-half_size.x, half_size.y)])
	
	elif shape is CircleShape2D:
		for i in ARC_SEGMENTS:
			var arc := (PI / 2.0) * i / ARC_SEGMENTS
			points.push_back(Vector2(cos(arc), sin(arc)) * shape.radius)
	
	elif shape is ConvexPolygonShape2D:
		points = shape.points
	
	return points


func clear() -> void:
	bounds.clear()
	polygons.clear()
	costs.clear()


func is_empty() -> bool:
	return costs.is_empty()
