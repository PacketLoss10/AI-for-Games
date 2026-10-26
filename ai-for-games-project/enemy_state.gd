@abstract class_name EnemyState

var transitions: Array[Callable]

@abstract func on_enter_state() -> void
@abstract func on_exit_state() -> void
@abstract func process_state(delta: float) -> void
