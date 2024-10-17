# World.gd

extends Node2D

# In m/s
@export
var speed = 69.0
var _current_speed = 69.0

@export
var minimum_pipe_distance: float = Pipe.CHUNK_SIZE * 4

var pipe_scene = preload("res://pipe.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.reset.connect(handle_reset)
	# this range is not inclusive
	# e.g. this will go 0, 1, 2... 10
	var starting_point = get_viewport_rect().size.x
	for i in 5: 
		var spawn_point = starting_point + (i * minimum_pipe_distance)
		spawn_pipe(spawn_point)

func _physics_process(delta):
	# This will allow us to iterate over all
	# them kids
	if not Game.lock_controls:
		for p in get_children():
			p.position.x -= speed * delta
			if p.position.x < -Pipe.CHUNK_SIZE:
				spawn_pipe(get_child_count() * minimum_pipe_distance)
				p.queue_free()

func get_random_pipe_position():
	var y_pos = rng.randi_range(0, 648)
	print(y_pos)
	return y_pos

func handle_reset():
	for p in get_children():
		p.queue_free()
	for i in 5:
		var starting_point = get_viewport_rect().size.x
		var spawn_point = starting_point + (i * minimum_pipe_distance)
		spawn_pipe(spawn_point)


func spawn_pipe(x_pos: float):
	var pipe: Pipe = pipe_scene.instantiate()
	pipe.goal_position = get_random_pipe_position()
	pipe.position.x = x_pos
	add_child(pipe)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
