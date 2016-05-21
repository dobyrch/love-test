local subclass = require 'subclass'
local Animation = require 'animation'
local Kinetic = require 'kinetic'
local Sword = require 'sword'
local Scheduler = require 'scheduler'

local Player = subclass(Kinetic)


function Player:new()
	local instance
	instance = self:inherit()
	instance.x = 80
	instance.y = 80
	instance.speed = 60
	instance:setAction('walk')
	instance.xbuf = 3
	return instance
end


function Player:swing(dt)
	if not dt then
		local sword, one, two, three
		self.tmp.sword = Sword:new()
		sword = self.tmp.sword
		sword.x = self.x
		sword.y = self.y
		sword:setDir(self.dir)

		self.animation = Animation:new('swing.png')

		local xtab, ytab
		xtab = {down = -1, up = 1, right = 0, left = 0}
		ytab = {down = 0, up = 0, right = -1, left = -1}
		sword.x = sword.x + xtab[sword.dir]*self.width
		sword.y = sword.y + ytab[sword.dir]*self.width

		function one()
			xtab = {down = 0, up = 0, right = 1, left = -1}
			ytab = {down = 1, up = -1, right = 0, left = 0}
			sword.x = sword.x + xtab[sword.dir]*self.width
			sword.y = sword.y + ytab[sword.dir]*self.width
			sword.animation:nextFrame()
		end

		function two()
			xtab = {down = 1, up = -1, right = 0, left = 0}
			ytab = {down = 0, up = 0, right = 1, left = 1}
			sword.x = sword.x + xtab[sword.dir]*self.width
			sword.y = sword.y + ytab[sword.dir]*self.width
			sword.animation:nextFrame()
		end
		function three()
			self:setAction('walk')
		end

		self.scheduler = Scheduler:new(
			{0.033, 0.050, 0.134},
			{one, two, three}
		)
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
		local timing
		self.animation = Animation:new('link.png')

		if dx == 0 and dy == 0 then
			timing = math.huge
		else
			timing = 0.133
			self.animation.frame = 2
		end

		self.scheduler = Scheduler:new(
			{timing},
			{function()
				self.animation:nextFrame()
				self.scheduler.i = 1
			end},
			true
		)

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
Player.stand = Player.walk


return Player
