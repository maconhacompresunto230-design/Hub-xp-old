local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ⚙️ Aumenta aqui se quiser ainda mais pra baixo
local QUANTO_DESCER = 20

local function ehOContadorCerto(obj)
    if not obj or not obj.Parent then return false end
    if not obj:IsA("GuiObject") then return false end

    local nome = obj.Name:lower()
    local texto = ""
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        texto = obj.Text:lower()
    end

    -- SÓ PEGA ISSO AQUI:
    return
        nome:find("survival") or
        nome:find("timer") or
        texto == "survival xp" or
        texto:find("^%d+m %d+s$") or
        (texto:match("^%d+$") and obj.Parent and obj.Parent:FindFirstChildWhichIsA("GuiObject") and (
            obj.Parent.Name:lower():find("survival") or
            (obj.Parent:FindFirstChildWhichIsA("GuiObject") and obj.Parent:FindFirstChildWhichIsA("GuiObject").Text:lower() == "survival xp")
        ))
end

local function mover(obj)
    if not obj or not obj.Parent then return end
    if obj:GetAttribute("ContadorXPMovido") then return end
    obj:SetAttribute("ContadorXPMovido", true)

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
                    if ehOContadorCerto(obj) then
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
