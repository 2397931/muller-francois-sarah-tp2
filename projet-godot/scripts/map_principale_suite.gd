extends Node2D

func _ready() -> void:
	global.current_scene = "map_principale_suite"
	if global.game_first_loadin == true:
		$joueur.position.x = global.joueur_start2_posx
		$joueur.position.y = global.joueur_start2_posy
	else:
		$joueur.position.x = global.joueur_exit_infirmerie_posx
		$joueur.position.y = global.joueur_exit_infirmerie_posy

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
