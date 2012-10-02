
-- Create frames for the Glow for Enemy/Player, plus 1 more for the Tooltip
local frames = {}
for i=1,7 do
	frames[i] = CreateFrame("Frame", "PetBattleQuality_Glow"..i, UIParent)
	frames[i].Glow = frames[i]:CreateTexture("Glow"..i, "ARTWORK")
	frames[i].Glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border", false)
	frames[i].Glow:SetBlendMode("ADD")
end


hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
	-- There must be a petOwner and a petIndex
	if not (self.petOwner and self.petIndex) then return end

	-- Set which Glow frame this will use (Enemy Frames are +3 / Tooltip is 7)
	local is_tooltip = self:GetName() == "PetBattlePrimaryUnitTooltip"
	local is_enemy = self.petOwner == LE_BATTLE_PET_ENEMY and 3 or 0
	local i = is_tooltip and 7 or (self.petIndex + is_enemy)
	local f = frames[i]

	-- Position the Glow, tricky to set it over Icon, but under Border
	f:SetParent(self)
	f:ClearAllPoints()
	f:SetWidth(self.Icon:GetWidth() * 1.7)
	f:SetHeight(self.Icon:GetHeight() * 1.7)
	f:SetPoint("CENTER", self.Icon, "CENTER", 0, 0)

	-- Set the texture for the Glow
	f.Glow:SetParent(self)
	f.Glow:ClearAllPoints()
	f.Glow:SetAllPoints(f)
	f.Glow:SetDrawLayer("ARTWORK", 1)

	-- Set the color for the Glow
	local qual = C_PetBattles.GetBreedQuality(self.petOwner, self.petIndex) - 1
	local r, g, b, hex = GetItemQualityColor(qual)
	f.Glow:SetVertexColor(r, g, b)

	-- Color the Name with the Quality color
	if self.Name then
		local sPetName = C_PetBattles.GetName(self.petOwner, self.petIndex)
		if (sPetName) then self.Name:SetText("|c"..hex..sPetName.."|r") end
	end

	-- Color the non-active Health Bars with the Quality color
	if self.ActualHealthBar and not is_tooltip and self.petIndex ~= 1 then
		if self.petIndex ~= C_PetBattles.GetActivePet(self.petOwner) then
			self.ActualHealthBar:SetVertexColor(r, g, b)
		else
			self.ActualHealthBar:SetVertexColor(0, 1, 0)
		end
	end
end)
