--[[ ==========================================================================
	� Feyawen Ariana 2011-2015
		If you use my code, please give me credit.
		
	Color Picker Advanced
		Color Picker with RGBA + HSB Sliders and Text Digit + Hex Entry.  20 Favorite + History Slots.
		Swatches for Class, Faction, Quality and Rainbow Colors.
		
		By Feyawen-Llane
		
		
		Version 2.0.0
			+ Initial Public Release.
			+ Better toolbar graphics.
			+ Uses ACE Library for Options UI.
			+ Added Demon Hunter color (Legion isn't out yet!)
			
		Version 1.8.0
			+ Added Toolbar, Toggle Sections On/Off.
			
		Version 1.7.0
			+ Added Item Quality Swatches.
			
		Version 1.6.0
			+ Added Class & Faction Color Swatches.
			
		version 1.5.0
			+ Added Color Swatches.
			
		Version 1.4.0
			+ Added Favorites, Get/Set 20 colors.
			+ Upped History to 20 colors.
			
		Version 1.2.0
			+ Added History, remembers last 10 picked colors.
			
		Version 1.1.0
			+ Added HSB Sliders, so fricken cool.
			
		Version 1.0.0
			...OMG, Event calling Event infinite loop!  All's well that ends well.
			
========================================================================== ]]--
local myName, me = ...		-- Addon Name , Addon
local L = me.L					-- Language Shorthand


local defaults = {			-- Defaults
	profile = {
		showTooltips = true,		-- Show the Tooltips on the swatches
		showHSB = true,				-- Show Hue, Saturation, Brightness sliders
		showFavorites = true,		-- Show favorite color swatches
		showHistory = true,			-- Show history color swatches
		showSwatches = true,		-- Show Class, Faction, Quality, Rainbow color swatches
		showLabels = true,			-- Show label text over swatches and original/current color blocks
		favorite = {					-- 20 Favorites
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
		},
		history = {						-- 20 History
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
			{ r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
		},
	},
}


-- Sizing and Spacing, doing it with constants to tweek things easily
local PADDING = 5				-- Padding around each Container Block and Sliders

local RGBA_WIDTH = 256		-- Width of each R,G,B,A Slider
local RGBA_HEIGHT = 16		-- Height of each R,G,B,A Slider
local RGBA_SPACE = 5			-- Space between each R,G,B,A Slider

local DIGIT_SPACE = 5			-- Space between the Slider and the Editbox
local DIGIT_WIDTH = 40		-- Width of the Editbox

local SUFFIX_SPACE = 3		-- Space between the Editbox and Suffix
local SUFFIX_WIDTH = 19		-- Width of the Suffix text

local COLOR_WIDTH = 80		-- Width of the Old/New Color swatch
local COLOR_HEIGHT = 50		-- Height of the Old/New Color swatch
local COLOR_OFFSET = 15	-- Offset of the New Color over the Old Color
local COLOR_SPACE = 3		-- Space between the New Color swatch and the Hexcode Editbox

local HSB_WIDTH = 360		-- Width of each H,S,B slider
local HSB_HEIGHT = 16			-- Height of the S, B slider
local HSB_HUE_HEIGHT = 28	-- Height of the Hue slider
local HSB_SPACE = 5			-- Space between each H, S, B slider

local SWATCH_WIDTH = 80	-- Width of color swatch
local SWATCH_HEIGHT = 14	-- Height of color swatch


local containerWidth = 0		-- Holds the internal container Width


-- Class Colors
local classColor = {
	{ r = RAID_CLASS_COLORS["DEATHKNIGHT"].r, g = RAID_CLASS_COLORS["DEATHKNIGHT"].g, b = RAID_CLASS_COLORS["DEATHKNIGHT"].b },
	{ r = RAID_CLASS_COLORS["DRUID"].r, g = RAID_CLASS_COLORS["DRUID"].g, b = RAID_CLASS_COLORS["DRUID"].b },
	{ r = RAID_CLASS_COLORS["HUNTER"].r, g = RAID_CLASS_COLORS["HUNTER"].g, b = RAID_CLASS_COLORS["HUNTER"].b },
	{ r = RAID_CLASS_COLORS["MAGE"].r, g = RAID_CLASS_COLORS["MAGE"].g, b = RAID_CLASS_COLORS["MAGE"].b },
	{ r = RAID_CLASS_COLORS["PALADIN"].r, g = RAID_CLASS_COLORS["PALADIN"].g, b = RAID_CLASS_COLORS["PALADIN"].b },
	{ r = RAID_CLASS_COLORS["PRIEST"].r, g = RAID_CLASS_COLORS["PRIEST"].g, b = RAID_CLASS_COLORS["PRIEST"].b },
	{ r = RAID_CLASS_COLORS["ROGUE"].r, g = RAID_CLASS_COLORS["ROGUE"].g, b = RAID_CLASS_COLORS["ROGUE"].b },
	{ r = RAID_CLASS_COLORS["SHAMAN"].r, g = RAID_CLASS_COLORS["SHAMAN"].g, b = RAID_CLASS_COLORS["SHAMAN"].b },
	{ r = RAID_CLASS_COLORS["WARLOCK"].r, g = RAID_CLASS_COLORS["WARLOCK"].g, b = RAID_CLASS_COLORS["WARLOCK"].b },
	{ r = RAID_CLASS_COLORS["WARRIOR"].r, g = RAID_CLASS_COLORS["WARRIOR"].g, b = RAID_CLASS_COLORS["WARRIOR"].b },
}
local className = {
	[1] = "Death Knight",	-- Death Knight
	[2] = "Druid",			-- Druid
	[3] = "Hunter",			-- Hunter
	[4] = "Mage",			-- Mage
	[5] = "Paladin",		-- Paladin
	[6] = "Priest",			-- Priest
	[7] = "Rogue",			-- Rogue
	[8] = "Shaman",			-- Shaman
	[9] = "Warlock",		-- Warlock
	[10] = "Warrior",		-- Warrior
}


-- Loot Quality Colors
local lootColor = {
	{ r = ITEM_QUALITY_COLORS[0].r, g = ITEM_QUALITY_COLORS[0].g, b = ITEM_QUALITY_COLORS[0].b },
	{ r = ITEM_QUALITY_COLORS[1].r, g = ITEM_QUALITY_COLORS[1].g, b = ITEM_QUALITY_COLORS[1].b },
	{ r = ITEM_QUALITY_COLORS[2].r, g = ITEM_QUALITY_COLORS[2].g, b = ITEM_QUALITY_COLORS[2].b },
	{ r = ITEM_QUALITY_COLORS[3].r, g = ITEM_QUALITY_COLORS[3].g, b = ITEM_QUALITY_COLORS[3].b },
	{ r = ITEM_QUALITY_COLORS[4].r, g = ITEM_QUALITY_COLORS[4].g, b = ITEM_QUALITY_COLORS[4].b },
	{ r = ITEM_QUALITY_COLORS[5].r, g = ITEM_QUALITY_COLORS[5].g, b = ITEM_QUALITY_COLORS[5].b },
	{ r = ITEM_QUALITY_COLORS[6].r, g = ITEM_QUALITY_COLORS[6].g, b = ITEM_QUALITY_COLORS[6].b },
}
local lootName = {
	ITEM_QUALITY0_DESC,
	ITEM_QUALITY1_DESC,
	ITEM_QUALITY2_DESC,
	ITEM_QUALITY3_DESC,
	ITEM_QUALITY4_DESC,
	ITEM_QUALITY5_DESC,
	ITEM_QUALITY6_DESC,
}


-- Faction Colors
local factionColor = {
	{ r = 0.29, g = 0.33, b = 0.91 },
	{ r = 0.90, g = 0.05, b = 0.07 },
}
-- There doesn't seem to be a localized constant for Player Faction Name within the Blizzard API?
-- This Constant is Not Localized:	PLAYER_FACTION_GROUP = { [0] = "Horde", [1] = "Alliance" };
-- englishFaction, localizedFaction = UnitFactionGroup("unit")	<-- Can only be called on a unit, so it's useless to us for getting both factions localized
local factionName = {
	L["Alliance"],
	L["Horde"],
}


-- Pure (Rainbow) Colors
local pureColor = {
	{ r = 1.0, g = 0.0, b = 0.0 },	-- red
	{ r = 1.0, g = 0.5, b = 0.0 },	-- orange
	{ r = 1.0, g = 1.0, b = 0.0 },	-- yellow
	{ r = 0.0, g = 1.0, b = 0.0 },	-- green
	{ r = 0.0, g = 1.0, b = 1.0 },	-- cyan
	{ r = 0.0, g = 0.0, b = 1.0 },	-- blue
	{ r = 1.0, g = 0.0, b = 1.0 },	-- purple
	{ r = 0.0, g = 0.0, b = 0.0 }, -- black
	{ r = 1.0, g = 1.0, b = 1.0 }, -- white
}
local pureName = {
	L["Red"],
	L["Orange"],
	L["Yellow"],
	L["Green"],
	L["Cyan"],
	L["Blue"],
	L["Purple"],
	L["Black"],
	L["White"],
}
local pureBrightness = { 0.25, 0.50, 0.75, 1.00, 1.00, 1.00, 1.00 }	-- Adjustments for Darker and Lighter shades of the Pure Color
local pureSaturation = { 1.00, 1.00, 1.00, 1.00, 0.75, 0.50, 0.25 }	-- Adjustments for Darker and Lighter shades of the Pure Color










--[[ ==========================================================================
		Event Handlers
========================================================================== ]]--
me.event = CreateFrame("Frame", myName.."Event", UIParent)
me.event:Hide()
me.event:SetScript("OnEvent", function(self, event, ...)
		if (self[event]) then
			self[event](self, ...)
		end
	end)
me.event:RegisterEvent("ADDON_LOADED")


function me.event:ADDON_LOADED(addonName)
	if (addonName == myName) then return end
	me.event:UnregisterEvent("ADDON_LOADED")
	
	me.db = LibStub("AceDB-3.0"):New(myName.."DB", defaults, true)
	me.Options:Initialize()
	
	me.event:RegisterEvent("PLAYER_ENTERING_WORLD")
end


function me.event:PLAYER_ENTERING_WORLD()
	me.event:UnregisterEvent("PLAYER_ENTERING_WORLD")
	me:Create_UI()
	me:Hook_ColorPicker()
end










--[[ ==========================================================================
		Hook Scripts
========================================================================== ]]--
function me:Hook_ColorPicker()
	ColorPickerFrame:HookScript("OnShow", function(...) me:Hooked_OnShow(...) end)
	-- Other Scripts...,  (we don't need to hook these because we handle this ourself)
	-- "OnColorSelect" : Calls the .func
	-- "OnValueChanged" : Calls the .opacityFunc
end


function me:Hooked_OnShow(...)
	-- Turn off the keyboard, why default ColorPicker captures all keystrokes I have no idea?!
	ColorPickerFrame:EnableKeyboard(false)
	-- Push the regular ColorPicker frame off the side of the screen (we won't be seeing the default frame, but we're still using some of it for integration)
	ColorPickerFrame:SetClampedToScreen(false)
	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", 0, 0)
	me:Initialize_UI()
end


-- The Color has been changed
function me:Call_OnColorSelect()
	if (ColorPickerFrame.func) then
		local r, g, b, a = me:Get_RGBA()
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame.func()
	end
end


-- The Alpha has been changed (This is only called from a change in Opacity)
function me:Call_OnValueChanged()
	if (ColorPickerFrame.opacityFunc) then
		local r, g, b, a = me:Get_RGBA()
		ColorPickerFrame.opacity = 1.0 - a			-- Opacity is flipped for some reason?!
		OpacitySliderFrame:SetValue(1.0 - a)		-- *see above*
		ColorPickerFrame.opacityFunc()
	end
end










--[[ ==========================================================================
		Create UI
========================================================================== ]]--
function me:Create_UI()
	containerWidth = (PADDING * 5) + COLOR_WIDTH + COLOR_OFFSET + RGBA_WIDTH + DIGIT_WIDTH + DIGIT_SPACE + SUFFIX_SPACE + SUFFIX_WIDTH
	me:Create_DialogFrame()
	me:Create_Toolbar()
	me:Create_RGBA()
	me:Create_ColorBlock()
	me:Create_HSB()
	me:Create_Favorites()
	me:Create_History()
	me:Create_Swatches()
	me:Create_StaticPopup_ClearFavorites()
	me:Create_StaticPopup_ClearHistory()
end


function me:Create_DialogFrame()
	-- Main Dialog Frame
	me.ui = CreateFrame("Frame", myName, ColorPickerFrame)
	me.ui:EnableMouse(true)
	me.ui:SetMovable(true)
	me.ui:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 12, right = 12, top = 12, bottom = 12 },
	} )
	
	-- Header Texture
	me.ui.header = me.ui:CreateTexture(myName.."Header", me.ui)
	me.ui.header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	me.ui.header:SetSize(320, 64)
	me.ui.header:SetPoint("TOP", me.ui, "TOP", 0, 12)
	
	-- Header Title
	me.ui.header.text = me.ui:CreateFontString(myName.."HeaderText")
	me.ui.header.text:SetFontObject("GameFontNormal")
	me.ui.header.text:SetText(L["Color Picker Advanced"])
	me.ui.header.text:SetPoint("TOP", me.ui.header, "TOP", 0, -14)
	
	-- Scripts
	me.ui:SetScript("OnMouseDown", function(self, button)
			me.ui:StartMoving()
		end)
	me.ui:SetScript("OnMouseUp", function(self, button)
			me.ui:StopMovingOrSizing()
		end)
	me.ui:SetScript("OnHide", function(self)
			me.ui:StopMovingOrSizing()
		end)
