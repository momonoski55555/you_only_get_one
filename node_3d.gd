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
	var child_mesh:MeshInstance3D = room.get_child(4).get_child(0)
	# we get the parent scale and position
	var parent_pos = room.get_parent().position
	var parent_scale = room.get_parent().scale 
	
	# we calculate the magnitude aka "size" of the former vectors
	var min_offset = parent_scale.length() * 0.2
	var base_offset = parent_pos.length() * 0.4
	# we take the Axis Aligned Bounding box and calculate the magnitude 
	# of it by the running a theoratical diagonal line thro it 
	var mesh_AABB: AABB = child_mesh.get_aabb()
	var AABB_magnitude = -mesh_AABB.size.length()
	var offset = clamp(base_offset, min_offset, AABB_magnitude)
	
	var displasment = room.basis.z * offset 
	
	room.position += displasment
