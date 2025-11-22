extends Node2D

signal puzzle_solved

const NEIGHBORS = [
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, 1)
]

@export var cell_scene: PackedScene = preload("res://Scenes/Cell.tscn")
@export var piece_scene: PackedScene = preload("res://Scenes/Piece.tscn")

var radius = 2
var cells = {}        # coord (Vector2i) -> Cell
var occupied = {}     # coord -> Piece
var exits = {}        # coord -> color_name
var pieces = []       # все фишки
var goal_pieces_left = 0  # сколько целевых фишек осталось вывести

var active_piece = null
var active_reachable = []
var owner_level = null
var is_moving = false


func setup_puzzle(puzzle: Dictionary, level: Node) -> void:
	owner_level = level
	clear_grid()

	radius = int(puzzle.get("radius", 2))
	build_cells()

	exits.clear()

	# блок-камни
	var blocks = puzzle.get("blocks", [])
	for block in blocks:
		var coord_block = Vector2i(int(block["q"]), int(block["r"]))
		if cells.has(coord_block):
			var cell_block = cells[coord_block]
			cell_block.set_blocked(true)

	# выходы
	var exit_defs = puzzle.get("exits", [])
	for e in exit_defs:
		var coord_exit = Vector2i(int(e["q"]), int(e["r"]))
		var color_exit = String(e["color"])
		exits[coord_exit] = color_exit
		if cells.has(coord_exit):
			var cell_exit = cells[coord_exit]
			cell_exit.set_exit(color_exit)

	pieces.clear()
	occupied.clear()
	goal_pieces_left = 0

	# целевые фишки из списка pieces
	var piece_defs = puzzle.get("pieces", [])
	for p in piece_defs:
		var coord_piece = Vector2i(int(p["q"]), int(p["r"]))
		var color_piece = String(p["color"])
		spawn_piece(coord_piece, color_piece, true)

		# auto_fill — заполнение оставшихся клеток фишками
	var auto_fill = bool(puzzle.get("auto_fill", false))
	if auto_fill:
		var fill_colors = puzzle.get("fill_colors", [])
		if fill_colors.is_empty():
			fill_colors = ["red", "blue", "green"]

		# все зафиленные фишки goal или нет — определяется флагом
		var auto_fill_goal_all = bool(puzzle.get("auto_fill_goal_all", false))

		var empties_array = puzzle.get("empty_cells", [])
		var empty_set = {}

		for ecell in empties_array:
			var ec = Vector2i(int(ecell["q"]), int(ecell["r"]))
			empty_set[ec] = true

		var idx_color = 0
		for coord in cells.keys():
			var cell = cells[coord]
			if cell.is_blocked:
				continue
			if exits.has(coord):
				continue
			if occupied.has(coord):
				continue
			if empty_set.has(coord):
				continue

			var cname = String(fill_colors[idx_color % fill_colors.size()])
			spawn_piece(coord, cname, auto_fill_goal_all)
			idx_color += 1


	active_piece = null
	active_reachable.clear()
	update_reachable_cells()


func clear_grid() -> void:
	for c in cells.values():
		c.queue_free()
	cells.clear()

	for p in pieces:
		p.queue_free()
	pieces.clear()
	occupied.clear()
	exits.clear()
	goal_pieces_left = 0


func build_cells() -> void:
	for q in range(-radius, radius + 1):
		for r in range(-radius, radius + 1):
			if cube_distance(q, r) <= radius:
				var coord = Vector2i(q, r)
				var cell = cell_scene.instantiate()
				add_child(cell)
				cell.position = axial_to_world(coord)
				cell.init(coord, self)
				cells[coord] = cell


func cube_distance(q: int, r: int) -> int:
	var x = q
	var z = r
	var y = -x - z
	var a = abs(x)
	var b = abs(y)
	var c = abs(z)
	return max(max(a, b), c)


func axial_to_world(coord: Vector2i) -> Vector2:
	var size = 40.0
	var q = float(coord.x)
	var r = float(coord.y)
	var x = size * sqrt(3.0) * (q + r / 2.0)
	var y = size * 1.5 * r
	return Vector2(x, y)


