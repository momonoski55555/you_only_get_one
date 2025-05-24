extends RigidBody3D

@export var force_magnitude: float = 100

func _ready():
	var local_forward = -transform.basis.z.normalized()
	apply_central_impulse(local_forward * force_magnitude)
