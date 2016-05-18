subclass = require 'subclass'
Entity = require 'entity'


local Monster = subclass(Entity, {alignment='bad'})


function Monster:new()
	local instance
	instance = self:super('octorok.png', 8, 40, 40, 16, 16)
	instance:setAction('walk')
	instance.speed = 30
	instance.steps = 0
	instance.damage = 1
	instance.buffer = 5
	instance.harmable = true
	instance.health = 3
	return instance
end


function Monster:harm(dt, other)
	if other.action ~= 'recoil' then
		other:setAction('recoil', self)
		other.health = other.health - self.damage
		print(other.health)
	end
end


function Monster:walk(dt)
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


return Monster
