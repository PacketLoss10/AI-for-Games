class_name NavBlocker
extends Node2D


@export var blocks_navigation := true
@export var traversal_cost := 1.0


func _ready() -> void:
	register_to_environment(PathFinder.active_environment)


func register_to_environment(environment: NavigationEnvironment) -> void:
	var desired_cost := INF if blocks_navigation else traversal_cost
	
	for child in get_children():
		if child is CollisionShape2D:
			if not child.disabled and child.shape != null:
				environment.add_shape(child.shape, child.global_transform, desired_cost)
		elif child is CollisionPolygon2D:
			if not child.disabled and child.build_mode == CollisionPolygon2D.BUILD_SOLIDS:
				environment.add_polygon(child.polygon, child.global_transform, desired_cost)
