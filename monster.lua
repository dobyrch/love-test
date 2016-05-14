Monster = {time=0, quads={}}

local left_step
local left_stand
local down_stand
local down_step
local up_step
local up_stand
local right_stand
local right_step


function Monster:new()
	instance = {}
	setmetatable(instance, self)
	self.__index = self

	self.x = 30 * scale
	self.y = 30 * scale

	self.img = love.graphics.newImage('assets/octorok.png')
	self.img:setFilter('linear', 'nearest')
	self.quads[1] = love.graphics.newQuad(1, 0, 16, 16, self.img:getDimensions())
	self.quads[2] = love.graphics.newQuad(18, 0, 16, 16, self.img:getDimensions())
	self.quads[3] = love.graphics.newQuad(36, 0, 16, 16, self.img:getDimensions())
	self.quads[4] = love.graphics.newQuad(54, 0, 16, 16, self.img:getDimensions())
	self.quads[5] = love.graphics.newQuad(72, 0, 16, 16, self.img:getDimensions())
	self.quads[6] = love.graphics.newQuad(90, 0, 16, 16, self.img:getDimensions())
	self.quads[7] = love.graphics.newQuad(108, 0, 16, 16, self.img:getDimensions())
	self.quads[8] = love.graphics.newQuad(125, 0, 16, 16, self.img:getDimensions())
	self.q = 1
	
	return instance
end


function Monster:update(dt)
	self.time = self.time + dt
	while self.time > 1 do
		self.q = self.q % 8 + 1
		self.time = self.time - 1
	end
end

function Monster:draw()
	love.graphics.draw(self.img, self.quads[self.q], self.x, self.y, 0, scale, scale)
end
