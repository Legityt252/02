-- [[ TEIA HUB - AUTO ANTI-LAG AO EXECUTAR ]]

-- 1. EXECUÇÃO AUTOMÁTICA DO ANTI-LAG EXTREMO (IMEDIATAMENTE)
task.spawn(function()
    if setfpscap then setfpscap(999) end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.EnvironmentDiffuseScale = 0

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end

    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterTransparency = 1
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        pcall(function() sethiddenproperty(Terrain, "Decoration", false) end)
    end

    local function removeGraphics(v)
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
            v.Enabled = false
            v:Destroy()
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
            v.Reflectance = 0
        elseif v:IsA("SpecialMesh") then
            v.TextureId = ""
        elseif v:IsA("MeshPart") then
            v.TextureID = ""
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    end

    for _, v in pairs(game:GetDescendants()) do
        removeGraphics(v)
    end

    game.DescendantAdded:Connect(removeGraphics)
end)

-- 2. CARREGAMENTO DA INTERFACE FLUENT
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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

-- [[ REMOÇÃO DE BOTÕES ANTIGOS ]]
if game:GetService("CoreGui"):FindFirstChild("TeiaHub_ToggleGui") then
    game:GetService("CoreGui").TeiaHub_ToggleGui:Destroy()
end

-- [[ NOVO BOTÃO FLUTUANTE COM TOGGLE CORRIGIDO ]]
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

-- LÓGICA CORRIGIDA DE ABRIR/FECHAR
local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    if Window.Root then
        Window.Root.Visible = uiVisible
    elseif Window.Instance then
        Window.Instance.Enabled = uiVisible
    else
        pcall(function() Window:Toggle() end)
    end
end)

-- [[ FUNÇÃO DE EXECUÇÃO SEGURA DOS SCRIPTS ]]
local function safeLoad(url, name, extraCode)
    task.spawn(function()
        Fluent:Notify({ Title = name or "Script", Content = "Iniciando...", Duration = 2 })
        if extraCode then pcall(extraCode) end
        if url and url ~= "" then
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                Fluent:Notify({ Title = "Erro", Content = "Falha ao carregar script", Duration = 3 })
            end
        end
    end)
end

-- ====================================================
-- [[ ORGANIZAÇÃO DAS ABAS ]]
-- ====================================================

local Tabs = {
    Main = Window:AddTab({ Title = "Blox Fruit / King Legacy", Icon = "home" }),
    Murder = Window:AddTab({ Title = "Murder", Icon = "sword" }),
    Robber = Window:AddTab({ Title = "Robber Hot", Icon = "user" }),
    Garden = Window:AddTab({ Title = "Go Garden", Icon = "trees" }),
    Troll = Window:AddTab({ Title = "Trollagem", Icon = "smile" })
    moites = Window:AddTab({ Title = "noites", Icon = "smile" })
}

----------------------------------------------------
-- 1ª ABA: BLOX FRUIT / KING LEGACY (DESEMPENHO + SCRIPTS)
----------------------------------------------------

Tabs.Main:AddButton({
    Title = "⚡ Replicar Anti-Lag (Limpar Texturas Novas)",
    Description = "Lança uma nova varredura para remover efeitos e partículas recém-carregadas.",
    Callback = function()
        Fluent:Notify({ Title = "Anti-Lag", Content = "Limpando novamente...", Duration = 2 })
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
    Description = "Aumenta o campo de visão para a tela esticada de PC.",
    Callback = function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = 110
            Fluent:Notify({ Title = "Câmera", Content = "FOV definido para 110!", Duration = 2 })
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
    Title = "Executar Gravity Hub (Blox Fruits)",
    Description = "Carrega Gravity Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Aegis Loader (v4)",
    Description = "Carrega LuaAegis",
    Callback = function()
        safeLoad("https://luaegis.net/scripts/v4/loaders/08f7c7f0-7917-4a53-99b5-84ae0dec28a9.lua", "Aegis Loader")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Omgshit MainLoader",
    Description = "Carrega Omgshit Loader",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", "Omgshit Loader")
    end
})

Tabs.Main:AddButton({
    Title = "Executar RealRedz Meme Sea",
    Description = "Carrega Meme Sea Script",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/realredz/MemeSea/refs/heads/main/Source.lua", "RealRedz Meme Sea")
    end
})

