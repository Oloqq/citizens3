--[[
Olo 2017
v2.2.1
Library containing often used calculations
]]

local ut = {}
ut.collisionType = nil
ut.soundVar = true
ut.musicVar = true
ut.musicPlaying = nil

function ut.init(collisionType, soundVar, musicVar)
    if collisionType == "tl" then
        ut.collision = ut.collisionTopLeft
    elseif collisionType == "ch" then
        ut.collision = ut.collisionCentHalf
    elseif collisionType == "cf" then
        ut.collision = ut.collisionCentFull
    elseif collisionType == "r" then
        ut.collision = ut.collisionRound
    end
    ut.soundVar = soundVar or ut.soundVar
    ut.musicVar = musicVar or ut.musicVar
end

function ut.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--collision for objects with their center as positon and size = full width full height
function ut.collisionCentFull(a, b)
	if a.x + a.width/2 > b.x - b.width/2 and
    a.x - a.width/2 < b.x + b.width/2 and
    a.y + a.height/2 > b.y - b.height/2 and
    a.y - a.height/2 < b.y + b.height/2 then
        return true
    else
        return false
    end
end

--collision for objects with their center as positon and size = half width half height
function ut.collisionCentHalf(a, b)
	if a.x + a.width > b.x - b.width and
    a.x - a.width < b.x + b.width and
    a.y + a.height > b.y - b.height and
    a.y - a.height < b.y + b.height then
        return true
    else
        return false
    end
end

--collision for objects with their left top corner as positon and size = full width full height
function ut.collisionTopLeft(a, b)
	if a.x + a.width > b.x and
    a.x < b.x + b.width and
    a.y + a.height > b.y and
    a.y < b.y + b.height then
        return true
    else
        return false
    end
end

--collision for objects with their center as position and radius/size as radius
function ut.collisionRound(o1, o2)
    local a, b, c
    a = math.abs(o1.y - o2.y)
    b = math.abs(o1.x - o2.x)
    c = math.sqrt(math.pow(a, 2) + math.pow(b, 2))

    a = o1.radius or o1.size or print("ERROR: utility.lua: collisionRound: o1.radius=nil")
    b = o2.radius or o2.size or print("ERROR: utility.lua: collisionRound: o2.radius=nil")
    if c < a + b then
       return true
    end
    return false
end

--set active as false for every element
function ut.makeFree(tab, makeFull)
    makeFull = makeFull or false
	for i, v in ipairs(tab) do
		v.active = makeFull
	end
end

function ut.findFree(tab, con)
    for i, v in ipairs(tab) do
        if v.active == false then
            return i, v
        end
    end
    if con then
        tab[#tab + 1] = con()
        return #tab, tab[#tab]
    end
    --return -1 as error code, return first object in the table just in case
    return -1, tab[1]
end

function ut.play(source, mode, loop)
    local nsrc = nil

    if mode == "m" and ut.musicVar then
        if ut.musicPlaying then
            ut.musicPlaying:stop()
        end
    elseif ut.soundVar then
        --
    else
        return
    end

    if type(source) == "string" then
        nsrc = love.audio.newSource(source)
    else
        nsrc = source
    end

    if mode == 'm' then
        ut.musicPlaying = nsrc
    end

    nsrc:setLooping(loop)
    nsrc:play()

    return nsrc
end

--calculates dmg after applying target's resistance
function ut.dmgResisted(dmg, resistance)
    if resistance >= 0 then
        return dmg * 100 / (100 + resistance)
    else
        return dmg * 2 - 100 / (100 - resistance)
    end
end

--seen should be ingored as it is just for recursion
function ut.tableDeepCopy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[ut.tableDeepCopy(k, s)] = ut.tableDeepCopy(v, s) end
    return res
end
ut.deepTableCopy = ut.tableDeepCopy

function ut.pythagoras(a, b)
    return math.sqrt(a * a + b * b)
end

ut.collision = ut.collisionTopLeft
return ut

--[[
v2.1 added collision function for round objects
     init() can get nil values to not change values
v2.2 added dmgResisted()
     added tableDeepCopy() for copying tables by value
     added pythagoras
v2.2.1 fixed bug where tableDeepCopy would return nil if original was empty
]]