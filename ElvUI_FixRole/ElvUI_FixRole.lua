-- ElvUI does not register tanks as tanks in instances.
-- This is a small trick that forces ElvUI to check
-- the player's role as soon as combat begins.

local ElvUI = _G.ElvUI
if not ElvUI then return end

local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", function()
    ElvUI[1]:CheckRole()
end)