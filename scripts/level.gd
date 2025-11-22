extends "res://scripts/level_base.gd"

enum LevelKind {
	LEVEL1,
	LEVEL2,
	LEVEL3,
	LEVEL4
}

# --- УРОВЕНЬ 1: базовый, R = 2, мало фишек, много пустоты ---
const PUZZLES_LEVEL1 = [
	{
		"radius": 2,
		"pieces": [
			{"q": -1, "r": 0, "color": "red"}
		],
		"exits": [
			{"q": 2, "r": -1, "color": "red"}
		],
		"blocks": []
	},
	{
		"radius": 2,
		"pieces": [
			{"q": -1, "r": 0, "color": "red"},
			{"q": 0, "r": 1, "color": "blue"}
		],
		"exits": [
			{"q": 2, "r": -1, "color": "red"},
			{"q": -2, "r": 1, "color": "blue"}
		],
		"blocks": []
	},
	{
		"radius": 2,
		"pieces": [
			{"q": -1, "r": 1, "color": "red"},
			{"q": 1, "r": -1, "color": "blue"}
		],
		"exits": [
			{"q": 1, "r": -2, "color": "red"},
			{"q": -1, "r": 2, "color": "blue"}
		],
		"blocks": []
	},
	{
		"radius": 2,
		"pieces": [
			{"q": 0, "r": -1, "color": "red"},
			{"q": 0, "r": 1, "color": "blue"}
		],
		"exits": [
			{"q": -2, "r": 0, "color": "red"},
			{"q": 2, "r": 0, "color": "blue"}
		],
		"blocks": []
	}
]

