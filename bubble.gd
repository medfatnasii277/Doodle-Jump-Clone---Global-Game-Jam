extends CharacterBody2D

var speed = 400  # Bullet speed
var direction = Vector2(1, 0)  # Direction in which the bullet moves

func _ready():
	# Make sure the direction is normalized for consistent speed
	direction = direction.normalized()

func _process(delta):
	# Move the bullet in the given direction using move_and_slide
	velocity = direction * speed  # Calculate the velocity
	move_and_slide()  # Apply movement using the calculated velocity