end

function me:Create_Toolbar()
	local i = 0
	for i = 1, 5 do
		local key = "toolbar"..tostring(i)
		me.ui[key] = CreateFrame("Button", myName..key, me.ui)
		me.ui[key]:SetSize(32, 32)
		me.ui[key].ID = i
		me.ui[key]["texture"] = me.ui[key]:CreateTexture(myName..key.."texture", me.ui[key])
		me.ui[key].texture:SetAllPoints(me.ui[key])
		me.ui[key].texture:SetTexture("Interface\\AddOns\\ColorPickerAdvanced\\Artwork\\Toolbar.blp", false)
		me.ui[key].texture:SetTexCoord(0.0, 0.125, 0.0, 0.5)
		me.ui[key]:SetScript("OnMouseUp", function(self, button)
				if (self:IsMouseOver()) then
					me:Toggle_Visiblity(self.ID)
				end
			end)
	end
	me.ui.toolbar5:SetPoint("TOPRIGHT", me.ui, "TOPRIGHT", -8, -6)
	for i = 4, 1, -1 do
		me.ui["toolbar"..tostring(i)]:SetPoint("TOPRIGHT", me.ui["toolbar"..tostring(i+1)], "TOPLEFT", 8, 0)
	end
	-- Tooltip
	me:MakeTooltip(me.ui.toolbar1, L["Toggle HSB (Hue, Saturation, Brightness)"])
	me:MakeTooltip(me.ui.toolbar2, L["Toggle Favorite Colors"])
	me:MakeTooltip(me.ui.toolbar3, L["Toggle Recent History Colors"])
	me:MakeTooltip(me.ui.toolbar4, L["Toggle Class, Faction, Quality, and Color Swatches"])
	me:MakeTooltip(me.ui.toolbar5, L["Toggle Label Text"])
end


function me:Create_RGBA()
	me:Create_BasicFrame(me.ui, "rgba")
	
	-- Red Bar ----------------------------------------------------------------
	me:Create_BasicFrame(me.ui.rgba, "red", RGBA_WIDTH, RGBA_HEIGHT)
	me:Create_Gradient(me.ui.rgba.red, 0.0, 0.0, 0.0,   1.0, 0.0, 0.0)
	me:Create_ValueBox(me.ui.rgba.red)
	me:Create_FauxSlider(me.ui.rgba.red, 0, 255)
	me.ui.rgba.red.ValueChanged = function()
			me:Update_Color()
			me:Update_HSBfromRGB()
		end
	me.ui.rgba.red.ValueUpdated = function()
			me:Call_OnColorSelect()
		end
	
	-- Green Bar --------------------------------------------------------------
	me:Create_BasicFrame(me.ui.rgba, "green", RGBA_WIDTH, RGBA_HEIGHT)
	me:Create_Gradient(me.ui.rgba.green, 0.0, 0.0, 0.0,   0.0, 1.0, 0.0)
	me:Create_ValueBox(me.ui.rgba.green)
	me:Create_FauxSlider(me.ui.rgba.green, 0, 255)
	me.ui.rgba.green.ValueChanged = function()
			me:Update_Color()
			me:Update_HSBfromRGB()
		end
	me.ui.rgba.green.ValueUpdated = function()
			me:Call_OnColorSelect()
		end
	
	-- Blue Bar ---------------------------------------------------------------
	me:Create_BasicFrame(me.ui.rgba, "blue", RGBA_WIDTH, RGBA_HEIGHT)
	me:Create_Gradient(me.ui.rgba.blue, 0.0, 0.0, 0.0,   0.0, 0.0, 1.0)
	me:Create_ValueBox(me.ui.rgba.blue)
	me:Create_FauxSlider(me.ui.rgba.blue, 0, 255)
	me.ui.rgba.blue.ValueChanged = function()
			me:Update_Color()
			me:Update_HSBfromRGB()
		end
	me.ui.rgba.blue.ValueUpdated = function()
			me:Call_OnColorSelect()
		end
	
	-- Alpha Bar --------------------------------------------------------------
	me:Create_BasicFrame(me.ui.rgba, "alpha", RGBA_WIDTH, RGBA_HEIGHT)
	me:Create_Gradient(me.ui.rgba.alpha, 0.0, 0.0, 0.0,   1.0, 1.0, 1.0)
	me:Create_ValueBox(me.ui.rgba.alpha, "%")
	me:Create_FauxSlider(me.ui.rgba.alpha, 0, 255)
	me.ui.rgba.alpha.ValueChanged = function()
			me:Update_Color()	-- Alpha doesn't effect the color preview, but it does the Hexcode
			--Alpha doesn't effect HSB, so no need to Update_HSBfromRGB()
		end
	me.ui.rgba.alpha.ValueUpdated = function()
			me:Call_OnValueChanged()
		end
	
	-- Size the container frame
	local width = RGBA_WIDTH + DIGIT_WIDTH + DIGIT_SPACE + SUFFIX_SPACE + SUFFIX_WIDTH + (PADDING * 2)
	local height = (RGBA_HEIGHT * 4) + (RGBA_SPACE * 3) + (PADDING * 2)
	me.ui.rgba:SetSize(width, height)
	
	-- Position everything within its container frame
	me.ui.rgba.red:SetPoint("TOPLEFT", me.ui.rgba, "TOPLEFT", PADDING, -PADDING)
	me.ui.rgba.green:SetPoint("TOPLEFT", me.ui.rgba.red, "BOTTOMLEFT", 0, -RGBA_SPACE)
	me.ui.rgba.blue:SetPoint("TOPLEFT", me.ui.rgba.green, "BOTTOMLEFT", 0, -RGBA_SPACE)
	me.ui.rgba.alpha:SetPoint("TOPLEFT", me.ui.rgba.blue, "BOTTOMLEFT", 0, -RGBA_SPACE)
end


