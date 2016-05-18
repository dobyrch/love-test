subclass = require 'subclass'
Entity = require 'entity'
Sword = require 'sword'
shader = require 'shader'


local Player = subclass(Entity, {alignment='good'})


function Player:new()
	local instance
	instance = self:super('link.png', 8, 70, 70, 14, 16)
	instance:setAction('walk')
	instance.speed = 60
	instance.q = 7
	instance.health = 10
	instance.harmable = true
	return instance
end


function Player:swing(dt)
	if not self.sword then
		self.sword = Sword:new()
	end

	if self.time < 0.033 then
		self.sword.q = 1
		self.sword.x = self.x
		self.sword.y = self.y - self.height
	elseif self.time < 0.083 then
		self.sword.q = 2
		self.sword.x = self.x + self.width
		self.sword.y = self.y - self.height
	elseif self.time < 0.217 then
		self.sword.q = 3
		self.sword.x = self.x + self.width
		self.sword.y = self.y
	else
		self.time = 0
		self.sword.x, self.sword.y = 1000, 1000
		self.sword = nil
		self:setAction('walk')
	end
end


function Player:walk(dt)
	self.time = self.time % 0.25

	local dx, dy = 0, 0
	oldquad = self.quad
	if love.keyboard.isDown('k') then
		self:setAction('swing')
	end
	if love.keyboard.isDown('down','d') and not love.keyboard.isDown('up','e') then
		dy = self.speed * dt
		if self.time < 0.125 then
			self.q = 7
		else
			self.q = 8
		end
	end
	if love.keyboard.isDown('up','e') and not love.keyboard.isDown('down','d') then
		dy = -self.speed * dt
		if self.time < 0.125 then
			self.q = 1
		else
			self.q = 2
		end
	end
	if love.keyboard.isDown('left','s') and not love.keyboard.isDown('right','f') then
		dx = -self.speed * dt
		if self.time < 0.125 then
			self.q = 6
		else
			self.q = 5
		end
	end
	if love.keyboard.isDown('right','f') and not love.keyboard.isDown('left','s') then
		dx = self.speed * dt
		if self.time < 0.125 then
			self.q = 3
		else
			self.q = 4
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
