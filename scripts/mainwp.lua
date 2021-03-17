--[[
MainWp
By Nc5xb3
]]

local Styler = require "styler"
local NBox = require "util/nbox"

local NPanel = require "widgets/npanel"
local NInput = require "widgets/ninput"
local NMapIconTemplate = require "widgets/nmapicontemplate"

-- CLASSES
local Waypoint = require "waypoint"

-- DIALOG
local DialogEdit = require "dialogedit"
local DialogMp = require "dialogmp"

-- OTHER
local PersistentData = require "persistentdata"

-- WIDGETS
local Compatibility = require "util/compatibility"
local ImageButton = Compatibility:ImageButton()
local Image = Compatibility:Image()
local Text = Compatibility:Text()

-- CONSTANTS
local DEFAULT_LIST_ITEM_HEIGHT = 45
local TOGGLE_ALPHA_DISABLED = .4
local TOGGLE_ALPHA_HOVER = .7
local DIRECTION_LINE_MAX_RANGE = 5

local MainWp = Class(NPanel, function(self,w,h,skin)
	NPanel._ctor(self, "Waypoint")
	self.skin = skin or 1

	self.editMode = false
	self.markerMode = false

	self.listWaypoint = {}
	self.pageIndex = 1
	self.pageSize = 0

	self:InitialisePersistentData()
	self:InitialiseComponents(w or 360,h or 480)
	Styler(self.skin):ApplyStyle(self)
	self:LoadData()
end)

function MainWp:InitialisePersistentData()
	self.uwid = "waypoint_" .. Compatibility:TheWorld().meta.seed
	if Compatibility:TheWorld():HasTag("cave") then
		self.uwid = self.uwid .. "C"
	end
	self.dataContainer = PersistentData("waypoint")
	self.dataContainer:Load()
	
	--这里我把世界ID存下来
	local Data_world_ID = PersistentData("waypoint_world_ID")
	Data_world_ID:Load()
	Data_world_ID:SetValue("now_world_ID", self.uwid )
	Data_world_ID:Save()
end

