extends Camera2D

@onready var player = get_node("/root/Game/Player")  # Adjust the path as needed


@export var follow_speed: float = 5.0  # Speed at which the camera catches up with the player
@export var vertical_offset: float = -100.0  # Vertical offset to give the player more space above
@export var horizontal_offset: float = 0.0  # Horizontal offset if needed
@export var smoothness: float = 0.1  # How smooth the camera movement should be (lower is smoother)

func _ready():
	# Set initial offset based on desired vertical and horizontal adjustments
	offset = Vector2(horizontal_offset, vertical_offset)

	# Enable smoothing
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed  # Set smoothing speed

	# Set camera limits for horizontal movement
	limit_left = 450
	limit_right = 500
