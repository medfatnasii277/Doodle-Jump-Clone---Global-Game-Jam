extends Area2D

@onready var player = get_node("/root/Game/Player")  # Assuming Player is in the Game node
@onready var sprite_2d: AnimatedSprite2D = player.get_node("Sprite2D")  # Access the bubble sprite
@onready var jumpboost: AudioStreamPlayer = $AudioStreamPlayer

@export var float_pixels: float = 1000.0  # Distance the player should float upwards
@export var float_strength: float = 1200.0  # Initial upward force to make the player float
@export var float_decay: float = 300.0  # How much the upward force decays each frame
@export var landing_gravity: float = 600.0  # Gravity applied after the float ends for smooth landing
@export var max_float_strength: float = 1500.0  # Maximum float strength (to avoid instant float)

var floating: bool = false
var initial_position: Vector2 = Vector2.ZERO  # Tracks the initial position when floating starts
var current_float_strength: float = 0.0  # Tracks the current upward force
var smooth_landing: bool = false  # Determines if the player is in the smooth landing phase

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Check if the player collides
		start_floating(body)
		jumpboost.play()
		print("Hey! Player collected the floating item!")

func start_floating(player: Node2D):
	# Start the floating effect
	floating = true
	smooth_landing = false  # Ensure smooth landing isn't active yet
	initial_position = player.position  # Track the player's position when floating starts
	current_float_strength = float_strength  # Start with the full force

	# Apply the initial upward force (smooth transition for the bubble)
	player.velocity.y = -current_float_strength  # Set initial upward velocity

	# Scale the bubble to simulate an initial expansion
	sprite_2d.scale = Vector2(1.0, 1.2)  # Stretch the bubble a little at the start

func _process(delta):
	if floating:
		var player = get_node("/root/Game/Player")  # Access the player node

		# Smoothly decrease the floating strength over time (to simulate air resistance)
		current_float_strength -= float_decay * delta  # Apply the decay (smooth fading)
		if current_float_strength < 0:
			current_float_strength = 0  # Ensure the force doesn't go negative

		# Apply the current force to the player
		player.velocity.y = -current_float_strength  # Adjust the player's velocity upward

		# Bubble shrinks as it rises, simulating buoyancy
		sprite_2d.scale = Vector2(1.0, 1.0 + (current_float_strength / max_float_strength))  # Shrink as it floats

		# Check if the player has floated the required distance
		if player.position.y <= initial_position.y - float_pixels:
			stop_floating(player)

	# If floating has stopped, apply gravity for smooth landing
	if not floating and not smooth_landing:
		smooth_landing = true  # Transition into landing phase
		apply_smooth_landing(player, delta)

func stop_floating(player: Node2D):
	# Stop floating once the player has moved the desired distance
	floating = false
	print("Player finished floating!")

	# Optionally, trigger a float effect end, like shrinking the bubble
	sprite_2d.scale = Vector2(1.0, 1.0)  # Reset scale

func apply_smooth_landing(player: Node2D, delta: float):
	# Apply downward force (gravity) for smooth landing
	player.velocity.y += landing_gravity * delta  # Apply gravity to start falling slowly

	# You can add conditions here to stop the landing effect once the player touches the ground
	if player.is_on_floor():
		player.velocity.y = 0  # Stop downward velocity once the player lands
		sprite_2d.scale = Vector2(1.0, 1.0)  # Reset the scale when landing
		print("Player has landed smoothly!")
