extends Node2D

@export var max_health := 6
var current_health := max_health

@onready var heart_sprite := $AnimatedSprite2D

func _ready():
	if heart_sprite == null:
		push_error("barre_vie not found! Check node path.")
	else:
		print("✅ barre_vie found")

# Update the hearts based on the player's health
func update_health(new_health: int):
	if heart_sprite == null:
		return
	current_health = clamp(new_health, 0, max_health)
	# Example: if max = 6 and current = 4 → frame = 2
	heart_sprite.frame = max_health - current_health
