--Same as from my Chest Memory mod, but the name is changed so I could modify one or another and they wouldn't overwrite each other.
local PlayerData = Class(function(self,id)
        self.persistdata = {}
        self.id = id
        self._isdatasaved = true
    end)
    
    function PlayerData:GetID()
        return self.id
    end
    
    function PlayerData:ChangePersistData(val)
        if type(val) == "table" then
            self.persistdata = val
            --print("WARNING: Persistdata has been changed to another table")
            --print("Saving it will remove the previous known data")
        else
            print("ERROR: Attempted to change persistdata with a non-table value")
        end
        
    end
    
    function PlayerData:Save()
        --[[print("self.persistdata:")
        for k,v in pairs(self.persistdata) do print(k,v) end
        print("------------")--]]
        local encoded_var = json.encode(self.persistdata)
        SavePersistentString(self.id,encoded_var,ENCODE_SAVES)
        self._isdatasaved = true
    end
    
    function PlayerData:Load(var)
        if not self._isdatasaved then
            self:Save()
        end
		if not self.id then return end
        TheSim:GetPersistentString(self.id,function(success,data)
                if success then 
                    self.persistdata = json.decode(data)
                end 
            end,false)
        return self.persistdata
    end
    
    function PlayerData:SetValue(entry,val)
        self.persistdata[entry] = val
        self._isdatasaved = false
    end
    
    function PlayerData:SetIndexedValue(index,entry,val)--Because it's annoying using the entire cake when you just want a slice.
       if self.persistdata[index] ~= nil then
          self.persistdata[index][entry] = val 
       else
           self.persistdata[index] = {}
           self.persistdata[index][entry] = val
       end
    end
    
    function PlayerData:SetPersistent(entry,val)
        self:SetValue(entry,val)
        self:Save()
    end
    
    function PlayerData:SetIndexedPersistent(index,entry,val)
       self:SetIndexedValue(index,entry,val)
       self:Save()
    end
    

    function PlayerData:GetValue(entry)
        return self.persistdata[entry]
    end
    
    function PlayerData:GetPersistDataTable()
        return self.persistdata
    end
    
    
    
    return PlayerData