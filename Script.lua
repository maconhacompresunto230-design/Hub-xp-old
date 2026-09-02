local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local QUANTO_DESCER = 10

local function ehContador(obj)
    if not obj or not obj.Parent then return false end
    local nome = obj.Name:lower()
    local texto = ""
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        texto = obj.Text:lower()
    end
    return
        nome:find("timer") or
        nome:find("survival") or
        texto:find("survival") or
        texto:find("inocente") or
        texto:find("tempo")
end

local function ehXP(obj)
    if not obj or not obj.Parent then return false end
    local nome = obj.Name:lower()
    return
        nome == "xp" or
        nome:find("xpbar") or
        nome:find("xp_bar") or
        nome:find("experience") or
        nome:find("progress")
end

local function mover(obj)
    if not obj or not obj.Parent or not obj:IsA("GuiObject") then return end
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
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Parent then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if obj and obj.Parent and obj:IsA("GuiObject") then
                        if ehContador(obj) or ehXP(obj) then
                            mover(obj)
                        end
                    end
                end
            end
        end
    end)
end

task.wait(1)
procurar()

PlayerGui.ChildAdded:Connect(function(child)
    task.wait(0.2)
    procurar()
end)
