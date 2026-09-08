--[[ ==========================================================================
	© Feyawen Ariana 2011-2015
		If you use my code, please give me credit.
========================================================================== ]]--
local myName, me = ...
local L = me.L

me.Options = {}
local testColor = { r = 0.5, g = 0.75, b = 1.0, a = 1.0 }





local options = {
	type = "group",
	args = {
		about = {
			order = 0,	type = "group",	name = L["About"],
			args = {
				aboutheader1 = {	order = 1,	type = "header",	name = "",	},
				aboutdesc1 = {	order = 2,	type = "description",	name = "|cff0088ff"..me:GetAddonInfo("Title"),	fontSize = "large",	width = "full",	},
				aboutdesc2 = {	order = 3,	type = "description",	name  = "\n|cffc0c0c0"..L["Version"].."|cff606060: |cffffff00"..me:GetAddonInfo("Version").."|r\n|cffc0c0c0"..L["Author"].."|cff606060: |cffffff00"..me:GetAddonInfo("Author").."|r\n",	fontSize = "medium",	width = "full",	},
				aboutdesc3 = {	order = 4,	type = "description",	name = "|cffa0a0a0    "..me:GetAddonInfo("Notes").."\n",	fontSize = "small",	width = "full",	},
				info1 = { order = 5, type = "description", fontSize = "small", width = "full",
					name = L["\n|cff0088ffSliders|r:\n     Mouse-Click & Drag to set value.\n     Mouse-Wheel Up & Down to step value (hold Shift for large steps)."], },
				info2 = { order = 6, type = "description", fontSize = "small", width = "full",
					name = L["\n|cff0088ffOriginal Color|r:\n     Left-Click to reset to Original color."], },
				info3 = { order = 7, type = "description", fontSize = "small", width = "full",
					name = L["\n|cff0088ffFavorites|r:\n     Left-Click to Get color.\n     Right-Click to Set color."], },
				info4 = { order = 8, type = "description", fontSize = "small", width = "full",
					name = L["\n|cff0088ffHistory|r:\n     Left-Click to Get color."], },
				info5 = { order = 9, type = "description", fontSize = "small", width = "full",
					name = L["\n|cff0088ffSwatches|r:\n     Left-Click to Get color."], },
			},
		},
		
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				header100 = {
					order = 1,
					type = "header",
					name = L["Section Block Visibility"],
				},
				hsb = {
					order = 2,
					type = "toggle",
					name = L["Show HSB"],
					desc = L["Show the HSB (Hue, Saturation, Brightness) color selection sliders."],
					width = "double",
					get = function() return me.db.profile.showHSB end,
					set = function(self, v)
							me.db.profile.showHSB = v
							me:Update_Dialog()
						end,
				},
				favorites = {
					order = 3,
					type = "toggle",
					name = L["Show Favorites"],
					desc = L["Show player's Favorite 20 set colors."],
					width = "double",
					get = function() return me.db.profile.showFavorites end,
					set = function(self, v)
							me.db.profile.showFavorites = v
							me:Update_Dialog()
						end,
				},
				history = {
					order = 4,
					type = "toggle",
					name = L["Show History"],
					desc = L["Show a History of the last 20 selected colors."],
					width = "double",
					get = function() return me.db.profile.showHistory end,
					set = function(self, v)
							me.db.profile.showHistory = v
							me:Update_Dialog()
						end,
				},
				swatches = {
					order = 5,
					type = "toggle",
					name = L["Show Swatches"],
					desc = L["Show the Class, Faction, Quality, and Pure color swatches."],
					width = "double",
					get = function() return me.db.profile.showSwatches end,
					set = function(self, v)
							me.db.profile.showSwatches = v
							me:Update_Dialog()
						end,
				},
				labels = {
					order = 6,
					type = "toggle",
					name = L["Show Labels"],
					desc = L["Show the Text on the Color Swatches."],
					width = "double",
					get = function() return me.db.profile.showLabels end,
					set = function(self, v)
							me.db.profile.showLabels = v
							me:Update_Labels()
						end,
				},
				spacer101 = {
					order = 7,
					type = "description",
					name = "\n",
				},
				header101 = {
					order = 8,
					type = "header",
					name = L["Advanced Users"],
				},
				tooltips = {
					order = 9,
					type = "toggle",
					name = L["Show Tooltips"],
					desc = L["Show Tooltips on the Favorites and History swatches."],
					width = "double",
					get = function() return me.db.profile.showTooltips end,
					set = function(self, v)
							me.db.profile.showTooltips = v
						end,
				},
				spacer102 = {
					order = 10,
					type = "description",
					name = "\n",
				},
				header102 = {
					order = 11,
					type = "header",
					name = L["Clear Stored Data"],
				},
				clearfavorites = {
					order = 12,
					type = "execute",
					name = L["Clear Favorites"],
					desc = L["Clear all Favorite Colors (Set all 20 to Black)."],
					--width = "double",
					func = function() me:Clear_Favorites() end,
				},
				clearhistory = {
					order = 13,
					type = "execute",
					name = L["Clear History"],
					desc = L["Clear all History Colors (Set all 20 to Black)."],
					--width = "double",
					func = function() me:Clear_History() end,
				},
				spacer103 = {
					order = 14,
					type = "description",
					name = "\n",
				},
				header103 = {
					order = 15,
					type = "header",
					name = L["Color Picker Advanced Frame"],
				},
				--[[ DEV: We don't need this anymore, since we put in the "test color"
				showtestframe = {
					order = 16,
					type = "execute",
					name = L["Show CPA Frame"],
					desc = L["Show the Color Picker Advanced frame."],
					--width = "double",
					func = function()
						me:Show_TestCPA(false)
						end,
				},
				]]--
				testcolor = {
					order = 16,
					type = "color",
					name = L["Test Color Picker Advanced"],
					desc = L["Test the Color Picker Advanced frame."],
					hasAlpha = true,
					width = "double",
					get = function() return testColor.r, testColor.g, testColor.b, testColor.a end,
					set = function(info, r, g, b, a)
							testColor.r = r
							testColor.g = g
							testColor.b = b
							testColor.a = a
						end,
				},
			},
		},
	},
}


function me.Options:Initialize()
	-- Add a Profile section to the "options" table (Before registering options table)
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(me.db)
	
	-- Register Options Table with Ace Config library
	LibStub("AceConfig-3.0"):RegisterOptionsTable(myName, options)
	
	-- Options UI
	local myTitle = me:GetAddonInfo("Title")
	local ACD = LibStub("AceConfigDialog-3.0")
	ACD:AddToBlizOptions(myName, myTitle, nil, "about")
	ACD:AddToBlizOptions(myName, L["General   |c00000000CPA"], myTitle, "general")
	-- Does this really need profiles??  I don't think so.
	--ACD:AddToBlizOptions(myName, L["Profiles"], myTitle, "profile")	-- Adds a Profiles sub-category
end










