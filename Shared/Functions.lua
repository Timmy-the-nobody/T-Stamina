---`🔸 Client`<br>`🔹 Server`<br>
---Gets the stamina of the character (integer between 0 and 100)
---@return integer @The stamina of the character
---
function Character:GetStamina()
    return self:GetValue("Stamina", 100)
end