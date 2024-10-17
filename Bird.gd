extends RigidBody2D

# In m/s
@export
var jump_velocity = 420.0


# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Freeze the bird on the X axis
	linear_velocity.x = 0
	# Lock the rotation of the bird
	angular_velocity = 0
	if Input.is_action_just_pressed("jump") and not Game.lock_controls:
		jump()
	
	for b in get_colliding_bodies():
		if b.is_in_group("pipes"):
			Game.game_over.emit()


# Adds velocity to this RigidBody
func jump():
	linear_velocity.y = -jump_velocity