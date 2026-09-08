
function NPCCommand_OnEnter(self,tipType,title,text,command)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
	GameTooltip:AddLine(title,0,0.7,0.7,1);
	if (tipType == 1) then
		GameTooltip:AddLine("Summon a bot, this bot is a "..text,1,0.8,0,1);
		-- GameTooltip:AddLine("Right click the bot out of combat to open its operation menu and set its combat role and equipment.",0,1,0,1);
		-- GameTooltip:AddLine("You need to select yourself before using this command.",1,0,0,1);
	elseif (tipType == 2) then
		GameTooltip:AddLine(text,1,0.8,0,1);
		GameTooltip:AddLine("You need to select yourself or an NPC bot before using this command.",1,0,0,1);
	end
	-- GameTooltip:AddLine("This command cannot be used in combat.",1,1,1,1);
	-- GameTooltip:AddLine(" ",1,1,1,1);
	if (command ~= nil) then
		GameTooltip:AddDoubleLine("Execute Command:",command,0,0.85,0.85,0,0.85,0.85);
	end
	GameTooltip:Show();
end
