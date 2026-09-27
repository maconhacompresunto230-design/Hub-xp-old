local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local function lowerUI()
    pcall(function()
        local MainGUI = PlayerGui:FindFirstChild("MainGUI")
        if not MainGUI then return end

        local GameFrame = MainGUI:FindFirstChild("Game")
        if not GameFrame then return end

        -- Posição original do MM2: reta, centralizada, no topo
        local EarnedXP = GameFrame:FindFirstChild("EarnedXP")
        if EarnedXP then
            EarnedXP.Position = UDim2.new(0.5, 0, 0.04, 0)
            EarnedXP.AnchorPoint = Vector2.new(0.5, 0)
        end

        local Timer = GameFrame:FindFirstChild("Timer")
        if Timer then
            Timer.Position = UDim2.new(0.5, 0, 0.04, 0)
            Timer.AnchorPoint = Vector2.new(0.5, 0)
        end
    end)
end

lowerUI()

PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "MainGUI" then
        task.wait(0.5)
        lowerUI()
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        lowerUI()
    end
end)

print("✅ Posição original do MM2 restaurada!")
