name = "The little demon by Yoa"
version = "1.0"
description = "The little demon versión: " .. version .. " by Yoa\n" .. [[
[This is a compilation mod from others authors]
I only google translate xD this for know what to do this mod.

The own of this mod is: https://steamcommunity.com/id/QueenYao

The picture is my picture~
This is a gift to support my little cute~
This is a gift of friendship, representing my love for Dont Starve~
Because of this love of Dont Starve, the strongest support was born! ~
[Module Function]
It has very powerful content, original functions and reference functions~
The list of modules is shown below:
thank:
班花、封锁、Tony、surg、sauktux、CossonWool
呼吸、老王、rezecib、kiopho、Marilyth、lifeking
毁掉一首歌、Nathalia、07×23、lvanX、adai1198
opinion:
  Say goodbye to Grief, Banhua, Tony (Thanks for making suggestions for the module)
platform:
 Steam					-------------------施工者：萌萌哒女王Yao~
]]
author = "可爱的小萌萌吖~"

forumthread = ""
api_version = 10
priority = -999999
icon_atlas = "modicon.xml"
icon = "modicon.tex"
shipwrecked_compatible = false
-- version_compatible="1.0.0"
server_filter_tags = {}
client_only_mod = true
all_clients_require_mod = false
server_only_mod = false
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

folder_name = folder_name or "QueenYao"
if not folder_name:find("workshop-") then
	name = name .. " -dev"
end

local function AddConfig(name, label, hover, options, default)
	return {
		name = name,
		label = label,
		hover = hover,
		options = options,
		default = default,
	}
end
local function AddEmptySeperator(seperator)
	return {
		name = "",
		label = seperator,
		hover = "",
		options = {
			{ description = "", data = 0 },
		},
		default = 0,

	}
end

local function CreatTitle(_name)
	return {
		name = _name,
		hover = "",
		options = {
			{ description = "", data = 0 },
		},
		default = 0,
	}
end

local gridlist = {
	{ description = "3x3", data = "3x3" },
	{ description = "4x4", data = "4x4" },
}

local valuelist = {}
for i = 1, 256 do
	valuelist[i] = { description = i - 1, data = i - 1 }
end

server_filter_tags = { "" }

MarginValues = {}
for i = 1, 101 do
	MarginValues[i] = { description = "" .. (i - 1) * 10, data = ((i - 1) * 10) }
end

local yOffsets = {}
for i = 6, 30 do
	yOffsets[i - 5] = {
		description = (i * 10),
		data = i * 10,
		hover = i == 6 and "If “Backpack Layout“ is disabled, it is located above your inventory. " or i == 10 and "If “Backpack Layout“ is enabled, it is located above your inventory." or i == 11 and "If the “backpack layout“ is enabled, leave a little space above your inventory. " or "",
	}
end

local alpha = {}
for i = 0, 20 do
	alpha[i + 1] = {
		description = (i * 5) .. "%",
		data = (100 - i * 5),
		hover = i == 5 and "standard" or i == 20 and "hide" or "",
	}
end

ScaleValues = {}
for i = 1, 15 do
	ScaleValues[i] = { description = "" .. (i / 10), data = (i / 10) }
end
local horizontal_margin_options = {}
local vertical_margin_options = {}

-- 64 - RESOLUTION_X/2 = 640
for i = 1, 64 do
	local value = (i - 1) * 10
	horizontal_margin_options[i] = { description = "" .. value, data = value }
end

-- 36 - RESOLUTION_Y/2 = 360
for i = 1, 36 do
	local value = (i - 1) * 10
	vertical_margin_options[i] = { description = "" .. value, data = value }
end

local hud_scale_options = {}
for i = 1, 21 do
	local scale = (i - 1) * 5 + 50
	hud_scale_options[i] = { description = "" .. (scale * 0.01), data = scale }
end

local bool_opt = {
	{ description = "开启", data = true },
	{ description = "禁用", data = false },
}

local kuaijiezhizuol = {
	{ description = "A", data = "A" },
	{ description = "B", data = "B" },
	{ description = "C", data = "C" },
	{ description = "D", data = "D" },
	{ description = "E", data = "E" },
	{ description = "F", data = "F" },
	{ description = "G", data = "G" },
	{ description = "H", data = "H" },
	{ description = "I", data = "I" },
	{ description = "J", data = "J" },
	{ description = "K", data = "K" },
	{ description = "L", data = "L" },
	{ description = "M", data = "M" },
	{ description = "N", data = "N" },
	{ description = "O", data = "O" },
	{ description = "P", data = "P" },
	{ description = "Q", data = "Q" },
	{ description = "R", data = "R" },
	{ description = "S", data = "S" },
	{ description = "T", data = "T" },
	{ description = "U", data = "U" },
	{ description = "V", data = "V" },
	{ description = "W", data = "W" },
	{ description = "X", data = "X" },
	{ description = "Y", data = "Y" },
	{ description = "Z", data = "Z" },
	{ description = "TAB", data = "TAB" },
	{ description = "LSHIFT", data = "LSHIFT" },
	{ description = "CAPSLOCK", data = "CAPSLOCK" },
	{ description = "LALT", data = "LALT" },
	{ description = "BACKSPACE", data = "BACKSPACE" },
	{ description = "PERIOD", data = "PERIOD" },
	{ description = "SLASH", data = "SLASH" },
	{ description = "TILDE", data = "TILDE" },
}
local keys_opt = {
	{ description = "禁用", data = 0 },
	{ description = "A", data = 97 },
	{ description = "B", data = 98 },
	{ description = "C", data = 99 },
	{ description = "D", data = 100 },
	{ description = "E", data = 101 },
	{ description = "F", data = 102 },
	{ description = "G", data = 103 },
	{ description = "H", data = 104 },
	{ description = "I", data = 105 },
	{ description = "J", data = 106 },
	{ description = "K", data = 107 },
	{ description = "L", data = 108 },
	{ description = "M", data = 109 },
	{ description = "N", data = 110 },
	{ description = "O", data = 111 },
	{ description = "P", data = 112 },
	{ description = "Q", data = 113 },
	{ description = "R", data = 114 },
	{ description = "S", data = 115 },
	{ description = "T", data = 116 },
	{ description = "U", data = 117 },
	{ description = "V", data = 118 },
	{ description = "W", data = 119 },
	{ description = "X", data = 120 },
	{ description = "Y", data = 121 },
	{ description = "Z", data = 122 },
	{ description = "Period", data = 46 },
	{ description = "Slash", data = 47 },
	{ description = "Semicolon", data = 59 },
	{ description = "LeftBracket", data = 91 },
	{ description = "RightBracket", data = 93 },
	{ description = "F1", data = 282 },
	{ description = "F2", data = 283 },
	{ description = "F3", data = 284 },
	{ description = "F4", data = 285 },
	{ description = "F5", data = 286 },
	{ description = "F6", data = 287 },
	{ description = "F7", data = 288 },
	{ description = "F8", data = 289 },
	{ description = "F9", data = 290 },
	{ description = "F10", data = 291 },
	{ description = "F11", data = 292 },
	{ description = "F12", data = 293 },
	{ description = "0", data = 48 },
	{ description = "1", data = 49 },
	{ description = "2", data = 50 },
	{ description = "3", data = 51 },
	{ description = "4", data = 52 },
	{ description = "5", data = 53 },
	{ description = "6", data = 54 },
	{ description = "7", data = 55 },
	{ description = "8", data = 56 },
	{ description = "9", data = 57 },
	{ description = "Up", data = 273 },
	{ description = "Down", data = 274 },
	{ description = "Right", data = 275 },
	{ description = "Left", data = 276 },
	{ description = "PageUp", data = 280 },
	{ description = "PageDown", data = 281 },
	{ description = "Home", data = 278 },
	{ description = "Insert", data = 277 },
	{ description = "Delete", data = 127 },
	{ description = "End", data = 279 },
	{ description = "None", data = 0 },
	{ description = "Num0", data = 256 },
	{ description = "Num1", data = 257 },
	{ description = "Num2", data = 258 },
	{ description = "Num3", data = 259 },
	{ description = "Num4", data = 260 },
	{ description = "Num5", data = 261 },
	{ description = "Num6", data = 262 },
	{ description = "Num7", data = 263 },
	{ description = "Num8", data = 264 },
	{ description = "Num9", data = 265 },
	{ description = "Num.", data = 266 },
	{ description = "Num/", data = 267 },
	{ description = "Num*", data = 268 },
	{ description = "Num-", data = 269 },
	{ description = "Num+", data = 270 },
	{ description = "Num Enbter", data = 271 },
}
local sizeList = {}
for i = 1, 6 do
	local size = 240 + 60 * i
	sizeList[i] = { description = size, data = size }
end
local disable_save_slot_toggle_options = {
	{ description = "- none -", data = false },
}
for i = 0, 25 do
	disable_save_slot_toggle_options[i + 2] = {
		description = "Control + " .. ("").char(65 + i),
		data = 97 + i,
	}
end

local percentage_options = {}
for i = 1, 20 do
	local percentage = i * 5
	local data = percentage / 100
	percentage_options[i] = {
		description = percentage .. "%",
		data = data,
	}
end
local offset_options = {}
for i = 0, 16 do
	local data = 1 + (i * 0.25)
	local extra_offset = (data - 1) * 100
	offset_options[i + 1] = {
		description = i == 0 and "Default" or "+" .. extra_offset .. "%",
		data = data,
	}
end

local text_sizes = {}
for i = 6, 48, 2 do
	text_sizes[#text_sizes + 1] = { description = "" .. i, data = "" .. i }
end
local colours = {
	"White",
	"Black",
	"Red",
	"Green",
	"Blue",
	"Cyan",
	"Magenta",
	"Yellow",
	"Pink",
	"Orange",
	"Dark Red",
	"Dark Green",
	"Dark Blue",
}
local colour_opt = {}
for i = 1, #colours do
	colour_opt[i] = { description = colours[i], data = i }
end

local boolean = { { description = "启用", data = true }, { description = "禁用", data = false } }

local string = ""
local keys = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"F1",
	"F2",
	"F3",
	"F4",
	"F5",
	"F6",
	"F7",
	"F8",
	"F9",
	"F10",
	"F11",
	"F12",
	"LAlt",
	"RAlt",
	"LCTRL",
	"RCTRL",
	"LSHIFT",
	"RSHIFT",
	"TAB",
	"CAPSLOCK",
	"SPACE",
	"MINUS",
	"EQUALS",
	"BACKSPACE",
	"INSERT",
	"HOME",
	"DELETE",
	"END",
	"PAGEUP",
	"PAGEDOWN",
	"PRINT",
	"SCROLLOCK",
	"PAUSE",
	"PERIOD",
	"SLASH",
	"SEMICOLON",
	"LEFTBRACKET",
	"RIGHTBRACKET",
	"BACKSLASH",
	"UP",
	"DOWN",
	"LEFT",
	"RIGHT",
}
local keylist = {}
local keylist_2 = {}
for i = 1, #keys do
	keylist[i] = { description = keys[i], data = "KEY_" .. string.upper(keys[i]) }
	keylist_2[i] = { description = keys[i], data = "KEY_" .. string.upper(keys[i]) }
