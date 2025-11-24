extends AnimatedSprite2D

@export var delay_time := 2
@export var animation_name := "window"

func _ready():
	play_with_delay()

func play_with_delay():
	while true:
		play(animation_name)
		await animation_finished
		await get_tree().create_timer(delay_time).timeout
