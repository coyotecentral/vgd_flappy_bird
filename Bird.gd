extends RigidBody2D

# In m/s
@export
var jump_velocity = 420.0


# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	Game.reset.connect(handle_reset)
	Game.game_over.connect(handle_game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Freeze the bird on the X axis
	linear_velocity.x = 0
	# Lock the rotation of the bird
	angular_velocity = 0

	if Game.game_state == Game.State.MENU:
		handle_reset()
		if Input.is_action_just_pressed("jump"):
			gravity_scale = 1
			Game.lock_controls = false
			Game.game_state = Game.State.PLAYING
			jump()
	
	if Game.game_state == Game.State.PLAYING:
		if Input.is_action_just_pressed("jump") and not Game.lock_controls:
			jump()
		for b in get_colliding_bodies():
			if b.is_in_group("pipes"):
				Game.game_over.emit()


# Adds velocity to this RigidBody
func jump():
	linear_velocity.y = -jump_velocity

func handle_reset():
	var screen_rect: Rect2 = get_viewport_rect()
	var reset_position = Vector2(
		screen_rect.size.x / 2,
		screen_rect.size.y / 2
	)
	gravity_scale = 0
	global_transform.origin = reset_position

func handle_game_over():
	pass