local M = {}

--- Reconfigure volume.
-- @name reconfigVolume
-- @param volume number
-- @return null
function M.reconfigVolume(volume)
  hs.audiodevice.defaultOutputDevice():setVolume(volume)
end

return M
