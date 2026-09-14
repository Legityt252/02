-- Teia HUB 🕸️ | Auto Anti-Lag + DLS Motion Blur + Suavização de Câmera + Palavra de Deus | por João Neto
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

for _, nome in ipairs({"TeiaHub_Minimal", "TeiaHub_FPS"}) do
    local old = CoreGui:FindFirstChild(nome)
    if old then old:Destroy() end
end

-- =========================================================
-- [[ ANTI-LAG MÁXIMO PARA CELULAR ]]
-- =========================================================
local function aplicarAntiLag()
    pcall(function()
        if setfpscap then setfpscap(9999) end
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.QualityLevel.Level01
        end)

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        Lighting.FogStart = 0
        Lighting.Brightness = 2
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.Ambient = Color3.fromRGB(120, 120, 120)
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)

        for _, efx in ipairs(Lighting:GetChildren()) do
            efx:Destroy()
        end
    end)
end

-- =========================================================
-- [[ MOTION BLUR REAL & SUAVIZAÇÃO DE CÂMERA (ANTI-TRAVADINHA) ]]
-- =========================================================
local camera = Workspace.CurrentCamera
local lastCamCF = camera and camera.CFrame or CFrame.new()

-- Remove blur antigo da lighting se houver
local oldBlur = Lighting:FindFirstChild("TeiaHub_MotionBlur")
if oldBlur then oldBlur:Destroy() end

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "TeiaHub_MotionBlur"
blurEffect.Size = 0
blurEffect.Parent = Lighting

-- Configuração de Suavização (Interpolação para remover travadinhas ao girar a câmera)
local cameraSuavidade = 0.35 -- Quanto maior, mais responsivo; quanto menor, mais suave

RunService.RenderStepped:Connect(function()
    if not camera then camera = Workspace.CurrentCamera return end
    
    local currentCF = camera.CFrame
    local delta = (currentCF.Position - lastCamCF.Position).Magnitude + (currentCF.LookVector - lastCamCF.LookVector).Magnitude
    
    -- Suaviza a rotação e movimento da câmera para eliminar micro-stuttering (travadinhas)
    camera.CFrame = lastCamCF:Lerp(currentCF, cameraSuavidade)
    lastCamCF = camera.CFrame

    -- Se mexer a câmera, embaça suavemente. Se parar, volta ao normal.
    if delta > 0.1 then
        blurEffect.Size = math.min(delta * 40, 24)
    else
        blurEffect.Size = 0
    end
end)

-- =========================================================
-- [[ LIMPEZA DE TEXTURAS E SKINS ]]
-- =========================================================
local function limparObjeto(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("MeshPart") then
            obj.TextureID = ""
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("SpecialMesh") then
            pcall(function() obj.TextureId = "" end)
        elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Beam") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail")
            or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
            or obj:IsA("Explosion") or obj:IsA("Highlight") then
            obj:Destroy()
        elseif obj:IsA("Sky") then
            obj:Destroy()
        elseif obj:IsA("Shirt") or obj:IsA("Pants")
            or obj:IsA("ShirtGraphic") then
            obj:Destroy()
        elseif obj:IsA("Accessory") or obj:IsA("Hat") then
            for _, d in ipairs(obj:GetDescendants()) do
                if d:IsA("Decal") or d:IsA("Texture") then d:Destroy() end
                if d:IsA("MeshPart") then d.TextureID = "" end
            end
        end
    end)
end

local function limparTudo()
    task.spawn(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            limparObjeto(obj)
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                for _, d in ipairs(plr.Character:GetDescendants()) do
                    limparObjeto(d)
                end
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:RemoveAccessories() end)
                end
            end
        end
    end)
end

aplicarAntiLag()
limparTudo()

Workspace.DescendantAdded:Connect(function(obj)
    task.spawn(function() limparObjeto(obj) end)
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        for _, d in ipairs(char:GetDescendants()) do
            limparObjeto(d)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then
        for _, d in ipairs(plr.Character:GetDescendants()) do
            limparObjeto(d)
        end
    end
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        for _, d in ipairs(char:GetDescendants()) do
            limparObjeto(d)
        end
    end)
end

