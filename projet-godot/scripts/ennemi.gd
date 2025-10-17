extends CharacterBody2D

@export var speed := 100
@export var attaque_distance := 50.0
@export var max_hits := 4 
@export var attaque_cooldown := 1.0 
@export var patrol_interval := 2.0
@export var damage_amount := 1
@onready var son_attaque = $AudioStreamPlayer2D
@onready var mort = $AudioStreamPlayer2D2

var joueur: Node2D
var hits_taken := 0
var is_dead := false
var is_joueur_in_range := false
var is_taking_damage := false

var patrol_direction := 0
var patrol_timer := 0.0
var attacking_loop_running := false

var min_x := 0
var max_x := 1024

func _ready() -> void:
	joueur = get_tree().get_first_node_in_group("joueur")
	$AnimatedSprite2D.play("walk")
	randomize()


	var screen_size = get_viewport_rect().size
	min_x = 0
	max_x = screen_size.x

func _physics_process(delta: float) -> void:
	if is_dead or joueur == null:
		return

	if is_joueur_in_range:
		var direction = joueur.global_position - global_position
		var distance = direction.length()

		if distance > attaque_distance:
			velocity = direction.normalized() * speed
			move_and_slide()
			if not is_taking_damage and $AnimatedSprite2D.animation != "attaque":
				$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = direction.x < 0
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			if not attacking_loop_running and not is_taking_damage:
				start_attacking_loop()
	else:
		patrol(delta)

	global_position.x = clamp(global_position.x, min_x, max_x)

func start_attacking_loop():
	attacking_loop_running = true
	while is_joueur_in_range and not is_dead and not is_taking_damage:
		attaque()
		await get_tree().create_timer(attaque_cooldown).timeout
	attacking_loop_running = false

func attaque():
	$AnimatedSprite2D.play("attaque")
	$AnimatedSprite2D.flip_h = joueur.global_position.x < global_position.x
	son_attaque.play()

	if joueur != null and joueur.has_method("take_damage"):
		joueur.take_damage(damage_amount)

	await $AnimatedSprite2D.animation_finished
	if not is_dead and not is_taking_damage:
		$AnimatedSprite2D.play("walk")

func take_hit():
	if is_dead or is_taking_damage:
		return

	is_taking_damage = true
	hits_taken += 1
	print("Ennemi touché ! Total =", hits_taken)

	$AnimatedSprite2D.play("damage")
	await $AnimatedSprite2D.animation_finished

	if hits_taken >= max_hits:
		die()
	else:
		is_taking_damage = false
		$AnimatedSprite2D.play("walk")
		if is_joueur_in_range and not attacking_loop_running:
			start_attacking_loop()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	mort.play()
	await $AnimatedSprite2D.animation_finished
	queue_free()

func patrol(delta):
	patrol_timer -= delta
	if patrol_timer <= 0:
		patrol_direction = randi() % 3 - 1
		patrol_timer = patrol_interval

	velocity = Vector2(patrol_direction * speed, 0)
	move_and_slide()

	if global_position.x <= min_x:
		patrol_direction = 1
	elif global_position.x >= max_x:
		patrol_direction = -1

	if not is_taking_damage and $AnimatedSprite2D.animation != "attaque":
		$AnimatedSprite2D.play("walk")

	if patrol_direction != 0:
		$AnimatedSprite2D.flip_h = patrol_direction < 0

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("joueur"):
		is_joueur_in_range = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("joueur"):
		is_joueur_in_range = false
