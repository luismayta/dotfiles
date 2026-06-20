--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local tiled_classes = {
}

local floating_classes = {
  "steam",
  "kitty-float",
  "1password",
}

local function escape_regex(value)
  return value:gsub("([%.%+%*%?%^%$%(%)%[%]%{%}%|\\])", "\\%1")
end

local function class_match(class)
  return ("^(%s)$"):format(escape_regex(class))
end

-- Tag-based window rule registration helper.
-- Registers a window_rule for each class in the classes table.
-- @param tag_name  string  display name (e.g. "+terminal")
-- @param classes   table   list of window classes
-- @param props     table   window rule properties (opacity, float, tile, etc.)
local function tag_window(tag_name, classes, props)
  for _, class in ipairs(classes) do
    local rule = { match = { class = class_match(class) } }
    for k, v in pairs(props) do
      rule[k] = v
    end
    hl.window_rule(rule)
  end
end

for _, class in ipairs(tiled_classes) do
  hl.window_rule({
    match = {
      class = class_match(class),
    },

    tile = true,
  })
end

for _, class in ipairs(floating_classes) do
  hl.window_rule({
    match = {
      class = class_match(class),
    },

    float = true,
  })
end

hl.window_rule({
  match = {
    class = class_match("firefox"),
    title = "^(Picture-in-Picture)$",
  },

  float = true,
})

hl.layer_rule({
  match = { namespace = "^(quickshell)$" },
  no_anim = true,
})

hl.workspace_rule({
  workspace = "special:scratchpad",
  gaps_out = 64,
  layout = "scrolling",
})

-- Tag-based window rules
-- +terminal: subtle opacity for terminal emulators
tag_window("+terminal", {
  "Alacritty", "kitty", "foot", "gnome-terminal",
}, {
  opacity = 0.97,
})

-- +chromium-based-browser: opacity + tiling for Chromium-derived browsers
tag_window("+chromium-based-browser", {
  "chrome", "chromium", "brave", "Brave-browser",
  "Microsoft-edge", "vivaldi", "opera",
}, {
  opacity = 0.97,
})

-- +firefox-browser: opacity + tiling for Firefox
tag_window("+firefox-browser", {
  "firefox", "Firefox", "firefoxdeveloperedition",
  "zen", "Zen",
}, {
  opacity = 0.97,
})

-- +floating-window: centered 60x60 for tool windows, dialogs, launchers
tag_window("+floating-window", {
  "wofi", "rofi", "dmenu",
  "pavucontrol", "blueman-manager",
  "nm-connection-editor",
  "xdg-desktop-portal", "xdg-desktop-portal-gtk",
  "org.quickshell",
}, {
  float = true,
})

-- +jetbrains: disable follow mouse for JetBrains IDEs
tag_window("+jetbrains", {
  "jetbrains-idea", "jetbrains-studio", "jetbrains-datagrip",
}, {
  no_follow_mouse = true,
})

-- +bitwarden: disable screen share capture for Bitwarden
tag_window("+bitwarden", {
  "Bitwarden",
}, {
  no_screen_share = true,
})

-- +media: opacity for media players and streaming apps
tag_window("+media", {
  "vlc", "mpv", "imv",
  "wireshark", "zoom", "discord",
}, {
  opacity = 0.95,
})
