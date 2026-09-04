local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local QUANTO_DESCER = 15

local function eOQueMover(obj)
    if not obj or not obj.Parent or not obj:IsA("GuiObject") then return false end
    local texto = ""
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        texto = obj.Text:lower()
    end

    return
        texto == "survival xp" or
        texto:match("^%d+m %d+s$") or
        (texto:match("^%d+$") and obj.Parent and (
            obj.Parent.Name:lower():find("survival") or
            (obj.Parent:FindFirstChildWhichIsA("GuiObject") and obj.Parent:FindFirstChildWhichIsA("GuiObject").Text:lower() == "survival xp")
        ))
end

local function mover(obj)
    if obj:GetAttribute("JaMovido") then return end
    obj:SetAttribute("JaMovido", true)

    local ok, pos = pcall(function() return obj.Position end)
    if not ok or not pos then return end

    pcall(function()
        obj.Position = UDim2.new(
            pos.X.Scale,
            pos.X.Offset,
            pos.Y.Scale,
            pos.Y.Offset + QUANTO_DESCER
        )
    end)
end

local function procurar()
    pcall(function()
        if not PlayerGui or not PlayerGui.Parent then return end
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Parent then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if eOQueMover(obj) then
                        mover(obj)
                    end
                end
            end
        end
    end)
end

task.wait(1)
procurar()

PlayerGui.ChildAdded:Connect(function()
    task.wait(0.2)
    procurar()
end)

PlayerGui.ChildRemoved:Connect(function()
    task.wait(0.3)
    procurar()
end)
