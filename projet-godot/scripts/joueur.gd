extends CharacterBody2D

@export var speed := 400
@export var jump_force := -500
@export var gravity := 1200
@export var max_health := 6
@export var damage_per_hit := 1
@export var invulnerability_time := 0.5  # Temps d'invincibilité après un coup
@onready var marche_metal = $AudioStreamPlayer2D
@onready var son_saut = $AudioStreamPlayer2D2
@onready var sword = $AudioStreamPlayer2D3
@onready var hurt = $AudioStreamPlayer2D4
@onready var death = $AudioStreamPlayer2D5

# On cible directement l'AnimatedSprite2D à l'intérieur de barre_vie
@onready var health_bar_sprite: AnimatedSprite2D = get_node("/root/main/HUD/barre_vie/AnimatedSprite2D")

var current_health := max_health
var is_invulnerable := false
var is_taking_damage := false
var is_walking_sound_playing := false

var screen_size : Vector2
var is_attacking := false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("idle")
	update_health_bar()

# Met à jour la barre de vie en fonction de la santé actuelle
func update_health_bar():
	if health_bar_sprite:
		health_bar_sprite.frame = max_health - current_health

# Le joueur subit des dégâts
func take_damage(amount):
	if is_invulnerable or current_health <= 0:
		return

	current_health -= amount
	current_health = clamp(current_health, 0, max_health)

	print("Player took damage! Health =", current_health)

	$AnimatedSprite2D.play("damage")
	update_health_bar()
	hurt.play()

	is_taking_damage = true
	is_invulnerable = true
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	is_taking_damage = false

	if current_health <= 0:
		die()

# Le joueur meurt
func die():
	# Stop input and movement
	set_process(false)
	set_physics_process(false)

	# Play death animation
	$AnimatedSprite2D.play("death")
	death.play()
	
	# Wait for the animation to finish
	await $AnimatedSprite2D.animation_finished

	# Reload the current scene
	get_tree().reload_current_scene()



func _physics_process(delta):
	# Déplacement horizontal
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	# Gravité et saut
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("saut"):
			velocity.y = jump_force
			if not is_taking_damage:
				$AnimatedSprite2D.play("jump")
				son_saut.play()

	# Orientation du sprite
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

	# animations selon l'état du joueur et son de marche
	if is_taking_damage:
		pass  # Ne rien changer, laisser l'animation "damage" jouer
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

	# Empêche le joueur de sortir de l'écran
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Attaque du joueur
	if Input.is_action_just_pressed("attaque_joueur"):
		attaque()
		sword.play()

# Fonction d'attaque
func attaque():
	is_attacking = true
	$AnimatedSprite2D.play("attaque")

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
