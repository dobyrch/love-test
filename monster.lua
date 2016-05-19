subclass = require 'subclass'
Entity = require 'entity'


local Monster = subclass(Entity, {alignment='bad'})


function Monster:new()
	local instance
	instance = self:super()
	instance.animation = Animation:new('octorok.png', 0.125)
	instance.x = 70
	instance.y = 70
	instance.speed = 30
	instance.steps = 0
	instance.damage = 1
	instance.buffer = 5
	instance.harmable = true
	instance.health = 3
	instance:setAction('walk')
	return instance
end


function Monster:harm(dt, other)
	if other.action ~= 'recoil' then
		other:setAction('recoil', self)
		other.health = other.health - self.damage
	end
end


function Monster:walk(dt)
	while self.time > 0.125 do
		self.steps = self.steps + 1
		self.time = self.time - 0.125

		if self.steps < 0 then
			break
		end

		if self.steps > 6 or self.steps > 1 and love.math.random() < 0.15 then
			self.steps = -3
			self:setDir()
		end
	end

	local xdir, ydir = self:dirVector()

	if self:inBounds() and self.steps >= 0 then
		self.x = self.x + self.speed*dt*xdir
		self.y = self.y + self.speed*dt*ydir

	end

	if not self:inBounds() then
		self.x = self.x - self.speed*dt*xdir
		self.y = self.y - self.speed*dt*ydir
		self.steps = 0
		self:setDir()
	end
end


return Monster
