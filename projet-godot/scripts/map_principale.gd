extends Node2D

func _ready() -> void:
	global.current_scene = "map_principale"
	if global.game_first_loadin == true:
		$joueur.position.x = global.joueur_start_posx
		$joueur.position.y = global.joueur_start_posy
	else:
		$joueur.position.x = global.joueur_exit_mapprincipalesuite_posx
		$joueur.position.y = global.joueur_exit_mapprincipalesuite_posy

func _process(delta: float) -> void:
	change_scene()

func _on_suite_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true

func _on_suite_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "map_principale":
			get_tree().change_scene_to_file("res://scenes/map_principale_suite.tscn")
			global.finish_changescenes()
