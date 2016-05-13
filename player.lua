Player = {}

function Player:new()
	instance = {}
	setmetatable(instance, self)
	self.__index = self
	return instance
end


function Player:init(scale)
	self.x = 70 * scale
	self.y = 70 * scale
	self.speed = 60 * scale

	self.img = love.graphics.newImage('assets/link.png')
	self.img:setFilter('linear', 'nearest')
	up_step1 = love.graphics.newQuad(0, 0, 12, 16, self.img:getDimensions())
	up_step2 = love.graphics.newQuad(14, 0, 12, 16, self.img:getDimensions())
	right_stand = love.graphics.newQuad(28, 0, 14, 16, self.img:getDimensions())
	right_step = love.graphics.newQuad(44, 0, 13, 16, self.img:getDimensions())
	left_step = love.graphics.newQuad(59, 0, 13, 16, self.img:getDimensions())
	left_stand = love.graphics.newQuad(74, 0, 14, 16, self.img:getDimensions())
	down_step1 = love.graphics.newQuad(89, 0, 14, 16, self.img:getDimensions())
	down_step2 = love.graphics.newQuad(103, 0, 14, 16, self.img:getDimensions())
	self.quad = down_step1
end

function Player:draw()
	love.graphics.draw(self.img, self.quad, self.x, self.y, 0, 4, 4)
end
