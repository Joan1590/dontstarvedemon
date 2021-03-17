
local require = GLOBAL.require


AddMinimapAtlas("images/flagmini.xml")



local DST = GLOBAL.TheSim:GetGameID() == "DST"
local function ThePlayer()
	if DST then
		return GLOBAL.ThePlayer
	end
	return GLOBAL.GetPlayer()
end
local function CompatibilityImageButton()
	if DST then
		return require "widgets/imagebutton"
	end
	return require "widgets/dstimagebutton"
end


local SKIN = TUNING.xiaoyao("坐标菜单风格")
local KEY = TUNING.xiaoyao("坐标菜单按键")
--local KEY_INDICATORS = TUNING.xiaoyao("坐标菜单导航图标")
local WIDTH = TUNING.xiaoyao("坐标菜单窗口宽度")
local HEIGHT = TUNING.xiaoyao("坐标菜单窗口高度")
local COLOUR_VARIETY = TUNING.xiaoyao("坐标颜色处理")
local HIDE_HUD_ICON = TUNING.xiaoyao("坐标菜单ui设置")
if type(HIDE_HUD_ICON) ~= 'boolean' then
	HIDE_HUD_ICON = HIDE_HUD_ICON == 1
end
local DISABLE_CUSTOM_MAP_ICONS = TUNING.xiaoyao("坐标系统自定义路径")
if type(DISABLE_CUSTOM_MAP_ICONS) ~= 'boolean' then
	DISABLE_CUSTOM_MAP_ICONS = DISABLE_CUSTOM_MAP_ICONS == 1
end
local ALWAYS_SHOW_MP = TUNING.xiaoyao("坐标系统导航图标")
if type(ALWAYS_SHOW_MP) ~= 'boolean' then
	ALWAYS_SHOW_MP = ALWAYS_SHOW_MP == 1
end

if not DST then
	ALWAYS_SHOW_MP = false
end

--Load localization
modimport("xiaoyao.lua")
STRINGS = GLOBAL.STRINGS
STRINGS.WAYPOINT = WAYPOINT

-----v MAIN v-----
local function IsScreenBusy()
	return not (ThePlayer() and type(ThePlayer()) == 'table' and
		ThePlayer().HUD and type(ThePlayer().HUD) == 'table' and
		TheFrontEnd:GetActiveScreen() and
		TheFrontEnd:GetActiveScreen().name and
		type(TheFrontEnd:GetActiveScreen().name) == 'string' and
		TheFrontEnd:GetActiveScreen().name == 'HUD')
end

local function GetScaledScreen(controls)
	local screenWidth, screenHeight = GLOBAL.TheSim:GetScreenSize()
	local hudscale = controls.top_root:GetScale()
	local screenGridW = screenWidth / hudscale.x
	local screenGridH = screenHeight / hudscale.y
	-- print("[waypoint] width " .. screenWidth .. " / " .. hudscale.x)
	-- print("[waypoint] height " .. screenHeight .. " / " .. hudscale.y)
	return screenGridW, screenGridH
end






------插入我自己的前置函数---------

local WayPointBlackListFile = "waypoint_blacklist_player.txt"

local PointName	--保存聊天信息中标记的名字
local Point_x	--保存聊天信息中标记的x值
local Point_z	--保存聊天信息中标记的z值
local flag_Message = false	--对方发送的协议消息是否合法
local global_world_id	--worldID

local blackListCommand	--保存一个数字，用来代表玩家列表的序号



----风滚草标记---
local global_controls = nil
local isOpenWatchingTumbleweed = false



--分割字符串---
local function split(str, split_char)      

    local sub_str_tab = {}

    while true do          

        local pos = string.find(str, split_char) 

        if not pos then              

            table.insert(sub_str_tab,str)

            break

        end  

        local sub_str = string.sub(str, 1, pos - 1)              

        table.insert(sub_str_tab,sub_str)

        str = string.sub(str, pos + 1, string.len(str))

    end      

 

    return sub_str_tab

end


