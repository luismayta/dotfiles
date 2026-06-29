local M = {}

function M.toggleFullscreen(context)
  context.screen.toggleFullscreen()
end

function M.moveToNextScreen(context)
  context.screen.moveToNextScreen()
end

return M
