extends Area2D

var coord: Vector2i
var grid: Node = null
var is_blocked = false
var is_exit = false
var exit_color = ""
var is_reachable = false
var is_hint = false

@onready var sprite: Sprite2D = $Sprite


func init(c: Vector2i, g: Node) -> void:
	coord = c
	grid = g
	is_blocked = false
	is_exit = false
	exit_color = ""
	is_reachable = false
	is_hint = false
	update_visual()


func set_blocked(flag: bool) -> void:
	is_blocked = flag
	update_visual()


func set_exit(color_name: String) -> void:
	is_exit = true
	exit_color = color_name
	update_visual()


func set_reachable(flag: bool) -> void:
	is_reachable = flag
	update_visual()


func set_hint(flag: bool) -> void:
	is_hint = flag
	update_visual()


func _input_event(viewport, event, shape_idx: int) -> void:
	var is_click := false

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_click = true
	elif event is InputEventScreenTouch and event.pressed:
		is_click = true

	if is_click:
		print("Cell clicked at coord: ", coord)
		if grid != null:
			grid.on_cell_clicked(self)



func update_visual() -> void:
	var base_color = Color(0.7, 0.7, 0.7)
	if is_blocked:
		base_color = Color(0.2, 0.2, 0.2)
	elif is_exit:
		base_color = get_color_from_name(exit_color)

	if is_reachable:
		base_color = base_color.lightened(0.3)

	if is_hint:
		base_color = Color(1.0, 1.0, 0.4)

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
			return Color(0.7, 0.7, 0.7)
