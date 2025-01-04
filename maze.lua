local Set = {}
Set.__index = Set

function Set.new()
	return setmetatable({ data = {}, elements = {} }, Set)
end

function Set:insert(value)
	if not self.data[value] then
		self.data[value] = #self.elements + 1
		table.insert(self.elements, value)
	end
end

function Set:remove(value)
	local index = self.data[value]
	if index then
		local lastValue = self.elements[#self.elements]
		self.elements[index] = lastValue
		self.data[lastValue] = index
		self.data[value] = nil
		table.remove(self.elements)
	end
end

function Set:get_random()
	local randomIndex = math.random(#self.elements)
	return self.elements[randomIndex]
end

local maze = {}

--[[

Maze generation algorithm, described by Jamis Buck:

1. Start with a rectangular grid, x units wide and y units tall. Mark each cell in
the grid unvisited.
2. Pick a random cell in the grid and mark it visited. This is the current cell.
3. From the current cell, pick a random direction (north, south, east, or west).
If (1) there is no cell adjacent to the current cell in that direction, or (2) if
the adjacent cell in that direction has been visited, then that direction
is invalid, and you must pick a different random direction. If all directions
are invalid, pick a different random visited cell in the grid and start this step
over again.
4. Let's call the cell in the chosen direction C. Create a corridor between the
current cell and C, and then make C the current cell. Mark C visited.
5. Repeat steps 3 and 4 until all cells in the grid have been visited.

]]
--

function maze.generate(width, height)
	local m = {}
	local unvisited = {}
	local unvisitedCount = width * height
	local visited = Set.new()

	for i = 1, width * height do
		m[i] = 0 -- No connections
		unvisited[i] = i
	end

	local visit = function(cell)
		unvisited[cell] = nil
		unvisitedCount = unvisitedCount - 1
		visited:insert(cell)
	end

	-- return a random adjacent unvisited cell and the direction to it, or nil if no such cell exists
	local pickAdjacentUnvisited = function(current)
		local directions = { 1, 2, 3, 4 } -- 1 = north, 2 = east, 3 = south, 4 = west
		while #directions > 0 do
			local direction = table.remove(directions, math.random(1, #directions))
			if direction == 1 then
				if current - width > 0 and unvisited[current - width] then
					return current - width, direction
				end
			elseif direction == 2 then
				if current % width ~= 0 and unvisited[current + 1] then
					return current + 1, direction
				end
			elseif direction == 3 then
				if current + width <= width * height and unvisited[current + width] then
					return current + width, direction
				end
			elseif direction == 4 then
				if current % width ~= 1 and unvisited[current - 1] then
					return current - 1, direction
				end
			end
		end
		return nil
	end

	-- (LSB order) bit 0: north, bit 1: east, bit 2: south, bit 3: west (1 = corridor, 0 = wall)
	local connectCells = function(current, adjacent, direction)
		-- direction: 1 = north, 2 = east, 3 = south, 4 = west
		if direction == 1 then
			m[current] = m[current] | 1 -- set bit 0 (north)
			m[adjacent] = m[adjacent] | 4 -- set bit 2 (south)
		elseif direction == 2 then
			m[current] = m[current] | 2 -- set bit 1 (east)
			m[adjacent] = m[adjacent] | 8 -- set bit 3 (west)
		elseif direction == 3 then
			m[current] = m[current] | 4 -- set bit 2 (south)
			m[adjacent] = m[adjacent] | 1 -- set bit 0 (north)
		elseif direction == 4 then
			m[current] = m[current] | 8 -- set bit 3 (west)
			m[adjacent] = m[adjacent] | 2 -- set bit 1 (east)
		end
	end

	local current = math.random(1, width * height)
	visit(current)
	local adjacent, direction = pickAdjacentUnvisited(current)
	while unvisitedCount > 0 do
		if adjacent then
			connectCells(current, adjacent, direction)
			current = adjacent
			visit(current)
			adjacent, direction = pickAdjacentUnvisited(current)
		else
			-- pick a different random visited cell
			current = visited:get_random()
			adjacent, direction = pickAdjacentUnvisited(current)
		end
	end
	return m
end

return maze
