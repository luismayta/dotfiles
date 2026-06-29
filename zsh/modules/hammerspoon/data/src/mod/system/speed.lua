-- luacheck: globals hs spoon
-- @see https://github.com/ashfinal/awesome-hammerspoon/blob/master/Spoons/SpeedMenu.spoon/init.lua
local speedBar = hs.menubar.new()
speedBar:setTitle('0.00 KB/s')
speedBar:setIcon(hs.image.imageFromPath('assets/speed/down.ico'):setSize({ w = 20, h = 20 }))

local function trim (s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function format_show(diff)
   if diff/1024 > 1024 then
      return trim(string.format("%6.2f MB/s", diff/1024/1024))
   end
   return trim(string.format("%6.2f KB/s", diff/1024))
end

local interface = hs.network.primaryInterfaces();
if interface then
  local netstat_down = 'netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $7}\''
  local netstat_up = 'netstat -ibn | grep -e ' .. interface .. ' -m 1 | awk \'{print $10}\''
  local prev_speed_down = hs.execute(netstat_down)
  local prev_speed_up = hs.execute(netstat_up)

  hs.timer.doEvery(
      10, function()
            local speed_down = hs.execute(netstat_down)
            local speed_up = hs.execute(netstat_up)
            local speed_down_show = format_show(speed_down - prev_speed_down)
            local speed_up_show = format_show(speed_up - prev_speed_up)
            prev_speed_down = speed_down
            prev_speed_up = speed_up
            speedBar:setTitle(speed_down_show)
            speedBar:setTooltip('UP:'..speed_up_show..', DOWN:'..speed_down_show)
        end
  )
end