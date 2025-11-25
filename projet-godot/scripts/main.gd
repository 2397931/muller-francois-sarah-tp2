extends Node2D

signal card_collected(card)

func collect_card(card):
	emit_signal("card_collected", card)

func _ready() -> void:
	GlobalAudio.get_node("AudioStreamPlayer").play()
