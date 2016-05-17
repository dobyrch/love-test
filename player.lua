subclass = require 'subclass'
Entity = require 'entity'


local Player = subclass(Entity, {time=0, speed=60, q=7})


function Player:new()
	local instance
	instance = self:super('link.png', 8, 70, 70, 14, 16)
	instance.action = self.walk
	return instance
end


function Player:bump(dt)
	-- TODO: store height and width when quads first created
	-- TODO: give every entity a center() method
	local cx, cy, mcx, mcy, mag, xmag, ymag

	cx = self.x + self.width/2
	cy = self.y + self.height/2
	mcx = monster.x + monster.width/2
	mcy = monster.y + monster.height/2

	mag = math.sqrt((cx - mcx)^2 + (cy - mcy)^2)
	xmag = (1 / mag)*(cx - mcx)
	ymag = (1 / mag)*(cy - mcy)

	self.x = self.x + dt*xmag*self.speed*4/3
	self.y = self.y + dt*ymag*self.speed*4/3

	self.time = self.time + dt
	if self.time > 0.2 then
		self:setAction('walk')
	end
end


function Player:walk(dt)
	self.time = self.time + dt
	self.time = self.time % 0.25

	dx, dy = 0, 0
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
	love.graphics.draw(self.image, self.quads[self.q], self.x, self.y)

end


return Player
