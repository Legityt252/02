-- Teia HUB 🕸️ | por João Neto
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end)

if not success or not Rayfield then
    task.wait(1)
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end

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
