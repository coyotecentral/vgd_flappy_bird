extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.text = "Your score:\n%d" % Game.score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
