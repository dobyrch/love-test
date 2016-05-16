Entity = {}


function Entity:inBounds()
	return self.x > 0 and self.y > 0 and
		self.x < 160 - self.width and
		self.y < 144 - self.height
end


-- TODO: check if both entities are collidable
function Entity:collides(other, buffer)
	buffer = buffer or 0

	return not (
		self.x > other.x + other.width - buffer or
		other.x > self.x + self.width - buffer or
		self.y > other.y + other.height - buffer or
		other.y > self.y + self.height - buffer
	)
end
