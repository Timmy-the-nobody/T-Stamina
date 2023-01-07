local tSprintingChars = {}
local tRecoveringChars = {}

local fNextSprintTick = 0
local iSprintPing = math.max((TStamina.SprintPing or 1 ), 1)

local fNextRecoverTick = 0
local iSprintCost = NanosMath.Round((TStamina.SprintCost or 1), 1, 100)

local iRecoverAmount = NanosMath.Round((TStamina.RecoverAmount or 1), 1, 100)
local iRecoverPing = math.max((TStamina.RecoverPing or 1), 1)

--[[ Character Spawn ]]--
Character.Subscribe("Spawn", function(eChar)
    eChar:SetStamina(100)
end)

--[[ Character GaitModeChanged ]]--
local function onGaitModeChanged(eChar, iOldState, iNewState)
    if (iNewState == GaitMode.Sprinting) then
        tSprintingChars[eChar] = true
        tRecoveringChars[eChar] = nil

        if (eChar:GetVelocity():Size() > 100) then
            eChar:AddStamina(-iSprintCost)
        end
        return
    end

    if (iOldState == GaitMode.Sprinting) then
        tRecoveringChars[eChar] = true
        tSprintingChars[eChar] = nil
    end
end

Character.Subscribe("GaitModeChanged", onGaitModeChanged)

--[[ Character StanceModeChanged ]]--
if TStamina.CrouchCost or TStamina.ProneCost then
    local iCrouchCost = TStamina.CrouchCost and NanosMath.Round((TStamina.CrouchCost or 0), 0, 100) or false
    local iProneCost = TStamina.ProneCost and NanosMath.Round((TStamina.ProneCost or 0), 0, 100) or false

    local function onStanceModeChanged(eChar, iOld, iNew)
        if iCrouchCost then
            if (iOld == StanceMode.Crouching) or (iNew == StanceMode.Crouching) then
                eChar:AddStamina(-iCrouchCost)
                tRecoveringChars[eChar] = true
                return
            end
        end

        if iProneCost then
            if (iOld == StanceMode.Proning) or (iNew == StanceMode.Proning) then
                eChar:AddStamina(-iProneCost)
                tRecoveringChars[eChar] = true
            end
        end
    end

    Character.Subscribe("StanceModeChanged", onStanceModeChanged)
end

--[[ Character FallingModeChanged ]]--
if (TStamina.JumpCost > 0) then
    local iJumpCost = NanosMath.Round((TStamina.JumpCost or 0), 0, 100)

    local function onFallingModeChanged(eChar, _, iNew)
        if (iNew ~= FallingMode.Jumping) then
            return
        end

        if not eChar:GetFlyingMode() and (eChar:GetJumpZVelocity() ~= TStamina.ExhaustJumpPower) then
            eChar:AddStamina(-iJumpCost)
        end
    end

    Character.Subscribe("FallingModeChanged", onFallingModeChanged)
end

--[[ Character Punch ]]--
if TStamina.PunchCost and (TStamina.PunchCost > 0) then
    Character.Subscribe("Punch", function(eChar)
        if eChar:GetCanPunch() then
            eChar:AddStamina(-TStamina.PunchCost)
        end
    end)
end

--[[ Server Tick ]]--
local function onTick()
    local iTime = os.time()

    -- Sprinting characters
    if (iTime >= fNextSprintTick) then
        fNextSprintTick = (iTime + iSprintPing)

        for eChar, _ in pairs(tSprintingChars) do
            if eChar:IsValid() then
                eChar:AddStamina(-iSprintCost)
            else
                tSprintingChars[eChar] = nil
            end
        end
    end

    -- Recovering characters
    if (iTime > fNextRecoverTick) then
        fNextRecoverTick = (iTime + iRecoverPing)

        for eChar, _ in pairs(tRecoveringChars) do
            if eChar:IsValid() then
                eChar:AddStamina(iRecoverAmount)

                if (eChar:GetStamina() == 100) then
                    tRecoveringChars[eChar] = nil
                end
            else
                tRecoveringChars[eChar] = nil
            end
        end
    end
end

Server.Subscribe("Tick", onTick)