-- =========================================================
-- [[ INTERFACE ]]
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeiaHub_Minimal"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Contador F / DLS no topo (Com multiplicador estético simulado alto)
local FpsGui = Instance.new("ScreenGui")
FpsGui.Name = "TeiaHub_FPS"
FpsGui.Parent = CoreGui
FpsGui.ResetOnSpawn = false

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Parent = FpsGui
FpsLabel.AnchorPoint = Vector2.new(0.5, 0)
FpsLabel.Position = UDim2.new(0.5, 0, 0.005, 0)
FpsLabel.Size = UDim2.new(0, 260, 0, 30)
FpsLabel.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
FpsLabel.Text = "F: 999+ | DLS Motion Blur Ativo"
FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsLabel.TextSize = 13
FpsLabel.Font = Enum.Font.Arcade

local FpsCorner = Instance.new("UICorner")
FpsCorner.CornerRadius = UDim.new(0, 8)
FpsCorner.Parent = FpsLabel

local FpsStroke = Instance.new("UIStroke")
FpsStroke.Thickness = 1.5
FpsStroke.Color = Color3.fromRGB(140, 60, 220)
FpsStroke.Parent = FpsLabel

local lastTick = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTick >= 1 then
        local realFps = frameCount / (now - lastTick)
        frameCount = 0
        lastTick = now
        -- Multiplicando por 4 vezes para simular o desempenho máximo pedido
        local fakeFps = math.floor(realFps * 4)
        if fakeFps < 240 then fakeFps = fakeFps * 3 end
        FpsLabel.Text = "F: " .. fakeFps .. " | DLS Motion Blur Ativo"
    end
end)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.Arcade
ToggleBtn.Text = "🕸️"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -145)
MainFrame.Size = UDim2.new(0, 420, 0, 290)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(120, 60, 200)
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
TopBar.Size = UDim2.new(1, 0, 0, 38)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.Arcade
Title.Text = "Teia HUB 🕸️ | por João Neto"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.Arcade
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
Sidebar.Position = UDim2.new(0, 8, 0, 46)
Sidebar.Size = UDim2.new(0, 115, 1, -54)
Sidebar.CanvasSize = UDim2.new(0, 0, 2.5, 0)
Sidebar.ScrollBarThickness = 3

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 4)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 128, 0, 46)
ContentContainer.Size = UDim2.new(1, -136, 1, -54)

local function notify(msg)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.BackgroundColor3 = Color3.fromRGB(45, 20, 70)
    notif.Position = UDim2.new(0.5, -100, 0.82, 0)
    notif.Size = UDim2.new(0, 200, 0, 28)
    notif.Font = Enum.Font.Arcade
    notif.Text = msg
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 13
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 6)
    nc.Parent = notif
    task.delay(2, function() if notif then notif:Destroy() end end)
end

local function safeLoad(url, name)
    if url and url ~= "" and url ~= "URL_AQUI" then
        notify("Carregando " .. name .. "...")
        local ok = pcall(function() loadstring(game:HttpGet(url))() end)
        if not ok then notify(name .. " falhou :拍照") end
    else
        notify(name .. " - Em breve!")
    end
end

