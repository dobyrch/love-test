subclass = require 'subclass'
Entity = require 'entity'
Sword = require 'sword'
shader = require 'shader'


local Player = subclass(Entity, {alignment='good'})


function Player:new()
	local instance
	instance = self:super()
	instance:setAction('walk')
	instance.x = 30
	instance.y = 30
	instance.speed = 60
	instance.health = 10
	instance.harmable = true
	instance.animation = Animation:new('link.png', 0.125)
	return instance
end


function Player:swing(dt)
	if not self.sword then
		self.sword = Sword:new()
		self.sword.x = self.x
		self.sword.y = self.y
		self.sword.dir = self.dir
	end

	self.time = self.time + dt

	if self.time >= self.sword.animation:getLength() then
		self.sword.deleted = true
		self.sword = nil
		self:setAction('walk')
	end

	--[[
	local qtab, xtab, ytab
	if self.time > 0.217 then
		xtab = {-self.width,-self.width, self.width,self.width, 0,0, 0,0}
		ytab = {0,0, 0,0, -self.height,-self.height, -self.height,-self.height}
		self.sword.animation:nextFrame(dt)
	elseif self.time > 0.083 then
		xtab = {-self.width,-self.width, self.width,self.width, self.width,self.width, -self.width,-self.width}
		ytab = {self.height,self.height, -self.height,-self.height, -self.height,-self.height, -self.height,-self.height}
		self.sword.animation:nextFrame(dt)
	elseif self.time > 0.033 then
		qtab = {3,3, 6,6, 9,9, 12,12}
		xtab = {0,0, 0,0, self.width,self.width, -self.width,-self.width}
		ytab = {self.height,self.height, -self.height,-self.height, 0,0, 0,0}
		self.sword.animation:nextFrame(dt)
	else
		self.sword.x, self.sword.y = 1000, 1000
		self.sword = nil
		self:setAction('walk')
	end
	--]]
end


function Player:walk(dt)

	if self.time == 0 then
		self.animation = Animation:new('link.png', 0.125)
	end

	self.time = self.time + dt

	local dx, dy = 0, 0

	if love.keyboard.isDown('k') then
		self:setAction('swing')
	end
	if love.keyboard.isDown('down','d') and not love.keyboard.isDown('up','e') then
		dy = self.speed * dt
		self.dir = 'down'
	end
	if love.keyboard.isDown('up','e') and not love.keyboard.isDown('down','d') then
		dy = -self.speed * dt
		self.dir = 'up'
	end
	if love.keyboard.isDown('right','f') and not love.keyboard.isDown('left','s') then
		dx = self.speed * dt
		self.dir = 'right'
	end
	if love.keyboard.isDown('left','s') and not love.keyboard.isDown('right','f') then
		dx = -self.speed * dt
		self.dir = 'left'
	end

	if dx ~= 0 and dy ~= 0 then
		dx = dx / math.sqrt(2)
		dy = dy / math.sqrt(2)
	end

	self.x = self.x + dx
	if not player:inBounds() then
		self.x = self.x - dx
	end

	self.y = self.y + dy
	if not player:inBounds() then
		self.y = self.y - dy
	end
end


return Player
