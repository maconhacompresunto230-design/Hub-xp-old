-- ==============================================
-- ⏱️ MOVER CONTADOR + BARRA DE XP PRA BAIXO
-- ✅ VERSÃO OTIMIZADA
-- ✅ NÃO FICA VARRRENDO A GUI INTEIRA CONSTANTEMENTE
-- ==============================================

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ⚙️ quanto mais alto, mais pra baixo
local QUANTO_DESCER = 10

-- nomes/textos que podem identificar o contador
local function ehContador(obj)
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

-- nomes que podem identificar a barra de xp
local function ehXP(obj)
    local nome = obj.Name:lower()

    return
        nome == "xp" or
        nome:find("xpbar") or
        nome:find("xp_bar") or
        nome:find("experience") or
        nome:find("progress")
end

local function mover(obj)
    if not obj:IsA("GuiObject") then
        return
    end

    -- evita mover o mesmo objeto novamente
    if obj:GetAttribute("ContadorXPMovido") then
        return
    end

    obj:SetAttribute("ContadorXPMovido", true)

    local pos = obj.Position

    obj.Position = UDim2.new(
        pos.X.Scale,
        pos.X.Offset,
        pos.Y.Scale,
        pos.Y.Offset + QUANTO_DESCER
    )
end

local function procurar()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then

            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("GuiObject") then

                    if ehContador(obj) or ehXP(obj) then
                        mover(obj)
                    end

                end
            end

        end
    end
end

-- espera a interface carregar
task.wait(1)

-- faz somente uma busca inicial
procurar()

print("✅ contador e xp movidos +" .. QUANTO_DESCER .. "px")
