extends Node

@export var room_types: Array[PackedScene]  # Exported array for additional room scenes
@export var steps: int = 5  # Number of rooms to generate
const TESTROOM = preload("res://room.tscn")

var current_room: Node3D
var rooms: Array = []
var max_attempts: int = steps * 3  # Limit the number of attempts to generate rooms

func _ready() -> void:
	# Connect the ready signal of the parent
	get_parent().ready.connect(generate)

func generate() -> void:
	# Create the first room (TESTROOM)
	create_testroom()

	var attempts = 0
	while rooms.size() < steps and attempts < max_attempts:
		var new_room_scene = get_random_room_scene()
		if new_room_scene:
			var new_room = new_room_scene.instantiate()
			if place_room(new_room):
				rooms.append(new_room)
				current_room = new_room
		attempts += 1

func create_testroom() -> void:
	# Create and add TESTROOM as the first room
	var first_room = TESTROOM.instantiate()
	get_parent().add_child(first_room)
	current_room = first_room
	rooms.append(first_room)

func get_random_room_scene() -> PackedScene:
	# Returns a random room scene from the room_types array
	if room_types.size() > 0:
		return room_types[randi_range(0, room_types.size() - 1)]
	return null

func place_room(new_room: Node3D) -> bool:
	# Finds an available connection point in the current room and attaches the new room
	var connection_point = find_point(current_room)
	if connection_point:
		connection_point.add_child(new_room)
		orient_room(new_room, connection_point)
		return true
	return false

func find_point(room: Node3D) -> Node3D:
	# Find a valid connection point from the room
	var points: Array = []
	for child in room.get_children():
		if child.name != "SKIP":  # Skip points marked as "SKIP"
			points.append(child)

	if points.size() > 0:
		return points[randi_range(0, points.size() - 1)]
	return null

func orient_room(room: Node3D, connection_point: Node3D) -> void:
	# Orient the new room based on its connection point
	room.global_transform = connection_point.global_transform
	room.translate(Vector3(0, 0, room.get_aabb().size.z))

# Optional utility: Remove a room if needed
func remove_room(room: Node3D) -> void:
	if rooms.has(room):
		rooms.erase(room)
		room.queue_free()
