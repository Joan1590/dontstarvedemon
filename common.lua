--由封锁封装的模块 version 1.1

--添加客户端聊天框命令

--[[
--param example

local command_string = "ABCD"
local params_table = {"param1","param2","param3",}
local function your_modmain_function(params_table, caller)
	print(params_table.param1)
	print(params_table.param2)
	print(params_table.param3)
	
	print(caller.name)
end

--触发键
local key_flag = 97	--代表A键

local function your_modmain_function(keycode)
	print(keycode)
end

]]--


function AddClientCommand_my(command_string , params_table , client_command_fn)

	local _G = GLOBAL
	
	--延迟2帧执行目标函数，为了方便防止命令选取操作，被聊天命令界面挡住的情况。
	local function delayTask(fn)
		_G.ThePlayer:DoTaskInTime(_G.FRAMES * 2 , fn )
	end
	
	local command_data = 
	{
		name = command_string,
		prettyname = nil,
		desc = nil,
		permission = _G.COMMAND_PERMISSION.USER,
		slash = true,	
		usermenu = false,
		servermenu = false,
		params = params_table ,
		localfn = client_command_fn,		
		--localfn的函数原型 
		--local function client_command_fn(params_table, caller)
		--serverfn = nil	
		--这个用不到，因为如果要给服务器添加命令，客户端必须也添加这个命令，
		--如果只有服务器添加了命令，客户端没添加，当用户输入命令的时候，客户端那一边就自动过滤了，
		--不会发送到服务器
		--所以这个只适合用来给客户端添加自定义命令
	}
	
	AddUserCommand(command_data.name , command_data)
end


--添加组合键

--[[
--param example

--功能键
local key_control_list = 
{
	305,	--代表右边Ctrl
	307,	--[307] = "Right Alt"
}

--触发键
local key_flag = 97	--代表A键

local function your_modmain_function(keycode)

end

]]--
function Add_KeyCombination_function(key_control_list,key_flag,fn,down_event)
	local _G = GLOBAL
	--检查是否在游戏画面内
	local function IsInGameScreen()
		if not _G.ThePlayer then
			return false
		end
	
		if not _G.ThePlayer.HUD then
			return false
		end
		
		local EndScreen = _G.TheFrontEnd:GetActiveScreen()
		if not EndScreen then
			return false
		end
		
		if not EndScreen.name then
			return false
		end
	
		if EndScreen.name ~= "HUD" then
			return false
		end
	
		--if EndScreen.name == "HUD" then
			return true
		--end
	end
	
	local function Check_KeyCombination(keycode)
		--检查功能键
		for index,each in pairs(key_control_list) do
			if not _G.TheInput:IsKeyDown(each) then
				return
			end
		end
		
		--检查是否在游戏画面内
		if not IsInGameScreen() then
			return
		end
		
		fn()
	end
	
	--注册按下事件，还是抬起事件
	if down_event then
		_G.TheInput:AddKeyDownHandler(key_flag,Check_KeyCombination)
	else
		_G.TheInput:AddKeyUpHandler(key_flag,Check_KeyCombination)
	end
end



--添加客户端公告函数

--[[
--param example
local text = "hello"
local color_data = {255,255,255,100}
local icon_type = "vote"

]]--
function Message_announcer(text , color_data,icon_type)
	local _G = GLOBAL
	
	--[[
	local announce_icon_type_list = 
	{
		"default",
		"afk_start",
		"afk_stop",
		"death",
		"resurrect",
		"join_game",
		"leave_game",
		"kicked_from_game",
		"banned_from_game",
		"item_drop",
		"vote",
		"dice_roll",
		"mod",
	}
	]]--
	
	if not (_G.ThePlayer and _G.ThePlayer.HUD and _G.ThePlayer.HUD.eventannouncer) then
		print("debug_common_01 ThePlayer is nil")
		return
	end
	
	if not text then
		print("debug_common_02 Message is nil")
		return
	end
	
	--[[
	if color_data then
		for index,each in pairs(color_data) do
			--each = each / 255		--这样操作，对原表无效，这个each是个临时的变量，循环结束就从内存中释放了，所以要用下面的方法
			color_data[index] = color_data[index] / 255
		end
	else
		color_data = {1,1,1,1,}	--默认的白色
	end
	]]--
	
	--当表作为函数的参数时，一定要注意值传递和地址传递的问题。
	--由于多模块之前错综复杂的内存回收问题，
	--在接收表类型的变量时，一定要注意手工转换为值传递
	local color_data2 = {1,1,1,1,}
	if color_data then
		color_data2[1] = color_data[1] / 255	--值的范围 0-255
		color_data2[2] = color_data[2] / 255
		color_data2[3] = color_data[3] / 255
		color_data2[4] = color_data[4] / 100	--值的范围 0-100 代表透明度
	end
	
	if (not icon_type) or (icon_type == "") then
		icon_type = "default"
	end
	
	_G.ThePlayer.HUD.eventannouncer:ShowNewAnnouncement(text, color_data2, icon_type)
end


--人物脑袋上出现消息 这个不支持颜色
function PlayerHeadMessage(text,color,player)
	local _G = GLOBAL
	if not text then
		print("debug_common_03 text is nil")
		return
	end
	
	local the_player = player or _G.ThePlayer
	if not the_player then
		print("debug_common_04 player is nil")
		return
	end
	
	local color2 = {1,1,1,1,}
	if color then
		color2[1] = color[1] / 255
		color2[2] = color[2] / 255
		color2[3] = color[3] / 255
		color2[4] = color[4] / 100
	end
	
	if not (the_player.components and the_player.components.talker) then
		print("debug_common_05 components or components.talker is nil")
		return
	end
	
	--the_player.components.talker:Say(text,nil,nil,nil,nil,color2)
	the_player.components.talker:Say(text, 2, 0, true, false, color2)
end



--聊天队列消息 只有自己能看到，其他人看不到。面向客户端的

--前置函数
local ChatQueue = nil
local function GetChatQueueHandle(inst)
	ChatQueue = inst
end
AddClassPostConstruct("widgets/chatqueue", GetChatQueueHandle )
	
function DisplayChatMessage(message,color_data)
	local _G = GLOBAL
	
	--local ChatQueue = _G.require("widgets/chatqueue")
	
	local username = ""
	--local message = message
	local color_data2 = {1,1,1,1,}
	local whisper = false
	local nolabel = true
	local profileflair = nil
	
	if not ChatQueue then
		print("debug_common_06 ChatQueue is nil")
		return
	end
	
	if (not message) or (message == "") then
		print("debug_common_07 message is nil")
		return
	end
	
	--如果传入了外部颜色，则修改为外部颜色
	if color_data then
		color_data2[1] = color_data[1] / 255	--值的范围 0-255
		color_data2[2] = color_data[2] / 255
		color_data2[3] = color_data[3] / 255
		color_data2[4] = color_data[4] / 100	--值的范围 0-100 代表透明度
	end
	
	--注意这里往里代入的颜色表，不能是从其他地方传进来的那个表，也就是不能代入原color_data
	--必须在这个函数里，临时构建一个本地的变量，用来存储外部接收的颜色值，
	--然后代入到这里，不然会出各种问题。
	--可能是由于地址传递的问题导致的。
	--这样操作就是为了在这里，把地址传递，强行变为值传递。
	--其他地方涉及到颜色相关的也是同样的问题，同样的应对方法
	ChatQueue:PushMessage(username, message, color_data2, whisper, nolabel, profileflair)
end



--ini文件读写模块
modimport("file-io.lua")



































