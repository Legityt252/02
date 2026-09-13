-- [[ TEIA HUB - VERSÃO RAYFIELD (BY JOÃO NETO) ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Teia HUB 🕸️ | por João Neto",
   LoadingTitle = "Teia HUB",
   LoadingSubtitle = "Carregando a interface...",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "TeiaHubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false
})

-- [[ OVERLAY DE FPS VISUAL (TOPO DA TELA) ]]
if game:GetService("CoreGui"):FindFirstChild("TeiaHub_FPS") then
    game:GetService("CoreGui").TeiaHub_FPS:Destroy()
end

local FpsGui = Instance.new("ScreenGui")
local FpsLabel = Instance.new("TextLabel")
local FpsCorner = Instance.new("UICorner")
local FpsStroke = Instance.new("UIStroke")

FpsGui.Name = "TeiaHub_FPS"
FpsGui.Parent = game:GetService("CoreGui")
FpsGui.ResetOnSpawn = false

FpsLabel.Parent = FpsGui
FpsLabel.AnchorPoint = Vector2.new(0.5, 0)
FpsLabel.Position = UDim2.new(0.5, 0, 0.01, 0)
FpsLabel.Size = UDim2.new(0, 160, 0, 28)
FpsLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
FpsLabel.Text = "FPS: ... | FSR"
FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsLabel.TextSize = 13
FpsLabel.Font = Enum.Font.SourceSansBold

FpsCorner.CornerRadius = UDim.new(0, 8)
FpsCorner.Parent = FpsLabel

FpsStroke.Thickness = 1.5
FpsStroke.Color = Color3.fromRGB(140, 60, 220)
FpsStroke.Parent = FpsLabel

local currentUpscaleMode = "FSR"
local RunService = game:GetService("RunService")
local lastTick = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTick >= 1 then
        local realFps = frameCount / (now - lastTick)
        frameCount = 0
        lastTick = now
        
        local displayFps = math.floor(realFps)
        if currentUpscaleMode == "FSR" then
            displayFps = math.floor(realFps * 4.0)
        elseif currentUpscaleMode == "DLSS" then
            displayFps = math.floor(realFps * 5.5)
        end

        FpsLabel.Text = "FPS: " .. tostring(displayFps) .. " | " .. currentUpscaleMode
    end
end)

-- [[ OTIMIZAÇÃO POR DISTÂNCIA (CULLING AUTOMÁTICO) ]]
local RenderDistance = 350 -- Distância limite para ocultar objetos/NPCs distantes
local function enableDistanceCulling()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        while task.wait(0.5) do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local myPos = char.HumanoidRootPart.Position
                    
                    for _, obj in pairs(workspace:GetChildren()) do
                        -- Ignora o próprio jogador e a câmera
                        if obj ~= char and obj.Name ~= "Camera" then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                            if part then
                                local dist = (part.Position - myPos).Magnitude
                                if dist > RenderDistance then
                                    if not obj:FindFirstChild("HiddenByTeia") then
                                        local tag = Instance.new("BoolValue")
                                        tag.Name = "HiddenByTeia"
                                        tag.Parent = obj
                                        
                                        if obj:IsA("Model") then
                                            for _, child in pairs(obj:GetDescendants()) do
                                                if child:IsA("BasePart") then child.LocalTransparencyModifier = 1 end
                                            end
                                        elseif obj:IsA("BasePart") then
                                            obj.LocalTransparencyModifier = 1
                                        end
                                    end
                                else
                                    if obj:FindFirstChild("HiddenByTeia") then
                                        obj.HiddenByTeia:Destroy()
                                        if obj:IsA("Model") then
                                            for _, child in pairs(obj:GetDescendants()) do
                                                if child:IsA("BasePart") then child.LocalTransparencyModifier = 0 end
                                            end
                                        elseif obj:IsA("BasePart") then
                                            obj.LocalTransparencyModifier = 0
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- [[ FUNÇÕES DE OTIMIZAÇÃO & CÂMERA FLUIDA ]]
local cameraMotionBlurConnection = nil
local function enableCameraSmoothness()
    pcall(function()
        local Lighting = game:GetService("Lighting")
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

        for _, v in pairs(game:GetDescendants()) do optimize(v) end
        game.DescendantAdded:Connect(optimize)
    end)
end

local function runFullOptimization()
    runUltraAntiLag()
    enableCameraSmoothness()
    enableDistanceCulling()
end

