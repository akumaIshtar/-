extends Resource

@export var story_dict: Dictionary = {
	0:{
		0:{
			1: {"type": "still",
				"time": 1.0},
			2: {"content": "这是最后一战",
				"type": "text",
				"time": 2.0},
			3: {"type": "still",
				"time": 1.0},
			4: {"content": "决战",
				"type": "text",
				"time": 2.0},
		}
	}
}


@export var init_story_progress: Dictionary = {
	0:{
		"key": true,
		0:{
			"key": true,
			"name": "故事开始",
			"complete": false,
		}
	}
}

func get_init_progress() -> Dictionary:
	return init_story_progress
