extends Camera2D

var player = null
@export var camera_offset = Vector2(0, 0)
@export var smoothing_factor = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("Root/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		if player.velocity.x > 1:
			offset.x = lerp(offset.x, camera_offset.x, delta * smoothing_factor);
		elif player.velocity.x < -1:
			offset.x = lerp(offset.x, -camera_offset.x, delta * smoothing_factor);
		else:
			offset.x = lerp(offset.x, 0.0, delta * 3.0 * smoothing_factor);

		if player.velocity.y > 1:
			offset.y = lerp(offset.y, camera_offset.y, delta * smoothing_factor);
		elif player.velocity.y < -1:
			offset.y = lerp(offset.y, -camera_offset.y, delta * smoothing_factor);
		else:
			offset.y = lerp(offset.y, 0.0, delta * 3.0 * smoothing_factor);

		position = player.position
	pass
