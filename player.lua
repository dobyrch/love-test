subclass = require 'subclass'
Entity = require 'entity'
Sword = require 'sword'


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
	return instance
end


function Player:swing(dt)
	if not self.tmp.sword then
		self.tmp.sword = Sword:new()
		self.tmp.sword.x = self.x
		self.tmp.sword.y = self.y
		self.tmp.sword.dir = self.dir
	end

	if self.time >= self.tmp.sword.animation:getLength() then
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
	local dx, dy = 0, 0
	local up =  love.keyboard.isDown('up','e')
	local down = love.keyboard.isDown('down', 'd')
	local right = love.keyboard.isDown('right','f')
	local left = love.keyboard.isDown('left','s')

	if up and not down then
		dy = -self.speed * dt
		self.dir = 'up'
	elseif down and not up then
		dy = self.speed * dt
		self.dir = 'down'
	end

	if right and not left then
		dx = self.speed * dt
		self.dir = 'right'
	elseif left and not right then
		dx = -self.speed * dt
		self.dir = 'left'
	end

	if self.time == 0 then
		if dx == 0 and dy == 0 then
			self.animation = Animation:new('link.png', math.huge)
		else
			self.animation = Animation:new('link.png', 0.133)
			self.animation.frame = 2
		end

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
