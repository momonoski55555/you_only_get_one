extends Node3D

@onready var point: Node3D = $"../point"
@export var start_position: Vector3 = point.position
@export var end_position: Vector3 = Vector3(2, 2, 2)
@export var line_width: float = 0.2  # Increased thickness
@export var fade_duration: float = 2.0
@export var line_color: Color = Color(1, 1, 1, 1)  # White with full opacity

var mesh_instance: MeshInstance3D
var material: StandardMaterial3D
var alpha: float = 1.0
var elapsed_time: float = 0.0

func _ready():
	create_line()
	material = StandardMaterial3D.new()
	material.albedo_color = line_color
	material.flags_transparent = true
	mesh_instance.material_override = material
	
	set_process(true)

func create_line():
	mesh_instance = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = line_width / 2
	mesh.bottom_radius = line_width / 2
	mesh.height = (start_position - end_position).length()
	
	mesh_instance.mesh = mesh
	mesh_instance.global_transform.origin = (start_position + end_position) * 0.5  # Center the cylinder
	mesh_instance.look_at(end_position, Vector3.UP)  # Rotate to align with direction

	add_child(mesh_instance)

func _process(delta):
	if elapsed_time < fade_duration:
		elapsed_time += delta
		alpha = lerp(1.0, 0.0, elapsed_time / fade_duration)
		material.albedo_color.a = alpha
	else:
		queue_free()
