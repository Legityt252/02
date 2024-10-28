-- Script para deixar o mapa invisível no Blox Fruits
for _, part in pairs(game.Workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Transparency = 1
        if part:FindFirstChildOfClass("Decal") then
            part:FindFirstChildOfClass("Decal").Transparency = 1
        end
    end
end







-- Max level, godhuman, CDK, soul guitar
getgenv().Configs = {
    ["Team"] = "Pirates",
    ["FPS Boost"] = false,
    ["Farm Boss Drops"] = {
        ["Enable"] = true,
        ["When x2 Exp Expired"] = true
    },
    ["Hop Player Near"] = false,
    ["Soul Guitar"] = true,
    ["Find Fruit"] = false, -- Will find 1m+ fruit to unlock swan door to access third sea
    ["Cursed Dual Katana"] = true
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Legityt252/02/refs/heads/main/jssj.lua"))()

