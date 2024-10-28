getgenv().Setting = {
    ["Team"] = "Marines",
    ["Chat"] = {},
    ["Skip Race V4"] = true,
    ["Misc"] = {
        ["Click Delay"] = 1.09,
        ["Enable Lock Bounty"] = false,
        ["Lock Bounty"] = {0, 300000000},
        ["Hide Health"] = {4000,5000},
        ["Lock Camera"] = false,
        ["Enable Cam Farm"] = false,
        ["White Screen"] = false,
        ["FPS Boost"] = true,
        ["Tween"] = true,
        ["Random & Store Fruit"] = false,
    },
    ["Item"] = {
        ["Melee"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.5},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1},
            ["C"] = {["Enable"] = true, ["Hold Time"] = 0.1}
        },
        ["Blox Fruit"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 1.2},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.2},
            ["C"] = {["Enable"] = true, ["Hold Time"] = 0.1},
            ["V"] = {["Enable"] = true, ["Hold Time"] = 0.2},
            ["F"] = {["Enable"] = true, ["Hold Time"] = 0}
        },
        ["Sword"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.1},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}
        },
        ["Gun"] = {["Enable"] = false,
            ["Z"] = {["Enable"] = true, ["Hold Time"] = 0.1},
            ["X"] = {["Enable"] = true, ["Hold Time"] = 0.1}
        }
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Legityt252/35/refs/heads/main/aimbotquinho.txt"))()