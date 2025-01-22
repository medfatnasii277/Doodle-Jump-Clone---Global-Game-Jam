extends Control

@onready var your_score: Label = $YourScore  # Ensure this path is correct

# Called when the node enters the scene tree for the first time.
func _ready():
	# We can update the score when the scene is ready.
	update_score_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function for Play Again button pressed event
func _on_p_layagain_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")  # Reloads the game scene

# Function to update the score label with the current global score
func update_score_label():
	# Print the score to make sure it's correct
	print("Updated score: " + str(Global.score))  # This should print the score when this function is called.
	
	if your_score:
		your_score.text = "Your Score: " + str(Global.score)  # Update the label with the score
	else:
		print("Error: Label not found!")
	
# Function for Quit button pressed event
func _on_quit_pressed() -> void:
	get_tree().quit()  # Quit the game
