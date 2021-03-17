--modimport("listen.lua")

--欢迎各大服务器服主共享你们的黑名单，把那些反复改名字 半夜进服务器烧家的人渣名单共享出来，我将会在这里持续更新列表。

local _G = GLOBAL

local BlackList = 
{
	{ ID = "KU_Wwg8fzzT", QQ = "834538774" , Thing = "在多个服务器拥有不良记录，服霸，恶意踢人，骂人，半夜进服务器烧家", },	--肉丸，这俩人是男同性恋
	{ ID = "KU_0j0lULQe", QQ = "3496430239" , Thing = "在多个服务器拥有不良记录，恶意踢人，骂人，专业喷子，骂街，半夜进服务器烧家", }, --辰捞捞 跟上面这个是两个男同性恋
	{ ID = "KU_wGWouLpn", QQ = "524995248" , Thing = "多次烧家，骂人，在多个服务器拥有不良记录", },	--小当家,跟上面是一帮人，也是个憨逼
}


local function TheTask()
	--检查玩家列表
	local player_list = _G.TheNet:GetClientTable()
	if not player_list then
		print("debug: player_list is nil")
		return false
	end
	
	for index,each in pairs(player_list) do
		for index2,eachBlackUser in pairs(BlackList) do
			if eachBlackUser.ID == each.userid then
				local info_text1 = "警告: 发现跨服务器作案的黑名单玩家 名称:" .. each.name .. "  玩家科雷ID:" .. each.userid .. " QQ号" .. eachBlackUser.QQ
				local info_text2 = "罪名: " .. eachBlackUser.Thing
				_G.TheNet:Say(info_text1,false)
				_G.ThePlayer:DoTaskInTime(3,
				function()
				_G.TheNet:Say(info_text2,false)
				end)
			end
		end
	end
end

local function PlayerInitFunc(player)
	player:DoPeriodicTask(30 , TheTask)
end
AddPlayerPostInit(PlayerInitFunc)