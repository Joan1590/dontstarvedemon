local assets=
{
	Asset("ANIM", "anim/fanweixianshi.zip")    
}


local function fn()
	local inst = CreateEntity()
	
	inst.persists = false

	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	trans:SetScale(0.001,0.001,0.001)
	
	anim:SetBank("fanweixianshi")
	anim:SetBuild("fanweixianshi")
	anim:PlayAnimation("idle")
	anim:SetOrientation(ANIM_ORIENTATION.OnGround)
	anim:SetLayer(LAYER_BACKGROUND)
	
    	inst:AddTag("FX")


   	 return inst
end

return Prefab( "common/xiaoyaofanweixianshi", fn, assets) 