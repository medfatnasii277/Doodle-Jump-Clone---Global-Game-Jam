extends ColorRect

@onready var color_rect: ColorRect = $"."  # Reference to the ColorRect node
# Adjust the colors with more cyberpunk aesthetics: blues, pinks, and neon accents
var day_color: Color = Color(0.4, 0.5, 0.8)  # Bold sunny light blue sky, with a slight pinkish tint
var foggy_color: Color = Color(0.6, 0.5, 0.7)  # Foggy purplish-pinkish color to create atmospheric effects
var night_color: Color = Color(0.1, 0.1, 0.2)  # Dark blue sky with a neon pinkish-purple glow for night
var transition_duration: float = 10.0  # Duration for the transition in seconds

var score: int = 0  # Assuming score is updated globally
var current_color: Color = day_color  # Start with sunny color
var transitioning: bool = false  # To avoid starting the transition repeatedly

func _ready():
	# Start the transition based on score updates
	call_deferred("_check_and_update_background_color")
	print("ColorRect size: ", size)

func _process(delta):
	# Update the score from the global variable
	score = Global.score  # Update the score

	# Check if we need to transition based on the score value
	_check_and_update_background_color()

# Function to update the background color based on score
func _check_and_update_background_color():
	# Determine the target color based on the score
	var target_color: Color = day_color
	if score >= 7000 and score < 14000:
		target_color = foggy_color  # Transition to foggy color between 7000 and 14000
	elif score >= 14000:
		target_color = night_color  # Transition to night color after 14000

	# If the target color is different from the current color, start the transition
	if target_color != current_color and not transitioning:
		_update_background_color(target_color)
		current_color = target_color  # Update the current color to the new one
		transitioning = true  # Mark that a transition is in progress

# Function to update the background color smoothly
func _update_background_color(target_color: Color):
	# Create a tween to smoothly transition to the new color
	var tween = create_tween()
	tween.tween_property(color_rect, "color", target_color, transition_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Reset the transitioning flag after the transition
	tween.tween_callback(Callable(self, "_on_transition_complete"))

# Callback when the transition is complete
func _on_transition_complete():
	transitioning = false  # Allow a new transition to start when needed
