Scheduler = subclass(Object)


-- TODO: Accept (num, func, bool) in addtion to (table, table, bool)
function Scheduler:init(timings, events, loop)
	self:inherit()
	
	if #timings ~= #events then
		error('Length of arguments do not match', 2)
	end

	self.timings = timings
	self.events = events
	self.loop = loop
	self.time = 0
	self.i = 1
end


function Scheduler:update(dt)
	self.time = self.time + dt

	while self.i <= #self.timings and self.time > self.timings[self.i] do
		self.events[self.i]()
		self.time = self.time - self.timings[self.i]

		if self.loop then
			self.i = self.i % #self.timings + 1
		else
			self.i = self.i + 1
		end
	end
end
