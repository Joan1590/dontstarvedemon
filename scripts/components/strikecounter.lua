local function onupdate(self, dt)
	local oldval = self.charge
	local stuck = false
	local jump = false
	
	self.charge = self.charge - dt
	
	if ThePlayer then
		if ThePlayer:HasTag("playerghost") then
			self.charge = 0
		elseif ThePlayer.Light then
			if not ThePlayer.Light:IsEnabled() then
				self.charge = 0
			else
				local light_rad = ThePlayer.Light:GetRadius()
				
				-- See prefab file wx78 for why these numbers are used
				if light_rad == 3 and self.charge < 60 then
					stuck = true
					self.charge = 60
					
					if self.accurate == true then
						self.accurate = false
					end
				elseif self.accurate == false and light_rad > 0.11 and light_rad < 3 then
					jump = true
					self.accurate = true
					self.charge = 20 * light_rad
				end
			end
		end
	end
	
	if self.charge <= 0 then 
		self.charge = 0
		self.max_charge = 0
		self.accurate = false
		
		if self.charge_task ~= nil then
			self.charge_task:Cancel()
			self.charge_task = nil
		end
	elseif self.max_charge < self.charge then
		self.max_charge = self.charge
	end
	
	self.inst:PushEvent("chargechange", { oldval = oldval, newval = self.charge, max = self.max_charge, stuck = stuck, jump = jump })
end

local function TryStartOvercharge(self)
	self.accurate = false
	
	if self.max_charge < self.charge then
		self.max_charge = self.charge
	end
	
	self.inst:PushEvent("chargechange", { oldval = 0, newval = self.charge, max = self.max_charge, stuck = false, jump = false })
	
	if self.charge_task == nil and self.inst then
		self.charge_task = self.inst:DoPeriodicTask(1, function() onupdate(self, 1) end)
	end
end

local function AddStrike(self)
	local basedelta = TUNING.TOTAL_DAY_TIME
	local dampen = 3 * basedelta / (self.charge + 3 * basedelta)
	local dcharge = dampen * basedelta * .5 * (1 + 0.5 * dampen)
	self.charge = self.charge + dcharge
end

----------------------------------------------------------------------------------------

local StrikeCounter = Class(function(self, inst)
	self.inst = inst
	
	self.known_strikes = {}
	
	self.charge = 0
	self.max_charge = 0
	self.charge_task = nil
	
	self.accurate = false -- client light isn't 100% accurate, check it once only so it doesn't look inconsistent
end)

----------------------------------------------------------------------------------------

function StrikeCounter:SetMaxCharge(duration)
	self.max_charge = duration
end

function StrikeCounter:SetCharge(duration)
	self.charge = duration
	TryStartOvercharge(self)
end

function StrikeCounter:GetMaxCharge()
	return self.max_charge
end

function StrikeCounter:GetCharge()
	return self.charge
end

function StrikeCounter:TryAddCharge()
	if ThePlayer then
		-- clear out old strikes
		for k, v in pairs(self.known_strikes) do
			if v and (Ents[k] == nil or not Ents[k]:IsValid()) then
				self.known_strikes[k] = nil 
			end
		end
		
		local pos = ThePlayer:GetPosition() 
		local ents = TheSim:FindEntities(pos.x, 0, pos.z, 2) 
		
		for k, v in pairs(ents) do
			if v.prefab == "lightning" and not self.known_strikes[v.GUID] then 
				self.known_strikes[v.GUID] = true
				
				AddStrike(self)
				TryStartOvercharge(self)
			end
		end
	end
end

return StrikeCounter