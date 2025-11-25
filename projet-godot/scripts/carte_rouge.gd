extends Node2D

@onready var pickup = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.name in global.key_founded:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "joueur":
		global.key_founded.append(self.name)
		pickup.play()
		await get_tree().create_timer(pickup.stream.get_length()).timeout
		queue_free()
