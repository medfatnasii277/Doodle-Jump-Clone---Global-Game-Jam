extends Area2D

@onready var player = get_node("/root/Game/Player")  # Assuming Player is in the Game node
@export var invincibility_duration: float = 30.0  # Duration of invincibility in seconds

var invincible: bool = false  # Tracks whether the player is invincible

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Check if the player collides with the item
		grant_invincibility(body)
		print("Player picked up invincibility item!")

func grant_invincibility(player: Node2D):
	if not invincible:
		invincible = true
		# Optionally change the player's appearance to show invincibility (e.g., change color or add a glow)
		# You can also trigger visual or audio effects to indicate invincibility

		# Disable collisions with enemies by modifying the CollisionMask
		player.collision_mask = 0  # Set to 0 to ignore all collisions (you can specify particular layers to ignore if needed)

		# Start a timer to remove invincibility after the specified duration
		await get_tree().create_timer(invincibility_duration).timeout  # Wait for the timer to finish
		stop_invincibility(player)

func stop_invincibility(player: Node2D):
	# End invincibility effect after the duration
	invincible = false

	# Re-enable collisions by restoring the CollisionMask
	player.collision_mask = 1  # Assuming the player should collide with the default layers (layer 1)

	# Optionally reset any visual effects or status indicators
	print("Invincibility ended!")
