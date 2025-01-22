extends StaticBody2D

@onready var timer: Timer = $Timer







func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name =="Player":
			timer.start(0.5)
			body.velocity.y = -600

	

	 


	




	
   


func _on_timer_timeout() -> void:
	queue_free()