function me:Create_ColorBlock()
	me:Create_BasicFrame(me.ui, "color")
	
	-- Old Color --------------------------------------------------------------
	me:Create_BasicFrame(me.ui.color, "old", COLOR_WIDTH, COLOR_HEIGHT)
	me:SetFrameStyle(me.ui.color.old, nil, nil, nil, nil, 0.0,0.0,0.0,1.0,   1.0,1.0,1.0,1.0)
	me.ui.color.old:SetScript("OnMouseUp", function(self, button)
			if (self:IsMouseOver()) then
				me:Reset_Color()
			end
		end)
	me.ui.color.old["label"] = me.ui.color.old:CreateFontString(me.ui.color.old:GetName().."label")
	me.ui.color.old.label:SetFontObject(GameFontHighlightSmall)
	me.ui.color.old.label:SetPoint("TOPLEFT", me.ui.color.old, "TOPLEFT", 3, -3)
	me.ui.color.old.label:SetText(L["Original Color"])
	
	-- New Color --------------------------------------------------------------
	me:Create_BasicFrame(me.ui.color, "new", COLOR_WIDTH, COLOR_HEIGHT)
	me:SetFrameStyle(me.ui.color.new, nil, nil, nil, nil, 0.0,0.0,0.0,1.0,   1.0,1.0,1.0,1.0)
	me.ui.color.new:SetFrameLevel(me.ui.color.old:GetFrameLevel() + 1)	-- Make sure New is over Old
	me.ui.color.new:SetScript("OnMouseUp", function(self, button)
			-- This just captures the mouse because we overlap the new over the old color frames
		end)
	me.ui.color.new["label"] = me.ui.color.new:CreateFontString(me.ui.color.new:GetName().."label")
	me.ui.color.new.label:SetFontObject(GameFontHighlightSmall)
	me.ui.color.new.label:SetPoint("TOPLEFT", me.ui.color.new, "TOPLEFT", 3, -3)
	me.ui.color.new.label:SetText(L["Current Color"])
	
	-- Hex Code Editbox -------------------------------------------------------
	me.ui.color["hex"] = CreateFrame("Editbox", myName.."colorhexeditbox", me.ui.color)
	local editbox = me.ui.color["hex"]
	editbox:SetAutoFocus(false)
	editbox:SetFontObject(GameFontHighlightSmall)
	editbox:SetHeight(14)
	editbox:SetWidth(COLOR_WIDTH)
	editbox:SetJustifyH("CENTER")
	editbox:EnableMouse(true)
	editbox:SetCursorPosition(0)
	editbox:SetMaxLetters(8)		-- Updated based on .hasOpacity
	me:SetFrameStyle(editbox, nil, nil, nil, nil, 0.0, 0.0, 0.0, 0.5,   1.0, 1.0, 1.0, 1.0)
	-- Add a prefix text area to the editbox
	editbox["prefix"] = editbox:CreateFontString(editbox:GetName().."Prefix")
	local prefix = editbox["prefix"]
	prefix:SetFontObject(GameFontHighlightSmall)
	prefix:SetPoint("RIGHT", editbox, "LEFT", -SUFFIX_SPACE, 0)
	prefix:SetText("#")
	
	editbox["LearnHex"] = function(self)
			local r, g, b, a = me:Get_RGBA()
			r, g, b, a = r * 255, g * 255, b * 255, a * 255
			local hexcode = format("%.2x%.2x%.2x", r, g, b)
			if (ColorPickerFrame.hasOpacity) then
				hexcode = format("%.2x%.2x%.2x%.2x", a, r, g, b)
			end
			self.lastHexcode = hexcode
			self:SetText(hexcode)
		end
		
	editbox:SetScript("OnEditFocusGained", function(self)
			self:SetCursorPosition(0)
			self:HighlightText()
		end)
	editbox:SetScript("OnEditFocusLost", function(self)
			self:SetCursorPosition(0)
			self:HighlightText(0, 0)
		end)
	editbox:SetScript("OnEnterPressed", function(self)
			if (self.invalid) then
				self.invalid = nil
				self:SetText(self.lastHexcode)
				self:ClearFocus()
				return
			end
			local hexcode = self:GetText()
			local r, g, b, a = 0.0, 0.0, 0.0, 0.0
			local i = 1
			if (ColorPickerFrame.hasOpacity) then
				a = tonumber("0x"..strsub(hexcode, 1, 2))
				i = 3
			end
			r = tonumber("0x"..strsub(hexcode, i, i + 1))
			g = tonumber("0x"..strsub(hexcode, i + 2, i + 3))
			b = tonumber("0x"..strsub(hexcode, i + 4, i + 5))
			if (ColorPickerFrame.hasOpacity) then
				self:SetText(format("%.2x%.2x%.2x%.2x", a, r, g, b))
			else
				self:SetText(format("%.2x%.2x%.2x", r, g, b))
			end
			if (hexcode ~= self.lastHexcode) then
				me:Update_AllSliders(r, g, b, a)	-- Update all the sliders based on the Hex Code
			end
			self.lastHexcode = hexcode
			self:ClearFocus()
		end)
	editbox:SetScript("OnEscapePressed", function(self)
			self:SetText(self.lastHexcode)
			self:ClearFocus()
		end)
	editbox:SetScript("OnTextChanged", function(self)
			local hexcode = self:GetText()
			local r, g, b, a = 0.0, 0.0, 0.0, 0.0
			local i = 1
			if (ColorPickerFrame.hasOpacity) then
				a = tonumber("0x"..strsub(hexcode, 1, 2))
				i = 3
			end
			r = tonumber("0x"..strsub(hexcode, i, i + 1))
			g = tonumber("0x"..strsub(hexcode, i + 2, i + 3))
			b = tonumber("0x"..strsub(hexcode, i + 4, i + 5))
			if ((r) and (r >=0) and (r<=255)) and ((g) and (g >=0) and (g<=255)) and ((b) and (b >=0) and (b<=255)) and ((a) and (a >=0) and (a<=255)) then
				self:SetTextColor(1.0, 1.0, 1.0, 1.0)	-- Valid (white text)
				self.invalid = nil
			else
				self:SetTextColor(1.0, 0.0, 0.0, 1.0)	-- Invalid (red text)
				self.invalid = true
			end
		end)
		
	-- Size the container frame
	local width = (PADDING * 2) + COLOR_WIDTH + COLOR_OFFSET
	local height = me.ui.rgba:GetHeight()
	me.ui.color:SetSize(width, height)
	
	-- Position everything within its container
	me.ui.color.old:SetPoint("TOPLEFT", me.ui.color, "TOPLEFT", PADDING, -PADDING)
	me.ui.color.new:SetPoint("TOPLEFT", me.ui.color, "TOPLEFT", PADDING + COLOR_OFFSET, -PADDING - COLOR_OFFSET)
	editbox:SetPoint("TOPLEFT", me.ui.color.new, "BOTTOMLEFT", 0, -COLOR_SPACE)
	editbox:SetPoint("TOPRIGHT", me.ui.color.new, "BOTTOMRIGHT", 0, -COLOR_SPACE)
end


function me:Create_HSB()
	me:Create_BasicFrame(me.ui, "hsb")
	
	-- Hue Bar ----------------------------------------------------------------
	me:Create_BasicFrame(me.ui.hsb, "hue", HSB_WIDTH, HSB_HUE_HEIGHT)
	local i, sectionSize = 0, floor((HSB_WIDTH / 6) + 0.5)
	local stretchSize = HSB_WIDTH - (sectionSize * 5) - 2
	local color = {
		{ r=1.0, g=0.0, b=0.0 },	-- Red
		{ r=1.0, g=1.0, b=0.0 },	-- Yellow
		{ r=0.0, g=1.0, b=0.0 },	-- Green
		{ r=0.0, g=1.0, b=1.0 },	-- Cyan
		{ r=0.0, g=0.0, b=1.0 },	-- Blue
		{ r=1.0, g=0.0, b=1.0 },	-- Purple
		{ r=1.0, g=0.0, b=0.0 },	-- back to Red
	}
	for i = 1, 6 do
		local key = "gradient"..tostring(i)
		me.ui.hsb.hue[key] = me.ui.hsb.hue:CreateTexture(me.ui.hsb:GetName()..key, me.ui.hsb)
		me.ui.hsb.hue[key]:SetPoint("LEFT", me.ui.hsb.hue, "LEFT", 1 + ((i - 1) * sectionSize), 0)
		me.ui.hsb.hue[key]:SetSize(sectionSize, me.ui.hsb.hue:GetHeight() - 2)
		me.ui.hsb.hue[key]:SetVertexColor(1.0, 1.0, 1.0, 1.0)
		me.ui.hsb.hue[key]:SetTexture(1.0, 1.0, 1.0, 1.0)
		me.ui.hsb.hue[key]:SetGradient("HORIZONTAL", color[i].r, color[i].g, color[i].b, color[i+1].r, color[i+1].g, color[i+1].b)
	end
	-- Stretch the last gradient just a few pixels to fill the bar completely
	me.ui.hsb.hue.gradient6:SetWidth(stretchSize)
	me:Create_ValueBox(me.ui.hsb.hue, "�")	-- The default WoW Font does NOT have defined character "�" (Degree) [Char:0176]
	me:Create_FauxSlider(me.ui.hsb.hue, 0, 360)
	me.ui.hsb.hue.ValueChanged = function()
			me:Update_Color()
			me:Update_RGBfromHSB()
			me:Update_BrightnessBySaturationChange()
			me:Update_SaturationByBrightnessChange()
		end
	me.ui.hsb.hue.ValueUpdated = function()
		end
	
	-- Saturation Bar --------------------------------------------------------------
	me:Create_BasicFrame(me.ui.hsb, "saturation", HSB_WIDTH, HSB_HEIGHT)
	me:Create_Gradient(me.ui.hsb.saturation, 0.0, 0.0, 0.0,   0.0, 1.0, 0.0)
	me:Create_ValueBox(me.ui.hsb.saturation, "% ")
	me:Create_FauxSlider(me.ui.hsb.saturation, 0, 100)
	me.ui.hsb.saturation.ValueChanged = function()
			me:Update_Color()
			me:Update_RGBfromHSB()
			me:Update_BrightnessBySaturationChange()
			me:Update_SaturationByBrightnessChange()
		end
	me.ui.hsb.saturation.ValueUpdated = function()
		end
	
	-- Brightness Bar ---------------------------------------------------------------
	me:Create_BasicFrame(me.ui.hsb, "brightness", HSB_WIDTH, HSB_HEIGHT)
	me:Create_Gradient(me.ui.hsb.brightness, 0.0, 0.0, 0.0,   0.0, 0.0, 1.0)
	me:Create_ValueBox(me.ui.hsb.brightness, "% ")
	me:Create_FauxSlider(me.ui.hsb.brightness, 0, 100)
	me.ui.hsb.brightness.ValueChanged = function()
			me:Update_Color()
			me:Update_RGBfromHSB()
			me:Update_BrightnessBySaturationChange()
			me:Update_SaturationByBrightnessChange()
		end
	me.ui.hsb.brightness.ValueUpdated = function()
		end
	
	-- Size the container frame
	local width = containerWidth
	local height = (HSB_HEIGHT * 2) + HSB_HUE_HEIGHT + (HSB_SPACE * 2) + (PADDING * 2)
	me.ui.hsb:SetSize(width, height)
	
	-- Position everything within its container frame
	me.ui.hsb.hue:SetPoint("TOPLEFT", me.ui.hsb, "TOPLEFT", PADDING, -PADDING)
	me.ui.hsb.saturation:SetPoint("TOPLEFT", me.ui.hsb.hue, "BOTTOMLEFT", 0, -HSB_SPACE)
	me.ui.hsb.brightness:SetPoint("TOPLEFT", me.ui.hsb.saturation, "BOTTOMLEFT", 0, -HSB_SPACE)
