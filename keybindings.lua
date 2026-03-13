local api = require('api')
local state = require('state')
local colors = require('colors')

local ALL_MODES = {
	'tool',
	'linestyle',
}

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


	-- NOTE:  <SHIFT> Tool
	--
	-- TAB toggleClipping -- Q redo    -- W         -- E linesyle   -- R selection -- T fit height          # Control variation row
	-- __                 -- A fpen    -- S fbox    -- D felipse    -- F cord      -- G dArrow              # Tool variation ROW
	-- __                 -- Z red pen -- X fredbox -- C red elipse -- V red arrow -- B fbezier             # Style combo,presets variation
	-- ` mangenta marker --


	-- NOTE:  Linestyle
	--
	-- high contrast colors, thicknes
	--
	-- TAB -- Q       -- W       -- E tool   -- R          -- T
	-- __  -- A black -- S dblue -- D red    -- F mangenta -- G dgreen                                      # Hight contrast Colors
	-- __  -- Z vthin -- X thin  -- C medium -- V thick    -- B vthick                                      # Thicknes
	-- ``` --

	-- NOTE:  <SHIFT> Linestyle
	--
	-- low contrast colors, linestyle
	--
	-- TAB -- Q      -- W       -- E        -- R        -- T
	-- __  -- A grey -- S lblue   -- D orange    -- F yellow --  G lgreen                                  # Low Contrast Colors
	-- __  -- Z .... -- X _. _. _ -- C  _ _ _ _  -- V ______  -- B                                         # Line modifyer
	-- ``` --


	pen = {
		description = 'Pen',
		buttons = { 'w' },
		modes = { 'tool' },
		call = api.pen,
	},

	highlighter = {
		description = 'Highlighter',
		buttons = { '<shift>a' },
		modes = { 'tool' },
		call = api.highlighter,
	},
	hand = {
		description = 'Hand',
		buttons = { '<tab>' },
		modes = { 'tool' },
		call = api.hand,
	},
	selection = {
		description = 'Selection',
		buttons = { 's' },
		modes = { 'tool' },
		call = api.selectRegion,
	},
	text = {
		description = 'Text',
		buttons = { '<Shift>t', '<Shift>i' },
		modes = { 'tool' },
		call = api.text,
	},
	delete = {
		description = 'Delete',
		buttons = { 'x' },
		modes = { 'tool' },
		call = api.delete,
	},

	-- History
	undo = {
		description = 'Undo',
		buttons = { 'q' },
		modes = { 'tool' },
		call = api.undo,
	},
	redo = {
		description = 'Redo',
		buttons = { '<shift>q' },
		modes = { 'tool' },
		call = api.redo,
	},


	-- Mode Selection
	linestyle = {
		description = 'Linestyle mode',
		buttons = { 'e' },
		modes = { 'tool' },
		call = function()
			changeMode('linestyle')
		end,
	},
	tool = {
		description = 'Linestyle mode',
		buttons = { 'e' },
		modes = { 'linestyle' },
		call = function()
			changeMode('tool')
		end,
	},
	stickyLinestyle = {
		description = 'Sticky linestyle mode',
		buttons = { '<Shift>e' },
		modes = { 'tool' },
		call = function()
			changeMode('linestyle', true)
		end,
	},
	resize = {
		description = 'Resize mode',
		buttons = { '<Shift>F' },
		modes = { 'tool' },
		call = function()
			changeMode('resize')
		end,
	},

	-- Various tool mode commands
	newAfterTool = {
		description = 'NewAfter',
		buttons = { 'n' },
		modes = { 'tool' },
		call = api.newAfter,
	},
	annotatePDFTool = {
		description = 'Annotate PDF',
		buttons = { 'o' },
		modes = { 'tool' },
		call = api.annotatePDF,
	},
	zoomIn = {
		description = 'Zoom in',
		buttons = { 'greater', 'plus' },
		modes = { 'tool' },
		call = api.zoomIn,
	},
	zoomOut = {
		description = 'Zoom out',
		buttons = { 'minus', 'less' },
		modes = { 'tool' },
		call = api.zoomOut,
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
		modes = { 'resize' },
		call = api.fine,
	},
	medium = {
		description = 'Medium',
		buttons = { 'c' },
		modes = { 'resize' },
		call = api.medium,
	},
	thick = {
		description = 'Thick',
		buttons = { 'v' },
		modes = { 'resize' },
		call = api.thick,
	},
	veryThick = {
		description = 'Very thick',
		buttons = { 'b' },
		modes = { 'resize' },
		call = api.veryThick,
	},
	-- Colors
	black = {
		description = 'Black',
		buttons = { 'a' },
		modes = { 'linestyle' },
		call = function()
			api.changeToolColor(colors.black)
		end,
	},
	white = {
		description = 'White',
		buttons = { 'w' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.white)
		end,
	},
	pink = {
		description = 'Pink',
		buttons = { 'q' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.pink)
		end,
	},
	red = {
		description = 'Red',
		buttons = { 'r' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.red)
		end,
	},
	orange = {
		description = 'Orange',
		buttons = { 'o' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.orange)
		end,
	},
	yellow = {
		description = 'Yellow',
		buttons = { 'y' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.yellow)
		end,
	},
	green = {
		description = 'Green',
		buttons = { 'g' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.green)
		end,
	},
	cyan = {
		description = 'Cyan',
		buttons = { 'c' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.cyan)
		end,
	},
	blue = {
		description = 'Blue',
		buttons = { 'b' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.blue)
		end,
	},
	purple = {
		description = 'Purple',
		buttons = { 'p', 'a' },
		modes = { 'color' },
		call = function()
			api.changeToolColor(colors.purple)
		end,
	},

	-- Shapes
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
	rectangle = {
		description = 'Rectangle',
		buttons = { 'a' },
		modes = { 'shape' },
		call = api.rectangle,
	},
	ellipse = {
		description = 'Ellipse',
		buttons = { 's' },
		modes = { 'shape' },
		call = api.ellipse,
	},
	spline = {
		description = 'Spline',
		buttons = { 'b' },
		modes = { 'shape' },
		call = api.spline,
	},
	fill = {
		description = 'Fill',
		buttons = { 'f' },
		modes = { 'shape' },
		call = api.fill,
	},
	-- Linestyles
	plain = {
		description = 'Plain',
		buttons = { 'z' },
		modes = { 'linestyle' },
		call = api.plain,
	},
	dashed = {
		description = 'Dashed',
		buttons = { 's' },
		modes = { 'linestyle' },
		call = api.dashed,
	},
	dotted = {
		description = 'Dotted',
		buttons = { 'd' },
		modes = { 'linestyle' },
		call = api.dotted,
	},
	dashDotted = {
		description = 'DashDotted',
		buttons = { 'f' },
		modes = { 'linestyle' },
		call = api.dashDotted,
	},

	-- Page
	copyPage = {
		description = 'copyPage',
		buttons = { 'c' },
		modes = { 'page' },
		call = api.copyPage,
	},
	deletePage = {
		description = 'DeletePage',
		buttons = { 'd' },
		modes = { 'page' },
		call = function()
			api.openDialog(
				'Do you really want to delete this page?',
				{ [1] = 'Yes', [2] = 'No' },
				function(button)
					if button == 1 then
						api.deletePage()
					end
				end,
				false
			)
		end,
	},
	moveUp = {
		description = 'Move Up',
		buttons = { 'w' },
		modes = { 'page' },
		call = api.moveUp,
	},
	moveDown = {
		description = 'Move Down',
		buttons = { 's' },
		modes = { 'page' },
		call = api.moveDown,
	},
	newBefore = {
		description = 'New Before',
		buttons = { '<Shift>a' },
		modes = { 'page' },
		call = api.newBefore,
	},
	newAfter = {
		description = 'New After',
		buttons = { 'a' },
		modes = { 'page' },
		call = api.newAfter,
	},
	deleteLayer = {
		description = 'Delete Layer',
		buttons = { 'x' },
		modes = { 'page' },
		call = function()
			api.openDialog(
				'Do you really want to delete this layer?',
				{ [1] = 'Yes', [2] = 'No' },
				function(button)
					if button == 1 then
						api.deleteLayer()
					end
				end,
				false
			)
		end,
	},
	newLayer = {
		description = 'NewLayer',
		buttons = { 'y' },
		modes = { 'page' },
		call = api.newLayer,
	},
	ruledBG = {
		description = 'Ruled background',
		buttons = { 'f' },
		modes = { 'page' },
		call = api.ruledBG,
	},
	graphBG = {
		description = 'Graph background',
		buttons = { 'g' },
		modes = { 'page' },
		call = api.graphBG,
	},
	isoGraphBG = {
		description = 'Isometric graph background',
		buttons = { 'r' },
		modes = { 'page' },
		call = api.isometricGraphBG,
	},
	dottedGraphBG = {
		description = 'Dotted background',
		buttons = { 'v' },
		modes = { 'page' },
		call = api.dottedGraphBG,
	},
	isodottedGraphBG = {
		description = 'Isometric dotted background',
		buttons = { 'b' },
		modes = { 'page' },
		call = api.isometricDottedGraphBG,
	},
	plainBG = {
		description = 'Plain background',
		buttons = { 'n' },
		modes = { 'page' },
		call = api.plainBG,
	},

	-- Navigation
	goToLastPage = {
		description = 'Go to last page',
		buttons = { '<Shift>g', 'e' },
		modes = { 'navigation' },
		call = function()
			state.lastPage = api.currentPage()
			api.goToLastPage()
		end,
	},
	goToFirstPage = {
		description = 'Go to first page',
		buttons = { 'g' },
		modes = { 'navigation' },
		call = function()
			state.lastPage = api.currentPage()
			api.goToFirstPage()
		end,
	},
	goToTop = {
		description = 'Go to top',
		buttons = { '<Shift>b' },
		modes = { 'navigation' },
		call = api.goToTop,
	},
	goToBottom = {
		description = 'Go to bottom',
		buttons = { 'b' },
		modes = { 'navigation' },
		call = api.goToBottom,
	},
	scrollPageDown = {
		description = 'Scroll page down',
		buttons = { 's' },
		modes = { 'navigation' },
		call = api.scrollPageDown,
	},
	scrollPageUp = {
		description = 'Scroll page up',
		buttons = { 'w' },
		modes = { 'navigation' },
		call = api.scrollPageUp,
	},
	goBack = {
		description = 'Go back to last visited page',
		buttons = { 'a' },
		modes = { 'navigation' },
		call = function()
			local cur = api.currentPage()
			api.goToPage(state.lastPage)
			state.lastPage = cur
		end,
	},
	layerUp = {
		description = 'Layer up',
		buttons = { 'y' },
		modes = { 'navigation' },
		call = api.layerUp,
	},
	layerDown = {
		description = 'Layer Down',
		buttons = { 'x' },
		modes = { 'navigation' },
		call = api.layerDown,
	},

	-- Files
	annotatePDF = {
		description = 'Annotate PDF',
		buttons = { 'a', 'o' },
		modes = { 'file' },
		call = api.annotatePDF,
	},
	exportAsPDF = {
		description = 'Export as PDF',
		buttons = { 'e' },
		modes = { 'file' },
		call = api.exportAsPDF,
	},
	save = {
		description = 'Save file',
		buttons = { 's', 'w' },
		modes = { 'file' },
		call = api.save,
	},
	saveAs = {
		description = 'Save file as ...',
		buttons = { '<Shift>s', '<Shift>w' },
		modes = { 'file' },
		call = api.saveAs,
	},
	open = {
		description = 'Open file',
		buttons = { 'f' },
		modes = { 'file' },
		call = api.open,
	},

	-- Visual
	lasso = {
		description = 'Select Region',
		buttons = { 's' },
		modes = { 'visual' },
		call = api.selectRegion,
	},
	selectRectangle = {
		description = 'Select Rectangle',
		buttons = { 'a', 'r' },
		modes = { 'visual' },
		call = api.selectRectangle,
	},
	selectObject = {
		description = 'Select Object',
		buttons = { 'f', 'g' },
		modes = { 'visual' },
		call = api.selectObject,
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

return {
	bindings = keybindings,
	ALL_MODES = ALL_MODES,
	changeMode = changeMode,
}
