extends CharacterBody2D
class_name Joueur

@export var speed := 400
@export var jump_force := -500
@export var gravity := 1200
@export var damage_per_hit := 1
@export var invulnerability_time := 0.8

@onready var marche_metal = $AudioStreamPlayer2D
@onready var son_saut = $AudioStreamPlayer2D2
@onready var sword = $AudioStreamPlayer2D3
@onready var hurt = $AudioStreamPlayer2D4
@onready var death = $AudioStreamPlayer2D5

var cam : Camera2D
var is_invulnerable := false
var is_taking_damage := false
var is_walking_sound_playing := false
var is_attacking := false
var screen_size : Vector2

func player():
	pass

func _ready() -> void:
	cam = $Camera2D
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("idle")

	# No more HealthBar.update_health — UI listens to global

	is_invulnerable = true
	await get_tree().create_timer(1.0).timeout
	is_invulnerable = false

func take_damage(amount):
	if is_invulnerable or global.current_health <= 0:
		return

	global.damage(amount)
	print("Player took damage! Health =", global.current_health)

	$AnimatedSprite2D.play("damage")
	hurt.play()

	is_taking_damage = true
	is_invulnerable = true
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	is_taking_damage = false

	if global.current_health <= 0:
		die()


func die():
	set_process(false)
	set_physics_process(false)
	$AnimatedSprite2D.play("death")
	death.play()
	await $AnimatedSprite2D.animation_finished
	get_tree().reload_current_scene()



# ----- Physics & movement (unchanged) -----
func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("saut"):
			velocity.y = jump_force
			if not is_taking_damage:
				$AnimatedSprite2D.play("jump")
				son_saut.play()

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	if is_taking_damage:
		pass
	elif is_attacking:
		pass
	elif not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
		if not is_walking_sound_playing:
			marche_metal.play()
			is_walking_sound_playing = true
	else:
		$AnimatedSprite2D.play("idle")
		if is_walking_sound_playing:
			marche_metal.stop()
			is_walking_sound_playing = false

	move_and_slide()

	if cam:
		position.x = clamp(position.x, cam.limit_left, cam.limit_right)
		position.y = clamp(position.y, cam.limit_top, cam.limit_bottom)

	if Input.is_action_just_pressed("attaque_joueur"):
		attaque()
		sword.play()

func attaque():
	is_attacking = true
	$AnimatedSprite2D.play("attaque")

	await get_tree().create_timer(0.15).timeout

	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("ennemi"):
			body.take_hit()

	await $AnimatedSprite2D.animation_finished
	is_attacking = false

	if velocity.x != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