end


function me:Create_Favorites()
	me:Create_BasicFrame(me.ui, "favorites")
	
	-- Create Color Swatches
	local i = 0
	local swatchSize = (containerWidth - 80 - (PADDING * 2)) / 20
	for i = 1, 20 do
		local key = "favorite"..tostring(i)
		me:Create_BasicFrame(me.ui.favorites, key, swatchSize, swatchSize, 1.0, 1.0, 1.0, 0.5)
		me.ui.favorites[key]:ClearAllPoints()
		if (i == 1) then
			me.ui.favorites[key]:SetPoint("RIGHT", me.ui.favorites, "RIGHT", -PADDING, 0)
		else
			me.ui.favorites[key]:SetPoint("RIGHT", me.ui.favorites["favorite"..tostring(i - 1)], "LEFT", -1, 0)
		end
		me.ui.favorites[key].ID = i
		me.ui.favorites[key]:SetScript("OnMouseUp", function(self, button)
				if (self:IsMouseOver()) then
					if (button == "LeftButton") then		-- Get favorite color
						local r = me.db.profile.favorite[self.ID].r or 0
						local g = me.db.profile.favorite[self.ID].g or 0
						local b = me.db.profile.favorite[self.ID].b or 0
						local a = me.db.profile.favorite[self.ID].a or 1
						me:Set_Color(r, g, b, a)
					elseif (button == "RightButton") then	-- Set favorite color
						local r, g, b, a = me:Get_RGBA()
						me.db.profile.favorite[self.ID].r = r
						me.db.profile.favorite[self.ID].g = g
						me.db.profile.favorite[self.ID].b = b
						me.db.profile.favorite[self.ID].a = a
						self:SetBackdropColor(r, g, b, 1.0)
					end
				end
			end)
		me.ui.favorites[key]:SetScript("OnEnter", function(self, ...)
				if (not me.db.profile.showTooltips) then return end
				local r = me.db.profile.favorite[self.ID].r
				local g = me.db.profile.favorite[self.ID].g
				local b = me.db.profile.favorite[self.ID].b
				local a = me.db.profile.favorite[self.ID].a
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:AddLine(format(L["Favorite Color: %d"], self.ID), 0.0, 0.5, 1.0)
				GameTooltip:AddLine(" ")	-- spacer
				GameTooltip:AddDoubleLine(L["Red"], 		format("%d (%f)", r * 255, r), 	1.00, 0.25, 0.25,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Green"], 	format("%d (%f)", g * 255, g), 	0.25, 1.00, 0.25,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Blue"], 		format("%d (%f)", b * 255, b), 	0.25, 0.25, 1.00,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Alpha"], 	format("%d (%f)", a * 255, a), 	0.75, 0.75, 0.75,   1.0, 1.0, 1.0)
				GameTooltip:AddLine(" ")	-- spacer
				GameTooltip:AddLine(L["|cffffff00Left-Click|r to get favorite."], 0.5, 0.5, 0.5)
				GameTooltip:AddLine(L["|cffffff00Right-Click|r to set favorite."], 0.5, 0.5, 0.5)
				GameTooltip:Show()
			end)
		me.ui.favorites[key]:SetScript("OnLeave", function(self, ...)
				if (not me.db.profile.showTooltips) then return end
				GameTooltip:Hide()
			end)
	end
	
	-- Create Label
	me.ui.favorites["label"] = me.ui.favorites:CreateFontString(me.ui.favorites:GetName().."label")
	local label = me.ui.favorites["label"]
	label:SetFontObject(GameFontHighlightSmall)
	label:SetPoint("LEFT", me.ui.favorites, "LEFT", PADDING, 0)
	label:SetText(L["Favorites"])
	
	-- Size container
	local height = swatchSize + (PADDING * 2)
	me.ui.favorites:SetSize(containerWidth, height)
end


function me:Create_History()
	me:Create_BasicFrame(me.ui, "recent")
	
	-- Create Color Swatches
	local i = 0
	local swatchSize = (containerWidth - 80 - (PADDING * 2)) / 20
	for i = 1, 20 do
		local key = "history"..tostring(i)
		me:Create_BasicFrame(me.ui.recent, key, swatchSize, swatchSize, 1.0, 1.0, 1.0, 0.5)
		me.ui.recent[key]:ClearAllPoints()
		if (i == 1) then
			me.ui.recent[key]:SetPoint("RIGHT", me.ui.recent, "RIGHT", -PADDING, 0)
		else
			me.ui.recent[key]:SetPoint("RIGHT", me.ui.recent["history"..tostring(i - 1)], "LEFT", -1, 0)
		end
		me.ui.recent[key].ID = i
		me.ui.recent[key]:SetScript("OnMouseUp", function(self, button)
				if (self:IsMouseOver()) then
					if (button == "LeftButton") then		-- Get history color
						local r = me.db.profile.history[self.ID].r or 0
						local g = me.db.profile.history[self.ID].g or 0
						local b = me.db.profile.history[self.ID].b or 0
						local a = me.db.profile.history[self.ID].a or 1
						me:Set_Color(r, g, b, a)
					end
				end
			end)
		me.ui.recent[key]:SetScript("OnEnter", function(self, ...)
				if (not me.db.profile.showTooltips) then return end
				local r = me.db.profile.history[self.ID].r
				local g = me.db.profile.history[self.ID].g
				local b = me.db.profile.history[self.ID].b
				local a = me.db.profile.history[self.ID].a
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				GameTooltip:AddLine(format(L["History Color: %d"], self.ID), 0.0, 0.5, 1.0)
				GameTooltip:AddLine(" ")	-- spacer
				GameTooltip:AddDoubleLine(L["Red"], 		format("%d (%f)", r * 255, r), 	1.00, 0.25, 0.25,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Green"], 	format("%d (%f)", g * 255, g), 	0.25, 1.00, 0.25,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Blue"], 		format("%d (%f)", b * 255, b), 	0.25, 0.25, 1.00,   1.0, 1.0, 1.0)
				GameTooltip:AddDoubleLine(L["Alpha"], 	format("%d (%f)", a * 255, a), 	0.75, 0.75, 0.75,   1.0, 1.0, 1.0)
				GameTooltip:AddLine(" ")	-- spacer
				GameTooltip:AddLine(L["|cffffff00Left-Click|r to get history color."], 0.5, 0.5, 0.5)
				GameTooltip:Show()
			end)
		me.ui.recent[key]:SetScript("OnLeave", function(self, ...)
				if (not me.db.profile.showTooltips) then return end
				GameTooltip:Hide()
			end)
	end
	
	-- Create Label
	me.ui.recent["label"] = me.ui.recent:CreateFontString(me.ui.recent:GetName().."label")
	local label = me.ui.recent["label"]
	label:SetFontObject(GameFontHighlightSmall)
	label:SetPoint("LEFT", me.ui.recent, "LEFT", PADDING, 0)
	label:SetText(L["History"])
	
	-- Size container
	local height = swatchSize + (PADDING * 2)
	me.ui.recent:SetSize(containerWidth, height)
end


