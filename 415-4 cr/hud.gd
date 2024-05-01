extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func update_score(score):
	$ScoreLabel.text = "Score: "+str(score)
	
func update_health(x):
	$HealthLabel.text = "Health: "+str(x)
	
func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Infinite Runner"
	$Message.show()
	$StartButton.show()

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
