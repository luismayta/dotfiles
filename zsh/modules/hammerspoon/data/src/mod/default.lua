-- luacheck: globals hs spoon

local function init(_)
  -- disable animations
  hs.window.animationDuration = 0.0

  -- alert default
  hs.alert.defaultStyle.radius = 3
  hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
  hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }

  -- switcher default
  hs.window.switcher.ui.textColor = {0.9,0.9,0.9}
  hs.window.switcher.ui.fontName = 'Fira Code'
  hs.window.switcher.ui.textSize = 17
  hs.window.switcher.ui.highlightColor = {0.8,0.5,0,0.6}
  hs.window.switcher.ui.backgroundColor = {0.3,0.3,0.3,0.6}
  hs.window.switcher.ui.onlyActiveApplication = true
  hs.window.switcher.ui.showTitles = true
  hs.window.switcher.ui.titleBackgroundColor = {0,0,0}
  hs.window.switcher.ui.showThumbnails = true
  hs.window.switcher.ui.thumbnailSize = 120
  hs.window.switcher.ui.showSelectedThumbnail = false
  hs.window.switcher.ui.selectedThumbnailSize = 150
  hs.window.switcher.ui.showSelectedTitle = true

  -- hide window shadows
  hs.window.setShadows(false)
end

return init