function me:Create_Swatches()
	me:Create_BasicFrame(me.ui, "swatches")
	me:SetFrameStyle(me.ui.swatches, nil, nil, nil, nil, 0,0,0,0,   0,0,0,0)
	
	-- Class Colors -----------------------------------------------------------
	me:Create_BasicFrame(me.ui.swatches, "classes")
	local i = 0
	for i = 1, 10 do
		me:Create_ColorSwatch(me.ui.swatches.classes, "class"..tostring(i), className[i], classColor[i].r, classColor[i].g, classColor[i].b)
	end
	me.ui.swatches.classes.class1:SetPoint("TOPLEFT", me.ui.swatches.classes, "TOPLEFT", PADDING, -PADDING)
	for i = 2, 6 do
		me.ui.swatches.classes["class"..tostring(i)]:SetPoint("TOPLEFT", me.ui.swatches.classes["class"..tostring(i-1)], "BOTTOMLEFT", 0, -1)
	end
	for i = 7, 10 do
		me.ui.swatches.classes["class"..tostring(i)]:SetPoint("TOPLEFT", me.ui.swatches.classes["class"..tostring(i-6)], "TOPRIGHT", 1, 0)
	end
	local width = (PADDING * 2) + (SWATCH_WIDTH * 2) + 1
	local height =(PADDING * 2) + (SWATCH_HEIGHT * 6) + 5
	me.ui.swatches.classes:SetSize(width, height)
	me.ui.swatches.classes:SetPoint("TOPLEFT", me.ui.swatches, "TOPLEFT", 0, 0)
	
	
	-- Faction Colors ---------------------------------------------------------
	me:Create_BasicFrame(me.ui.swatches, "factions")
	for i = 1, 2 do
		me:Create_ColorSwatch(me.ui.swatches.factions, "faction"..tostring(i), factionName[i], factionColor[i].r, factionColor[i].g, factionColor[i].b)
	end
	me.ui.swatches.factions.faction1:SetPoint("TOPLEFT", me.ui.swatches.factions, "TOPLEFT", PADDING, -PADDING)
	me.ui.swatches.factions.faction2:SetPoint("TOPLEFT", me.ui.swatches.factions.faction1, "TOPRIGHT", 1, 0)
	width = (PADDING * 2) + (SWATCH_WIDTH * 2) + 1
	height = (PADDING * 2) + SWATCH_HEIGHT
	me.ui.swatches.factions:SetSize(width, height)
	me.ui.swatches.factions:ClearAllPoints()
	me.ui.swatches.factions:SetPoint("TOPLEFT", me.ui.swatches.classes, "BOTTOMLEFT", 0, -1)
	

	
	-- Loot Colors ------------------------------------------------------------
	me:Create_BasicFrame(me.ui.swatches, "loots")
	for i = 1, 7 do
		me:Create_ColorSwatch(me.ui.swatches.loots, "loot"..tostring(i), lootName[i], lootColor[i].r, lootColor[i].g, lootColor[i].b)
	end
	me.ui.swatches.loots.loot1:SetPoint("TOPLEFT", me.ui.swatches.loots, "TOPLEFT", PADDING, -PADDING)
	for i = 2, 7 do
		me.ui.swatches.loots["loot"..tostring(i)]:SetPoint("TOPLEFT", me.ui.swatches.loots["loot"..tostring(i-1)], "BOTTOMLEFT", 0, -1)
	end
	width = (PADDING * 2) + (SWATCH_WIDTH)
	height = (PADDING * 2) + (SWATCH_HEIGHT * 7) + 6
	me.ui.swatches.loots:SetSize(width, height)
	me.ui.swatches.loots:ClearAllPoints()
	me.ui.swatches.loots:SetPoint("TOPLEFT", me.ui.swatches.classes, "TOPRIGHT", PADDING, 0)
	
	
	-- Pure Colors ------------------------------------------------------------
	me:Create_BasicFrame(me.ui.swatches, "pure")
	me:Create_ColorSwatch(me.ui.swatches.pure, "black", "", pureColor[8].r, pureColor[8].g,pureColor[8].b, SWATCH_HEIGHT, (SWATCH_HEIGHT * 7) + 6)
	me.ui.swatches.pure.black:SetPoint("TOPLEFT", me.ui.swatches.pure, "TOPLEFT", PADDING, -PADDING)
	local n = 0
	local name = ""
	for n = 1, 7 do
		local r, g, b = pureColor[n].r, pureColor[n].g, pureColor[n].b
		local H, S, B = me:Convert_RGB_HSB(r, g, b)
		for i = 1, 7 do
			local rr, gg, bb = me:Convert_HSB_RGB(H, pureSaturation[i], pureBrightness[i])
			if (i == 4) then
				name = pureName[n]
				width = SWATCH_HEIGHT * 3
			else
				name = ""
				width = SWATCH_HEIGHT
			end
			me:Create_ColorSwatch(me.ui.swatches.pure, "color"..tostring(n)..tostring(i), name, rr, gg, bb, width, SWATCH_HEIGHT)
		end
	end
	me:Create_ColorSwatch(me.ui.swatches.pure, "white", "", pureColor[9].r, pureColor[9].g,pureColor[9].b, SWATCH_HEIGHT, (SWATCH_HEIGHT * 7) + 6)
	me.ui.swatches.pure.color11:SetPoint("TOPLEFT", me.ui.swatches.pure.black, "TOPRIGHT", 1, 0)
	for i = 2, 7 do
		me.ui.swatches.pure["color1"..tostring(i)]:SetPoint("TOPLEFT", me.ui.swatches.pure["color1"..tostring(i-1)], "TOPRIGHT", 1, 0)
	end
	for n = 2, 7 do
		for i = 1, 7 do
			me.ui.swatches.pure["color"..tostring(n)..tostring(i)]:SetPoint("TOPLEFT", me.ui.swatches.pure["color"..tostring(n-1)..tostring(i)], "BOTTOMLEFT", 0, -1)
		end
	end
	me.ui.swatches.pure.white:SetPoint("TOPRIGHT", me.ui.swatches.pure, "TOPRIGHT", -PADDING, -PADDING)
	width = (PADDING * 2) + (SWATCH_HEIGHT * 11) + 8
	height = (PADDING * 2) + (SWATCH_HEIGHT * 7) + 6
	me.ui.swatches.pure:SetSize(width, height)
	me.ui.swatches.pure:ClearAllPoints()
	me.ui.swatches.pure:SetPoint("TOPLEFT", me.ui.swatches.loots, "TOPRIGHT", PADDING, 0)
	
	
	-- Filler
	me:Create_BasicFrame(me.ui.swatches, "filler")
	width = me.ui.swatches.loots:GetWidth() + PADDING + me.ui.swatches.pure:GetWidth()
	height = ((PADDING * 4) + (SWATCH_HEIGHT * 7) + 5) - height
	me.ui.swatches.filler:SetSize(width, height)
	me.ui.swatches.filler:ClearAllPoints()
	me.ui.swatches.filler:SetPoint("BOTTOMRIGHT", me.ui.swatches, "BOTTOMRIGHT", 0, 0)
	
	
	-- Size container
	height = (PADDING * 4) + (SWATCH_HEIGHT * 7) + 6
	me.ui.swatches:SetSize(containerWidth, height)
end










--[[ ==========================================================================
		Creation Building Blocks
========================================================================== ]]--
function me:Create_ColorSwatch(parent, key, label, r, g, b, width, height)
	me:Create_BasicFrame(parent, key, width or SWATCH_WIDTH, height or SWATCH_HEIGHT, 1.0, 1.0, 1.0, 0.5)
	parent[key]:ClearAllPoints()
	parent[key]:SetBackdropColor(r, g, b, 1.0)
	parent[key]:SetScript("OnMouseUp", function(self, button)
			if (self:IsMouseOver()) then
				if (button == "LeftButton") then
					local r, g, b, a = self:GetBackdropColor()
					me:Set_Color(r, g, b, a)
				end
			end
		end)
	me:Create_SwatchLabel(parent[key], "label", label)
end


function me:Create_SwatchLabel(parent, name, text)
	parent[name] = parent:CreateFontString(parent:GetName()..name)
	parent[name]:SetFontObject(GameFontHighlightSmall)
	parent[name]:SetTextColor(1.0, 1.0, 1.0, 1.0)
	parent[name]:SetPoint("CENTER", parent, "CENTER", 0, 0)
	parent[name]:SetText(text)
end


function me:Create_BasicFrame(parent, name, width, height, br, bg, bb, ba)
	parent[name] = CreateFrame("Button", myName..name, parent)
	parent[name]:SetSize(width or 1, height or 1)	-- If we have no size, other frames that anchor us won't work correctly
	me:SetFrameStyle(parent[name], nil, nil, nil, nil, 0.0, 0.0, 0.0, 0.25,   br or 0.5, bg or 0.5, bb or 0.5, ba or 0.5)
	parent[name]:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)	-- If we don't define this, other anchors won't work correctly
end


function me:Create_Gradient(parent, r,g,b, rr,gg,bb)
	parent["gradient"] = parent:CreateTexture(parent:GetName().."Gradient", parent)
	local gradient = parent["gradient"]
	gradient:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)
	gradient:SetVertexColor(1.0, 1.0, 1.0, 1.0)
	gradient:SetTexture(1.0, 1.0, 1.0, 1.0)	-- For some reason, gradient doesn't work until texture is a solid color
	gradient:SetGradient("HORIZONTAL", r,g,b, rr,gg,bb)
end


function me:Create_ValueBox(parent, suffixMark)
	-- Make an editbox and set it up so it's usable
	parent["editbox"] = CreateFrame("Editbox", parent:GetName().."Editbox", parent)
	local editbox = parent["editbox"]
	editbox:SetAutoFocus(false)
	editbox:SetFontObject(GameFontHighlightSmall)
	editbox:SetHeight(14)
	editbox:SetWidth(DIGIT_WIDTH)
	editbox:SetJustifyH("CENTER")
	editbox:EnableMouse(true)
	editbox:SetCursorPosition(0)
	editbox:SetMaxLetters(3)
	editbox:SetNumeric(true)
	editbox:SetPoint("LEFT", parent, "RIGHT", DIGIT_SPACE, 0)
	me:SetFrameStyle(editbox, nil, nil, nil, nil, 0.0, 0.0, 0.0, 0.5,   1.0, 1.0, 1.0, 1.0)
	
	-- Add a suffix text area to the edit box
	editbox["suffix"] = editbox:CreateFontString(editbox:GetName().."Suffix")
	local suffix = editbox["suffix"]
	suffix:SetFontObject(GameFontHighlightSmall)
	suffix:SetPoint("LEFT", editbox, "RIGHT", SUFFIX_SPACE, 0)
	suffix:SetText(suffixMark or "")
	
	-- Functions --------------------------------------------------------------
	-- Called by the Faux Slider widget when the value is changed and the text
	--		in the editbox needs to be updated.  Value bounds check must be done
	--		done before this call.
	editbox["UpdateTextByValue"] = function(self, value)
			local slider = self:GetParent()["slider"]
			if (self.suffix:GetText() == "%") then	-- Is this a percentage?
				self:SetText(format("%d", floor(((value / slider.maxValue) * 100) + 0.5)))
			else
				self:SetText(format("%d", value))
			end
		end
	
	-- Scripts ----------------------------------------------------------------
	editbox:SetScript("OnEditFocusGained", function(self)
			self:SetCursorPosition(0)
			self:HighlightText()
		end)
		
	editbox:SetScript("OnEditFocusLost", function(self)
			self:SetCursorPosition(0)
			self:HighlightText(0, 0)
		end)
		
	editbox:SetScript("OnEnterPressed", function(self)
			local slider = self:GetParent()["slider"]
			local newValue = tonumber(self:GetText()) or 0
			if (self.suffix:GetText() == "%") then	-- Is this a percentage value
				newValue = (newValue / 100) * slider.maxValue
			end
			if (newValue < slider.minValue) then newValue = slider.minValue end
			if (newValue > slider.maxValue) then newValue = slider.maxValue end
			slider:SetValue(newValue, true)
			self:ClearFocus()
		end)
		
	editbox:SetScript("OnEscapePressed", function(self)
			self:UpdateTextByValue(self:GetParent()["slider"]:GetValue())
			self:ClearFocus()
		end)
		
	editbox:SetScript("OnTextChanged", function(self)
			local slider = self:GetParent()["slider"]
			local newValue = tonumber(self:GetText()) or 0
			local inRange =false
			if (self.suffix:GetText() == "%") then
				if (newValue >= 0) and (newValue <= 100) then
					inRange = true
				end
			else
				if (newValue >= slider.minValue) and (newValue <= slider.maxValue) then	
					inRange = true
				end
			end
			if (inRange) then
				self:SetTextColor(1.0, 1.0, 1.0, 1.0)	-- Valid (white text)
			else
				self:SetTextColor(1.0, 0.0, 0.0, 1.0)	-- Invalid (red text)
			end
		end)
