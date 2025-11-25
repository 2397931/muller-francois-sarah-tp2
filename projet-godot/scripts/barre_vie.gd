extends Node

@export var max_health := 6
var current_health := max_health
var heart_sprite: AnimatedSprite2D = null

func set_heart_sprite(node: AnimatedSprite2D) -> void:
	heart_sprite = node
	update_health(current_health)

func update_health(new_health: int) -> void:
	current_health = clamp(new_health, 0, max_health)
	if heart_sprite:
		heart_sprite.frame = max_health - current_health
