local wezterm = require('wezterm')
local act = wezterm.action

local platform = require('utils.platform')
local backdrops = require('utils.backdrops')

-- ---------------------------------------------------------------------------
-- Keys
-- ---------------------------------------------------------------------------

local key = {
   TAB = 'Tab',
   ENTER = 'Enter',
   SPACE = 'Space',
   ESC = 'Escape',
   BACKSPACE = 'Backspace',
}

-- ---------------------------------------------------------------------------
-- Modifiers
-- ---------------------------------------------------------------------------

local mod = {
   CTRL = 'CTRL',
   SHIFT = 'SHIFT',
   ALT = 'ALT',
   SUPER = 'SUPER',
   LEADER = 'LEADER',

   CTRL_SHIFT = 'CTRL|SHIFT',
   CTRL_ALT = 'CTRL|ALT',
   SUPER_SHIFT = 'SUPER|SHIFT',
}

-- ---------------------------------------------------------------------------
-- Semantic modifiers
-- ---------------------------------------------------------------------------

mod.PRIMARY = platform.is_mac and mod.SUPER or mod.ALT
mod.PRIMARY_REV = platform.is_mac
      and 'SUPER|CTRL'
   or 'ALT|CTRL'

mod.COPY = platform.is_mac and mod.SUPER or mod.CTRL_SHIFT
mod.PASTE = mod.COPY

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function resize_window(delta)
   return wezterm.action_callback(function(window, _)
      local dimensions = window:get_dimensions()

      if dimensions.is_full_screen then
         return
      end

      window:set_inner_size(
         dimensions.pixel_width + delta,
         dimensions.pixel_height + delta
      )
   end)
end

local function send_csi_u(code, modifier)
   return act.SendString(string.format('\x1b[%d;%du', code, modifier))
end

-- ---------------------------------------------------------------------------
-- Keybindings
-- ---------------------------------------------------------------------------

local keys = {
   -- ------------------------------------------------------------------------
   -- Modern keyboard protocol
   -- ------------------------------------------------------------------------

   {
      key = key.TAB,
      mods = mod.CTRL,
      action = send_csi_u(9, 5),
   },

   {
      key = key.TAB,
      mods = mod.CTRL_SHIFT,
      action = send_csi_u(9, 6),
   },

   -- ------------------------------------------------------------------------
   -- Shell multiline input
   -- ------------------------------------------------------------------------

   {
      key = key.ENTER,
      mods = mod.SHIFT,
      action = act.SendString("\x1b[200~\n\x1b[201~"),
   },

   -- ------------------------------------------------------------------------
   -- Misc
   -- ------------------------------------------------------------------------

   { key = 'F1', mods = 'NONE', action = act.ActivateCopyMode },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   {
      key = 'F4',
      mods = 'NONE',
      action = act.ShowLauncherArgs({
         flags = 'FUZZY|TABS',
      }),
   },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({
         flags = 'FUZZY|WORKSPACES',
      }),
   },

   { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },

   -- ------------------------------------------------------------------------
   -- Search / links
   -- ------------------------------------------------------------------------

   {
      key = 'f',
      mods = mod.PRIMARY,
      action = act.Search({
         CaseInSensitiveString = '',
      }),
   },

   {
      key = 'u',
      mods = mod.PRIMARY_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',

         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+',
         },

         action = wezterm.action_callback(function(window, pane)
            local url =
               window:get_selection_text_for_pane(pane)

            wezterm.open_with(url)
         end),
      }),
   },

   -- ------------------------------------------------------------------------
   -- Copy / paste
   -- ------------------------------------------------------------------------

   {
      key = 'c',
      mods = mod.COPY,
      action = act.CopyTo('Clipboard'),
   },

   {
      key = 'v',
      mods = mod.PASTE,
      action = act.PasteFrom('Clipboard'),
   },

   -- ------------------------------------------------------------------------
   -- Tabs
   -- ------------------------------------------------------------------------

   {
      key = 't',
      mods = mod.PRIMARY,
      action = act.SpawnTab('DefaultDomain'),
   },

   {
      key = 'w',
      mods = mod.PRIMARY_REV,
      action = act.CloseCurrentTab({
         confirm = false,
      }),
   },

   {
      key = '[',
      mods = mod.PRIMARY,
      action = act.ActivateTabRelative(-1),
   },

   {
      key = ']',
      mods = mod.PRIMARY,
      action = act.ActivateTabRelative(1),
   },

   -- ------------------------------------------------------------------------
   -- Windows
   -- ------------------------------------------------------------------------

   {
      key = 'n',
      mods = mod.PRIMARY,
      action = act.SpawnWindow,
   },

   {
      key = '-',
      mods = mod.PRIMARY,
      action = resize_window(-50),
   },

   {
      key = '=',
      mods = mod.PRIMARY,
      action = resize_window(50),
   },

   -- ------------------------------------------------------------------------
   -- Backgrounds
   -- ------------------------------------------------------------------------

   {
      key = '/',
      mods = mod.PRIMARY,
      action = wezterm.action_callback(function(window)
         backdrops:random(window)
      end),
   },

   {
      key = ',',
      mods = mod.PRIMARY,
      action = wezterm.action_callback(function(window)
         backdrops:cycle_back(window)
      end),
   },

   {
      key = '.',
      mods = mod.PRIMARY,
      action = wezterm.action_callback(function(window)
         backdrops:cycle_forward(window)
      end),
   },

   -- ------------------------------------------------------------------------
   -- Panes
   -- ------------------------------------------------------------------------

   {
      key = '\\',
      mods = mod.PRIMARY,
      action = act.SplitVertical({
         domain = 'CurrentPaneDomain',
      }),
   },

   {
      key = '\\',
      mods = mod.PRIMARY_REV,
      action = act.SplitHorizontal({
         domain = 'CurrentPaneDomain',
      }),
   },

   {
      key = key.ENTER,
      mods = mod.PRIMARY,
      action = act.TogglePaneZoomState,
   },

   -- ------------------------------------------------------------------------
   -- Key tables
   -- ------------------------------------------------------------------------

   {
      key = 'f',
      mods = mod.LEADER,
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timeout_milliseconds = 1000,
      }),
   },

   {
      key = 'p',
      mods = mod.LEADER,
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timeout_milliseconds = 1000,
      }),
   },
}

local key_tables = {
   resize_font = {
      { key = 'k', action = act.IncreaseFontSize },
      { key = 'j', action = act.DecreaseFontSize },
      { key = 'r', action = act.ResetFontSize },
      { key = key.ESC, action = 'PopKeyTable' },
      { key = 'q', action = 'PopKeyTable' },
   },

   resize_pane = {
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = key.ESC, action = 'PopKeyTable' },
      { key = 'q', action = 'PopKeyTable' },
   },
}

return {
   disable_default_key_bindings = true,

   enable_kitty_keyboard = true,
   enable_csi_u_key_encoding = false,

   leader = {
      key = key.SPACE,
      mods = mod.ALT,
      timeout_milliseconds = 800,
   },

   keys = keys,
   key_tables = key_tables,

   mouse_bindings = {
      {
         event = {
            Up = {
               streak = 1,
               button = 'Left',
            },
         },

         mods = mod.CTRL,
         action = act.OpenLinkAtMouseCursor,
      },
   },
}
