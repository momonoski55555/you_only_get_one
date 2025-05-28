extends Area3D


@export var Damage: int

var things_inside_area: Array

func _on_body_entered(body: Node3D) -> void:
	things_inside_area.append(body)

func _on_body_exited(body: Node3D) -> void:
	things_inside_area.erase(body)

func do_damage() -> void:
	for i in things_inside_area.
