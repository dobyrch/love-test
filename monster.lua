require 'entity'

Monster = {time=0, quads={}}
setmetatable(Monster, {__index=Entity})

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
	self.width = 16
	self.height = 16

	self.img = love.graphics.newImage('assets/octorok.png')
	self.img:setFilter('linear', 'nearest')

	for i = 1,8 do
		self.quads[i] = love.graphics.newQuad(
			i + (i - 1)*self.width,
			0,
			self.width,
			self.height,
			self.img:getDimensions()
		)
	end

	self.q = 1
	self.steps = 0

	return instance
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
