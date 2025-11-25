extends Area2D


@export_file var dest_scene
@export var required_card:String = "card_red"
@onready var anim = $Door
var entered = false

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		entered = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		entered = false

func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("entrer"):
		get_tree().change_scene_to_file(dest_scene)
