
local function MakeFakeCharacterMarker(name)
	
	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		inst.Transform:SetFourFaced()
		inst.AnimState:SetBank("wilson")
		inst.AnimState:SetBuild(name)
		inst.AnimState:Hide("ARM_carry")
		inst.AnimState:Hide("HAT")
		inst.AnimState:Hide("HAIR_HAT")
		inst.AnimState:Show("HAIR_NOHAT")
		inst.AnimState:Show("HAIR")
		inst.AnimState:Show("HEAD")
		inst.AnimState:Hide("HEAD_HAT")
		inst.AnimState:PlayAnimation("idle_loop",false)--Don't loop to reduce spookiness
		inst.AnimState:SetMultColour(1,1,1,0.25)
		inst:AddComponent("skinner")
		inst:AddTag("player")--For the skinner component to work properly.
		inst:AddTag("extra_spooky")
		inst:AddTag("noblock")  
		inst:AddTag("noclick")--Play around "hovering item over something with an artificially added player-tag" crash.
		if TheWorld.ismastersim then
			inst.persists = false
		end
		return inst
	end
	return Prefab( "ghost_"..name, fn, nil)
end

local characters_ = {}
for name,_ in pairs(STRINGS.CHARACTER_NAMES) do
	if name ~= "unknown" and name ~= "random" then
		local character = MakeFakeCharacterMarker(name)
		table.insert(characters_,character)
	end
end

return unpack(characters_ or {})
