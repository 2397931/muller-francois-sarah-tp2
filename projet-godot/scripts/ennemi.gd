extends CharacterBody2D

@export var speed := 100
@export var attaque_distance := 50.0
@export var max_hits := 4
@export var attaque_cooldown := 1.0
@export var patrol_interval := 2.0
@export var damage_amount := 1

@onready var son_attaque = $AudioStreamPlayer2D
@onready var mort = $AudioStreamPlayer2D2
@onready var anim = $AnimatedSprite2D

var joueur: Node2D
var hits_taken := 0
var is_dead := false
var is_joueur_in_range := false
var is_taking_damage := false
var attacking_loop_running := false

var patrol_direction := 0
var patrol_timer := 0.0
var min_x := 0
var max_x := 3835

func _ready() -> void:
	joueur = get_tree().get_first_node_in_group("joueur")
	anim.play("walk")
	randomize()

func _physics_process(delta):
	if is_dead or joueur == null:
		return

	if is_joueur_in_range:
		var direction = joueur.global_position - global_position
		var distance = direction.length()

		if distance > attaque_distance:
			velocity = direction.normalized() * speed
			move_and_slide()
			if not is_taking_damage and anim.animation != "attaque":
				anim.play("walk")
			anim.flip_h = direction.x < 0
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
	anim.play("attaque")
	son_attaque.play()

	if joueur != null and joueur.has_method("take_damage"):
		if not joueur.is_invulnerable:
			joueur.take_damage(damage_amount)

	await anim.animation_finished

	if not is_dead and not is_taking_damage:
		anim.play("walk")

func take_hit():
	if is_dead or is_taking_damage:
		return

	is_taking_damage = true
	hits_taken += 1
	print("Ennemi touché ! Total =", hits_taken)

	var dir = sign(global_position.x - joueur.global_position.x)
	velocity.x = dir * 150
	velocity.y = -100

	anim.play("damage")
	await anim.animation_finished

	if hits_taken >= max_hits:
		die()
	else:
		is_taking_damage = false
		anim.play("walk")
		if is_joueur_in_range and not attacking_loop_running:
			start_attacking_loop()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	anim.play("death")
	mort.play()
	await anim.animation_finished
	queue_free()

func patrol(delta):
	patrol_timer -= delta
	if patrol_timer <= 0:
		patrol_direction = randi() % 3 - 1
		patrol_timer = patrol_interval

	velocity = Vector2(patrol_direction * speed, 0)
	move_and_slide()

	if not is_taking_damage and anim.animation != "attaque":
		anim.play("walk")

	if patrol_direction != 0:
		anim.flip_h = patrol_direction < 0

func _on_detection_area_body_entered(body):
	if body.is_in_group("joueur"):
		is_joueur_in_range = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("joueur"):
		is_joueur_in_range = false
