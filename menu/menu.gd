extends Control




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") :
		get_tree().change_scene_to_file("res://pause_menu.tscn")


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
	


func _on_options_button_pressed():
	var options = load("res://options_ui.tscn") as PackedScene
	if options:
		var new_scene = options.instantiate()  
		get_tree().root.add_child(new_scene)


func _on_quit_button_pressed():
	get_tree().quit()




var is_sound_on: bool = true

@export var audio_bus: String = "Master"

func _on_audio_pressed() -> void:
	is_sound_on = not is_sound_on  

	var volume = 0.0 if is_sound_on else -80.0  
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), volume)
