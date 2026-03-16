local api = require('api')
local state = require('state')
--local colors = require('colors')

local ALL_MODES = {
  'tool',
  'linestyle',
}

local colors = {
  hard = {
    black = 0x000000,
    blue = 0x000099,
    red = 0x990000,
    green = 0x009900,
    purple = 0x990099,

  },
  soft = {
    grey = 0x878787,
    light_blue = 0x7676ff,
    orange = 0xff6611,
    light_green = 0x55ff55,
    cyan = 0xff30ba,
  },

}

-- helper functions
local function cleanShape()
  api.ruler(false)
  api.arrow(false)
  api.rectangle(false)
  api.ellipse(false)
  api.spline(false)
  api.fill(false)
end

-- modify for different layout or for left handed use
--[[ local leader = '<shift>'
local key_rows_left = {
	r0 = {
		k0_equal = 'equal',
		k1_one = '1',
		k2_two = '2',
		k3_three = '3',
		k4_four = '4',
		k5_five = '5',
	},
	r1 = {
		k0_tab = 'tab',
		k1_q = 'q',
		k2_w = 'w',
		k3_e = 'e',
		k4_r = 'r',
		k5_t = 't',
	},
	r2 = {
		k0_esc = 'esc',
		k1_a = 'a',
		k2_s = 's',
	},
	r3 = {
		k1_z = 'z',
		k2_x = 'x',
		k3_c = 'c',
		k4_v = 'v',
		k5_b = 'b',
	},
	r4 = {
		k2_backquote = 'backquote',
	},
}
--]]

local function changeMode(mode, stickyValue)
  state.currentMode = mode
  if stickyValue ~= nil then
    state.sticky = stickyValue
  end
  local display = state.currentMode
  if state.sticky then
    display = display .. ' (sticky)'
  end
  api.setPlaceholderValue('vi-mode', display)
end

--------------------
-- KEYBINDINGS:   --
--------------------



-- NOTE: Pylosophy Split keyboard focused (Glove80 / Go60)
-- everything drawing related to the left side
-- everything writing related to the right side

-- DRAW            WRITE
-- single haded    both handed
-------------------------------
-- =  1 2 3 4 5    6 7 8 9 0  -
--TAB q w e r t    y u i o p  \
--ESC a s d f g    h j k l ;  '
--    z x c v b    n m , . /
--       SHIFT     Space Enter

-- Arrows availabe on both sides
-- Homerow layer


