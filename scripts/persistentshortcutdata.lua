local ShortcutData = Class(function(self,id)
	self.persistdata = {}
	self.id = id
	self._isdatasaved = true
end)

function ShortcutData:GetID()
	return self.id
end

function ShortcutData:Save()
	local encoded_var = json.encode(self.persistdata)
	SavePersistentString(self.id,encoded_var,ENCODE_SAVES)
	self._isdatasaved = true
end

function ShortcutData:Load(var)
	if not self._isdatasaved then
		self:Save()
	end
	TheSim:GetPersistentString(self.id,function(success,data)
		if success then 
			self.persistdata = json.decode(data)
		end 
	end,false)
	return self.persistdata
end

function ShortcutData:SetValue(entry,val)
	self.persistdata[entry] = val
	self._isdatasaved = false
end

function ShortcutData:SetPersistent(entry,val)
	self:SetValue(entry,val)
	self:Save()
end

function ShortcutData:GetValue(entry)
	return self.persistdata[entry]
end

return ShortcutData