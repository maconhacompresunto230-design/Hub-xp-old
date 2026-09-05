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
        texto = obj.Text:lower()
    end

    -- Pega o texto "Survival XP"
    if texto == "survival xp" then
        return true
    end

    -- Pega QUALQUER número (inteiro ou decimal) que esteja no mesmo grupo/filho do Survival XP
    if texto:match("^%d+$") or texto:match("^%d+%.%d+$") then
        local pai = obj.Parent
        while pai do
            for _, filho in ipairs(pai:GetDescendants()) do
                if filho:IsA("TextLabel") or filho:IsA("TextButton") then
                    if filho.Text:lower() == "survival xp" then
                        return true
                    end
                end
            end
            pai = pai.Parent
        end
    end

    -- Pega QUALQUER tempo no formato 0m 0s, 9m 59s, 10m 0s...
    if texto:match("^%d+m %d+s$") then
        return true
    end

    return false
end

local function moverContador(obj)
    -- REMOVI a trava de "já movido" para funcionar sempre que precisar
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

-- Roda várias vezes pra garantir que pega tudo, mesmo que carregue devagar
local loop = game:GetService("RunService").Heartbeat:Connect(function()
    procurarContadores()
end)

-- Reinicia tudo quando o personagem carrega de novo (nova partida)
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    procurarContadores()
end)

task.wait(1)
procurarContadores()
