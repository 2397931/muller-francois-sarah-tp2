extends Node

var current_scene = "map_principale"
var transition_scene = false

var joueur_exit_mapprincipalesuite_posx = 1837
var joueur_exit_mapprincipalesuite_posy = 913
var joueur_exit_infirmerie_posx = 526
var joueur_exit_infirmerie_posy = 913
var joueur_start2_posx = 78
var joueur_start2_posy = 913
var joueur_start_posx = 185
var joueur_start_posy = 913

var key_founded = []

var max_health := 6
var current_health := max_health

signal health_changed(value)

var game_first_loadin = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "map_principale":
			current_scene = "map_principale_suite"
		else:
			current_scene = "map_principale"

func damage(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	emit_signal("health_changed", current_health)

func heal(amount: int):
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health)

func reset_health():
	current_health = max_health
	emit_signal("health_changed", current_health)
