extends MeshInstance3D

var r: float

func _physics_process(delta: float) -> void:
	
	r += 10
	
	rotate_object_local(Vector3(0,1,0), deg_to_rad(-r))
