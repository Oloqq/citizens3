--[[
Olo 2017-2018
v2.0
Library for dealing with files and strings
]]

ff = {}

ff.spaces = true

--[[
returns value from string saved like:
description=value or
description = value (set spaces as true)
]]
function ff.val(str, spaces)
	local s = ff.stringVal(str, spaces)
	--s is now the value represented as string

	if s == "false" or s == "f" then
		return false
	end
	if s == "true" or s =="t" then 
		return true
	end

	return tonumber(s)
end

function ff.stringVal(str, spaces)
	spaces = spaces or ff.spaces
	local s = ""

	local i = 1
	local l = string.len(str)
	local act = str:sub(i, i)
	while act ~= "=" do
		i = i + 1
		act = str:sub(i, i)
		if i > #str then
			return str
		end
	end

	if spaces == true then
		i = i + 2
	else
		i = i + 1
	end

	s = str:sub(i)

	return s
end

function ff.dottedVals(str, spaces)
	s = ff.stringVal(str, spaces)

	tab = {}

	local i = 1
	while i < s:len() do
		local word = ""
		local act = s:sub(i, i)
		
		while act ~= "." do
			word = word..act
			i = i + 1
			act = str:sub(i, i)
		end
		i = i + 1

		table.insert(tab, tonumber(word))
	end

	return tab
end


return ff