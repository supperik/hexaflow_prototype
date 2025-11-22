extends Control

const LEVEL_SCENE = preload("res://Scenes/Level.tscn")
const LEVEL_SCRIPT = preload("res://scripts/level.gd")

var current_level = null
var last_kind = 0
var last_level_title = ""
var last_success = false
var last_score = 0
var last_required_score = 0
var level_defs = []

@onready var main_menu: Control = $"."
@onready var menu_panel: Control = $MenuPanel
@onready var level_root: Node = $LevelRoot

@onready var levels_list: VBoxContainer = $MenuPanel/CenterContainer/VBoxContainer/LevelsList

@onready var game_over_layer: CanvasLayer = $GameOverLayer
@onready var game_over_label: Label = $GameOverLayer/GameOverPanel/VBoxContainer/GameOverLabel
@onready var restart_button: Button = $GameOverLayer/GameOverPanel/VBoxContainer/RestartButton
@onready var back_to_menu_button: Button = $GameOverLayer/GameOverPanel/VBoxContainer/BackToMenuButton

#var mainmenu_level_button_scene: PackedScene = preload("res://Scenes/MainMenuLevelButton.tscn")


func _ready() -> void:
	# На старте показываем меню
	menu_panel.visible = true
	game_over_layer.visible = false

	level_defs = LEVEL_SCRIPT.get_level_definitions()
	for def in level_defs:
		var btn: Button = Button.new()
		#mainmenu_level_button_scene.instantiate()
		#var mainmenu_level_button = mainmenu_level_button_scene.get(".")
		var title = String(def.get("title", "Уровень"))
		var kind = int(def.get("kind", 0))

		btn.text = title
		btn.focus_mode = Control.FOCUS_NONE
		btn.pressed.connect(func():
			start_level(kind)
		)

		levels_list.add_child(btn)

	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	back_to_menu_button.connect("pressed", Callable(self, "_on_back_to_menu_button_pressed"))


func start_level(kind: int) -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null

	var inst = LEVEL_SCENE.instantiate()
	level_root.add_child(inst)

	current_level = inst
	last_kind = kind
	last_level_title = _get_level_title(kind)

	main_menu.visible = false
	game_over_layer.visible = false

	# Настраиваем уровень
	inst.setup_level(kind)

	if inst.has_signal("level_finished"):
		inst.connect("level_finished", Callable(self, "_on_level_finished"))
	else:
		push_warning("Level scene does not have 'level_finished' signal")



func _get_level_title(kind: int) -> String:
	for def in level_defs:
		if int(def.get("kind", -1)) == kind:
			return String(def.get("title", "Уровень"))
	return "Уровень"
	

func _on_level_finished(success: bool, score: int, required_score: int) -> void:
	last_success = success
	last_score = score
	last_required_score = required_score
	
	game_over_layer.visible = true

	# Можно различать завершение 1 и 2 уровня
	if success:
		game_over_label.text = "%s пройден!\nОчки: %d" % [last_level_title, score]
	else:
		if required_score > 0:
			game_over_label.text = "%s не пройден.\nНужно: %d, набрано: %d" % [
				last_level_title, required_score, score
			]
		else:
			game_over_label.text = "%s завершён.\nОчки: %d" % [last_level_title, score]


func _on_restart_button_pressed() -> void:
	start_level(last_kind)


func _on_back_to_menu_button_pressed() -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null

	game_over_layer.visible = false
	main_menu.visible = true