local keybindings = {
  --NOTE: Left Side Drawing
  -- Tools
  -- NOTE: Tool
  --
  -- TAB hand -- Q undo     -- W toogle wand -- E linestyle   -- R selction rect -- T fit width           # CONTROL ROW
  -- __       -- A pen      -- S box         -- D elipse      -- F ruler         -- G arrow               # Tool ROW
  -- __       -- Z blue pen -- X fblue box   -- C blue felipse -- V blue arrow    -- B  bezier            # Style combo, presets
  --  `  marker --

  -- Control row

  hand = {
    description = 'Hand',
    buttons = { 'Tab' },
    modes = { 'tool' },
    call = api.hand,
  },

  undo = {
    description = 'Undo',
    buttons = { 'q' },
    modes = { 'tool' },
    call = api.undo,
  },

  wand = {

  },

  linestyle = {
    description = 'Linestyle mode',
    buttons = { 'e' },
    modes = { 'tool' },
    call = function()
      changeMode('linestyle')
    end,
  },
  fitWidth = {
    description = 'zoom to fit',
    buttons = { 't' },
    modes = { 'tool' },
    call = api.zoomFit,

  },

  -- Tool row
  pen = {
    description = 'Pen',
    buttons = { 'a' },
    modes = { 'tool' },
    call = function()
      cleanShape()
      api.pen()
    end,
  },
  rectangle = {
    description = 'Rectangle',
    buttons = { 's' },
    modes = { 'tool' },
    call = api.rectangle,
  },
  ellipse = {
    description = 'Ellipse',
    buttons = { 'd' },
    modes = { 'tool' },
    call = api.ellipse,
  },
  ruler = {
    description = 'Ruler',
    buttons = { 'f' },
    modes = { 'tool' },
    call = api.ruler,
  },
  arrow = {
    description = 'Arrow',
    buttons = { 'g' },
    modes = { 'tool' },
    call = api.arrow,
  },
  bluePen = {

  },
  filledBlueBox = {},
  filledBlueElipse = {},
  blueArrow = {},
  highlighter = {
    description = 'Highlighter',
    buttons = { 'backquote' },
    modes = { 'tool' },
    call = api.highlighter,

  },
  spline = {
    description = 'Spline',
    buttons = { 'b' },
    modes = { 'tool' },
    call = api.spline,
  },


  -- combo row
  -- presets most used

  -- NOTE:  <SHIFT> Tool
  --
  -- TAB toggleClipping -- Q redo    -- W         -- E linesyle   -- R selection -- T fit height          # Control variation row
  -- __                 -- A fpen    -- S fbox    -- D felipse    -- F cord      -- G dArrow              # Tool variation ROW
  -- __                 -- Z red pen -- X fredbox -- C red elipse -- V red arrow -- B fbezier             # Style combo,presets variation
  -- ` mangenta marker --

  -- Control variation

  gridSnapping =
  {
    description = 'Toogle grid Snapping',
    buttons = { '<shift>Tab' },
    modes = { 'tool' },
    call = api.gridSnapping,
  },

  redo = {
    description = 'Redo',
    buttons = { '<shift>q' },
    modes = { 'tool' },
    call = api.redo,
  },


  stikyLinestyle = {
    description = 'Linestyle mode',
    buttons = { '<shift>e' },
    modes = { 'tool' },
    call = function()
      changeMode('linestyle', true)
    end,
  },

  selection = {
    description = 'Selection',
    buttons = { '<shift>r' },
    modes = { 'tool' },
    call = api.selectRegion,
  },
  fitHeight = {
    description = 'zoom to normal',
    buttons = { '<shift>t' },
    modes = { 'tool' },
    call = api.zoomNormal,
  },


  -- NOTE:  Linestyle
  --
  -- high contrast colors, thicknes
  --
  -- TAB -- Q       -- W       -- E tool   -- R          -- T
  -- __  -- A black  -- S dblue -- D red    -- F mangenta -- G dgreen                                      # Hight contrast Colors
  -- __  -- Z vthin -- X thin  -- C medium -- V thick    -- B vthick                                      # Thicknes
  -- ``` --

  tool = {
    description = 'tool mode',
    buttons = { 'e' },
    modes = { 'linestyle' },
    call = function()
      changeMode('tool')
    end,
  },

  -- High contast colors

  black = {
    description = 'Black',
    buttons = { 'a' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.hard.black)
    end,
  },

  blue = {
    description = 'Dark Blue',
    buttons = { 's' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.hard.blue)
    end,
  },

  red = {
    description = 'Red',
    buttons = { 'd' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.hard.red)
    end,
  },

  purple = {
    description = 'Purple',
    buttons = { 'f' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.hard.purple)
    end,
  },

  green = {
    description = 'Green',
    buttons = { 'g' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.hard.green)
    end,
  },


  -- Thickness
  veryFine = {
    description = 'Very Fine',
    buttons = { 'z' },
    modes = { 'linestyle' },
    call = api.veryFine,
  },
  fine = {
    description = 'Fine',
    buttons = { 'x' },
    modes = { 'linestyle' },
    call = api.fine,
  },
  medium = {
    description = 'Medium',
    buttons = { 'c' },
    modes = { 'linestyle' },
    call = api.medium,
  },
  thick = {
    description = 'Thick',
    buttons = { 'v' },
    modes = { 'linestyle' },
    call = api.thick,
  },
  veryThick = {
    description = 'Very thick',
    buttons = { 'b' },
    modes = { 'linestyle' },
    call = api.veryThick,
  },

  -- NOTE:  <SHIFT> Linestyle
  --
  -- low contrast colors, linestyle
  --
  -- TAB -- Q      -- W       -- E        -- R        -- T
  -- __  -- A grey -- S lblue   -- D orange    -- F yellow --  G lgreen                                  # Low Contrast Colors
  -- __  -- Z .... -- X _. _. _ -- C  _ _ _ _  -- V ______  -- B                                         # Line modifyer
  -- ``` --

  -- Low contast colors

  grey = {
    description = 'Black',
    buttons = { '<shift>a' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.soft.grey)
    end,
  },

  lightBlue = {
    description = 'Light Blue',
    buttons = { '<shift>s' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.soft.light_blue)
    end,
  },

  orange = {
    description = 'Orange',
    buttons = { '<shift>d' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.soft.orange)
    end,
  },

  cyan = {
    description = 'cyan',
    buttons = { '<shift>f' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.soft.cyan)
    end,
  },

  lightGreen = {
    description = 'Light Green',
    buttons = { '<shift>g' },
    modes = { 'linestyle' },
    call = function()
      api.changeToolColor(colors.soft.light_green)
    end,
  },


  -- Line modifier
  dotted = {
    description = 'Dotted',
    buttons = { '<shift>z' },
    modes = { 'linestyle' },
    call = api.dotted,
  },
  dashDotted = {
    description = 'DashDotted',
    buttons = { '<shift> x' },
    modes = { 'linestyle' },
    call = api.dashDotted,
  },
  dashed = {
    description = 'Dashed',
    buttons = { '<shift>c' },
    modes = { 'linestyle' },
    call = api.dashed,
  },
  plain = {
    description = 'Plain',
    buttons = { '<shift>v' },
    modes = { 'linestyle' },
    call = api.plain,
  },






}


return {
  bindings = keybindings,
  ALL_MODES = ALL_MODES,
  changeMode = changeMode,
}