function MainWp:InitialiseComponents(w,h)
	self:SetVAnchor(ANCHOR_MIDDLE)
	self:SetHAnchor(ANCHOR_MIDDLE)
	-- self:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self:SetPosition(-310,20)
	self:SetSize(w,h)

	self:AddClass("Frame")

	local box = NBox(self:GetSize())

	local maxRows = math.floor(box:H()/DEFAULT_LIST_ITEM_HEIGHT)
	local maxCols = 10
	self.pageSize = maxRows - 2

	local labelTitle = self:AddChild(Text(TALKINGFONT,28))
	labelTitle:SetPosition(box:GridX(4,maxCols),box:GridY(1,maxRows),0) -- X Center; 1-4-7|8,9,10
	labelTitle:SetString(STRINGS.WAYPOINT.UI.MENU.TITLE)

	self.btnEdit = self:AddChild(ImageButton("images/nuiwp.xml","edit.tex","edit.tex","edit.tex"))
	self.btnEdit:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.TOGGLE_EDITMODE)
	self.btnEdit:SetPosition(box:GridX(8,maxCols),box:GridY(1,maxRows),0)
	self.btnEdit:SetNormalScale(.5)
	self.btnEdit:SetFocusScale(.57)
	self.btnEdit:SetImageNormalColour(.9,.9,.9,TOGGLE_ALPHA_DISABLED)
	self.btnEdit:SetImageFocusColour(1,1,1,TOGGLE_ALPHA_HOVER)
	self.btnEdit:SetOnClick(function() self:ToggleEditMode() end)

	self.btnIndicators = self:AddChild(ImageButton("images/nuiwp.xml","marker.tex","marker.tex","marker.tex"))
	self.btnIndicators:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.TOGGLE_INDICATORS)
	self.btnIndicators:SetPosition(box:GridX(9,maxCols),box:GridY(1,maxRows),0)
	self.btnIndicators:SetNormalScale(.5)
	self.btnIndicators:SetFocusScale(.57)
	self.btnIndicators:SetImageNormalColour(.9,.9,.9,TOGGLE_ALPHA_DISABLED)
	self.btnIndicators:SetImageFocusColour(1,1,1,TOGGLE_ALPHA_HOVER)
	self.btnIndicators:SetOnClick(function() self:ToggleMarkerMode() end)

	self.btnAdd = self:AddChild(ImageButton("images/nuiwp.xml","flag.tex","flag.tex","flag.tex"))
	self.btnAdd:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.ADD)
	self.btnAdd:SetPosition(box:GridX(10,maxCols),box:GridY(1,maxRows),0)
	self.btnAdd:SetNormalScale(.6)
	self.btnAdd:SetFocusScale(.68)
	self.btnAdd:SetImageNormalColour(.9,.9,.9,1)
	self.btnAdd:SetImageFocusColour(1,1,1,1)
	self.btnAdd:SetOnClick(function() self:Add() end)

	-- LIST OF WAYPOINTS
	for i=1,self.pageSize do
		self.listWaypoint[i] = self:AddChild(NPanel("WaypointItem"))
		local li = self.listWaypoint[i]
		li:AddClass("ListItem")
		li:SetPosition(0,box:GridY(1+i,maxRows))
		li:SetSize(box:W()-20,box:GridH(maxRows)-5)

		local liBox = NBox(li:GetSize())

		li.lblName = li:AddChild(NInput("WaypointName"))
		li.lblName:SetPosition(liBox:GridX(4,maxCols),0) -- X Center; 1-4-7
		li.lblName:SetSize(liBox:GridW(10)*7-10,liBox:H()-10)

		li.lblX = li:AddChild(Text(NUMBERFONT,16))
		li.lblX:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(1,2))
		li.lblX:SetString("123")

		li.lblZ = li:AddChild(Text(NUMBERFONT,16))
		li.lblZ:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(2,2))
		li.lblZ:SetString("123")

		li.lblArrow = li:AddChild(Image("images/nuiwp.xml", "direction.tex"))
	    li.lblArrow.inst:AddTag("NOCLICK")
		li.lblArrow:SetPosition(liBox:GridX(9,maxCols),0,0)
		li.lblArrow:SetTint(1,1,1,.4)

		li.lblDistance = li:AddChild(Text(NUMBERFONT,20))
		li.lblDistance:SetPosition(liBox:GridX(9,maxCols),0,0)

		li.btnNavigate = li:AddChild(ImageButton("images/nuiwp.xml","flag.tex","flag.tex","flag.tex"))
		li.btnNavigate:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.TRAVEL)
		li.btnNavigate:SetPosition(liBox:GridX(10,maxCols),liBox:GridY(1,1))
		li.btnNavigate:SetNormalScale(.5)
		li.btnNavigate:SetFocusScale(.57)
		li.btnNavigate:SetImageNormalColour(.9,.9,.9,1)
		li.btnNavigate:SetImageFocusColour(1,1,1,1)

		-- Side bar

		li.btnUp = li:AddChild(ImageButton("images/nuiwp.xml","delete.tex","delete.tex","delete.tex"))
		li.btnUp:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.MOVE_UP)
		----------------------------------------------------------------
		--li.btnUp:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(1,2))		--这是他原来的值，现在为了把上移下移按钮合并成一个删除
		li.btnUp:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(1,1))
		----------------------------------------------------------------
		li.btnUp:SetNormalScale(.5)
		li.btnUp:SetFocusScale(.57)
		li.btnUp:SetImageNormalColour(.9,.9,.9,1)
		li.btnUp:SetImageFocusColour(1,1,1,1)

		li.btnDown = li:AddChild(ImageButton("images/nuiwp.xml","delete.tex","delete.tex","delete.tex"))
		li.btnDown:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.MOVE_DOWN)
		----------------------------------------------------------------
		--li.btnDown:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(2,2))	--这是他原来的值，现在为了把上移下移按钮合并成一个删除
		li.btnDown:SetPosition(liBox:GridX(8,maxCols),liBox:GridY(1,1))
		----------------------------------------------------------------
		li.btnDown:SetNormalScale(.5)
		li.btnDown:SetFocusScale(.57)
		li.btnDown:SetImageNormalColour(.9,.9,.9,1)
		li.btnDown:SetImageFocusColour(1,1,1,1)

		li.btnHidden = li:AddChild(ImageButton("images/nuiwp.xml","markeron.tex","markeron.tex","markeron.tex"))
		li.btnHidden:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.TOGGLE_VISIBILITY)
		li.btnHidden:SetPosition(liBox:GridX(9,maxCols),liBox:GridY(1,1))
		li.btnHidden:SetNormalScale(.5)
		li.btnHidden:SetFocusScale(.57)
		li.btnHidden:SetImageNormalColour(.9,.9,.9,1)
		li.btnHidden:SetImageFocusColour(1,1,1,1)

		li.btnEdit = li:AddChild(ImageButton("images/nuiwp.xml","edit.tex","edit.tex","edit.tex"))
		li.btnEdit:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.EDIT)
		li.btnEdit:SetPosition(liBox:GridX(10,maxCols),liBox:GridY(1,1))
		li.btnEdit:SetNormalScale(.5)
		li.btnEdit:SetFocusScale(.57)
		li.btnEdit:SetImageNormalColour(.9,.9,.9,1)
		li.btnEdit:SetImageFocusColour(1,1,1,1)

		li.btnUp:Hide()
		li.btnDown:Hide()
		li.btnHidden:Hide()
		li.btnEdit:Hide()
	end

	-- Page Navigation

	self.btnPrev = self:AddChild(ImageButton("images/nuiwp.xml","left.tex","left.tex","left.tex"))
	self.btnPrev:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.PREV)
	self.btnPrev:SetPosition(box:GridX(2,5),box:GridY(maxRows,maxRows))
	self.btnPrev:SetNormalScale(.5)
	self.btnPrev:SetFocusScale(.57)
	self.btnPrev:SetImageNormalColour(.9,.9,.9,1)
	self.btnPrev:SetImageFocusColour(1,1,1,1)
	self.btnPrev:SetOnClick(function() self:PrevPage() end)

	self.lblPageIndex = self:AddChild(Text(NUMBERFONT, 32))
	self.lblPageIndex:SetPosition(box:GridX(3,5),box:GridY(maxRows,maxRows))

	self.btnNext = self:AddChild(ImageButton("images/nuiwp.xml","right.tex","right.tex","right.tex"))
	self.btnNext:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.NEXT)
	self.btnNext:SetPosition(box:GridX(4,5),box:GridY(maxRows,maxRows))
	self.btnNext:SetNormalScale(.5)
	self.btnNext:SetFocusScale(.57)
	self.btnNext:SetImageNormalColour(.9,.9,.9,1)
	self.btnNext:SetImageFocusColour(1,1,1,1)
	self.btnNext:SetOnClick(function() self:NextPage() end)

	self.lblXZ = self:AddChild(Text(NUMBERFONT,24))
	self.lblXZ:SetPosition(box:GridX(5,5),box:GridY(maxRows,maxRows))

	-- Close

	self.btnClose = self:AddChild(ImageButton())
	self.btnClose:SetPosition(0,-box:H()/2-20/2)
	self.btnClose:SetScale(.7,.7,.7)
	self.btnClose:SetText(STRINGS.WAYPOINT.UI.BUTTON.CLOSE)
	self.btnClose:SetOnClick(function() self:Hide(true) end)

	-- EXTRA

	-- Movement Prediction toggle button!	行动预测（延迟补偿）切换按钮
	self.btnMpToggle = self:AddChild(ImageButton("images/nuiwp.xml","mpoff.tex","mpoff.tex","mpoff.tex"))
	self.btnMpToggle:SetTooltip(STRINGS.WAYPOINT.UI.BUTTON.TOGGLE_MOVEMENT_PREDICTION)
	self.btnMpToggle:SetPosition(box:GridX(1,10),box:GridY(maxRows,maxRows),0)
	self.btnMpToggle:SetNormalScale(.5)
	self.btnMpToggle:SetFocusScale(.57)
	self.btnMpToggle:SetImageNormalColour(.9,.9,.9,1)
	self.btnMpToggle:SetImageFocusColour(1,1,1,1)
	self.btnMpToggle:SetOnClick(function() self:ToggleMovementPrediction() end)
	if Compatibility:ThePlayer().components.locomotor ~= nil then
		self.btnMpToggle:Hide()
	else
		self:UpdateMovementPredictionButton()
	end
