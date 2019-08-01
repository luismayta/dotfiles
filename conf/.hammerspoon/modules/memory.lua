local memoryIcon = {
    icon = hs.image.imageFromPath('assets/memory/icon.png'):setSize({ w = 20, h = 20 }),
    clean = hs.image.imageFromPath('assets/memory/clean.png'):setSize({ w = 20, h = 20 }),
}
local fetchTimer = nil
local isCleaning = false
local memoryBar = hs.menubar.new()

memoryBar:setTitle('0.00%') --used_rate
memoryBar:setIcon(memoryIcon['icon'])
memoryBar:setTooltip('0M used (0M wired), 0M unused')
memoryBar:setClickCallback(
   function()
      isCleaning = true
      if (fetchTimer ~= nil) then
         fetchTimer:stop()
      end

      memoryBar:setTitle('Cleaning...')
      memoryBar:setIcon(memoryIcon['clean'])
      hs.execute('sudo purge')
      if (fetchTimer ~= nil) then
         fetchTimer:start()
      end
   end
)

local function fetchPhysMem()
	if (isCleaning) then
		memoryBar:setIcon(memoryIcon['icon'])
		isCleaning = false
	end
	
	-- PhysMem: 9032M used (2148M wired), 7351M unused.
	physMem = hs.execute('top -l 1 | head -n 10 | grep PhysMem')
	
	-- 9032M used
	used_text = string.match(physMem, '[%d]+%a used')
	wired_text = string.match(physMem, '[%d]+%a wired')
	unused_text = string.match(physMem, '[%d]+%a unused')
	
	-- M or G
	used_unit = string.match(used_text, '%u')
	wired_unit = string.match(wired_text, '%u')
	unused_unit = string.match(unused_text, '%u')
	
	-- 9032
	used = string.match(used_text, '[%d]+')
	if (used_unit == 'G') then
		used = used * 1024
	end
	wired = string.match(wired_text, '[%d]+')
	if (wired_unit == 'G') then
		wired = wired * 1024
	end
	unused = string.match(unused_text, '[%d]+')
	if (unused_unit == 'G') then
		unused = unused * 1024
	end
	
	-- used_rate = (used - wired) / (used + unused) ?
	used_rate =  used / (used + unused)
	memoryBar:setTitle((string.gsub(string.format("%6.0f", used_rate * 100), "^%s*(.-)%s*$", "%1"))..'%')
	memoryBar:setTooltip(string.format('%dM used (%dM wired), %dM unused',used, wired, unused))
end
fetchTimer = hs.timer.doEvery(30, fetchPhysMem)
fetchPhysMem()
