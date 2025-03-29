local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()

local Window = Luna:CreateWindow({
	Name = "Zypher Hub (Luna UI)", 
	Subtitle = "By Maam.Zypher and Eyes Sight", 
	LogoID = "82795327169782", 
	LoadingEnabled = true, 
	LoadingTitle = "Wait Until Luna UI Load Up", 
	LoadingSubtitle = "By Maam.Zypher and Eyes Sight", 

	ConfigSettings = {
		RootFolder = "Zypher", 
		ConfigFolder = "ZypherConfig" 
	},

	KeySystem = false, 
	KeySettings = {
		Title = "Keysystem",
		Subtitle = "Key System",
		Note = "There no key buddy",
		SaveInRoot = true, 
		SaveKey = true, 
		Key = {"Key"}, 
		SecondAction = {
			Enabled = true, 
			Type = "https://discord.gg/ere8H6q9", 
			Parameter = ".gg/ere8H6q9" 
		}
	}
})
