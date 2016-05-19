subclass = require 'subclass'
Entity = require 'entity'
Sword = require 'sword'


local Player = subclass(Entity, {alignment='good'})


function Player:new()
	local instance
	instance = self:super()
	instance.x = 80
	instance.y = 80
	instance.speed = 60
	instance.health = 10
	instance.harmable = true
	instance:setAction('walk')
	return instance
end


function Player:swing(dt)
	local sword = self.tmp.sword
	if not sword then
		sword = Sword:new()
		sword.x = self.x
		sword.y = self.y
		sword.dir = self.dir
		self.tmp.sword = sword
	end

	if self.time == 0 then
		self.animation = Animation:new('swing.png', math.huge)
	end

	if self.time >= self.tmp.sword.animation:getLength() then
		self:setAction('walk')
	end

	local xtab, ytab
	if sword.animation.frame == 1 and not sword.tmp.did1 then
		xtab = {down = -1, up = 1, right = 0, left = 0}
		ytab = {down = 0, up = 0, right = -1, left = -1}
		sword.x = sword.x + xtab[sword.dir]*self.width
		sword.y = sword.y + ytab[sword.dir]*self.width
		sword.tmp.did1 = true

	elseif sword.animation.frame == 2 and not sword.tmp.did2 then
		xtab = {down = 0, up = 0, right = 1, left = -1}
		ytab = {down = 1, up = -1, right = 0, left = 0}
		sword.x = sword.x + xtab[sword.dir]*self.width
		sword.y = sword.y + ytab[sword.dir]*self.width
		sword.tmp.did2 = true

	elseif sword.animation.frame == 3 and not sword.tmp.did3 then
		xtab = {down = 1, up = -1, right = 0, left = 0}
		ytab = {down = 0, up = 0, right = 1, left = 1}
		sword.x = sword.x + xtab[sword.dir]*self.width
		sword.y = sword.y + ytab[sword.dir]*self.width
		sword.tmp.did3 = true
	end
end


function Player:walk(dt)
	local dx, dy = 0, 0
	local up =  love.keyboard.isDown('up','e')
	local down = love.keyboard.isDown('down', 'd')
	local right = love.keyboard.isDown('right','f')
	local left = love.keyboard.isDown('left','s')

	if up and not down then
		dy = -self.speed
		self.dir = 'up'
	elseif down and not up then
		dy = self.speed
		self.dir = 'down'
	end

	if right and not left then
		dx = self.speed
		self.dir = 'right'
	elseif left and not right then
		dx = -self.speed
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

	dx, dy = dt*dx, dt*dy

	if dx ~= 0 and dy ~= 0 then
		dx = dx / math.sqrt(2)
		dy = dy / math.sqrt(2)
	end

	self.x = self.x + dx
	if not self:inBounds() then
		self.x = self.x - dx
	end

	self.y = self.y + dy
	if not self:inBounds() then
		self.y = self.y - dy
	end
end


return Player
