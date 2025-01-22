extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_resume_pressed() -> void:
	Engine.time_scale = 1  # Unfreeze the game
	get_tree().paused = false  # Unpause the game
	$".".visible = false  # Hide the pause menu

func _on_main_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
