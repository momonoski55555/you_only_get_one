extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func  _input(event: InputEvent) -> void:
	var Sens = 0.5
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * Sens))
		$Camera.rotation.x += deg_to_rad(-event.relative.y * Sens)
		$Camera.rotation.x = clamp($Camera.rotation.x , deg_to_rad(-89), deg_to_rad(89))
	