end

function MainWp:SetConfiguration(alwaysShowMp, colourVariety)
	if alwaysShowMp then
		self.btnMpToggle:Show()
		self:ToggleMovementPrediction()
	end
	self.colourVariety = colourVariety
end

function MainWp:Hide(quiet)
	MainWp._base.Hide(self)
	if quiet == nil or quiet == false then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	end
end

function MainWp:Show(quiet)
	MainWp._base.Show(self)
	if quiet == nil or quiet == false then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
	end
	if self.btnMpToggle:IsVisible() then
		self:UpdateMovementPredictionButton()
	end
end

function MainWp:GetAngleToPoint(x,z)
	local p = Compatibility:ThePlayer()
	
	local angleToTarget = p:GetAngleToPoint(x, 0, z)
	local downVector = TheCamera:GetDownVec()
	local downAngle = -math.atan2(downVector.z, downVector.x) / DEGREES
	local angle = (angleToTarget - downAngle) + 90
	while angle > 180 do angle = angle - 360 end
	while angle < -180 do angle = angle + 360 end

	return angle
end

function MainWp:OnUpdate_PlayerPosition(point)
	self.lblXZ:SetString(math.floor(point.x) .. " " .. math.floor(point.z))
	local pageSize = #self.listWaypoint
	for i=1,pageSize,1 do
		local li = self.listWaypoint[i]
		if li:IsVisible() and li.currentWaypoint ~= nil and self.editMode == false then
			local xd = point.x - li.currentWaypoint.coord.x
			local yd = point.y - li.currentWaypoint.coord.y
			local zd = point.z - li.currentWaypoint.coord.z
			local dist = math.sqrt(xd*xd+yd*yd+zd*zd) / TILE_SCALE
			li.lblDistance:SetString(math.floor(dist) .. "m")

			li.lblArrow:SetRotation(self:GetAngleToPoint(
				li.currentWaypoint.coord.x,li.currentWaypoint.coord.z
			))
			if dist < DIRECTION_LINE_MAX_RANGE then
				li.lblArrow:SetScale(.6*dist/DIRECTION_LINE_MAX_RANGE)
			elseif li.lblArrow:GetScale() ~= .6 then
				li.lblArrow:SetScale(.6)
			end
		end
	end
end

function MainWp:LoadData()
	self.waypoints = self.dataContainer:GetValue(self.uwid) or {}
	-- load older data with incorrect spelling
	for i,w in pairs(self.waypoints) do
		self:AddMapIcon(w)
		if w.color ~= nil then
			w.colour = w.color
			w.color = nil
		end
	end
	self:UpdateList()
end

function MainWp:SaveData()
	self.dataContainer:SetValue(self.uwid, self.waypoints)
	self.dataContainer:Save()
end

