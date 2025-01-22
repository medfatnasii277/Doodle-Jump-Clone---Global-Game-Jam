extends Node2D

@export var spawnable_scenes: Array  # Array to hold different item scenes
@export var min_spawn_distance: float = 300.0  # Minimum vertical distance between items
@export var max_spawn_distance: float = 500.0  # Maximum vertical distance between items
@export var game_width: float = 450.0  # Width of the game area
@export var spawn_offset_y: float = 300.0  # Distance above the player to start spawning items
@export var spawn_chance: float = 0.1  # Probability to spawn an item

var last_spawn_y: float = 0.0  # Tracks the Y position of the last item spawned
@export var score_threshold: int = 14000  # Score threshold to switch spawning items

func _ready():
	var player = get_parent().get_node("Player")
	last_spawn_y = player.position.y - spawn_offset_y

	# Initial spawn for testing
	for i in range(5):
		spawn_item_if_chance(last_spawn_y + i * min_spawn_distance)

func _process(delta):
	var player = get_parent().get_node("Player")
	
	while player.position.y < last_spawn_y - min_spawn_distance:
		var new_y = last_spawn_y - randf_range(min_spawn_distance, max_spawn_distance)
		spawn_item_if_chance(new_y)
		last_spawn_y = new_y

func spawn_item_if_chance(y_position: float):
	if randf() < spawn_chance:
		var x_position = randf_range(0, game_width)
		var score = Global.score  # Assuming Global is a singleton with a score variable

		# Debugging: Print which item should spawn
		if score < score_threshold:
			print("Spawning item 0")
			spawn_item(Vector2(x_position, y_position), 0)  # Spawn the first item
		else:
			print("Spawning item 1")
			spawn_item(Vector2(x_position, y_position), 1)  # Spawn the second item

func spawn_item(position: Vector2, index: int):
	if index < 0 or index >= spawnable_scenes.size():
		print("Error: Invalid index for spawnable scenes!")
		return

	var selected_scene = spawnable_scenes[index]
	if selected_scene:
		var item = selected_scene.instantiate()
		item.position = position
		add_child(item)
	else:
		print("Error: Selected scene is invalid!")
