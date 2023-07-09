extends StaticBody2D

enum ChestState {
	CLOSED,
	OPEN
}

enum InteractionState {
	NONE,
	ENTERED,
	INTERACTED
}

@export var interaction_cooldown = 0.5
var interaction_cooldown_timer = 0.0

var anim = null
var int_state = InteractionState.NONE
var highlighted_last_frame = false
var chest_state = ChestState.CLOSED

@onready var label = $label

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("AnimatedSprite2D")
	anim.play()

func _process(delta):
	if highlighted_last_frame == false:
		int_state = InteractionState.NONE
		label.text = ""
	highlighted_last_frame = false

	if interaction_cooldown_timer > 0.000:
		interaction_cooldown_timer -= delta

func interaction_highlight():
	if int_state == InteractionState.INTERACTED:
		return
	int_state = InteractionState.ENTERED
	highlighted_last_frame = true
	label.text = "Press [Space] to interact"

func interaction():
	if (interaction_cooldown_timer > 0.001):
		return
	interaction_cooldown_timer = interaction_cooldown
	int_state = InteractionState.INTERACTED
	if chest_state == ChestState.CLOSED:
		anim.set_animation("open")
		chest_state = ChestState.OPEN
	else:
		anim.set_animation("close")
		chest_state = ChestState.CLOSED
