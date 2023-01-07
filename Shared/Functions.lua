--[[ Character:GetStamina ]]--
function Character:GetStamina()
    return self:GetValue("Stamina", 100)
end