extends Node2D

@onready var musique_arriere = $AudioStreamPlayer
@onready var bruit_spaceship = $AudioStreamPlayer2
@onready var entrer = $AudioStreamPlayer3

func _ready() -> void:
	musique_arriere.play()
	bruit_spaceship.play()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	entrer.play()
