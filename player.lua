local subclass = require 'subclass'
local Animation = require 'animation'
local Entity = require 'entity'
local Sword = require 'sword'
local Synchronizer = require 'synchronizer'


local Player = subclass(Entity, {alignment='good'})


function Player:new()
	local instance
	instance = self:super()
	instance.x = 30
	instance.y = 30
	instance.speed = 60
	instance.health = 10
	instance.harmable = true
	instance:setAction('walk')
	return instance
end


function Player:swing(dt)
	local one, two, three
	local sword = self.tmp.sword

	if not dt then
		self.animation = Animation:new('swing.png', math.huge)


		local xtab, ytab
		function one()
			xtab = {down = -1, up = 1, right = 0, left = 0}
			ytab = {down = 0, up = 0, right = -1, left = -1}
			sword.x = sword.x + xtab[sword.dir]*self.width
			sword.y = sword.y + ytab[sword.dir]*self.width
		end

		function two()
			xtab = {down = 0, up = 0, right = 1, left = -1}
			ytab = {down = 1, up = -1, right = 0, left = 0}
			sword.x = sword.x + xtab[sword.dir]*self.width
			sword.y = sword.y + ytab[sword.dir]*self.width
		end

		function three()
			xtab = {down = 1, up = -1, right = 0, left = 0}
			ytab = {down = 0, up = 0, right = 1, left = 1}
			sword.x = sword.x + xtab[sword.dir]*self.width
			sword.y = sword.y + ytab[sword.dir]*self.width
		end
	end

	if not sword then
		sword = Sword:new()
		sword.x = self.x
		sword.y = self.y
		sword:setDir(self.dir)
		self.tmp.sword = sword

		self.tmp.sync = Synchronizer:new(sword.animation, one, two, three)
	end

	if self.time >= self.tmp.sword.animation:getLength() then
		self:setAction('walk')
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
		self:setDir('up')
	elseif down and not up then
		dy = self.speed
		self:setDir('down')
	end

	if right and not left then
		dx = self.speed
		self:setDir('right')
	elseif left and not right then
		dx = -self.speed
		self:setDir('left')
	end

	if not dt then
		if dx == 0 and dy == 0 then
			self.animation = Animation:new('link.png', math.huge)
		else
			self.animation = Animation:new('link.png', 0.133)
			self.animation.frame = 2
		end

		return
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
