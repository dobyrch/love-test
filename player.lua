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

local dtotal = 0
function Player:update(dt)
	dtotal = dtotal + dt
	if dtotal >= 0.25 then
		dtotal = dtotal - 0.25
	end

	_, _, width, height = self.quad:getViewport()
	dx, dy = 0, 0
	oldquad = self.quad
	if love.keyboard.isDown('down','d') and not love.keyboard.isDown('up','e') then
		if self.y < (love.graphics.getHeight() - height*scale) then
			dy = self.speed * dt
			if dtotal < 0.125 then
				self.quad = down_step1
			else
				self.quad = down_step2
			end
		end
	end
	if love.keyboard.isDown('up','e') and not love.keyboard.isDown('down','d') then
		if self.y > 0 then
			dy = -self.speed * dt
			if dtotal < 0.125 then
				self.quad = up_step1
			else
				self.quad = up_step2
			end
		end
	end
	if love.keyboard.isDown('left','s') and not love.keyboard.isDown('right','f') then
		if self.x > 0 then
			dx = -self.speed * dt
			if dtotal < 0.125 then
				self.quad = left_stand
			else
				self.quad = left_step
			end
		end
	end
	if love.keyboard.isDown('right','f') and not love.keyboard.isDown('left','s') then
		if self.x < (love.graphics.getWidth() - width*scale) then
			dx = self.speed * dt
			if dtotal < 0.125 then
				self.quad = right_stand
			else
				self.quad = right_step
			end
		end
	end

	if dx ~= 0 and dy ~= 0 then
		dx = dx / math.sqrt(2)
		dy = dy / math.sqrt(2)
	end

	self.x = self.x + dx
	self.y = self.y + dy
end


function Player:draw()
	love.graphics.draw(self.img, self.quad, self.x, self.y, 0, 4, 4)
end
