

--此数据读写模块是相同原理的ini版本，ini更适合人类阅读和编辑。

-- ini文件里的内容 格式为 key=value 的形式：
--[[

a=1
b=2
c=AAA
d=EEE
--这一行代表注释

内存结构为

local the_table = 
{
"a" = "1",
"b" = "2",
"c" = "AAA",
"d" = "EEE",
}

]]--


--目前有个麻烦的地方就是注释只支持单独占据一行，不能跟其他内容混行。
--还有就是会把注释给清除掉，所以ini的注释，只适合当用户参考的模板
--所以，索性就干脆tm的别在数据里面搞注释，分开搞算了。


--但是还有一个问题：ini文件，本来就是：用户负责编辑，程序负责读取的，
--所以，这些注释行，只在用户编辑的时候，发挥作用，
--让程序写入的时候，自动就过滤掉这些注释，也无关紧要。

--[[
还有一种数据文件的结构是一行一行的，并非键值对结构，比如怪物清单：

monster1
monster2
monster3
...

这种对应的内存结构就是

local string_table = 
{
"monster1",
"monster2",
"monster3",
}



]]--


--datatype代表数据文件的存储类型
--1 LineData 数据清单 结构
--2 KeyAndValue key=value 键值对结构



local _G = GLOBAL
local debugmod = false	--是否打印日志

local function debugprint(str)
	if debugmod then
		print("[file-io]" .. str)
	end
end

--对字符串去除指定的字符
local function trim(str,the_char)
	if not str then
		return false
	end
	
	--str = string.gsub(str,"\r","")
	str = string.gsub(str,the_char,"")
	
	return str
end

--分割1个字符串 到 字符串数组---
local function Split_String_To_String_Table(str, split_char)    
    local sub_str_tab = {}

    while true do          
        local pos = string.find(str, split_char) 

        if not pos then              
            table.insert(sub_str_tab,str)
            break
        end  

        local sub_str = string.sub(str, 1, pos - 1)              
        table.insert(sub_str_tab,sub_str)
        str = string.sub(str, pos + 1, string.len(str))
    end      

    return sub_str_tab
end




--把一行内容转换为key-value的键值对,存入内存数据表
local function TranslateOneLineToKeyAndValue(OneLineString)
	debugprint("debug007")
	debugprint(OneLineString)

	local tmp_str_table = {}
	--以=号为分隔符
	tmp_str_table = Split_String_To_String_Table(OneLineString,"=")
	
	debugprint("debug008")
	
	for index,each in pairs(tmp_str_table)do
		debugprint(index .. "----" .. each)
	end
	
	return tmp_str_table
end



--删除一个字符串数组中的所有注释行
local function RemoveCommentLine(str_table)
	local new_table = {}
	for index,each in pairs(str_table) do
		local foundStr = string.sub(each,1,2)
		if foundStr ~= "--" then
			table.insert(new_table,each)
		end
	end
	
	return new_table
end




local function SaveDataToFile(filename,datatype,dataBase)
	local fileObject = _G.io.open(filename,"w")
	if not fileObject then
		return false
	end
	
	local oneLine = ""
	
	if datatype == "LineData" then
		for index,each in pairs(dataBase) do
			oneLine = each .. "\n"
			fileObject:write(oneLine)
		end
	elseif datatype == "KeyAndValue" then
		for index,each in pairs(dataBase) do
			oneLine = index .. "=" .. each .. "\n"
			fileObject:write(oneLine)
		end
	else
		fileObject:close()
		return false
	end
	
	fileObject:close()
	return true
end

local function LoadDataFromFile(filename,datatype)
	local dataBase = {}
	
	local fileObject = _G.io.open(filename,"r")
	if not fileObject then
		return false
	end
	
	--真尼玛坑，不同环境下，_G.io.read() 有的是读取整个文件的所有字符，有的是只读取一行字符，坑了我一个晚上做测试排查才发现的，马勒戈壁
	
	local oneLine = ""
	if datatype == "LineData" then
		while true do
			oneLine = fileObject:read("*l")		--用这个参数强制规定 一次只读取一行
			if not oneLine then
				break
			end
			
			oneLine = trim(oneLine,"\r")
			oneLine = trim(oneLine,"\n")
			
			debugprint("011")
			debugprint(oneLine)
			
			table.insert(dataBase,oneLine)	--插入一行
		end
	elseif datatype == "KeyAndValue" then
		while true do
			oneLine = fileObject:read("*l")
			if not oneLine then
				break
			end
			
			oneLine = trim(oneLine,"\r")
			oneLine = trim(oneLine,"\n")
			
			
			debugprint("010")
			debugprint(oneLine)		--尼玛这里读取的一行是带行尾的\n 上面读取的就不带，真尼玛坑，Linux 和  windows 换行符不一致卧槽
			
			
				
				
			local key_and_value = TranslateOneLineToKeyAndValue(oneLine)
			--if key_and_value then
				local key = key_and_value[1]
				local value = key_and_value[2]
				dataBase[key] = value	--插入一对 key=value
				debugprint("009")
				debugprint(dataBase[key])
			--end
		end
	else
		fileObject:close()
		return false
	end
	
	fileObject:close()
	return dataBase
end

------------------------------------------------------------------------------------------------------

--程序入口
function GetMyData(filename,datatype)
	local dataBase = {}
	local dataBase = LoadDataFromFile(filename,datatype)
	if dataBase then
		return dataBase
	else
		return false
	end
end

function SaveMyData(filename,dataBase,datatype)
	return SaveDataToFile(filename,datatype,dataBase)
end

--初始化数据表
--传入一个初始化的数据表，如果读取文件失败，则直接用这个初始化的数据表来存入文件
function InitDataBase(filename,datatype, InitDataBase)
	local outtable = {}
	outtable = GetMyData(filename,datatype)
	
	if not outtable then
		SaveMyData(filename,InitDataBase,datatype)
		outtable = InitDataBase
	end
	
	return outtable
end

