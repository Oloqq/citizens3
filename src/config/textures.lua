local t = {}
local gr = love.graphics

t["transparent"] = "img/transparent.png"

t["unit"] = "img/unit.png"

for k,v in pairs(t) do
	t[k] = gr.newImage(v)
end

return t