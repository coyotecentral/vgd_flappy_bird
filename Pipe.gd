@tool
extends Node2D
class_name Pipe

@onready
var gap_goal: Area2D = $GoalArea

@onready
var upper_pipe: StaticBody2D = $UpperPipe

@onready
var lower_pipe: StaticBody2D = $LowerPipe

@export
var goal_size: int = 200

@export
var goal_position: int = 648 / 2

var SCREEN_HEIGHT: float = ProjectSettings.get_setting("display/window/size/viewport_height")
const CHUNK_SIZE = 128

func adjust_sizes():
	#Check if this is an actual node
	if gap_goal:
		var rect = get_collider_shape(gap_goal)
		rect.size = Vector2(CHUNK_SIZE / 4, goal_size)
		var top_distance: int = goal_position - (goal_size / 2.0)
		if top_distance < 0:
			gap_goal.position.y = goal_size / 2.0
			gap_goal.position.y = CHUNK_SIZE - (CHUNK_SIZE / 4)
		else:
			gap_goal.position.y = goal_position

		var bottom_distance: int = SCREEN_HEIGHT - (gap_goal.position.y + (goal_size / 2.0))
		if bottom_distance < 0:
			gap_goal.position.y = SCREEN_HEIGHT - goal_size / 2.0
	# Resize the upper_pipe shape to fit the gap
	if gap_goal and upper_pipe:
		var top_distance: int = gap_goal.position.y - (goal_size / 2.0)
		var rect = get_collider_shape(upper_pipe)
		if top_distance > 0:
			rect.size = Vector2(CHUNK_SIZE, top_distance)
			upper_pipe.position.y = top_distance / 2.0
		else:
			rect.size.y = 0
			upper_pipe.position.y = 0
		var color_rect: ColorRect = upper_pipe.get_child(1)
		color_rect.size = rect.size
		color_rect.position = Vector2(
			-round(rect.size.x / 2.0),
			-round(rect.size.y / 2.0)
		)
	if gap_goal and lower_pipe:
			var bottom_distance: float = SCREEN_HEIGHT - (gap_goal.position.y + (goal_size / 2.0))
			var rect = get_collider_shape(lower_pipe)
			if bottom_distance > 0:
				rect.size = Vector2(CHUNK_SIZE, bottom_distance)
			else:
				rect.size.y = 0
			lower_pipe.position.y = SCREEN_HEIGHT - (rect.size.y / 2.0)
			var color_rect: ColorRect = lower_pipe.get_child(1)
			color_rect.size = rect.size
			color_rect.position = Vector2(
						-round(rect.size.x / 2.0),
						-round(rect.size.y / 2.0)
					)

# Called when the node enters the scene tree for the first time.
func _ready():
	adjust_sizes()
	$GoalArea.body_entered.connect(handle_body_entered)
	lower_pipe.add_to_group("pipes")
	upper_pipe.add_to_group("pipes")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# This will run in the editor
	if Engine.is_editor_hint():
		adjust_sizes()

# Expect `body_or_area` to be Area2D, StaticBody2D, or RigidBody2D
func get_collider_shape(body_or_area) -> RectangleShape2D:
	# We can assume that the CollisionShape2D will always
	# be the 1st child of our body or area, because of the way
	# it is structured in our scene tree.
	# Order is guaranteed by `get_child`
	var collider: CollisionShape2D  = body_or_area.get_child(0)
	var shape = collider.shape
	assert(shape is RectangleShape2D)
	return shape

func handle_body_entered(_body: Node2D):
	Game.score += 1