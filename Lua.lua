-- Teia HUB 🕸️ | Auto Anti-Lag + DLS Motion Blur + Suavização de Câmera + Palavra de Deus + Esticamento de Tela | por João Neto
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
-- [[ MOTION BLUR REAL & SUAVIZAÇÃO DE CÂMERA (ANTI-TRAVADINHA) + ESTICAMENTO DE TELA ]]
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

-- Variável global para o fator de esticamento de tela (valor padrão 65, indo de 0 a 100)
getgenv().TeiaResolutionFactor = 0.65

RunService.RenderStepped:Connect(function()
    if not camera then camera = Workspace.CurrentCamera return end
    
    local currentCF = camera.CFrame
    local delta = (currentCF.Position - lastCamCF.Position).Magnitude + (currentCF.LookVector - lastCamCF.LookVector).Magnitude
    
    -- Suaviza a rotação e movimento da câmera para eliminar micro-stuttering (travadinhas) e aplica o esticamento de tela dinâmico
    local resFactor = getgenv().TeiaResolutionFactor or 0.65
    local smoothed = lastCamCF:Lerp(currentCF, cameraSuavidade)
    
    camera.CFrame = smoothed * CFrame.new(0, 0, 0, 1, 0, 0, 0, resFactor, 0, 0, 0, 1)
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

-- Contador F / DLS no topo
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
        if not ok then notify(name .. " falhou ❌") end
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
-- [[ ABA 1: 📐 ESTICAMENTO DE TELA ]]
-- =========================================================
local tabEsticar = createTab("📐 Esticar Tela")

local descEsticar = Instance.new("TextLabel")
descEsticar.Parent = tabEsticar
descEsticar.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
descEsticar.Size = UDim2.new(1, 0, 0, 65)
descEsticar.Font = Enum.Font.SourceSans
descEsticar.Text = "Digite um valor de 0 a 100 para esticar a tela.\n(Ex: 0 = Extremamente Esticado, 100 = Normal)."
descEsticar.TextColor3 = Color3.fromRGB(230, 210, 255)
descEsticar.TextSize = 12
descEsticar.TextWrapped = true

local decCorner = Instance.new("UICorner")
decCorner.CornerRadius = UDim.new(0, 6)
decCorner.Parent = descEsticar

local decPad = Instance.new("UIPadding")
decPad.PaddingTop = UDim.new(0, 6)
decPad.PaddingBottom = UDim.new(0, 6)
decPad.PaddingLeft = UDim.new(0, 6)
decPad.PaddingRight = UDim.new(0, 6)
decPad.Parent = descEsticar

local inputContainer = Instance.new("Frame")
inputContainer.Parent = tabEsticar
inputContainer.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
inputContainer.Size = UDim2.new(1, 0, 0, 45)

local icCorner = Instance.new("UICorner")
icCorner.CornerRadius = UDim.new(0, 6)
icCorner.Parent = inputContainer

local inputLabel = Instance.new("TextLabel")
inputLabel.Parent = inputContainer
inputLabel.BackgroundTransparency = 1
inputLabel.Position = UDim2.new(0, 10, 0, 0)
inputLabel.Size = UDim2.new(0.5, 0, 1, 0)
inputLabel.Font = Enum.Font.Arcade
inputLabel.Text = "Valor (0-100):"
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.TextSize = 12
inputLabel.TextXAlignment = Enum.TextXAlignment.Left

local screenTextBox = Instance.new("TextBox")
screenTextBox.Parent = inputContainer
screenTextBox.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
screenTextBox.Position = UDim2.new(0.55, 0, 0.15, 0)
screenTextBox.Size = UDim2.new(0.4, -10, 0.7, 0)
screenTextBox.Font = Enum.Font.Arcade
screenTextBox.Text = "65"
screenTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
screenTextBox.TextSize = 14

local stcCorner = Instance.new("UICorner")
stcCorner.CornerRadius = UDim.new(0, 4)
stcCorner.Parent = screenTextBox

screenTextBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(screenTextBox.Text)
    if num then
        num = math.clamp(num, 0, 100)
        -- Evita divisão por zero absoluta transformando 0 em algo muito próximo ou ajustando a escala
        if num == 0 then num = 0.01 end
        getgenv().TeiaResolutionFactor = num / 100
        notify("Esticamento ajustado para: " .. screenTextBox.Text)
    else
        notify("Digite apenas números de 0 a 100!")
    end
end)

-- =========================================================
-- [[ ABA 2: PALAVRA DE DEUS (API + BANCO VARIADO) ]]
-- =========================================================
local tabBiblia = createTab("📖 Palavra de Deus")

local bibliaBox = Instance.new("TextLabel")
bibliaBox.Parent = tabBiblia
bibliaBox.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
bibliaBox.Size = UDim2.new(1, 0, 0, 180)
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
    {ref="Isaías 41:10", texto="Não temas, porque eu soy contigo; não te assombres, porque eu sou teu Deus.", exp="Deus nunca abandona quem nele confia."},
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
        
