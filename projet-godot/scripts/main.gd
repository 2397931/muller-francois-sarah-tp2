extends Node2D

signal card_collected(card)

@onready var musique_arriere = get_tree().root.get_node("/root/main/AudioStreamPlayer")
@onready var bruit_spaceship = get_tree().root.get_node("/root/main/AudioStreamPlayer2")

func collect_card(card):
	emit_signal("card_collected", card)

#func _ready() -> void:
#	musique_arriere.play()
#	bruit_spaceship.play()
