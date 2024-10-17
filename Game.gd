extends Node

var game_over_scene = preload("res://game_over_screen.tscn")

signal game_over

var score: int = 0
var lock_controls: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	game_over.connect(handle_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_game_over():
	lock_controls = true
	game_over_scene.instantiate()
	get_tree().get_root().add_child(game_over_scene)
