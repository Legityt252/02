-- [[ TEIA HUB - COM ANTI-LAG & CÂMERA FLUIDA AUTOMÁTICOS ]]

local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then return end

-- [[ JANELA ROXA E COMPACTA ]]
local Window = Fluent:CreateWindow({
    Title = "Teia HUB 🕸️",
    SubTitle = "by João Neto",
    TabWidth = 130,
    Size = UDim2.fromOffset(480, 350),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ DESIGN ROXO & ROLAGEM NAS ABAS ]]
pcall(function()
    if Window.Root then
        Window.Root.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
        
        local LeftSection = Window.Root:FindFirstChild("LeftSection", true) or Window.Root:FindFirstChild("TabList", true)
        if LeftSection and LeftSection:IsA("ScrollingFrame") then
            LeftSection.ScrollBarThickness = 4
            LeftSection.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 220)
            LeftSection.ScrollingDirection = Enum.ScrollingDirection.Y
            LeftSection.CanvasSize = UDim2.new(0, 0, 0, 420)
        end
    end
end)

-- [[ BOTÃO FLUTUANTE DE ABRIR/FECHAR ]]
if game:GetService("CoreGui"):FindFirstChild("TeiaHub_Toggle") then
    game:GetService("CoreGui").TeiaHub_Toggle:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ToggleGui.Name = "TeiaHub_Toggle"
ToggleGui.Parent = game:GetService("CoreGui")
ToggleGui.ResetOnSpawn = false

ToggleButton.Parent = ToggleGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
ToggleButton.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Text = "🕸️"
ToggleButton.TextSize = 20
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(140, 60, 220)
UIStroke.Parent = ToggleButton

local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    pcall(function()
        if Window.Root then Window.Root.Visible = uiVisible else Window:Toggle() end
    end)
end)

-- [[ FUNÇÃO DE CÂMERA FLUIDA / MOTION BLUR ]]
local cameraMotionBlurConnection = nil
local function enableCameraSmoothness()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera

        local blur = Lighting:FindFirstChild("TeiaMotionBlur") or Instance.new("BlurEffect")
        blur.Name = "TeiaMotionBlur"
        blur.Size = 0
        blur.Parent = Lighting

        local lastCFrame = Camera.CFrame

        if cameraMotionBlurConnection then cameraMotionBlurConnection:Disconnect() end

        cameraMotionBlurConnection = RunService.RenderStepped:Connect(function()
            local currentCFrame = Camera.CFrame
            local angle = math.acos(math.clamp(lastCFrame.LookVector:Dot(currentCFrame.LookVector), -1, 1))
            local blurAmount = math.clamp(angle * 120, 0, 16)
            
            blur.Size = blurAmount
            lastCFrame = currentCFrame
        end)
    end)
end

-- [[ FUNÇÃO ANTI-LAG MÁXIMO ]]
local function runUltraAntiLag()
    pcall(function()
        if setfpscap then setfpscap(999) end
        if disable_fps_cap then disable_fps_cap() end
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0

        local function optimize(v)
            pcall(function()
                if v:IsA("Tool") or v:FindFirstAncestorOfClass("Tool") then return end

                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") or v:IsA("Light") then
                    v:Destroy()
                elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                    v:Destroy()
                elseif v:IsA("Accessory") or v:IsA("Accoutrement") or v:IsA("CharacterMesh") then
                    v:Destroy()
                elseif v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                    v.Reflectance = 0
                end
            end)
        end

        for _, v in pairs(game:GetDescendants()) do
            optimize(v)
        end

        game.DescendantAdded:Connect(optimize)
    end)
end

-- [[ FUNÇÃO COMBINADA: ANTI-LAG + FLUIDEZ DE CÂMERA ]]
local function runFullOptimization()
    runUltraAntiLag()
    enableCameraSmoothness()
end

-- [[ EXECUÇÃO AUTOMÁTICA AO INICIAR O SCRIPT ]]
task.spawn(function()
    runFullOptimization()
    Fluent:Notify({ 
        Title = "Teia HUB", 
        Content = "Anti-Lag + Câmera Fluida ativados automaticamente!", 
        Duration = 4 
    })
end)

