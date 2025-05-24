extends CharacterBody3D
class_name Player

@onready var point: Node3D = $Gimble/point
const PLAYER_BULLET = preload("res://scences/player/player_bullet.tscn")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var bullets: int = 1

func _ready() -> void:
	
	clamp(bullets,0,1)


func collision():
	print("yes a hit")


func _input(event: InputEvent) -> void:
	var bullet = PLAYER_BULLET.instantiate()
	if Input.is_action_just_released("Fire"):
		point.add_child(bullet)
		bullet.top_level = true
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var input_dir := Input.get_vector("A", "D", "W", "S")
		var direction: Vector3 = ($Gimble.transform.basis * Vector3(input_dir.x, velocity.y, input_dir.y)).normalized()
		if direction:
			velocity = direction * SPEED
		else:
			velocity = lerp(velocity, Vector3.ZERO, delta * 3)
		
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
			velocity.y = JUMP_VELOCITY
		

	move_and_slide()
