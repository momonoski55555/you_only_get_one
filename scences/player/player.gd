extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") :
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("A", "D", "W", "S")
		var direction: Vector3 = ($Gimble.transform.basis * Vector3(input_dir.x, velocity.y, input_dir.y)).normalized()
		if direction:
			velocity = direction * SPEED
		else:
			velocity = lerp(velocity, Vector3.ZERO, delta * 3)
	
	move_and_slide()
