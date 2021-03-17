local function MakeSnapTillPlacer(self, x, z, index)
    if self.linked == nil then
        self.linked = {}
    end

    local inst = SpawnPrefab("snaptillplacer")
    if inst then
        inst.Transform:SetPosition(x, 0, z)
        --inst:SetDebugNumber(index)
        table.insert(self.linked, inst)
    end
end

local function ApplayVisible(self)
    if self.linked ~= nil then
        for _, v in ipairs(self.linked) do
            if self.visible then
                v:Show()
            else
                v:Hide()
            end
        end
    end
end

local SnapTillPlacer = Class(function(self, inst)
    self.inst = inst
    self.linked = nil
    self.cachetilepos = nil
    self.cachesnapmode = nil
    self.cacheadjacentsoil = nil
    self.visible = true
    self.inst:StartUpdatingComponent(self)
end)

function SnapTillPlacer:ClearLinked()
    if self.linked ~= nil then
        for _, v in ipairs(self.linked) do
            v:Remove()
        end
        self.linked = nil
    end
end

function SnapTillPlacer:Hide()
    self.visible = false
    ApplayVisible(self)
end

function SnapTillPlacer:Show()
    self.visible = true
    ApplayVisible(self)
end

function SnapTillPlacer:OnUpdate(dt)
    if self.inst == nil then
        self:ClearLinked()
        return
    end

    if self.inst.components.snaptiller.snapmode == 0 then
        self:ClearLinked()
        return
    end 

    if self.inst.components.snaptiller == nil or self.inst.replica.inventory == nil or
       (self.inst.replica.rider and self.inst.replica.rider:IsRiding()) then
        self:ClearLinked()
        return
    end

    local equippeditem = self.inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

    if not equippeditem or (equippeditem and
                            equippeditem.prefab ~= "farm_hoe" and
                            equippeditem.prefab ~= "golden_farm_hoe" and
                            equippeditem.prefab ~= "quagmire_hoe") then
        self:ClearLinked()
        return
    end

    local pos = nil

    if TheInput:ControllerAttached() then
        pos = Point(self.inst.entity:LocalToWorldSpace(0, 0, 0))
    else
        local activeitem = self.inst.replica.inventory:GetActiveItem()

        if activeitem ~= nil then
            self:ClearLinked()
            return
        end

        pos = TheInput:GetWorldPosition()
    end

    if not pos then
        self:ClearLinked()
        return
    end

    local tilex, tiley = TheWorld.Map:GetTileCoordsAtPoint(pos.x, pos.y, pos.z)
    local tile = TheWorld.Map:GetTile(tilex, tiley)

    if self.cachetilepos == nil then
        self.cachetilepos = {tilex, tiley}
    end

    if self.cachesnapmode == nil then
        self.cachesnapmode = self.inst.components.snaptiller.snapmode
    end

    if self.cachesnapmode == 1 then
        local res = self.inst.components.snaptiller:HasAdjacentSoilTile(Point(TheWorld.Map:GetTileCenterPoint(tilex, tiley)))
        if self.cacheadjacentsoil ~= res then
            self.cacheadjacentsoil = res
            self:ClearLinked()
        end
    end

    if tile == GROUND.FARMING_SOIL or tile == GROUND.QUAGMIRE_SOIL then
        if self.cachetilepos[1] ~= tilex or self.cachetilepos[2] ~= tiley or
           self.cachesnapmode ~= self.inst.components.snaptiller.snapmode or self.linked == nil then
            self:ClearLinked()
            local snaplist = self.inst.components.snaptiller:GetSnapListOnTile(tilex, tiley)
            for i, v in ipairs(snaplist) do
                MakeSnapTillPlacer(self, v[1], v[2], i)
            end
            self.cachetilepos = {tilex, tiley}
            self.cachesnapmode = self.inst.components.snaptiller.snapmode
            ApplayVisible(self)
        end
    else
        self:ClearLinked()
    end

    if self.linked ~= nil then
        local cantill = true
        for _, v in ipairs(self.linked) do
            if self.inst.components.snaptiller.isquagmire then
                cantill = TheWorld.Map:CanTillSoilAtPoint(Point(v.Transform:GetWorldPosition()))
            else
                cantill = TheWorld.Map:CanTillSoilAtPoint(v.Transform:GetWorldPosition())
            end

            if cantill then
                v.AnimState:PlayAnimation("on", false)
            else
                v.AnimState:PlayAnimation("off", false)
            end
        end
    end
end

SnapTillPlacer.OnRemoveEntity = SnapTillPlacer.ClearLinked
SnapTillPlacer.OnRemoveFromEntity = SnapTillPlacer.ClearLinked

return SnapTillPlacer
