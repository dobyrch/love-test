Background = {time=0, fq=1}

local grass, grass_w, grass_h, grass_quads
local flowers, flower_w, flower_h, flower_quads
local quadinfo


function Background:new(tiles)
	instance = {tiles=tiles}
	setmetatable(instance, self)
	self.__index = self
	return instance
end


function Background:update(dt)
	self.time = self.time + dt
	if self.time >= 0.40 then
		self.time = self.time - 0.40
		self.fq = self.fq%4 + 1
	end
end


function Background:draw()
	for i, row in ipairs(self.tiles) do
		for j, num in ipairs(row) do
			local x, y = (j-1)*16*scale, (i-1)*16*scale
			if num == 0 then
				love.graphics.draw(flowers, flower_quads[self.fq], x, y, 0, scale, scale)
			else
				love.graphics.draw(grass, grass_quads[num], x, y, 0, scale, scale)
			end
		end
	end
end


grass = love.graphics.newImage('assets/grass.png')
grass:setFilter('linear', 'nearest')
grass_w, grass_h = grass:getWidth(), grass:getHeight()
quadinfo = {
	{0,  0}, {17,  0}, {34,  0},
	{0, 17}, {17, 17}, {34, 17},
	{0, 34}, {17, 34}, {34, 34},
}
grass_quads = {}
for i, qi in ipairs(quadinfo) do
	grass_quads[i] = love.graphics.newQuad(qi[1], qi[2], 16, 16, grass_w, grass_h)
end

flowers = love.graphics.newImage('assets/flowers.png')
flowers:setFilter('linear', 'nearest')
flower_w, flower_h = flowers:getWidth(), flowers:getHeight()
flower_quads = {}
quadinfo = {
	{0, 0}, {17, 0}, {34, 0}, {51, 0},
}
for i, qi in ipairs(quadinfo) do
	flower_quads[i] = love.graphics.newQuad(qi[1], qi[2], 16, 16, flower_w, flower_h)
end
