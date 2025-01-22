extends Node2D

@onready var player = $Player  # Player node
@onready var audio_player1: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var audio_player3: AudioStreamPlayer = $AudioStreamPlayer3
@onready var fogg: ParallaxBackground = $fogg
@onready var label: Label = $CanvasLayer2/Label




var current_sound_phase: int = 1  # To track which sound is currently playing



func _ready():
	# Set all audio players to loop
	audio_player1.stream.loop = true
	audio_player2.stream.loop = true
	audio_player3.stream.loop = true
	
	# Initialize the score
	Global.score = 0
	print("Game Started! Your score is: ", Global.score)
	play_sound(1)


func _process(delta):
	# Increment the score based on the player's vertical position
	Global.score = int(abs(player.position.y))
	update_score_label() 
	#print(Global.score)
	
	# Access the global score
	var score = Global.score


	if score > 14000:
		fogg.visible = false 
		
	# Phase 1: Score < 7000
	if score < 7000 and current_sound_phase != 1:
		play_sound(1)

	# Phase 2: Score >= 7000 and < 14000
	elif score >= 7000 and score < 15000 and current_sound_phase != 2:
		play_sound(2)

	# Phase 3: Score >= 14000
	elif score >= 15000 and current_sound_phase != 3:
		play_sound(3)
		
		
		

func play_sound(phase):
	current_sound_phase = phase

	# Stop all sounds first
	audio_player1.stop()
	audio_player2.stop()
	audio_player3.stop()

	# Play the corresponding sound for the current phase
	if phase == 1:
		audio_player1.play()
	elif phase == 2:
		audio_player2.play()
	elif phase == 3:
		audio_player3.play()
func update_score_label():
	label.text = "Score: " + str(Global.score)