end


-- Create the Faux Slider that will handle mouse input
function me:Create_FauxSlider(parent, minValue, maxValue)
	-- Transparent overlay frame will be used to capture mouse position
	parent["slider"] = CreateFrame("Button", parent:GetName().."Slider", parent)
	local slider = parent["slider"]
	slider:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, 0)
	slider:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -2, 0)
	slider.value = maxValue			-- Expecting SetValue to be called to set this
	slider.lastValue = nil				-- This invalidates the last-value to force a refresh after creation
	slider.initialized = nil				-- Allow 1 OnUpdate to set positions and sizes properly
	slider.doDrag = nil				-- We are not dragging the thumb
	slider.minValue = minValue
	slider.maxValue = maxValue
	slider.timer = 0.01	-- Speed of refresh when the mouse is being dragged over the Slider
	
	-- Thumb indicates value position on the slider
	slider["thumb"] = slider:CreateTexture(slider:GetName().."Thumb", slider)
	local thumb = slider["thumb"]
	thumb:SetTexture("Interface\\AddOns\\ColorPickerAdvanced\\Artwork\\SliderMarks.blp", false)
	thumb:SetTexCoord(0.0, 0.21875, 0.0, 1.0)
	thumb:SetSize(7, parent:GetHeight() + 4)
	thumb:SetPoint("CENTER", slider, "CENTER", 0, 0)
	
	-- Functions --------------------------------------------------------------
	--[[
		Parent must have functions defined;
			ValueChanged()	-- 
			ValueUpdated()	-- Use to update other sliders
		Editbox must have functions;
			UpdateTextByValue(value)		-- Fill the Editbox with the value of the slider
	]]--
	slider["Update"] = function(self)
			local percent = self.value / self.maxValue
			local pos = self:GetWidth() * percent
			self.thumb:ClearAllPoints()
			self.thumb:SetPoint("CENTER", self, "LEFT", pos, 0)
			local editbox = self:GetParent()["editbox"]
			editbox:UpdateTextByValue(self.value)	-- Call the UpdateTextByValue event of the Editbox
		end
	slider["SetValue"] = function(self, value, doCallback)
			if (value < self.minValue) then value = self.minValue end
			if (value > self.maxValue) then value = self.maxValue end
			self.value = floor(value + 0.5)	-- round values
			if (doCallback) then
				if (self.value ~= self.lastValue) then
					self:GetParent():ValueChanged()	-- Call the ValueChanged event of the Parent
				end
			end
			self:GetParent():ValueUpdated()	-- Call the ValueUpdated event of the Parent
			self.lastValue = self.value
			self:Update()
		end
	slider["GetValue"] = function(self)
			return self.value
		end
	slider["SetByMouse"] = function(self, clamp)
			-- Get the bounds of the frame and account for any Scale settings
			local scale = ColorPickerFrame:GetScale()	-- We inherit scale from our "parent" the ColorPickerFrame
			local left = self:GetLeft() * scale
			local right = self:GetRight() * scale
			local top = self:GetTop() * scale
			local bottom = self:GetBottom() * scale
			
			-- Get the cursor position and account for any UI Scale settings
			local uiscale = UIParent:GetEffectiveScale()
			local x, y = GetCursorPosition()
			x = x / uiscale
			y = y / uiscale
			
			-- Is the mouse down in the bounds of our frame
			if ((x > left) and (x < right)) and (((y > bottom) and (y < top)) or clamp) then
				local width = right - left
				local clickPos = x - left
				local percent = clickPos / width
				local value = self.maxValue * percent
				self:SetValue(value, true)
			elseif (clamp) then
				if (x < left) then
					self:SetValue(self.minValue, true)
				elseif (x > right) then
					self:SetValue(self.maxValue, true)
				end
			end
		end
	
	-- Scripts ----------------------------------------------------------------
	slider:SetScript("OnMouseWheel", function(self, delta)
			local step = 1
			if (IsShiftKeyDown()) then step = 10 end
			if (delta > 0) then
				self:SetValue(self.value + step, true)
			else
				self:SetValue(self.value - step, true)
			end
		end)
		
	slider:SetScript("OnMouseDown", function(self, button)
			self.elapsed = 0
			self.doDrag = true
			self:SetByMouse()
		end)
		
	slider:SetScript("OnMouseUp", function(self, button)
			self.doDrag = nil
		end)
		
	slider:SetScript("OnUpdate", function(self, elapsed)
			-- Do 1 Update to Finish Positioning and Sizing
			if (not self.initialized) then
				self.initialized = true
				self:Update()
			end
			-- Are we dragging the thumb?
			if (not self.doDrag) then return end
			self.elapsed = self.elapsed + elapsed
			if (self.elapsed > self.timer) then
				self.elapsed = 0
				self:SetByMouse(true)
			end
		end)
		
end


function me:Create_StaticPopup_ClearFavorites()
	StaticPopupDialogs["CPA_CONFIRM_CLEAR_FAVORITES"] = {
		text =  L[myName].."\n"..L["Are you sure you want to Clear all Favorites?"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			me:Clear_Favorites(true)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end


function me:Create_StaticPopup_ClearHistory()
	StaticPopupDialogs["CPA_CONFIRM_CLEAR_HISTORY"] = {
		text = L[myName].."\n"..L["Are you sure you want to Clear all Recent History?"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			me:Clear_History(true)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
end










--[[ ==========================================================================
		Initializations
========================================================================== ]]--
function me:Initialize_UI()
	me:Initialize_RGBA()
	me:Initialize_Color()
	me:Initialize_HSB()
	me.Initialize_Favorites()
	me:Initialize_History()
	me:Initialize_Buttons()
	me:Initialize_Dialog()
	me:Update_Labels()
end


function me:Initialize_RGBA()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	r, g, b = r * 255, g * 255, b * 255
	
	local a = ColorPickerFrame.opacity or 1
	a = (1.0 - a) * 255	-- For some reason, alpha is flipped around
	
	local i = 0
	local keys = { "red", "green", "blue", "alpha" }
	local values = { r, g, b, a }
	for i = 1, #(keys) do
		me.ui.rgba[keys[i]].initialized = false				-- We have not initialized for this color yet
		me.ui.rgba[keys[i]].slider.lastValue = 99999		-- Invalidate the Last Value for the Slider, forces a refresh
		me.ui.rgba[keys[i]].slider:SetValue(values[i])	-- Set the initial value of the Sliderr
	end
end


function me:Initialize_Color()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	me.ui.color.old:SetBackdropColor(r, g, b, 1.0)
	me:Update_Color()
end


function me:Initialize_HSB()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local H, S, B = me:Convert_RGB_HSB(r, g, b)
	S, B = S * 100, B * 100
	
	local i = 0
	local keys = { "hue", "saturation", "brightness" }
	local values = { H, S, B }
	for i = 1, #(keys) do
		me.ui.hsb[keys[i]].initialized = false
		me.ui.hsb[keys[i]].slider.lastValue = 999999
		me.ui.hsb[keys[i]].slider:SetValue(values[i])
	end
	me:Update_SaturationByBrightnessChange()
	me:Update_BrightnessBySaturationChange()
end


function me:Initialize_Favorites()
	local i = 0
	for i = 1, 20 do
		local key = "favorite"..tostring(i)
		local r = me.db.profile.favorite[i].r or 0
		local g = me.db.profile.favorite[i].g or 0
		local b = me.db.profile.favorite[i].b or 0
		me.ui.favorites[key]:SetBackdropColor(r, g, b, 1.0)
	end
end


function me:Initialize_History()
	local i = 0
	for i = 1, 20 do
		local key = "history"..tostring(i)
		local r = me.db.profile.history[i].r or 0
		local g = me.db.profile.history[i].g or 0
		local b = me.db.profile.history[i].b or 0
		me.ui.recent[key]:SetBackdropColor(r, g, b, 1.0)
	end
end


function me:Initialize_Buttons()
	if (me.gotButtons) then return end	-- Only appropriate the buttons once
	me.gotButtons = true
	-- Appropriate the ColorPicker Okay Button
	ColorPickerOkayButton:SetFrameStrata(me.ui:GetFrameStrata())
	ColorPickerOkayButton:SetFrameLevel(me.ui:GetFrameLevel() + 1)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMLEFT", me.ui, "BOTTOMLEFT", 12, 12)
	ColorPickerOkayButton:HookScript("OnClick", function(self, button)
			me:Add_RecentHistory()
			HideUIPanel(ColorPickerFrame)
		end)
	
	-- Appropriate the ColorPicker Cancel Button
	ColorPickerCancelButton:SetFrameStrata(me.ui:GetFrameStrata())
	ColorPickerCancelButton:SetFrameLevel(me.ui:GetFrameLevel() + 1)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMRIGHT", me.ui, "BOTTOMRIGHT", -12, 12)
	ColorPickerCancelButton:HookScript("OnClick", function(self, button)
			HideUIPanel(ColorPickerFrame)
		end)
end


function me:Initialize_Dialog()
	me:Update_Dialog()
	
	-- Put Dialog in the Center of the Screen
	me.ui:ClearAllPoints()
	me.ui:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end










--[[ ==========================================================================
		Updates
========================================================================== ]]--
function me:Update_UI()
	return
end


function me:Update_Dialog()
	local width = (12 + PADDING) * 2	-- Insets + Padding (left & right)
	local height = ((12 + PADDING) * 2) + 40	-- Insets + Padding (Top & Bottom) + Title + Buttons
	local anchor = me.ui
	
	width = width + me.ui.rgba:GetWidth() + PADDING + me.ui.color:GetWidth()
	
	-- RGBA + Color Block (Always Shown)
	height = height + me.ui.rgba:GetHeight()
	me.ui.rgba:ClearAllPoints()
	me.ui.rgba:SetPoint("TOPLEFT", me.ui, "TOPLEFT", 12 + PADDING, -32 - PADDING)
	me.ui.color:ClearAllPoints()
	me.ui.color:SetPoint("TOPLEFT", me.ui.rgba, "TOPRIGHT", PADDING, 0)
	me.ui.color:SetPoint("BOTTOMLEFT", me.ui.rgba, "BOTTOMRIGHT", PADDING, 0)
	if (ColorPickerFrame.hasOpacity) then
		me.ui.color.hex:SetMaxLetters(8)
		me.ui.rgba.alpha:Show()
	else
		me.ui.color.hex:SetMaxLetters(6)
		me.ui.rgba.alpha:Hide()
	end
	anchor = me.ui.rgba
	
	-- HSB?
	if (me.db.profile.showHSB) then
		height = height + me.ui.hsb:GetHeight() + PADDING
		me.ui.hsb:ClearAllPoints()
		me.ui.hsb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -PADDING)
		anchor = me.ui.hsb
		me.ui.hsb:Show()
	else
		me.ui.hsb:Hide()
	end
	
	-- Favorites?
	if (me.db.profile.showFavorites) then
		height = height + me.ui.favorites:GetHeight() + PADDING
		me.ui.favorites:ClearAllPoints()
		me.ui.favorites:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -PADDING)
		anchor = me.ui.favorites
		me.ui.favorites:Show()
	else
		me.ui.favorites:Hide()
	end
	
	-- History?
	if (me.db.profile.showHistory) then
		height = height + me.ui.recent:GetHeight() + PADDING
		me.ui.recent:ClearAllPoints()
		me.ui.recent:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -PADDING)
		anchor = me.ui.recent
		me.ui.recent:Show()
	else
		me.ui.recent:Hide()
	end
	
	-- Swatches?
	if (me.db.profile.showSwatches) then
		height = height + me.ui.swatches:GetHeight() + PADDING
		me.ui.swatches:ClearAllPoints()
		me.ui.swatches:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -PADDING)
		me.ui.swatches:Show()
	else
		me.ui.swatches:Hide()
	end
	
	-- Update the toolbar
	me:Update_Toolbar()
	
	-- Size Dialog
	me.ui:SetSize(width, height)