end
keylist[#keylist + 1] = { description = "禁用", data = false }
keylist_2[#keylist_2 + 1] = { description = "没有切换按键", data = "no_toggle_key" }
keylist_2[#keylist_2 + 1] = { description = "禁用", data = false }

local eight_options = {
	-- Default emotes
	{ description = "/wave", data = "wave" },
	{ description = "/rude", data = "rude" },
	{ description = "/happy", data = "happy" },
	{ description = "/angry", data = "angry" },
	{ description = "/sad", data = "sad" },
	{ description = "/annoyed", data = "annoyed" },
	{ description = "/joy", data = "joy" },
	{ description = "/dance", data = "dance" },
	{ description = "/bonesaw", data = "bonesaw" },
	{ description = "/facepalm", data = "facepalm" },
	{ description = "/kiss", data = "kiss" },
	{ description = "/pose", data = "pose" },
	{ description = "/sit", data = "sit" },
	{ description = "/squat", data = "squat" },
	{ description = "/toast", data = "toast" },

	-- Unlockable emotes
	{ description = "/sleepy", data = "sleepy" },
	{ description = "/yawn", data = "yawn" },
	{ description = "/swoon", data = "swoon" },
	{ description = "/chicken", data = "chicken" },
	{ description = "/robot", data = "robot" },
	{ description = "/step", data = "step" },
	{ description = "/fistshake", data = "fistshake" },
	{ description = "/flex", data = "flex" },
	{ description = "/impatient", data = "impatient" },
	{ description = "/cheer", data = "cheer" },
	{ description = "/laugh", data = "laugh" },
	{ description = "/shrug", data = "shrug" },
	{ description = "/slowclap", data = "slowclap" },
	{ description = "/carol", data = "carol" },
}
local smallgridsizeoptions = {}
for i = 0, 10 do
	smallgridsizeoptions[i + 1] = { description = "" .. (i * 2) .. "", data = i * 2 }
end
local medgridsizeoptions = {}
for i = 0, 10 do
	medgridsizeoptions[i + 1] = { description = "" .. i .. "", data = i }
end
local biggridsizeoptions = {}
for i = 0, 5 do
	biggridsizeoptions[i + 1] = { description = "" .. i .. "", data = i }
end

local KEY_A = 65
local keyslist = {}
local string = "" -- can't believe I have to do this... -____-
for i = 1, 26 do
	local ch = string.char(KEY_A + i - 1)
	keyslist[i] = { description = ch, data = ch }
end
keyslist[27] = { description = "None", data = "" }

local percent_options = {}
for i = 1, 10 do
	percent_options[i] = { description = i .. "0%", data = i / 10 }
end
percent_options[11] = { description = "Unlimited", data = false }

local placer_color_options = {
	{ description = "绿色", data = "green", hover = "游戏使用的普通绿色。" },
	{ description = "蓝色", data = "blue", hover = "蓝色，如果你是红/绿色盲的话很有用." },
	{ description = "红色", data = "red", hover = "游戏使用的普通红色。" },
	{ description = "白色", data = "white", hover = "明亮的白色，为了更好的能见度。" },
	{ description = "黑色", data = "black", hover = "黑色，与明亮的颜色形成对比" },
}
local color_options = {}
for i = 1, #placer_color_options do
	color_options[i] = placer_color_options[i]
end
color_options[#color_options + 1] = {
	description = "白色轮廓",
	data = "whiteoutline",
	hover = "白色带黑色轮廓，以获得最佳可见性。",
}
color_options[#color_options + 1] = {
	description = "黑色轮廓",
	data = "blackoutline",
	hover = "黑色加白色轮廓，以获得最佳可见性。",
}
local hidden_option = {
	description = "隐藏",
	data = "hidden",
	hover = "把它完全藏起来，因为你根本不需要看到它，对吧？",
}
placer_color_options[#placer_color_options + 1] = hidden_option
color_options[#color_options + 1] = hidden_option

local function AddTitle(title)
	return {
		label = title,
		name = "",
		hover = "",
		options = { { description = "", data = 0 } },
		default = 0,
	}
end

local function CreateAreOneSetting(display_name, code_name_base, chinese_name, default_false)
	return {
		label = display_name,
		name = code_name_base .. "_are_one",
		hover = "All types of " .. string.lower(display_name) .. "所有类型的" .. chinese_name .. "将会被视为同一个prefab",
		options = boolean,
		default = not default_false,
	}
end

local function AddConfig(label, name, options, default, hover)
	return { label = label, name = name, options = options, default = default, hover = hover or "" }
end
local chaoqiangjiyi = { { description = "启用", data = true }, { description = "禁用", data = false } }
----仇恨显示
local colour2 = { --------颜色表
	{ description = "红色", data = 1 },
	{ description = "绿色", data = 2 },
	{ description = "深绿色", data = 3 },
	{ description = "蓝色", data = 4 },
	{ description = "浅蓝色", data = 5 },
	{ description = "橙色", data = 6 },
	{ description = "橘子色", data = 7 },
	{ description = "黄色", data = 8 },
	{ description = "紫色", data = 9 },
	{ description = "粉红色", data = 10 },
	{ description = "灰色", data = 11 },
--将数据作为数字处理，因为将数据作为表格处理会使选项和字符串变得枯燥乏味。.
}

local colour = { --一张桌子，这样更容易记录颜色。
	["red"] = 1,
	["green"] = 2,
	["darkgreen"] = 3,
	["blue"] = 4,
	["lightblue"] = 5,
	["orange"] = 6,
	["orangered"] = 7,
	["yellow"] = 8,
	["purple"] = 9,
	["pink"] = 10,
	["gray"] = 11,
}
local colors = {
	{ data = 0, description = "标准 " },
	{ data = 1, description = "黄金" },
	{ data = 2, description = "白色" },
	{ data = 3, description = "红色" },
	{ data = 4, description = "绿色" },
	{ data = 5, description = "蓝色" },
	{ data = 6, description = "黄色" },
	{ data = 7, description = "洋红" },
	{ data = 8, description = "青色" },
	{ data = 9, description = "灰色" },
}

local colorlist = {
	{ description = "白色", data = "WHITE" },
	{ description = "红色", data = "FIREBRICK" },
	{ description = "橙色", data = "TAN" },
	{ description = "黄色", data = "LIGHTGOLD" },
	{ description = "绿色", data = "GREEN" },
	{ description = "青色", data = "TEAL" },
	{ description = "蓝色", data = "OTHERBLUE" },
	{ description = "紫色", data = "DARKPLUM" },
	{ description = "粉红色", data = "ROSYBROWN" },
	{ description = "黄金色", data = "GOLDENROD" },
}

local numberoptions = {}
for i = 1, 18 do
	numberoptions[i] = { description = "" .. i .. "", data = i }
end
local numberoptionssmall = {}
local space = "   " -- Literally just space
--for i=0,5 do numberoptionssmall[i+1] = {description = i == 0 and "none" or ""..i.."", data = i} end
for i = 0, 5 do
	numberoptionssmall[i + 1] = { description = space .. i .. "", data = i }
end
local booleanoptions = {
	{ data = false, description = "禁用" },
	{ data = true, description = "启用" },
}
local delims = { { data = false, description = "禁用" } }
local symbols = {
	"`",
	"~",
	"!",
	"@",
	"#",
	"$",
	"%",
	"^",
	"&",
	"*",
	"?",
	";",
	"\\",
	"|",
	"'",
	"\"",
	".",
	"..",
	",",
	",,",
	"(",
	")",
	"{",
	"}",
	"[",
	"]",
	"<",
	">",
}
for i = 1, #symbols do
	delims[i + 1] = { description = symbols[i] .. space, data = symbols[i] }
end

local CC_text = "显示快捷菜单前所需的字符数。."
local SS_text = "开始处显示快捷菜单所需的符号。"
local Emoji_text = "符号-显示一个带有所有可用表情符号的列表。"
local Emote_text = "表情-显示一个列表与所有可用的表情。"
local Player_text = "玩家 - 显示当前世界中可用玩家的列表."
local Object_text = "对象 - 显示游戏中所有可用对象名称的列表。"
local Prefab_text = "预制 - 如果使用Tab/Enter选择，则将任何对象名称转换为其预设名称。"
local Personal_text = "个人-设计自己的快捷方式，通过 [快捷] [名称] [文本] "

local function BuildNumConfig(start_num, end_num, step, percent)
	local num_table = {}
	local iterator = 1
	local suffix = percent and "%" or ""
	for i = start_num, end_num, step do
		num_table[iterator] = { description = i .. suffix, data = percent and i / 100 or i }
		iterator = iterator + 1
	end
	return num_table
end
local function CreateDisableSoundSetting(display_name, code_name_base, en_description, ch_description)
	return {
		label = display_name,
		name = "remove_" .. code_name_base .. "_noise",
		hover = "Mute " .. en_description .. "\n静音" .. ch_description,
		options = boolean,
		default = false,
	}
end

local function AddConfig(label, name, options, default, hover)
	return { label = label, name = name, options = options, default = default, hover = hover or "" }
end

configuration_options = {
	{
		name = "避雷针",
		label = "基础功能开启",
		hover = " ",
		options = { { description = "", data = true } }, 
		default = true,

	},
	{
		name = "仇恨与跟随目标显示",
		label = "开启仇恨与跟随目标显示",
		hover = "是否开启显示仇恨",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "攻击技能间隔显示",
		label = "攻击技能间隔显示",
		hover = "是否开启技能间隔倒计时",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "显示攻击范围",
		label = "究极范围显示",
		hover = "开启范围显示，自动搜寻脚印 小惊吓礼物，各种物品范围光环提醒",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "显示鸟范围",
		label = "[范围显示是否显示鸟的范围？]",
		hover = "开启后鸟也有范围",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "袭击警示",
		label = "袭击警示",
		hover = "开启后在猎狗来袭，boss来袭后，会以各种方式告知你",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "显示人物攻击范围",
		label = "人物攻击范围显示",
		hover = "人物攻击范围，在白圈是你的最大攻击目标仇恨，红圈是打出的攻击判定",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "自动填充燃料",
		label = "自动填充燃料",
		hover = "自动填充魔光，提灯，头灯，骨甲以及鼹鼠帽的燃料，并且保护它们耐久为2%的时候脱落",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "夜视全图滤镜处理",
		label = "夜视滤镜",
		hover = "按键夜视，全图，消除月岛、脑残滤镜、OB视角",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "夜视全图滤镜处理2",
		label = "OB视角",
		hover = "OB视角是否开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "操作提升",
		label = "操作提升",
		hover = "全面操作优化带给你更好的体验，相信我，你肯定会打开",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "输入优化",
		label = "输入优化",
		hover = "全面输入优化带给你更好的体验，相信我，你肯定会打开",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "超高数据显示",
		label = "超高数据显示",
		hover = "显示四季时钟，季节温度，机器人充能，洞穴暴动，与三围显示",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "快捷制作栏",
		label = "快捷制作栏",
		hover = "收藏你经常做的物品然后长按ALT弹出快捷制作栏",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "自动走A",
		label = "自动走A",
		hover = "平A取消后摇并且自动攻击",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	-- {
	-- name = "禁止强A",
	-- label = "禁止强A",
	-- hover = "无法使用强制攻击攻击",
	-- options = {
	-- {description = "禁止", data = true},
	-- {description = "不禁止", data = false},
	-- },
	-- default = false,

	-- },

	{
		name = "是否打鸟",
		label = "是否打鸟",
		hover = "无法使用强制攻击打鸟",
		options = {
			{ description = "禁止打鸟", data = true },
			{ description = "不禁止打鸟", data = false },
		},
		default = true,

	},

	{
		name = "111111",
		label = "额外功能",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "更多图标",
		label = "更多图标",
		hover = "在游戏的地图上，显示更多图标。但是却会让很多生物失去声音,bug吓人",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "名称显示",
		label = "名称显示",
		hover = "在游戏中显示玩家昵称",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "智能锅",
		label = "智能锅",
		hover = "在游戏中显示锅子的配方",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "快捷宣告",
		label = "快捷宣告",
		hover = "在游戏中开启快捷宣告功能",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "G键表情",
		label = "快捷表情",
		hover = "在游戏中开启快捷表情功能",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "物品信息",
		label = "物品信息",
		hover = "在游戏中开启物品信息显示功能",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "几何布局",
		label = "几何布局",
		hover = "客户端所实现的几何建筑",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "装备固定",
		label = "装备固定",
		hover = "一个简单装备固定系统",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "黑化排队论",
		label = "黑化排队论",
		hover = "客户端上的黑化排队论",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "自动钓鱼",
		label = "自动钓鱼",
		hover = "一个简单的自动钓鱼和钓海鱼",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "钓鱼按键",
		label = "自动钓鱼按键",
		hover = "默认F5启动钓鱼",
		options = keys_opt,
		default = 286,

	},
	{
		name = "自动海钓",
		label = "自动海钓",
		hover = "一个简单的海钓系统，可能在钓鱼过程切换鱼饵会炸",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "自动烹饪",
		label = "自动烹饪",
		hover = "一个简单烹饪系统按F8",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "111111",
		label = "实验功能",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},

	{
		name = "游戏中模组设置",
		label = "游戏内模组开关功能",
		hover = "在游戏中按下小键盘上的7可开启或者关闭客户端模组",
		options = {
			{ description = "开启-与熔炉冲突！", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "幽灵玩家",
		label = "幽灵玩家",
		hover = "记入你最后看到那个玩家是在什么地点什么时候它叫什么名字",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "坐标系统",
		label = "坐标系统",
		hover = "在游戏中开启强大的坐标系统，可分享坐标，可是仅用于开启本模组的玩家",
		options = {
			{
				description = "开启",
				data = true,
				hover = "如果你跟朋友都开了这个功能，那就可以直接定位一个坐标让他走过去了",
			},
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "农场辅助",
		label = "农场辅助",
		hover = "在游戏中开启强大的农场辅助，可以显示各种各样的植物营养,直接显示种子名字等",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "禁声系统",
		label = "禁声系统",
		hover = "一个简单的禁声系统",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "1111656565656111",
		label = "高亮辅助",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "高亮显示",
		label = "高亮显示",
		hover = "让一些生物高亮显示！配合范围辅助更清楚哦",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "光照模式",
		label = "高亮显示:直接发光",
		hover = "直接给那些生物一个灯光，让你看的清楚无比",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "1111111",
		label = "地图系统",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "微型地图",
		label = "微型地图",
		hover = "在游戏中添加一个随心所欲控制的小地图UI",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "锁定地图",
		label = "锁定地图",
		hover = "在游戏中锁定大地图方向",
		options = {
			{ description = "开启--可能会让你眩晕", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "透明地图",
		label = "透明地图",
		hover = "一个简单的透明地图",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "map_alpha",
		label = "透明地图设置",
		options = {
			{ description = "10%", data = 0.9 },
			{ description = "20%", data = 0.8 },
			{ description = "30%", data = 0.7 },
			{ description = "40%", data = 0.6 },
			{ description = "50%", data = 0.5 },
			{ description = "60%", data = 0.4 },
			{ description = "70%", data = 0.3 },
			{ description = "80%", data = 0.2 },
			{ description = "90%", data = 0.1 },
		},
		default = 0.7,
	},
	{
		name = "1111112221",
		label = "制作栏优化",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "加宽制作栏",
		label = "加宽制作栏",
		hover = "让制作栏位加宽",
		options = {
			{ description = "开启", data = true, hover = "切换可能闪退一次" },
			{ description = "禁用", data = false, hover = "切换可能闪退一次" },
		},
		default = false,

	},
	{
		name = "制作物品美化",
		label = "更清晰的制作栏（二选一）",
		hover = "接近原版的美化方式，让制作的东西更清晰",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "制作物品美化2",
		label = "色彩丰富的制作栏（二选一）",
		hover = "让制作的物品色彩分明，解锁和不解锁和可制作的颜色都不一样",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "1111111101",
		label = "滤镜设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "四季滤镜",
		label = "四季滤镜",
		hover = "一个比较大的滤镜系统四季都有一种独特的风格",
		options = {
			{ description = "开启", data = true, hover = "切换可能闪退一次" },
			{ description = "禁用", data = false, hover = "切换可能闪退一次" },
		},
		default = false,

	},
	{
		name = "兼容模式",
		label = "滤镜兼容",
		hover = "如果你要开启其他滤镜模组，请开启兼容模式",
		options = {
			{ description = "兼容模式未开启", data = true, hover = "切换可能闪退一次" },
			{ description = "兼容模式开启", data = false, hover = "切换可能闪退一次" },
		},
		default = true,

	},
	{
		name = "111111111",
		label = "字体设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	-- {
	-- name = "方正喵呜",
	-- label = "方正喵呜（二选一）",
	-- hover = "将你的字体设置成方正喵呜体",
	-- options = {
	-- {description = "开启", data = true},
	-- {description = "禁用", data = false}
	-- },
	-- default = false,

	-- },
	-- {
	-- name = "本墨悠圆",
	-- label = "本墨悠圆（二选一）",
	-- hover = "有点像是修仙大型网游的字体",
	-- options = {
	-- {description = "开启", data = true},
	-- {description = "禁用", data = false}
	-- },
	-- default = false,

	-- },
	{
		name = "修改字体大小",
		label = "字体大小",
		hover = "修改字体大小",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,

	},
	{
		name = "CHINESE_TEXT_SCALE",
		label = "使用简体中文时的字体大小",
		options = {
			{ description = "0.50", data = 0.50 },
			{ description = "0.55", data = 0.55 },
			{ description = "0.60", data = 0.60 },
			{ description = "0.65", data = 0.65 },
			{ description = "0.70", data = 0.70 },
			{ description = "0.75", data = 0.75 },
			{ description = "0.80", data = 0.80 },
			{ description = "0.85", data = 0.85 },
			{ description = "0.90", data = 0.90 },
			{ description = "0.95", data = 0.95 },
			{ description = "1.00", data = 1.00 },
			{ description = "1.05", data = 1.05 },
			{ description = "1.10", data = 1.10 },
			{ description = "1.15", data = 1.15 },
			{ description = "1.20", data = 1.20 },
			{ description = "1.25", data = 1.25 },
			{ description = "1.30", data = 1.30 },
			{ description = "1.35", data = 1.35 },
			{ description = "1.40", data = 1.40 },
			{ description = "1.45", data = 1.45 },
			{ description = "1.50", data = 1.50 },
		},
		default = 0.90,
	},
	{
		name = "ENGLISH_TEXT_SCALE",
		label = "使用英文时的字体大小",
		options = {
			{ description = "0.50", data = 0.50 },
			{ description = "0.55", data = 0.55 },
			{ description = "0.60", data = 0.60 },
			{ description = "0.65", data = 0.65 },
			{ description = "0.70", data = 0.70 },
			{ description = "0.75", data = 0.75 },
			{ description = "0.80", data = 0.80 },
			{ description = "0.85", data = 0.85 },
			{ description = "0.90", data = 0.90 },
			{ description = "0.95", data = 0.95 },
			{ description = "1.00", data = 1.00 },
			{ description = "1.05", data = 1.05 },
			{ description = "1.10", data = 1.10 },
			{ description = "1.15", data = 1.15 },
			{ description = "1.20", data = 1.20 },
			{ description = "1.25", data = 1.25 },
			{ description = "1.30", data = 1.30 },
			{ description = "1.35", data = 1.35 },
			{ description = "1.40", data = 1.40 },
			{ description = "1.45", data = 1.45 },
			{ description = "1.50", data = 1.50 },
		},
		default = 1.00,
	},
	{
		name = "24254112643",
		label = "快捷制作",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "快捷制作",
		label = "快捷制作",
		hover = "按下键位 快捷制作物品",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "更多按键",
		label = "是否需要按下ctrl",
		hover = "是否需要按下ctrl，再按快捷键制作物品",
		options = {
			{ description = "需要按下", data = true },
			{ description = "不需要", data = false },
		},
		default = true,

	},

	{
		name = "key",
		label = "一键做影刀.按键",
		options = keylist,
		default = "KEY_N",
	},
	{
		name = "key2",
		label = "CTRL+1做打包纸按键",
		options = keys_opt,
		default = 49,
	},
	{
		name = "key3",
		label = "CTRL+2做绳子，按键",
		options = keys_opt,
		default = 50,
	},
	{
		name = "打包纸",
		label = "使用打包纸打包纸按键",
		options = keys_opt,
		default = 108,
	},
	{
		name = "2425411264",
		label = "模组功能开关END",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "2425411264",
		label = "模组细节设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "anjian",
		label = "游戏内开关模组按键",
		options = keys_opt,
		default = 263,
	},

	{
		name = "范围显示",
		label = "开关范围显示",
		hover = "用按钮来隐藏开关范围显示",
		options = keys_opt,
		default = 258,
	},
	{
		name = "范围显示1",
		label = "开关名称显示",
		hover = "用按钮来隐藏名称显示",
		options = keys_opt,
		default = 259,
	},
	{
		name = "toggle",
		label = "开关技能计时",
		hover = "切换显示怪物的计时器标签",
		options = keys_opt,
		default = 258,
	},
	{
		name = "人物范围",
		label = "开关人物范围显示",
		hover = "用按钮来隐藏开关范围显示",
		options = keys_opt,
		default = 259,
	},
	{
		name = "夜视开关",
		label = "夜视开关",
		hover = "打开以后夜晚会跟白天一样",
		options = keys_opt,
		default = 257,
	},
	{
		name = "鹰眼全图",
		label = "鹰眼全图",
		hover = "俯视全图地形,点击地图会自动走向目的地的快捷键位",
		options = keys_opt,
		default = 260,
	},
	{
		name = "listbind",
		label = "显示快捷制作栏",
		hover = "长按此键可显示一共快捷制作的菜单",
		options = kuaijiezhizuol,
		default = "LALT",
	},
	{
		name = "uiscale",
		label = "快捷制作界面比例",
		hover = "更改屏幕上菜单的大小，没有需求就不要改动",
		options = {
			{ description = "0.1", data = 0.1 },
			{ description = "0.2", data = 0.2 },
			{ description = "0.3", data = 0.3 },
			{ description = "0.4", data = 0.4 },
			{ description = "0.5", data = 0.5 },
			{ description = "0.6", data = 0.6 },
			{ description = "0.7", data = 0.7 },
			{ description = "0.8", data = 0.8 },
			{ description = "0.9", data = 0.9 },
			{ description = "1.0", data = 1.0 },
			{ description = "1.1", data = 1.1 },
			{ description = "1.2", data = 1.2 },
			{ description = "1.3", data = 1.3 },
			{ description = "1.4", data = 1.4 },
			{ description = "1.5", data = 1.5 },
			{ description = "1.6", data = 1.6 },
			{ description = "1.7", data = 1.7 },
			{ description = "1.8", data = 1.8 },
			{ description = "1.9", data = 1.9 },
			{ description = "2.0", data = 2.0 },
			{ description = "2.1", data = 2.1 },
			{ description = "2.2", data = 2.2 },
			{ description = "2.3", data = 2.3 },
			{ description = "2.4", data = 2.4 },
			{ description = "2.5", data = 2.5 },
			{ description = "2.6", data = 2.6 },
			{ description = "2.7", data = 2.7 },
			{ description = "2.8", data = 2.8 },
			{ description = "2.9", data = 2.9 },
			{ description = "3.0", data = 3.0 },
		},
		default = 1.0,
	},

	{
		name = "OBC_INITIAL_VIEW_MODE",
		label = "进入游戏时的初始视角模式",
		hover = "进入游戏时的初始视图模式。",
		options = {
			{ description = "默认", data = 0 },
			{ description = "高空", data = 1 },
			{ description = "俯视", data = 2 },
		},
		default = 0,
	},
	{
		name = "OBC_FUNCTION_KEY_1",
		label = "在默认/高空/俯视模式间切换",
		hover = "在默认/鸟瞰/垂直视图模式之间切换的键。",
		options = keys_opt,
		default = 290,
	},
	{
		name = "OBC_FUNCTION_KEY_2",
		label = "隐藏/显示游戏HUD",
		hover = "隐藏/显示游戏HUD",
		options = keys_opt,
		default = 291,
	},
	{
		name = "OBC_FUNCTION_KEY_3",
		label = "隐藏/显示自身角色",
		hover = "隐藏/显示角色的关键。",
		options = keys_opt,
		default = 292,
	},
	{
		name = "OBC_SWITCH_KEY_1",
		label = "固定视角到鼠标所指实体",
		hover = "将相机聚焦在鼠标下的实体上的键。",
		options = keys_opt,
		default = 0,
	},
	{
		name = "OBC_SWITCH_KEY_2",
		label = "固定视角到鼠标所指位置",
		hover = "将相机聚焦在鼠标下的位置。",
		options = keys_opt,
		default = 0,
	},
	{
		name = "OBC_RESET_KEY",
		label = "在自身与最近选定的实体/位置间切换",
		hover = "在角色和最近选定的实体/位置之间切换相机焦点的键",
		options = keys_opt,
		default = 0,
	},
	{
		name = "自动填充",
		label = "自动添加燃料耐久",
		hover = "耐久小于多少时添加一次燃料",
		options = {
			{ description = "80%", data = 80 },
			{ description = "60%", data = 60 },
			{ description = "50%", data = 50 },
			{ description = "30%", data = 30 },
			{ description = "20%", data = 20 },
			{ description = "10%", data = 10 },
		},
		default = 50,
	},
	{
		name = "22222222265656",
		label = "植物辅助设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "buttonregister",
		label = "植物登记按钮",
		hover = "启用HUD中的“植物登记”按钮。",
		options = {
			{ description = "禁用", data = false },
			{ description = "启用", data = true },
		},
		default = true,
	},
	{
		name = "keyregister",
		label = "植物登记按键绑定",
		hover = "按此键可切换植物登记簿",
		options = keys_opt,
		default = 0,
	},
	{
		name = "buttonhud",
		label = "营养视觉按钮",
		hover = "启用HUD中的“养分视觉”按钮",
		options = {
			{ description = "禁用", data = false },
			{ description = "启用", data = true },
		},
		default = true,
	},
	{
		name = "keyhud",
		label = "营养视觉按键",
		hover = "按下这个键可以切换你的营养视力。",
		options = keys_opt,
		default = 0,
	},
	{
		name = "location",
		label = "位置",
		hover = "植物登记和营养素视觉按钮的位置。",
		options = {
			{ description = "右下角^", data = 1, hover = "在“显示地图”按钮上方" },
			{ description = "右下角<", data = 2, hover = "从“显示地图”按钮向左" },
			{ description = "左下角", data = 3, hover = "在你的工艺菜单下面" },
			{ description = "左上角", data = 4, hover = "在你的工艺菜单上面" },
			{ description = "顶部", data = 5, hover = "顶部" },
			{ description = "右上方", data = 6, hover = "在你的数据旁边" },
			{ description = "右", data = 7, hover = "在你的背包后面" },
		},
		default = 2,
	},
	{
		name = "nutrientsoveralpha",
		label = "营养视觉透明度",
		hover = "在此处更改营养素视野的透明度。\n透明度越高，看到的东西就越少。",
		options = alpha,
		default = 75,
	},
	{
		name = "knowallplants",
		label = "研究植物",
		hover = "解锁植物登记册中某些植物和肥料的数据。\n这不会影响原始植物数据。",
		options = {
			{
				description = "标准",
				data = false,
				hover = "植物登记册将只包含你已经研究过的植物。",
			},
			{ description = "仅种子", data = "seeds", hover = "作物种子将显示它们相应的名称。" },
			{ description = "全部", data = true, hover = "解锁设备寄存器中的各种数据。" },
		},
		default = true,
	},
	{
		name = "plantcolors",
		label = "有色作物",
		hover = "如果它检测到某种压力源，就会改变作物的颜色。",
		options = {
			{ description = "禁用", data = false },
			{ description = "启用", data = true, hover = "注意：只有在启用营养视力时才可见。" },
		},
		default = true,
	},
	{
		name = "groundstatus",
		label = "地面分析仪",
		hover = "走在一块农田上，你会看到其中的营养和水分。",
		options = {
			{ description = "禁用", data = false },
			{ description = "启用", data = true, hover = "注意：只有在启用营养视力时才可见。" },
		},
		default = true,
	},
	{
		name = "groundstatusoffset",
		label = "地面分析仪偏移",
		hover = "地面分析仪的Y偏移。",
		options = yOffsets,
		default = 100,
	},
	{
		name = "222222222",
		label = "走A设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},

	AddConfig("发动攻击", "Attack_key", keylist, "KEY_R", "按住不放即可实现走A"),
	AddConfig("增加攻击频率", "Adddelay_key", keylist, "KEY_UP", "增加攻击频率"),
	AddConfig("降低攻击频率", "Reducedelay_key", keylist, "KEY_DOWN", "降低攻击频率"),
	AddConfig("延后启动关键帧", "Addkeyframe_key", keylist, "KEY_RIGHT", "延后启动关键帧"),
	AddConfig("提前启动关键帧", "Reducekeyframe_key", keylist, "KEY_LEFT", "提前启动关键帧"),
	{
		name = "Default_delay",
		label = "默认攻击频率",
		hover = "默认攻击频率",
		options = {
			{ description = "1帧", data = 1 },
			{ description = "2帧", data = 2 },
			{ description = "3帧", data = 3 },
			{ description = "4帧", data = 4 },
			{ description = "5帧", data = 5 },
			{ description = "6帧", data = 6 },
			{ description = "7帧", data = 7 },
			{ description = "8帧", data = 8 },
			{ description = "9帧", data = 9 },
			{ description = "10帧", data = 10 },
			{ description = "11帧", data = 11 },
			{ description = "12帧", data = 12 },
		},
		default = 9,
	},
	{
		name = "Default_keyframe",
		label = "默认关键帧",
		hover = "默认关键帧",
		options = {
			{ description = "第 0帧数", data = 0 },
			{ description = "第 1'st FRAME", data = 1 },
			{ description = "第 2'nd FRAME", data = 2 },
			{ description = "第 3帧数", data = 3 },
			{ description = "第 4帧数", data = 4 },
			{ description = "第 5帧数", data = 5 },
			{ description = "第 6帧数", data = 6 },
			{ description = "第 7帧数", data = 7 },
			{ description = "第 8帧数", data = 8 },
			{ description = "第 9帧数", data = 9 },
			{ description = "第 10帧数", data = 10 },
			{ description = "第 11帧数", data = 11 },
			{ description = "第 12帧数", data = 12 },
			{ description = "第 13帧数", data = 13 },
			{ description = "第 14帧数", data = 14 },
			{ description = "第 15帧数", data = 15 },
		},
		default = 10,
	},

	{
		name = "萌萌呀",
		label = "范围辅助设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "攻击范围显示",
		label = "显示你的攻击范围光圈颜色",
		hover = "设置你的显示攻击范围显示的光环的颜色",
		options = colour2, 
		default = colour.red, --Red
	},
	{
		name = "跟踪动画",
		label = "跟踪动画",
		hover = "是否开启跟踪动画",
		options = {
			{ description = "禁用", data = 0 },
			{ description = "开启", data = 1 },
		},
		default = 1,
	},
	{
		name = "通知声音",
		label = "通知声音",
		hover = "当附近的土堆出现/消失时播放声音。",
		options = {
			{ description = "禁用", data = 0 },
			{ description = "仅出现", data = 1 },
			{ description = "仅消失", data = 2 },
			{ description = "总是", data = 3 },
		},
		default = 3,
	},
	{
		name = "动物跟踪器快捷键",
		label = "动物跟踪器快捷键",
		hover = "按快捷键跟随动物的足迹。",
		options = keys_opt,
		default = 259,
	},
	{
		name = "丢失的玩具跟踪器快捷键",
		label = "丢失的玩具跟踪器快捷键",
		hover = "按快捷键寻找丢失的玩具。",
		options = keys_opt,
		default = 262,
	},
	{
		name = "警示语言",
		label = "袭击提示设置",
		hover = " ",
		options = { { description = "", data = "chinese_s" } }, 
		default = "chinese_s",
	},

	{
		name = "display_form",
		hover = "选择袭击提示的显示位置",
		label = "显示形式",
		options = {
			{ description = "人物头顶", data = "head", hover = "袭击提示将会出现在人物头顶" },
			{
				description = "自己可见聊天栏",
				data = "chat",
				hover = "袭击提示将会出现在聊天栏的位置(仅自己可见)",
			},
			{
				description = "系统消息栏",
				data = "eventannouncer",
				hover = "袭击提示将会显示到系统消息栏",
			},
			{
				description = "所有人",
				data = "announce",
				hover = "袭击提示将会宣告到服务器，所有人可见",
			},
			{
				description = "全部启用：仅自己",
				data = "zijikejian",
				hover = "袭击提示将会以各种方式通知你",
			},
			{
				description = "全部启用：所有人",
				data = "qvanbuqiyong",
				hover = "袭击提示将会以各种方式通知你：所有人可见",
			},
		},
		default = "qvanbuqiyong",
	},

	{
		name = "deerclops_warning",
		hover = "玩家会在巨鹿每次吼叫的同时说:巨鹿将在...秒后到来",
		label = "提示巨鹿",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "bearger_warning",
		hover = "玩家会在熊獾每次吼叫的同时说:熊獾将在...秒后到来",
		label = "提示熊大",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "twister_warning",
		hover = "玩家会在飓风海豹每次吼叫的同时说:海豹将在...秒后到来",
		label = "提示豹龙卷",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "hound_warning",
		hover = "玩家会在猎犬袭击的警告声出现的时候说:猎犬袭击将在...秒后开始",
		label = "提示猎犬",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "worm_warning",
		hover = "玩家会在蠕虫袭击的警告声出现的时候说:蠕虫袭击将在...秒后开始",
		label = "提示蠕虫",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "sinkhole_warning",
		hover = "玩家会在蚁狮地震前的提示时说:蚁狮地陷将在...秒后生成",
		label = "提示蚁狮地陷",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "cavein_warning",
		hover = "玩家会在蚁狮落石前的提示时说:蚁狮落石将在...秒后生成",
		label = "提示蚁狮地陷落石",
		options = {
			{ description = "开启", data = true, hover = "启用" },
			{ description = "关闭", data = false, hover = "禁用" },
		},
		default = true,
	},

	{
		name = "P_C",
		hover = "如果你希望自定义袭击提示的颜色，可以选择自定义，然后分别在 红、绿、蓝 选项中选择需要的数值",
		label = "袭击提示颜色",
		options = {
			{ description = "预设", data = "preset", hover = "将会使用预设颜色" },
			{ description = "自定义", data = "customize", hover = "将会使用自定义颜色" },
		},
		default = "preset",
	},
	{
		name = "string_color",
		hover = "选一个喜欢的提示语颜色吧",
		label = "袭击提示预设颜色",
		options = {
			{ description = "白色", data = "white", hover = "白色" },
			{ description = "黑色", data = "black", hover = "黑色" },
			{ description = "红色", data = "red", hover = "红色" },
			{ description = "粉色", data = "pink", hover = "粉色" },
			{ description = "紫色", data = "purple", hover = "紫色" },
			{ description = "黄色", data = "yellow", hover = "黄色" },
			{ description = "蓝色", data = "blue", hover = "蓝色" },
			{ description = "绿色", data = "green", hover = "绿色" },
		},
		default = "red",
	},
	{
		name = "R",
		hover = "",
		label = "红",
		options = valuelist,
		default = 0,
	},
	{
		name = "G",
		hover = "",
		label = "绿",
		options = valuelist,
		default = 0,
	},
	{
		name = "B",
		hover = "",
		label = "蓝",
		options = valuelist,
		default = 0,
	},

	{
		name = "999999",
		label = "幽灵玩家设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "隐蔽幽灵玩家",
		label = "隐蔽幽灵玩家",
		hover = "用按钮来隐藏掉幽灵玩家显示的信息和按钮",
		options = keys_opt,
		default = 264,
	},
	{
		name = "默认开启关闭幽灵玩家",
		label = "默认开启关闭幽灵玩家",
		hover = "进入游戏不需要按任何按钮就显示数据",
		options = bool_opt,
		default = true,
	},
	{
		name = "幽灵玩家按钮",
		label = "幽灵玩家提供更多信息",
		hover = "幽灵玩家方显示一个按钮，点开它来提供更多信息",
		options = bool_opt,
		default = true,
	},
	{
		name = "9999995599965",
		label = "操作提升设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "better_fw_fight",
		hover = "当有影手在的时候不攻击影织者，按照顺序击败怪物，不a墙不a鸟",
		label = "攻击优化",
		options = boolean,
		default = true,
	},
	-- {
	-- name = "camera_maxdist_tweak",
	-- hover = "将默认镜头的maxdist调为225（大视野）",
	-- label = "大视野",
	-- options = boolean,
	-- default = true
	-- },
	-- {
	-- name = "camera_cave_pitch_tweak",
	-- hover = "将洞穴默认镜头视角调为默认视角",
	-- label = "洞穴默认镜头视角调为默认视角",
	-- options = boolean,
	-- default = true
	-- },

	{
		name = "quick_zoom",
		hover = "Shift + 鼠标滚轮快速放大/缩小镜头",
		label = "滚轮镜头",
		options = {
			{ description = "4", hover = "再缩放4步", data = 4 },
			{ description = "6", hover = "再缩放6步", data = 6 },
			{ description = "8", hover = "再缩放8步", data = 8 },
			{ description = "10", hover = "再缩放10步", data = 10 },
			{ description = "12", hover = "再缩放12步", data = 12 },
			{ description = "14", hover = "再缩放14步", data = 14 },
			{ description = "16", hover = "再缩放16步", data = 16 },
			{ description = "禁用", data = false },
		},
		default = 16,
	},
	{
		name = "repeat_drop",
		hover = "右键双击丢弃全部同类物品",
		label = "双击丢弃",
		options = {
			{ description = "放置在网格上 A", hover = "总是放在网格上", data = "drop_on_grid" },
			{
				description = "放置在网格上 B",
				hover = "左键单击仅放置在网格上",
				data = "drop_on_grid_leftclick",
			},
			{ description = "正常下降", data = "normal_drop" },
			{ description = "禁用", data = false },
		},
		default = "normal_drop",
	},
	{
		name = "batch_move_items",
		hover = "Shift + 左键双击移动全部同类物品到对应容器",
		label = "双击移动",
		options = {
			{ description = "瞬间移动", data = "instant_move" },
			{ description = "正常移动", data = "normal_move" },
			{ description = "禁用", data = false },
		},
		default = "instant_move",
	},
	{
		name = "quick_craftslot_moving",
		hover = "Shift + 左键上/下键移动制作栏到最顶/低端",
		label = "移动制作栏到最顶/低端",
		options = boolean,
		default = true,
	},

	{
		name = "cave_clock",
		hover = "在地下点击时钟来强制显示时间/恢复正常",
		label = "地下点击时钟显示时间",
		options = {
			{ description = "默认打开", data = "default_on" },
			{ description = "默认关闭", data = "default_off" },
			{ description = "禁用", data = false },
		},
		default = "default_off",
	},
	{
		name = "bundle_first",
		hover = "先进打包裹 !",
		label = "先进打包裹",
		options = boolean,
		default = true,
	},
	{
		name = "stewer_first",
		hover = "先进厨具 !",
		label = "先进厨具",
		options = boolean,
		default = true,
	},

	-- {
	-- name = "no_lightning_flash",
	-- hover = "去除雷电闪烁",
	-- label = "去除雷电闪烁",
	-- options = boolean,
	-- default = false
	-- },

	{
		name = "操作提升2",
		label = "自动回血",
		hover = "这边可以开关自动回血哦",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,

	},
	{
		name = "key_autoheal",
		label = "自动回血",
		hover = "按下此按钮后，使用加血物品",
		options = keylist,
		default = "KEY_X",
	},
	{
		name = "sound",
		label = "反馈声音",
		hover = "播放反馈声音？",
		options = bool_opt,
		default = true,
	},
	{
		name = "debug",
		label = "调试消息",
		hover = "是否将调试消息打印到控制台？",
		options = bool_opt,
		default = false,
	},
	{
		name = "aq_changes",
		hover = "对黑化排队论的改动",
		label = "黑化排队论的改动",
		options = boolean,
		default = true,
	},
	{
		name = "drop_actionpicker",
		hover = "禁用官方新的快捷丢弃",
		label = "禁用官方快捷丢弃",
		options = boolean,
		default = true,
	},
	{
		name = "dont_click_it",
		hover = "不要点这些东西!",
		label = "不要点这些东西",
		options = boolean,
		default = true,
	},
	{
		name = "no_flower_picking",
		hover = "不要捡花!",
		label = "不要捡花",
		options = {
			{ description = "只有邪恶的花朵", data = "evil_only" },
			{ description = "仅限普通花", data = "normal_only" },
			{ description = "邪恶与正常 ", data = "no_flower" },
			{ description = "禁用", data = false },
		},
		default = "evil_only",
	},
	{
		name = "no_winch_using",
		hover = "不要用空格键使用绞盘!",
		label = "不要用空格键使用绞盘",
		options = boolean,
		default = true,
	},
	{
		name = "unblocked_castspell",
		hover = "现在你可以随意在任何地方施法了！",
		label = "随意施法",
		options = boolean,
		default = true,
	},
	{
		name = "modsscreen_lag_reducer",
		hover = "减少部分mod界面卡顿",
		label = "减少部分mod��面卡顿",
		options = boolean,
		default = true,
	},
	AddTitle("改进排队论设置"),
	{
		name = "double_click_speed",
		hover = "双击速度",
		label = "双击速度",
		options = {
			{ description = "0.2s", data = 0.2 },
			{ description = "0.3s", data = 0.3 },
			{ description = "0.4s", data = 0.4 },
			{ description = "0.5s", data = 0.5 },
		},
		default = 0.3,
	},
	{
		name = "no_leftclick_evilflower",
		hover = "左键不会捡起恶魔花",
		label = "左键不会捡起恶魔花",
		options = boolean,
		default = false,
	},
	{
		name = "low_dur_first",
		hover = "自动重新装备会先装备低耐久物品",
		label = "重新装备",
		options = boolean,
		default = true,
	},
	{
		name = "autowrap",
		hover = "当使用批量移动时如果目标包裹已满并且装的物品都是同类的时候自动打包",
		label = "自动打包",
		options = boolean,
		default = false,
	},
	{
		name = "tilling_spacing",
		hover = "耕地间距（不包含暴食）",
		label = "耕地间距",
		options = {
			{ description = "分钟(1.25)", data = "min" },
			{ description = "1.33", data = 1.33 },
			{ description = "1.5", data = 1.5 },
		},
		default = 1.33,
	},
	{
		name = "allow_all_open_containers",
		hover = "允许排队论从所有打开的容器里拿取物品",
		label = "排队论拿取物品",
		options = boolean,
		default = true,
	},
	{
		name = "rmb_pickup_setting",
		hover = "允许排队论右键选择捡起雕像",
		label = "捡起雕像",
		options = {
			{ description = "全部允许", data = "all" },
			{ description = "只有你的大理石", data = "sus_marbles_only" },
			{ description = "禁用", data = false },
		},
		default = "sus_marbles_only",
	},
	{
		name = "no_keepnone",
		hover = "不会让有些东西不能选中（用来兼容有些mod）",
		label = "不让选中",
		options = boolean,
		default = false,
	},

	AddTitle("按键设置"),
	{
		name = "attack_lureplant",
		hover = "启动攻击食人花的按键",
		label = "启动攻击食人花的按键",
		options = keylist,
		default = "KEY_G",
	},
	{
		name = "honey_collector",
		hover = "启动点燃并收获蜂箱的按键",
		label = "启动点燃并收获蜂箱的按键",
		options = keylist,
		default = "KEY_L",
	},
	{
		name = "auto_reequip_weapons",
		hover = "自动重新装备武器的按键",
		label = "自动重新装备武器的按键",
		options = keylist_2,
		default = "no_toggle_key",
	},
	{
		name = "fish_killer",
		hover = "启动杀鱼的按键",
		label = "启动杀鱼的按键",
		options = keylist,
		default = "KEY_END",
	},
	{
		name = "repeat_compare_fishes",
		hover = "重复比较鱼重量的按键",
		label = "重复比较鱼重量的按键",
		options = keylist,
		default = false,
	},

	{
		name = "easy_steering_boat",
		hover = "使用最近舵的按键",
		label = "使用最近舵的按键",
		options = keylist,
		default = false,
	},
	{
		name = "easy_anchor_using",
		hover = "使用最近锚的按键",
		label = "使用最近锚的按键",
		options = keylist,
		default = false,
	},
	{
		name = "rescue_key",
		hover = "发rescue到服务器的按键",
		label = "发rescue到服务器的按键",
		options = keylist,
		default = false,
	},
	AddTitle("不拾取类型"),
	CreateAreOneSetting("鹿角", "antlers", "鹿角"),
	CreateAreOneSetting("贝壳", "shells", "贝壳"),
	CreateAreOneSetting("小玩具", "trinkets", "小玩具"),
	CreateAreOneSetting("节日挂饰", "winter_ornaments", "节日挂饰"),
	CreateAreOneSetting("节日彩灯", "winter_lights", "节日彩灯"),
	CreateAreOneSetting("冬季盛宴零食", "winter_foods", "冬季盛宴零食", true),
	CreateAreOneSetting("万圣节挂饰", "halloween_ornaments", "万圣节挂饰"),
	CreateAreOneSetting("万圣节糖果", "halloween_candies", "万圣节糖果"),
	CreateAreOneSetting("种子", "seeds", "种子", true),
	CreateAreOneSetting("种下的蔬菜", "plants", "种下的蔬菜"),
	CreateAreOneSetting("巨大蔬菜", "giant_veggies", "巨大蔬菜"),
	CreateAreOneSetting("蓝图/稿纸/广告", "recipe_papers", "蓝图/稿纸/广告"),
	{
		name = "9999995599999965",
		label = "操作提升设置结束",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},

	{
		name = "999999555",
		label = "坐标系统设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "坐标菜单风格",
		label = "坐标菜单风格样式",
		hover = "选择坐标菜单界面的风格",
		options = {
			{ description = "简约风格", data = 0 },
			{ description = "普通风格", data = 1 },
		},
		default = 1,
	},
	{
		name = "坐标菜单按键",
		label = "坐标菜单按键",
		hover = "设置快捷键 快速打开坐标菜单界面",
		options = keys_opt,
		default = 261,
	},
	-- {
	-- name = "坐标菜单导航图标",
	-- label = "坐标菜单导航图标 隐藏-可见 切换键",
	-- hover = "一键切换导航图标的可视和隐藏",
	-- options = keys_opt,
	-- default = 0,
	-- },
	{
		name = "坐标菜单窗口宽度",
		label = "坐标菜单窗口宽度",
		hover = "如果你没有要求，那就默认吧",
		options = sizeList,
		default = 360,
	},
	{
		name = "坐标菜单窗口高度",
		label = "坐标菜单窗口高度",
		hover = "如果你没有需求，那还是默认吧",
		options = sizeList,
		default = 480,
	},
	{
		name = "坐标颜色处理",
		label = "坐标颜色的多样性",
		hover = "当编辑标记点时，需要多少颜色可用",
		options = {
			{ description = "单调", data = 15 },
			{ description = "少量变化", data = 10 },
			{ description = "适中的", data = 8 },
			{ description = "丰富的", data = 6 },
			{ description = "眼花缭乱", data = 3 },
		},
		default = 8,
	},
	{
		name = "坐标菜单ui设置",
		label = "显示新的坐标UI",
		hover = "在地图UI的上方增加一个坐标UI通过点击进入坐标菜单",
		options = {
			{ description = "显示", data = false },
			{ description = "不显示", data = true },
		},
		default = true,
	},
	{
		name = "坐标系统自定义路径",
		label = "禁用自定义系统坐标路径",
		hover = "禁用可以自行添加路径点的功能",
		options = {
			{ description = "不禁用", data = false },
			{ description = "禁用", data = true },
		},
		default = false,
	},
	{
		name = "坐标系统导航图标",
		label = "坐标系统导航图标是否会一直显示",
		hover = "如果不嫌弃很乱可以开启哦",
		options = {
			{ description = "不会一直显示", data = false },
			{ description = "会一直显示", data = true },
		},
		default = false,
	},
	{
		name = "95555555",
		label = "地图系统设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "BLENDMODE",
		label = "地图混合",
		hover = "默认值：加法",
		options = {
			{ description = "无效 ", data = 0 },
			{ description = "阿尔法混合", data = 1 },
			{ description = "加法", data = 2 },
			{ description = "预乘", data = 3 },
			{ description = "反向", data = 4 },
			{ description = "阿尔法加", data = 5 },
			{ description = "VFX测试", data = 6 },
		},
		default = 2,
	},
	{
		name = "BLENDMODE_BG",
		label = "背景混合模式",
		hover = "默认值：阿尔法混合",
		options = {
			{ description = "无效 ", data = 0 },
			{ description = "阿尔法混合", data = 1 },
			{ description = "加法", data = 2 },
			{ description = "预乘", data = 3 },
			{ description = "反向", data = 4 },
			{ description = "阿尔法加", data = 5 },
			{ description = "VFX测试", data = 6 },
		},
		default = 1,
	},
	{
		name = "判定地图方位",
		label = "判定地图方位",
		options = {
			{ description = "0, 北", data = 0 },
			{ description = "45, 东北", data = -45 },
			{ description = "90, 东", data = -90 },
			{ description = "135, 东南", data = -135 },
			{ description = "180, 南", data = -180 },
			{ description = "225, 西南", data = -225 },
			{ description = "270, 西", data = -270 },
			{ description = "315, 西北", data = -315 },
		},
		default = 0,
	},
	{
		name = "显示地图方位",
		label = "在地图上显示字符方向",
		options = {
			{ description = "显示", data = true },
			{ description = "不显示", data = false },
		},
		default = true,
	},
	{
		name = "999999",
		label = "超高数据显示设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "UNIT",
		label = "温度单位",
		hover = "做正确的事情，把它留在游戏中。",
		options = {
			{ description = "游戏单位", data = "T", hover = "游戏使用的温度数字." },
			{
				description = "摄氏度",
				data = "C",
				hover = "游戏中使用的温度数字，但减半后更为合理。",
			},
			{
				description = "华氏温度",
				data = "F",
				hover = "你最喜欢的温度单位毫无意义。",
			},
		},
		default = "T",
	},
	{
		name = "SHOWMOON",
		label = "显示月亮",
		hover = "显示月亮在白天和黄昏时的月相。",
		options = {
			{ description = "只夜晚", data = 0, hover = "显示月亮只在晚上，像往常一样。" },
			{ description = "黄昏夜晚", data = 1, hover = "显示夜晚和黄昏的月亮。" },
			{ description = "全天显示", data = 2, hover = "显示任何时候都是月亮。." },
		},
		default = 1,
	},

	{
		name = "FLIPMOON",
		label = "翻转月亮",
		hover = "翻转月亮阶段（是恢复旧行为）",
		options = {
			{ description = "Yes", data = true, hover = "显示 月亮好像在南半球。" },
			{ description = "No", data = false, hover = "显示 月亮好像在北半球。" },
		},
		default = false,
	},
	{
		name = "SEASONOPTIONS",
		label = "季节时钟",
		hover = "添加一个显示季节的时钟，并重新排列状态徽章以更好地适应。",
		options = {
			{ description = "微型的", data = "Micro" },
			{ description = "紧凑的", data = "Compact" },
			{ description = "时钟", data = "Clock" },
			{ description = "No", data = "" },
		},
		default = "Clock",
	},
	{
		name = "VISIBLY_HAVE_MEDALLION",
		label = "可见性",
		hover = "设置可见性",
		options = {
			{ description = "有奖章吗", data = true },
			{ description = "总是", data = false },
		},
		default = false,
	},
	{
		name = "VISIBLE_ANIMATION",
		label = "动画",
		hover = "设置动画",
		options = {
			{ description = "有动画", data = true },
			{ description = "没有", data = false },
		},
		default = true,
	},
	{
		name = "TIMER",
		label = "计时器",
		hover = "设置计时器可见性和位置",
		options = {
			{ description = "Hide", data = "NONE" },
			{ description = "Top", data = "TOP" },
			{ description = "Bottom", data = "BOTTOM" },
			{ description = "Center", data = "CENTER" },
			{ description = "Left", data = "LEFT" },
			{ description = "Right", data = "RIGHT" },
		},
		default = "BOTTOM",
	},
	{
		name = "PHASE_NAME",
		label = "阶段名称",
		hover = "设置阶段名称可见性和位置",
		options = {
			{ description = "Hide", data = "NONE" },
			{ description = "Top", data = "TOP" },
			{ description = "Bottom", data = "BOTTOM" },
			{ description = "Center", data = "CENTER" },
			{ description = "Left", data = "LEFT" },
			{ description = "Right", data = "RIGHT" },
		},
		default = "CENTER",
	},
	{
		name = "HORIZONTAL_ALIGNMENT",
		label = "水平对齐",
		hover = "设置水平对齐方式",
		options = {
			{ description = "Left", data = "LEFT" },
			{ description = "Center", data = "CENTER" },
			{ description = "Right", data = "RIGHT" },
		},
		default = "CENTER",
	},
	{
		name = "VERTICAL_ALIGNMENT",
		label = "垂直对齐",
		hover = "设置垂直对齐方式",
		options = {
			{ description = "Top", data = "TOP" },
			{ description = "Center", data = "CENTER" },
			{ description = "Bottom", data = "BOTTOM" },
		},
		default = "TOP",
	},
	{
		name = "洞穴钟水平边距",
		label = "洞穴钟水平边距",
		hover = "没需求不要改",
		options = horizontal_margin_options,
		default = 0,
	},
	{
		name = "洞穴钟垂直边距",
		label = "垂直边距",
		hover = "没需求不要改",
		options = vertical_margin_options,
		default = 50,
	},
	{
		name = "洞穴钟比例大小",
		label = "洞穴钟比例",
		hover = "设置比例-只能缩小",
		options = {
			{ description = "100%", data = 1 },
			{ description = "90%", data = 0.9 },
			{ description = "80%", data = 0.8 },
			{ description = "70%", data = 0.7 },
			{ description = "60%", data = 0.6 },
			{ description = "50%", data = 0.5 },
			{ description = "40%", data = 0.4 },
			{ description = "30%", data = 0.3 },
		},
		default = 1,
	},
	{
		name = "机器电池",
		label = "文本格式",
		options = {
			{ description = "dd-mm:ss", data = "daydash", hover = "[游戏日]d-[分钟]：[秒]" },
			{ description = "dd:mm:ss", data = "day", hover = "[游戏日]：[分钟]：[秒]" },
			{ description = "hh:mm:ss", data = "hour", hover = "[小时]：[分钟]：[秒]" },
			{ description = "mm:ss", data = "minute", hover = "[分钟]：[秒]" },
			{ description = "ss", data = "second", hover = "[秒]" },
		},
		default = "hour",
		hover = "为要显示的充电时间选择自定义格式。",
	},
	{
		name = "HUDSCALEFACTOR",
		label = "HUD比例",
		hover = "如果没有需求 请不要改动",
		options = hud_scale_options,
		default = 100,
	},
	{
		name = "LANGUAGE",
		label = "显示语言",
		hover = "时钟的语言",
		options = {
			{ description = "简体中文", hover = "简体中文", data = "npi_chs" },
		},
		default = "npi_chs",
	},
	{
		name = "三维血量字体",
		label = "字体大小",
		hover = "编辑统计数字的大小s",
		options = {
			{
				description = "50",
				data = 50,
			},
			{
				description = "45",
				data = 45,
			},
			{
				description = "40",
				data = 40,
			},
			{
				description = "33 (Default)",
				data = 33,
			},
			{
				description = "25",
				data = 25,
			},
			{
				description = "20",
				data = 20,
			},
			{
				description = "15",
				data = 15,
			},
			{
				description = "10",
				data = 10,
			},
		},
		default = 33,
	},
	{
		name = "3299565232",
		label = "输入优化设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "colorselected",
		label = "选定的颜色",
		hover = "更改聊天窗口中选定快捷方式的颜色。",
		options = colors,
		default = 1,
	},
	{
		name = "colorunselected",
		label = "未选择的颜色 ",
		hover = "更改聊天窗口中未选定快捷方式的颜色。 ",
		options = colors,
		default = 2,
	},
	{
		name = "maxRows",
		label = "最大快捷方式行数 ",
		hover = "决定快捷方式建议中显示的最大行数。 ",
		options = numberoptions,
		default = 7,
	},
	{
		name = "ignoreCase",
		label = "不区分大小写 ",
		hover = "允许使用快捷菜单而不考虑大小写。 ",
		--	hover = "Ignores uppper and lowercase when searching for the right word.",
		options = booleanoptions,
		default = true,
	},
	{
		name = "emojiTranslate",
		label = "调整表情符号 ",
		hover = "通过Tab/Enter在菜单中选择表情符号将在聊天屏幕中显示所选表情符号，而不是其输入代码。",
		options = booleanoptions,
		default = false,
	},
	{
		name = "dummy1",
		label = "表情符号快捷方式 ",
		hover = SS_text .. "\n" .. Emoji_text,
		options = { { data = 0, description = ":" .. space } },
		default = 0,
	},
	{
		name = "emojiNumChars",
		label = "表情符号计数 ",
		hover = CC_text .. "\n" .. Emoji_text,
		options = numberoptionssmall,
		default = 0,
	},
	{
		name = "emojiDisplay",
		label = "表情符号快捷方式显示 ",
		hover = "在快捷菜单中定义所选表情符号的标记" .. Emoji_text,
		options = {
			{ data = "", description = "禁用" },
			{ data = false, description = "标准" },
			{ data = "●", description = "圆圈" },
			{ data = "■", description = "正方形" },
			{ data = "♥", description = "心心" },
			{ data = "←", description = "箭头" },
		},
		default = false,
	},
	{
		name = "dummy2",
		label = "表情快捷符号 ",
		hover = SS_text .. "\n" .. Emote_text,
		options = { { data = 0, description = "/" .. space } },
		default = 0,
	},
	{
		name = "emoteNumChars",
		label = "表情字符计数",
		hover = CC_text .. "\n" .. Emote_text,
		options = numberoptionssmall,
		default = 1,
	},
	{
		name = "playerDelim",
		label = "播放器快捷方式符号",
		hover = SS_text .. "\n" .. Player_text,
		options = delims,
		default = "@",
	},
	{
		name = "playerNumChars",
		label = "玩家角色计数 ",
		hover = CC_text .. "\n" .. Player_text,
		options = numberoptionssmall,
		default = 0,
	},
	{
		name = "objectDelim",
		label = "对象快捷方式符号 ",
		hover = SS_text .. "\n" .. Object_text,
		options = delims,
		default = "#",
	},
	{
		name = "objectNumChars",
		label = "对象字符计数 ",
		hover = CC_text .. "\n" .. Object_text,
		options = numberoptionssmall,
		default = 3,
	},
	{
		name = "objectLowerCase",
		label = "对象小写 ",
		hover = "小写：将只搜索和写入小写对象。\n调整：如果输入为小写，则输出为小写。 ",
		options = {
			{ data = false, description = "标准" },
			{ data = true, description = "小写字母" },
			{ data = "adjust", description = "调整" },
		},
		default = false,
	},

	{
		name = "prefabDelim",
		label = "预制快捷方式符号",
		hover = SS_text .. "\n" .. Prefab_text,
		options = delims,
		default = false,
	},
	{
		name = "prefabNumChars",
		label = "预制字符计数",
		hover = CC_text .. "\n" .. Prefab_text,
		options = numberoptionssmall,
		default = 0,
	},
	{
		name = "personalDelim",
		label = "个人快捷方式符号 ",
		hover = SS_text .. "\n" .. Personal_text,
		options = delims,
		default = "\\",
	},
	{
		name = "personalNumChars",
		label = "个性计数",
		hover = CC_text .. "\n" .. Personal_text,
		options = numberoptionssmall,
		default = 0,
	},
	{
		name = "323332336",
		label = "禁声系统设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "pet",
		label = "宠物饥饿时禁声 pet",
		hover = "设置宠物饥饿是否没有声音\nGet rid of the noise when the Glommer following you",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 1,
	},
	{
		name = "SilentGlommer",
		label = "格罗姆禁声 Silent Glommer",
		hover = "设置格罗姆是否没有声音\nGet rid of the noise when the Glommer following you",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "Insanity Sounds",
		label = "低脑残消除恐怖音效(Insanity Sounds)",
		options = {
			{ description = "Yes", data = 1, hover = "消除脑残降低导致的恐怖音效。" },
			{ description = "No", data = 0, hover = "啥事儿都不发生。" },
		},
		default = 1,
	},
	{
		name = "SilentMandrake",
		label = "曼德拉草禁声 Silent Mandrake",
		hover = "设置蔓德拉草跟随时是否没有声音\nGet rid of the noise when the Mandrake following you",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "SilentFiresuppressor",
		label = "灭火器禁声 Silent Firesuppressor",
		hover = "设置灭火器是否没有声音运作\nGet rid of the noise from the working firesuppressor",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "spawnportal",
		label = "恶魔门禁声 spawnportal",
		hover = "设置恶魔门是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "poop",
		label = "大便禁声 poop",
		hover = "设置大便是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 1,
	},
	{
		name = "wx78",
		label = "机器人系统过载禁声 wx78 Overcharge sound",
		hover = "设置机器人系统过载禁声是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 1,
	},
	{
		name = "bee",
		label = "蜜蜂.蜂箱禁声 bee and bee_box",
		hover = "设置蜜蜂.蜂箱是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "birdtrap",
		label = "捕鸟器禁声 birdtrap",
		hover = "设置恶魔门是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 1,
	},
	{
		name = "bird",
		label = "鸟（包括鸟笼）禁声 bird",
		hover = "设置鸟（包括鸟笼里的鸟）是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "lucy",
		label = "露西斧禁声 lucy",
		hover = "设置露西斧是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "frog",
		label = "青蛙禁声 frog",
		hover = "设置青蛙是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "deciduous",
		label = "桦树精禁声 deciduous",
		hover = "设置桦树精是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "overheat",
		label = "过冷过热禁声 overheat freeze",
		hover = "设置过冷过热是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "houndwarning",
		label = "猎狗袭击前禁声 houndwarning",
		hover = "设置猎狗袭击前是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "summer-ABM",
		label = "禁止夏天的某种音效 summer-ABM",
		hover = "设置夏天的某种音效是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "spider",
		label = "禁蜘蛛喊叫  spider scream",
		hover = "设置蜘蛛喊叫的是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "ghosts",
		label = "禁止鬼魂（包括阿比盖尔）  ghosts and abigail",
		hover = "设置鬼魂（包括阿比盖尔）是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "mosquito",
		label = "禁止蚊子  mosquito",
		hover = "设置沼泽蚊子是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "staff",
		label = "禁止矮星和极光  staff_star,coldlight",
		hover = "设置矮星和极光是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "chester",
		label = "禁止切斯特走路  chester",
		hover = "设置切斯特走路是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "lureplants",
		label = "禁止食人花  lureplants",
		hover = "设置食人花是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "thunder",
		label = "禁止打雷  thunder",
		hover = "设置打雷是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "perd",
		label = "禁止火鸡  turkey",
		hover = "设置火鸡是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "buzzard",
		label = "禁止秃鹫  buzzard",
		hover = "设置秃鹫是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "shadowhand",
		label = "禁止抓火黑手  shadowhand",
		hover = "设置抓火黑手是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "dragonflyfurnace",
		label = "禁止龙鳞火炉  dragonflyfurnace",
		hover = "设置龙鳞火炉是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "rabbit",
		label = "禁止兔子 rabbit",
		hover = "设置小兔子是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "mole",
		label = "禁止鼹鼠 mole",
		hover = "设置鼹鼠是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "catcoon",
		label = "禁止浣熊猫  catcoon",
		hover = "设置鼹鼠是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "researchmachine",
		label = "禁止靠近科技的声音 researchmachine",
		hover = "设置靠近科技是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	{
		name = "grassgekko",
		label = "禁止草蜥蜴的声音 grassgekko",
		hover = "设置草蜥蜴是否没有声音",
		options = {
			{ description = "Yes", data = 1 },
			{ description = "No", data = 0 },
		},
		default = 0,
	},
	CreateDisableSoundSetting("Pets", "pets", "pets's begging noise", "宠物要食物的声音"),
	CreateDisableSoundSetting("Lucy", "lucy", "lucy's talking noise", "渣男老婆"),
	CreateDisableSoundSetting("Sandstorm", "sandstorm", "sandstorm's noise", "沙暴噪音"),
	CreateDisableSoundSetting("Overcharge", "overcharge", "WX78's overcharge noise", "机器人过载噪音"),
	CreateDisableSoundSetting("Think Tank", "tink_tank", "think tank", "智囊团"),
	CreateDisableSoundSetting("Friendly Fruit Fly", "friendlyfruitfly", "friendly fruit fly's noise", "友善果蝇的噪声"),
	CreateDisableSoundSetting("Put On The Meat Rack", "dry", "putting things on the meat rack's sound", "晒肉的声音"),
	{
		name = "32333233",
		label = "快捷宣告设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "语言检测",
		label = "选择你的语言",
		hover = "只有中文",
		options = {
			{ description = "简体中文", data = "chinese", hover = "始终为简体中文。" },
		},
		default = "chinese",
	},
	{
		name = "WHISPER",
		label = "默认宣告为密语",
		hover = "习惯性设置，在游戏中宣告可以加 Ctrl 键互相切换私密与公开",
		options = {
			{ description = "开", data = true, hover = "Alt+Shift 宣告只有附近玩家能看到。" },
			{ description = "关", data = false, hover = "Alt+Shift 宣告全部玩家都能看到。" },
		},
		default = false,
	},
	{
		name = "EXPLICIT",
		label = "显示(当前值)/(最大值)",
		hover = "在宣告三维状态时，是否显示当前值和最大值。(Current)/(Max)",
		options = {
			{ description = "是", data = true, hover = "开启是正确的选择。" },
			{ description = "否", data = false, hover = "关闭后异常的尴尬。" },
		},
		default = true,
	},
	{
		name = "SHOWPROTOTYPER",
		label = "宣告标准原型体",
		hover = "宣告制定配方时，是否要宣告“你需要一个科学机器”或“一个原型样本”。",
		options = {
			{ description = "是", data = true, hover = "" },
			{ description = "否", data = false, hover = "" },
		},
		default = true,
	},
	{
		name = "SHOWEMOJI",
		label = "宣告三维符号",
		hover = "宣布数据时，用三维符号来表示 (若不使用 \"当前值/最大值\").",
		options = {
			{ description = "是", data = true },
			{ description = "否", data = false },
		},
		default = true,
	},
	{
		name = "SHOWDURABILITY",
		label = "宣告装备耐久性",
		hover = "是否要宣告一个装备的耐久性或耐用时限。",
		options = {
			{ description = "是", data = true, hover = "" },
			{ description = "否", data = false, hover = "" },
		},
		default = true,
	},
	{
		name = "OVERRIDEB",
		label = "手柄控制器宣告",
		hover = "当使用手柄控制器且库存是打开时，允许用 B (取消按钮) 来宣告 体温。",
		options = {
			{ description = "是", data = true, hover = "" },
			{ description = "否", data = false, hover = "" },
		},
		default = true,
	},
	{
		name = "OVERRIDESELECT",
		label = "手柄控制器地图宣告",
		options = {
			{ description = "是", data = true },
			{ description = "否", data = false },
		},
		default = true,
		hover = "当使用手柄且库存是打开时, 允许使用按钮 选择/地图 来宣布季节\n你必须正在使用Mod：Combined Status(季节时钟).",
	},
	{
		name = "WILSON",
		label = "定制科学家 威尔逊语录",
		hover = "当你是威尔逊时，会宣告科学家专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WILLOW",
		label = "定制玩火者 薇洛语录",
		hover = "当你是薇洛时，会宣告玩火者专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WX78",
		label = "定制机器人 WX-78语录",
		hover = "当你是WX-78时，会宣告机器人专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WICKERBOTTOM",
		label = "定制图管员 维克波顿语录",
		hover = "当你是维克波顿时，会宣告图书管理员专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WOLFGANG",
		label = "定制大力士 沃尔夫冈语录",
		hover = "当你是沃尔夫冈时，会宣告大力士专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WENDY",
		label = "定制丧亲者 温蒂语录",
		hover = "当你是温蒂时，会宣告丧失亲人者专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WOODIE",
		label = "定制啃木人 伍迪语录",
		hover = "当你是伍迪时，会宣告异食癖专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WES",
		label = "定制表演家 维斯语录",
		hover = "当你是维斯时，会宣告表演家专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WAXWELL",
		label = "定制暗法师 麦斯威尔语录",
		hover = "当你是麦斯威尔时，会宣告暗影魔法师专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WEBBER",
		label = "定制蜘蛛人 韦帕语录",
		hover = "当你是韦帕时，会宣告蜘蛛人专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WATHGRITHR",
		label = "定制女战神 瓦弗德语录",
		hover = "当你是瓦弗德时，会宣告战武神专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WINONA",
		label = "定制女巧工 薇诺娜语录",
		hover = "当你是薇诺娜时，会宣告女巧工专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WORMWOOD",
		label = "定制植物人 苦艾语录",
		hover = "当你是苦艾时，会宣告植物人专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WURT",
		label = "定制小鱼人 沃特语录",
		hover = "当你是沃特时，会宣告小鱼人专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WORTOX",
		label = "定制小恶魔 沃拓克斯语录",
		hover = "当你是苦艾时，会宣告沃拓克斯专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WARLY",
		label = "定制大厨 沃利语录",
		hover = "当你是沃利时，会宣告大厨专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WALANI",
		label = "定制冲浪者 瓦拉里语录",
		hover = "当你是瓦拉里时，会宣告冲浪者专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WOODLEGS",
		label = "定制海盗船长 木腿语录",
		hover = "当你是木腿时，会宣告海盗船长专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "WILBUR",
		label = "定制小红猪 威尔伯语录",
		hover = "当你是威尔伯时，会宣告猪公主专有语录。",
		options = {
			{ description = "开", data = true },
			{ description = "关", data = false },
		},
		default = true,
	},
	{
		name = "32333233",
		label = "快捷表情设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "G快捷键",
		label = "开关按钮",
		hover = "你需要按着按钮才可以打开G表情",
		options = keyslist,
		default = "G", --G
	},
	{
		name = "SCALEFACTOR",
		label = "菜单尺寸",
		hover = "菜单有多大尺寸",
		options = scalefactors,
		default = 1,
	},
	{
		name = "IMAGETEXT",
		label = "显示图片/文本",
		options = {
			{ description = "两者", data = 3 },
			{ description = "仅是图片", data = 2 },
			{ description = "仅是文本", data = 1 },
		},
		default = 3,
	},
	{
		name = "CENTERWHEEL",
		label = "中心轮",
		options = {
			{ description = "启用", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
	},
	{
		name = "RESTORECURSOR",
		label = "恢复光标位置",
		hover = "如果控制盘居中，则在选择前后移动鼠标的位置。",
		options = {
			{
				description = "相对",
				data = 3,
				hover = "将光标放置在没有移动到控制盘中心的位置",
			},
			{
				description = "绝对",
				data = 2,
				hover = "将光标放在控制盘之前的位置，通过移动选择表情",
			},
			{
				description = "居中",
				data = 1,
				hover = "仅将光标置于控制盘的中心，选择后不移动光标。",
			},
			{
				description = "关闭",
				data = 0,
				hover = "从不移动光标。可能已经根据光标之前所在的位置选择了",
			},
		},
		default = 3,
	},
	{
		name = "RIGHTSTICK",
		label = "控制器",
		hover = "使用哪个控制器模拟棒来选择轮子上的表情.",
		options = {
			{ description = "左", data = false },
			{ description = "右", data = true },
		},
		default = false,
	},
	{
		name = "ONLYEIGHT",
		label = "限制为8",
		hover = "将控制盘限制为8个表情，由下面选项中的选择决定。" .. "\n请注意，在/shunk之后的选项需要由emote项解锁。",
		options = {
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = false,
	},
	{
		name = "EIGHT1",
		label = "右表情",
		hover = "这将直接显示在右侧。",
		options = eight_options,
		default = "wave",
	},
	{
		name = "EIGHT2",
		label = "右上角表情",
		hover = "这将显示对角线向上的权利。",
		options = eight_options,
		default = "dance",
	},
	{
		name = "EIGHT3",
		label = "上表情",
		hover = "这将直接显示出来",
		options = eight_options,
		default = "happy",
	},
	{
		name = "EIGHT4",
		label = "左上表情",
		hover = "这将显示对角线向上左。",
		options = eight_options,
		default = "bonesaw",
	},
	{
		name = "EIGHT5",
		label = "左表情",
		hover = "这将直接显示在左侧。",
		options = eight_options,
		default = "rude",
	},
	{
		name = "EIGHT6",
		label = "左下表情",
		hover = "这将显示在左下角的对角线上。",
		options = eight_options,
		default = "facepalm",
	},
	{
		name = "EIGHT7",
		label = "下表情",
		hover = "这将直接向下显示。",
		options = eight_options,
		default = "sad",
	},
	{
		name = "EIGHT8",
		label = "右下表情",
		hover = "这将显示对角线右下。",
		options = eight_options,
		default = "kiss",
	},
	{
		name = "3233323344",
		label = "信息显示设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "INFO_SCALE",
		label = "信息比例",
		hover = "设置工具提示的信息比例",
		options = ScaleValues,
		default = 0.8,
	},
	{
		name = "TIME_FORMAT",
		label = "时间格式",
		hover = "设置显示时间格式",
		options = {
			{ description = "小时制", data = 0 },
			{ description = "天数制", data = 1 },
		},
		default = 0,
	},
	{
		name = "SHOW_EDIBLE_SHANG",
		label = "显示食物三维属性",
		hover = "如服务器未开启 Show Me，可选择开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "SHOW_PERISHABLE_SHANG",
		label = "显示腐烂倒计时",
		hover = "如服务器未开启 Show Me，可选择开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "PERISHABLE",
		label = "腐烂倒计时",
		hover = "如上面选项未启用则本选项无效。设置你想要看到的方式，陈旧和腐烂倒计时",
		options = {
			{ description = "只有腐烂", data = 0 },
			{ description = "陈旧 > 腐烂", data = 1 },
			{ description = "两者皆有", data = 2 },
		},
		default = 2,
	},
	{
		name = "WURT_MEAT",
		label = "小鱼人沃特 | 肉料统计",
		hover = "设置为开启并玩沃特时，你将看到肉类料理统计(饥饿、理智、健康)",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "WIG_VEGGIE",
		label = "女武神薇格弗德 | 素料统计",
		hover = "设置为开启并玩女武神时，你将看到素类料理统计(饥饿，理智，健康)",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "WORM_HEALTH",
		label = "植物人沃姆伍德 | 料理健康统计",
		hover = "设置为开启并玩植物人时，你将看到料理的生命值加成",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "SHOW_INFO_HANDS",
		label = "显示手部装备",
		hover = "如果你想看到你的手装备项目信息可设置成开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "SHOW_INFO_BODY",
		label = "显示身体装备",
		hover = "如果你想看到你的身体装备项目信息可设置成开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "SHOW_INFO_HEAD",
		label = "显示头部装备",
		hover = "如果你想看到你的头装备项目信息可设置成开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = true,
	},
	{
		name = "EQUIP_SCALE",
		label = "装备信息比例",
		hover = "设置装备物品信息比例。这不会影响工具提示",
		options = ScaleValues,
		default = 0.5,
	},
	{
		name = "SHOW_PREFABNAME",
		label = "物品代码名称(Prefab name)",
		hover = "如果你想看到物品的代码名称可设置为开启，身为Mods制作者感觉此功能真香",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,
	},
	{
		name = "SHOW_BACKGROUND",
		label = "显示背景",
		hover = "巨丑建议关闭，如果你想看到装备信息的背景可设置为开启",
		options = {
			{ description = "开启", data = true },
			{ description = "禁用", data = false },
		},
		default = false,
	},
	{
		name = "HORIZONTAL_MARGIN",
		label = "下边距",
		hover = "设置装备信息底部边缘",
		options = MarginValues,
		default = 100,
	},
	{
		name = "VERTICAL_MARGIN",
		label = "右边距",
		hover = "设置装备信息右边边缘",
		options = MarginValues,
		default = 100,
	},
	{
		name = "ONCLICK",
		label = "避雷针单击显示范围",
		default = true,
		options = {
			{
				description = "启用",
				data = true,
			},
			{
				description = "禁用",
				data = false,
			},
		},
	},
	{
		name = "ONBUILD",
		label = "放置建筑时显示避雷针范围",
		default = true,
		options = {
			{
				description = "启用",
				data = true,
			},
			{
				description = "禁用",
				data = false,
			},
		},
	},
	{
		name = "ONHELP",
		label = "使用草叉显示避雷针范围",
		default = true,
		options = {
			{
				description = "启用",
				data = true,
			},
			{
				description = "禁用",
				data = false,
			},
		},
	},
	{
		name = "ONCLICK_TIME",
		label = "显示“x”秒",
		default = 30,
		options = {
			{
				description = "5",
				data = 5,
			},
			{
				description = "10",
				data = 10,
			},
			{
				description = "15",
				data = 15,
			},
			{
				description = "20",
				data = 20,
			},
			{
				description = "25",
				data = 25,
			},
			{
				description = "30",
				data = 30,
			},
			{
				description = "35",
				data = 35,
			},
			{
				description = "40",
				data = 40,
			},
			{
				description = "45",
				data = 45,
			},
			{
				description = "50",
				data = 50,
			},
			{
				description = "55",
				data = 55,
			},
			{
				description = "60",
				data = 60,
			},
		},
	},
	{
		name = "9",
		label = "几何布局设置",
		options = {
			{ description = "", data = 0 },
		},
		default = 0,
	},

	{
		name = "CTRL",
		label = "Ctrl切换MOD状态",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = false,
		hover = "按住Ctrl键是否启用或禁用MOD.",
	},
	{
		name = "KEYBOARDTOGGLEKEY",
		label = "修改配置按键",
		options = keyslist,
		default = "B",
		hover = "在游戏内修改MOD配置的启动键.",
	},
	{
		name = "GEOMETRYTOGGLEKEY",
		label = "切换键",
		options = keyslist,
		default = "V",
		hover = "一键切换到最近使用的几何\n(例如，方形和X-六角形的切换)",
	},
	{
		name = "SNAPGRIDKEY",
		label = "网格按钮",
		options = keyslist,
		default = "",
		-- hover = "A key to snap the grid to have a point centered on the hovered object or point. No controller binding.\nI recommend setting this with the Settings menu in DST.",
		hover = "捕捉栅格以使点位于悬停对象或点的中心的关键点。没有控制器绑定。.",
	},
	{
		name = "SHOWMENU",
		label = "游戏内菜单",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
		hover = "默认'B'，如果打开，按修改配置按键启动.\n如果关闭，它只能Ctrl切换开启和关闭模组.",
	},
	{
		name = "BUILDGRID",
		label = "显示构建网格",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
		hover = "是否显示构建网格.",
	},
	{
		name = "GEOMETRY",
		label = "网格几何",
		options = {
			{ description = "方形", data = "SQUARE" },
			{ description = "菱形", data = "DIAMOND" },
			{ description = "X 六角形", data = "X_HEXAGON" },
			{ description = "Z 六角形", data = "Z_HEXAGON" },
			{ description = "平 六角形", data = "FLAT_HEXAGON" },
			{ description = "尖 六角形", data = "POINTY_HEXAGON" },
		},
		default = "SQUARE",
		hover = "使用什么构建网格几何.",
	},
	{
		name = "TIMEBUDGET",
		label = "刷新速度",
		options = percent_options,
		default = 0.1,
		hover = "有多少可用时间用于刷新网格。禁用或设置过高可能会导致延迟.",
	},
	{
		name = "HIDEPLACER",
		label = "隐藏放置物体虚影",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = false,
		hover = "是否隐藏放置物，隐藏它可以帮助您更好地查看网格.",
	},
	{
		name = "HIDECURSOR",
		label = "隐藏鼠标项",
		options = {
			{ description = "隐藏所有", data = 1 },
			{ description = "显示数量", data = true },
			{ description = "显示所有", data = false },
		},
		default = false,
		hover = "是否隐藏鼠标项，以更好地查看网格.",
	},
	{
		name = "SMARTSPACING",
		label = "智能间距",
		options = {
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = false,
		hover = "Whether to adjust the spacing of the grid based on what object is being placed.\nAllows for optimal grids, but can make it hard to put things just where you want them.",
	},
	{
		name = "ACTION_TILL",
		label = "犁地网格",
		options = {
			{ description = "On", data = true },
			{ description = "Off", data = false },
		},
		default = true,
		hover = "是否使用网格耕作农田土壤。使用“捕捉耕作”模块时，该功能会自动关闭。",
	},
	{
		name = "SMALLGRIDSIZE",
		label = "精细网格尺寸",
		options = smallgridsizeoptions,
		default = 10,
		hover = "使用精细网格(结构、植物等)的物体的网格有多大.",
	},
	{
		name = "MEDGRIDSIZE",
		label = "墙网格大小",
		options = medgridsizeoptions,
		default = 6,
		hover = "墙的格子有多大.",
	},
	{
		name = "BIGGRIDSIZE",
		label = "地皮的网格尺寸",
		options = biggridsizeoptions,
		default = 2,
		hover = "地皮/干草叉的格子有多大.",
	},
	{
		name = "GOODCOLOR",
		label = "建筑放置颜色",
		options = color_options,
		default = "whiteoutline",
		hover = "可以在其中放置建筑.",
	},
	{
		name = "BADCOLOR",
		label = "建筑不可放置颜色",
		options = color_options,
		default = "blackoutline",
		hover = "用于不能放置建筑颜色.",
	},
	{
		name = "NEARTILECOLOR",
		label = "最近的地皮颜色",
		options = color_options,
		default = "white",
		hover = "用于最近的地皮颜色.",
	},
	{
		name = "GOODTILECOLOR",
		label = "地皮放置颜色",
		options = color_options,
		default = "whiteoutline",
		hover = "可以在其中放置草皮.",
	},
	{
		name = "BADTILECOLOR",
		label = "地皮不可放置颜色",
		options = color_options,
		default = "blackoutline",
		hover = "在那里你不能放置地皮.",
	},
	{
		name = "GOODPLACERCOLOR",
		label = "建筑放置颜色",
		options = placer_color_options,
		default = "white",
		hover = "用于显示建筑放置颜色.",
	},
	{
		name = "BADPLACERCOLOR",
		label = "建筑不可放置颜色",
		options = placer_color_options,
		default = "black",
		hover = "用于显示不可放置建筑颜色.",
	},
	{
		name = "REDUCECHESTSPACING",
		label = "箱子间隔缩短",
		options = {
			{ description = "打开", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
		hover = "是否允许将箱子放在一起比正常情况更接近。",
	},
	{
		name = "CONTROLLEROFFSET",
		label = "控制器偏移",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = false,
		hover = "使用控制器，无论对象是在您的脚下（“关闭”）还是在偏移位置（“打开”）放置。.",
	},
	{
		name = "555555",
		label = "固定装备栏设置",
		options = {
			{ description = "", data = 0 },
		},
		default = 0,
	},
	{
		name = "apply_to_items",
		label = "用于什么项目",
		hover = "配置应该保存哪些项类型",

		options = {
			{ description = "装备", data = "100" },
			{ description = "装备. + 食物", data = "110" },
			{ description = "装备. + 药品", data = "101" },
			{ description = "装备. + 食物. + 药品.", data = "111" },
			{ description = "ALL", data = "all" },
		},

		default = "100",
	},

	{
		name = "show_slot_icons",
		label = "是否显示插槽上方的图标",
		hover = "显示保存的项目在其保存的插槽上方的图标,单击图标以清除该项目保存的插槽",

		options = {
			{ description = "开启", data = true },
			{ description = "隐藏", data = false },
		},

		default = true,
	},

	{
		name = "slot_icon_opacity",
		label = "图标透明度",
		hover = "图标透明度",

		options = percentage_options,
		default = 0.75,
	},

	{
		name = "slot_icon_scale",
		label = "图标大小",
		hover = "图标大小",

		options = percentage_options,
		default = 0.75,
	},

	{
		name = "slot_icon_offset",
		label = "图标垂直偏移",
		hover = "图标垂直偏移",

		options = offset_options,
		default = 1,
	},

	{
		name = "disable_save_slots_toggle",
		label = "禁用保存槽切换",
		hover = "键组合,将切换保存槽开/关",
		options = disable_save_slot_toggle_options,
		default = false,
	},

	{
		name = "save_slots_initial_state",
		label = "保存槽初始状态",
		hover = "保存插槽行为的初始状态,仅在配置切换键时使用.",

		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},

		default = false,
	},

	{
		name = "disable_slot_icon_click_when_save_slots_off",
		label = "禁用插槽图标点击",
		hover = "禁用插槽图标点击",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = false,
	},

	{
		name = "allow_equip_for_space",
		label = "为空间配备装备",
		hover = "允许一个物品使用空槽，以便为即将到来的物品腾出空间",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
	},

	{
		name = "reserve_saved_slots",
		label = "图标栏只能放对应物品",
		hover = "确定是否保存的插槽将保留他们的项目,如果这只发生在有其他空位的时",

		options = {
			{ description = "关闭", data = false },
		},

		default = false,
	},

	{
		name = "dst_save_items_on_spawn",
		label = "保存项目",
		hover = "保存所有物品的槽在库存时产生,帮助在恢复或进入洞穴时恢复保存的槽",

		options = {
			{ description = "Enabled", data = true },
			{ description = "Disabled", data = false },
		},

		default = true,
	},

	{
		name = "3233323d",
		label = "黑化排队论设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	AddConfig("排队论按键", "action_queue_key", keylist, "KEY_LSHIFT"),
	AddConfig("始终清除队列", "always_clear_queue", boolean, true),
	AddConfig("选择颜色", "selection_color", colorlist, "WHITE"),
	AddConfig("选择不透明度", "selection_opacity", BuildNumConfig(5, 95, 5, true), 0.5),
	AddConfig("双击速度", "double_click_speed", BuildNumConfig(0, 0.5, 0.05), 0.3),
	AddConfig("双击范围", "double_click_range", BuildNumConfig(10, 60, 5), 25),
	AddConfig("草皮网格切换键", "turf_grid_key", keylist, "KEY_F3"),
	AddConfig("草皮网格半径", "turf_grid_radius", BuildNumConfig(1, 50, 1), 5),
	AddConfig("草皮网格颜色", "turf_grid_color", colorlist, "WHITE"),
	AddConfig("始终部署在网格上", "deploy_on_grid", boolean, false),
	AddConfig("自动收集切换键", "auto_collect_key", keylist, "KEY_F4"),
	AddConfig("默认情况下启用自动收集", "auto_collect", boolean, false),
	AddConfig("无限展开切换键", "endless_deploy_key", keylist, "KEY_F6"),
	AddConfig("默认情况下启用部署", "endless_deploy", boolean, false),
	AddConfig("制作最后一个配方键", "last_recipe_key", keylist, "KEY_C"),
	AddConfig("齿阱间距", "tooth_trap_spacing", BuildNumConfig(1, 4, 0.5), 2),
	AddConfig("农田耕作网", "farm_grid", gridlist, "3x3"), -- 201221 null: change between farm Tilling grids (3x3, 4x4)
	AddConfig("UI是否可见", "visiblesnaps", boolean, true),
	AddConfig("自动耕田按键", "keychagemode", keylist, "KEY_P"),
	AddConfig("启用双蛇行", "double_snake", boolean, false), -- 210127 null: support for snaking within snaking
	AddConfig("启用调试模式", "debug_mode", boolean, false),
	{
		name = "3233323",
		label = "自动钓鱼设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		label = "自动钓鱼",
		hover = [[鱼上钩时帮你自动收线,自动检测鱼竿张力避免脱钩]],
		name = "autoreel",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
	},
	{
		label = "鱼饵提示",
		hover = [[手拿海钓杆时点击鱼群将显示鱼群种类、鱼饵偏好、推荐饵料]],
		name = "fishtips",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
	},
	{
		label = "使用最佳抛饵位置",
		hover = [[启用后近距离钓鱼时会自动尝试使用最佳点位(必须使用好的浮漂，否则误差大)。
近距离钓鱼时，自动选择较大概率可以在鱼不挣扎的情况下将鱼瞬间捕获的点位。]],
		name = "optimumpos",
		options = {
			{ description = "开启", data = true },
			{ description = "关闭", data = false },
		},
		default = true,
	},
	{
		name = "6",
		label = "自动烹饪设置",
		options = {
			{ description = "", data = 0 },
		},
		default = 0,
	},
	----------------
	{
		name = "自动烹饪语言",
		hover = "选择您使用的语言",
		label = "选择您使用的语言",
		options = {
			-- {description = "English", data = "English", hover = "English"},
			{ description = "简体中文", data = "Chinese", hover = "简体中文" },
		},
		default = "Chinese",
	},
	{
		name = "自动烹饪key",
		hover = "启动做饭的按键",
		label = "启动做饭的按键",
		options = keylist,
		default = "KEY_F8",
	},
	{
		name = "自动烹饪key_2",
		hover = "启动做饭的按键（该按键 + 点击锅子）",
		label = "启动做饭的按键（该按键 + 点击锅子）",
		options = keylist,
		default = "KEY_LCTRL",
	},
	{
		name = "自动烹饪last_recipe_key1",
		hover = "开始做上一次配方的按键",
		label = "开始做上一次配方的按键",
		options = keylist,
		default = "KEY_HOME",
	},
	{
		name = "自动烹饪last_recipe_mode",
		hover = "烹饪上次配方的模式",
		label = "烹饪上次配方的模式",
		options = {
			{ description = "Auto Cooking", data = "auto", hover = "Last auto cooking recipe only" },
			{ description = "Last Cooking", data = "last", hover = "Last cooking recipe" },
		},
		default = "auto",
	},
	{
		name = "自动烹饪cookpots_num_divisor",
		hover = "选择更多或更少的烹饪锅",
		label = "选择更多或更少的烹饪锅",
		options = {
			{ description = "更少", data = 2.5, hover = "Select lesser cookpots" },
			{ description = "默认", data = 2, hover = "Select more cookpots" },
			{ description = "更多", data = 1.5, hover = "Select more cookpots" },
		},
		default = 2,
	},
	{
		name = "自动烹饪laggy_mode",
		hover = "如果很卡的话再开",
		label = "如果很卡的话再开",
		options = {
			{ description = "关闭", data = "off", hover = "Always off" },
			{ description = "开启", data = "on", hover = "Always on" },
			{ description = "游戏里", data = "in_game", hover = "Toggleable in game" },
		},
		default = "off",
	},
	{
		name = "自动烹饪laggy_mode_key",
		hover = "切换卡顿模式的按键",
		label = "切换卡顿模式的按键",
		options = keylist,
		default = "KEY_END",
	},
	--------------

	{
		name = "3233323",
		label = "全局颜色设置",
		hover = " ",
		options = { { description = "", data = 0 } }, 
		default = 0,

	},
	{
		name = "show_specialcolours",
		label = "仇恨显示颜色开关",
		hover = "是否让让标签使用不同的颜色来区别仇恨",
		options = { { description = "开启颜色", data = true }, { description = "关闭颜色", data = false } },
		default = true,
	},

	{
		name = "colour_mobaggroyou",
		label = "仇恨你的目标显示颜色",
		hover = "对你有敌意的生物应该显示什么颜色",
		options = colour2, 
		default = colour.red, --Red

	},

	{
		name = "colour_mobaggroplayer",
		label = "仇恨其他玩家生物显示颜色",
		hover = "对另一个玩家有仇恨的生物应该显示什么颜色",
		options = colour2, 
		default = colour.orange, --Orange

	},

	{
		name = "colour_mobfriendyou",
		label = "与你结交的生物它们是什么颜色",
		hover = "与你结交的生物它们是什么颜色",
		options = colour2, 
		default = colour.green, --Green

	},

	{
		name = "colour_mobfriendo第r",
		label = "被别的玩家驯服应该显示什么颜色",
		hover = "被别的玩家驯服应该显示什么颜色",
		options = colour2, 
		default = colour.yellow, --Yellow

	},

	{
		name = "colour_mobaggrofollower",
		label = "追随者的颜色",
		hover = "对特殊追随者（如伯尼）有敌意的暴徒应该是什么颜色！，阿比盖尔）",
		options = colour2, 
		default = colour.purple, --Purple

	},

	{
		name = "show_widget",
		label = "默认显示计时器",
		hover = "是否默认显示怪物攻击计时器",
		options = { { description = "开启", data = true }, { description = "关闭", data = false } },
		default = true,
	},
	{
		name = "scaletext",
		label = "摄像头缩放文本",
		hover = "使用相机距离缩放小部件文本大小。较高的相机距离=较小的文本，反之亦然。",
		options = { { description = "开启", data = true }, { description = "关闭", data = false } },
		default = true,
	},
	{
		name = "hidecdup",
		label = "隐藏冷却时间",
		hover = "如果文本的冷却时间已经准备好，它应该被隐藏吗？",
		options = { { description = "是的", data = true }, { description = "不是", data = false } },
		default = false,
	},
	{
		name = "colour_attack",
		label = "颜色攻击冷却时间",
		hover = "攻击冷却时间应该是彩色的吗？",
		options = { { description = "是的", data = true }, { description = "不是", data = false } },
		default = true,
	},
	{
		name = "colour_cooldown",
		label = "彩色怪物冷却",
		hover = "非攻击冷却应该是彩色的吗？",
		options = { { description = "是的", data = true }, { description = "不是", data = false } },
		default = true,
	},
	{
		name = "colour_danger",
		label = "危险颜色",
		hover = "在“危险”类别中，冷却时间应如何着色？",
		options = colour_opt,
		default = 3, --Red
	},
	{
		name = "colour_warning",
		label = "警戒颜色",
		hover = "说明你该走位了？",
		options = colour_opt,
		default = 8, --Yellow
	},
	{
		name = "colour_safe",
		label = "安全颜色",
		hover = "在“安全”类别中，冷却时间应如何着色？\n安全-CD:>67%的冷却时间；攻击：还不需要躲闪。",
		options = colour_opt,
		default = 4, --Green
	},
	{
		name = "textsize",
		label = "文本大小",
		hover = "显示的计时器文本的字体大小",
		options = text_sizes,
		default = "22",
	},
	{
		name = "偷拍摄像头",
		label = "偷拍摄像头",
		hover = "偷拍摄像头按键",
		options = keys_opt,
		default = 265,
	},
	{
		name = "Sand storm",
		label = "过滤沙漠风沙",
		hover = "沙尘暴滤镜",
		options = {
			{ description = "把风沙关了", data = 1 },
			{ description = "风沙还在哦", data = 0 },
		},
		default = 1,
	},
	{
		name = "积雪过滤",
		label = "积雪的程度",
		hover = "过滤积雪",
		options = {
			{ description = "地面上没有积雪", data = 0, hover = "地面上没有积雪" },
			{ description = "地面上有一点积雪", data = 1, hover = "地面上有一点积雪" },
			{ description = "地面上有一些积雪", data = 2, hover = "地面上有一些积雪" },
			{ description = "地面上有比较多的积雪", data = 3, hover = "地面上有比较多的积雪" },
			{ description = "不过滤 原版", data = 4, hover = "不过滤" },
		},
		default = 1,
	},
	{
		name = "服务器人数",
		label = "服务器人数多少",
		hover = "不要超过64哦",
		options = valuelist,
		default = 64,
	},
}
