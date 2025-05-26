extends CharacterBody3D

@onready var timer: Timer = $Timer
@onready var gimble: Node3D = $Gimble
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var area_3d: Area3D = $Area3D
@onready var look_at: Marker3D = $Look_at
const PLAYER_BULLET = preload("res://scences/player/player_bullet.tscn")
var bullet:int = 1
var player: Player
@onready var ray_cast_3d: RayCast3D = $Gimble/RayCast3D

var s: float

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.5 * delta
	s += 10.0
	
	%saw.rotate_object_local(Vector3(0,1,0),deg_to_rad(s))
	if player:
		fire()
		
	if player:
		look_at.look_at(player.position)
		gimble.rotation.y = lerp(gimble.rotation.y , look_at.rotation.y, 3 * delta)
		gimble.rotation.x = lerp(gimble.rotation.x, look_at.rotation.x, 3 * delta)
	
	move_and_slide()

func fire():
	if not timer.is_stopped():
		await timer.timeout
	var instance = PLAYER_BULLET.instantiate()
	%point.add_child(instance)
	instance.top_level = true
	timer.start()

func die():
	Global.add_bullets()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
