if TUNING.xiaoyao("加宽制作栏") then
	AddClassPostConstruct("widgets/tabgroup", function(self)
		--显示制作栏
		local oldShowTab=self.ShowTab
		self.ShowTab = function(self,tab)
			--有行号且行号超过1，则对tab的隐藏坐标偏移值进行增值
			if tab.colnum and tab.colnum>1 then
				if not self.shown[tab] then
					if self.base_pos[tab] then
						tab:MoveTo((self.base_pos[tab] + self.hideoffset*tab.colnum), self.base_pos[tab], .33)
						self.shown[tab] = true
						if self.onshowtab ~= nil then
							self.onshowtab()
						end
					end
				end
			else
				oldShowTab(self,tab)
			end
		end
		--隐藏制作栏
		local oldHideTab=self.HideTab
		self.HideTab = function(self,tab)
			--有行号且行号超过1，则对tab的隐藏坐标偏移值进行增值
			if tab.colnum and tab.colnum>1 then
				if self.shown[tab] then
					if self.base_pos[tab] then
						tab:MoveTo(self.base_pos[tab], (self.base_pos[tab] + self.hideoffset*tab.colnum), .33)
						self.shown[tab] = false
						if self.onhidetab ~= nil then
							self.onhidetab()
						end
					end
				end
			else
				oldHideTab(self,tab)
			end
		end
	end)
	
	AddClassPostConstruct("widgets/crafttabs", function(self)
		local colmaxtab=1--一列最多有多少个tab(一般是12个，如果有其他Mod插入制作栏也能智能扩增)
		for k, v in pairs(RECIPETABS) do
			if not v.crafting_station then
				colmaxtab = colmaxtab + 1
			end
		end
		local numtabs = 0--总tab数(不算隐藏的)
		for i, v in ipairs(self.tabs.tabs) do
		    if not v.collapsed then
		        numtabs = numtabs + 1
		    end
		end
		local col_numtabs=math.min(numtabs,colmaxtab)--每列tab数
		local spacing = 790/col_numtabs--math.max(790/col_numtabs,self.tabs.spacing)
		local scalar = spacing * (1 - col_numtabs) * .5
		local offset = self.tabs.offset * scalar
		local offsetx = Vector3(50, 0, 0)--x坐标修正
		--------------这里由于显示层级问题，所以需要排序在前面的靠右显示，从右往左依次排列
		local maxcol=math.ceil(numtabs/colmaxtab)--最大列数
		local maxcol_correct=colmaxtab*maxcol-numtabs--最右列数值校正
		local newpos=offset--新坐标
		local controllercrafting_tabidx = numtabs-(maxcol-1)*col_numtabs+1--键盘制作栏默认制作栏编号(默认都放到工具栏上)
		for _, v in ipairs(self.tabs.tabs) do
		    --不是隐藏的才需要更新新坐标，否则都输出在同一个位置
			if not v.collapsed then
				newpos=offset--每次都要重置下，避免叠加数值
				local colnum=math.ceil(numtabs/colmaxtab)--当前列
				if colnum<maxcol then
					maxcol_correct=0--当前列小于最大列，则取消数值校正
				end
				local rownum=(colmaxtab*colnum-numtabs)%colmaxtab-maxcol_correct--当前行
				--根据行号列号进行坐标计算
				newpos = offset + self.tabs.offset*spacing*rownum + offsetx*(colnum-1)
				v.colnum=colnum--记录行号
				numtabs=numtabs-1
			end
		    v:SetPosition(newpos)
		    self.tabs.base_pos[v] = Vector3(newpos:Get())
		end
		
		
		self.bg:SetScale(1,1,1)--防止其他mod把它拉长
		self.bg_cover:SetScale(1,1,1)--防止其他mod把它拉长
		
		
		self.bg:SetPosition(48,0,0)--背景图往外拉
		self.crafting.in_pos=Vector3(188,0,0)--鼠标制作栏往外拉
		self.controllercrafting.in_pos=Vector3(600,250,0)--键盘制作栏往外拉
		self.controllercrafting.tabidx=controllercrafting_tabidx--设置键盘制作栏默认制作栏编号
	end)
end
