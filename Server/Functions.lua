
local iExhaustJumpPower = math.max( ( TStamina.ExhaustJumpPower or 0 ), 0 )
local iDefaultJumpPower = math.max( ( TStamina.DefaultJumpPower or 450 ), 0 )

--[[

    Character:SetStamina

]]--

function Character:SetStamina( iStamina )
    if not iStamina or ( iStamina == self:GetStamina() ) then
        return
    end

    self:SetValue( "Stamina", iStamina )

    -- Sprint
    if TStamina.SprintCost then
        if ( iStamina <= TStamina.SprintCost ) then
            self:SetCanSprint( false )
        else
            if not self:GetCanSprint() then
                self:SetCanSprint( true )
            end
        end
    end

    -- Jump
    if TStamina.JumpCost then
        if ( iStamina <= TStamina.JumpCost ) then
            self:SetJumpZVelocity( iExhaustJumpPower )
        else
            if ( self:GetJumpZVelocity() ~= iDefaultJumpPower ) then
                self:SetJumpZVelocity( iDefaultJumpPower )
            end
        end
    end

    -- Punch
    if TStamina.PunchCost then
        if ( iStamina <= TStamina.PunchCost ) then
            self:SetCanPunch( false )
        else
            if not self:GetCanPunch() then
                self:SetCanPunch( true )
            end
        end
    end

    -- Crouch
    if TStamina.CrouchCost then
        if ( iStamina < TStamina.CrouchCost ) then
            self:SetCanCrouch( false )
        else
            if not self:GetCanCrouch() then
                self:SetCanCrouch( true )
            end
        end
    end

    local pPlayer = self:GetPlayer()
    if pPlayer and pPlayer:IsValid() then
        Events.CallRemote( "StaminaChanged", pPlayer, iStamina )
    end
end

--[[

    Character:AddStamina

]]--

function Character:AddStamina( iStamina )
    if not iStamina then
        return
    end

    local iCurrent = self:GetStamina()
    local iNew = NanosMath.Clamp( ( iCurrent + iStamina ), 0, 100 )

    if ( iCurrent ~= iNew ) then
        self:SetStamina( iNew )
    end
end