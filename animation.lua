Animation = subclass(Object, {images={}})


function Animation:new(filename)
	local instance = self:inherit()
	instance.down = {}
	instance.up = {}
	instance.right = {}
	instance.left = {}
	instance.frame = 1

	if self.images[filename] then
		instance.image = self.images[filename]
	else
		instance.image = love.graphics.newImage('assets/' .. filename)
		instance.image:setFilter('linear', 'nearest')
		self.images[filename] = instance.image
	end

	local dir = {'down', 'up', 'right', 'left'}
	local width, height = instance.image:getDimensions()

	for i = 1, height/TS do
		for j = 1, width/TS do
			table.insert(instance[dir[i]],
				love.graphics.newQuad(
					(j - 1)*TS, (i - 1)*TS,
					TS, TS,
					width, height
				)
			)
		end
	end

	return instance
end


function Animation:nextFrame()
	self.frame = self.frame % #self.down + 1
end


function Animation:getFrame(dir)
	return self.image, self[dir or 'down'][self.frame]
end