end


function me:Update_Toolbar()
	-- HSB?
	if (me.db.profile.showHSB) then
		me.ui.toolbar1.texture:SetTexCoord(0.0, 0.125, 0.5, 1.0)
	else
		me.ui.toolbar1.texture:SetTexCoord(0.0, 0.125, 0.0, 0.5)
	end
	
	-- Favorites
	if (me.db.profile.showFavorites) then
		me.ui.toolbar2.texture:SetTexCoord(0.125, 0.25, 0.5, 1.0)
	else
		me.ui.toolbar2.texture:SetTexCoord(0.125, 0.25, 0.0, 0.5)
	end
	
	-- History
	if (me.db.profile.showHistory) then
		me.ui.toolbar3.texture:SetTexCoord(0.25, 0.375, 0.5, 1.0)
	else
		me.ui.toolbar3.texture:SetTexCoord(0.25, 0.375, 0.0, 0.5)
	end
	
	-- Swatches
	if (me.db.profile.showSwatches) then
		me.ui.toolbar4.texture:SetTexCoord(0.375, 0.5, 0.5, 1.0)
	else
		me.ui.toolbar4.texture:SetTexCoord(0.375, 0.5, 0.0, 0.5)
	end
	
	-- Labels
	if (me.db.profile.showLabels) then
		me.ui.toolbar5.texture:SetTexCoord(0.5, 0.625, 0.5, 1.0)
	else
		me.ui.toolbar5.texture:SetTexCoord(0.5, 0.625, 0.0, 0.5)
	end
end


function me:Update_Color()
	local r = me.ui.rgba.red.slider:GetValue()
	local g = me.ui.rgba.green.slider:GetValue()
	local b = me.ui.rgba.blue.slider:GetValue()
	local a = me.ui.rgba.alpha.slider:GetValue()
	-- Update the Hexcode
	me.ui.color.hex:LearnHex()
	-- Update the New Color swatch
	r, g, b = r / 255, g / 255, b / 255
	me.ui.color.new:SetBackdropColor(r, g, b, 1.0)
end


-- Update all sliders based on rgba from the Hexcode being manually edited
function me:Update_AllSliders(r, g, b, a)
	if (me.lockAll) then return end	-- Prevents us from creating an infinite loop of events
	me.lockAll = true
	-- RGBA
	me.ui.rgba.red.slider:SetValue(r)
	me.ui.rgba.green.slider:SetValue(g)
	me.ui.rgba.blue.slider:SetValue(b)
	me.ui.rgba.alpha.slider:SetValue(a)
	-- HSB
	r, g, b = r / 255, g / 255, b / 255
	local H, S, B = me:Convert_RGB_HSB(r, g, b)
	me.ui.hsb.hue.slider:SetValue(H)
	me.ui.hsb.saturation.slider:SetValue(S * 100)
	me.ui.hsb.brightness.slider:SetValue(B * 100)
	-- Color
	me:Update_Color()
	-- Gradients
	me:Update_SaturationByBrightnessChange()
	me:Update_BrightnessBySaturationChange()
	me.lockAll = false
end


function me:Update_HSBfromRGB()
	if (me.lockRGB) then return end	-- Prevents us from creating an infinite loop of events
	me.lockRGB = true
	local r, g, b, a = me:Get_RGBA()
	local H, S, B = me:Convert_RGB_HSB(r, g, b)
	me.ui.hsb.hue.slider:SetValue(H)
	me.ui.hsb.saturation.slider:SetValue(S * 100)
	me.ui.hsb.brightness.slider:SetValue(B * 100)
	-- gradients
	me.ui.hsb.saturation.gradient:SetGradient("HORIZONTAL", B, B, B,   r, g, b)
	me.ui.hsb.brightness.gradient:SetGradient("HORIZONTAL", 0.0, 0.0, 0.0,   r, g, b)
	me.lockRGB = nil
end


function me:Update_RGBfromHSB()
	if (me.lockHSB) then return end	-- Prevents us from creating an infinte loop of events
	me.lockHSB = true
	local H, S, B = me:Get_HSB()
	local r, g, b = me:Convert_HSB_RGB(H, S, B)
	me.ui.rgba.red.slider:SetValue(r * 255)
	me.ui.rgba.green.slider:SetValue(g * 255)
	me.ui.rgba.blue.slider:SetValue(b * 255)
	me.lockHSB = nil
end


function me:Update_SaturationByBrightnessChange()
	local H, S, B = me:Get_HSB()
	local r, g, b = me:Convert_HSB_RGB(H, 1.0, B)
	local B = me.ui.hsb.brightness.slider:GetValue() / 100
	me.ui.hsb.saturation.gradient:SetGradient("HORIZONTAL", B, B, B,   r, g, b)
	me:Update_Color()
end


function me:Update_BrightnessBySaturationChange()
	local H, S, B = me:Get_HSB()
	local r, g, b = me:Convert_HSB_RGB(H, S, 1.0)
	me.ui.hsb.brightness.gradient:SetGradient("HORIZONTAL", 0.0, 0.0, 0.0,   r, g, b)
	me:Update_Color()
end


function me:Update_Labels()
	local i = 0
	if (me.db.profile.showLabels) then
		for i = 1, 10 do
			local key = "class"..tostring(i)
			me.ui.swatches.classes[key].label:Show()
		end
		for i = 1, 2 do
			local key = "faction"..tostring(i)
			me.ui.swatches.factions[key].label:Show()
		end
		for i = 1, 7 do
			local key = "loot"..tostring(i)
			me.ui.swatches.loots[key].label:Show()
		end
		for i = 1, 7 do
			local key = "color"..tostring(i).."4"
			me.ui.swatches.pure[key].label:Show()
		end
		me.ui.color.new.label:Show()
		me.ui.color.old.label:Show()
	else
		for i = 1, 10 do
			local key = "class"..tostring(i)
			me.ui.swatches.classes[key].label:Hide()
		end
		for i = 1, 7 do
			local key = "loot"..tostring(i)
			me.ui.swatches.loots[key].label:Hide()
		end
		for i = 1, 2 do
			local key = "faction"..tostring(i)
			me.ui.swatches.factions[key].label:Hide()
		end
		for i = 1, 7 do
			local key = "color"..tostring(i).."4"
			me.ui.swatches.pure[key].label:Hide()
		end
		me.ui.color.new.label:Hide()
		me.ui.color.old.label:Hide()
	end
end










--[[ ==========================================================================
		Helper Functions
========================================================================== ]]--
-- Get RGBA from the Sliders
function me:Get_RGBA()
	local r = me.ui.rgba.red.slider:GetValue() / 255
	local g = me.ui.rgba.green.slider:GetValue() / 255
	local b = me.ui.rgba.blue.slider:GetValue() / 255
	local a = me.ui.rgba.alpha.slider:GetValue() / 255
	return r, g, b, a
end


-- Get HSB from the Sliders
function me:Get_HSB()
	local h = me.ui.hsb.hue.slider:GetValue()
	local s = me.ui.hsb.saturation.slider:GetValue() / 100
	local b = me.ui.hsb.brightness.slider:GetValue() / 100
	return h, s, b
end


-- Reset the Color and Sliders to the Original color
function me:Reset_Color()
	me:Initialize_RGBA()
	me:Initialize_Color()
	me:Initialize_HSB()
end


-- Set the Color to a specific RGBA (Used by the Swatches)
function me:Set_Color(r, g, b, a)
	me:Update_AllSliders(r * 255, g * 255, b * 255, a * 255)
	me.ui.color.hex:LearnHex()
end


