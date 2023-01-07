if TStamina.HUD then
    TStamina._WebUI = WebUI("Stamina HUD", "file:///hud/index.html")
end

--[[ StaminaChanged ]]--
Events.SubscribeRemote("StaminaChanged", function(iStamina)
    local pPlayer = Client.GetLocalPlayer()
    if not pPlayer or not pPlayer:IsValid() then return end

    local eChar = pPlayer:GetControlledCharacter()
    if not eChar or not eChar:IsValid() then return end

    eChar:SetValue("Stamina", iStamina)

    if TStamina._WebUI then
        TStamina._WebUI:CallEvent("updateStamina", iStamina)
    end
end)