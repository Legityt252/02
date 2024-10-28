loadstring(game:HttpGet("https://raw.githubusercontent.com/Legityt252/Tiktok-fake-D/refs/heads/main/Annie-Hub.lua.txt"))()
-- Script para deixar o mapa invisível no Blox Fruits
for _, part in pairs(game.Workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Transparency = 1
        if part:FindFirstChildOfClass("Decal") then
            part:FindFirstChildOfClass("Decal").Transparency = 1
        end
    end
end