local function safeLoad(url, name)
    if url and url ~= "" and url ~= "URL_AQUI" then
        Rayfield:Notify({ Title = name, Content = "Carregando script...", Duration = 2 })
        pcall(function() loadstring(game:HttpGet(url))() end)
    else
        Rayfield:Notify({ Title = name or "Aviso", Content = "Em breve novos scripts!", Duration = 2 })
    end
end

-- [[ INICIALIZAÇÃO AUTOMÁTICA COMPLETA ]]
task.spawn(function()
    runFullOptimization()
    Rayfield:Notify({ Title = "Teia HUB", Content = "Otimização, Anti-Lag e Distance Culling Ativados!", Duration = 4 })
end)

-- ====================================================
-- [[ ABAS DA INTERFACE RAYFIELD ]]
-- ====================================================

local TabMain = Window:CreateTab("Blox / King", 4483362458)
local TabOutros = Window:CreateTab("Outros Jogos", 4483362458)
local TabMurder = Window:CreateTab("Murder", 4483362458)
local TabRobber = Window:CreateTab("Robber Hot", 4483362458)
local TabGarden = Window:CreateTab("Go Garden", 4483362458)
local TabTroll = Window:CreateTab("Trollagem", 4483362458)
local TabMoites = Window:CreateTab("99 Noites", 4483362458)
local TabDaybot = Window:CreateTab("Daybot", 4483362458)
local TabMusic = Window:CreateTab("Música", 4483362458)
local TabConfig = Window:CreateTab("Configurações", 4483362458)

