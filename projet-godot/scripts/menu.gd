extends CanvasLayer

@onready var entrer = $AudioStreamPlayer
@onready var sortir = $AudioStreamPlayer2
@onready var menu_music = $AudioStreamPlayer3

func _ready() -> void:
	print("PauseMenu:", $PauseMenu)
	print("InstructionsScreen:", %InstructionsScreen)
	$PauseMenu.hide()
	%InstructionsScreen.hide()

func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pauser()
		menu_music.play()
	else:
		continuer()

func pauser() -> void:
	print("PAUSE MODE")
	$PauseMenu.show()
	entrer.play()
	menu_music.play()
	get_tree().paused = true
	$PauseMenu/ShowInstructions.grab_focus.call_deferred()


func continuer() -> void:
	print("PLAY MODE")
	$PauseMenu.hide()
	%InstructionsScreen.hide()
	menu_music.stop()
	sortir.play()
	get_tree().paused = false

func _on_continue_button_pressed() -> void:
	continuer()

func _on_close_button_pressed() -> void:
	%InstructionsScreen.hide()
	$PauseMenu/ShowInstructions.grab_focus.call_deferred()
	sortir.play()

func _on_show_instructions_pressed() -> void:
	%InstructionsScreen.show()
	%InstructionsScreen/CloseButton.grab_focus.call_deferred()
	entrer.play()
