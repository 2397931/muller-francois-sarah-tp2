extends StaticBody2D

@export_file var dest_scene
@export var required_key: String = "red_card"

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var block_collision: CollisionShape2D = $CollisionShape2D1

var door_unlocked := false
var player_in_range := false


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body.name == "joueur":
		player_in_range = true

		# Unlock when player has the card
		if required_key in global.key_founded and not door_unlocked:
			door_unlocked = true
			anim_sprite.play("opening")
			await anim_sprite.animation_finished
			block_collision.disabled = true   # Removes blocking collision


func _on_body_exited(body: Node) -> void:
	if body.name == "joueur":
		player_in_range = false


func _process(_delta):
	if door_unlocked and player_in_range and Input.is_action_just_pressed("entrer"):
		get_tree().change_scene_to_file(dest_scene)