-- 1. BLOX FRUIT / KING LEGACY
TabMain:CreateButton({ Name = "Gravity Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub") end })
TabMain:CreateButton({ Name = "Aegis Loader", Callback = function() safeLoad("https://luaegis.net/scripts/v4/loaders/08f7c7f0-7917-4a53-99b5-84ae0dec28a9.lua", "Aegis Loader") end })
TabMain:CreateButton({ Name = "Omgshit MainLoader", Callback = function() safeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", "Omgshit MainLoader") end })
TabMain:CreateButton({ Name = "RealRedz Meme Sea", Callback = function() safeLoad("https://raw.githubusercontent.com/realredz/MemeSea/refs/heads/main/Source.lua", "RealRedz Meme Sea") end })
TabMain:CreateButton({ Name = "TLRedz Script", Callback = function() safeLoad("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", "TLRedz Script") end })
TabMain:CreateButton({ Name = "Banana Cat Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua", "Banana Cat Hub") end })
TabMain:CreateButton({ Name = "TurboLite V2", Callback = function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", "TurboLite V2") end })
TabMain:CreateButton({ Name = "Pastebin Script", Callback = function() safeLoad("https://pastebin.com/raw/uECLqG3j", "Pastebin Script") end })
TabMain:CreateButton({ Name = "KiteLoader", Callback = function() safeLoad("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/KiteLoader", "KiteLoader") end })
TabMain:CreateButton({ Name = "NightMystic Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua", "NightMystic Hub") end })
TabMain:CreateButton({ Name = "Stellar Eclipse", Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau", "Stellar Eclipse") end })
TabMain:CreateButton({ Name = "Redz Ruby", Callback = function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua", "Redz Ruby") end })
TabMain:CreateButton({ Name = "Zynex Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Hirokai-Script-make/Zynexhubbloxfruit/refs/heads/main/ZynexHub-BloxFruit-redz.lua", "Zynex Hub") end })
TabMain:CreateButton({ Name = "Matsune Hub", Callback = function() safeLoad("https://luacrack.site/raw.php/MatsuneHubSuppor/raw/Gamemod2.lua", "Matsune Hub") end })
TabMain:CreateButton({ Name = "Teddy Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TeddyHub.lua", "Teddy Hub") end })
TabMain:CreateButton({ Name = "MẹoX Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/VanHoangIOS/MeoXHub/refs/heads/main/Main.lua", "MẹoX Hub") end })
TabMain:CreateButton({ Name = "Fazium Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader", "Fazium Hub") end })
TabMain:CreateButton({ Name = "Wukong HUD", Callback = function() safeLoad("https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud", "Wukong HUD") end })
TabMain:CreateButton({ Name = "Vector Hub", Callback = function() safeLoad("https://vectorhub.space", "Vector Hub") end })
TabMain:CreateButton({ Name = "Genesis Hub (King Legacy)", Callback = function() safeLoad("https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua", "Genesis Hub") end })
TabMain:CreateButton({ Name = "Redz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub") end })
TabMain:CreateButton({ Name = "QuantumOnyx", Callback = function() safeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", "QuantumOnyx") end })

-- 2. OUTROS JOGOS
TabOutros:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 3. MURDER
TabMurder:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 4. ROBBER HOT
TabRobber:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 5. GO GARDEN
TabGarden:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 6. TROLLAGEM
TabTroll:CreateButton({ Name = "FE Trolling GUI", Callback = function() safeLoad("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/FE%20Trolling%20GUI.lua", "FE Trolling GUI") end })

-- 7. 99 NOITES
TabMoites:CreateButton({ Name = "Rifton Loader", Callback = function() safeLoad("https://rifton.top/loader.lua", "Rifton Loader") end })
TabMoites:CreateButton({ Name = "Vape Voidware Addons", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", "Vape Voidware Addons") end })
TabMoites:CreateButton({ Name = "H4xScripts Loader", Callback = function() safeLoad("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", "H4xScripts Loader") end })
TabMoites:CreateButton({ Name = "VW Extra Forest", Callback = function() safeLoad("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/NightsInTheForest.lua", "VW Extra Forest") end })
TabMoites:CreateButton({ Name = "Kenniel Script", Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-Forest/refs/heads/main/99%20Nights%20in%20the%20Forest", "Kenniel Script") end })
TabMoites:CreateButton({ Name = "Hutao Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/SLK-gaming/Hutao-Hub/refs/heads/main/99-Nights-In-The-Forest.txt", "Hutao Hub") end })
TabMoites:CreateButton({ Name = "PhantomFlux", Callback = function() safeLoad("https://raw.githubusercontent.com/sudaisontopxd/PhantomFlux/refs/heads/main/99NightsInTheForest", "PhantomFlux") end })
TabMoites:CreateButton({ Name = "Script Pastebin", Callback = function() safeLoad("https://pastebin.com/raw/pMVn317S", "Script Pastebin") end })
TabMoites:CreateButton({ Name = "Auto Food", Callback = function() safeLoad("https://raw.githubusercontent.com/99nightsscripts/main/autofood.lua", "Auto Food") end })
TabMoites:CreateButton({ Name = "KillAura & ESP (Kenniel)", Callback = function() safeLoad("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-forest-KillAura-ESP/main/script.lua", "KillAura & ESP") end })

-- 8. DAYBOT
TabDaybot:CreateButton({ Name = "CentuDox Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ParadozCode/CentuDox-Hub-Paradoz-Hub/refs/heads/main/CENTUDOX%20AIMBOT.xyz", "CentuDox Hub") end })

-- 9. MÚSICA
local SoundService = game:GetService("SoundService")
local currentSound = nil

TabMusic:CreateInput({
   Name = "ID da Música",
   PlaceholderText = "Digite o ID Roblox...",
   RemoveTextOnFocus = false,
   Callback = function(Text)
      _G.SelectedMusicID = Text
   end,
})

TabMusic:CreateButton({
   Name = "▶️ Tocar",
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

TabMusic:CreateButton({
   Name = "⏹️ Parar",
   Callback = function()
      if currentSound then
         currentSound:Stop()
         currentSound:Destroy()
         currentSound = nil
      end
   end
})

-- 10. CONFIGURAÇÕES
TabConfig:CreateDropdown({
   Name = "Modo de Upscaling",
   Options = {"FSR (Fake)", "DLSS (Preset)"},
   CurrentOption = {"FSR (Fake)"},
   MultipleOptions = false,
   Callback = function(Option)
      local selected = type(Option) == "table" and Option[1] or Option
      if selected == "DLSS (Preset)" then
          currentUpscaleMode = "DLSS"
          Rayfield:Notify({ Title = "Upscaling", Content = "Modo DLSS ativado!", Duration = 2 })
      else
          currentUpscaleMode = "FSR"
          runUltraAntiLag()
          Rayfield:Notify({ Title = "Upscaling", Content = "Modo FSR ativado!", Duration = 2 })
      end
   end,
})

TabConfig:CreateButton({
   Name = "🚀 Reativar Anti-Lag + Distance Cull",
   Callback = function()
      runFullOptimization()
      Rayfield:Notify({ Title = "Otimização", Content = "Sistemas de otimização reativados!", Duration = 2 })
   end
})

TabConfig:CreateButton({
   Name = "🔄 Rejoin",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
   end
})