Tabs.Main:AddButton({
    Title = "Executar TLRedz Script (Beta Version)",
    Description = "Carrega TLRedz Script",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", "TLRedz Beta", function()
            getgenv().BETA_VERSION = true
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Executar Banana Cat Hub",
    Description = "Carrega Banana Cat Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua", "Banana Cat Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar TurboLite V2",
    Description = "Carrega TurboLite V2",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", "TurboLite V2")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Pastebin Script",
    Description = "Carrega script Pastebin",
    Callback = function()
        safeLoad("https://pastebin.com/raw/uECLqG3j", "Pastebin Script")
    end
})

Tabs.Main:AddButton({
    Title = "Executar KiteLoader",
    Description = "Carrega KiteLoader",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/KiteLoader", "KiteLoader")
    end
})

Tabs.Main:AddButton({
    Title = "Executar NightMystic Hub",
    Description = "Carrega NightMystic Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua", "NightMystic Hub", function()
            getgenv().team = "Marines"
        end)
    end
})

Tabs.Main:AddButton({
    Title = "Executar Stellar Eclipse (No Key)",
    Description = "Carrega Stellar Eclipse",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau", "Stellar Eclipse")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Redz Ruby (No Key)",
    Description = "Carrega Redz Ruby",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua", "Redz Ruby")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Zynex Hub",
    Description = "Carrega Zynex Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Hirokai-Script-make/Zynexhubbloxfruit/refs/heads/main/ZynexHub-BloxFruit-redz.lua", "Zynex Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Matsune Hub",
    Description = "Carrega Matsune Hub",
    Callback = function()
        safeLoad("https://luacrack.site/raw.php/MatsuneHubSuppor/raw/Gamemod2.lua", "Matsune Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Teddy Hub",
    Description = "Carrega Teddy Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TeddyHub.lua", "Teddy Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar MẹoX Hub",
    Description = "Carrega MẹoX Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/VanHoangIOS/MeoXHub/refs/heads/main/Main.lua", "MẹoX Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Fazium Hub",
    Description = "Carrega Fazium Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader", "Fazium Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Wukong HUD",
    Description = "Carrega Wukong HUD",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud", "Wukong HUD")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Vector Hub",
    Description = "Carrega Vector Hub",
    Callback = function()
        safeLoad("https://vectorhub.space", "Vector Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Genesis Hub (King Legacy)",
    Description = "Carrega Genesis Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua", "Genesis Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar Redz Hub",
    Description = "Carrega Redz Hub",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub")
    end
})

Tabs.Main:AddButton({
    Title = "Executar QuantumOnyx",
    Description = "Carrega QuantumOnyx",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", "QuantumOnyx")
    end
})

----------------------------------------------------
-- 2ª ABA: MURDER
----------------------------------------------------

Tabs.Murder:AddButton({
    Title = "Executar Script Murder Mystery",
    Description = "Carrega o script para Murder",
    Callback = function()
        safeLoad("https://LINK_DO_SCRIPT_MURDER_AQUI", "Murder Script")
    end
})

----------------------------------------------------
-- 3ª ABA: ROBBER HOT
----------------------------------------------------

Tabs.Robber:AddButton({
    Title = "Executar Script Robber Hot",
    Description = "Carrega o script para Robber Hot",
    Callback = function()
        safeLoad("https://LINK_DO_SCRIPT_ROBBER_HOT_AQUI", "Robber Hot Script")
    end
})

----------------------------------------------------
-- 4ª ABA: GO GARDEN
----------------------------------------------------

Tabs.Garden:AddButton({
    Title = "Executar Script Go Garden",
    Description = "Carrega o script para Go Garden",
    Callback = function()
        safeLoad("https://LINK_DO_SCRIPT_GO_GARDEN_AQUI", "Go Garden Script")
    end
})

Tabs.noites:AddButton({
    Title = "Executar Script 99",
    Description = "Carrega o script para 99",
    Callback = function()
        safeLoad("https://rifton.top/loader.lua", "99 Script")
    end
})


----------------------------------------------------
-- 5ª ABA: TROLLAGEM
----------------------------------------------------

Tabs.Troll:AddButton({
    Title = "Executar FE Trolling GUI",
    Description = "Carrega o script FE Trolling GUI",
    Callback = function()
        safeLoad("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/FE%20Trolling%20GUI.lua", "FE Trolling GUI")
    end
})

-- SELEÇÃO E NOTIFICAÇÃO INICIAL
Window:SelectTab(1)

Fluent:Notify({
    Title = "Teia HUB",
    Content = "Anti-Lag ativado automaticamente na hora!",
    Duration = 5
})
