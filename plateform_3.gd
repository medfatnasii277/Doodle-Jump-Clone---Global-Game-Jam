extends StaticBody2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = get_node("/root/Game/Player")
	if body.name == "Player":
		# Apply a smooth jump boost, ensuring the player experiences a nice bounce
		body.velocity.y = -900  # Instant boost force upwards
		player.ressort_jump.play("ressort")  # Play the jump animation
		
		
		# Squash/stretch effect for bubble feel (you can adjust the values for better effects)
		player.sprite_2d.scale = Vector2(1.0, 1.2)  # Stretch when boosted
	
			
			
			
 
		
