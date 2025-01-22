extends StaticBody2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var platform: StaticBody2D = $"."

# The method to detect when the player enters the platform's area
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.name == "Player":  # Replace with the exact name of your player node
		# Apply instant jump by setting the player's velocity
		body.velocity.y = -600  # Jump velocity
		
		
		
		# Access the player's AnimationPlayer and play the "jump" animation
		var player_animation_player = body.get_node("AnimationPlayer")  # Make sure to use the correct node path
		if player_animation_player is AnimationPlayer:
			player_animation_player.play("jump")  # Play the jump animation

func _process(delta):
	var player = get_node("/root/Game/Player")  # Reference to the player node
	if player and collision_shape_2d  :
		# Check if the player is falling and above the platform (using one-way collision)
		if   player.position.y + player.scale.y / 2 > platform.position.y - platform.scale.y / 2:
			# The player is falling down and about to land on the platform
			if not audio_stream_player.playing:
				audio_stream_player.play()  # Play the sound if it's not already playing
				print("Playing sound as player lands on platform.")
