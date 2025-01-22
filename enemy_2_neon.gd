extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Node2D = get_node("/root/Game/Player")
@onready var play_again_scene = preload("res://play_again.tscn")  # Path to your Play Again scene
@onready var play_again: Control = $"/root/Game/playAgain"
@onready var camera: Camera2D = $"/root/Game/Player/Camera2D"  # Reference to your Camera2D node
@onready var timer: Timer = $"../Timer"






	


func _on_enemy_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Play death animation
		player.get_node("Sprite2D").play("death")
		
		# Print Game Over message and score
		print("Game Over")
		print(Global.score)
		
		# Pause the game (this stops updates, physics, etc.)
		get_tree().paused = true
		
		# Make the play_again Control node visible after the player dies
		play_again.visible = true  # This will make the node appear
		
		# Disable the camera's follow behavior by setting 'enabled' to false
		camera.enabled = false  # This stops the camera from following the player
