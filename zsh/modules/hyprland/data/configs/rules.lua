--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local tiled_classes = {
  "pavucontrol",
}

local floating_classes = {
  "steam",
  "xdg-desktop-portal",
  "xdg-desktop-portal-gtk",
  "kitty-float",
  "1password",
  "org.quickshell",
}

local function escape_regex(value)
  return value:gsub("([%.%+%*%?%^%$%(%)%[%]%{%}%|\\])", "\\%1")
end

local function class_match(class)
  return ("^(%s)$"):format(escape_regex(class))
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