function MainWp:Add()
	local x,y,z = Compatibility:ThePlayer().Transform:GetWorldPosition()
	local gid = Compatibility:TheWorld().Map:GetTileAtPoint(x,y,z)
	
	--追加的取整操作-----------
	x = math.floor(x)
	y = math.floor(y)
	z = math.floor(z)
	------操作结束-------------

	-- GROUND from constants which is accessible
	local iground={}
	for k,v in pairs(GROUND) do
		iground[v]=string.gsub(k, "(%a)([%w']*)", function(a,b)
			return a:upper()..b:lower()
		end)
	end

	--local waypoint = Waypoint(iground[gid],
	local waypoint = Waypoint("",
		{["x"]=x,["y"]=y,["z"]=z},
		{
			--r=math.random()*.7+.3,
			--g=math.random()*.7+.3,
			--b=math.random()*.7+.3
			
			--手动添加的标记 全部为白色，更显眼。
			r=255/255,
			g=255/255,
			b=255/255,
		}
	)
	table.insert(self.waypoints, waypoint)
	self:AddMapIcon(waypoint)
	if self.markerMode then
		self:AddMarker(waypoint)
	end
	
	self:LastPage()
end

------这里我追加一条可以调用的操作：添加一个指定坐标的标记点-----------
------这是从function MainWp:Add()这条直接复制过来的，稍加改造即可-----
function MainWp:AddFromPoint(p_name,x,z)
	
	local y = 0	-- 坐标是x和z，y在游戏里一直显示为0，既然下面很多部分用到了y，这里就创建一个。
	
	--追加的取整操作-----------
	x = math.floor(x)
	y = math.floor(y)
	z = math.floor(z)
	------操作结束-------------

	-- GROUND from constants which is accessible
	local iground={}
	for k,v in pairs(GROUND) do
		iground[v]=string.gsub(k, "(%a)([%w']*)", function(a,b)
			return a:upper()..b:lower()
		end)
	end

	--local waypoint = Waypoint(iground[gid],
	local waypoint = Waypoint(p_name,
		{["x"]=x,["y"]=y,["z"]=z},
		{
			--风滚草的自动添加，还是彩色的比较好，贴合在一起的标记容易区分
			r=math.random()*.7+.3,
			g=math.random()*.7+.3,
			b=math.random()*.7+.3,
			
			--白色
			--r=255/255,
			--g=255/255,
			--b=255/255,
			
		}
	)
	table.insert(self.waypoints, waypoint)
	self:AddMapIcon(waypoint)
	if self.markerMode then
		self:AddMarker(waypoint)
	end
	
	self:LastPage()
end

--上面那条是彩色的，这里加一条白色版本的
function MainWp:AddFromPoint_white(p_name,x,z)
	
	local y = 0	-- 坐标是x和z，y在游戏里一直显示为0，既然下面很多部分用到了y，这里就创建一个。
	
	--追加的取整操作-----------
	x = math.floor(x)
	y = math.floor(y)
	z = math.floor(z)
	------操作结束-------------

	-- GROUND from constants which is accessible
	local iground={}
	for k,v in pairs(GROUND) do
		iground[v]=string.gsub(k, "(%a)([%w']*)", function(a,b)
			return a:upper()..b:lower()
		end)
	end

	--local waypoint = Waypoint(iground[gid],
	local waypoint = Waypoint(p_name,
		{["x"]=x,["y"]=y,["z"]=z},
		{
			--风滚草的自动添加，还是彩色的比较好，贴合在一起的标记容易区分
			--r=math.random()*.7+.3,
			--g=math.random()*.7+.3,
			--b=math.random()*.7+.3,
			
			--白色
			r=255/255,
			g=255/255,
			b=255/255,
			
		}
	)
	table.insert(self.waypoints, waypoint)
	self:AddMapIcon(waypoint)
	if self.markerMode then
		self:AddMarker(waypoint)
	end
	
	self:LastPage()
end



---追加一个多世界版本的，支持不同世界之间互相通过聊天信息添加标记。
function MainWp:AddFromPoint_by_Message(p_name,x,z,ID)
	--如果没有必要的信息，则退出。
	if (not ID) or (not x) or (not z) then
		return
	end
	
	
	local y = 0	-- 坐标是x和z，y在游戏里一直显示为0，既然下面很多部分用到了y，这里就创建一个。
	
	--追加的取整操作-----------
	x = math.floor(x)
	y = math.floor(y)
	z = math.floor(z)
	------操作结束-------------

	-- GROUND from constants which is accessible
	local iground={}
	for k,v in pairs(GROUND) do
		iground[v]=string.gsub(k, "(%a)([%w']*)", function(a,b)
			return a:upper()..b:lower()
		end)
	end

	--local waypoint = Waypoint(iground[gid],
	local waypoint = Waypoint(p_name,
		{["x"]=x,["y"]=y,["z"]=z},
		{
			
			--白色
			r=255/255,
			g=255/255,
			b=255/255,
			
		}
	)
	
	--如果是当前世界
	if ID == self.uwid then
		--检查此坐标是否已经存在，存在则退出。
		for i,v in pairs(self.waypoints) do
			if v and v.coord and v.coord.x == x and v.coord.z == z then
				return
			end
		end
		
		table.insert(self.waypoints, waypoint)
		self:AddMapIcon(waypoint)
		if self.markerMode then
			self:AddMarker(waypoint)
		end
		self:LastPage()
		--接收宣告
		--TheNet:Say( p_name .. "  received." , false)
	else	--如果是其他世界的
		local other_world_waypoints = {}
		other_world_waypoints = self.dataContainer:GetValue(ID) or {}
		
		--检查此坐标是否已经存在，存在则退出。
		for i,v in pairs(other_world_waypoints) do
			if v and v.coord and v.coord.x == x and v.coord.z == z then
				return
			end
		end
	
		table.insert(other_world_waypoints, waypoint)
		self.dataContainer:SetValue(ID, other_world_waypoints)
		self.dataContainer:Save()
		--接收宣告
		--TheNet:Say( p_name .. "  received." , false)
		
	end

end

	
	


function MainWp:ToggleHidden(wid)
	local waypoint = self.waypoints[wid]
	waypoint.hidden = not waypoint.hidden
	self:SaveData()
	-- print("[waypoint] waypoint hidden toggled!")
	self:UpdateMarker(waypoint)
	self:UpdateList()
	if self.markerMode then
		if waypoint.hidden then
			self:RemoveMarker(waypoint)
		else
			self:AddMarker(waypoint)
		end
	end
end


--这里把上移和下移，全部改成删除此标记。因为删除更实用，上下移动用的很少。------
--[[
function MainWp:MoveUp(wid)
	if wid-1 > 0 then
		local temp = self.waypoints[wid-1]
		self.waypoints[wid-1] = self.waypoints[wid]
		self.waypoints[wid] = temp
		self:SaveData()
		-- print("[waypoint] waypoint moved up saved!")
		self:UpdateList()
	end
end

function MainWp:MoveDown(wid)
	if wid < #self.waypoints then
		local temp = self.waypoints[wid+1]
		self.waypoints[wid+1] = self.waypoints[wid]
		self.waypoints[wid] = temp
		self:SaveData()
		-- print("[waypoint] waypoint moved down saved!")
		self:UpdateList()
	end
end
]]--

function MainWp:MoveUp(wid)
	self:Remove(wid)
end

function MainWp:MoveDown(wid)
	self:Remove(wid)
end

----------------------------------------------------------------------

function MainWp:Edit(wid)
	if self.dialogEdit == nil then
		local waypoint = self.waypoints[wid]
		self.dialogEdit = self:AddChild(DialogEdit(nil,nil,self.skin,self.colourVariety))
		self.dialogEdit:SetWaypoint(waypoint)
		self.dialogEdit:SetSuccessCallback(function()
			waypoint.name = self.dialogEdit.inputName.input:GetText()
			local x = tonumber(self.dialogEdit.inputX.input:GetText())
			local z = tonumber(self.dialogEdit.inputZ.input:GetText())
			if x ~= nil then
				waypoint.coord.x = x
			end
			if z ~= nil then
				waypoint.coord.z = z
			end
			local r,g,b = self.dialogEdit.palette:GetRGB()
			waypoint.colour.r = r
			waypoint.colour.g = g
			waypoint.colour.b = b
			self:SaveData()
			print("[waypoint] edit saved!")
			self:UpdateList()
			self:UpdateMarker(waypoint)
			self:KillEditDialog()
		end)
		self.dialogEdit:SetCancelCallback(function()
			self:KillEditDialog()
		end)
		self.dialogEdit:SetDeleteCallback(function()
			self:Remove(wid)
			self:KillEditDialog()
		end)
	else
		print("[waypoint] already editing!")
	end
end

function MainWp:KillEditDialog()
	self.dialogEdit:Kill()
	self.dialogEdit = nil
end

function MainWp:KillMpDialog()
	self.dialogMp:Kill()
	self.dialogMp = nil
end

function MainWp:Remove(wid)
	-- Remove indicator
	local waypoint = self.waypoints[wid]

	if waypoint ~= nil then
		if self.markerMode then
			self:RemoveMarker(waypoint)
		end
		self:RemoveMapIcon(waypoint)
	end

	table.remove(self.waypoints,wid)
	self:UpdateList()
	self:SaveData()
end

function MainWp:AddMarker(waypoint)
	if not waypoint.hidden then
		local marker = SpawnPrefab("flagplacer")
		if marker ~= nil then
			if self.markers == nil then
				self.markers = {}
			end
			marker.Transform:SetPosition(waypoint.coord.x, waypoint.coord.y, waypoint.coord.z)
			self.markers[waypoint] = marker

			-- Add indicator
			local indicator = self.im:AddIndicator(marker)
			indicator:SetName(waypoint.name)
			indicator:SetTooltip(STRINGS.LMB .. " " ..
				STRINGS.WAYPOINT.UI.INDICATOR.BUTTON.PREFIX_TRAVELTO .. " " .. waypoint.name)
			indicator:SetColour({waypoint.colour.r,waypoint.colour.g,waypoint.colour.b})
			indicator:SetCallback(function()
				self:MovePlayerTo(waypoint)
			end)
			-- Compatibility:ThePlayer().HUD:AddTargetIndicator(marker)
		else
			print("[waypoint] failed to spawn flagplacer!")
		end
		-- self:AddMapIcon(waypoint)
	end
end
function MainWp:RemoveMarker(waypoint)
	local marker = self.markers[waypoint]
	self.markers[waypoint] = nil
	if marker ~= nil then
		self.im:RemoveIndicator(marker)
		marker:Remove()
	end
	-- Compatibility:ThePlayer().HUD:RemoveTargetIndicator(marker)
	-- self:RemoveMapIcon(waypoint)
end

function MainWp:AddMapIcon(waypoint)
	if TheFrontEnd.NMapIconTemplateManager then
		if self.mapIcons == nil then
			self.mapIcons = {}
		end
		local template = NMapIconTemplate()
		template:SetWorldPosition(waypoint.coord.x, waypoint.coord.y, waypoint.coord.z)
		template:SetWidget(function(inst)
			local root = inst:AddChild(NPanel("MapIconRoot"))
			
			local icon = root:AddChild(ImageButton("images/flag.xml","flag.tex","flag.tex","flag.tex"))
			icon:SetScale(.2)
			icon:SetNormalScale(.9)
			icon:SetFocusScale(1)
			icon:SetImageNormalColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
			icon:SetImageFocusColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
			icon:SetOnClick(function()
				self:MovePlayerTo(waypoint)
			end)
			icon:SetTooltip(STRINGS.LMB .. " " ..
				STRINGS.WAYPOINT.UI.INDICATOR.BUTTON.PREFIX_TRAVELTO .. " " .. waypoint.name)

			local label = root:AddChild(Text(TALKINGFONT, 25, waypoint.name))
			label:SetColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
			label:SetPosition(0, 45, 0)

			-- local OldSetScale = root.SetScale
			-- function root:SetScale(pos, y, z)

			-- end

			return root
		end)
		self.mapIcons[waypoint] = TheFrontEnd.NMapIconTemplateManager:AddTemplate(template)
	end
end
function MainWp:UpdateMapIcon(waypoint)
	if TheFrontEnd.NMapIconTemplateManager then
		local icon = self.mapIcons[waypoint]
		if TheFrontEnd.NMapIconTemplateManager:HasTemplate(icon) then
			icon:SetWorldPosition(waypoint.coord.x, waypoint.coord.y, waypoint.coord.z)
		end
	end
end
function MainWp:RemoveMapIcon(waypoint)
	if TheFrontEnd.NMapIconTemplateManager then
		TheFrontEnd.NMapIconTemplateManager:RemoveTemplate(self.mapIcons[waypoint])
		self.mapIcons[waypoint] = nil
	end
end

function MainWp:ContainsMarker(waypoint)
	if not self.markers then return end
	for i,v in pairs(self.markers) do
		if i == waypoint then
			return true
		end
	end
	return false
end

function MainWp:UpdateMarker(waypoint)
	self:UpdateMapIcon(waypoint)
	if self:ContainsMarker(waypoint) then
		local marker = self.markers[waypoint]
		if marker ~= nil and self.im:HasIndicator(marker) then
			marker.Transform:SetPosition(
				waypoint.coord.x,
				waypoint.coord.y,
				waypoint.coord.z)
			local indicator = self.im:GetIndicator(marker)
			indicator:SetName(waypoint.name)
			indicator:SetTooltip(STRINGS.LMB .. " " ..
				STRINGS.WAYPOINT.UI.INDICATOR.BUTTON.PREFIX_TRAVELTO .. " " .. waypoint.name)
			indicator:SetColour({waypoint.colour.r,waypoint.colour.g,waypoint.colour.b})
			indicator:SetCallback(function()
				self:MovePlayerTo(waypoint)
			end)
		end
	end
end

function MainWp:ToggleEditMode()
	if self.editMode then
		self.editMode = false
		self.btnEdit:SetImageNormalColour(.9,.9,.9,TOGGLE_ALPHA_DISABLED)
		self.btnEdit:SetImageFocusColour(1,1,1,TOGGLE_ALPHA_HOVER)
	else
		self.editMode = true
		self.btnEdit:SetImageNormalColour(.9,.9,.9,1)
		self.btnEdit:SetImageFocusColour(1,1,1,1)
	end
	for i,li in pairs(self.listWaypoint) do
		if self.editMode then
			li.btnHidden:Show()
			li.btnUp:Show()
			li.btnDown:Show()
			li.btnEdit:Show()
			li.lblX:Hide()
			li.lblZ:Hide()
			li.lblDistance:Hide()
			li.lblArrow:Hide()
			li.btnNavigate:Hide()
		else
			li.btnHidden:Hide()
			li.btnUp:Hide()
			li.btnDown:Hide()
			li.btnEdit:Hide()
			li.lblX:Show()
			li.lblZ:Show()
			li.lblDistance:Show()
			li.lblArrow:Show()
			li.btnNavigate:Show()
		end
	end
end

function MainWp:ToggleMarkerMode()
	if self.markerMode then
		self.markerMode = false
		self.btnIndicators:SetImageNormalColour(.9,.9,.9,TOGGLE_ALPHA_DISABLED)
		self.btnIndicators:SetImageFocusColour(1,1,1,TOGGLE_ALPHA_HOVER)
		if self.markers ~= nil then
			for i,marker in pairs(self.markers) do
				self:RemoveMarker(i)
			end
			self.markers = {}
			print("[waypoint] markers removed.")
		end
	else
		self.markerMode = true
		self.btnIndicators:SetImageNormalColour(.9,.9,.9,1)
		self.btnIndicators:SetImageFocusColour(1,1,1,1)
		for i,w in pairs(self.waypoints) do
			self:AddMarker(w)
		end
		print("[waypoint] markers added.")
	end
end

function MainWp:ToggleMovementPrediction()
	if Compatibility:ThePlayer().components.locomotor == nil then
		Compatibility:ThePlayer():EnableMovementPrediction(true)		--这条指令就是打开延迟补偿（也就是行动预测）
		-----------
		Compatibility:ThePlayer().HUD.controls.networkchatqueue:DisplaySystemMessage("MovementPrediction ON")
		----------
	else
		Compatibility:ThePlayer():EnableMovementPrediction(false)
		-----------
		Compatibility:ThePlayer().HUD.controls.networkchatqueue:DisplaySystemMessage("MovementPrediction OFF")
		----------
	end
	-- Check again to correct image
	self:UpdateMovementPredictionButton()
end

function MainWp:UpdateMovementPredictionButton()
	if Compatibility:ThePlayer().components.locomotor == nil then
		self.btnMpToggle:SetTextures("images/nuiwp.xml","mpoff.tex","mpoff.tex","mpoff.tex")
		self.btnMpToggle:SetImageNormalColour(.9,.9,.9,1)
		self.btnMpToggle:SetImageFocusColour(1,1,1,1)

	else
		self.btnMpToggle:SetTextures("images/nuiwp.xml","mpon.tex","mpon.tex","mpon.tex")
		self.btnMpToggle:SetImageNormalColour(.9,.9,.9,1)
		self.btnMpToggle:SetImageFocusColour(1,1,1,1)
	end
end

function MainWp:NextPage()
	local pageSize = #self.listWaypoint
	if self.pageIndex < math.ceil(#self.waypoints / pageSize) then
		self.pageIndex = self.pageIndex + 1
		self:UpdateList()
	end
end

function MainWp:PrevPage()
	if self.pageIndex > 1 then
		self.pageIndex = self.pageIndex - 1
		self:UpdateList()
	end
end

function MainWp:LastPage()
	local pageSize = #self.listWaypoint
	local pageCap = math.ceil(#self.waypoints / pageSize)
	self.pageIndex = pageCap
	self:UpdateList()
end

function MainWp:UpdateList()
	local pageSize = #self.listWaypoint
	local pageCap = math.ceil(#self.waypoints / pageSize)
	for i=1,pageSize,1 do
		local wid = (self.pageIndex-1)*pageSize+i
		local waypoint = self.waypoints[wid];
		local li = self.listWaypoint[i]
		li.currentWaypoint = waypoint
		self:DisplayWaypoint(li, waypoint)
		li.lblName:SetCallback(function()
			waypoint.name = li.lblName.input:GetText()
			self:UpdateMarker(waypoint)
			self:SaveData()
		end)
		li.btnNavigate:SetOnClick(function()
			self:MovePlayerTo(waypoint)
		end)
		li.btnHidden:SetOnClick(function()
			self:ToggleHidden(wid)
		end)
		li.btnUp:SetOnClick(function()
			self:MoveUp(wid)
		end)
		li.btnDown:SetOnClick(function()
			self:MoveDown(wid)
		end)
		li.btnEdit:SetOnClick(function()
			self:Edit(wid)
		end)
	end
	if self.pageIndex > pageCap then
		self:LastPage()
	else
		self.lblPageIndex:SetString(self.pageIndex .. "/" .. pageCap)
	end

	self:SaveData()
end

function MainWp:DisplayWaypoint(li, waypoint)
	if type(waypoint)=="table" then
		li.lblName.input:SetText(waypoint.name)
		li.lblName.input:SetColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
		li.lblX:SetString(math.floor(waypoint.coord.x))
		li.lblZ:SetString(math.floor(waypoint.coord.z))
		li.btnNavigate:SetImageNormalColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
		li.btnNavigate:SetImageFocusColour(waypoint.colour.r,waypoint.colour.g,waypoint.colour.b,1)
		if waypoint.hidden then
			li.btnHidden:SetTextures("images/nuiwp.xml","markeroff.tex","markeroff.tex","markeroff.tex")
		else
			li.btnHidden:SetTextures("images/nuiwp.xml","markeron.tex","markeron.tex","markeron.tex")
		end
		li:Show()
	else
		li:Hide()
	end
end

--[[
function MainWp:MovePlayerTo(waypoint)
	Compatibility:ThePlayer():EnableMovementPrediction(true)		--这一行原本是个注释，代码作用是：打开行动预测(延迟补偿)
	if Compatibility:ThePlayer().components.locomotor ~= nil and waypoint then
		local locomotor = Compatibility:ThePlayer().components.locomotor
		local point = Point(waypoint.coord.x,waypoint.coord.y,waypoint.coord.z)
		print("[waypoint] moving to " .. point.x .. ", " .. point.y .. ", " .. point.z)	
		locomotor:GoToPoint(point, nil, true)
		--追加标记的发布消息----
		local PointMessage = "^* " .. waypoint.name .. " " .. point.x .. " " .. point.z
		if (waypoint.name ~= "") then		--标记的名字必须不为空字符，才能发出去，不然不发送。
			TheNet:Say( PointMessage , false)
		end
		--追加部分结束-----------
	elseif not self.btnMpToggle:IsVisible() then
		print("[waypoint] Movement Prediction is disabled!")
		self.btnMpToggle:Show()
		self:ShowMpWarning()
	end
end
--]]


--[[
--重写他的这个函数，去掉移动功能，改为单纯的发送坐标-----

function MainWp:MovePlayerTo(waypoint)
	--Compatibility:ThePlayer():EnableMovementPrediction(false)		--关闭延迟补偿

	--if Compatibility:ThePlayer().components.locomotor ~= nil and waypoint then	--这一句如果不修改，在游戏里关闭延迟补偿的状态下，点击Travel按钮不会发送消息。
	if waypoint then
		--local locomotor = Compatibility:ThePlayer().components.locomotor
		local point = Point(waypoint.coord.x,waypoint.coord.y,waypoint.coord.z)
		
		--追加标记的发布消息----
		local PointMessage = "^* " .. waypoint.name .. " " .. point.x .. " " .. point.z
		if (waypoint.name ~= "") then		--标记的名字必须不为空字符，才能发出去，不然不发送。
			TheNet:Say( PointMessage , false)
		end
		--追加部分结束-----------

	end
end
-------------------------
--]]


-----2019-11-19日更新  现在改为依据延迟补偿分打开和关闭两种情况，做不同的处理----------

function MainWp:MovePlayerTo(waypoint)

	if waypoint then

	
		---如果延迟补偿是打开的状态---
		if Compatibility:ThePlayer().components.locomotor then
			local locomotor = Compatibility:ThePlayer().components.locomotor
			local point = Point(waypoint.coord.x,waypoint.coord.y,waypoint.coord.z)
			print("[waypoint] moving to " .. point.x .. ", " .. point.y .. ", " .. point.z)	
			locomotor:GoToPoint(point, nil, true)
		
			--追加标记的发布消息----
			local PointMessage = "^* " .. waypoint.name .. " " .. self.uwid .. " " .. point.x .. " " .. point.z
			if (waypoint.name ~= "") then		--标记的名字必须不为空字符，才能发出去，不然不发送。
				--TheNet:Say( PointMessage , false)
				Compatibility:ThePlayer().HUD.controls.networkchatqueue:DisplaySystemMessage("正在前往 "..waypoint.name)
			else
				--虽然不发送消息，但是给自己做个提示，以免其他人不懂为什么发送不了
				Compatibility:ThePlayer().HUD.controls.networkchatqueue:DisplaySystemMessage("Unnamed 空名称")
			end
			--追加部分结束-----------
	
		---如果延迟补偿是关闭的状态 则只发送消息，而不移动人物。
		else
			local point = Point(waypoint.coord.x,waypoint.coord.y,waypoint.coord.z)
			--追加标记的发布消息----
			local PointMessage = "^* " .. waypoint.name .. " " .. self.uwid .. " ".. point.x .. " " .. point.z
			if (waypoint.name ~= "") then		--标记的名字必须不为空字符，才能发出去，不然不发送。
				TheNet:Say( PointMessage , false)
			else
				--虽然不发送消息，但是给自己做个提示，以免其他人不懂为什么发送不了
				Compatibility:ThePlayer().HUD.controls.networkchatqueue:DisplaySystemMessage("Unnamed 空名称")
			end
			--追加部分结束-----------
		end
	
	end
	
end
-------------------------

--self.waypoints = self.dataContainer:GetValue(self.uwid) or {}
----一键删除所有的风滚草标记----
function MainWp:Delete_All_Tumbleweed_Mark()
	local wid = nil
	local name = nil
	for i,v in pairs(self.waypoints) do
		if v then
			name = string.sub(v.name,1,11)
			if name and name == "tumbleweed_" then
				wid = i
				self:Remove(wid)
			end
		end
	end

end
-------------------------

----一键删除所有的风滚草标记  修复版----
function MainWp:Delete_All_Tumbleweed_Mark_EX()

	local old = {}
	local new = {}
	old = self.dataContainer:GetValue(self.uwid) or {}
	--self.waypoints = self.dataContainer:GetValue(self.uwid) or {}
	if not old then
		return
	end
	
	--对数组new进行初始化赋值
	local index = 0
	for i,w in pairs(old) do
		if w then
			index = index + 1
			new[index] = w
		end
	end
	--经过上面这样处理，new里面保证是没有nil值的，全是有值的waypoint数组
	--每个waypoint的name，要么是被赋值的字符串，要么是"NA"或者""，所以不可能是nil
	self.waypoints = new
	
	--这里用外部索引的方法
	index = 1
	for i=1,#self.waypoints do
		local firstName = string.sub(self.waypoints[index].name,1,11)
		if firstName and firstName == "tumbleweed_" then
			if self.markerMode then
				self:RemoveMarker(self.waypoints[index])
			end
			self:RemoveMapIcon(self.waypoints[index])
			table.remove(self.waypoints,index)
			
			index = index - 1
		end
		index = index + 1
	end
	
	self:UpdateList()
	self:SaveData()

end
-------------------------


--根据perfab添加标记
function MainWp:AddFromPoint_by_prefab(p_name,x,z,isRandom)

	--名称是否添加随机数字后缀
	if isRandom then
		local random_number = math.random(0,99)
		p_name = p_name.."-"..random_number	--拼接成完整的名字
	end
	
	
	local y = 0	-- 坐标是x和z，y在游戏里一直显示为0，既然下面很多部分用到了y，这里就创建一个。
	
	--追加的取整操作-----------
	x = math.floor(x)
	--y = math.floor(y)
	z = math.floor(z)
	------操作结束-------------

	-- GROUND from constants which is accessible
	--local iground={}
	--for k,v in pairs(GROUND) do
		--iground[v]=string.gsub(k, "(%a)([%w']*)", function(a,b)
			--return a:upper()..b:lower()
		--end)
	--end

	--local waypoint = Waypoint(iground[gid],
	local waypoint = Waypoint(p_name,
		{["x"]=x,["y"]=y,["z"]=z},
		{
			--风滚草的自动添加，还是彩色的比较好，贴合在一起的标记容易区分
			--r=math.random()*.7+.3,
			--g=math.random()*.7+.3,
			--b=math.random()*.7+.3,
			
			--白色
			r=255/255,
			g=255/255,
			b=255/255,
			
		}
	)
	
	--检查此坐标是否已经存在，存在则退出。
	for i,v in pairs(self.waypoints) do
		if v and v.coord and v.coord.x == x and v.coord.z == z then
			return
		end
	end
	
	table.insert(self.waypoints, waypoint)
	self:AddMapIcon(waypoint)
	if self.markerMode then
		self:AddMarker(waypoint)
	end
	
	self:LastPage()
end







function MainWp:ShowMpWarning()
	if self.dialogMp == nil then
		self.dialogMp = self:AddChild(DialogMp(nil,nil,self.skin))
		self.dialogMp:SetOkayCallback(function()
			self:KillMpDialog()
		end)
	else
		print("[waypoint] already editing!")
	end
end

return MainWp