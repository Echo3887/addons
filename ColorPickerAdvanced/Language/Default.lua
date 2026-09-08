--[[ ==========================================================================
	© Feyawen Ariana 2011-2015
		If you use my code, please give me credit.
========================================================================== ]]--
local _, me = ...


me.L = {}
local L = me.L
local function defaultFunc(L, key) return key end
setmetatable(L, {__index=defaultFunc})
