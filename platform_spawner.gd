extends Node2D

@export var platform_scenes: Array  # Array to hold different platform scenes
@export var platform_spawn_chances_first_half: Array = [0.6, 0.2, 0.2]  # Probabilities for platforms 1, 2, and 3
@export var platform_spawn_chances_second_half: Array = [0.6, 0.2, 0.2]  # Probabilities for platforms 4, 5, and 6
@export var min_spawn_distance: float = 150.0  # Increased minimum vertical distance between platforms
@export var max_spawn_distance: float = 200.0  # Increased maximum vertical distance between platforms
@export var game_width: float = 450.0  # Width of the game area
@export var spawn_offset_y: float = 200.0  # Distance above the player to start spawning platforms
@export var min_horizontal_distance: float = 120.0  # Increased minimum horizontal distance between platforms
@export var max_horizontal_distance: float = 180.0  # Increased maximum horizontal distance between platforms
@export var max_platforms_per_level: int = 2  # Reduced maximum number of platforms per Y level
@export var platform_width: float = 60.0  # Platform width (in pixels)

var last_spawn_y: float = 0.0  # Tracks the Y position of the last platform spawned
var spawned_platforms: Array = []  # Array to track spawned platforms for collision detection

func _ready():
	var player = get_parent().get_node("Player")
	# Ensure no platforms spawn below the player when the game starts
	last_spawn_y = player.position.y + spawn_offset_y

	# Spawn initial platforms above the player's current position
	for i in range(5):  # Reduced initial platform count
		if last_spawn_y > player.position.y:
			spawn_multiple_platforms(last_spawn_y + i * min_spawn_distance)

func _process(delta):
	var player = get_parent().get_node("Player")
	# Keep spawning platforms as the player ascends
	while player.position.y < last_spawn_y - min_spawn_distance:
		var new_y = last_spawn_y - randf_range(min_spawn_distance, max_spawn_distance)
		if new_y > player.position.y:
			spawn_multiple_platforms(new_y)
			last_spawn_y = new_y  # Update last_spawn_y for the next platform

	# Clean up spawned_platforms array to remove freed platforms
	cleanup_spawned_platforms()

func spawn_multiple_platforms(y_position: float):
	# Randomly decide how many platforms to spawn (1 or 2)
	var platforms_to_spawn = randi() % max_platforms_per_level + 1  # Now only 1 or 2 platforms

	var last_x_position = -platform_width  # Keep track of the last platform's X position
	for i in range(platforms_to_spawn):
		var x_position = random_x_position(last_x_position)
		# Ensure the new platform doesn't collide with existing platforms
		while is_colliding_with_other_platforms(Vector2(x_position, y_position)):
			x_position = random_x_position(last_x_position)
		spawn_platform(Vector2(x_position, y_position))
		last_x_position = x_position + platform_width  # Update last_x_position

func spawn_platform(position: Vector2):
	# Use the spawn chances to randomly choose a platform from the array
	var platform_scene = get_random_platform()
	var platform = platform_scene.instantiate()
	platform.position = position
	add_child(platform)
	spawned_platforms.append(platform)  # Add the platform to the tracking array

func random_x_position(last_x_position: float) -> float:
	# Generate a random X position with enough space between platforms
	var x_pos = randf_range(last_x_position + min_horizontal_distance, game_width - platform_width)
	return x_pos

func is_colliding_with_other_platforms(new_position: Vector2) -> bool:
	# Check if the new platform collides with any existing platforms
	for platform in spawned_platforms:
		if is_instance_valid(platform):  # Ensure the platform is still valid
			var platform_rect = Rect2(platform.position, Vector2(platform_width, 10))  # Assuming platform height is 10
			var new_platform_rect = Rect2(new_position, Vector2(platform_width, 10))
			if platform_rect.intersects(new_platform_rect):
				return true  # Collision detected
	return false  # No collision

func cleanup_spawned_platforms():
	# Remove freed platforms from the spawned_platforms array
	var valid_platforms = []
	for platform in spawned_platforms:
		if is_instance_valid(platform):  # Check if the platform is still valid
			valid_platforms.append(platform)
	spawned_platforms = valid_platforms

func get_random_platform() -> PackedScene:
	var score = Global.score  # Access the global score
	var rand_value = randf()  # Random float between 0 and 1
	var cumulative_probability = 0.0
	
	# Choose which set of platform chances to use based on the score
	if score < 15000:
		# Use the first half probabilities for platforms 1, 2, and 3
		for i in range(3):
			cumulative_probability += platform_spawn_chances_first_half[i]
			if rand_value <= cumulative_probability:
				return platform_scenes[i]
	else:
		# Use the second half probabilities for platforms 4, 5, and 6
		for i in range(3, 6):
			cumulative_probability += platform_spawn_chances_second_half[i - 3]
			if rand_value <= cumulative_probability:
				return platform_scenes[i]
	
	# If no platform is chosen, return the last one (failsafe, should not happen)
	return platform_scenes[platform_scenes.size() - 1]
