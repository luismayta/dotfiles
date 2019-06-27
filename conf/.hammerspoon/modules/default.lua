-- disable animations
hs.window.animationDuration = 0

-- hide window shadows
hs.window.setShadows(false)

-- alert default
hs.alert.defaultStyle.radius = 3
hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }

-- switcher default
hs.window.switcher.ui.textColor = {0.9,0.9,0.9}
hs.window.switcher.ui.fontName = 'Lucida Grande'
hs.window.switcher.ui.textSize = 15
hs.window.switcher.ui.highlightColor = {0.8,0.5,0,0.6} -- 突出显示所选窗口的颜色
hs.window.switcher.ui.backgroundColor = {0.3,0.3,0.3,0.6}
hs.window.switcher.ui.onlyActiveApplication = true -- 仅显示活动应用程序的窗口
hs.window.switcher.ui.showTitles = true -- 显示窗口标题
hs.window.switcher.ui.titleBackgroundColor = {0,0,0}
hs.window.switcher.ui.showThumbnails = true -- 显示窗口缩略图
hs.window.switcher.ui.thumbnailSize = 120 -- 屏幕点中窗口缩略图的大小
hs.window.switcher.ui.showSelectedThumbnail = false -- 为当前选定的窗口显示更大的缩略图
hs.window.switcher.ui.selectedThumbnailSize = 150
hs.window.switcher.ui.showSelectedTitle = true -- 显示当前所选窗口的较大标题
