extends Node2D

signal level_finished(success: bool, score: int, required_score: int)

const DEFAULT_MAX_PUZZLE_TIME = 30.0

var puzzles = []
var current_puzzle_index = -1
var puzzle_elapsed = 0.0
var puzzle_active = false
var score = 0
var puzzle_times = []

var level_name = "Уровень"

var max_puzzle_time = DEFAULT_MAX_PUZZLE_TIME
var base_reward = 100
var difficulty_multiplier = 1.0
var required_score = 0

# --- новое: лимит ходов ---
var moves_used = 0
var max_moves = 0
var level_over = false

@onready var grid = $HexGrid
@onready var label_task: Label = $UI/HBoxContainer/TaskLabel
@onready var label_timer: Label = $UI/HBoxContainer/TimerLabel
@onready var label_score: Label = $UI/HBoxContainer/ScoreLabel
@onready var label_message: Label = $UI/HBoxContainer/MessageLabel
@onready var label_moves: Label = $UI/HBoxContainer/MovesLabel


func _ready() -> void:
	if grid != null and grid.has_signal("puzzle_solved"):
		grid.connect("puzzle_solved", Callable(self, "on_puzzle_solved"))
	else:
		push_error("HexGrid node or signal 'puzzle_solved' not found")

	moves_used = 0
	level_over = false
	update_score_label()
	update_moves_label()
	start_next_puzzle()


func _process(delta: float) -> void:
	if level_over:
		return

	if puzzle_active:
		puzzle_elapsed += delta
		var remaining = max_puzzle_time - puzzle_elapsed
		if remaining < 0.0:
			remaining = 0.0
		label_timer.text = "Время: %.1f c" % remaining

		if puzzle_elapsed >= max_puzzle_time:
			on_puzzle_timeout()


func start_next_puzzle() -> void:
	if level_over:
		return

	current_puzzle_index += 1
	label_message.text = ""

	# если задач больше нет — подводим итоги уровня
	if current_puzzle_index >= puzzles.size():
		puzzle_active = false

		var success = true
		if required_score > 0 and score < required_score:
			success = false
		if max_moves > 0 and moves_used > max_moves:
			success = false

		if success:
			label_task.text = "%s завершён! Очки: %d" % [level_name, score]
		else:
			var msg = "%s не пройден.\n" % level_name
			if required_score > 0:
				msg += "Нужно очков: %d, набрано: %d.\n" % [required_score, score]
			if max_moves > 0:
				msg += "Лимит ходов: %d, использовано: %d." % [max_moves, moves_used]
			label_task.text = msg

		print("%s — времена задач:" % level_name, puzzle_times)
		level_over = true
		level_finished.emit(success, score, required_score)
		return

	var puzzle: Dictionary = puzzles[current_puzzle_index]
	label_task.text = "%s — задача %d / %d" % [
		level_name,
		current_puzzle_index + 1,
		puzzles.size()
	]

	puzzle_elapsed = 0.0
	puzzle_active = true

	grid.setup_puzzle(puzzle, self)
	update_score_label()
	update_moves_label()


func update_score_label() -> void:
	if label_score != null:
		label_score.text = "Очки: %d" % score


func update_moves_label() -> void:
	if label_moves == null:
		return
	if max_moves > 0:
		label_moves.text = "Ходы: %d / %d" % [moves_used, max_moves]
	else:
		label_moves.text = "Ходы: %d" % moves_used


func compute_reward(success: bool) -> int:
	if not success:
		return 0
	var time_bonus = int(max(0.0, (max_puzzle_time - puzzle_elapsed) * 2.0 * difficulty_multiplier))
	var base_value = int(float(base_reward) * difficulty_multiplier)
	return base_value + time_bonus


func on_puzzle_solved() -> void:
	if level_over or not puzzle_active:
		return

	puzzle_active = false
	puzzle_times.append(puzzle_elapsed)

	var reward = compute_reward(true)
	score += reward
	update_score_label()

	label_message.text = "Решение верно! +%d очков" % reward

	await get_tree().create_timer(1.0).timeout
	start_next_puzzle()


func on_puzzle_timeout() -> void:
	if level_over or not puzzle_active:
		return

	puzzle_active = false
	puzzle_times.append(puzzle_elapsed)

	label_message.text = "Решение неверно: время вышло :("
	update_score_label()

	grid.show_hint_for_current_puzzle()

	await get_tree().create_timer(1.5).timeout
	start_next_puzzle()


func on_piece_exited_correctly() -> void:
	label_message.text = "Фишка доставлена в правильный выход!"


func on_piece_wrong_exit(piece, exit_color: String) -> void:
	label_message.text = "Неверный выход: это %s, а фишка %s" % [
		exit_color, piece.color_name
	]


# --- новое: регистрация хода ---
func on_move_made() -> void:
	if level_over:
		return

	moves_used += 1
	update_moves_label()

	if max_moves > 0 and moves_used > max_moves:
		# уровень провален по лимиту ходов
		level_over = true
		puzzle_active = false

		label_message.text = "Превышен лимит ходов :("

		var msg = "%s не пройден.\n" % level_name
		if required_score > 0:
			msg += "Нужно очков: %d, набрано: %d.\n" % [required_score, score]
		msg += "Лимит ходов: %d, использовано: %d." % [max_moves, moves_used]
		label_task.text = msg

		level_finished.emit(false, score, required_score)
