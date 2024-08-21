extends CanvasLayer

signal start_game

func update_score(value):
	$MarginContainer/Score.text = str(value)

func update_time(value):
	$MarginContainer/Time.text = str(value)

func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()


func _on_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
	
func show_game_level(game_level):
	show_message(str("Level ", game_level))
	await $Timer.timeout
	$Message.hide()
