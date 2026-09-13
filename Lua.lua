-- [[ TEIA HUB - COMPLETO ]]

-- 1. CARREGAMENTO DA INTERFACE FLUENT
local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    warn("Erro ao carregar a interface Fluent: " .. tostring(err))
    return
end

-- [[ JANELA PRINCIPAL ]]
local Window = Fluent:CreateWindow({
    Title = "Teia HUB",
    SubTitle = "by João Neto",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ CRIAÇÃO DO BOTÃO FLUTUANTE NA TELA ]]
if game:GetService("CoreGui"):FindFirstChild("TeiaHub_ToggleGui") then
    game:GetService("CoreGui").TeiaHub_ToggleGui:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ToggleGui.Name = "TeiaHub_ToggleGui"
ToggleGui.Parent = game:GetService("CoreGui")
ToggleGui.ResetOnSpawn = false

ToggleButton.Name = "WebToggleButton"
ToggleButton.Parent = ToggleGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 52, 0, 52)
ToggleButton.Text = "🕸️"
ToggleButton.TextSize = 28
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(120, 120, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = ToggleButton

-- LÓGICA DE ABRIR E FECHAR O MENU
local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    pcall(function()
        if Window.Root then
            Window.Root.Visible = uiVisible
        else
            Window:Toggle()
        end
    end)
end)

-- 2. EXECUÇÃO DO ANTI-LAG EM SEGUNDO PLANO
task.spawn(function()
    pcall(function()
        if setfpscap then setfpscap(999) end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0

        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end

        local function removeGraphics(v)
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v:Destroy()
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                end
            end)
        end

        for _, v in pairs(game:GetDescendants()) do
            removeGraphics(v)
        end
        game.DescendantAdded:Connect(removeGraphics)
    end)
end)

-- [[ FUNÇÃO DE EXECUÇÃO SEGURA DOS SCRIPTS ]]
local function safeLoad(url, name, extraCode)
    task.spawn(function()
        Fluent:Notify({ Title = name or "Script", Content = "Iniciando...", Duration = 2 })
        if extraCode then pcall(extraCode) end
        if url and url ~= "" then
            local s, e = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not s then
                Fluent:Notify({ Title = "Erro", Content = "Falha ao carregar script", Duration = 3 })
            end
        end
    end)
end

-- ====================================================
-- [[ ORGANIZAÇÃO DAS ABAS ]]
-- ====================================================

local Tabs = {
    Main        = Window:AddTab({ Title = "Blox Fruit / King Legacy", Icon = "home" }),
    OutrosJogos = Window:AddTab({ Title = "Outros Jogos", Icon = "gamepad-2" }),
    Murder      = Window:AddTab({ Title = "Murder", Icon = "sword" }),
    Robber      = Window:AddTab({ Title = "Robber Hot", Icon = "user" }),
    Garden      = Window:AddTab({ Title = "Go Garden", Icon = "trees" }),
    Troll       = Window:AddTab({ Title = "Trollagem", Icon = "smile" }),
    Moites      = Window:AddTab({ Title = "99 Noites", Icon = "🫎" }),
    Daybot      = Window:AddTab({ Title = "Daybot", Icon = "crosshair" }),
    Music       = Window:AddTab({ Title = "Música", Icon = "music" })
}

----------------------------------------------------
-- 1ª ABA: BLOX FRUIT / KING LEGACY
----------------------------------------------------

Tabs.Main:AddButton({
    Title = "⚡ Replicar Anti-Lag",
    Description = "Lança uma nova varredura para remover efeitos recentes.",
    Callback = function()
        Fluent:Notify({ Title = "Anti-Lag", Content = "Limpando...", Duration = 2 })
        task.spawn(function()
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end)
    end
})

Tabs.Main:AddButton({
    Title = "📱 Esticar Tela (FOV 110)",
    Description = "Aumenta o campo de visão.",
    Callback = function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = 110
            Fluent:Notify({ Title = "Câmera", Content = "FOV 110 ativado!", Duration = 2 })
        end
    end
})

Tabs.Main:AddButton({
    Title = "📱 Resetar Câmera (FOV 70)",
    Description = "Volta o campo de visão ao padrão.",
    Callback = function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = 70
            Fluent:Notify({ Title = "Câmera", Content = "FOV resetado!", Duration = 2 })
        end
    end
})

Tabs.Main:AddButton({
    Title = "Executar Gravity Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Aegis Loader",
    Callback = function() safeLoad("https://luaegis.net/scripts/v4/loaders/08f7c7f0-7917-4a53-99b5-84ae0dec28a9.lua", "Aegis Loader") end
})

