extends CharacterBody3D
class_name Player


@onready var ray_cast_3d: RayCast3D = $Gimble/Camera/RayCast3D
@onready var point: Node3D = $Gimble/Camera/point
const PLAYER_BULLET = preload("res://scences/player/player_bullet.tscn")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var marker_3d: Marker3D = $Marker3D
var dir_xy
@onready var crosshair: Control = $crosshair
var dash_target: Vector3
var dashing: bool = false
var dash_speed: float = 10.0  # Adjust speed for smoother motion


var bullets: int = 1


func _ready() -> void:
	crosshair.position = (get_viewport().size / 2)

	%ammo_count.text = str(bullets)
	clamp(bullets,0,1)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func  _input(event: InputEvent) -> void:
	var Sens = 0.5
	if event is InputEventMouseMotion:
		$Gimble.rotate_y(deg_to_rad(-event.relative.x * Sens))
		$Gimble/Camera.rotation.x += deg_to_rad(-event.relative.y * Sens)
		$Gimble/Camera.rotation.x = clamp($Gimble/Camera.rotation.x , deg_to_rad(-89), deg_to_rad(89))
	
#func _input(event: InputEvent) -> void:
	#var bullet = PLAYER_BULLET.instantiate()

	#if Input.is_action_just_released("Fire"):
		#if bullets > 0:
			#bullets -= 1
			#point.add_child(bullet)
			#bullet.top_level = true
			#var colideed = ray_cast_3d_2
			#if colideed:
				#if colideed.name == "Enemy":
					#colideed.queue_free()
					#add_bullet()
				#else:
					#pass
			#$LaserShoot.play()
			#line_maker.start_position = $Gimble/Camera/point.position
			#line_maker.end_position = ray_cast_3d_2.get_collision_point()
			#line_maker.fire()
			#%ammo_count.text = str(bullets)
		#else:
			#if not $AnimationPlayer.is_playing():
				#melee_attack()

func add_bullet() -> void: 
	$PowerUp.play()
	bullets += 1
	%ammo_count.text = str(bullets)


func dash(dir: Vector3, delta: float) -> void:
	dash_target = position + dir
	dashing = true


#func melee_attack() -> void:
	#print("melee hit")
	#var collided = ray_cast_3d.get_collider()
	#$AnimationPlayer.play("melee")
	#if collided:
		#if collided.is_in_group("enemy"):
			#collided.queue_free()
			#await get_tree().create_timer(0.5)
			#$Explosion.play()
			#add_bullet()
			#

func _physics_process(delta: float) -> void:
	if dashing:
		position = position.move_toward(dash_target, dash_speed * delta)
	if position == dash_target:
		dashing = false
	
	if Input.is_action_just_released("shift"):
		dash(dir_xy, delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var input_dir := Input.get_vector("A", "D", "W", "S")
		var direction: Vector3 = ($Gimble.transform.basis * Vector3(input_dir.x, velocity.y, input_dir.y)).normalized()
		dir_xy = Vector3(direction.x, position.y, direction.z) * 3
		if direction:
			velocity = direction * SPEED
		else:
			velocity = lerp(velocity, Vector3.ZERO, delta * 3)
		
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() :
			velocity.y = JUMP_VELOCITY
		

	move_and_slide()
