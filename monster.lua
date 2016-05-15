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

	self.x = 30
	self.y = 30
	self.speed = 30

	self.img = love.graphics.newImage('assets/octorok.png')
	self.img:setFilter('linear', 'nearest')
	self.quads[1] = love.graphics.newQuad(1, 0, 16, 17, self.img:getDimensions())
	self.quads[2] = love.graphics.newQuad(18, 0, 16, 17, self.img:getDimensions())
	self.quads[3] = love.graphics.newQuad(36, 0, 16, 17, self.img:getDimensions())
	self.quads[4] = love.graphics.newQuad(54, 0, 16, 17, self.img:getDimensions())
	self.quads[5] = love.graphics.newQuad(72, 0, 16, 17, self.img:getDimensions())
	self.quads[6] = love.graphics.newQuad(90, 0, 16, 17, self.img:getDimensions())
	self.quads[7] = love.graphics.newQuad(108, 0, 16, 17, self.img:getDimensions())
	self.quads[8] = love.graphics.newQuad(125, 0, 16, 17, self.img:getDimensions())
	self.q = 1
	self.steps = 0

	return instance
end


function Monster:inBounds()
	local width, height
	_, _, width, height = self.quads[self.q]:getViewport()

	return self.x > 0 and self.y > 0 and
		self.x < love.graphics.getWidth() - height and
		self.y < love.graphics.getHeight() - height
end


function Monster:update(dt)
	self.time = self.time + dt
	while self.time > 0.125 do
		self.steps = self.steps + 1
		self.time = self.time - 0.125

		if self.steps < 0 then
			break
		end

		if self:inBounds() then
			if self.q % 2 == 0 then
				self.q = self.q - 1
			else
				self.q = self.q + 1
			end
		end

		if self.steps > 6 or self.steps > 1 and love.math.random() < 0.15 then
			self.steps = -3
			self.q = love.math.random(4) * 2
		end
	end

	local xdir, ydir
	if self.q > 6 then
		xdir = 1
		ydir = 0
	elseif self.q > 4 then
		xdir = 0
		ydir = -1
	elseif self.q > 2 then
		xdir = 0
		ydir = 1
	else
		xdir = -1
		ydir = 0
	end

	if self:inBounds() and self.steps >= 0 then
		self.x = self.x + self.speed*dt*xdir
		self.y = self.y + self.speed*dt*ydir

	end

	if not self:inBounds() then
		self.x = self.x - self.speed*dt*xdir
		self.y = self.y - self.speed*dt*ydir
		self.steps = 0
		self.q = love.math.random(4) * 2
	end

	self.quad = self.quads[self.q]
end

function Monster:draw()
	love.graphics.draw(self.img, self.quads[self.q], self.x, self.y)
end
