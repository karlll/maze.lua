local m = require("maze")
local width = 100
local height = 20
local mz = m.generate(width, height)

for i = 1, width * height do
	local cell = mz[i]
	local cellChar = "X"
	if cell == 5 then
		cellChar = "║"
	end
	if cell == 10 then
		cellChar = "═"
	end
	if cell == 6 then
		cellChar = "╔"
	end
	if cell == 12 then
		cellChar = "╗"
	end
	if cell == 9 then
		cellChar = "╝"
	end
	if cell == 3 then
		cellChar = "╚"
	end
	if cell == 15 then
		cellChar = "╬"
	end -- 0b1111
	if cell == 7 then
		cellChar = "╠"
	end -- 0b0111
	if cell == 11 then
		cellChar = "╩"
	end -- 0b1011
	if cell == 14 then
		cellChar = "╦"
	end -- 0b1110
	if cell == 13 then
		cellChar = "╣"
	end -- 0b1101
	if cell == 0 then
		cellChar = "▓"
	end -- 0b0000
	if cell == 1 then
		cellChar = "╨"
	end -- 0b0001
	if cell == 2 then
		cellChar = "╞"
	end -- 0b0010
	if cell == 4 then
		cellChar = "╥"
	end -- 0b0100
	if cell == 8 then
		cellChar = "╡"
	end -- 0b1000
	if i % width == 0 then
		io.write("\n")
	end
end