# --- УРОВЕНЬ 2: R = 3, 3 цвета + блоки (как у тебя уже было) ---
const PUZZLES_LEVEL2 = [
	{
		"radius": 3,
		"pieces": [
			{"q": -1, "r": 0, "color": "red"},
			{"q": 0, "r": 1, "color": "blue"},
			{"q": 1, "r": 1, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": 0, "color": "red"},
			{"q": -3, "r": 1, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0}
		]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": -2, "r": 1, "color": "red"},
			{"q": 1, "r": -1, "color": "blue"},
			{"q": 0, "r": 2, "color": "green"}
		],
		"exits": [
			{"q": 2, "r": -2, "color": "red"},
			{"q": -2, "r": 2, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [
			{"q": -1, "r": 0},
			{"q": 1, "r": 0},
			{"q": 0, "r": 1}
		]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": -1, "r": -1, "color": "red"},
			{"q": 1, "r": 0, "color": "blue"},
			{"q": 0, "r": 1, "color": "green"}
		],
		"exits": [
			{"q": -3, "r": 0, "color": "red"},
			{"q": 3, "r": -1, "color": "blue"},
			{"q": 0, "r": 3, "color": "green"}
		],
		"blocks": [
			{"q": 0, "r": -1},
			{"q": 1, "r": -1},
			{"q": -1, "r": 1}
		]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": -2, "r": 0, "color": "red"},
			{"q": 0, "r": 2, "color": "blue"},
			{"q": 2, "r": -2, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": -1, "color": "red"},
			{"q": -3, "r": 1, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [
			{"q": -1, "r": 0},
			{"q": 1, "r": 0},
			{"q": 0, "r": 1},
			{"q": 0, "r": -1}
		]
	}
]

# --- УРОВЕНЬ 3: R = 3, почти всё поле забито фишками (auto_fill) ---
# свободных клеток немного (ядро вокруг центра)
const PUZZLES_LEVEL3 = [
	{
		"radius": 3,
		"pieces": [
			{"q": -2, "r": 0, "color": "red"},
			{"q": 2, "r": -1, "color": "blue"},
			{"q": 0, "r": 2, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": 0, "color": "red"},
			{"q": -3, "r": 0, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [],
		"auto_fill": true,
		"auto_fill_goal_all": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": -2, "r": 1, "color": "red"},
			{"q": 2, "r": -2, "color": "blue"},
			{"q": 1, "r": 2, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": 0, "color": "red"},
			{"q": -3, "r": 0, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": -1, "r": -2, "color": "red"},
			{"q": 1, "r": -1, "color": "blue"},
			{"q": 2, "r": 1, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": 0, "color": "red"},
			{"q": -3, "r": 0, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 3,
		"pieces": [
			{"q": 0, "r": -2, "color": "red"},
			{"q": 0, "r": 2, "color": "blue"},
			{"q": 2, "r": 0, "color": "green"}
		],
		"exits": [
			{"q": 3, "r": 0, "color": "red"},
			{"q": -3, "r": 0, "color": "blue"},
			{"q": 0, "r": -3, "color": "green"}
		],
		"blocks": [],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	}
]

# --- УРОВЕНЬ 4: R = 4, максимальная плотность + блоки ---
# поле ещё больше, почти всё забито фишками, свободное ядро + блок-камни
const PUZZLES_LEVEL4 = [
	{
		"radius": 4,
		"pieces": [
			{"q": -3, "r": 0, "color": "red"},
			{"q": 2, "r": 1, "color": "blue"},
			{"q": 1, "r": 3, "color": "green"}
		],
		"exits": [
			{"q": 4, "r": 0, "color": "red"},
			{"q": -4, "r": 0, "color": "blue"},
			{"q": 0, "r": -4, "color": "green"}
		],
		"blocks": [
			{"q": 0, "r": 2},
			{"q": 1, "r": 1}
		],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 4,
		"pieces": [
			{"q": -2, "r": 2, "color": "red"},
			{"q": 3, "r": -1, "color": "blue"},
			{"q": 0, "r": 3, "color": "green"}
		],
		"exits": [
			{"q": 4, "r": 0, "color": "red"},
			{"q": -4, "r": 0, "color": "blue"},
			{"q": 0, "r": -4, "color": "green"}
		],
		"blocks": [
			{"q": 0, "r": -2},
			{"q": -1, "r": 1},
			{"q": 2, "r": 0}
		],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 4,
		"pieces": [
			{"q": -3, "r": 1, "color": "red"},
			{"q": 2, "r": -2, "color": "blue"},
			{"q": 1, "r": 2, "color": "green"}
		],
		"exits": [
			{"q": 4, "r": 0, "color": "red"},
			{"q": -4, "r": 0, "color": "blue"},
			{"q": 0, "r": -4, "color": "green"}
		],
		"blocks": [
			{"q": 1, "r": 0},
			{"q": 0, "r": -1},
			{"q": -1, "r": 2}
		],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	},
	{
		"radius": 4,
		"pieces": [
			{"q": -2, "r": -1, "color": "red"},
			{"q": 3, "r": 0, "color": "blue"},
			{"q": 0, "r": 2, "color": "green"}
		],
		"exits": [
			{"q": 4, "r": 0, "color": "red"},
			{"q": -4, "r": 0, "color": "blue"},
			{"q": 0, "r": -4, "color": "green"}
		],
		"blocks": [
			{"q": 0, "r": 1},
			{"q": 1, "r": 1},
			{"q": -1, "r": 0}
		],
		"auto_fill": true,
		"empty_cells": [
			{"q": 0, "r": 0},
			{"q": 1, "r": 0},
			{"q": 1, "r": -1},
			{"q": 0, "r": -1},
			{"q": -1, "r": 0},
			{"q": -1, "r": 1},
			{"q": 0, "r": 1}
		],
		"fill_colors": ["red", "blue", "green"]
	}
]

# --- Конфигурация уровней ---
const LEVEL_CONFIG = {
	LevelKind.LEVEL1: {
		"name": "Уровень 1: базовый",
		"puzzles": PUZZLES_LEVEL1,
		"required_score": 250,
		"max_puzzle_time": 30.0,
		"base_reward": 100,
		"difficulty_multiplier": 1.0,
		"max_moves": 7
	},
	LevelKind.LEVEL2: {
		"name": "Уровень 2: препятствия",
		"puzzles": PUZZLES_LEVEL2,
		"required_score": 350,
		"max_puzzle_time": 30.0,
		"base_reward": 110,
		"difficulty_multiplier": 1.2,
		"max_moves": 12
	},
	LevelKind.LEVEL3: {
		"name": "Уровень 3: плотное поле",
		"puzzles": PUZZLES_LEVEL3,
		"required_score": 450,
		"max_puzzle_time": 60.0,
		"base_reward": 120,
		"difficulty_multiplier": 1.4,
		"max_moves": 150
	},
	LevelKind.LEVEL4: {
		"name": "Уровень 4: максимум плотности",
		"puzzles": PUZZLES_LEVEL4,
		"required_score": 550,
		"max_puzzle_time": 120.0,
		"base_reward": 130,
		"difficulty_multiplier": 1.7,
		"max_moves": 150
	}
}

var _initialized = false
var _kind = LevelKind.LEVEL1


func _ready() -> void:
	# Ждём setup_level, чтобы знать, какой конфиг применять
	if _initialized:
		super._ready()


func setup_level(kind: int) -> void:
	_kind = kind

	if not LEVEL_CONFIG.has(kind):
		push_error("Unknown level kind: %s" % [str(kind)])
		return

	var cfg = LEVEL_CONFIG[kind]

	level_name = String(cfg.get("name", "Уровень"))
	puzzles = cfg.get("puzzles", [])

	required_score = int(cfg.get("required_score", 0))
	max_puzzle_time = float(cfg.get("max_puzzle_time", 30.0))
	base_reward = int(cfg.get("base_reward", 100))
	difficulty_multiplier = float(cfg.get("difficulty_multiplier", 1.0))
	max_moves = int(cfg.get("max_moves", 0))

	_initialized = true
	super._ready()



static func get_level_definitions() -> Array:
	var defs: Array = []
	for kind in LEVEL_CONFIG.keys():
		var cfg: Dictionary = LEVEL_CONFIG[kind]
		defs.append({
			"kind": kind,
			"title": String(cfg.get("name", "Уровень")),
			"required_score": int(cfg.get("required_score", 0)),
			"max_puzzle_time": float(cfg.get("max_puzzle_time", 30.0))
		})
	return defs
