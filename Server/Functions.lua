local iExhaustJumpPower = math.max((TStamina.ExhaustJumpPower or 0), 0)
local iDefaultJumpPower = math.max((TStamina.DefaultJumpPower or 450), 0)

--[[ Character:SetStamina ]]--
function Character:SetStamina(iStamina)
    if type(iStamina) ~= "number" then return end

    iStamina = math.floor(iStamina)

    if (iStamina == self:GetStamina()) then return end

    self:SetValue("Stamina", iStamina)

    -- Sprint
    if TStamina.SprintCost then
        if (iStamina <= TStamina.SprintCost) then
            self:SetCanSprint(false)
        else
            if not self:GetCanSprint() then
                self:SetCanSprint(true)
            end
        end
    end

    -- Jump
    if TStamina.JumpCost then
        if (iStamina <= TStamina.JumpCost) then
            self:SetJumpZVelocity(iExhaustJumpPower)
        else
            if (self:GetJumpZVelocity() ~= iDefaultJumpPower) then
                self:SetJumpZVelocity(iDefaultJumpPower)
            end
        end
    end

    -- Punch
    if TStamina.PunchCost then
        if (iStamina <= TStamina.PunchCost) then
            self:SetCanPunch(false)
        else
            if not self:GetCanPunch() then
                self:SetCanPunch(true)
            end
        end
    end

    -- Crouch
    if TStamina.CrouchCost then
        if (iStamina < TStamina.CrouchCost) then
            self:SetCanCrouch(false)
        else
            if not self:GetCanCrouch() then
                self:SetCanCrouch(true)
            end
        end
    end

    local pPlayer = self:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        Events.CallRemote("StaminaChanged", pPlayer, iStamina)
    end
end

--[[ Character:AddStamina ]]--
function Character:AddStamina(iStamina)
    if (type(iStamina) ~= "number") then return end

    local iCur = self:GetStamina()
    local iNew = NanosMath.Clamp(math.floor(iCur + iStamina), 0, 100)

    if (iCur ~= iNew) then
        self:SetStamina(iNew)
    end
end