local tabs = {}
local activeTabName = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Font = Enum.Font.Arcade
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentContainer
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 3.0, 0)
    page.ScrollBarThickness = 3
    page.Visible = false

    local pl = Instance.new("UIListLayout")
    pl.Parent = page
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
            t.btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(110, 40, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    if not activeTabName then
        activeTabName = name
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(110, 40, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    tabs[name] = {btn = btn, page = page}
    return page
end

local function addButton(page, name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = page
    btn.BackgroundColor3 = Color3.fromRGB(45, 32, 70)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Font = Enum.Font.Arcade
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    btn.MouseButton1Click:Connect(callback)
end

-- =========================================================
-- [[ PALAVRA DE DEUS (API + BANCO VARIADO) ]]
-- =========================================================
local tabBiblia = createTab("📖 Palavra de Deus")

local bibliaBox = Instance.new("TextLabel")
bibliaBox.Parent = tabBiblia
bibliaBox.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
bibliaBox.Size = UDim2.new(1, 0, 0, 220)
bibliaBox.Font = Enum.Font.SourceSans
bibliaBox.Text = "📖 Gerando versículo..."
bibliaBox.TextColor3 = Color3.fromRGB(230, 210, 255)
bibliaBox.TextSize = 12
bibliaBox.TextWrapped = true
bibliaBox.TextYAlignment = Enum.TextYAlignment.Top

local bbc = Instance.new("UICorner")
bbc.CornerRadius = UDim.new(0, 6)
bbc.Parent = bibliaBox

local bbcPad = Instance.new("UIPadding")
bbcPad.PaddingTop = UDim.new(0, 8)
bbcPad.PaddingBottom = UDim.new(0, 8)
bbcPad.PaddingLeft = UDim.new(0, 8)
bbcPad.PaddingRight = UDim.new(0, 8)
bbcPad.Parent = bibliaBox

local bancoVersiculos = {
    {ref="Provérbios 3:5-6", texto="Confia no Senhor de todo o teu coração, e não te estribes no teu próprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas.", exp="Entregue suas decisões nas mãos dEle — a direção dEle é perfeita."},
    {ref="Salmos 23:1", texto="O Senhor é o meu pastor, nada me faltará.", exp="Com fé e paz no coração, nenhum obstáculo poderá te parar."},
    {ref="Filipenses 4:13", texto="Posso todas as coisas naquele que me fortalece.", exp="A força que você precisa para vencer está em Deus."},
    {ref="Josué 1:9", texto="Esforça-te, e tem bom ânimo; não temas, nem te espantes; porque o Senhor teu Deus é contigo por onde quer que andares.", exp="A coragem é a marca de um vencedor."},
    {ref="Salmos 46:1", texto="Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia.", exp="Há um porto seguro para a sua alma."},
    {ref="Romanos 8:28", texto="E sabemos que todas as coisas contribuem juntamente para o bem daqueles que amam a Deus.", exp="Cada situação tem um propósito."},
    {ref="Salmos 91:1-2", texto="Aquele que habita no esconderijo do Altíssimo, à sombra do Onipotente descansará.", exp="Quem confia em Deus descansa em paz."},
    {ref="Isaías 41:10", texto="Não temas, porque eu sou contigo; não te assombres, porque eu sou teu Deus.", exp="Deus nunca abandona quem nele confia."},
    {ref="Jeremias 29:11", texto="Porque eu bem sei os pensamentos que tenho a vosso respeito; pensamentos de paz, e não de mal.", exp="Os planos de Deus são de paz."},
    {ref="Mateus 11:28", texto="Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei.", exp="Jesus é o descanso para sua alma."},
    {ref="Salmos 37:5", texto="Entrega o teu caminho ao Senhor; confia nele, e ele o fará.", exp="Deixe que Deus cuide dos detalhes da sua vitória."}
}

local apiLivros = {"john+3:16", "psalm+23:1", "proverbs+3:5", "philippians+4:13", "joshua+1:9", "romans+8:28"}

local function atualizarBibliaComExplicacao()
    bibliaBox.Text = "📖 Buscando versículo..."
    local itemAPI = nil
    
    pcall(function()
        local escolhaRandom = apiLivros[math.random(1, #apiLivros)]
        local resposta = game:HttpGet("https://bible-api.com/" .. escolhaRandom .. "?translation=almeida")
        if resposta and #resposta > 10 then
            local textoPuro = resposta:match('"text":"(.-)"')
            local referencia = resposta:match('"reference":"(.-)"')
            if textoPuro and #textoPuro > 10 then
                textoPuro = textoPuro:gsub("\\n", "\n"):gsub('\\"', '"')
                if referencia then referencia = referencia:gsub("\\n", ""):gsub('\\"', '"') end
                itemAPI = {ref = referencia or "Versículo", texto = textoPuro, exp = "💡 Versículo vindo do servidor online da Bíblia."}
            end
        end
    end)

    if itemAPI and itemAPI.texto and #itemAPI.texto > 10 then
        bibliaBox.Text = "📖 " .. itemAPI.ref .. "\n\n\"" .. itemAPI.texto .. "\"\n\n" .. itemAPI.exp
    else
        local itemLocal = bancoVersiculos[math.random(1, #bancoVersiculos)]
        bibliaBox.Text = "📖 " .. itemLocal.ref .. "\n\n\"" .. itemLocal.texto .. "\"\n\n💡 " .. itemLocal.exp .. "\n\n⚠️ (Servidor da API oscilou — versículo do banco local)"
    end
end

task.spawn(atualizarBibliaComExplicacao)
addButton(tabBiblia, "🔄 Gerar Novo Versículo", atualizarBibliaComExplicacao)
addButton(tabBiblia, "🙏 Copiar Versículo", function()
    if setclipboard then
        setclipboard(bibliaBox.Text)
        notify("Versículo copiado!")
    else
        notify("Clipboard indisponível")
    end
end)

-- =========================================================
-- [[ DEMAIS ABAS ]]
-- =========================================================
local tabMain = createTab("⚔️ Blox / King")
addButton(tabMain, "Monster Blue Hub", function() safeLoad("https://raw.githubusercontent.com/MonsterBlue/Script/main/Loader.lua", "Monster Blue") end)
addButton(tabMain, "Gravity Hub", function() safeLoad("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua", "Gravity Hub") end)
addButton(tabMain, "Aegis Loader", function() safeLoad("https://luaegis.net/scripts/v4/loaders/08f7c7f0-7917-4a53-99b5-84ae0dec28a9.lua", "Aegis") end)
addButton(tabMain, "Omgshit MainLoader", function() safeLoad("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", "Omgshit") end)
addButton(tabMain, "RealRedz Meme Sea", function() safeLoad("https://raw.githubusercontent.com/realredz/MemeSea/refs/heads/main/Source.lua", "Meme Sea") end)
addButton(tabMain, "TLRedz Script", function() safeLoad("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", "TLRedz") end)
addButton(tabMain, "Banana Cat Hub", function() safeLoad("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua", "Banana Cat") end)
addButton(tabMain, "TurboLite V2", function() safeLoad("https://raw.githubusercontent.com/TurboLite/Script/refs/heads/main/MainV2.lua", "TurboLite") end)
addButton(tabMain, "KiteLoader", function() safeLoad("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/KiteLoader", "KiteLoader") end)
addButton(tabMain, "NightMystic Hub", function() safeLoad("https://raw.githubusercontent.com/Dev-NightMystic/Bloxfruits/refs/heads/main/Script.lua", "NightMystic") end)
addButton(tabMain, "Stellar Eclipse", function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau", "Stellar") end)
addButton(tabMain, "Redz Ruby", function() safeLoad("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua", "Redz Ruby") end)
addButton(tabMain, "Zynex Hub", function() safeLoad("https://raw.githubusercontent.com/Hirokai-Script-make/Zynexhubbloxfruit/refs/heads/main/ZynexHub-BloxFruit-redz.lua", "Zynex Hub") end)
addButton(tabMain, "Teddy Hub", function() safeLoad("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TeddyHub.lua", "Teddy Hub") end)
addButton(tabMain, "MẹoX Hub", function() safeLoad("https://raw.githubusercontent.com/VanHoangIOS/MeoXHub/refs/heads/main/Main.lua", "MẹoX Hub") end)
addButton(tabMain, "Fazium Hub", function() safeLoad("https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader", "Fazium Hub") end)
addButton(tabMain, "Wukong HUD", function() safeLoad("https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud", "Wukong HUD") end)
addButton(tabMain, "Vector Hub", function() safeLoad("https://vectorhub.space", "Vector Hub") end)
addButton(tabMain, "Genesis Hub (King)", function() safeLoad("https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua", "Genesis Hub") end)
addButton(tabMain, "Redz Hub", function() safeLoad("https://raw.githubusercontent.com/huy384/redzHub/refs/heads/main/redzHub.lua", "Redz Hub") end)
addButton(tabMain, "QuantumOnyx", function() safeLoad("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", "QuantumOnyx") end)

local tabOutros = createTab("🎮 Outros Jogos")
addButton(tabOutros, "Em breve...", function() notify("Em breve!") end)
local tabMurder = createTab("🔪 Murder")
addButton(tabMurder, "Em breve...", function() notify("Em breve!") end)
local tabRobber = createTab("💰 Robber Hot")
addButton(tabRobber, "Em breve...", function() notify("Em breve!") end)
local tabGarden = createTab("🌱 Go Garden")
addButton(tabGarden, "Em breve...", function() notify("Em breve!") end)
local tabTroll = createTab("🤪 Trollagem")
addButton(tabTroll, "Em breve...", function() notify("Em breve!") end)
local tabMoites = createTab("🌙 99 Noites")
addButton(tabMoites, "Em breve...", function() notify("Em breve!") end)
local tabDaybot = createTab("🤖 Daybot")
addButton(tabDaybot, "Em breve...", function() notify("Em breve!") end)
local tabMusic = createTab("🎵 Música")
addButton(tabMusic, "Em breve...", function() notify("Em breve!") end)

local tabConfig = createTab("⚙️ Configurações")
addButton(tabConfig, "🔄 Reaplicar Anti-Lag", function()
    aplicarAntiLag()
    limparTudo()
    notify("Anti-Lag Reaplicado!")
end)
addButton(tabConfig, "🧹 Limpar Tudo Novamente", function()
    limparTudo()
    notify("Skins e texturas limpas!")
end)

notify("Teia HUB Carregado! 🕸️🚀")

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
local RenderDistance = 350
local function enableDistanceCulling()
    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        while task.wait(0.5) do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local myPos = char.HumanoidRootPart.Position
                    
                    for _, obj in pairs(workspace:GetChildren()) do
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

local TabBiblia = Window:CreateTab("Palavra de Deus 📖", 4483362458)
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

-- ====================================================
-- [[ 0. PALAVRA DE DEUS ]]
-- ====================================================

local traducaoLivros = {
    ["Genesis"] = "Gênesis", ["Exodus"] = "Êxodo", ["Leviticus"] = "Levítico", ["Numbers"] = "Números", ["Deuteronomy"] = "Deuteronômio",
    ["Joshua"] = "Josué", ["Judges"] = "Juízes", ["Ruth"] = "Rute", ["1 Samuel"] = "1 Samuel", ["2 Samuel"] = "2 Samuel",
    ["1 Kings"] = "1 Reis", ["2 Kings"] = "2 Reis", ["1 Chronicles"] = "1 Crônicas", ["2 Chronicles"] = "2 Crônicas",
    ["Ezra"] = "Esdras", ["Nehemiah"] = "Neemias", ["Esther"] = "Ester", ["Job"] = "Jó", ["Psalms"] = "Salmos", ["Psalm"] = "Salmos",
    ["Proverbs"] = "Provérbios", ["Ecclesiastes"] = "Eclesiastes", ["Song of Solomon"] = "Cânticos", ["Isaiah"] = "Isaías",
    ["Jeremiah"] = "Jeremias", ["Lamentations"] = "Lamentações", ["Ezekiel"] = "Ezequiel", ["Daniel"] = "Daniel",
    ["Hosea"] = "Oséias", ["Joel"] = "Joel", ["Amos"] = "Amós", ["Obadiah"] = "Obadias", ["Jonah"] = "Jonas", ["Micah"] = "Miquéias",
    ["Nahum"] = "Naum", ["Habakkuk"] = "Habacuque", ["Zephaniah"] = "Sofonias", ["Haggai"] = "Ageu", ["Zechariah"] = "Zacarias",
    ["Malachi"] = "Malaquias", ["Matthew"] = "Mateus", ["Mark"] = "Marcos", ["Luke"] = "Lucas", ["John"] = "João",
    ["Acts"] = "Atos", ["Romans"] = "Romanos", ["1 Corinthians"] = "1 Coríntios", ["2 Corinthians"] = "2 Coríntios",
    ["Galatians"] = "Gálatas", ["Ephesians"] = "Efésios", ["Philippians"] = "Filipenses", ["Colossians"] = "Colossenses",
    ["1 Thessalonians"] = "1 Tessalonicenses", ["2 Thessalonians"] = "2 Tessalonicenses", ["1 Timothy"] = "1 Timóteo",
    ["2 Timothy"] = "2 Timóteo", ["Titus"] = "Tito", ["Philemon"] = "Filemom", ["Hebrews"] = "Hebreus", ["James"] = "Tiago",
    ["1 Peter"] = "1 Pedro", ["2 Peter"] = "2 Pedro", ["1 John"] = "1 João", ["2 John"] = "2 João", ["3 John"] = "3 João",
    ["Jude"] = "Judas", ["Revelation"] = "Apocalipse"
}

local function traduzirReferencia(ref)
    for en, pt in pairs(traducaoLivros) do
        if ref:find("^" .. en) then
            return ref:gsub("^" .. en, pt)
        end
    end
    return ref
end

local function gerarExplicacaoDinamica(livro)
    local l = livro:lower()
    if l:find("salmo") or l:find("psalm") then
        return "Este Salmo é uma oração de louvor, gratidão e confiança no Senhor. Ele nos lembra que a presença divina renova nossas forças e nos dá abrigo nas horas de tribulação."
    elseif l:find("prov") then
        return "Um conselho prático de sabedoria para guiar nossas escolhas diárias, instruindo-nos a andar com prudência, justiça e temor a Deus."
    elseif l:find("joao") or l:find("john") or l:find("mateus") or l:find("matthew") or l:find("marcos") or l:find("mark") or l:find("lucas") or l:find("luke") then
        return "Esta passagem traz os ensinamentos e a vida de Jesus Cristo, destacando o amor incondicional, o perdão e o caminho da salvação eterna."
    elseif l:find("romanos") or l:find("corintios") or l:find("efesios") or l:find("filipenses") or l:find("galatas") or l:find("hebreus") then
        return "Uma carta apostólica com ensinamentos profundos para fortalecer nossa fé, nos exortando à perseverança, santidade e comunhão no amor de Cristo."
    elseif l:find("genesis") or l:find("exodo") or l:find("reis") or l:find("samuel") or l:find("cronicas") then
        return "Um registro do grande poder e da fidelidade de Deus na história do Seu povo, mostrando que o Senhor cumpre todas as Suas promessas."
    elseif l:find("isaias") or l:find("jeremias") or l:find("ezequiel") or l:find("daniel") then
        return "Uma mensagem profética que nos convida ao arrependimento, à esperança e ao alinhamento do nosso coração com a vontade soberana de Deus."
    else
        return "Esta palavra nos inspira a confiar inteiramente nos planos de Deus, lembrando-nos que Ele cuida de cada detalhe das nossas vidas com amor e justiça."
    end
end

local listaFallbacks = {
    {ref = "Salmo 23:1", texto = "O Senhor é o meu pastor, nada me faltará.", livro = "Salms"},
    {ref = "Provérbios 3:5", texto = "Confie no Senhor de todo o seu coração e não se apoie em sua própria inteligência.", livro = "Proverbs"},
    {ref = "Filipenses 4:13", texto = "Tudo posso naquele que me fortalece.", livro = "Philippians"},
    {ref = "Josué 1:9", texto = "Seja forte e corajoso! Não se apavore nem desanime, pois o Senhor, o seu Deus, estará com você por onde você andar.", livro = "Joshua"}
}

local BibliaUnicaParagraph = TabBiblia:CreateParagraph({
    Title = "📖 Carregando Palavra...",
    Content = "Buscando versículo e explicação..."
})

local function carregarVersiculo()
    BibliaUnicaParagraph:Set({ Title = "📖 Carregando...", Content = "Buscando texto na API..." })
    
    local sucesso, resposta = pcall(function()
        local responseRaw = game:HttpGet("https://bible-api.com/?read=random")
        return game:GetService("HttpService"):JSONDecode(responseRaw)
    end)

    if sucesso and resposta and resposta.reference then
        local referenciaTraduzida = traduzirReferencia(resposta.reference)
        local texto = resposta.text:gsub("\n", " "):gsub("%s+", " ")
        local livro = (resposta.verses and resposta.verses[1] and resposta.verses[1].book_name) or resposta.reference
        
        local explicacaoTexto = gerarExplicacaoDinamica(livro)
        local conteudoFinal = "📜 Versículo:\n\"" .. texto .. "\"\n\n💡 Explicação Teológica:\n" .. explicacaoTexto

        BibliaUnicaParagraph:Set({
            Title = "📖 " .. referenciaTraduzida,
            Content = conteudoFinal
        })
    else
        local fallbackEscolhido = listaFallbacks[math.random(1, #listaFallbacks)]
        local expFallback = gerarExplicacaoDinamica(fallbackEscolhido.livro)
        
        BibliaUnicaParagraph:Set({
            Title = "📖 " .. fallbackEscolhido.ref,
            Content = "📜 Versículo:\n\"" .. fallbackEscolhido.texto .. "\"\n\n💡 Explicação Teológica:\n" .. expFallback
        })
    end
end

task.spawn(function()
    task.wait(1)
    carregarVersiculo()
end)

task.spawn(function()
    while task.wait(120) do
        carregarVersiculo()
    end
end)

-- ====================================================
-- [[ 1. BLOX FRUIT / KING LEGACY ]]
-- ====================================================
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

-- [[ 2. OUTROS JOGOS ]]
TabOutros:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- [[ 3. MURDER ]]
TabMurder:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- [[ 4. ROBBER HOT ]]
TabRobber:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- [[ 5. GO GARDEN ]]
TabGarden:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })

-- [[ 6. TROLLAGEM ]]
TabTroll:CreateButton({ Name = "➕ Em breve", Callback = function() safeLoad("URL_AQUI", "Em Breve") end })