func spawn_piece(coord: Vector2i, color_name: String, is_goal: bool) -> void:
	if not cells.has(coord):
		push_warning("Trying to spawn piece outside grid at %s" % [coord])
		return

	var piece = piece_scene.instantiate()
	add_child(piece)
	piece.position = axial_to_world(coord)
	piece.init(coord, color_name, self, is_goal)

	pieces.append(piece)
	occupied[coord] = piece

	if is_goal:
		goal_pieces_left += 1


func on_piece_clicked(piece: Node) -> void:
	if is_moving:
		return
	if owner_level == null:
		return
	if not owner_level.puzzle_active:
		return

	active_piece = piece
	active_reachable = get_reachable_from(piece.coord)
	update_reachable_cells()


func on_cell_clicked(cell: Node) -> void:
	if is_moving:
		return
	if active_piece == null:
		return

	var coord = cell.coord
	if coord in active_reachable:
		move_active_piece_to(coord)


func get_reachable_from(start: Vector2i) -> Array:
	var reachable = []
	var visited = {}
	var queue = []

	visited[start] = true
	queue.push_back(start)

	while queue.size() > 0:
		var current = queue.pop_front()
		for d in NEIGHBORS:
			var nxt = current + d
			if not cells.has(nxt):
				continue

			var cell = cells[nxt]
			if cell.is_blocked:
				continue
			if occupied.has(nxt):
				continue
			if visited.has(nxt):
				continue

			visited[nxt] = true
			reachable.append(nxt)
			queue.push_back(nxt)

	reachable.erase(start)
	return reachable


func update_reachable_cells() -> void:
	for c in cells.values():
		c.set_reachable(false)
		c.set_hint(false)

	for coord in active_reachable:
		if cells.has(coord):
			var cell = cells[coord]
			cell.set_reachable(true)


func move_active_piece_to(target: Vector2i) -> void:
	if active_piece == null:
		return
	if is_moving:
		return

	var path = find_path(active_piece.coord, target)
	if path.is_empty():
		return

	is_moving = true
	occupied.erase(active_piece.coord)

	var tween = create_tween()
	for coord in path:
		var pos = axial_to_world(coord)
		tween.tween_property(active_piece, "position", pos, 0.12)

	await tween.finished

	active_piece.coord = target
	occupied[target] = active_piece
	is_moving = false

	handle_piece_arrived(active_piece)

	if owner_level != null and owner_level.has_method("on_move_made"):
		owner_level.on_move_made()

	active_reachable.clear()
	update_reachable_cells()



func find_path(start: Vector2i, goal: Vector2i) -> Array:
	if start == goal:
		return []

	var queue = []
	var parents = {}

	queue.push_back(start)
	parents[start] = null

	while queue.size() > 0:
		var current = queue.pop_front()
		for d in NEIGHBORS:
			var nxt = current + d
			if not cells.has(nxt):
				continue

			var cell = cells[nxt]
			if cell.is_blocked:
				continue

			if occupied.has(nxt) and nxt != goal:
				continue

			if parents.has(nxt):
				continue

			parents[nxt] = current

			if nxt == goal:
				var path = []
				var c = goal
				while c != start:
					path.push_front(c)
					c = parents[c]
				return path

			queue.push_back(nxt)

	return []


func handle_piece_arrived(piece: Node) -> void:
	var coord = piece.coord
	if exits.has(coord):
		var exit_color = exits[coord]
		if exit_color == piece.color_name:
			if owner_level != null:
				owner_level.on_piece_exited_correctly()

			occupied.erase(coord)
			pieces.erase(piece)
			if piece.is_goal:
				goal_pieces_left -= 1

			piece.queue_free()

			if goal_pieces_left <= 0:
				puzzle_solved.emit()
		else:
			if owner_level != null:
				owner_level.on_piece_wrong_exit(piece, exit_color)


func show_hint_for_current_puzzle() -> void:
	for c in cells.values():
		c.set_hint(false)

	for coord in exits.keys():
		if cells.has(coord):
			var cell = cells[coord]
			cell.set_hint(true)
