extends Node3D

@export var force_magnitude: float = 100.0


func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -force_magnitude) * delta
	
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#queue_free()


func _on_timer_timeout() -> void:
	queue_free()
