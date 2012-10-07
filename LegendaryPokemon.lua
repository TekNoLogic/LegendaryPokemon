
local textures = setmetatable({}, {
	__index = function(t,i)
		local f = CreateFrame("Frame", nil, i)
		f:SetWidth(i.Icon:GetWidth() * 1.7)
		f:SetHeight(i.Icon:GetHeight() * 1.7)
		f:SetPoint("CENTER", i.Icon)

		local tex = f:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints(f)
		tex:SetDrawLayer("ARTWORK", 1)
		tex:SetTexture("Interface\\Buttons\\UI-ActionButton-Border", false)
		tex:SetBlendMode("ADD")

		t[i] = tex
		return tex
	end
})


hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
	if not (self.petOwner and self.petIndex) then return end

	local is_tooltip = self == PetBattlePrimaryUnitTooltip
	local name = C_PetBattles.GetName(self.petOwner, self.petIndex)
	local qual = C_PetBattles.GetBreedQuality(self.petOwner, self.petIndex) - 1
	local r, g, b, hex = GetItemQualityColor(qual)

	textures[self]:SetVertexColor(r, g, b)
	if self.Name and name then self.Name:SetText("|c"..hex..name.."|r") end

	-- Color the non-active Health Bars with the Quality color
	if self.ActualHealthBar and not is_tooltip and self.petIndex ~= 1 then
		if self.petIndex ~= C_PetBattles.GetActivePet(self.petOwner) then
			self.ActualHealthBar:SetVertexColor(r, g, b)
		else
			self.ActualHealthBar:SetVertexColor(0, 1, 0)
		end
	end
end)
