if not TStamina.HUD then
    return
end

local wHUD = WebUI( "Main HUD", "file:///hud/index.html" )

--[[

    StaminaChanged

]]--

Events.SubscribeRemote( "StaminaChanged", function( iStamina )
    wHUD:CallEvent( "updateStamina", iStamina )
end )