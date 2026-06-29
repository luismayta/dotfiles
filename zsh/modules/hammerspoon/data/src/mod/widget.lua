-- luacheck: globals hs spoon
local logger = require("hs.logger")

local function init(_)
    local log = logger.new("Apps")
    -- Load SpoonInstall
    local success, spoonInstall = pcall(require, "SpoonInstall")
    if not success then
        log.ef("Error: in load SpoonInstall")
        return
    end

    local Install = spoonInstall

    Install:andUse("ModalMgr", {
        loglevel = 'debug',
    })

    log.df("SpoonInstall Load Success")
end

return init