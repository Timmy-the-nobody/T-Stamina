local tSprintingChars = {}
local tRecoveringChars = {}

local fNextSprintTick = 0
local fNextRecoverTick = 0

local iGaitSprint = GaitMode.Sprinting

local iSprintCost = NanosMath.Round( ( TStamina.SprintCost or 1 ), 1, 100 )
local iSprintPing = math.max( ( TStamina.SprintPing or 1 ), 1 )
local iRecoverAmount = NanosMath.Round( ( TStamina.RecoverAmount or 1 ), 1, 100 )
local iRecoverPing = math.max( ( TStamina.RecoverPing or 1 ), 1 )

--[[

    Character : Spawn

]]--

Character.Subscribe( "Spawn", function( eChar )
    eChar:SetStamina( 100 )
end )

--[[

    onGaitModeChanged

]]--

local function onGaitModeChanged( eChar, iOldState, iNewState )
    if ( iNewState == iGaitSprint ) then
        tSprintingChars[ eChar ] = true
        tRecoveringChars[ eChar ] = nil

        eChar:AddStamina( -iSprintCost )
        return
    end

    if ( iOldState == iGaitSprint ) then
        tRecoveringChars[ eChar ] = true
        tSprintingChars[ eChar ] = nil
    end
end

Character.Subscribe( "GaitModeChanged", onGaitModeChanged )

--[[

    Character : StanceModeChanged

]]--

if TStamina.CrouchCost or TStamina.ProneCost then
    local iStanceCrouch = StanceMode.Crouching
    local iStanceProne = StanceMode.Proning

    local iCrouchCost = TStamina.CrouchCost and NanosMath.Round( ( TStamina.CrouchCost or 0 ), 0, 100 ) or false
    local iProneCost = TStamina.ProneCost and NanosMath.Round( ( TStamina.ProneCost or 0 ), 0, 100 ) or false

    local function onStanceModeChanged( eChar, iOldState, iNewState )
        if iCrouchCost then
            if ( iOldState == iStanceCrouch ) or ( iNewState == iStanceCrouch ) then
                eChar:AddStamina( -iCrouchCost )
                tRecoveringChars[ eChar ] = true
                return
            end
        end

        if iProneCost then
            if ( iOldState == iStanceProne ) or ( iNewState == iStanceProne ) then
                eChar:AddStamina( -iProneCost )
                tRecoveringChars[ eChar ] = true
            end
        end
    end

    Character.Subscribe( "StanceModeChanged", onStanceModeChanged )
end

--[[

    Character : FallingModeChanged

]]--

if ( TStamina.JumpCost > 0 ) then
    local iFallJump = FallingMode.Jumping
    local iJumpCost = NanosMath.Round( ( TStamina.JumpCost or 0 ), 0, 100 )
    local iExhaustJumpPower = TStamina.ExhaustJumpPower

    local function onFallingModeChanged( eChar, iOldState, iNewState )
        if ( iNewState ~= iFallJump ) then
            return
        end

        if not eChar:GetFlyingMode() and ( eChar:GetJumpZVelocity() ~= iExhaustJumpPower ) then
            eChar:AddStamina( -iJumpCost )
        end
    end

    Character.Subscribe( "FallingModeChanged", onFallingModeChanged )
end

--[[

    Character : Punch

]]--

if TStamina.PunchCost then
    local iPunchCost = TStamina.PunchCost

    Character.Subscribe( "Punch", function( eChar )
        if eChar:GetCanPunch() then
            eChar:AddStamina( -iPunchCost )
        end
    end )
end

--[[

    Server : Tick

]]--

local function onTick()
    local iTime = os.time()

    -- Sprinting characters
    if ( iTime >= fNextSprintTick ) then
        fNextSprintTick = ( iTime + iSprintPing )

        for eChar, _ in pairs( tSprintingChars ) do
            if eChar and eChar:IsValid() then
                eChar:AddStamina( -iSprintCost )
            else
                tSprintingChars[ eChar ] = nil
            end
        end
    end

    -- Recovering characters
    if ( iTime > fNextRecoverTick ) then
        fNextRecoverTick = ( iTime + iRecoverPing )

        for eChar, _ in pairs( tRecoveringChars ) do
            if eChar and eChar:IsValid() then
                eChar:AddStamina( iRecoverAmount )

                if ( eChar:GetStamina() == 100 ) then
                    tRecoveringChars[ eChar ] = nil
                end
            else
                tRecoveringChars[ eChar ] = nil
            end
        end
    end
end

Server.Subscribe( "Tick", onTick )