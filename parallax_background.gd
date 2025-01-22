extends ParallaxBackground

@onready var layer1: ParallaxLayer = $ParallaxLayer
@onready var layer2: ParallaxLayer = $ParallaxLayer2
@onready var layer3: ParallaxLayer = $ParallaxLayer3
@onready var layer4: ParallaxLayer = $ParallaxLayer4
@onready var layer5: ParallaxLayer = $ParallaxLayer5
@onready var layer6: ParallaxLayer = $ParallaxLayer6

var transition_started: bool = false  # Track if the transition has started
var transition_progress: float = 0.0  # Track the progress of the transition (0 to 1)
var transition_speed: float = 0.5  # Speed of the transition (adjust as needed)
var current_phase: int = 1  # Track the current phase (1, 2, or 3)

func _ready():
	# Initially, show only the first two layers (clear sky)
	layer1.visible = true
	layer2.visible = true
	layer3.visible = false
	layer4.visible = false
	layer5.visible = false
	layer6.visible = false

	# Set initial opacity for all layers
	layer1.modulate.a = 1.0
	layer2.modulate.a = 1.0
	layer3.modulate.a = 0.0
	layer4.modulate.a = 0.0
	layer5.modulate.a = 0.0
	layer6.modulate.a = 0.0

func _process(delta):
	# Access the global score
	var score = Global.score

	# Phase 1: Score < 7000
	if score < 7000:
		set_phase(1)
		reset_layer_opacity(layer1, layer2)

	# Phase 2: Score >= 7000 and < 14000
	elif score >= 7000 and score < 14000:
		if current_phase != 2:
			set_phase(2)
			transition_started = true
			transition_progress = 0.0

		# Perform the transition from layer1/layer2 to layer3/layer4
		if transition_started and transition_progress < 1.0:
			transition_progress += transition_speed * delta
			transition_layers(layer1, layer2, layer3, layer4, transition_progress)

		if transition_progress >= 1.0:
			finalize_layers(layer1, layer2)

	# Phase 3: Score >= 14000
	elif score >= 14000:
		if current_phase != 3:
			set_phase(3)
			transition_started = true
			transition_progress = 0.0

		# Perform the transition from layer3/layer4 to layer5/layer6
		if transition_started and transition_progress < 1.0:
			transition_progress += transition_speed * delta
			transition_layers(layer3, layer4, layer5, layer6, transition_progress)

		if transition_progress >= 1.0:
			finalize_layers(layer3, layer4)

func set_phase(new_phase):
	current_phase = new_phase
	transition_started = false
	transition_progress = 0.0

func reset_layer_opacity(layer_a, layer_b):
	layer_a.visible = true
	layer_b.visible = true
	layer_a.modulate.a = 1.0
	layer_b.modulate.a = 1.0

func transition_layers(out_layer_a, out_layer_b, in_layer_a, in_layer_b, progress):
	out_layer_a.modulate.a = 1.0 - progress
	out_layer_b.modulate.a = 1.0 - progress if out_layer_b else 1.0
	in_layer_a.modulate.a = progress
	if in_layer_b:
		in_layer_b.modulate.a = progress
		in_layer_b.visible = true

	in_layer_a.visible = true

func finalize_layers(out_layer_a, out_layer_b):
	out_layer_a.visible = false
	if out_layer_b:
		out_layer_b.visible = false
