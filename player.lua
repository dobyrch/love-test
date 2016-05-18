subclass = require 'subclass'
Entity = require 'entity'
shader = require 'shader'


local Player = subclass(Entity, {speed=60, q=7})


function Player:new()
	local instance
	instance = self:super('link.png', 8, 70, 70, 14, 16)
	instance:setAction('walk')
	return instance
end


function Player:recoil(dt, other)
	self.shader = shader.damaged
	self.shader:send('time', self.time)

	if self.time < 0.300 then
		self:callAction('bump', dt, other)
	elseif self.time < 0.800 then
		self:callAction('walk', dt)
	else
		self.time = 0
		self.shader = nil
		self:setAction('walk')
	end
end


function Player:walk(dt)
	self.time = self.time % 0.25

	local dx, dy = 0, 0
	oldquad = self.quad
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


function Player:draw()
	love.graphics.setShader(self.shader)
	love.graphics.draw(self.image, self.quads[self.q], self.x, self.y)
	love.graphics.setShader(nil)

end


return Player
