extends Node

var game_over_scene = preload("res://game_over_screen.tscn")

signal game_over
signal reset

var score: int = 0
var lock_controls: bool = false

enum State {
	PLAYING,
	DEAD,
}

var game_state: State = State.PLAYING


var game_over_menu: Control = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over.connect(handle_game_over)
	reset.connect(handle_reset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_game_over():
	game_state = State.DEAD
	lock_controls = true
	if not game_over_menu:
		game_over_menu = game_over_scene.instantiate()
		get_tree().root.add_child(game_over_menu)

func handle_reset():
	score = 0
	lock_controls = false
	game_state = State.PLAYING
	game_over_menu.queue_free()
