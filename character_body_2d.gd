extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DOUBLE_JUMP_VELOCITY = -500.0  # You can adjust this for your double jump strength
const SUPER_JUMP_VELOCITY = -900.0  # New super jump velocity
const GRAVITY = 1000.0  # Higher gravity for more realistic falling
const AIR_CONTROL = 0.1  # Less control in the air
const DECELERATION = 0.1  # For smooth deceleration


var jump_count = 0  # Track the number of jumps (1 = single, 2 = double)
var superjump_active = false
var air_control_factor = 1.0  # Factor for air control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var double_jump_effect: AnimatedSprite2D = $DoubleJumpEffect
@onready var ressort_jump: AnimatedSprite2D = $RessortJump
var bubleshot = preload("res://bubble.tscn")
@onready var marker_2d: Marker2D = $Marker2D
var shoot_direction = Vector2(1, 0)  # Default direction to shoot (right)

# Connect the animation finished signal to a handler
func _ready() -> void:
	# Connect the 'animation_finished' signal to '_on_animation_finished'
	sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Physics process for smooth control and gravity
func _physics_process(delta: float) -> void:
	print(velocity)
	# Apply gravity with smoother transition for falling and jumping
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		air_control_factor = AIR_CONTROL  # Less air control when not on the floor
	else:
		air_control_factor = 1.0  # Full control when on the floor
	
	# Movement logic (horizontal)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * SPEED, 0.1)  # Smooth horizontal movement
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * DECELERATION)  # Smooth deceleration when idle

	# Jumping (single, double, super jump)
	if Input.is_action_just_pressed("ui_accept"):
		
		velocity.y = JUMP_VELOCITY
		jump_count = 1
		animation_player.play("jump")
		if jump_count == 1:
			velocity.y = DOUBLE_JUMP_VELOCITY
			jump_count = 2
			animation_player.play("jump")
		
	
	# Play double jump effect when in the air and above certain velocity
	if velocity.y < -1000:
		if not double_jump_effect.is_playing():
			double_jump_effect.visible = true
			double_jump_effect.play("boost")

			
	# Handle the effects and squash/stretch animations for a bubble-like feel
	if velocity.y < -300:
		sprite_2d.scale = Vector2(1.0, 1.2)  # Stretch the sprite vertically while jumping
	elif velocity.y > 300:
		sprite_2d.scale = Vector2(1.0, 0.8)  # Squash the sprite when falling

	# Apply movement
	move_and_slide()

# Function that will be triggered when any animation finishes
func _on_animation_finished() -> void:
	if sprite_2d.animation == "superjump":
		# When the superjump animation finishes, check if the player is on the floor
		if is_on_floor():
			sprite_2d.play("default")  # Play the idle animation when the player is on the floor
			superjump_active = false  # Reset superjump active flag

func _on_double_jump_effect_animation_finished() -> void:
	double_jump_effect.stop()  # Stop the animation
	double_jump_effect.visible = false  # Hide the effect
	
	

	
