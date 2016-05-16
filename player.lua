require 'entity'

Player = {time=0, quads={}}
setmetatable(Player, {__index=Entity})

local up_step1
local up_step2
local right_stand
local right_step
local left_step
local left_stand
local down_step1
local down_step2


function Player:new()
	instance = {}
	setmetatable(instance, self)
	self.__index = self

	self.x = 70
	self.y = 70
	self.speed = 60
	self.width = 14
	self.height = 16

	self.img = love.graphics.newImage('assets/link.png')
	self.img:setFilter('linear', 'nearest')

	for i = 1,8 do
		self.quads[i] = love.graphics.newQuad(
			i + (i - 1)*self.width,
			0,
			self.width,
			self.height,
			self.img:getDimensions()
		)
	end

	up_step1 = self.quads[1]
	up_step2 = self.quads[2]
	right_stand = self.quads[3]
	right_step = self.quads[4]
	left_step = self.quads[5]
	left_stand = self.quads[6]
	down_step1 = self.quads[7]
	down_step2 = self.quads[8]
	self.quad = down_step1

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

	_, _, width, height = self.quad:getViewport()
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
	love.graphics.draw(self.img, self.quad, self.x, self.y)

end
