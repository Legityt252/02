
-- Teia HUB 🕸️ | Executador Direto por João Neto
local urlDoOutroScript = "https://pastebin.com/raw/m77A3Psg" -- Ex: "https://pastebin.com/raw/seu_codigo"

local sucesso, erro = pcall(function()
    loadstring(game:HttpGet(urlDoOutroScript))()
end)

if sucesso then
    print("Script externo carregado e executado com sucesso!")
else
    warn("Erro ao carregar o script externo: " .. tostring(erro))
end
