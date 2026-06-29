-- luacheck: globals hs spoon
package.path = hs.configdir .. "/src/?.lua;" .. hs.configdir .. "/src/?/init.lua;" .. package.path

--------------------------------------------------
-- Logger
--------------------------------------------------

local logger = require("hs.logger")
local log = logger.new("Bootstrap")
log.df("Starting Hammerspoon")

--------------------------------------------------
-- SpoonInstall (infra bootstrap)
--------------------------------------------------

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.doiken = {
  url = "https://github.com/doiken/Spoons",
  desc = "Spoons",
}

spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:updateAllRepos()

--------------------------------------------------
-- Load Global Config
--------------------------------------------------

local config = require("config")

--------------------------------------------------
-- Infrastructure
--------------------------------------------------
local SpoonManager = require("core.spoon_manager")

local Hotkey = require("core.hotkey")

local application = require("core.hs.application")
local screen = require("core.hs.screen")

--------------------------------------------------
-- Build Context
--------------------------------------------------

local context = {
  config = config,
  log = log,

  -- engines
  hotkey = Hotkey.new({
    functions = application,
  }),

  -- infrastructure adapters
  application = application,
  screen = screen,

  -- spoon spoon_manager
  spoon_manager = SpoonManager.new(spoon.SpoonInstall),
}

--------------------------------------------------
-- Register Features
--------------------------------------------------

local features = {
  require("features.workspace"),
  require("features.window"),
}

for _, feature in ipairs(features) do
  if feature.setup then
    log.df("Loading feature: %s", tostring(feature))
    feature.setup(context)
  end
end

log.df("All features loaded")

--------------------------------------------------
-- Optional Speech
--------------------------------------------------

local success, speech = pcall(require, "hs.speech")
if success then
  local speaker = speech.new()
  speaker:speak(os.getenv("USER") .. ", system ready.")
end
