extends CharacterBody3D

@onready var gimble: Node3D = $Gimble
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var area_3d: Area3D = $Area3D
@onready var look_at: Marker3D = $Look_at

var bullet:int = 1
var player: Player

func _physics_process(delta: float) -> void:
	if player:
		look_at.look_at(player.position)
		gimble.rotation.y = lerp(gimble.rotation.y , look_at.rotation.y, 3 * delta)
		gimble.rotation.x = lerp(gimble.rotation.x, look_at.rotation.x, 3 * delta)
	
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
