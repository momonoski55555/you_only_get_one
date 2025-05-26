extends Node

@export var room_types: Array[PackedScene]  # Exported array for additional room scenes
@export var steps: int = 5  # Number of rooms to generate
const TESTROOM = preload("res://room.tscn")

var current_room: Node3D
var rooms: Array = []
var max_attempts: int = steps * 3
  # Limit the number of attempts to generate rooms


var check_first_room: bool = false

func _ready() -> void:
	get_parent().ready.connect(generate)

func generate():
	var firstroom = TESTROOM.instantiate()
	get_parent().add_child(firstroom)
	current_room = firstroom
	rooms.append(firstroom)
	
	var attempts: int = 0
	var max_attempts: int = steps * 3
	
	while rooms.size() < steps and attempts < max_attempts:
		var new_room = random_room().instantiate()
		if check_first_room == false:
			find_point(current_room).add_child(new_room)
			orient_room(new_room)
			rooms.append(new_room)
			current_room = new_room
			check_first_rooms()
		else:
			rooms.append(new_room)
			find_point(current_room).add_child(new_room)
			current_room = new_room
			orient_room(new_room)
		
		attempts += 1
		# change from the first room to the next room
		
func random_room() -> PackedScene:
	var rand = randi_range(0, room_types.size() - 1)
	
	return room_types[rand]



func check_first_rooms():
	if check_first_room == false:
		check_first_room = true
	else:
		pass


func find_room(room:Node3D) -> Node3D:
	if rooms.size() < 0:
		rooms.erase(room)
	else:
		pass
	rooms.shuffle()
	return rooms.pop_front()

func find_point(room: Node3D) -> Node3D:
	var points: Array
	for i in room.get_children():
		if i.name == "SKIP":
			pass
		else:
			points.append(i)
	
	points.erase(room.get_child(randi_range(0,3)))
	points.shuffle()
	return points.pop_front()
	
	
	

func orient_room(room: Node3D):
	# Ensure room exists and contains the expected child node
	var child_mesh: MeshInstance3D = room.get_node_or_null("SKIP").get_child(0)
	#if child_mesh == null or child_mesh.get_child_count() == 0:
		#push_error("Invalid room structure: Missing SKIP node or child mesh.")
		#return
#
	#child_mesh = child_mesh.get_child(0)

	# Get parent position and scale
	var parent = room.get_parent()
	if parent == null:
		push_error("Room has no valid parent.")
		return

	var parent_pos = parent.position
	var parent_scale = parent.scale

	# Calculate offsets with improved readability
	var min_offset = parent_scale.length() * 0.1
	var base_offset = parent_pos.length() * 0.6

	# Compute magnitude from the AABB size
	var mesh_AABB: AABB = child_mesh.get_aabb()
	var AABB_magnitude = mesh_AABB.size.length()  # Removed the incorrect negative sign

	# Ensure offset stays within safe bounds
	var offset = clamp(base_offset, min_offset, AABB_magnitude)
	
##	
#@onready var point: Node3D = $"../point"
#@export var start_position: Vector3 = point.position
	# Compute displacement correctly
	var displacement = room.basis.z * offset
	room.position += displacement
