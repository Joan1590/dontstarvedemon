
	local smallmap_atlaslist = {}
	local filename = GLOBAL.MODS_ROOT.."smallmap_index.txt"

	local hfile,msg = GLOBAL.io.open(filename, "r")
	if hfile then
		for line in hfile:lines() do
			local fullname = string.gsub(line,"%s*$","")
			table.insert( Assets, Asset("ATLAS", string.gsub(fullname,"^UI|","")) )
			table.insert( smallmap_atlaslist, fullname )
		end
		hfile:close()
	end
--[[
--]]


--//
	local smallmap_data = nil
	local smallmap_data_saved = nil

	local function loadConfigData()
		local fname = "mod_config_data/smallmap"
		GLOBAL.TheSim:GetPersistentString(fname, function(load_success, str)
			if load_success then
				local success, data = GLOBAL.RunInSandboxSafe(str)
				if success and data ~= nil then
					smallmap_data = data
				end
			end
		end)
	end
	local function saveConfigData()
		local fname = "mod_config_data/smallmap"
		GLOBAL.SavePersistentString(fname, GLOBAL.DataDumper(smallmap_data, nil, true), false, nil)
	end


--//
	local SmallMap = GLOBAL.require "widgets/smallmap"

	AddClassPostConstruct("widgets/controls", function(self, owner)
		loadConfigData()
		if type(smallmap_data) ~= "table" then smallmap_data = {} end
		smallmap_data.blendmode = TUNING.xiaoyao("小地图混合模式")
		smallmap_data.blendmode_bg = TUNING.xiaoyao("背景混合模式")
		smallmap_data_saved = GLOBAL.deepcopy(smallmap_data)
		self.smallmap = self:AddChild(SmallMap(smallmap_data, smallmap_atlaslist))-- .top_root
		self.smallmap:MoveToBack()
		--//
		GLOBAL.ThePlayer:ListenForEvent("smallmap_save_config", function(inst)
			smallmap_data = self.smallmap:GetConfigData()
			if type(smallmap_data_saved) ~= "table" then smallmap_data_saved={} end
			local tbl = {}
			local chk = false
			for k,v in pairs(smallmap_data) do
				if chk == false and smallmap_data_saved[k] ~= v then chk=true end
				tbl[k] = v
			--	tbl[k] = GLOBAL.deepcopy(v)
			end
			if chk then
				saveConfigData(smallmap_data)
				smallmap_data_saved = tbl
			end
		end)
	end)


--//
	local mapscreen_zoomlevel = 1

	AddClassPostConstruct("screens/mapscreen", function(self, owner)
		local zoomget = self.minimap.minimap:GetZoom()
		self.minimap.minimap:Zoom( mapscreen_zoomlevel - zoomget )
	--	modprint("mapscreen_zoomlevel", mapscreen_zoomlevel - zoomget, mapscreen_zoomlevel,zoomget)
		local OnBecomeInactive_old = self.OnBecomeInactive or function() end
		function self.OnBecomeInactive(self)
			OnBecomeInactive_old(self)
			mapscreen_zoomlevel = self.minimap.minimap:GetZoom()
		--	modprint("mapscreen_zoomlevel", mapscreen_zoomlevel)
			GLOBAL.ThePlayer.HUD.controls.smallmap:GetMapControl()
		end
	end)


--[[
--]]



