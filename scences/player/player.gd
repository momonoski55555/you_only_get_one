extends CharacterBody3D
class_name Player

@onready var shape_cast_3d: ShapeCast3D = $Gimble/Camera/ShapeCast3D

@onready var ray_cast_3d: RayCast3D = $Gimble/Camera/RayCast3D
@onready var point: Node3D = $Gimble/Camera/point
const PLAYER_BULLET = preload("res://scences/player/player_bullet.tscn")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


var bullets: int = 1

func _ready() -> void:
	%ammo_count.text = str(bullets)
	clamp(bullets,0,1)


func _input(event: InputEvent) -> void:
	var bullet = PLAYER_BULLET.instantiate()
	if Input.is_action_just_released("Fire"):
		if bullets > 0:
			bullets -= 1
			point.add_child(bullet)
			bullet.top_level = true
			%ammo_count.text = str(bullets)
		else:
			if not $AnimationPlayer.is_playing():
				melee_attack()

func add_bullet() -> void: 
	bullets += 1
	%ammo_count.text = str(bullets)


func melee_attack() -> void:
	print("melee hit")

	var collided = ray_cast_3d.get_collider()
	$AnimationPlayer.play("melee")
	if collided:
		if collided.name == "Enemy":
			print("het")
			collided.queue_free()

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
