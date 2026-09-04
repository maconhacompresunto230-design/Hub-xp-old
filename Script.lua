local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local QUANTO_DESCER = 20

local function eContadorParaMover(obj)
    if not obj or not obj.Parent or not obj:IsA("GuiObject") then
        return false
    end

    local texto = ""
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        texto = obj.Text
    end

    -- Move o texto "Survival XP"
    if texto:lower() == "survival xp" then
        return true
    end

    -- Move o número abaixo do Survival XP
    if texto:match("^%d+$") and obj.Parent then
        local textoPai = ""
        if obj.Parent:IsA("TextLabel") or obj.Parent:IsA("TextButton") then
            textoPai = obj.Parent.Text:lower()
        end

        if textoPai == "survival xp" then
            return true
        end

        if obj.Parent.Parent and obj.Parent.Parent:IsA("TextLabel") then
            if obj.Parent.Parent.Text:lower() == "survival xp" then
                return true
            end
        end
    end

    -- Move QUALQUER tempo no formato 0m 0s, 9m 59s, 10m 0s etc.
    if texto:match("^%d+m %d+s$") then
        return true
    end

    return false
end

local function moverContador(obj)
    if obj:GetAttribute("JaMovido") then
        return
    end

    obj:SetAttribute("JaMovido", true)

    local ok, pos = pcall(function()
        return obj.Position
    end)

    if not ok or not pos then
        return
    end

    pcall(function()
        obj.Position = UDim2.new(
            pos.X.Scale,
            pos.X.Offset,
            pos.Y.Scale,
            pos.Y.Offset + QUANTO_DESCER
        )
    end)
end

local function procurarContadores()
    pcall(function()
        if not PlayerGui or not PlayerGui.Parent then
            return
        end

        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Parent then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if eContadorParaMover(obj) then
                        moverContador(obj)
                    end
                end
            end
        end
    end)
end

task.wait(1)
procurarContadores()

PlayerGui.ChildAdded:Connect(function()
    task.wait(0.2)
    procurarContadores()
end)

PlayerGui.ChildRemoved:Connect(function()
    task.wait(0.3)
    procurarContadores()
end)