Tabs.Main:AddButton({
    Title = "Executar Omgshit MainLoader",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", "Omgshit Loader") end
})

Tabs.Main:AddButton({
    Title = "Executar RealRedz Meme Sea",
    Callback = function() safeLoad("https://raw.githubusercontent.com/realredz/MemeSea/refs/heads/main/Source.lua", "RealRedz Meme Sea") end
})

Tabs.Main:AddButton({
    Title = "Executar TLRedz Script",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", "TLRedz Beta", function()
            getgenv().BETA_VERSION = true
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Executar Banana Cat Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua", "Banana Cat Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar TurboLite V2",
    Callback = function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", "TurboLite V2") end
})

Tabs.Main:AddButton({
    Title = "Executar Pastebin Script",
    Callback = function() safeLoad("https://pastebin.com/raw/uECLqG3j", "Pastebin Script") end
})

Tabs.Main:AddButton({
    Title = "Executar KiteLoader",
    Callback = function() safeLoad("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/KiteLoader", "KiteLoader") end
})

Tabs.Main:AddButton({
    Title = "Executar NightMystic Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua", "NightMystic Hub", function()
            getgenv().team = "Marines"
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Executar Stellar Eclipse",
    Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau", "Stellar Eclipse") end
})

Tabs.Main:AddButton({
    Title = "Executar Redz Ruby",
    Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua", "Redz Ruby") end
})

Tabs.Main:AddButton({
    Title = "Executar Zynex Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Hirokai-Script-make/Zynexhubbloxfruit/refs/heads/main/ZynexHub-BloxFruit-redz.lua", "Zynex Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Matsune Hub",
    Callback = function() safeLoad("https://luacrack.site/raw.php/MatsuneHubSuppor/raw/Gamemod2.lua", "Matsune Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Teddy Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TeddyHub.lua", "Teddy Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar MẹoX Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/VanHoangIOS/MeoXHub/refs/heads/main/Main.lua", "MẹoX Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Fazium Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader", "Fazium Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Wukong HUD",
    Callback = function() safeLoad("https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud", "Wukong HUD") end
})

Tabs.Main:AddButton({
    Title = "Executar Vector Hub",
    Callback = function() safeLoad("https://vectorhub.space", "Vector Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Genesis Hub (King Legacy)",
    Callback = function() safeLoad("https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua", "Genesis Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar Redz Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub") end
})

Tabs.Main:AddButton({
    Title = "Executar QuantumOnyx",
    Callback = function() safeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", "QuantumOnyx") end
})

----------------------------------------------------
-- 2ª ABA: OUTROS JOGOS (100 BOTÕES PRONTOS PARA VOCÊ ADICIONAR SEUS SCRIPTS)
-- COMO USAR QUANDO ESTIVER OFFLINE:
-- 1. Troque "Nome do Jogo" pelo nome do seu jogo.
-- 2. Troque "COLE_O_LINK_AQUI" pelo link do script raw.
----------------------------------------------------

Tabs.OutrosJogos:AddButton({ Title = "Jogo 1: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 1") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 2: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 2") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 3: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 3") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 4: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 4") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 5: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 5") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 6: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 6") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 7: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 7") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 8: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 8") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 9: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 9") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 10: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 10") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 11: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 11") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 12: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 12") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 13: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 13") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 14: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 14") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 15: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 15") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 16: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 16") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 17: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 17") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 18: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 18") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 19: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 19") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 20: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 20") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 21: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 21") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 22: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 22") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 23: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 23") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 24: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 24") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 25: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 25") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 26: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 26") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 27: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 27") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 28: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 28") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 29: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 29") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 30: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 30") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 31: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 31") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 32: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 32") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 33: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 33") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 34: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 34") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 35: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 35") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 36: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 36") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 37: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 37") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 38: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 38") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 39: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 39") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 40: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 40") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 41: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 41") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 42: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 42") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 43: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 43") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 44: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 44") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 45: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 45") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 46: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 46") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 47: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 47") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 48: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 48") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 49: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 49") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 50: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 50") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 51: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 51") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 52: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 52") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 53: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 53") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 54: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 54") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 55: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 55") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 56: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 56") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 57: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 57") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 58: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 58") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 59: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 59") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 60: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 60") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 61: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 61") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 62: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 62") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 63: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 63") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 64: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 64") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 65: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 65") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 66: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 66") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 67: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 67") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 68: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 68") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 69: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 69") end })
Tabs.OutrosJogos:AddButton({ Title = "Jogo 70: Nome do Jogo", Callback = function() safeLoad("COLE_O_LINK_AQUI", "Jogo 70") end })
Tabs.OutrosJogos:AddButton({ Ti