-- Add the current color to the Recent History list (Only when player clicks the Okay button)
function me:Add_RecentHistory()
	local i = 0
	for i = 20, 2, -1 do
		me.db.profile.history[i].r = me.db.profile.history[i-1].r
		me.db.profile.history[i].g = me.db.profile.history[i-1].g
		me.db.profile.history[i].b = me.db.profile.history[i-1].b
		me.db.profile.history[i].a = me.db.profile.history[i-1].a
	end
	local r, g, b, a = me:Get_RGBA()
	me.db.profile.history[1].r = r
	me.db.profile.history[1].g = g
	me.db.profile.history[1].b = b
	me.db.profile.history[1].a = a
end


-- Toggle what to show on the CPA frame
function me:Toggle_Visiblity(blockID)
	if (blockID == 1) then
		me.db.profile.showHSB = not me.db.profile.showHSB
	elseif (blockID == 2) then
		me.db.profile.showFavorites = not me.db.profile.showFavorites
	elseif (blockID == 3) then
		me.db.profile.showHistory = not me.db.profile.showHistory
	elseif (blockID == 4) then
		me.db.profile.showSwatches = not me.db.profile.showSwatches
	elseif (blockID == 5) then
		me.db.profile.showLabels = not me.db.profile.showLabels
		me:Update_Labels()
	end
	me:Update_Dialog()
end


-- Clear Favorites, after confirmation
function me:Clear_Favorites(isConfirmed)
	if (not isConfirmed) then
		StaticPopup_Show("CPA_CONFIRM_CLEAR_FAVORITES")
		return
	end
	local i = 0
	for i = 1, 20 do
		me.db.profile.favorite[i].r = 0.0
		me.db.profile.favorite[i].g = 0.0
		me.db.profile.favorite[i].b = 0.0
		me.db.profile.favorite[i].a = 1.0
	end
	me:Initialize_Favorites()
end


-- Clear History, after confirmation
function me:Clear_History(isConfirmed)
	if (not isConfirmed) then
		StaticPopup_Show("CPA_CONFIRM_CLEAR_HISTORY")
		return
	end
	local i = 0
	for i = 1, 20 do
		me.db.profile.history[i].r = 0.0
		me.db.profile.history[i].g = 0.0
		me.db.profile.history[i].b = 0.0
		me.db.profile.history[i].a = 1.0
	end
	me:Initialize_History()
end


-- Dev Testing
function me:Show_TestCPA(isDebug)
	ColorPickerFrame.func = nil
	ColorPickerFrame.opacityFunc = nil
	ColorPickerFrame.cancelFunc = nil
	ColorPickerFrame.previousValues = { 1.0, 1.0, 1.0, 1.0 }
	ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	ColorPickerFrame:SetClampedToScreen(true)
	ColorPickerFrame.hasOpacity = true
	ColorPickerFrame.opacity = 0.0	-- Alpha is flipped, 1.0 - alpha = opacity, it's weird
	ColorPickerFrame:SetColorRGB(1.0, 1.0, 1.0)
	if (isDebug) then	-- Debugging...
		ColorPickerFrame.func = function()
				print("ColorPicker . func")
			end
		ColorPickerFrame.opacityFunc = function()
				print("ColorPicker . opacityFunc")
			end
		ColorPickerFrame.cancelFunc = function()
				print("ColorPicker . cancelFunc")
			end
		ColorPickerFrame:SetScale(1)
	else
		ColorPickerFrame:SetScale(1)
		ColorPickerFrame.func = function() return end	-- do nothing
	end
	if (ColorPickerFrame:IsVisible()) then
		ColorPickerFrame:Hide()
	end
	ColorPickerFrame:Show()
end


-- Show the Configuration
function me:Helper_ShowConfig()
	local myTitle = me:GetAddonInfo("Title")
	InterfaceAddOnsList_Update()	-- If the Blizzard Options Frame hasn't been Opened yet, OpenToCategory will fail, so we force a refresh first
	InterfaceOptionsFrame_OpenToCategory(L["General   |c00000000CPA"])	-- By selecting a SubCategory first, the Options Tree will be open when we select the main Category
	InterfaceOptionsFrame_OpenToCategory(myTitle)	-- Select the main category (which is setup as an About frame)
end










--[[ ==========================================================================
		Converters
========================================================================== ]]--

--[[	Convert RGB to HSB	---------------------------------------------------
	Inputs:
		r = Red [0, 1]
		g = Green [0, 1]
		b = Blue [0, 1]
	Outputs:
		H = Hue [0, 360]
		S = Saturation [0, 1]
		B = Brightness [0, 1]
]]--
function me:Convert_RGB_HSB(r, g, b)
	local colorMax = max(max(r, g), b)
	local colorMin = min(min(r, g), b)
	local delta = colorMax - colorMin
	local H, S, B = 0.0, 0.0, 0.0
	
	-- WoW's LUA doesn't handle floating point numbers very well (Somehow 1.000000 != 1.000000   WTF?)
	-- So we do this weird conversion of, Number to String back to Number, to make the IF..THEN work correctly!
	colorMax = tonumber(format("%f", colorMax))
	r = tonumber(format("%f", r))
	g = tonumber(format("%f", g))
	b = tonumber(format("%f", b))
	
	if (delta > 0) then
		if (colorMax == r) then
			H = 60 * (((g - b) / delta) % 6)
		elseif (colorMax == g) then
			H = 60 * (((b - r) / delta) + 2)
		elseif (colorMax == b) then
			H = 60 * (((r - g) / delta) + 4)
		end
		
		if (colorMax > 0) then
			S = delta / colorMax
		else
			S = 0
		end
		
		B = colorMax
	
	else
		H = 0
		S = 0
		B = colorMax
	end
	
	if (H < 0) then
		H = H + 360
	end
	
	return H, S, B
end


--[[	Convert HSB to RGB	---------------------------------------------------
	Inputs:
		h = Hue [0, 360]
		s = Saturation [0, 1]
		b = Brightness [0, 1]
	Outputs:
		R = Red [0,1]
		G = Green [0,1]
		B = Blue [0,1]
]]--
function me:Convert_HSB_RGB(h, s, b)
	local chroma = b * s
	local prime = (h / 60) % 6
	local X = chroma * (1 - abs((prime % 2) - 1))
	local M = b - chroma
	local R, G, B = 0, 0, 0

	if (0 <= prime) and (prime < 1) then
		R = chroma
		G = X
		B = 0
	elseif (1 <= prime) and (prime < 2) then
		R = X
		G = chroma
		B = 0
	elseif (2 <= prime) and (prime < 3) then
		R = 0
		G = chroma
		B = X
	elseif (3 <= prime) and (prime < 4) then
		R = 0
		G = X
		B = chroma
	elseif (4 <= prime) and (prime < 5) then
		R = X
		G = 0
		B = chroma
	elseif (5 <= prime) and (prime < 6) then
		R = chroma
		G = 0
		B = X
	else
		R = 0
		G = 0
		B = 0
	end
	
	R = R + M
	G = G + M
	B =  B + M
	
	return R, G, B
end










--[[ ==========================================================================
		Slash Command
========================================================================== ]]--
SlashCmdList["COLORPICKERADVANCED"] = function(command)
	local cmd, arg, rest = strsplit(" ", command, 3)
	if (cmd) and (cmd ~= "") then
		if (cmd == L["clear"]) then
			if (arg) then
				if (arg == L["favorites"]) then
					me:Clear_Favorites(true)
				elseif (arg == L["history"]) then
					me:Clear_History(true)
				else
					me:print(format(L["Invalid Array to Clear \"%s\""], arg))
					return
				end
			else
				me:print(format(L["Clear What? [%s/%s]"], L["favorites"], L["history"]))
			end
		elseif (cmd == L["config"]) then
			me:Helper_ShowConfig()
		elseif (cmd == L["debug"]) then
			me:Show_TestCPA(true)
		elseif (cmd == L["rgb"]) then
			local _, r, g, b, _ = strsplit(" ", command, 5)
			if (r) and (g) and (b) then
				local H, S, B = me:Convert_RGB_HSB(r, g, b)
				me:print(format(L["Input: R=%f [%d]    G=%f [%d]    B=%f [%d]"], r, r*255, g,g*255, b,b*255))
				me:print(format(L["Output: H=%d    S=%f [%d%%]    L=%f [%d%%]"], H, S, S*100, B, B*100))
			else
				me:print(format(L["Error: Invalid RGB [%s]"], arg))
			end
		elseif (cmd == L["hsb"]) then
			local _, h, s, b, _ = strsplit(" ", command, 5)
			if (h) and (s) and (b) then
				local R, G, B = me:Convert_HSB_RGB(h, s, b)
				me:print(format(L["Input: H=%d    S=%f [%d%%]    L:%f [%d%%]"], h, s,s*100, b,b*100))
				me:print(format(L["Output: R=%f [%d]    G=%f [%d]    B=%f [%d]"], R,R*255, G,G*255, B,B*255))
			else
				me:print(format(L["Error: Invalid HSB [%s]"], arg))
			end
		elseif (cmd == L["help"]) then
			me:Slash_Help()
		else
			me:print(format(L["Invalid Command \"%s\""], cmd))
		end
	else
		me:Slash_Help()
	end
end
SLASH_COLORPICKERADVANCED1 = L["/cpa"]


function me:Slash_Help()
	me:print(format(L["Usage: |cffffff00%s |cffff8800[command]"], L["/cpa"]))
	me:print(L["Optional Commands:"])
	me:print(format(L["    |cffff8800%s|r : Open the Configuration frame."], L["config"]))
	me:print(format(L["    |cffff8800%s|r : Clear a Color Array."], L["clear"]))
	me:print(format(L["        |cffff8800%s|r : Favorites Color Array."], L["favorites"]))
	me:print(format(L["        |cffff8800%s|r : History Color Array."], L["history"]))
	me:print(format(L["    |cffff8800%s|r : Show usage and command list."], L["help"]))
	--[[
	me:print(L["Dev_Debug Commands:"])
	me:print(format(L["    |cffff8800%s|r : Output HSB from RGB."], L["rgb <r, g, b>"]))
	me:print(format(L["    |cffff8800%s|r : Output RGB from HSB."], L["hsb <h, s, b>"]))
	me:print(format(L["    |cffff8800%s|r : Open frame in Debug mode."], L["debug"]))
	]]--
end










