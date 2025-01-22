extends Node2D

@export var enemy_scenes: Array  # Array to hold different enemy scenes
@export var spawn_interval: float = 3.0  # Interval to spawn enemies (in seconds)
@export var game_width: float = 450.0  # Width of the game area
@export var spawn_offset_y: float = 500.0  # Distance above the player to start spawning enemies
@export var spawn_chance: float = 0.1  # Probability to spawn an enemy

@export var platform_scenes: Array  # Array of platform scenes to check for Y positions

var last_spawn_y: float = 0.0  # Tracks the Y position of the last enemy spawned
var active_platforms: Array = []  # Array to track active platforms
var time_since_last_spawn: float = 0.0  # Tracks time passed since last enemy spawn

@export var score_threshold: int = 14000  # Score threshold to switch spawning enemies

func _ready():
	var player = get_parent().get_node("Player")
	last_spawn_y = player.position.y - spawn_offset_y  # Initialize spawn position based on player

	# Initial spawn for testing
	for i in range(5):
		spawn_enemy_if_chance(last_spawn_y + i * spawn_offset_y)

func _process(delta):
	var player = get_parent().get_node("Player")
	time_since_last_spawn += delta  # Update the time passed

	# Check if enough time has passed to spawn a new enemy
	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0  # Reset timer
		spawn_enemy_if_chance(player.position.y)  # Spawn the enemy relative to player's position

	# Keep spawning platforms above player
	while player.position.y < last_spawn_y - spawn_offset_y:
		var new_y = last_spawn_y - randf_range(spawn_offset_y, spawn_offset_y * 2)  # Adjust spawn range
		spawn_enemy_if_chance(new_y)
		last_spawn_y = new_y  # Update last spawn position for the next enemy spawn

func spawn_enemy_if_chance(player_y_position: float):
	# Check if a random value is less than spawn_chance to decide whether to spawn an enemy
	if randf() < spawn_chance:
		# Ensure the enemy spawns above platforms
		var spawn_y = get_spawn_above_platforms(player_y_position)
		var x_position = randf_range(0, game_width)  # Random x position within the game width

		var score = Global.score  # Assuming Global is a singleton with a score variable

		# Decide which enemy to spawn based on the score
		if score < score_threshold:
			print("Spawning enemy 0")  # Debug print
			spawn_enemy(Vector2(x_position, spawn_y), 0)  # Spawn the first enemy
		else:
			# Randomly choose between the second and third enemy
			var enemy_index = randi() % 2 + 1
			print("Spawning enemy", enemy_index)  # Debug print
			spawn_enemy(Vector2(x_position, spawn_y), enemy_index)

func get_spawn_above_platforms(player_y_position: float) -> float:
	var highest_platform_y = player_y_position  # Start with the player's position as the lowest Y

	# Loop through all platforms in the active_platforms array and find the highest platform
	for platform in active_platforms:
		if platform.position.y > highest_platform_y:
			highest_platform_y = platform.position.y

	# Add some space above the highest platform for enemy spawn
	var spawn_y = highest_platform_y + randf_range(50, 150)  # Adjust the range based on how far above the platforms you want to spawn the enemies
	return spawn_y

func spawn_enemy(position: Vector2, index: int):
	if index < 0 or index >= enemy_scenes.size():
		print("Error: Invalid index for enemy scenes!")
		return

	var selected_enemy_scene = enemy_scenes[index]
	if selected_enemy_scene:
		var enemy = selected_enemy_scene.instantiate()
		enemy.position = position
		add_child(enemy)
	else:
		print("Error: Selected enemy scene is invalid!")

# Assuming a function to spawn platforms exists
func spawn_platform(y_position: float):
	var platform_scene = platform_scenes[randi() % platform_scenes.size()]  # Select a random platform scene
	var platform = platform_scene.instantiate()
	platform.position = Vector2(randf_range(0, game_width), y_position)
	add_child(platform)
	active_platforms.append(platform)  # Add the platform to the active platforms array
