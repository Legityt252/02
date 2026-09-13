-- [[ TEIA HUB - EDIÇÃO FINAL ROXA & COMPACTA ]]

local Fluent
local success, err = pcall(function()
    Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then return end

-- [[ JANELA ROXA E ULTRA COMPACTA ]]
local Window = Fluent:CreateWindow({
    Title = "Teia HUB 🕸️",
    SubTitle = "by João Neto",
    TabWidth = 130,
    Size = UDim2.fromOffset(450, 320), -- Tamanho reduzido ao máximo
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ COR ROXA NA INTERFACE ]]
pcall(function()
    if Window.Root then
        Window.Root.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
        
        -- Habilita rolagem vertical na lista de abas (Scroll Down)
        local LeftSection = Window.Root:FindFirstChild("LeftSection", true) or Window.Root:FindFirstChild("TabList", true)
        if LeftSection and LeftSection:IsA("ScrollingFrame") then
            LeftSection.ScrollBarThickness = 4
            LeftSection.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 220)
            LeftSection.ScrollingDirection = Enum.ScrollingDirection.Y
            LeftSection.CanvasSize = UDim2.new(0, 0, 0, 400) -- Permite rolar todas as abas
        end
    end
end)

-- [[ BOTÃO FLUTUANTE ROXO ]]
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

-- [[ FUNÇÃO ANTI-LAG EXTREMO (GRÁFICO BATATA & ITENS PRESERVADOS) ]]
local function runUltraAntiLag()
    pcall(function()
        if setfpscap then setfpscap(999) end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0

        local function optimize(v)
            pcall(function()
                -- Preserva ferramentas e itens
                if v:IsA("Tool") or v:FindFirstAncestorOfClass("Tool") then return end

                -- Remove efeitos visuais
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") or v:IsA("Light") then
                    v:Destroy()
                -- Remove roupas, decalques e texturas
                elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
                    v:Destroy()
                -- Remove cabelos e acessórios de skins
                elseif v:IsA("Accessory") or v:IsA("Accoutrement") or v:IsA("CharacterMesh") then
                    v:Destroy()
                -- Mapa em SmoothPlastic
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

-- [[ FUNÇÃO DE CARREGAMENTO ]]
local function safeLoad(url, name)
    if url and url ~= "" and url ~= "URL_AQUI" then
        Fluent:Notify({ Title = name, Content = "Iniciando...", Duration = 2 })
        pcall(function() loadstring(game:HttpGet(url))() end)
    else
        Fluent:Notify({ Title = name or "Aviso", Content = "Em breve novos scripts!", Duration = 2 })
    end
end

-- ====================================================
-- [[ ABAS ORGANIZADAS COM ROLAGEM ]]
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
    Config   = Window:AddTab({ Title = "Config", Icon = "settings" })
}

-- 1. BLOX FRUIT / KING LEGACY
Tabs.Main:AddButton({ Title = "Gravity Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub") end })
Tabs.Main:AddButton({ Title = "Redz Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub") end })
Tabs.Main:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 2. OUTROS JOGOS
Tabs.Outros:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 3. MURDER
Tabs.Murder:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 4. ROBBER HOT
Tabs.Robber:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 5. GO GARDEN
Tabs.Garden:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 6. TROLLAGEM
Tabs.Troll:AddButton({ Title = "FE Trolling GUI", Callback = function() safeLoad("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/FE%20Trolling%20GUI.lua", "FE Trolling") end })
Tabs.Troll:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 7. 99 NOITES
Tabs.Moites:AddButton({ Title = "Rifton Loader", Callback = function() safeLoad("https://rifton.top/loader.lua", "Rifton") end })
Tabs.Moites:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 8. DAYBOT
Tabs.Daybot:AddButton({ Title = "CentuDox Hub", Callback = function() safeLoad("https://raw.githubusercontent.com/ParadozCode/CentuDox-Hub-Paradoz-Hub/refs/heads/main/CENTUDOX%20AIMBOT.xyz", "CentuDox") end })
Tabs.Daybot:AddButton({ Title = "➕ Adicionar Script", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- 9. CONFIGURAÇÕES & ANTI-LAG
Tabs.Config:AddButton({
    Title = "🚀 Ativar Anti-Lag (Gráfico Batata)",
    Callback = function()
        runUltraAntiLag()
        Fluent:Notify({ Title = "Anti-Lag", Content = "Gráfico batata ativado!", Duration = 2 })
    end
})

Tabs.Config:AddButton({
    Title = "🔄 Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Window:SelectTab(1)

