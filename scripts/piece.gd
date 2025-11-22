extends Area2D

var coord: Vector2i
var grid: Node = null
var color_name: String = "red"
var is_goal: bool = true

@onready var sprite: Sprite2D = $Sprite


func init(c: Vector2i, color_name_: String, g: Node, is_goal_piece := true) -> void:
	coord = c
	color_name = color_name_
	grid = g
	is_goal = is_goal_piece
	update_visual()


func _input_event(viewport, event, shape_idx: int) -> void:
	var is_click := false

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_click = true
	elif event is InputEventScreenTouch and event.pressed:
		is_click = true

	if is_click and grid != null:
		grid.on_piece_clicked(self)


func update_visual() -> void:
	var base_color: Color = get_color_from_name(color_name)

	if is_goal:
		# goal-фишка: чуть светлее и крупнее
		base_color = base_color.lightened(0.3)
		self.scale = Vector2(1.15, 1.15)
	else:
		# обычная "мусорная" фишка
		self.scale = Vector2(1.0, 1.0)

	sprite.modulate = base_color


func get_color_from_name(name: String) -> Color:
	match name:
		"red":
			return Color(1, 0.3, 0.3)
		"blue":
			return Color(0.3, 0.3, 1)
		"green":
			return Color(0.3, 1, 0.3)
		_:
			return Color(0.8, 0.8, 0.8)
