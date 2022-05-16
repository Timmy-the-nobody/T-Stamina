--[[

    T-Stamina : Config

]]--

TStamina.HUD = true                 -- Enable/disable the default HUD

TStamina.SprintCost = 4             -- Amount of stamina drained on sprint start, and on each sprint ping (Min: 1, Max: 100)
TStamina.SprintPing = 1             -- Time between sprint ping (in seconds)
TStamina.RecoverAmount = 5          -- Amount of stamina recovered each recover ping (Min: 1, Max: 100)
TStamina.RecoverPing = 4            -- Time between recover ping (in seconds)

TStamina.JumpCost = 10              -- Amount of stamina drained each time the character jump, false to disable (Min:0, Max: 100)
TStamina.CrouchCost = 5             -- Amount of stamina drained each time the character enter or exit crouch mode, false to disable (Min:0, Max: 100)
TStamina.ProneCost = 6              -- Amount of stamina drained each time the character enter or exit prone mode, false to disable (Min:0, Max: 100)
TStamina.PunchCost = 2              -- Amount of stamina drained each time the character throws a punch, false to disable (Min:0, Max: 100)

TStamina.ExhaustJumpPower = 0       -- Jump power when exhausted
TStamina.DefaultJumpPower = 450     -- Normal jump power (Default jump power is 450)