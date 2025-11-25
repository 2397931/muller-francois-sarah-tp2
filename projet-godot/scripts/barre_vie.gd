extends Node2D

@export var max_health := 6
var current_health := max_health
var heart_sprite: AnimatedSprite2D

func _ready():
	heart_sprite = $CanvasLayer/AnimatedSprite2D

	if heart_sprite:
		heart_sprite.stop()

	# Connect once — works across all scenes
	global.health_changed.connect(update_health)

	update_health(global.current_health)

func update_health(new_health: int) -> void:
	current_health = clamp(new_health, 0, max_health)

	if heart_sprite:
		heart_sprite.stop()
		heart_sprite.frame = max_health - current_health
