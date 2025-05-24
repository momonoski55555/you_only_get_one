extends Node3D

@export var force_magnitude: float = 100.0
var player 

func _ready() -> void:
	player = get_parent().get_node_or_null("Player")

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -force_magnitude) * delta
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if player is Player:
		player.add_bullet()
	
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
