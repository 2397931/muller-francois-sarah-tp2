extends CanvasLayer

func fade_out():
	$ColorRect.modulate.a = 0.0
	$ColorRect.show()
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 0.4)
	await tween.finished

func fade_in():
	$ColorRect.modulate.a = 1.0
	$ColorRect.show()
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.4)
	await tween.finished
	$ColorRect.hide()
