extends Resource

@export var l: float = 1.3

var nodes: Dictionary = {
	"0001": {
		"type": "Skill",
		"id": "0001",
		"cost": 3,
		"position": Vector2(120, 300) * l,
		"required": ["000003"],
		"unlocked": false,
	},

	"0002": {
		"type": "Skill",
		"id": "0002",
		"cost": 3,
		"position": Vector2(-120, 100) * l,
		"required": ["000004"],
		"unlocked": false,
	},

	"0003": {
		"type": "Skill",
		"id": "0003",
		"cost": 3,
		"position": Vector2(300, -200) * l,
		"required": ["000006"],
		"unlocked": false,
	},

	"0004": {
		"type": "Skill",
		"id": "0004",
		"cost": 3,
		"position": Vector2(300, 0) * l,
		"required": ["000005"],
		"unlocked": false,
	},

	"0005": {
		"type": "Skill",
		"id": "0005",
		"cost": 3,
		"position": Vector2(120, -100) * l,
		"required": ["010004"],
		"unlocked": false,
	},

	"0006": {
		"type": "Skill",
		"id": "0006",
		"cost": 3,
		"position": Vector2(-300, 0) * l,
		"required": ["010005"],
		"unlocked": false,
	},

	"0007": {
		"type": "Skill",
		"id": "0007",
		"cost": 3,
		"position": Vector2(-300, 200) * l,
		"required": ["010006"],
		"unlocked": false,
	},

	"0008": {
		"type": "Skill",
		"id": "0008",
		"cost": 3,
		"position": Vector2(-120, -300) * l,
		"required": ["010003"],
		"unlocked": false,
	},

	"000001": {
		"type": "Attribute",
		"info": {
			"name": "将领勋章",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_3.tres",
			"attribute": {
				"最大生命值": 10,
				"攻击力": 5,
			},
			"description": "属于抵抗军将军的荣誉。"
		},
		"cost": 3,
		"position": Vector2(60, 0) * l,
		"required": [],
		"unlocked": false,
	},

	"000002": {
		"type": "Attribute",
		"info": {
			"name": "酬劳",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_1.tres",
			"attribute": {
				"最大生命值": 5,
			},
			"description": "\"听说你要启程了，将军。\""
		},
		"cost": 1,
		"position": Vector2(120, 100) * l,
		"required": ["000001"],
		"unlocked": false,
	},

	"000003": {
		"type": "Attribute",
		"info": {
			"name": "准备万全",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_8.tres",
			"attribute": {
				"最大生命值": 2,
				"攻击力": 1,
			},
			"description": "..."
		},
		"cost": 1,
		"position": Vector2(60, 200) * l,
		"required": ["000002"],
		"unlocked": false,
	},

	"000004": {
		"type": "Attribute",
		"info": {
			"name": "角斗士",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_5.tres",
			"attribute": {
				"攻击力": 3,
			},
			"description": "\"胜利属于你！\""
		},
		"cost": 2,
		"position": Vector2(-60, 200) * l,
		"required": ["000003"],
		"unlocked": false,
	},

	"000005": {
		"type": "Attribute",
		"info": {
			"name": "活力",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_2.tres",
			"attribute": {
				"最大生命值": 5,
			},
			"description": "..."
		},
		"cost": 1,
		"position": Vector2(240, 100) * l,
		"required": ["000002"],
		"unlocked": false,
	},

	"000006": {
		"type": "Attribute",
		"info": {
			"name": "祭祀",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_4.tres",
			"attribute": {
				"最大法力值": 10,
			},
			"description": "..."
		},
		"cost": 2,
		"position": Vector2(240, -100) * l,
		"required": ["0004"],
		"unlocked": false,
	},

	"010001": {
		"type": "Attribute",
		"info": {
			"name": "永恒",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_9.tres",
			"attribute": {
				"最大魂力值": 20,
			},
			"description": "\"即使我死了，我依然陪着你。\""
		},
		"cost": 3,
		"position": Vector2(-60, 0) * l,
		"required": [],
		"unlocked": false,
	},

	"010002": {
		"type": "Attribute",
		"info": {
			"name": "禁忌之术",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_10.tres",
			"attribute": {
				"魂力强度": 1,
			},
			"description": "\"喝下它...我就能去和他一起战斗了...\""
		},
		"cost": 1,
		"position": Vector2(-120, -100) * l,
		"required": ["010001"],
		"unlocked": false,
	},

	"010003": {
		"type": "Attribute",
		"info": {
			"name": "枯",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_11.tres",
			"attribute": {
				"最大法力值": 5,
			},
			"description": "..."
		},
		"cost": 1,
		"position": Vector2(-60, -200) * l,
		"required": ["010002"],
		"unlocked": false,
	},

	"010004": {
		"type": "Attribute",
		"info": {
			"name": "亡",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_12.tres",
			"attribute": {
				"法力强度": 1,
				"魂力强度": 1,
			},
			"description": "\"我也许是死了？\""
		},
		"cost": 2,
		"position": Vector2(60, -200) * l,
		"required": ["010003"],
		"unlocked": false,
	},

	"010005": {
		"type": "Attribute",
		"info": {
			"name": "灵",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_7.tres",
			"attribute": {
				"魂力强度": 1,
			},
			"description": "..."
		},
		"cost": 1,
		"position": Vector2(-240, -100) * l,
		"required": ["010002"],
		"unlocked": false,
	},

	"010006": {
		"type": "Attribute",
		"info": {
			"name": "奏",
			"texture": "res://Resource/Customize/Skill/AttributeTexture/icon_13.tres",
			"attribute": {
				"最大法力值": 5,
				"法力强度": 1,
				"最大魂力值": 10,
			},
			"description": "最后之舞"
		},
		"cost": 2,
		"position": Vector2(-240, 100) * l,
		"required": ["0006"],
		"unlocked": false,
	},

}
