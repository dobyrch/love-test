Monster = subclass(Kinetic)


function Monster:new()
	local instance
	instance = self:inherit()
	instance.animation = Animation:new('octorok.png')
	instance.x = 112
	instance.y = 112
	instance.speed = 30
	instance:setAction('walk')
	return instance
end


function Monster:walk(dt)
	if not dt then
		self.animation.frame = 2

		self.scheduler = Scheduler:new(
			{0.125},
			{function() self.animation:nextFrame() end},
			true
		)

		return
	end

	if self.time > 0.25 * math.random(2, 6) then
		self:setAction('stand')
	end

	local xdir, ydir = self:dirVector()

	if not self:outOfBounds() then
		self.x = self.x + self.speed*dt*xdir
		self.y = self.y + self.speed*dt*ydir

	end

	if self:outOfBounds() then
		self.x = self.x - self.speed*dt*xdir
		self.y = self.y - self.speed*dt*ydir
	end
end


function Monster:stand(dt)
	if not dt then
		self.scheduler = nil
		self.animation.frame = 1
	end

	if self.time > 0.5 then
		self:changeDir()
		self:setAction('walk')
	end
end