-- [[ FUNÇÃO PARA RODAR OS SCRIPTS DA LISTA ]]
local function safeLoad(url, name)
    if url and url ~= "" and url ~= "URL_AQUI" then
        Fluent:Notify({ Title = name, Content = "Carregando...", Duration = 2 })
        pcall(function() loadstring(game:HttpGet(url))() end)
    else
        Fluent:Notify({ Title = name or "Aviso", Content = "Em breve novos scripts!", Duration = 2 })
    end
end

-- ====================================================
-- [[ ABAS DA INTERFACE ]]
-- ====================================================

local Tabs = {
    Main     = Window:AddTab({ Title = "Blox / King", Icon = "home" }),
    Outros   = Window:AddTab({ Title = "Outros Jogos", Icon = "gamepad-2" }),
    Murder   = Window:AddTab({ Title = "Murder", Icon = "sword" }),
    Robber   = Window:AddTab({ Title = "Robber Hot", Icon = "user" }),
    Garden   = Window:AddTab({ Title = "Go Garden", Icon = "trees" }),
    Troll    = Window:AddTab({ Title = "Trollagem", Icon = "smile" }),
    Moites   = Window:AddTab({ Title = "99 Noites", Icon = "moon" }),
    Daybot   = Window:AddTab({ Title = "Daybot", Icon = "crosshair" }),
    Music    = Window:AddTab({ Title = "Música", Icon = "music" }),
    Config   = Window:AddTab({ Title = "Config", Icon = "settings" })
}

-- ====================================================
-- [[ LISTA DE TODOS OS SCRIPTS ]]
-- ====================================================

