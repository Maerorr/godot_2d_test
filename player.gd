extends CharacterBody2D

enum Direction {
	UP, #0
	DOWN, #1
	LEFT, #2
	RIGHT #3
}

@export var speed: float
@export var interaction_collider_offset: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var look_direction = Direction.DOWN
var key_up = true;
var particles = null

var interaction_collider = null
var def_interaction_collider_position = null
var anim_sprite = null

func _ready():
	anim_sprite = get_node("AnimatedSprite2D")
	anim_sprite.play()
	particles = get_node("Dust")
	interaction_collider = get_node("InteractionCollider")
	def_interaction_collider_position = interaction_collider.position

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_horizontal = Input.get_axis("ui_left", "ui_right")
	var dir_vertical = Input.get_axis("ui_up", "ui_down")

	key_up = true

	if dir_horizontal:
		look_direction = Direction.RIGHT if dir_horizontal == 1 else Direction.LEFT
		velocity.x = dir_horizontal * speed
		key_up = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if dir_vertical:
		look_direction = Direction.DOWN if dir_vertical == 1 else Direction.UP
		velocity.y = dir_vertical * speed
		key_up = false
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()

func _process(_delta):
	handle_movement_and_animation()
	handle_interaction()

func handle_movement_and_animation():
	if key_up:
		idle_animation()
		return

	particles.emitting = true

	anim_sprite.speed_scale = 1.5
	match look_direction:
		Direction.UP:
			interaction_collider.position = def_interaction_collider_position \
											+ Vector2(0, -interaction_collider_offset)
			anim_sprite.animation = "walk_up"
			particles.rotation = 0
		Direction.DOWN:
			interaction_collider.position = def_interaction_collider_position \
											+ Vector2(0, interaction_collider_offset)
			anim_sprite.animation = "walk_down"
			particles.rotation = 180
		Direction.LEFT:
			interaction_collider.position = def_interaction_collider_position \
											+ Vector2(-interaction_collider_offset, 0)
			anim_sprite.animation = "walk_horizontal"
			anim_sprite.flip_h = true
			particles.rotation = 90
		Direction.RIGHT:
			interaction_collider.position = def_interaction_collider_position \
											+ Vector2(interaction_collider_offset, 0)
			anim_sprite.animation = "walk_horizontal"
			anim_sprite.flip_h = false
			particles.rotation = 270
	if velocity.length_squared() < speed:
		idle_animation()

func idle_animation():
	particles.emitting = false
	anim_sprite.speed_scale = 1.0
	match look_direction:
		Direction.UP:
			anim_sprite.animation = "idle_up"
		Direction.DOWN:
			anim_sprite.animation = "idle_down"
		Direction.LEFT:
			anim_sprite.animation = "idle_horizontal"
			anim_sprite.flip_h = true
		Direction.RIGHT:
			anim_sprite.animation = "idle_horizontal"
			anim_sprite.flip_h = false

func handle_interaction():
	var bodies = interaction_collider.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("interaction_highlight"):
			body.interaction_highlight()
		if body.has_method("interaction"):
			if Input.is_action_just_pressed("ui_accept"):
				body.interaction()