-- [[ TEIA HUB - COMPLETO ]]

-- 1. CARREGAMENTO DA INTERFACE FLUENT (Primeira Prioridade)
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
    Main    = Window:AddTab({ Title = "Blox Fruit / King Legacy", Icon = "home" }),
    Murder  = Window:AddTab({ Title = "Murder", Icon = "sword" }),
    Robber  = Window:AddTab({ Title = "Robber Hot", Icon = "user" }),
    Garden  = Window:AddTab({ Title = "Go Garden", Icon = "trees" }),
    Troll   = Window:AddTab({ Title = "Trollagem", Icon = "smile" }),
    Moites  = Window:AddTab({ Title = "99 Noites", Icon = "🫎" }),
    Daybot  = Window:AddTab({ Title = "Daybot", Icon = "crosshair" }),
    Music   = Window:AddTab({ Title = "Música", Icon = "music" })
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
-- OUTRAS ABAS
----------------------------------------------------

Tabs.Murder:AddButton({
    Title = "Executar Script Murder",
    Callback = function() safeLoad("https://LINK_DO_SCRIPT_MURDER_AQUI", "Murder Script") end
})

Tabs.Robber:AddButton({
    Title = "Executar Script Robber Hot",
    Callback = function() safeLoad("https://LINK_DO_SCRIPT_ROBBER_HOT_AQUI", "Robber Hot Script") end
})

Tabs.Garden:AddButton({
    Title = "Executar Script Go Garden",
    Callback = function() safeLoad("https://LINK_DO_SCRIPT_GO_GARDEN_AQUI", "Go Garden Script") end
})

Tabs.Troll:AddButton({
    Title = "Executar FE Trolling GUI",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/FE%20Trolling%20GUI.lua", "FE Trolling GUI") end
})

----------------------------------------------------
-- ABA: 99 NOITES
----------------------------------------------------

Tabs.Moites:AddButton({
    Title = "Executar Rifton Loader",
    Callback = function() safeLoad("https://rifton.top/loader.lua", "99 Script") end
})

Tabs.Moites:AddButton({
    Title = "Executar Vape Voidware Addons",
    Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", "VW Addons") end
})

Tabs.Moites:AddButton({
    Title = "Executar H4xScripts Loader",
    Callback = function() safeLoad("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", "H4xScripts") end
})

Tabs.Moites:AddButton({
    Title = "Executar VW Extra Forest",
    Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", "VW Extra") end
})

Tabs.Moites:AddButton({
    Title = "Executar Kenniel Script",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-Forest/refs/heads/main/99%20Nights%20in%20the%20Forest", "Kenniel Script") end
})

Tabs.Moites:AddButton({
    Title = "Executar Hutao Hub",
    Callback = function() safeLoad("https://raw.githubusercontent.com/SLK-gaming/Hutao-Hub/refs/heads/main/99-Nights-In-The-Forest.txt", "Hutao Hub") end
})

Tabs.Moites:AddButton({
    Title = "Executar PhantomFlux",
    Callback = function() safeLoad("https://raw.githubusercontent.com/sudaisontopxd/PhantomFlux/refs/heads/main/99NightsInTheForest", "PhantomFlux") end
})

Tabs.Moites:AddButton({
    Title = "Executar Script Pastebin",
    Callback = function() safeLoad("https://pastebin.com/raw/pMVn317S", "Pastebin Script") end
})

Tabs.Moites:AddButton({
    Title = "Executar Auto Food",
    Callback = function() safeLoad("https://raw.githubusercontent.com/99nightsscripts/main/autofood.lua", "Auto Food") end
})

Tabs.Moites:AddButton({
    Title = "Executar KillAura & ESP (Kenniel)",
    Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-forest-KillAura-ESP/main/script.lua", "KillAura & ESP") end
})

----------------------------------------------------
-- ABA: DAYBOT
----------------------------------------------------

Tabs.Daybot:AddButton({
    Title = "Executar CentuDox Hub",
    Description = "Carrega o script CentuDox",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/ParadozCode/CentuDox-Hub-Paradoz-Hub/refs/heads/main/CENTUDOX%20AIMBOT.xyz", "CentuDox Hub")
    end
})

----------------------------------------------------
-- ABA: MÚSICA
----------------------------------------------------

local SoundService = game:GetService("SoundService")
local currentSound = nil

Tabs.Music:AddInput("MusicID", {
    Title = "ID da Música (Roblox)",
    Default = "",
    Placeholder = "Digite o Sound ID aqui...",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        _G.SelectedMusicID = Value
    end
})

Tabs.Music:AddButton({
    Title = "▶️ Tocar Música",
    Callback = function()
        if _G.SelectedMusicID and _G.SelectedMusicID ~= "" then
            if currentSound then
                currentSound:Stop()
                currentSound:Destroy()
            end

            currentSound = Instance.new("Sound")
            currentSound.SoundId = "rbxassetid://" .. tostring(_G.SelectedMusicID)
            currentSound.Volume = 1
            currentSound.Looped = true
            currentSound.Parent = SoundService
            currentSound:Play()

            Fluent:Notify({ Title = "Música", Content = "Tocando áudio ID: " .. _G.SelectedMusicID, Duration = 3 })
        else
            Fluent:Notify({ Title = "Erro", Content = "Insira um ID de música válido!", Duration = 3 })
        end
    end
})

Tabs.Music:AddButton({
    Title = "⏹️ Parar Música",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
            currentSound = nil
            Fluent:Notify({ Title = "Música", Content = "Música parada.", Duration = 2 })
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Teia HUB",
    Content = "Menu carregado com sucesso!",
    Duration = 4
})
