-- luacheck: globals hs spoon
--- Pomodoro module

--------------------------------------------------------------------------------
-- Configuration variables
--------------------------------------------------------------------------------
local pomodoor={}

pomodoor.bar = {
  indicator_height = 0.2, -- ratio from the height of the menubar (0..1)
  indicator_alpha  = 0.3,
  indicator_in_all_spaces = true,
  color_time_remaining = hs.drawing.color.green,
  color_time_used      = hs.drawing.color.red,

  c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0)),
  c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
}

pomodoor.config = {
  enable_color_bar = true,
  work_period_sec  = 25 * 60,
  rest_period_sec   = 5 * 60,
}

pomodoor.var = {
  is_active        = false,
  disable_count    = 0,
  work_count       = 0,
  curr_active_type = "work", -- {"work", "rest"}
  time_left        = pomodoor.config.work_period_sec,
  max_time_sec     = pomodoor.config.work_period_sec
}

--------------------------------------------------------------------------------
-- pomodoor function show status
--------------------------------------------------------------------------------
function pomodoor.isEnabled()
  return pomodoor.var.is_active
end

--------------------------------------------------------------------------------
-- Color bar for pomodoor
--------------------------------------------------------------------------------

function pomodoor.del_indicators()
  pomodoor.bar.c_left:delete()
  pomodoor.bar.c_used:delete()
end

function pomodoor.draw_on_menu(target_draw, screen, offset, width, fill_color)
  local screeng                  = screen:fullFrame()
  local screen_frame_height      = screen:frame().y
  local screen_full_frame_height = screeng.y
  local height_delta             = screen_frame_height - screen_full_frame_height
  local height                   = pomodoor.bar.indicator_height * (height_delta)

  target_draw:setSize(hs.geometry.rect(screeng.x + offset, screen_full_frame_height, width, height))
  target_draw:setTopLeft(hs.geometry.point(screeng.x + offset, screen_full_frame_height))
  target_draw:setFillColor(fill_color)
  target_draw:setFill(true)
  target_draw:setAlpha(pomodoor.bar.indicator_alpha)
  target_draw:setLevel(hs.drawing.windowLevels.overlay)
  target_draw:setStroke(false)
  if pomodoor.bar.indicator_in_all_spaces then
    target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
  end
  target_draw:show()
end

function pomodoor.draw_indicator(time_left, max_time)
  local main_screen = hs.screen.mainScreen()
  local screeng     = main_screen:fullFrame()
  local time_ratio  = time_left / max_time
  local width       = math.ceil(screeng.w * time_ratio)
  local left_width  = screeng.w - width

  pomodoor.draw_on_menu(pomodoor.bar.c_left, main_screen, left_width, width, pomodoor.bar.color_time_remaining)
  pomodoor.draw_on_menu(pomodoor.bar.c_used, main_screen, 0, left_width, pomodoor.bar.color_time_used)
  --------------------------------------------------------------------------------
end

-- update display
local function pom_update_display()
  local time_min = math.floor((pomodoor.var.time_left / 60))
  local time_sec = pomodoor.var.time_left - (time_min * 60)
  local str = string.format(
      "[%s|%02d:%02d|#%02d]",
      pomodoor.var.curr_active_type,
      time_min,
      time_sec,
      pomodoor.var.work_count
  )
  pom_menu:setTitle(str)
end

-- stop the clock
-- Stateful:
-- * Disabling once will pause the countdown
-- * Disabling twice will reset the countdown
-- * Disabling trice will shut down and hide the pomodoro timer
function pomodoor.disable()
  local pom_was_active = pomodoor.var.is_active
  pomodoor.var.is_active = false

  if (pomodoor.var.disable_count == 0) then
    if (pom_was_active) then
        pom_timer:stop()
    end

  elseif (pomodoor.var.disable_count == 1) then
    pomodoor.var.time_left         = pomodoor.config.work_period_sec
    pomodoor.var.curr_active_type  = "work"
    pom_update_display()
    elseif (pomodoor.var.disable_count >= 2) then
      if pom_menu == nil then
        pomodoor.var.disable_count = 2
        return
    end

    pom_menu:delete()
    pom_menu = nil
    pom_timer:stop()
    pom_timer = nil
    pomodoor.del_indicators()
  end

  pomodoor.var.disable_count = pomodoor.var.disable_count + 1
end

-- update pomodoro timer
local function pom_update_time()
  if pomodoor.var.is_active == false then
    return
  else
    pomodoor.var.time_left = pomodoor.var.time_left - 1

    if (pomodoor.var.time_left <= 0 ) then
      pomodoor.disable()
      if pomodoor.var.curr_active_type == "work" then
        hs.notify.new({title='Work Complete'}):send()
        pomodoor.var.work_count        =  pomodoor.var.work_count + 1
        pomodoor.var.curr_active_type  = "rest"
        pomodoor.var.time_left         = pomodoor.config.rest_period_sec
        pomodoor.var.max_time_sec      = pomodoor.config.rest_period_sec
      else
        hs.notify.new({title='Done resting'}):send()
        pomodoor.var.curr_active_type  = "work"
        pomodoor.var.time_left         = pomodoor.config.work_period_sec
        pomodoor.var.max_time_sec      = pomodoor.config.work_period_sec
      end
    end

    -- draw color bar indicator, if enabled.
    if (pomodoor.config.enable_color_bar == true) then
      pomodoor.draw_indicator(pomodoor.var.time_left, pomodoor.var.max_time_sec)
    end

  end
end

-- update menu display
local function pom_update_menu()
  pom_update_time()
  pom_update_display()
end

local function pom_create_menu(pom_origin)
  if pom_menu == nil then
    pom_menu = hs.menubar.new()
    pomodoor.bar.c_left = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
    pomodoor.bar.c_used = hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
  end
end

-- start the pomodoro timer
function pomodoor.enable()
  pomodoor.var.disable_count = 0;
  if (pomodoor.var.is_active) then
    return
  end

  pom_create_menu()
  pom_timer = hs.timer.new(1, pom_update_menu)

  pomodoor.var.is_active = true
  pom_timer:start()
end

-- reset work count
-- TODO - reset automatically every day
function pomodoor.reset_work()
  pomodoor.var.work_count = 0;
end
-- Use examples:

-- init pomodoro -- show menu immediately
-- pom_create_menu()
-- pom_update_menu()

-- show menu only on first enable
--hs.hotkey.bind(mash, '9', function() pomodoor.enable() end)
--hs.hotkey.bind(mash, '0', function() pomodoor.disable() end)

return pomodoor
