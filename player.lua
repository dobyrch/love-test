Player = Kinetic:subclass()


function Player:init()
	self:inherit()
	self.x = 80
	self.y = 80
	self.speed = 60
	self:setAction('walk')
	self.xbuf = 3
	self.ybuf = 2
end


function Player:swing(dt)
	if not dt then
		local sword, one, two, three
		self.tmp.sword = Sword:new()
		sword = self.tmp.sword
		sword.x = self.x
		sword.y = self.y
		sword.dir = self.dir

		self.animation = Animation:new('swing.png')

		local dx, dy = player:dirVector()
		local xtab, ytab
		xtab = {down = -1, up = 1, right = 0, left = 0}
		ytab = {down = 0, up = 0, right = -1, left = -1}
		sword.x = sword.x + xtab[sword.dir]*TS
		sword.y = sword.y + ytab[sword.dir]*TS

		function one()
			xtab = {down = 0, up = 0, right = 1, left = -1}
			ytab = {down = 1, up = -1, right = 0, left = 0}
			sword.x = sword.x + xtab[sword.dir]*TS
			sword.y = sword.y + ytab[sword.dir]*TS
			sword.animation:nextFrame()
		end

		function two()
			xtab = {down = 1, up = -1, right = 0, left = 0}
			ytab = {down = 0, up = 0, right = 1, left = 1}
			sword.x = sword.x + xtab[sword.dir]*TS
			sword.y = sword.y + ytab[sword.dir]*TS

			if sword.dir == 'left' or sword.dir == 'right' then
				sword.y = sword.y + 4
			elseif sword.dir == 'up' then
				sword.x = sword.x - 4
			elseif sword.dir == 'down' then
				sword.x = sword.x + 4
			end

			player.x = player.x + dx*4
			player.y = player.y + dy*4

			sword.animation:nextFrame()
		end
		function three()
			player.x = player.x - dx*4
			player.y = player.y - dy*4

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
	local up = love.keyboard.isDown('up','e')
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
	self.y = self.y + dy
end
Player.stand = Player.walk
