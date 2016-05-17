subclass = require 'subclass'
Entity = require 'entity'


local Player = subclass(Entity, {time=0})

local up_step1
local up_step2
local right_stand
local right_step
local left_step
local left_stand
local down_step1
local down_step2


function Player:new()
	instance = self:super('link.png', 8, 70, 70, 14, 16)
	instance.speed = 60

	up_step1 = instance.quads[1]
	up_step2 = instance.quads[2]
	right_stand = instance.quads[3]
	right_step = instance.quads[4]
	left_step = instance.quads[5]
	left_stand = instance.quads[6]
	down_step1 = instance.quads[7]
	down_step2 = instance.quads[8]
	instance.quad = down_step1

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
		self.time = 0
		self.action = 'walk'
	end
end


function Player:update(dt)
	-- TODO: add table of actions
	-- TODO: refactor update() to call current action
	if self.action == 'bump' then
		self:bump(dt)
		return
	end

	self.time = self.time + dt
	self.time = self.time % 0.25

	dx, dy = 0, 0
	oldquad = self.quad
	if love.keyboard.isDown('down','d') and not love.keyboard.isDown('up','e') then
		dy = self.speed * dt
		if self.time < 0.125 then
			self.quad = down_step1
		else
			self.quad = down_step2
		end
	end
	if love.keyboard.isDown('up','e') and not love.keyboard.isDown('down','d') then
		dy = -self.speed * dt
		if self.time < 0.125 then
			self.quad = up_step1
		else
			self.quad = up_step2
		end
	end
	if love.keyboard.isDown('left','s') and not love.keyboard.isDown('right','f') then
		dx = -self.speed * dt
		if self.time < 0.125 then
			self.quad = left_stand
		else
			self.quad = left_step
		end
	end
	if love.keyboard.isDown('right','f') and not love.keyboard.isDown('left','s') then
		dx = self.speed * dt
		if self.time < 0.125 then
			self.quad = right_stand
		else
			self.quad = right_step
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
	love.graphics.draw(self.image, self.quad, self.x, self.y)

end


return Player
