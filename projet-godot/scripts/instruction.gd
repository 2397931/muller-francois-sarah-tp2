extends Control

@onready var instruction = $HUD/Instruction
@onready var button_instructions = $HUD/ButtonInstructions
@onready var button_retour = $HUD/Instruction/retour  # assuming the retour button is inside the instruction panel

func _ready() -> void:
	# Hide the instruction panel at start
	instruction.visible = false

	# Connect the buttons
	button_instructions.pressed.connect(_on_button_instructions_pressed)
	button_retour.pressed.connect(_on_retour_pressed)

func _on_retour_pressed() -> void:
	# Hide the instruction panel when pressing retour
	instruction.visible = false


func _on_button_instructions_pressed() -> void:
	# Show the instruction panel when the button is pressed
	instruction.visible = true
