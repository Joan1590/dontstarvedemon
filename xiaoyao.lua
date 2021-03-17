WAYPOINT = {
	UI = {
		HUD = {
			TOOLTIP = "打开标记菜单"
		},
		MENU = {
			TITLE = "- 标记列表 -"
		},
		BUTTON = {
			TOGGLE_EDITMODE = "编辑模式",
			TOGGLE_INDICATORS = "在屏幕上显示引导",
			TOGGLE_MOVEMENT_PREDICTION = "延迟补偿 开关",

			ADD = "在脚下添加一个标记",

			PREV = "上一页",
			NEXT = "下一页",

			TRAVEL = "走向此处 并向队友发出此坐标",

			MOVE_UP = "删除",
			MOVE_DOWN = "删除",		--这里本来应该是下移，现在改为删除。（已经把上下移的功能都改为删除了）
			TOGGLE_VISIBILITY = "是否可见",
			EDIT = "修改",

			CLOSE = "关闭",
		},
		INDICATOR = {
			BUTTON = {
				PREFIX_TRAVELTO = "走向",
			},
		},
		DIALOG = {
			OPTION = {
				SAVE = "保存",
				CANCEL = "取消",
				OKAY = "Okay",
				DELETE = "Delete",
			},
			EDIT = {
				TITLE = "Modify Waypoint",
				NAME = "名称",
				COORDINATES = "坐标",
				COLOUR = "颜色",
				RANDOMIZE = "Randomize",
			},
			MP = {
				TITLE = "Information",
				MESSAGE1 = "Lag Compensation is NOT predictive, meaning",
				MESSAGE2 = "'movement prediction' is currently disabled!",
				MESSAGE3 = "Due to this, traveling to a waypoint is not possible.",
				MESSAGE4 = "A toggle button is now visible allowing you to toggle",
				MESSAGE5 = "movement prediction in order to use travel.",
			}
		},
	},
}