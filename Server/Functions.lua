local iExhaustJumpPower = math.max((TStamina.ExhaustJumpPower or 0), 0)
local iDefaultJumpPower = math.max((TStamina.DefaultJumpPower or 450), 0)

-- Internal function to update the states of the character based on their stamina
local function characterStaminaUpdate(eChar, iStamina)
    -- Sprint
    if TStamina.SprintCost then
        if (iStamina <= TStamina.SprintCost) then
            eChar:SetCanSprint(false)
        else
            if not eChar:GetCanSprint() then
                eChar:SetCanSprint(true)
            end
        end
    end

    -- Jump
    if TStamina.JumpCost then
        if (iStamina <= TStamina.JumpCost) then
            eChar:SetJumpZVelocity(iExhaustJumpPower)
        else
            if (eChar:GetJumpZVelocity() ~= iDefaultJumpPower) then
                eChar:SetJumpZVelocity(iDefaultJumpPower)
            end
        end
    end

    -- Punch
    if TStamina.PunchCost then
        if (iStamina <= TStamina.PunchCost) then
            eChar:SetCanPunch(false)
        else
            if not eChar:GetCanPunch() then
                eChar:SetCanPunch(true)
            end
        end
    end

    -- Crouch
    if TStamina.CrouchCost then
        if (iStamina < TStamina.CrouchCost) then
            eChar:SetCanCrouch(false)
        else
            if not eChar:GetCanCrouch() then
                eChar:SetCanCrouch(true)
            end
        end
    end
end

---`🔹 Server`<br>
---Sets the stamina of the character, clamped between 0 and 100
---@param iStamina integer @The stamina to set
---@return boolean @Returns true if the stamina was changed, false if not
---
function Character:SetStamina(iStamina)
    if (type(iStamina) ~= "number") then
        return false
    end

    iStamina = NanosMath.Clamp(math.floor(iStamina), 0, 100)

    if (iStamina == self:GetStamina()) then
        return false
    end

    self:SetValue("Stamina", iStamina, false)

    characterStaminaUpdate(self, iStamina)

    local pPlayer = self:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        Events.CallRemote("StaminaChanged", pPlayer, iStamina)
    end

    return true
end

---`🔹 Server`<br>
---Adds stamina to the character
---Can be used to subtract stamina by passing a negative number
---@param iStamina number @The amount of stamina to add/remove
---@return nil
---
function Character:AddStamina(iStamina)
    if (type(iStamina) ~= "number") then return end
    self:SetStamina(self:GetStamina() + iStamina)
end