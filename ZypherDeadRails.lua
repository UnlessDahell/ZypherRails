local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Zypher Script Loader (.gg/aTNg2Dcw)",
    Icon = 82284779245358,
    LoadingTitle = "Wait until UI load up",
    LoadingSubtitle = "by Sir.Zypher and Eyes Sight",
    Theme = "nil",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = false,
        FolderName = "Zypher",
        FileName = "Zypher"
    },

    Discord = {
        Enabled = false,
        Invite = "https://discord.gg/aTNg2Dcw",
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "none",
        Subtitle = "none",
        Note = "none",
        FileName = "ZTeam",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"nil"},
    }
})