---处理字符串----（处理标记协议字符串的）
local function ProcessTheMessage(message)

	local tempMessage
	local x,z
	local table_message = {}
	local table_len
	local world_id
	
	local waypoint_tmp = 
	{
		name = nil,
		x = nil,
		z = nil,
		ID = nil,
		
	}
	
	local isRight = false	--消息是否合法
	
	
	tempMessage = string.sub(message , 1 , 2)		--截取前两个字符
	
	if ( tempMessage == "^*" ) then	--协议字符
		--message的消息模型是这样的形式  local message = "##  name name  10  -86"
		
		table_message = split(message , " " )	--以空格为分隔符，将消息分割为一组一组的字符串 table_message = {"##","name","name","10","-86"}
		table_len = #table_message		--获取表的元素个数
		
		waypoint_tmp.ID = table_message[table_len - 2]	--倒数第3个字符串
		waypoint_tmp.x = table_message[table_len - 1]	--倒数第二个字符串
		waypoint_tmp.z = table_message[table_len]		--倒数第一个字符串
		
		--坐标处理完了，现在处理名字
		local index = 2	--从第二个元素开始
		tempMessage = ""
		
		while (index < (table_len - 2) )
		do
			tempMessage = tempMessage..table_message[index] .." "
			index = index + 1
		end
		
		--去掉最后的空格
		tempMessage = string.sub(tempMessage , 1 , #tempMessage - 1)
		
		--PointName = tempMessage	--名称获取完成
		waypoint_tmp.name = tempMessage	--名称
		
		--将两个坐标做数值化处理，因为他们本来是字符串类型。
		waypoint_tmp.x = GLOBAL.tonumber(waypoint_tmp.x)
		waypoint_tmp.z = GLOBAL.tonumber(waypoint_tmp.z)
		
		--在是此协议消息的情况下，检查合法性--
		if waypoint_tmp.name and waypoint_tmp.ID and waypoint_tmp.x and waypoint_tmp.z then
			isRight = true
		else
			isRight = false
		end
		
		if not isRight then
			return
		end
		
		if global_controls then
			global_controls:AddFromPoint_by_Message(waypoint_tmp.name,waypoint_tmp.x,waypoint_tmp.z,waypoint_tmp.ID)
		end
		
	end

end



--这一条是用来处理数字指令的黑名单命令字符串的
local function ProcessTheMessage_BlackList(message)
	
	local tempstring = GLOBAL.tonumber(message)
	if tempstring then
		blackListCommand = tempstring
	end

end



----消息拦截------------------
local function HookTheChatMessage(self)

	local old_OnMessageReceived = self.OnMessageReceived
	
	function self:OnMessageReceived(name, prefab, message, colour, whisper, profileflair)
		old_OnMessageReceived(self,name, prefab, message, colour, whisper, profileflair)	-- 先执行一遍原函数--
		
		--执行完原函数之后，再做自己想做的--
		if message then
			--print(message)
			ProcessTheMessage(message)	--这一条是用来处理标记协议字符串的
			ProcessTheMessage_BlackList(message)	--这一条是用来处理数字指令的黑名单的
		end

	end

end

AddClassPostConstruct("widgets/chatqueue", HookTheChatMessage )



--[[
-----将指定序号的玩家ID存入黑名单文件里---
local function Add_The_Bad_Player_To_File(n)

	
	
    local isdedicated = not GLOBAL.TheNet:GetServerIsClientHosted()
    local index = 1
    for i, v in ipairs(GLOBAL.TheNet:GetClientTable()) do
        if not isdedicated or v.performance == nil then
			if index == n then
				--print(string.format("%s[%d] (%s) %s <%s>", v.admin and "*" or " ", index, v.userid, v.name, v.prefab))
				local blacklistFile = GLOBAL.io.open("waypoint_blacklist_player","w")
				blacklistFile:write(v.userid .. "  " .. v.name )
				blacklistFile:close()
				GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage(v.name .. "  " .. v.userid)
				index = index + 1
			end
        end
    end

end
]]--


---文件追加操作 先全部读取出来，再全部写入,因为mod环境只有r和w两种模式----------
local function Add_The_Text(filename , message)

	local theFile = GLOBAL.io.open(filename,"r")
	local theTable = {}
	
	if theFile then
		local temp = theFile:read()
		while (temp)
		do
			table.insert(theTable,temp)
			temp = theFile:read()
		end
		
		theFile:close()
	end
	
	
	
	--插入这次传入的信息
	table.insert(theTable,message)
	
	theFile = GLOBAL.io.open(filename,"w")
	local table_len = #theTable
	
	if table_len > 0 then
		local index = 1
		while (index <= table_len)
		do
			theFile:write(theTable[index] .. "\n")
			index = index + 1
		end
	end
	
	theFile:close()

end






-----将指定序号的玩家ID存入黑名单文件里---
local function Add_The_Bad_Player_To_File(n)

	
	
    local isdedicated = not GLOBAL.TheNet:GetServerIsClientHosted()
    local index = 1
    for i, v in ipairs(GLOBAL.TheNet:GetClientTable()) do
        if not isdedicated or v.performance == nil then
			if index == n then
				--print(string.format("%s[%d] (%s) %s <%s>", v.admin and "*" or " ", index, v.userid, v.name, v.prefab))

				Add_The_Text(WayPointBlackListFile , v.userid .. "  " .. v.name)
				GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage(v.name .. "  " .. v.userid)
				return true
			else
				index = index + 1
			end
        end
    end

end
----------------------------------------------------


--------检查当前玩家列表里是否存在黑名单玩家----------
local function checkBlackList(filename)

	local table_now	 = {}	--当前玩家列表
	local table_file = {}	--本地存储列表
	local notFound = true
	
	table_now = GLOBAL.TheNet:GetClientTable()
	
	local theFile = GLOBAL.io.open(filename,"r")
	if theFile then
		local temp = theFile:read()
		while (temp)
		do
			temp = split(temp," ")[1]	--获取第一部分，也就是ID
			table.insert(table_file,temp)
			temp = theFile:read()
		end
		
		theFile:close()
	end
	
	--两个玩家列表都获取完毕
	
	local len_table_file = #table_file
	
	local index_out = 0	--记录外层索引，也就是table_now的索引
	for i, v in ipairs(table_now) do
		index_out = index_out + 1 --外层索引递进
		local index_in = 1	--这个是内层索引，也就是table_file的索引
		while (index_in <= len_table_file)
		do
			if v.userid == table_file[index_in] then
				notFound = false
				local tempnumber = index_out - 1
				GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage( "发现熊孩子" .. tempnumber .. "  " .. v.name .. "  " .. v.userid)
				break	--这个中断会跳出针对当前列表的某个玩家对file的比对，继续检查当前列表的下一个玩家。
			else
				index_in = index_in + 1	--否则内层索引继续向下进行
			end
		end

	end
	
	if notFound then
		GLOBAL.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage( "当前没有发现任何熊孩子哦")
	end

end



-- Post Construct and Key Handlers
local function AddMod(controls)
	controls.inst:DoTaskInTime(0, function()
		local MainWp = require "mainwp"
		local NIndicatorManager = require "widgets/nindicatormanager"
		controls.waypoint = controls.top_root:AddChild(MainWp(WIDTH, HEIGHT, SKIN))
		controls.waypoint:SetConfiguration(ALWAYS_SHOW_MP, COLOUR_VARIETY)
		controls.waypoint.im = controls.top_root:AddChild(NIndicatorManager())
		controls.waypoint.im:MoveToBack()
		controls.waypoint:Hide()

		-- Continuous update to player's position
		local base_OnUpdate = controls.OnUpdate
		controls.OnUpdate = function(self, dt)
			base_OnUpdate(self, dt)
			if controls.waypoint:IsVisible() then
				local p = Point(ThePlayer().Transform:GetWorldPosition())
				controls.waypoint:OnUpdate_PlayerPosition(p)
			end
		end
		
		-- Toggle key for GUI
		GLOBAL.TheInput:AddKeyDownHandler(KEY, function()
			if IsScreenBusy() then
				-- print("[waypoint] GUI can't be toggled")
				return
			end

			if controls.waypoint:IsVisible() then
				controls.waypoint:Hide()
			else
				controls.waypoint:Show()
			end
		end)
		
		-- Toggle key for markers
		-- GLOBAL.TheInput:AddKeyDownHandler(KEY_INDICATORS, function()
			-- if IsScreenBusy() then
				--print("[waypoint] markers can't be toggled")
				-- return
			-- end

			-- if controls.waypoint then
				-- controls.waypoint:ToggleMarkerMode()
			-- end
		-- end)
		
		
		
		---依据上面的几条GLOBAL.TheInput:AddKeyDownHandler ，这里我插入一条我自己的事件函数----------
		--接收聊天框里的坐标提示然后一键添加标记
		local function OneKeyAddMark()

			if IsScreenBusy() then
				-- print("[waypoint] markers can't be toggled")
				return
			end
	
			if global_controls and PointName and flag_Message then	--flag_Message代表如果协议合法
				global_controls:AddFromPoint_by_Message(PointName,Point_x,Point_z,global_world_id)
				--GLOBAL.TheNet:Say( PointName .. "  received." , false)
			end

		end

		--GLOBAL.TheInput:AddKeyDownHandler( 268, OneKeyAddMark)		--[268] = "Num *"
		---------------结束：我自己插入的事件部分结束--------------------------------------------------------
		
		---修改风滚草，第一次从内存中出现的地方自动添加标记------------------
		--先在这里把要用到的controls.waypoint句柄传递给全局变量
		global_controls = controls.waypoint
		---------------------------------------------------------------------
		
		--Add_The_Bad_Player_To_File
		
		---我插入的第二条我自己的事件函数----------将玩家加入黑名单
		local function OneKeyAddBlacklist()

			if IsScreenBusy() then
				-- print("[waypoint] markers can't be toggled")
				return
			end
	
			if blackListCommand then	
				Add_The_Bad_Player_To_File(blackListCommand)
			end

		end

		GLOBAL.TheInput:AddKeyDownHandler( 267, OneKeyAddBlacklist)		--[267] = "Num /"
		---------------结束：我自己插入的事件部分结束--------------------------------------------------------
		
		
		
		
		--检查玩家列表部分
		
		---我插入的第三条我自己的事件函数----------检查玩家列表部分
		local function OneKeyCheckBlacklist()

			if IsScreenBusy() then
				-- print("[waypoint] markers can't be toggled")
				return
			end
			
			checkBlackList(WayPointBlackListFile)

		end

		GLOBAL.TheInput:AddKeyDownHandler( 278, OneKeyCheckBlacklist)		--[278] = "Home"
		---------------结束：我自己插入的事件部分结束--------------------------------------------------------
		
		
		

		

		-- No point of showing icon if controller connected
		local controller_mode = GLOBAL.TheInput:ControllerAttached()

		-- HUD Icon
		if not HIDE_HUD_ICON and not controller_mode then
			local ImageButton = CompatibilityImageButton()
			controls.waypoint_icon = controls.top_root:AddChild(
				ImageButton("images/icon.xml","icon.tex","icon.tex","icon.tex")
			)
			local sw, sh = GetScaledScreen(controls)
			local posX = sw/2
			local posY = -sh
			local offX, offY = controls.waypoint_icon:GetSize()

			controls.waypoint_icon:SetTooltip(STRINGS.WAYPOINT.UI.HUD.TOOLTIP .. 
				"\n(" .. string.upper(string.char(KEY)) .. ")")
			controls.waypoint_icon:SetPosition(posX - offX/2,posY + offY*1.2,0)
			controls.waypoint_icon:SetNormalScale(.7)
			controls.waypoint_icon:SetFocusScale(.8)
			controls.waypoint_icon:SetOnClick(function()
				if controls.waypoint:IsVisible() then
					controls.waypoint:Hide(true)
				else
					controls.waypoint:Show(true)
				end
			end)
		end

		-- Update hud size and position on event (best to update through event than overriding PlayerProfile.GetHUDSize)
		if DST then
			ThePlayer().HUD.inst:ListenForEvent("refreshhudsize", function(hud, scale)
				if controls.waypoint then
					controls.waypoint:SetScale(scale)
				end
				if controls.waypoint_icon then
					local sw, sh = GetScaledScreen(controls)
					local posX = sw/2
					local posY = -sh
					local offX, offY = controls.waypoint_icon:GetSize()

					controls.waypoint_icon:SetPosition(posX - offX/2,posY + offY*1.2,0)
				end
			end)
			
    		ThePlayer().HUD.inst:PushEvent("refreshhudsize", TheFrontEnd:GetHUDScale())
		end

	end)
end

-- Curious to know if TheFrontEnd is an appropriate place to add my NMapIconTemplateManager
if not DISABLE_CUSTOM_MAP_ICONS then
	local NMapIconTemplateManager = require "widgets/nmapicontemplatemanager"
	require "frontend"
	local OldFrontEnd_ctor = GLOBAL.FrontEnd._ctor
	GLOBAL.FrontEnd._ctor = function(TheFrontEnd, ...)
		OldFrontEnd_ctor(TheFrontEnd, ...)
		if TheFrontEnd.NMapIconTemplateManager == nil then
			TheFrontEnd.NMapIconTemplateManager = NMapIconTemplateManager()
		end
	end
end
-- if not DISABLE_CUSTOM_MAP_ICONS then
-- 	AddClassPostConstruct("frontend", function(FrontEnd)
-- 		local NMapIconTemplateManager = require "widgets/nmapicontemplatemanager"
-- 		if FrontEnd.NMapIconTemplateManager == nil then
-- 			FrontEnd.NMapIconTemplateManager = NMapIconTemplateManager()
-- 		end
-- 	end)
-- end

-- AddSimPostInit(function() ModInit() end)
AddClassPostConstruct("widgets/controls", AddMod)
AddClassPostConstruct("widgets/mapwidget", require "widgets/nmapwidget")
-- AddClassPostConstruct("screens/mapscreen", function(MapScreen)
-- 	print("okay")
-- end)

--print(TheSim:GetRealTime()/1000)
---修改风滚草，第一次从内存中出现的地方自动添加标记------------------
local _G = GLOBAL
local function WatchTumbleweedPosition(inst)
	inst:DoTaskInTime(0.1, function()
		local point = inst:GetPosition()	--必须要延迟0.1秒后才能获取到坐标，否则坐标获取到的都是0
		point.x = math.floor(point.x)
		point.y = math.floor(point.y)
		point.z = math.floor(point.z)
				
		local name = "tumbleweed_"
		local random_number = math.random(0,99)	--随机产生一个0到99之前的整数，用于区分。
		local time_number = _G.TheSim:GetRealTime() / 1000	--获得一个秒数。这是为了让后面的数字后缀，是一个有序数字，而不是杂乱的随机数值。
		--number = number / 1000
		name = name..time_number.."-"..random_number	--拼接成完整的名字
		
		if isOpenWatchingTumbleweed then
			if global_controls then
				global_controls:AddFromPoint(name,point.x,point.z)
				_G.ThePlayer.components.talker:Say("发现风滚草")	--这里提示作用不明显，换成在屏幕上显示的
				_G.TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
				--_G.ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("发现风滚草") --有了声音提示就没必要这个了。
			end
		end
					
	end)
end
AddPrefabPostInit("tumbleweed",WatchTumbleweedPosition)
		---------------------------------------------------------------------

--风滚草记录功能的开关。默认为关闭状态。
local function ChangeWatchingTumbleweed()
	if isOpenWatchingTumbleweed then
		isOpenWatchingTumbleweed = false
		--这个快捷删除功能还是很有必要的，即便它不那么完善。
		if global_controls then
			global_controls:Delete_All_Tumbleweed_Mark_EX()
		end
		_G.ThePlayer.components.talker:Say("当前风滚草检测功能：关闭")
	else
		isOpenWatchingTumbleweed = true
		_G.ThePlayer.components.talker:Say("当前风滚草检测功能：开启")
	end
end
GLOBAL.TheInput:AddKeyDownHandler( KEY_END, ChangeWatchingTumbleweed)		--[279] = "End", -- KEY_END






--列表化，清单化添加自动标记的物件：

--不添加数字后缀的
local auto_add_mark_prefab_list_single = 
{
"multiplayer_portal",	--绚丽之门
"atrium_gate",			--中庭
"pigking",				--猪王
"moonbase",				--月台
"beequeenhive",			--蜂后

}

--添加数字后缀的
local auto_add_mark_prefab_list_more = 
{
"klaus_sack", -- 克劳斯赃物袋
"cave_entrance",		--落水洞 被堵住的
"cave_entrance_open",	--挖开的落水洞
"cave_exit",			--洞穴楼梯

"ancient_altar_broken",	--破损的科技塔
"toadstool_cap",		--蛤蟆窝

"walrus_camp",			--海象巢穴

"lava_pond",			--岩浆池 这个没必要，注释掉算了。

"slurtlehole",			--洞穴里的蜗牛窝

"knight_nightmare",			--残破的发条骑士
"rook_nightmare",			--残破的发条战车
"bishop_nightmare",			--残破的发条主教

"sculpture_rooknose",	--三基佬雕像
"sculpture_bishophead",	--
"sculpture_knighthead",


}



--单个prefab版本，不添加数字后缀
local function Add_Them_to_AutoMark_single(inst)
	inst:DoTaskInTime(0.1, 
	function()
		local point = inst:GetPosition()
		local name = inst:GetDisplayName()
		local isRandomEx_name = false			--是否在名字后面添加随机数后缀(用以区分多个相同的prefab)
		
		if global_controls then
			global_controls:AddFromPoint_by_prefab(name,point.x,point.z,isRandomEx_name)	--条件添加标记。
		end
	end)
end

for index,each in pairs(auto_add_mark_prefab_list_single) do
	AddPrefabPostInit(each,Add_Them_to_AutoMark_single)
end

--多个prefab版本，添加数字后缀。
local function Add_Them_to_AutoMark_more(inst)
	inst:DoTaskInTime(0.1, 
	function()
		local point = inst:GetPosition()
		local name = inst:GetDisplayName()
		local isRandomEx_name = true			--是否在名字后面添加随机数后缀(用以区分多个相同的prefab)
		
		if global_controls then
			global_controls:AddFromPoint_by_prefab(name,point.x,point.z,isRandomEx_name)	--条件添加标记。
		end
	end)
end

for index,each in pairs(auto_add_mark_prefab_list_more) do
	AddPrefabPostInit(each,Add_Them_to_AutoMark_more)
end



