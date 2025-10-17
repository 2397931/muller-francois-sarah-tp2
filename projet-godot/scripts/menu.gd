extends CanvasLayer

@onready var panneau_pause = $HUD/ControlePause/PanneauPause
@onready var panneau_instructions = $HUD/ControlePause/PanneauInstructions
@onready var controle_pause = $HUD/ControlePause
@onready var button_retour_pause = $HUD/ControlePause/PanneauPause/ButtonRetour
@onready var button_instructions = $HUD/ControlePause/PanneauPause/ButtonInstructions
@onready var button_retour_instructions = $HUD/ControlePause/PanneauInstructions/retour


func _ready() -> void:
	print("panneau_pause: ", panneau_pause)
	print("panneau_instructions: ", panneau_instructions)
	print("controle_pause: ", controle_pause)
	print("button_retour_pause: ", button_retour_pause)
	print("button_instructions: ", button_instructions)
	print("button_retour_instructions: ", button_retour_instructions)
	panneau_pause.visible = false
	panneau_instructions.visible = false

	# Connecter les boutons
	controle_pause.pressed.connect(_on_controle_pause_pressed)
	button_retour_pause.pressed.connect(_on_button_retour_pressed)
	button_instructions.pressed.connect(_on_instructions_pressed)
	button_retour_instructions.pressed.connect(_on_retour_pressed)

func _on_controle_pause_pressed() -> void:
	# Affiche ou cache le panneau de pause
	panneau_pause.visible = not panneau_pause.visible

func _on_instructions_pressed() -> void:
	# Ouvre le panneau instructions
	panneau_instructions.visible = true
	panneau_pause.visible = false

func _on_retour_pressed() -> void:
	# Retour au panneau pause
	panneau_instructions.visible = false
	panneau_pause.visible = true

func _on_button_retour_pressed() -> void:
	# Retour au menu principal ou fermeture du panneau
	panneau_pause.visible = false
	get_tree().paused = false
