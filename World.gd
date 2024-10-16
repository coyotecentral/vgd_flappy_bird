# World.gd

extends Node2D

# In m/s
@export
var speed = 69.0

@export
var minimum_pipe_distance: int = 394

var pipe_scene = preload("res://pipe.tscn")
const PIPE_WIDTH = 224
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# this range is not inclusive
	# e.g. this will go 0, 1, 2... 10
	for i in 5: 
		var pipe = pipe_scene.instantiate()
		pipe.position.x = i * minimum_pipe_distance
		add_child(pipe)

func _physics_process(delta):
	# This will allow us to iterate over all
	# them kids
	for p in get_children():
		p.position.x -= speed * delta
		if p.position.x < -PIPE_WIDTH:
			var pipe: Pipe = pipe_scene.instantiate()
			pipe.goal_position = get_random_pipe_position()
			pipe.position.x = get_child_count() * minimum_pipe_distance
			add_child(pipe)
			p.queue_free()

func get_random_pipe_position():
	var y_pos = rng.randi_range(0, 648)
	print(y_pos)
	return y_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
