extends Node3D
class_name linemaker

@export var start_position: Vector3 = Vector3.ZERO
@export var end_position: Vector3 = Vector3(2, 2, 2)
@export var line_width: float = 0.05
@export var fade_duration: float = 2.0
@export var line_color: Color = Color(1, 1, 1, 1) # White with full opacity

var mesh_instance: MeshInstance3D
var material: StandardMaterial3D
var alpha: float = 1.0
var elapsed_time: float = 0.0

func fire():
	create_line()
	material = StandardMaterial3D.new()
	material.albedo_color = line_color
	material.flags_transparent = true
	mesh_instance.material_override = material
	
	set_process(true)

func create_line():
	mesh_instance = MeshInstance3D.new()
	var mesh = ImmediateMesh.new()
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, null)
	mesh.surface_set_color(line_color)
	mesh.surface_add_vertex(start_position)
	mesh.surface_add_vertex(end_position)
	mesh.surface_end()
	
	mesh_instance.mesh = mesh
	
	# Add to scene root instead of as child of this node
	get_tree().current_scene.add_child(mesh_instance)
	
	# Set the line's global position (optional, since vertices are already in world space)
	mesh_instance.global_position = Vector3.ZERO

func _process(delta):
	if mesh_instance and is_instance_valid(mesh_instance):
		if elapsed_time < fade_duration:
			elapsed_time += delta
			alpha = lerp(1.0, 0.0, elapsed_time / fade_duration)
			material.albedo_color.a = alpha
		else:
			mesh_instance.queue_free()
