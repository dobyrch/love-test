Animation = subclass(Object, {images={}})


function Animation:init(filename)
	self:inherit()
	self.down = {}
	self.up = {}
	self.right = {}
	self.left = {}
	self.frame = 1

	if self.images[filename] then
		self.image = self.images[filename]
	else
		self.image = love.graphics.newImage('assets/' .. filename)
		self.image:setFilter('linear', 'nearest')
		self.images[filename] = self.image
	end

	local dir = {'down', 'up', 'right', 'left'}
	local width, height = self.image:getDimensions()

	for i = 1, height/TS do
		for j = 1, width/TS do
			table.insert(self[dir[i]],
				love.graphics.newQuad(
					(j - 1)*TS, (i - 1)*TS,
					TS, TS,
					width, height
				)
			)
		end
	end
end


function Animation:nextFrame()
	self.frame = self.frame % #self.down + 1
end


function Animation:getFrame(dir)
	return self.image, self[dir or 'down'][self.frame]
end
