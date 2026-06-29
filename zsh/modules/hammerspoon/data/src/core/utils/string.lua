local M = {}

function M.firstUp(str)
  return (string.lower(str):gsub("^%l", string.upper))
end

return M
