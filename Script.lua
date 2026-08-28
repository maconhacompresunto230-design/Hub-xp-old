-- ==============================================
-- ⏱️ MOVER CONTADOR + BARRA DE XP PRA BAIXO
-- ✅ Só o tempo e a barra de XP
-- ✅ Não mexe em mais nada
-- ==============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ⚙️ AJUSTE AQUI — quanto mais alto, mais pra baixo desce
local QUANTO_DESCER = 10 -- 🔽 Mude aqui!

-- 📦 Função para mover
local function MoverElementos()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if not gui:IsA("ScreenGui") then continue end

        for _, obj in ipairs(gui:GetDescendants()) do
            if not obj:IsA("GuiObject") then continue end

            local nome = obj.Name:lower()
            local texto = ""
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    texto = obj.Text:lower()
                end
            end)

            -- 🔍 Só CONTADOR (tempo) e BARRA DE XP
            local eContadorOuXP = 
                nome:find("timer") or nome:find("time") or 
                nome:find("survival") or nome:find("xp") or
                nome:find("bar") or nome:find("progress") or
                texto:find("survival") or texto:find("xp") or
                texto:find("inocente") or texto:find("tempo")

            if eContadorOuXP then
                -- Salva posição original
                if not obj:GetAttribute("YOriginal") then
                    obj:SetAttribute("YOriginal", obj.Position.Y.Offset)
                end

                -- Move pra baixo
                local yOrig = obj:GetAttribute("YOriginal")
                obj.Position = UDim2.new(
                    obj.Position.X.Scale, obj.Position.X.Offset,
                    obj.Position.Y.Scale, yOrig + QUANTO_DESCER
                )
            end
        end
    end
end

-- 🚀 Carrega
task.wait(1)
MoverElementos()

-- 🔄 Atualiza se recarregar
PlayerGui.DescendantAdded:Connect(function()
    task.wait(0.3)
    MoverElementos()
end)

print("✅ Contador e XP movidos +" .. QUANTO_DESCER .. "px pra baixo!")