-- 1. BLOX FRUIT / KING LEGACY
Tabs.Main:AddButton({ Title = "Gravity Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub") end })
Tabs.Main:AddButton({ Title = "Aegis Loader", Callback = function() safeLoad("https://luaegis.net/scripts/v4/loaders/08f7c7f0-7917-4a53-99b5-84ae0dec28a9.lua", "Aegis Loader") end })
Tabs.Main:AddButton({ Title = "Omgshit MainLoader", Callback = function() safeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", "Omgshit MainLoader") end })
Tabs.Main:AddButton({ Title = "RealRedz Meme Sea", Callback = function() safeLoad("https://raw.githubusercontent.com/realredz/MemeSea/refs/heads/main/Source.lua", "RealRedz Meme Sea") end })
Tabs.Main:AddButton({ Title = "TLRedz Script", Callback = function() safeLoad("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", "TLRedz Script") end })
Tabs.Main:AddButton({ Title = "Banana Cat Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua", "Banana Cat Hub") end })
Tabs.Main:AddButton({ Title = "TurboLite V2", Callback = function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", "TurboLite V2") end })
Tabs.Main:AddButton({ Title = "Pastebin Script", Callback = function() safeLoad("https://pastebin.com/raw/uECLqG3j", "Pastebin Script") end })
Tabs.Main:AddButton({ Title = "KiteLoader", Callback = function() safeLoad("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/KiteLoader", "KiteLoader") end })
Tabs.Main:AddButton({ Title = "NightMystic Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua", "NightMystic Hub") end })
Tabs.Main:AddButton({ Title = "Stellar Eclipse", Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau", "Stellar Eclipse") end })
Tabs.Main:AddButton({ Title = "Redz Ruby", Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua", "Redz Ruby") end })
Tabs.Main:AddButton({ Title = "Zynex Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Hirokai-Script-make/Zynexhubbloxfruit/refs/heads/main/ZynexHub-BloxFruit-redz.lua", "Zynex Hub") end })
Tabs.Main:AddButton({ Title = "Matsune Hub", Callback = function() safeLoad("https://luacrack.site/raw.php/MatsuneHubSuppor/raw/Gamemod2.lua", "Matsune Hub") end })
Tabs.Main:AddButton({ Title = "Teddy Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TeddyHub.lua", "Teddy Hub") end })
Tabs.Main:AddButton({ Title = "MẹoX Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/VanHoangIOS/MeoXHub/refs/heads/main/Main.lua", "MẹoX Hub") end })
Tabs.Main:AddButton({ Title = "Fazium Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader", "Fazium Hub") end })
Tabs.Main:AddButton({ Title = "Wukong HUD", Callback = function() safeLoad("https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud", "Wukong HUD") end })
Tabs.Main:AddButton({ Title = "Vector Hub", Callback = function() safeLoad("https://vectorhub.space", "Vector Hub") end })
Tabs.Main:AddButton({ Title = "Genesis Hub (King Legacy)", Callback = function() safeLoad("https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua", "Genesis Hub") end })
Tabs.Main:AddButton({ Title = "Redz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub") end })
Tabs.Main:AddButton({ Title = "QuantumOnyx", Callback = function() safeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", "QuantumOnyx") end })
Tabs.Main:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 2. OUTROS JOGOS
Tabs.Outros:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 3. MURDER
Tabs.Murder:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 4. ROBBER HOT
Tabs.Robber:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 5. GO GARDEN
Tabs.Garden:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 6. TROLLAGEM
Tabs.Troll:AddButton({ Title = "FE Trolling GUI", Callback = function() safeLoad("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/FE%20Trolling%20GUI.lua", "FE Trolling GUI") end })
Tabs.Troll:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 7. 99 NOITES
Tabs.Moites:AddButton({ Title = "Rifton Loader", Callback = function() safeLoad("https://rifton.top/loader.lua", "Rifton Loader") end })
Tabs.Moites:AddButton({ Title = "Vape Voidware Addons", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", "Vape Voidware Addons") end })
Tabs.Moites:AddButton({ Title = "H4xScripts Loader", Callback = function() safeLoad("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", "H4xScripts Loader") end })
Tabs.Moites:AddButton({ Title = "VW Extra Forest", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", "VW Extra Forest") end })
Tabs.Moites:AddButton({ Title = "Kenniel Script", Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-Forest/refs/heads/main/99%20Nights%20in%20the%20Forest", "Kenniel Script") end })
Tabs.Moites:AddButton({ Title = "Hutao Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/SLK-gaming/Hutao-Hub/refs/heads/main/99-Nights-In-The-Forest.txt", "Hutao Hub") end })
Tabs.Moites:AddButton({ Title = "PhantomFlux", Callback = function() safeLoad("https://raw.githubusercontent.com/sudaisontopxd/PhantomFlux/refs/heads/main/99NightsInTheForest", "PhantomFlux") end })
Tabs.Moites:AddButton({ Title = "Script Pastebin", Callback = function() safeLoad("https://pastebin.com/raw/pMVn317S", "Script Pastebin") end })
Tabs.Moites:AddButton({ Title = "Auto Food", Callback = function() safeLoad("https://raw.githubusercontent.com/99nightsscripts/main/autofood.lua", "Auto Food") end })
Tabs.Moites:AddButton({ Title = "KillAura & ESP (Kenniel)", Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-forest-KillAura-ESP/main/script.lua", "KillAura & ESP") end })
Tabs.Moites:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 8. DAYBOT
Tabs.Daybot:AddButton({ Title = "CentuDox Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ParadozCode/CentuDox-Hub-Paradoz-Hub/refs/heads/main/CENTUDOX%20AIMBOT.xyz", "CentuDox Hub") end })
Tabs.Daybot:AddButton({ Title = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 9. MÚSICA
local SoundService = game:GetService("SoundService")
local currentSound = nil

Tabs.Music:AddInput("MusicID", {
    Title = "ID da Música",
    Default = "",
    Placeholder = "Digite o ID...",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        _G.SelectedMusicID = Value
    end
})

Tabs.Music:AddButton({
    Title = "▶️ Tocar",
    Callback = function()
        if _G.SelectedMusicID and _G.SelectedMusicID ~= "" then
            if currentSound then currentSound:Destroy() end
            currentSound = Instance.new("Sound")
            currentSound.SoundId = "rbxassetid://" .. tostring(_G.SelectedMusicID)
            currentSound.Volume = 1
            currentSound.Looped = true
            currentSound.Parent = SoundService
            currentSound:Play()
        end
    end
})

Tabs.Music:AddButton({
    Title = "⏹️ Parar",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
            currentSound = nil
        end
    end
})

-- 10. CONFIGURAÇÕES
Tabs.Config:AddButton({
    Title = "🚀 Ativar Anti-Lag + Câmera Fluida",
    Callback = function()
        runFullOptimization()
        Fluent:Notify({ Title = "Otimização", Content = "Anti-Lag + Motion Blur reativados!", Duration = 2 })
    end
})

Tabs.Config:AddButton({
    Title = "🔄 Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Window:SelectTab(1)
