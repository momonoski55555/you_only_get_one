extends Node3D
class_name Gamemaster

@onready var player: Player = $Player

func _ready() -> void:
	Global.add_bullet.connect(add_bullets_fp)

func add_bullets_fp():
	player.add_bullet()
