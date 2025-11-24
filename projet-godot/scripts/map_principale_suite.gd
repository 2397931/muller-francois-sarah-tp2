extends Node2D

func _ready() -> void:
	global.current_scene = "map_principale_suite"

func _process(delta: float) -> void:
	change_scene()


func _on_arriere_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_arriere_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "map_principale_suite":
			get_tree().change_scene_to_file("res://scenes/map_principale.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()
