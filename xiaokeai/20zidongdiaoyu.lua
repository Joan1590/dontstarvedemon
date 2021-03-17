








--自动钓鱼

GLOBAL.TheInput:AddKeyDownHandler(TUNING.xiaoyao("钓鱼按键"), function()
if not GLOBAL.ThePlayer then return end
		if GLOBAL.ThePlayer.diaoyu then
			GLOBAL.ThePlayer.diaoyu:SetList(nil)
			GLOBAL.ThePlayer.diaoyu = nil		
			return
		end
		GLOBAL.ThePlayer.zdpr = GLOBAL.ThePlayer:GetPosition()
		local rpc_id = nil
		for k,v in pairs(GLOBAL.AllRecipes) do 
			if v.name == "fishingrod" then 
				rpc_id = v.rpc_id
			end 
		end
		if rpc_id == nil then return end
		local pos = GLOBAL.ThePlayer.zdpr
		local qmc = GLOBAL.ThePlayer.components.playercontroller
		local B = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		local ku = GLOBAL.ThePlayer.replica.inventory
		----
		local function zhuangbei()
			local sousuo = nil
			for i=1,ku:GetNumSlots() do
				local sou_1 = ku:GetItemInSlot(i)
				if sou_1 and sou_1.prefab == "fishingrod" then
					sousuo = sou_1
					break
				end
			end
			local beibao = GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BODY
			local Bbao = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(beibao)
			if Bbao and not sousuo then
			if not Bbao.replica.container then return end
				for i=1,Bbao.replica.container:GetNumSlots() do
					local sou_1 = Bbao.replica.container:GetItemInSlot(i)
					if sou_1 and sou_1.prefab == "fishingrod" then
						sousuo = sou_1
						break
					end
				end
			end
			return sousuo
		end
		-----
		if not B or B.prefab ~= "fishingrod" then
			local C = zhuangbei()
			if not C then
				return
			end
			ku:EquipActiveItem()
		end
		GLOBAL.ThePlayer.diaoyu = GLOBAL.ThePlayer:StartThread(function()
		local qid = true
		local ccc = 0.1
			while qid do
				local ku = GLOBAL.ThePlayer.replica.inventory
				local beibao = GLOBAL.EQUIPSLOTS.BACK or GLOBAL.EQUIPSLOTS.BODY
				local Bbao = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(beibao)
				local B = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
				if not B or B.prefab ~= "fishingrod" then
					local C = zhuangbei()
					if not C and GLOBAL.ThePlayer.replica.builder:CanBuild("fishingrod") then
						GLOBAL.SendRPCToServer(GLOBAL.RPC.MakeRecipeFromMenu, rpc_id, nil)
						GLOBAL.Sleep(1)
					end
					local B = GLOBAL.ThePlayer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
					if not B or B.prefab ~= "fishingrod" then
						local C = zhuangbei()
						if not C then
							return
						end
						ku:EquipActiveItem()
						GLOBAL.Sleep(0.3)
					end
				end
				local C = nil
				C = GLOBAL.FindEntity(GLOBAL.ThePlayer,20,function(guy)
					return (guy.prefab == "pond" or guy.prefab == "pond_mos" or guy.prefab == "pond_cave"
					or guy.prefab == "oasislake") and guy:GetDistanceSqToPoint(pos:Get()) < 14*14
					end,nil,{ "INLIMBO", "noauradamage" })
				if C ~= nil and qid then
					local A = C:GetPosition() 
					local controlmods = qmc:EncodeControlMods() 
					local E,F = GLOBAL.ThePlayer.components.playeractionpicker:DoGetMouseActions(A, C) 
					if E then
						local S = E and E:GetActionString() or ""
						if S ~= GLOBAL.STRINGS.ACTIONS.REEL.CANCEL then
							qmc:DoAction(E)
							GLOBAL.Sleep(0.1)
							GLOBAL.SendRPCToServer(GLOBAL.RPC.LeftClick, E.action.code, A.x, A.z, C, false, controlmods, false, E.action.mod_name)
						end
					end
				else
					qid = false
					GLOBAL.ThePlayer.diaoyu:SetList(nil)
					GLOBAL.ThePlayer.diaoyu = nil		
				end
				GLOBAL.Sleep(ccc)
			end
		end)
	end)

