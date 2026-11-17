getgenv().FlowHubConfig = getgenv().FlowHubConfig or {}
local FlowHubConfig = getgenv().FlowHubConfig
local API_URL = FlowHubConfig.ApiUrl or "https://api-unan.vercel.app/api"
local DISCORD_INVITE = FlowHubConfig.Discord or "https://discord.gg/B6AYjVJKf"
local FLOW_ICON = "rbxassetid://129402195808838"


local t1 = {
	Frases = loadstring(game:HttpGet("https://raw.githubusercontent.com/realgengar/Brookhaven/refs/heads/main/translations.lua"))()
}
local idioma = (game.Players.LocalPlayer.LocaleId or "en-US"):sub(1, 2):lower()

if not t1.Frases[idioma] then
	idioma = "en"
end

t1.Idioma = idioma
t1.traduzir = function(p1, p2)
	return p1.Frases[p1.Idioma][p2] or p2
end

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

game:GetService("VirtualInputManager")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

game:GetService("MarketplaceService")
game:GetService("TeleportService")

local lib = (function()







local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local genv = (getgenv and getgenv()) or _G
if genv.FlowHubUI then pcall(function() genv.FlowHubUI:Destroy() end) end

local Lib = { Lang = "en", Dict = { pt = {} }, Version = "1.0.0" }
pcall(function() (getgenv and getgenv() or _G).FlowLib = Lib end)
local Connections = {}
local function connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(Connections, c)
	return c
end


local ICON_ID = "122659805107067"
local BRAND, SIGNATURE = "Flow Hub", "BROOK-RP"
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local WIN_W, WIN_H = 600, 340
local SIDE_W, HEAD_H = 150, 46
local DEVICE_SCALE = IS_MOBILE and 0.9 or 1.15
local BUTTON_SIZE = IS_MOBILE and 46 or 64
local BS = IS_MOBILE and 28 or 32
local ROW_H, ROW_HD = 30, 38

local T = {
	BG = Color3.fromRGB(18, 24, 52),
	SIDE = Color3.fromRGB(10, 11, 14),
	ROW = Color3.fromRGB(20, 26, 54),
	SELECT = Color3.fromRGB(38, 52, 108),
	ACCENT = Color3.fromRGB(56, 88, 190),
	ACCENT2 = Color3.fromRGB(150, 175, 240),
	TEXT = Color3.fromRGB(236, 240, 250),
	MUTED = Color3.fromRGB(145, 152, 172),
	STROKE = Color3.fromRGB(48, 54, 82),
	GOOD = Color3.fromRGB(70, 255, 170),
	WARN = Color3.fromRGB(255, 205, 90),
	BAD = Color3.fromRGB(255, 80, 100),
	GLOW_A = Color3.fromRGB(52, 80, 170),
	GLOW_B = Color3.fromRGB(18, 19, 24),
	BLUE = Color3.fromRGB(30, 44, 104),
	BLACK = Color3.fromRGB(13, 14, 18),
}
Lib.Theme = T


local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end
local function corner(p, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, p) end
local function stroke(p, color, thick, transp)
	return new("UIStroke", { Color = color or T.STROKE, Thickness = thick or 1, Transparency = transp or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, p)
end
local function pad(p, l, r, t, b)
	return new("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r), PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b) }, p)
end
local function tween(o, props, t, style)
	TweenService:Create(o, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function assetUrl(id)
	id = tostring(id or "")
	if id == "" then return "" end
	if id:match("^%d+$") then return "rbxassetid://" .. id end
	return id
end
local function guiParent()
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and h then return h end
	if pcall(function() return CoreGui.Name end) then return CoreGui end
	return LocalPlayer:WaitForChild("PlayerGui")
end
local function labelOf(parent, text, size, color, font, align)
	return new("TextLabel", {
		BackgroundTransparency = 1, Text = text or "", TextSize = size or 13, TextColor3 = color or T.TEXT,
		Font = font or Enum.Font.GothamMedium, TextXAlignment = align or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center, RichText = false, Active = false,
	}, parent)
end


local function glyph(parent, kind, color, size, pos, z)
	local holder = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5), Position = pos or UDim2.fromScale(0.5, 0.5), Active = false, ZIndex = z or 5 }, parent)
	local bars = {}
	local L = size * 0.6
	local function bar(rot, dx, dy)
		local b = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = color, BorderSizePixel = 0, Size = UDim2.fromOffset(L, 2), Position = UDim2.new(0.5, dx, 0.5, dy), Rotation = rot, Active = false, ZIndex = (z or 5) + 1 }, holder)
		corner(b, 1)
		table.insert(bars, b)
	end
	local o = L * 0.28
	if kind == "x" then bar(45, 0, 0); bar(-45, 0, 0)
	elseif kind == "down" then bar(45, -o, 0); bar(-45, o, 0)
	elseif kind == "up" then bar(-45, -o, 0); bar(45, o, 0)
	else bar(45, 0, -o); bar(-45, 0, o) end
	local g = { Frame = holder }
	function g:SetColor(c) for _, b in ipairs(bars) do tween(b, { BackgroundColor3 = c }, 0.12) end end
	return g
end


local LucideLib
local function lucide(names)
	if LucideLib == nil then
		LucideLib = false
		pcall(function() LucideLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua"))() end)
	end
	if not LucideLib then return nil end
	for _, n in ipairs(names) do
		local ok, a = pcall(LucideLib.GetAsset, n)
		if ok and a then return a end
	end
	return nil
end
local ICONS = {
	["ℹ"] = { "info" }, ["🏠"] = { "house", "home" }, ["🎉"] = { "party-popper", "sparkle" }, ["✨"] = { "sparkles" },
	["🧱"] = { "boxes", "box", "package" }, ["🌌"] = { "moon-star", "moon" }, ["👕"] = { "shirt" }, ["🛡"] = { "shield-check", "shield" },
	["👤"] = { "user" }, ["😈"] = { "flame", "skull" }, ["🚗"] = { "car" }, ["🌀"] = { "orbit", "tornado" },
	["⚙"] = { "settings", "cog" }, ["📜"] = { "scroll-text", "scroll", "file-text" }, ["📁"] = { "folder" },
	["👻"] = { "ghost", "skull" }, ["🎯"] = { "crosshair", "target" }, ["🏘"] = { "house", "building", "home" }, ["🎵"] = { "volume-2", "music" },
	["💣"] = { "bomb", "server-crash", "zap" }, ["📝"] = { "type", "signature", "pencil" }, ["👶"] = { "baby", "smile" }, ["🎒"] = { "backpack", "package" }, ["🌐"] = { "globe", "plane" }, ["🖥"] = { "server", "hard-drive", "monitor" },
}
local function iconFor(spec)
	if type(spec) ~= "string" or spec == "" then return nil, "📁" end
	if spec:match("^[%a][%w_%-]*$") then return lucide({ spec }), "📁" end
	local key = spec:gsub(utf8.char(0xFE0F), "")
	return lucide(ICONS[key] or ICONS["📁"]), spec
end


local registry = {}
local reverseCache = nil
local function reverseDict()
	if reverseCache then return reverseCache end
	reverseCache = {}
	for en, pt in pairs(Lib.Dict.pt) do reverseCache[pt] = en end
	return reverseCache
end
Lib.PT2EN = {}
local function norm(text)
	if type(text) == "string" then return Lib.PT2EN[text] or text end
	return text
end
local function translate(text, from, to)
	if type(text) ~= "string" or text == "" then return text end
	if Lib.PT2EN[text] then
		if to == "pt" then return text end
		text = Lib.PT2EN[text]; from = "en"
	end
	if from == to then return text end
	if to == "pt" and Lib.Dict.pt[text] then return Lib.Dict.pt[text] end
	if to == "en" and reverseDict()[text] then return reverseDict()[text] end
	if Lib.Translator then
		local ok, r = pcall(Lib.Translator, from, to, text)
		if ok and type(r) == "string" then return r end
	end
	return text
end

local origin, shown = {}, {}
local function tr(inst, text)
	inst.Text = translate(text, "en", Lib.Lang)
	origin[inst] = text; shown[inst] = inst.Text
	registry[inst] = true
	return inst
end
Lib.PlayerGroups = {}
function Lib:PlayerGroup(id)
	local g = Lib.PlayerGroups[id]
	if not g then g = { toggles = {} }; Lib.PlayerGroups[id] = g end
	return g
end
function Lib:AddPairs(list)
	for _, pr in ipairs(list) do Lib.PT2EN[pr[1]] = pr[2]; Lib.Dict.pt[pr[2]] = pr[1] end
	reverseCache = nil
end
function Lib:AddDictionary(pt)
	for en, p in pairs(pt) do Lib.Dict.pt[en] = p end
	reverseCache = nil
end
function Lib:T(text) return translate(text, "en", Lib.Lang) end
local langListeners = {}
function Lib:SetLanguage(lang)
	if lang ~= "en" and lang ~= "pt" then return end
	local old = Lib.Lang
	if old == lang then return end
	Lib.Lang = lang
	for inst in pairs(registry) do
		if inst.Parent then
			local okp, cur = pcall(function() return inst.Text end)
			if okp then
				if origin[inst] and shown[inst] == cur then inst.Text = translate(origin[inst], "en", lang)
				else inst.Text = translate(cur, old, lang) end
				shown[inst] = inst.Text
			end
			local okh, ph = pcall(function() return inst.PlaceholderText end)
			if okh and ph and ph ~= "" then inst.PlaceholderText = translate(ph, old, lang) end
		else
			registry[inst] = nil
		end
	end
	for _, fn in ipairs(langListeners) do pcall(fn, lang) end
end
function Lib:OnLanguage(fn) table.insert(langListeners, fn) end


local Gui = new("ScreenGui", { Name = "FlowHubUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, IgnoreGuiInset = true })
pcall(function() if syn and syn.protect_gui then syn.protect_gui(Gui) end end)
Gui.Parent = guiParent()
genv.FlowHubUI = { Destroy = function() for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end Gui:Destroy() end }
Lib.Gui = Gui

local function viewport()
	local cam = workspace.CurrentCamera
	return cam and cam.ViewportSize or Vector2.new(1280, 720)
end


local function makeDraggable(handle, target, onTap)
	local dragging, startInput, startPos, moved = false, nil, nil, 0
	connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, moved = true, 0
			startInput = input.Position
			startPos = target.Position
			local c; c = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					c:Disconnect()
					if onTap and moved < 8 then onTap() end
				end
			end)
		end
	end)
	connect(UserInputService.InputChanged, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - startInput
			moved = math.max(moved, d.Magnitude)
			if moved >= 8 or not onTap then
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end
	end)
end


local Window = new("Frame", {
	Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(WIN_W, WIN_H), BackgroundColor3 = T.BG, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, Gui)
corner(Window, 16)
local WinScale = new("UIScale", {}, Window)
local WinStroke = stroke(Window, Color3.new(1, 1, 1), 2)
local WinGrad = new("UIGradient", { Color = ColorSequence.new(T.GLOW_A, T.GLOW_B) }, WinStroke)
Window.BackgroundColor3 = Color3.new(1, 1, 1)
new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, T.BLUE), ColorSequenceKeypoint.new(0.5, T.BLUE), ColorSequenceKeypoint.new(0.501, T.BLACK), ColorSequenceKeypoint.new(1, T.BLACK) }), Rotation = 35 }, Window)


local Glow = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = false, ZIndex = 0, Visible = false }, Window)
corner(Glow, 16)
new("UIGradient", { Color = ColorSequence.new(T.GLOW_A, T.GLOW_B), Rotation = 35, Transparency = NumberSequence.new(0.8) }, Glow)


local Embers = new("Folder", { Name = "Embers" }, Window)
do
	local rng = Random.new()
	for i = 1, 8 do
		local e = new("Frame", {
			Size = UDim2.fromOffset(rng:NextInteger(2, 4), rng:NextInteger(2, 4)), BackgroundColor3 = T.ACCENT2,
			BackgroundTransparency = 0.5, BorderSizePixel = 0, Active = false, ZIndex = 1,
			Position = UDim2.new(rng:NextNumber(0.28, 0.98), 0, 1.02, 0),
		}, Embers)
		corner(e, 4)
		task.spawn(function()
			task.wait(rng:NextNumber(0, 6))
			while Gui.Parent do
				e.Position = UDim2.new(rng:NextNumber(0.28, 0.98), 0, 1.02, 0)
				e.BackgroundTransparency = 0.4
				local dur = rng:NextNumber(6, 11)
				local t = TweenService:Create(e, TweenInfo.new(dur, Enum.EasingStyle.Sine), { Position = UDim2.new(e.Position.X.Scale + rng:NextNumber(-0.06, 0.06), 0, -0.05, 0), BackgroundTransparency = 1 })
				t:Play()
				t.Completed:Wait()
			end
		end)
	end
end

local targetScale, animating = 1, false
local function applyScale()
	local vp = viewport()
	local fit = math.min((vp.X - 24) / WIN_W, (vp.Y - 24) / WIN_H)
	targetScale = math.clamp(math.min(DEVICE_SCALE, fit), 0.4, 1.3)
	if not animating then WinScale.Scale = targetScale end
end
applyScale()
if workspace.CurrentCamera then connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), applyScale) end


local Side = new("Frame", { Name = "Sidebar", Size = UDim2.new(0, SIDE_W, 1, 0), BackgroundColor3 = T.SIDE, BorderSizePixel = 0, ZIndex = 2 }, Window)
corner(Side, 16)
new("Frame", { Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundColor3 = T.SIDE, BorderSizePixel = 0, ZIndex = 1 }, Side)
new("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = T.STROKE, BorderSizePixel = 0, ZIndex = 3 }, Side)

local Brand = new("Frame", { Size = UDim2.new(1, -16, 0, 46), Position = UDim2.fromOffset(8, 8), BackgroundColor3 = T.ROW, BorderSizePixel = 0, ZIndex = 3 }, Side)
corner(Brand, 12); stroke(Brand, T.STROKE, 1)
local Logo = new("ImageLabel", { Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(7, 7), BackgroundTransparency = 1, Image = assetUrl(132430769217267), ZIndex = 4, ScaleType = Enum.ScaleType.Fit }, Brand)
corner(Logo, 8)
local BrandName = labelOf(Brand, BRAND, 14, T.TEXT, Enum.Font.GothamBold)
BrandName.Position = UDim2.fromOffset(46, 6); BrandName.Size = UDim2.new(1, -50, 0, 18); BrandName.ZIndex = 4
local BrandSign = labelOf(Brand, SIGNATURE, 10, T.ACCENT2, Enum.Font.GothamMedium)
BrandSign.Position = UDim2.fromOffset(46, 24); BrandSign.Size = UDim2.new(1, -50, 0, 14); BrandSign.ZIndex = 4

local TabList = new("ScrollingFrame", {
	Name = "Tabs", Position = UDim2.fromOffset(0, 62), Size = UDim2.new(1, 0, 1, -86), BackgroundTransparency = 1, BorderSizePixel = 0,
	ScrollBarThickness = 2, ScrollBarImageColor3 = T.ACCENT, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3,
}, Side)
pad(TabList, 8, 8, 2, 4)
new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, TabList)
local Footer = labelOf(Side, "FlothanBR", 9, T.MUTED, Enum.Font.Gotham, Enum.TextXAlignment.Center)
Footer.Font = Enum.Font.GothamBold; Footer.TextSize = 11; Footer.TextColor3 = T.ACCENT2; Footer.Size = UDim2.new(1, 0, 0, 18); Footer.Position = UDim2.new(0, 0, 1, -22); Footer.ZIndex = 3


local Head = new("Frame", { Name = "Header", Position = UDim2.fromOffset(SIDE_W, 0), Size = UDim2.new(1, -SIDE_W, 0, HEAD_H), BackgroundTransparency = 1, Active = true, ZIndex = 2 }, Window)
local HEAD_RES = 12 + (BS + 6) * 2 + 8
local HeadIcon = new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), ImageColor3 = T.ACCENT2, Visible = false, ZIndex = 3 }, Head)
local HeadTitle = labelOf(Head, "", 19, T.TEXT, Enum.Font.GothamBold)
HeadTitle.AnchorPoint = Vector2.new(0, 0.5); HeadTitle.Position = UDim2.new(0, 14, 0.5, 0); HeadTitle.Size = UDim2.new(1, -(HEAD_RES + 24), 0, 26); HeadTitle.TextTruncate = Enum.TextTruncate.AtEnd; HeadTitle.ZIndex = 3
local HeadDesc = labelOf(Head, "", 10, T.MUTED, Enum.Font.Gotham)
HeadDesc.Visible = false; HeadDesc.Position = UDim2.fromOffset(14, 24); HeadDesc.Size = UDim2.new(1, -(HEAD_RES + 36), 0, 14); HeadDesc.TextTruncate = Enum.TextTruncate.AtEnd; HeadDesc.ZIndex = 3
new("Frame", { Size = UDim2.new(1, -SIDE_W, 0, 1), Position = UDim2.fromOffset(SIDE_W, HEAD_H), BackgroundColor3 = T.STROKE, BorderSizePixel = 0, ZIndex = 3 }, Window)
makeDraggable(Head, Window)
makeDraggable(Brand, Window)


local LANG_IMG = { pt = "104605019793239", en = "80651584476641" }
local DISCORD_IMG = "125064913709663"

local function headButton(order)
	local b = new("TextButton", {
		Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(BS, BS), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -(12 + order * (BS + 6)), 0.5, 0), BackgroundColor3 = T.SIDE, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 4,
	}, Head)
	corner(b, 10)
	local st = stroke(b, T.ACCENT, 1.5, 0.25)
	local sc = new("UIScale", {}, b)
	b.MouseEnter:Connect(function() tween(st, { Thickness = 2.2 }, 0.15); tween(sc, { Scale = 1.08 }, 0.15) end)
	b.MouseLeave:Connect(function() tween(st, { Thickness = 1.5 }, 0.15); tween(sc, { Scale = 1 }, 0.15) end)
	return b, st, sc
end

local function pressFx(b, sc, rot)
	sc.Scale = 0.78
	tween(sc, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
	b.Rotation = rot
	tween(b, { Rotation = 0 }, 0.5, Enum.EasingStyle.Elastic)
	local rp = new("Frame", { Size = UDim2.fromOffset(4, 4), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = T.ACCENT, BackgroundTransparency = 0.3, BorderSizePixel = 0, Active = false, ZIndex = 3 }, b)
	corner(rp, 99)
	tween(rp, { Size = UDim2.fromOffset(BS * 1.7, BS * 1.7), BackgroundTransparency = 1 }, 0.5)
	task.delay(0.55, function() rp:Destroy() end)
end
local function iconImage(parent, id)
	return new("ImageLabel", { Image = assetUrl(id), Size = UDim2.new(1, -8, 1, -8), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, Active = false, ZIndex = 5 }, parent)
end

local BtnDiscord, _, DcSc = headButton(0)
iconImage(BtnDiscord, DISCORD_IMG)
Lib.DiscordInvite = "https://discord.gg/B6AYjVJKf"
local function copyInvite()
	local ok = false
	if setclipboard then ok = pcall(setclipboard, Lib.DiscordInvite) end
	if not ok and toclipboard then ok = pcall(toclipboard, Lib.DiscordInvite) end
	Lib:Notify({ Title = "Discord", Type = ok and "Success" or "Info",
		Description = ok and (Lib.Lang == "pt" and "Link do Discord copiado!" or "Discord link copied!") or Lib.DiscordInvite, Duration = 3 })
end
BtnDiscord.Activated:Connect(function() copyInvite(); pressFx(BtnDiscord, DcSc, -14) end)


local BtnLang, _, LgSc = headButton(1)
local LangFlag = iconImage(BtnLang, LANG_IMG.en)
corner(LangFlag, 6)
local function refreshLangChips() LangFlag.Image = assetUrl(LANG_IMG[Lib.Lang] or LANG_IMG.en) end
BtnLang.Activated:Connect(function()
	local nxt = Lib.Lang == "en" and "pt" or "en"
	Lib:SetLanguage(nxt)
	pressFx(BtnLang, LgSc, nxt == "pt" and 14 or -14)
	Lib:Notify({ Title = nxt == "pt" and "Idioma" or "Language", Description = nxt == "pt" and "Português (BR) ativado." or "English enabled.", Duration = 3 })
end)
Lib:OnLanguage(function(lang)
	refreshLangChips()
	pcall(function() if writefile then
		if makefolder and isfolder and not isfolder("FlowHub") then makefolder("FlowHub") end
		writefile("FlowHub/lang.txt", lang)
	end end)
end)
task.spawn(function()
	pcall(function()
		local a, b = Instance.new("ImageLabel"), Instance.new("ImageLabel")
		a.Image = assetUrl(LANG_IMG.pt); b.Image = assetUrl(LANG_IMG.en)
		game:GetService("ContentProvider"):PreloadAsync({ a, b })
		a:Destroy(); b:Destroy()
	end)
end)


local Content = new("Frame", { Name = "Content", Position = UDim2.fromOffset(SIDE_W, HEAD_H + 1), Size = UDim2.new(1, -SIDE_W, 1, -(HEAD_H + 1)), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2 }, Window)
local Pages, TabButtons, activeTab, tabCount = {}, {}, nil, 0

local function selectTab(id)
	if activeTab == id or not Pages[id] then return end
	local info = TabButtons[id]
	for k, p in pairs(Pages) do
		if k ~= id then p.Visible = false end
		local tb = TabButtons[k]
		if tb then
			local on = k == id
			tween(tb.btn, { BackgroundColor3 = on and T.SELECT or T.SIDE, BackgroundTransparency = on and 0 or 1 }, 0.2)
			tween(tb.bar, { BackgroundTransparency = on and 0 or 1 }, 0.2)
			tween(tb.name, { TextColor3 = on and T.TEXT or T.MUTED }, 0.2)
			if tb.icon then tween(tb.icon, tb.asset and { ImageColor3 = on and T.ACCENT2 or T.MUTED } or { TextColor3 = T.TEXT }, 0.2) end
		end
	end
	activeTab = id
	local page = Pages[id]
	page.Visible = true
	page.Position = UDim2.fromOffset(0, 12)
	tween(page, { Position = UDim2.fromOffset(0, 0) }, 0.26, Enum.EasingStyle.Quint)
	if info.asset then
		HeadIcon.Image = info.asset.Url; HeadIcon.ImageRectSize = info.asset.ImageRectSize; HeadIcon.ImageRectOffset = info.asset.ImageRectOffset
		HeadIcon.Visible = true; HeadTitle.Position = UDim2.new(0, 46, 0.5, 0); HeadTitle.Text = info.name.Text
	else
		HeadIcon.Visible = false; HeadTitle.Position = UDim2.new(0, 14, 0.5, 0); HeadTitle.Text = info.name.Text
	end
	HeadDesc.Text = info.desc or ""
end
Lib:OnLanguage(function()
	if activeTab and TabButtons[activeTab] then HeadTitle.Text = TabButtons[activeTab].name.Text end
end)

local function newPage()
	local page = new("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
		ScrollBarThickness = 3, ScrollBarImageColor3 = T.ACCENT, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
	}, Content)
	pad(page, 10, 12, 8, 12)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }, page)
	return page
end


local function baseRow(page, height, auto)
	local r = new("Frame", { Size = UDim2.new(1, 0, 0, height or ROW_H), BackgroundColor3 = T.ROW, BorderSizePixel = 0, ZIndex = 3 }, page)
	if auto then r.AutomaticSize = Enum.AutomaticSize.Y end
	corner(r, 10); stroke(r, T.STROKE, 1, 0.35)
	return r
end
local function titleDesc(row, name, desc, rightReserve)
	local hasDesc = type(desc) == "string" and desc:match("%S") ~= nil
	local t = labelOf(row, "", 13, T.TEXT, Enum.Font.GothamMedium)
	t.Size = UDim2.new(1, -(rightReserve or 20), 0, 15); t.Position = UDim2.fromOffset(12, hasDesc and 4 or 7); t.TextTruncate = Enum.TextTruncate.AtEnd; t.ZIndex = 4
	tr(t, name or "")
	local d
	if type(desc) == "string" and desc:match("%S") then
		d = labelOf(row, "", 10, T.MUTED, Enum.Font.Gotham)
		d.Size = UDim2.new(1, -(rightReserve or 20), 0, 12); d.Position = UDim2.fromOffset(12, 20); d.TextTruncate = Enum.TextTruncate.AtEnd; d.ZIndex = 4
		tr(d, desc)
	end
	return t, d
end
local function rowHeight(desc) return (type(desc) == "string" and desc:match("%S")) and ROW_HD or ROW_H end

local function opt(a, ...)
	if type(a) ~= "table" then return { Name = a, Callback = (...) } end
	return a
end

local function hover(row, hot)
	row.MouseEnter:Connect(function() tween(row, { BackgroundColor3 = hot or T.SELECT }, 0.12) end)
	row.MouseLeave:Connect(function() tween(row, { BackgroundColor3 = T.ROW }, 0.12) end)
end


local function canon(s)
	s = tostring(s or ""); s = norm(s)
	return (s:lower():gsub("[^%w]+", ""))
end
Lib._tabs = {}
local function finalizeSection(tab)
	local sec = tab._sec; tab._sec = nil
	if not sec or not sec.frame or not sec.frame.Parent then return end
	local drop = sec.count == 0
	if not drop and sec.count == 1 and sec.first then
		local a, c = canon(sec.text), canon(sec.first)
		if a ~= "" and c ~= "" and (a == c or c:find(a, 1, true) or a:find(c, 1, true)) then drop = true end
	end
	if drop then pcall(function() sec.frame:Destroy() end) end
end
function Lib.SweepSections() for _, t in ipairs(Lib._tabs) do finalizeSection(t) end end
local function noteElement(tab, name)
	local sec = tab._sec
	if sec then sec.count += 1; if sec.count == 1 then sec.first = name end end
end

local Tab = {}
Tab.__index = Tab
local function safe(cb, ...)
	if type(cb) ~= "function" then return end
	local ok, err = pcall(cb, ...)
	if not ok then warn("[FlowHub] callback error: " .. tostring(err)) end
end

function Tab:AddSection(a)
	local o = opt(a)
	local text = o.Name or o.Title or o[1] or ""
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0, ZIndex = 3 }, self.page)
	new("Frame", { Size = UDim2.fromOffset(3, 12), Position = UDim2.fromOffset(2, 4), BackgroundColor3 = T.ACCENT, BorderSizePixel = 0, ZIndex = 4 }, row)
	local l = labelOf(row, "", 11, T.ACCENT2, Enum.Font.GothamBold)
	l.Position = UDim2.fromOffset(12, 0); l.Size = UDim2.new(1, -12, 1, 0); l.ZIndex = 4
	tr(l, text)
	finalizeSection(self); self._sec = { frame = row, text = text, count = 0 }
	return { Set = function(_, v) l.Text = v end, Frame = row }
end

function Tab:AddParagraph(a)
	local o = opt(a)
	local title, text = o.Title or o.Name or o[1], o.Text or o.Content
	if o.Text == nil and o.Title == nil and o.Name == nil then title, text = nil, o[1] end
	if text == "" then text = nil end
	local row = baseRow(self.page, 30)
	local TextService = game:GetService("TextService")
	local tl, bl
	local TS, TF = 12, Enum.Font.Gotham
	if title and text then
		tl = labelOf(row, "", 13, T.TEXT, Enum.Font.GothamBold); tl.Position = UDim2.fromOffset(12, 6); tl.Size = UDim2.new(1, -24, 0, 15); tl.ZIndex = 4; tr(tl, title)
	end
	bl = labelOf(row, "", TS, title and T.MUTED or T.TEXT, TF)
	bl.TextWrapped = true; bl.TextYAlignment = Enum.TextYAlignment.Top; bl.ZIndex = 4
	tr(bl, text or title or "")
	local function relayout()
		local w = math.max(row.AbsoluteSize.X - 24, 80)
		local ok, sz = pcall(TextService.GetTextSize, TextService, bl.Text, TS, TF, Vector2.new(w, 2000))
		local th = ok and math.ceil(sz.Y) or 16
		local top = tl and 23 or 7
		bl.Position = UDim2.fromOffset(12, top); bl.Size = UDim2.new(1, -24, 0, th)
		row.Size = UDim2.new(1, 0, 0, math.max(30, top + th + 7))
	end
	relayout()
	row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if math.abs(row.AbsoluteSize.X - (row:GetAttribute("lastW") or 0)) > 1 then row:SetAttribute("lastW", row.AbsoluteSize.X); relayout() end
	end)
	bl:GetPropertyChangedSignal("Text"):Connect(relayout)
	return { Set = function(_, v) bl.Text = tostring(v) end, SetTitle = function(_, v) if tl then tl.Text = tostring(v) end end, Frame = row }
end

function Tab:AddButton(a, b)
	local o = opt(a, b)
	local name = o.Name or o.Title or o[1]
	local cb = o.Callback or o[2]
	local row = baseRow(self.page, rowHeight(o.Description))
	local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5 }, row)
	local t = titleDesc(row, name, o.Description, 56)
	if o.Style == "danger" then t.TextColor3 = T.BAD end
	glyph(row, "right", T.ACCENT, 12, UDim2.new(1, -24, 0.5, 0), 4)
	hover(row)
	btn.Activated:Connect(function()
		tween(row, { BackgroundColor3 = T.ACCENT }, 0.08)
		task.delay(0.12, function() tween(row, { BackgroundColor3 = T.ROW }, 0.2) end)
		safe(cb)
	end)
	return { SetText = function(_, v) tr(t, v) end, Frame = row }
end

function Tab:AddToggle(a)
	local o = opt(a)
	local state = o.Default == true
	local callback = o.Callback
	local row = baseRow(self.page, rowHeight(o.Description))
	titleDesc(row, o.Name or o.Title, o.Description, 70)
	local track = new("Frame", { Size = UDim2.fromOffset(32, 16), Position = UDim2.new(1, -44, 0.5, -8), BackgroundColor3 = state and T.ACCENT or T.SELECT, BorderSizePixel = 0, ZIndex = 4 }, row)
	corner(track, 8)
	local knob = new("Frame", { Size = UDim2.fromOffset(12, 12), Position = state and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5 }, track)
	corner(knob, 6)
	local btn = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 6 }, row)
	hover(row)
	local obj = {}
	if o.Player then local g = Lib:PlayerGroup(o.Player); table.insert(g.toggles, obj) end
	local function render(silent)
		tween(track, { BackgroundColor3 = state and T.ACCENT or T.SELECT }, 0.15)
		tween(knob, { Position = state and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2) }, 0.15)
		if not silent then safe(callback, state) end
	end
	btn.Activated:Connect(function() state = not state; render() end)
	function obj:SetValue(v, silent) state = v and true or false; render(silent) end
	obj.Set = obj.SetValue
	function obj:Get() return state end
	function obj:Callback(fn) callback = fn; return self end
	obj.Frame = row
	if state then task.defer(function() safe(callback, state) end) end
	return obj
end


function Tab:AddLabel(a)
	local text = type(a) == "table" and (a.Name or a.Title or a.Text or a[1]) or a
	return self:AddParagraph({ tostring(text or "") })
end

function Tab:AddSlider(a)
	local o = opt(a)
	local min, max, step = tonumber(o.Min) or 0, tonumber(o.Max) or 100, tonumber(o.Increase) or 1
	local value = math.clamp(tonumber(o.Default) or min, min, max)
	local row = baseRow(self.page, 38)
	local t = titleDesc(row, o.Name or o.Title, nil, 80)
	t.Position = UDim2.fromOffset(12, 4)
	local val = labelOf(row, tostring(value), 11, T.ACCENT2, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	val.Size = UDim2.fromOffset(60, 14); val.Position = UDim2.new(1, -72, 0, 5); val.ZIndex = 4
	local bar = new("Frame", { Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 1, -11), BackgroundColor3 = T.SELECT, BorderSizePixel = 0, ZIndex = 4 }, row)
	corner(bar, 2)
	local fill = new("Frame", { Size = UDim2.fromScale((value - min) / math.max(max - min, 1), 1), BackgroundColor3 = T.ACCENT, BorderSizePixel = 0, ZIndex = 5 }, bar)
	corner(fill, 2)
	local hit = new("TextButton", { Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, -9), BackgroundTransparency = 1, Text = "", ZIndex = 6 }, bar)
	local obj = {}
	local function setValue(v, silent)
		v = math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
		value = v
		val.Text = tostring(v)
		fill.Size = UDim2.fromScale((v - min) / math.max(max - min, 1), 1)
		if not silent then safe(o.Callback, v) end
	end
	local dragging = false
	local function fromInput(pos) setValue(min + (max - min) * math.clamp((pos.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)) end
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; fromInput(i.Position) end
	end)
	connect(UserInputService.InputChanged, function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromInput(i.Position) end
	end)
	connect(UserInputService.InputEnded, function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	function obj:SetValue(v, silent) setValue(tonumber(v) or min, silent) end
	function obj:Get() return value end
	obj.Frame = row
	return obj
end

function Tab:AddTextBox(a)
	local o = opt(a)
	local row = baseRow(self.page, rowHeight(o.Description))
	titleDesc(row, o.Title or o.Name, o.Description, 140)
	local boxWrap = new("Frame", { Size = UDim2.fromOffset(104, 20), Position = UDim2.new(1, -116, 0.5, -10), BackgroundColor3 = T.SIDE, BorderSizePixel = 0, ZIndex = 4 }, row)
	corner(boxWrap, 8); stroke(boxWrap, T.STROKE, 1)
	local box = new("TextBox", {
		Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(6, 0), BackgroundTransparency = 1, Text = tostring(o.Default or ""),
		PlaceholderText = o.PlaceholderText or "", PlaceholderColor3 = T.MUTED, TextColor3 = T.TEXT, Font = Enum.Font.Gotham, TextSize = 11,
		ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true, ZIndex = 5,
	}, boxWrap)
	registry[box] = true
	box.Focused:Connect(function() tween(boxWrap, { BackgroundColor3 = T.SELECT }) end)
	box.FocusLost:Connect(function()
		tween(boxWrap, { BackgroundColor3 = T.SIDE })
		safe(o.Callback, box.Text)
		if o.ClearText then box.Text = "" end
	end)
	return { Get = function() return box.Text end, Set = function(_, v) box.Text = tostring(v) end, Clear = function() box.Text = "" end, Frame = row, Box = box }
end


function Tab:AddDropdown(a)
	local o = opt(a)
	local options = {}
	for _, v in ipairs(o.Options or {}) do table.insert(options, tostring(v)) end
	local selected = nil
	local open = false

	local wrap = new("Frame", { Size = UDim2.new(1, 0, 0, rowHeight(o.Description)), BackgroundColor3 = T.ROW, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 3 }, self.page)
	corner(wrap, 10); stroke(wrap, T.STROKE, 1, 0.35)
	local headH = rowHeight(o.Description)
	titleDesc(wrap, o.Name or o.Title, o.Description, 170)
	local cur = labelOf(wrap, "—", 12, T.ACCENT2, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	cur.Size = UDim2.fromOffset(130, 16); cur.Position = UDim2.new(1, -168, 0, headH / 2 - 8); cur.TextTruncate = Enum.TextTruncate.AtEnd; cur.ZIndex = 4
	local caret = glyph(wrap, "down", T.MUTED, 12, UDim2.new(1, -20, 0, headH / 2), 4)
	local head = new("TextButton", { Size = UDim2.new(1, 0, 0, headH), BackgroundTransparency = 1, Text = "", ZIndex = 6 }, wrap)
	local list = new("ScrollingFrame", {
		Position = UDim2.fromOffset(8, headH), Size = UDim2.new(1, -16, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, ScrollBarImageColor3 = T.ACCENT, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 4,
	}, wrap)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) }, list)

	local obj = {}
	local function setOpen(v)
		open = v
		local h = math.min(#options * 25 + 4, 132)
		tween(wrap, { Size = UDim2.new(1, 0, 0, open and headH + h + 8 or headH) }, 0.18)
		tween(list, { Size = UDim2.new(1, -16, 0, open and h or 0) }, 0.18)
		tween(caret.Frame, { Rotation = open and 180 or 0 }, 0.18)
	end
	local group = o.Players and Lib:PlayerGroup(o.Players) or nil
	local function label(v) if group then return v end return translate(v, "en", Lib.Lang) end
	local function choose(v, silent)
		local changed = selected ~= v
		selected = v
		cur.Text = v and label(v) or "—"
		setOpen(false)
		if not silent then
			safe(o.Callback, v)

			if group and changed and v then
				for _, tg in ipairs(group.toggles) do
					if tg:Get() then
						task.spawn(function()
							tg:Set(false)
							task.wait(0.2)
							if selected == v and not tg:Get() then tg:Set(true) end
						end)
					end
				end
			end
		end
	end
	local function rebuild()
		for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
		for i, v in ipairs(options) do
			local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = T.SIDE, BorderSizePixel = 0, Text = label(v), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = T.TEXT, AutoButtonColor = false, LayoutOrder = i, ZIndex = 5 }, list)
			corner(b, 7)
			b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = T.SELECT }, 0.1) end)
			b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = T.SIDE }, 0.1) end)
			b.Activated:Connect(function() choose(v) end)
		end
		if open then setOpen(true) end
	end
	function obj:SetOptions(list2)
		options = {}
		for _, v in ipairs(list2 or {}) do table.insert(options, tostring(v)) end
		if selected and not table.find(options, selected) then selected = nil; cur.Text = "—" end
		rebuild()
	end

	function obj:Set(v, silent)
		if type(v) == "table" then return obj:SetOptions(v) end
		choose(v ~= nil and tostring(v) or nil, silent)
	end
	obj.SetValue = obj.Set
	function obj:Get() return selected end
	obj.Frame = wrap
	if group then
		group.dropdown = obj
		local LP = game:GetService("Players").LocalPlayer
		local function names(skip)
			local l = {}
			for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
				if p ~= LP and p ~= skip then table.insert(l, p.Name) end
			end
			table.sort(l)
			return l
		end
		game:GetService("Players").PlayerAdded:Connect(function() task.defer(function() obj:SetOptions(names()) end) end)
		game:GetService("Players").PlayerRemoving:Connect(function(p)
			local was = selected == p.Name
			obj:SetOptions(names(p))
			if was then
				selected = nil; cur.Text = "—"
				safe(o.OnLeft, p.Name)
				local any = false
				for _, tg in ipairs(group.toggles) do
					if tg:Get() then any = true; tg:Set(false) end
				end
				if any then
					Lib:Notify({ Title = "Player left", Description = p.Name .. " " .. translate("left the game. The function was turned off.", "en", Lib.Lang), Type = "Error", Duration = 5 })
				end
			end
		end)
	end
	head.Activated:Connect(function() setOpen(not open) end)
	rebuild()
	table.insert(langListeners, function() rebuild(); if selected then cur.Text = label(selected) end end)
	if o.Default and table.find(options, tostring(o.Default)) then choose(tostring(o.Default), true) end
	return obj
end

function Tab:AddImage(a)
	local o = opt(a)
	local h = tonumber(o.Size) or 60
	local row = baseRow(self.page, h)
	local img = new("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = assetUrl(o.Image), ScaleType = Enum.ScaleType.Crop, ZIndex = 4 }, row)
	corner(img, 10)
	return { Frame = row }
end

function Tab:AddDiscordInvite(a)
	local o = opt(a)
	if o.Invite then Lib.DiscordInvite = o.Invite end
	local row = baseRow(self.page, 56)
	local logo = new("ImageLabel", { Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(10, 10), BackgroundTransparency = 1, Image = assetUrl(o.Logo or ICON_ID), ZIndex = 4 }, row)
	corner(logo, 10)
	local t = labelOf(row, "", 14, T.TEXT, Enum.Font.GothamBold); t.Position = UDim2.fromOffset(54, 7); t.Size = UDim2.new(1, -132, 0, 16); t.ZIndex = 4; t.TextTruncate = Enum.TextTruncate.AtEnd; tr(t, o.Title or BRAND)
	local d = labelOf(row, "", 11, T.MUTED, Enum.Font.Gotham); d.Position = UDim2.fromOffset(54, 24); d.Size = UDim2.new(1, -132, 0, 28); d.TextWrapped = true; d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 4; tr(d, o.Description or "")
	local join = new("TextButton", { Text = "Join", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = T.ACCENT, Size = UDim2.fromOffset(58, 28), Position = UDim2.new(1, -68, 0.5, -14), AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 5 }, row)
	corner(join, 8); tr(join, "Join")
	join.Activated:Connect(copyInvite)
	return { Frame = row }
end


function Tab:AddMiniMap(a)
	local o = opt(a)
	local size = tonumber(o.Size) or 140
	local zoom = tonumber(o.Zoom) or 0.05
	local row = baseRow(self.page, size + 36)
	local t = labelOf(row, "", 13, T.TEXT, Enum.Font.GothamMedium)
	t.Position = UDim2.fromOffset(12, 8); t.Size = UDim2.new(1, -24, 0, 16); t.ZIndex = 4
	tr(t, tostring(o.Name or o.Title or o[1] or "Radar"))
	local radar = new("Frame", { Size = UDim2.fromOffset(size, size), Position = UDim2.new(0.5, -size / 2, 0, 28), BackgroundColor3 = T.SIDE, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 4 }, row)
	corner(radar, size / 2); stroke(radar, T.ACCENT, 1.5, 0.3)
	local me = new("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = T.GOOD, BorderSizePixel = 0, ZIndex = 6 }, radar)
	corner(me, 3)
	local dots = {}
	task.spawn(function()
		while radar.Parent do
			task.wait(0.1)
			if row.Visible and self.page.Visible then
				local mine = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local cam = workspace.CurrentCamera
				local seen = {}
				if mine and cam and o.ShowPlayers ~= false then
					local look = cam.CFrame.LookVector
					local yaw = math.atan2(look.X, look.Z)
					local c, s = math.cos(yaw), math.sin(yaw)
					for _, p in ipairs(Players:GetPlayers()) do
						local hrp = p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							local d = hrp.Position - mine.Position
							local x, y = d.X * c - d.Z * s, d.X * s + d.Z * c
							local dot = dots[p]
							if not dot then
								dot = new("Frame", { Size = UDim2.fromOffset(5, 5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = T.ACCENT, BorderSizePixel = 0, ZIndex = 5 }, radar)
								corner(dot, 3); dots[p] = dot
							end
							dot.Position = UDim2.new(0.5, x * zoom * size / 140 * -1, 0.5, y * zoom * size / 140 * -1)
							seen[p] = true
						end
					end
				end
				for p, dot in pairs(dots) do
					if not seen[p] then dot:Destroy(); dots[p] = nil end
				end
			end
		end
	end)
	return { Frame = row }
end


for _, nm in ipairs({ "AddButton", "AddToggle", "AddSlider", "AddTextBox", "AddDropdown", "AddParagraph", "AddImage", "AddDiscordInvite", "AddMiniMap", "AddLabel" }) do
	local orig = Tab[nm]
	if orig then
		Tab[nm] = function(self, a, c)
			local ok, o = pcall(opt, a, c)
			local name = ok and type(o) == "table" and (o.Name or o.Title or o[1]) or nil
			noteElement(self, type(name) == "string" and name or nil)
			return orig(self, a, c)
		end
	end
end

local function createTab(nameArg, iconArg, descArg)
	local name, emoji, desc = nameArg, iconArg, descArg
	if type(nameArg) == "table" then
		name = nameArg.Name or nameArg.Title or nameArg[1]
		emoji = nameArg.Emoji or nameArg.Icon or nameArg[2]
		desc = nameArg.Description or nameArg.Desc or nameArg[3]
	end
	local asset
	asset, emoji = iconFor(emoji)
	tabCount += 1
	local id = tabCount
	local page = newPage()
	Pages[id] = page

	local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = T.SIDE, BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = id, ZIndex = 4 }, TabList)
	corner(btn, 9)
	local bar = new("Frame", { Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = T.ACCENT, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 5 }, btn)
	corner(bar, 2)
	local em
	if asset then
		em = new("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(10, 7), ZIndex = 5, Image = asset.Url, ImageRectSize = asset.ImageRectSize, ImageRectOffset = asset.ImageRectOffset, ImageColor3 = T.MUTED }, btn)
	else
		em = labelOf(btn, emoji, 14, T.TEXT, Enum.Font.Gotham, Enum.TextXAlignment.Center)
		em.Size = UDim2.fromOffset(24, 30); em.Position = UDim2.fromOffset(6, 0); em.ZIndex = 5
	end
	local nm = labelOf(btn, "", 11, T.MUTED, Enum.Font.GothamMedium)
	nm.Position = UDim2.fromOffset(34, 0); nm.Size = UDim2.new(1, -38, 1, 0); nm.TextTruncate = Enum.TextTruncate.AtEnd; nm.ZIndex = 5
	tr(nm, tostring(name))
	TabButtons[id] = { btn = btn, bar = bar, name = nm, emoji = emoji, desc = desc, icon = em, asset = asset }
	btn.MouseEnter:Connect(function() if activeTab ~= id then tween(btn, { BackgroundTransparency = 0.6 }, 0.1) end end)
	btn.MouseLeave:Connect(function() if activeTab ~= id then tween(btn, { BackgroundTransparency = 1 }, 0.1) end end)
	btn.Activated:Connect(function() selectTab(id) end)
	if not activeTab then selectTab(id) end

	local tabObj = setmetatable({ page = page, id = id }, Tab)
	table.insert(Lib._tabs, tabObj)
	function tabObj:Remove()
		btn:Destroy(); page:Destroy(); Pages[id] = nil; TabButtons[id] = nil
		if activeTab == id then activeTab = nil; local k = next(Pages); if k then selectTab(k) end end
	end
	function tabObj:Select() selectTab(id) end
	return tabObj
end


local Open = false
Window.Visible = false
local Pill = new("ImageButton", {
	Name = "FlowToggle", Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE), Position = UDim2.new(0, 12, 0.5, -BUTTON_SIZE / 2),
	BackgroundTransparency = 1, Image = assetUrl(ICON_ID), ScaleType = Enum.ScaleType.Fit, AutoButtonColor = false, ZIndex = 50, BorderSizePixel = 0,
}, Gui)
local PillScale = new("UIScale", {}, Pill)

local function pillPress()
	tween(PillScale, { Scale = 0.82 }, 0.09)
	task.delay(0.09, function() tween(PillScale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back) end)
end

local openToken, winBase = 0, nil
local function setOpen(v, instant)
	v = v and true or false
	if Open == v and not instant then return end
	Open = v
	openToken += 1
	local my = openToken
	if not winBase then winBase = Window.Position end
	local base = winBase
	local away = base + UDim2.fromOffset(0, 22)
	if instant then
		animating = false; Window.Visible = v; Window.Position = base; winBase = nil; WinScale.Scale = targetScale
		return
	end
	pillPress()
	tween(Pill, { ImageTransparency = v and 0 or 0.35 }, 0.2)
	animating = true
	if v then
		if not Window.Visible then
			Window.Position = away
			WinScale.Scale = targetScale * 0.86
			Window.Visible = true
		end

		tween(WinScale, { Scale = targetScale }, 0.34, Enum.EasingStyle.Back)
		tween(Window, { Position = base }, 0.34, Enum.EasingStyle.Quint)
		task.delay(0.36, function()
			if openToken ~= my then return end
			animating = false; winBase = nil; Window.Position = base; WinScale.Scale = targetScale
		end)
	else
		TweenService:Create(WinScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = targetScale * 0.86 }):Play()
		TweenService:Create(Window, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = away }):Play()
		task.delay(0.22, function()
			if openToken ~= my then return end
			Window.Visible = false; animating = false; winBase = nil; Window.Position = base; WinScale.Scale = targetScale
		end)
	end
end
makeDraggable(Pill, Pill, function() setOpen(not Open) end)
Lib.Show = function() setOpen(true) end
Lib.Hide = function() setOpen(false) end
Lib.Toggle = function() setOpen(not Open) end


connect(UserInputService.InputBegan, function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.F4 then setOpen(not Open) end
end)


do
	local last = 0
	connect(RunService.Heartbeat, function()
		if not Window.Visible then return end
		local now = os.clock()
		if now - last < 0.05 then return end
		last = now
		WinGrad.Rotation = (now * 55) % 360
	end)
end


local NotifyHolder = new("Frame", { Size = UDim2.fromOffset(240, 400), Position = UDim2.new(1, -252, 0, 12), BackgroundTransparency = 1, ZIndex = 100 }, Gui)
new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Top }, NotifyHolder)
local notifyOrder = 0
function Lib:Notify(cfg)
	cfg = cfg or {}
	notifyOrder += 1
	local kind = tostring(cfg.Type or "Info"):lower()
	local color = (kind == "error" or kind == "warn") and T.BAD or (kind:sub(1, 3) == "suc" and T.GOOD) or T.ACCENT
	local wrap = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = notifyOrder, ZIndex = 101 }, NotifyHolder)
	local card = new("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.SIDE, BorderSizePixel = 0,
		Position = UDim2.fromOffset(36, 0), GroupTransparency = 1, ZIndex = 101,
	}, wrap)
	corner(card, 10); stroke(card, color, 1.5, 0.15)
	pad(card, 12, 10, 7, 7)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1) }, card)
	local t = labelOf(card, translate(tostring(cfg.Title or BRAND), "en", Lib.Lang), 12, T.TEXT, Enum.Font.GothamBold); t.Size = UDim2.new(1, 0, 0, 14); t.ZIndex = 102; t.LayoutOrder = 1
	local d = labelOf(card, translate(tostring(cfg.Description or cfg.Content or cfg.Text or ""), "en", Lib.Lang), 11, T.MUTED, Enum.Font.Gotham)
	d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y; d.TextWrapped = true; d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 102; d.LayoutOrder = 2
	tween(card, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.3, Enum.EasingStyle.Quint)
	task.delay(tonumber(cfg.Duration or cfg.Time) or 4, function()
		tween(card, { Position = UDim2.fromOffset(36, 0), GroupTransparency = 1 }, 0.22)
		task.wait(0.25)
		wrap:Destroy()
	end)
end


local dialogQueue, dialogActive = {}, false
local function runDialog(cfg)
	dialogActive = true
	local overlay = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 200 }, Gui)
	local card = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.BG, BorderSizePixel = 0, ZIndex = 201 }, overlay)
	corner(card, 14); stroke(card, T.ACCENT, 2)
	local dlgScale = math.clamp((viewport().X - 20) / 340, 0.6, 1) * (IS_MOBILE and 0.9 or 1.1)
	local cardScale = new("UIScale", { Scale = dlgScale * 0.9 }, card)
	tween(cardScale, { Scale = dlgScale }, 0.28, Enum.EasingStyle.Back)
	pad(card, 16, 16, 14, 14)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }, card)
	local t = labelOf(card, "", 15, T.TEXT, Enum.Font.GothamBold); t.Size = UDim2.new(1, 0, 0, 20); t.ZIndex = 202; t.LayoutOrder = 1; t.Text = translate(tostring(cfg.Title or BRAND), "en", Lib.Lang)
	local d = labelOf(card, translate(tostring(cfg.Text or cfg.Description or ""), "en", Lib.Lang), 12, T.MUTED, Enum.Font.Gotham)
	d.Size = UDim2.new(1, 0, 0, 0); d.AutomaticSize = Enum.AutomaticSize.Y; d.TextWrapped = true; d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 202; d.LayoutOrder = 2
	local timeout = tonumber(cfg.Timeout)
	local cd
	if timeout then cd = labelOf(card, "", 11, T.WARN, Enum.Font.GothamBold); cd.Size = UDim2.new(1, 0, 0, 14); cd.ZIndex = 202; cd.LayoutOrder = 3 end
	local btns = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 202, LayoutOrder = 4 }, card)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) }, btns)
	local closed = false
	local function close(fn)
		if closed then return end
		closed = true
		if fn then safe(fn) end
		tween(overlay, { BackgroundTransparency = 1 }, 0.14)
		tween(cardScale, { Scale = dlgScale * 0.92 }, 0.14)
		task.delay(0.15, function()
			overlay:Destroy()
			dialogActive = false
			local nextCfg = table.remove(dialogQueue, 1)
			if nextCfg then runDialog(nextCfg) end
		end)
	end
	for i, optn in ipairs(cfg.Options or { { "OK", function() end } }) do
		local isPrimary = i == 1
		local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = isPrimary and T.ACCENT or T.ROW, Text = translate(tostring(optn[1]), "en", Lib.Lang), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = isPrimary and Color3.new(1, 1, 1) or T.TEXT, AutoButtonColor = false, LayoutOrder = i, ZIndex = 203, BorderSizePixel = 0 }, btns)
		corner(b, 9); if not isPrimary then stroke(b, T.STROKE, 1) end
		b.Activated:Connect(function() close(optn[2]) end)
	end
	tween(overlay, { BackgroundTransparency = 0.45 }, 0.28)
	if timeout then
		task.spawn(function()
			for s = timeout, 1, -1 do
				if closed then return end
				cd.Text = ("%ds"):format(s)
				task.wait(1)
			end
			if not closed then close(cfg.OnTimeout) end
		end)
	end
end
local function dialog(cfg)
	if dialogActive then table.insert(dialogQueue, cfg) else runDialog(cfg) end
end
Lib.Dialog = function(_, cfg) dialog(cfg) end


function Lib:MakeWindow(cfg)
	cfg = cfg or {}
	if cfg.Discord then Lib.DiscordInvite = cfg.Discord end
	local w = {}
	function w:MakeTab(a, b, c) return createTab(a, b, c) end
	w.AddTab = w.MakeTab
	function w:Dialog(c) dialog(c) end
	function w:Notify(c) Lib:Notify(c) end
	function w:Minimize() setOpen(not Open) end
	function w:AddMinimizeButton() end
	function w:Destroy() Lib:Destroy() end
	setOpen(true)
	refreshLangChips()
	return w
end
function Lib:Destroy() genv.FlowHubUI.Destroy() end


pcall(function()
	if isfile and readfile and isfile("FlowHub/lang.txt") then
		local l = readfile("FlowHub/lang.txt")
		if l == "pt" or l == "en" then Lib.Lang = l end
	end
end)
if Lib.Lang == "en" then
	local loc = (LocalPlayer.LocaleId or "en-us"):sub(1, 2):lower()
	local saved = false
	pcall(function() saved = isfile and isfile("FlowHub/lang.txt") end)
	if not saved and loc == "pt" then Lib.Lang = "pt" end
end

Lib:AddDictionary({
	["Invite copied to clipboard"] = "Convite copiado",
	["Join"] = "Entrar",
})

Lib:AddPairs({
	{ "Junte-se à nossa comunidade discord para receber informações sobre a próxima atualização", "Join our Discord community to get news about the next update" },
	{ "Mapa Status", "Map Status" },
	{ "Tempo De Uso De Script", "Script Uptime" },
	{ "Quantidade De Pessoas", "Players In Server" },
	{ "Search Itens", "Item Search" },
	{ "Itens Escondidos", "Hidden Items" },
	{ "Selecione um item escondido", "Select a hidden item" },
	{ "Itens VIP", "VIP Items" },
	{ "Selecione um item VIP", "Select a VIP item" },
	{ "Itens de Evento", "Event Items" },
	{ "Selecione um item de evento", "Select an event item" },
	{ "Pegar Item", "Get Item" },
	{ "Pega o item selecionado em qualquer categoria", "Grabs the selected item from any category" },
	{ "Super Poderes", "Super Powers" },
	{ "Velocidade", "Speed" },
	{ "Definir A Velocidade", "Set the speed" },
	{ "Pulos", "Jump Power" },
	{ "Definir Os Pulos", "Set the jump power" },
	{ "Gravidade", "Gravity" },
	{ "Definir A Gravidade", "Set the gravity" },
	{ "Reseta <Velocidade/Gravidade/Pulos>", "Reset <Speed/Gravity/Jump>" },
	{ "Repetição De Nomes", "Name Repeater" },
	{ "Nome", "Name" },
	{ "Primeiro Nome Da Repetição!", "First repeated name!" },
	{ "Segundo Nome Da Repetição!", "Second repeated name!" },
	{ "Terceiro Nome Da Repetição!", "Third repeated name!" },
	{ "NOME RGB", "RGB NAME" },
	{ "mudar a cor dos nomes automático", "Automatically changes the name color" },
	{ "Reptir Nomes", "Repeat Names" },
	{ "Repitir nomes da textbox automaticamente", "Automatically repeats the names from the text boxes" },
	{ "Navio Pirado", "Crazy Ship" },
	{ "Tornado - Navio Pirata", "Tornado - Pirate Ship" },
	{ "Puxa Navio Pirata para a praça", "Pulls the pirate ship to the square" },
	{ "o auto farm da estação de bombeiros", "Fire station auto farm" },
	{ "Veículo", "Vehicle" },
	{ "Utilidades", "Utilities" },
	{ "Roupa Bombeiro", "Firefighter Outfit" },
	{ "Pega a roupa de bombeiro", "Gets the firefighter outfit" },
	{ "Items RGB", "RGB Items" },
	{ "o efeito RGB nos itens", "RGB effect on items" },
	{ "Velocidade RGB", "RGB Speed" },
	{ "Resoluções Da Tela", "Screen Resolutions" },
	{ "Resolução Normal", "Normal Resolution" },
	{ "Resolução 0.70", "Resolution 0.70" },
	{ "Resolução 0.80", "Resolution 0.80" },
	{ "Sistema Lgbt", "Rainbow System" },
	{ "Velocidade das cores", "Color speed" },
	{ "Cabelo lgbt", "Rainbow Hair" },
	{ "Mudar a cor de cabelo automático", "Automatically changes your hair color" },
	{ "Nome lgbt", "Rainbow Name" },
	{ "Mudar a cor do nome automático", "Automatically changes your name color" },
	{ "Bio lgbt", "Rainbow Bio" },
	{ "Mudar a cor da bio automático", "Automatically changes your bio color" },
	{ "Rosas Lgbt", "Rainbow Roses" },
	{ "Muda a cor da rosa automaticamente", "Automatically changes the rose color" },
	{ "Personagem Lgbt", "Rainbow Character" },
	{ "Deixa seu personagem RGB automaticamente", "Makes your character RGB automatically" },
	{ "Selecione Players", "Select Player" },
	{ "Atualizar Lista", "Refresh List" },
	{ "Spectar Jogador", "Spectate Player" },
	{ "Seção de jogador local", "Local Player Props" },
	{ "Selecione uma pessoa para usableAngle", "Select a person for usableAngle" },
	{ "Prop Cobra", "Snake Prop" },
	{ "Furacão de Props", "Prop Hurricane" },
	{ "Portal prop", "Portal Prop" },
	{ "Props Doidos", "Crazy Props" },
	{ "prop círculo", "prop circle" },
	{ "Prop Cobra em player", "Snake Prop on Player" },
	{ "Velocidade do Spin", "Spin Speed" },
	{ "Camisas Usável", "Wearable Shirts" },
	{ "Adicione um id", "Add an ID" },
	{ "ids de camisas de preferência", "Preferred shirt IDs" },
	{ "Animação & Reset", "Animation & Reset" },
	{ "Reseta Avatar", "Reset Avatar" },
	{ "Animação home ou muie", "Man or woman animation" },
	{ "Melhores Partes", "Best Parts" },
	{ "Cabeça Invisível", "Invisible Head" },
	{ "Machado Escuro", "Dark Axe" },
	{ "Sistema de Avatares", "Avatar System" },
	{ "Selecionar Jogador", "Select Player" },
	{ "Verificação De Parts <Update>", "Parts Check <Update>" },
	{ "Copiar Avatar", "Copy Avatar" },
	{ "Panico", "Panic" },
	{ "Pânico FE", "Panic FE" },
	{ "Camera De Carro", "Car Camera" },
	{ "Camera de carro no roblox", "Car camera in Roblox" },
	{ "Mãozinha", "Little Hand" },
	{ "Mãozinha FE", "Little Hand FE" },
	{ "Minecraft no roblox", "Minecraft in Roblox" },
	{ "Super Heróis <Packs>", "Super Heroes <Packs>" },
	{ "Mulher Bonita <Packs>", "Beautiful Woman <Packs>" },
	{ "Estilosa", "Stylish" },
	{ "Elegância Rosa-Pastel", "Pastel Pink Elegance" },
	{ "Informações De Uso", "Usage Info" },
	{ "Fun", "Info" },
	{ "•As funções acima já aplicam as roupas completas, portanto, basta apenas modificar o corpo ou a cor.", "•The functions above already apply the full outfits, so you only need to change the body or the color." },
	{ "Fechar", "Close" },
	{ "Packs <Masculinos", "Male Packs" },
	{ "Packs <Masculinos>", "Male Packs" },
	{ "E os D <Masculino>", "And the D <Male>" },
	{ "Clonado de <Masculino>", "Cloned <Male>" },
	{ "Fino <Masculino>", "Slim <Male>" },
	{ "Trajado <Masculino>", "Dressed <Male>" },
	{ "Sem dona <Masculino>", "Ownerless <Male>" },
	{ "Packs Variados <Conjuntos>", "Mixed Packs <Sets>" },
	{ "Roupas 3D <Conjuntos>", "3D Clothes <Sets>" },
	{ "Skins 3D", "3D Skins" },
	{ "Roupas 3D Varias opções Tops!", "3D clothes, many top options!" },
	{ "Vestir", "Wear" },
	{ "Especiais Efeitos <Acessórios>", "Special Effects <Accessories>" },
	{ "Escolha o Efeito", "Choose the Effect" },
	{ "Selecione um acessório para ativar", "Select an accessory to activate" },
	{ "Vestir Acessório", "Wear Accessory" },
	{ "Impede sentar via Tool", "Prevents sitting via Tool" },
	{ "Impede sentar em Carro", "Prevents sitting in cars" },
	{ "Proteção contra colisões de veículos/objetos", "Protection against vehicle/object collisions" },
	{ "Impede que outros vejam seus chats <Creator>", "Stops others from seeing your chats <Creator>" },
	{ "Jogador Local", "Local Player" },
	{ "Atravessar Paredes", "Noclip" },
	{ "Permite atravessar paredes e objetos", "Lets you walk through walls and objects" },
	{ "Pulos Infinitos", "Infinite Jump" },
	{ "Permite pular infinitamente no ar", "Lets you jump infinitely in the air" },
	{ "Bring Drip User", "Bring Flow Hub User" },
	{ "Verify Drip Users", "Verify Flow Hub Users" },
	{ "Checks who is using Drip Client", "Checks who is using Flow Hub" },
	{ "Crie Nomes Com Extinto", "Create Names With Extinct" },
	{ "Digite Um Texto", "Type a text" },
	{ "Crie um Nome de extinto", "Create an extinct name" },
	{ "Crie um Muro de tools", "Create a Tool Wall" },
	{ "Tamanho Do Muro", "Wall Size" },
	{ "Escolha a quantidade de tools para formar o muro", "Choose how many tools make up the wall" },
	{ "Criar Muro", "Create Wall" },
	{ "Crie Um Tornado de tools", "Create a Tool Tornado" },
	{ "Tamanho do Tornado", "Tornado Size" },
	{ "Escolha quantas ferramentas formarão o tornado", "Choose how many tools form the tornado" },
	{ "Criar Tornado", "Create Tornado" },
	{ "Notificações Mapa", "Map Notifications" },
	{ "Notificação: Entrada/Saída", "Notification: Join/Leave" },
	{ "Notifica quando jogadores entram ou saem", "Notifies when players join or leave" },
	{ "Notificação De Morte", "Death Notification" },
	{ "Mostra quando um jogador morre", "Shows when a player dies" },
	{ "Voo & Equipe All", "Fly & Equip All" },
	{ "Fly Drip Chip", "Fly Chip" },
	{ "Equipa Todos Items", "Equip All Items" },
	{ "Teleporte", "Teleport" },
	{ "Escolher Um Jogador", "Choose a Player" },
	{ "Selecione um jogador para usar as funções", "Select a player to use the functions" },
	{ "Teleportar Com Carro", "Teleport With Car" },
	{ "Teleporte Automático", "Auto Teleport" },
	{ "Teleporta instantaneamente para o jogador", "Instantly teleports to the player" },
	{ "Visualizar Jogador", "View Player" },
	{ "Acompanha o jogador com a câmera", "Follows the player with the camera" },
	{ "Menu Esp", "ESP Menu" },
	{ "Velocidade da Rotação", "Rotation Speed" },
	{ "Escolha o jogador alvo do barco pirata", "Choose the pirate boat's target player" },
	{ "Spawna o barco pirata e persegue o jogador selecionado", "Spawns the pirate boat and chases the selected player" },
	{ "Parar Boat Pirate", "Stop Pirate Boat" },
	{ "Para o barco pirata imediatamente", "Stops the pirate boat immediately" },
	{ "Cabeça", "Head" },
	{ "Peito Superior", "Upper Chest" },
	{ "Barriga Inferior", "Lower Belly" },
	{ "Frente do Corpo", "Front of Body" },
	{ "Frente", "Front" },
	{ "Traseiro", "Back" },
	{ "Pirralhos Trolagem <filho>", "Kid Trolling <child>" },
	{ "Escolher Jogador", "Choose Player" },
	{ "Selecione quem o pirralho irá seguir", "Select who the kid will follow" },
	{ "Selecionar Nome RP", "Select RP Name" },
	{ "Escolha Uma Tag para o pirralho", "Choose a tag for the kid" },
	{ "Parte do Corpo", "Body Part" },
	{ "Onde o pirralho ficará preso no corpo", "Where the kid will attach on the body" },
	{ "Partes", "Parts" },
	{ "Atualizar Jogadores", "Refresh Players" },
	{ "Enviar Pirralho", "Send Kid" },
	{ "Seção Kill Car", "Kill Car Section" },
	{ "Escolha um jogador", "Choose a player" },
	{ "Selecionar um jogador pra funcionar as funções", "Select a player for the functions to work" },
	{ "Olha jogador de longe qualquer lugar", "Watch a player from afar, anywhere" },
	{ "Atualizar", "Refresh" },
	{ "Inícia Fling", "Start Fling" },
	{ "Parar Fling", "Stop Fling" },
	{ "Aviso < ⚠️ >", "Warning < ⚠️ >" },
	{ "Recomendo Entra no Carro Antes de usa!\nPara Rapidez e eficiência do fling", "Get in a car before using it!\nFor faster and more efficient fling" },
	{ "Method Variados", "Misc Methods" },
	{ "Funções Mata <Todos>", "Kill <All> Functions" },
	{ "Mata Geral De Ônibus", "Kill All With Bus" },
	{ "Matar Geral de Barco ", "Kill All With Boat" },
	{ "Joga bola <Todos>", "Throw ball <All>" },
	{ "Matar Geral v2 <Couch>", "Kill All v2 <Couch>" },
	{ "Matar Jogadores Com Clique", "Kill Players With Click" },
	{ "Clique Admin <Fling>", "Admin Click <Fling>" },
	{ "Equipe a bola e use o clique para arremessar jogadores. Ferramenta com câmera automática.", "Equip the ball and click to fling players. Tool with automatic camera." },
	{ "Clique Portas <Fling>", "Door Click <Fling>" },
	{ "Clique Bola <Fling>", "Ball Click <Fling>" },
	{ "trolar jogadores usando isso apenas damdo clique", "Troll players with this just by clicking" },
	{ "Orbitar", "Orbit" },
	{ "Selecione Um Jogador", "Select a Player" },
	{ "Selecione um jogador para orbitar", "Select a player to orbit" },
	{ "Velocidade <Tween>", "Speed <Tween>" },
	{ "Atualizar tabela", "Refresh Table" },
	{ "Orbita Jogador", "Orbit Player" },
	{ "Vire um planeta e orbite o jogador", "Become a planet and orbit the player" },
	{ "Carros View", "Car View" },
	{ "Foco < Carros >", "Focus < Cars >" },
	{ "Super Foque nos carros de longe", "Focus on cars from far away" },
	{ "Visualizar Carro", "View Car" },
	{ "olha carro mesmo estando de longe", "Watch a car even from afar" },
	{ "Velocidade Do Carro Sem <GamePass>", "Car Speed Without <GamePass>" },
	{ "Definir Velocidade", "Set Speed" },
	{ "Velocidade do carro preencher o espaço", "Car speed, fill in the box" },
	{ "Definir Turbo", "Set Turbo" },
	{ "Valor turbo (Velocidade add)", "Turbo value (added speed)" },
	{ "Mudar Velocidade e Turbo", "Change Speed and Turbo" },
	{ "Velocidade Aplicada", "Speed Applied" },
	{ "Musica No Carro", "Car Music" },
	{ "Tocar Música", "Play Music" },
	{ "Parar Música", "Stop Music" },
	{ "Carro Colorido <GamePass>", "Colorful Car <GamePass>" },
	{ "Carro Funções", "Car Functions" },
	{ "Selecione um carro", "Select a car" },
	{ "Selecionar Um Carro para as funções", "Select a car for the functions" },
	{ "Carros", "Cars" },
	{ "Verificação de Carros", "Car Check" },
	{ "Atualizar lista", "Refresh list" },
	{ "Teleporta ao Assento", "Teleport to Seat" },
	{ "Puxa o Carro", "Pull the Car" },
	{ "Teleporta temporariamente o carro até você", "Temporarily teleports the car to you" },
	{ "Extreme Carros <Super>", "Extreme Cars <Super>" },
	{ "Fly Carro Free", "Free Car Fly" },
	{ "Puxa Carros", "Pull Cars" },
	{ "Remover os carros <Todos>", "Remove <All> Cars" },
	{ "Drip Avançado", "Advanced" },
	{ "Esp Carros", "Car ESP" },
	{ "Mostra Carros no mapa", "Shows cars on the map" },
	{ "Codigo Varios Carros", "Multi-Car Code" },
	{ "Local de Teleporte", "Teleport Location" },
	{ "Escolha um destino para teleportar", "Choose a destination to teleport to" },
	{ "Teleportar", "Teleport" },
	{ "Teleporta para o local selecionado", "Teleports to the selected location" },
	{ "Teleportes Variados", "Misc Teleports" },
	{ "Servidor Com Pouca Pessoas", "Low Population Server" },
	{ "Servidor inferior", "Smaller Server" },
	{ "Reentra No Servidor", "Rejoin Server" },
	{ "Sistema De Variações", "Variations System" },
	{ "Não Sentar", "Do not sit" },
	{ "Desenvolvedores", "Developers" },
	{ "Dev Script", "Script Dev" },
	{ "Mostra o Moderador do script no servidor", "Shows the script moderator in the server" },
	{ "Owner Script", "Script Owner" },
	{ "Mostra o Dono do script no servidor", "Shows the script owner in the server" },
	{ "Modder Script", "Script Modder" },
	{ "Mostra os Staffs do servidor", "Shows the server staff" },
	{ "Personalizado", "Custom" },
	{ "Mostra usuários personalizados", "Shows custom users" },
	{ "Items Tool", "Tool Items" },
	{ "Telecinese", "Telekinesis" },
	{ "Pegar Teleport tool", "Get Teleport Tool" },
	{ "Jogador Morreu", "Player Died" },
	{ "Jogador Entrou", "Player Joined" },
	{ "Jogador Saiu", "Player Left" },
	{ "Entrou na Workspace", "Joined Workspace" },
	{ "Saiu da Workspace", "Left Workspace" },
	{ "Ativar", "Activate" },
	{ "Link Discord", "Discord Link" },
	{ "props troll ALL", "Props Troll ALL" },
	{ "prop sit all", "Prop Sit All" },
	{ "prop kill all", "Prop Kill All" },
	{ "prop fling", "Prop Fling" },
	{ "prop kill player", "Prop Kill Player" },
	{ "Nuke normal", "Normal Nuke" },
	{ "Pirralho", "Kid" },
	{ "Navio", "Ship" },
	{ "Pânico", "Panic" },
})
Lib:AddPairs({
	{ "Avançado", "Advanced" }, { "morreu", "died" }, { "entrou no jogo", "joined the game" }, { "saiu do jogo", "left the game" },
	{ "entrou na Workspace.Players", "joined Workspace.Players" }, { "saiu da Workspace.Players", "left Workspace.Players" },
})
Lib:AddPairs({
	{ "informações", "Information" },
	{ "Início", "Home" },
	{ "Efeitos", "Effects" },
	{ "Roupas", "Clothes" },
	{ "Proteção", "Protection" },
	{ "Jogador", "Player" },
	{ "Trolar", "Troll" },
	{ "Carro", "Car" },
	{ "Configurações", "Settings" },
	{ "Livro Velho", "Old Book" },
	{ "Chave Velha", "Old Key" },
	{ "Mangueira", "Fire Hose" },
	{ "Sacola de Diamantes", "Diamond Bag" },
	{ "Chave de Ouro", "Golden Key" },
	{ "Sofa", "Couch" },
	{ "Espada de Ouro", "Golden Sword" },
	{ "Lança ovo", "Egg Launcher" },
	{ "Canhão", "Cannon" },
	{ "Planador", "Glider" },
	{ "Pedra Nuclear", "Radioactive Rock" },
	{ "Balão de Água", "Water Balloon" },
	{ "Canhão de Neve", "Snowball Cannon" },
	{ "Pegar Candy", "Get Candy" },
	{ "Garrafa Térmica", "Thermos" },
	{ "Motosserra", "Chainsaw" },
	{ "Lança Azul", "Blue Joust" },
	{ "Regador", "Watering Can" },
	{ "Macaco Azul", "Blue Monkey" },
	{ "Present Natal", "Christmas Present" },
	{ "Bandeija", "Cookie Tray" },
	{ "Planador de Neve", "Snow Glider" },
	{ "Lança Vermelha", "Red Joust" },
	{ "Linhas <Esp>", "Lines <ESP>" },
	{ "Vida <Esp>", "Health <ESP>" },
	{ "Nome <Esp>", "Name <ESP>" },
	{ "Distância <Esp>", "Distance <ESP>" },
	{ "Distância", "Distance" },
	{ "Mostra linhas da posição dos jogadores", "Shows lines to the players' positions" },
	{ "Mostra a vida dos jogadores", "Shows the players' health" },
	{ "Mostra os nomes dos jogadores no mapa", "Shows the players' names on the map" },
	{ "Mostra as distâncias dos jogadores", "Shows the players' distances" },
	{ "Criança", "Child" },
	{ "Aleatório", "Random" },
	{ "Web namoro", "Web Dating" },
	{ "Cria Nome Extinto", "Create Extinct Name" },
	{ "Crie Nomes Com Extinto", "Create Extinct Names" },
	{ "Fada do Dia de São Petersburgo", "St. Petersburg Day Fairy" },
	{ "Nick Aqui", "Nick Here" },
	{ "Seção de jogador local", "Local Player Section" },
	{ "Selecione uma pessoa para usableAngle", "Select a person for usableAngle" },
	{ "Nome do Jogo", "Game Name" },
	{ "Desconhecido", "Unknown" },
	{ "Agência", "Agency" },
	{ "Hotéis", "Hotels" },
	{ "Café", "Cafe" },
	{ "Refúgio", "Refuge" },
	{ "Clínica Dentária", "Dental Clinic" },
	{ "Portal da Agência", "Agency Portal" },
	{ "Oficina Oculta", "Hidden Workshop" },
	{ "Bastidores", "Backstage" },
	{ "Centro Urbano", "Downtown" },
	{ "Área do Crime", "Crime Area" },
	{ "Casa Deserta", "Abandoned House" },
	{ "Arco", "Arch" },
	{ "Sala Secreta", "Secret Room" },
	{ "Ilha Isolada", "Isolated Island" },
	{ "Montanha", "Mountain" },
	{ "Esconderijo", "Hideout" },
	{ "Escola", "School" },
	{ "Cafeteria", "Cafeteria" },
	{ "Banco", "Bank" },
})
Lib:AddDictionary({
	["This device is not registered for your admin account"] = "Este aparelho não está registrado na sua conta de admin",
	["Teleported to"] = "Teletransportado para", ["Teleport..."] = "Teleportando...", ["Copy Avatar..."] = "Copiando avatar...",
	["copying avatar please wait"] = "copiando o avatar, aguarde", ["Notification"] = "Notificação", ["Avatar Successfuly Copied"] = "Avatar copiado com sucesso",
	["warn"] = "Aviso", ["ball not found"] = "bola não encontrada", ["error when catching the ball "] = "erro ao pegar a bola", ["Loading..."] = "Carregando...",
})
Lib:AddDictionary({ ["Player left"] = "Jogador saiu", ["left the game. The function was turned off."] = "saiu do jogo. A função foi desativada." })
return Lib

end)()

if not lib then
	error("[FlowHub] falha ao carregar a UI")
end

workspace.FallenPartsDestroyHeight = -math.huge


do
	local reverse = {}
	local function reverseOf(lang)
		if reverse[lang] then return reverse[lang] end
		local map = {}
		for key, value in pairs(t1.Frases[lang] or {}) do
			if type(value) == "string" then map[value] = key end
		end
		reverse[lang] = map
		return map
	end
	lib.Translator = function(from, to, text)
		local dst = t1.Frases[to]
		if not dst then return text end
		local key = reverseOf(from)[text] or text
		return dst[key] or key
	end
	lib:OnLanguage(function(lang)
		if t1.Frases[lang] then t1.Idioma = lang end
	end)
	if t1.Frases[lib.Lang] then t1.Idioma = lib.Lang end
end

local v13 = lib:MakeWindow({
	Title = "Flow Hub | Brookhaven RP",
	SubTitle = "By Lian [flow]",
	Discord = DISCORD_INVITE,
})

local Flow = {}
function Flow.LeftNotice(name)
	lib:Notify({ Title = "Player left", Description = tostring(name) .. " " .. lib:T("left the game. The function was turned off."), Type = "Error", Duration = 5 })
end

local function v15()
	setclipboard(DISCORD_INVITE)
end

local t2 = {}

for _, player in pairs(game.Players:GetPlayers()) do
	if player ~= game.Players.LocalPlayer then
		table.insert(t2, player.Name)
	end
end


lib:AddPairs({
	{ "Scripts Trolls", "Troll Scripts" },
	{ "Troll Players", "Troll Players" },
	{ "Casas", "Houses" },
	{ "Audio All", "Audio All" },
	{ "Lag Server", "Lag Server" },
	{ "Nomes", "Names" },
	{ "Criança", "Child" },
	{ "Itens", "Items" },
	{ "Scripts Universais", "Universal Scripts" },
	{ "Black Hole", "Black Hole" },
	{ " Ativando isso você puxa Parts até o seu personagem", "Enabling this pulls parts to your character" },
	{ "Puxar Parts", "Pull Parts" },
	{ "Para usar, chegue perto do Player Selecionado", "To use it, get close to the selected player" },
	{ "Invisível", "Invisible" },
	{ "Ficar Invisível", "Become Invisible" },
	{ "Ficar invisível FE", "Become invisible FE" },
	{ "Avatar RGB", "Avatar RGB" },
	{ "Deixa seu personagem RGB", "Makes your character RGB" },
	{ "Cabelo RGB", "Hair RGB" },
	{ "Deixa Seu Cabelo RGB", "Makes your hair RGB" },
	{ "Não Deixa seu personagem Sentar", "Stops your character from sitting" },
	{ "Selecionar Jogador", "Select Player" },
	{ "Atualizar Player List", "Refresh Player List" },
	{ "Teleportar até o Player", "Teleport to Player" },
	{ "Spectar Player", "Spectate Player" },
	{ "Métodos", "Methods" },
	{ "Selecionar Método para Matar", "Select Kill Method" },
	{ "Matar Player", "Kill Player" },
	{ "Puxar Player", "Bring Player" },
	{ "Fling - Boat", "Fling - Boat" },
	{ "Desligar Fling - Boat", "Turn Off Fling - Boat" },
	{ "Click Fling Portas [Beta]", "Click Fling Doors [Beta]" },
	{ "Para Usar, Recomendo chegar perto de outras portas, apos ela ir até você, clique no jogador que deseja flingar", "To use it, get close to other doors; after they come to you, click the player you want to fling" },
	{ "Bring All Couch [melhor]", "Bring All Couch [best]" },
	{ "Kill All Couch [melhor]", "Kill All Couch [best]" },
	{ "Dupando", "Duping" },
	{ "Dupando vida", "Duping life" },
	{ "Script de Dupe", "Dupe Script" },
	{ "Copiar Skin", "Copy Skin" },
	{ "Copiar Avatar", "Copy Avatar" },
	{ "Selecione a Casa", "Select House" },
	{ "Atualizar Lista de Casas", "Refresh House List" },
	{ "Teleportar para Casa", "Teleport to House" },
	{ "Teleportar para Cofre", "Teleport to Vault" },
	{ "Atravessar Porta da Casa", "Walk Through House Door" },
	{ "Tocar Campainha", "Ring Doorbell" },
	{ "Bater na Porta", "Knock on Door" },
	{ "Teleporte Para Casas", "Teleport to Houses" },
	{ "Selecionar Casa", "Select House" },
	{ "Teleporte para a Casa que Quiser", "Teleport to any house you want" },
	{ "Te desbane automaticamente das Casas", "Automatically unbans you from houses" },
	{ "Casa RGB", "House RGB" },
	{ "Deixa a sua casa RGB", "Makes your house RGB" },
	{ "Audio Todos os Players", "Audio for All Players" },
	{ "Gritinho", "Little Scream" },
	{ "Jumpscare Horroroso", "Horrible Jumpscare" },
	{ "Áudio Alto", "Loud Audio" },
	{ "Ruído", "Noise" },
	{ "Risada Da Bruxa Minecraft", "Minecraft Witch Laugh" },
	{ "Deitei Um Ave Maria Doido", "Crazy Hail Mary" },
	{ "Gritao AAAAAAAAA", "Big Scream AAAAAAAAA" },
	{ "Nao sei KKKK", "No idea LOL" },
	{ "Grito", "Scream" },
	{ "Grito 2", "Scream 2" },
	{ "Sem ideia de nome KK", "No idea for a name LOL" },
	{ "Estora tímpano", "Eardrum Blaster" },
	{ "Gemidão", "Moan" },
	{ "Toma Jack", "Take That Jack" },
	{ "Pede ifood pede", "Order Food Delivery" },
	{ "Compre OnLine Na shoope", "Shop Online" },
	{ "Uh Que Nojo", "Ew, Gross" },
	{ "Sai dai Lava Prato", "Get Out, Dishwasher" },
	{ "Seloko num compensa", "Not Worth It" },
	{ "Insira o ID do Áudio ou Musica", "Enter the Audio or Music ID" },
	{ "Digite o ID do áudio", "Type the audio ID" },
	{ "ID do áudio", "Audio ID" },
	{ "Selecione o Áudio", "Select Audio" },
	{ "Escolha um áudio da lista", "Choose an audio from the list" },
	{ "Loop de Audio", "Audio Loop" },
	{ "Loop Tocar Áudio", "Loop Play Audio" },
	{ "Ativa o loop do áudio", "Enables the audio loop" },
	{ "Tocar Áudio", "Play Audio" },
	{ "Estorar ouvido de geral KK", "Blow everyone's ears LOL" },
	{ "Toca áudio repetidamente para todos", "Plays audio repeatedly for everyone" },
	{ "Shutdown Personalizado", "Custom Shutdown" },
	{ "Shutdown Servidor", "Shutdown Server" },
	{ "Shutdown Servidor (Erro de Internet)", "Shutdown Server (Internet Error)" },
	{ "Shutdown Servidor (Erro de Conexão Expirada)", "Shutdown Server (Connection Timeout Error)" },
	{ "Lag com Laptop", "Laptop Lag" },
	{ "Informação de Lag", "Lag Info" },
	{ "Lag com Telefone", "Phone Lag" },
	{ "Lag com Bomba", "Bomb Lag" },
	{ "Nome RGB", "RGB Name" },
	{ "Ativar Nome RGB", "Enable RGB Name" },
	{ "Ativar RGB BIO", "Enable RGB BIO" },
	{ "Adicionar Nomes no Jogador", "Add Names to Player" },
	{ "Informação:", "Information:" },
	{ "Note", "Note" },
	{ "Aplicar Velocidade, Turbo e drift", "Apply Speed, Turbo and Drift" },
	{ "Enviar criança", "Send Child" },
	{ "Retornar criança", "Return Child" },
	{ "Selecione um player para perseguir", "Select a player to chase" },
	{ "Funcionalidades FE", "FE Features" },
	{ "Velocidade, Gravidade e Pulo", "Speed, Gravity and Jump" },
	{ "Velocidade do Player", "Player Speed" },
	{ "Digite a velocidade", "Type the speed" },
	{ "Resetar velocidade", "Reset Speed" },
	{ "Tamanho do Pulo", "Jump Size" },
	{ "Digite a altura do pulo", "Type the jump height" },
	{ "Resetar Pulo", "Reset Jump" },
	{ "Gravidade", "Gravity" },
	{ "Digite a gravidade", "Type the gravity" },
	{ "Resetar Gravidade", "Reset Gravity" },
	{ "Digite a mensagem", "Type the message" },
	{ "Delay do Spam", "Spam Delay" },
	{ "Spam chat Hacked By Flow Hub", "Spam chat Hacked By Flow Hub" },
	{ "Limpar Chat", "Clear Chat" },
	{ "Selecionar Player", "Select Player" },
	{ "Head Sit (Cavalinho)", "Head Sit (Piggyback)" },
	{ "Atualizar tabela", "Refresh table" },
	{ "Vermelho", "Red" },
	{ "Laranja", "Orange" },
	{ "Amarelo", "Yellow" },
	{ "Verde", "Green" },
	{ "Ciano", "Cyan" },
	{ "Azul", "Blue" },
	{ "Roxo", "Purple" },
	{ "Preto", "Black" },
	{ "Colorir Mapa Chão [Muito OP]", "Color Map Floor [Very OP]" },
	{ "Colorir Mapa Céu [Muito OP]", "Color Map Sky [Very OP]" },
	{ "Selecione a Cor", "Select Color" },
	{ "Escolha uma cor para aplicar", "Choose a color to apply" },
	{ "Colorido", "Colorful" },
	{ "Selecione a Combinação de Cores", "Select Color Combination" },
	{ "Escolha uma combinação de cores", "Choose a color combination" },
	{ "Controle de Itens", "Items Control" },
	{ "Limpar Todas as Tools", "Clear All Tools" },
	{ "Equipar Itens", "Equip Items" },
	{ "Equipar todos os itens", "Equip all items" },
	{ "Telecinese", "Telekinesis" },
	{ "Nao Clique em nada quando tiver dupando . ", "Don't click anything while duping." },
	{ " Eu entendi", "I understand" },
	{ "Eu entendi", "I understand" },
	{ "Because It will break the script and you will need to rejoin.", "Because it will break the script and you will need to rejoin." },
	{ "Nao clique em nada", "Don't click anything" },
	{ "Espere", "Wait" },
	{ "Tendeu", "Got it" },
	{ "Shutdown Concluído, Agora Vai Desligar", "Shutdown complete, the server will now shut down" },
	{ "Iniciando duplicação, seja paciente", "Starting duplication, please be patient" },
	{ "Não Clique em nada enquanto as tool estiverem sendo dupadas", "Don't click anything while the tools are being duped" },
	{ "Please do not equip any tools or unequip tools or click tools on inventory. It will break the script.", "Please do not equip, unequip or click tools in your inventory. It will break the script." },
	{ "Loop de tocar Áudio (Todos players do Server ouvem)", "Audio play loop (all players in the server hear it)" },
	{ "Todos do server ouvem o áudio", "Everyone in the server hears the audio" },
	{ "O efeito de lag começa após 35 segundos", "The lag effect starts after 35 seconds" },
	{ "O script começa a causar lag após 35 segundos", "The script starts causing lag after 35 seconds" },
	{ "Recomendo usar 2 vezes para garantir que todos os veículos sejam removidos", "Use it twice to make sure all vehicles are removed" },
	{ "Puxa todos os carros do servidor até você", "Pulls every car in the server to you" },
	{ "Ambos os turbos não precisam de Gamepass", "Neither turbo needs a Gamepass" },
	{ "O script de música funciona em todos os carros e casas", "The music script works on all cars and houses" },
	{ "Ativando isso deixará seu carro RGB", "Enabling this makes your car RGB" },
	{ "Ativando isso você pode voar com o seu carro", "Enabling this lets you fly with your car" },
	{ "Spamar vários carros", "Spam multiple cars" },
	{ "Remover Todos os Carros", "Remove All Cars" },
	{ "Puxar Todos os Carros", "Bring All Cars" },
	{ "Feito, Você já pode se mover!", "Done, You can Move Now!" },
	{ "Erro", "Error" },
	{ "Sente no carro primeiro!", "Sit in car first!" },
	{ "Coloque um carro primeiro!", "Put a Car First!" },
	{ "Velocidade", "Speed" },
	{ "Turbo V2 [Melhor]", "Turbo V2 [Best]" },
	{ "Música para Carros e Casas", "Music for Cars, Houses" },
	{ "ID da Música (Requer Gamepass)", "Music ID (Gamepass Required)" },
	{ "Digite o ID da Música", "Enter Music ID" },
	{ "Selecione a Música (Requer Gamepass)", "Select Music (Gamepass Required)" },
	{ "Spam de Buzina", "Spam Horn" },
	{ "Voar com o Carro", "Fly Car" },
	{ "Spam de Carros", "Spam Cars" },
	{ "Carro RGB", "Car RGB" },
	{ "Jogador Troll", "Troll Player" },
	{ "Métodos de Matar com Clique", "Click Kill Methods" },
	{ "Todos os métodos", "All methods" },
	{ "Matar Todos de Ônibus", "Kill All Bus" },
	{ "Banir da Casa e Matar Todos", "House Ban Kill All" },
	{ "Banir da Casa e Matar", "House Ban Kill" },
	{ "Fling com Barco", "Fling Boat" },
	{ "Fling com Barco em Todos", "Fling Boat All" },
	{ "Fling Automático", "Auto Fling" },
	{ "Fling Automático em Todos", "Auto Fling All" },
	{ "Fling com Bola", "Fling Ball" },
	{ "Fling com Bola em Todos", "Fling Ball All" },
	{ "Click Fling com Sofá (Tool)", "Click Fling Couch (Tool)" },
	{ "Click Fling com Bola (Tool)", "Click Fling Ball (Tool)" },
	{ "Click Kill com Sofá (Tool)", "Click Kill Couch (Tool)" },
	{ "Equipar Itens", "Equip Items" },
	{ "Grip N4zi", "N4zi Grip" },
	{ "Grip Aura", "Aura Grip" },
	{ "Grip D1ck", "D1ck Grip" },
	{ "Aura de Sofá", "Couch Aura" },
	{ "Aura de Fogo", "Fire Aura" },
	{ "Aura de Água", "Water Aura" },
	{ "Aura de Luz", "Light Aura" },
	{ "Aura de Fumaça", "Smoke Aura" },
	{ "Digite o Texto", "Enter text" },
	{ "Enviar Chat", "Send Chat" },
	{ "Spam de Chat", "Spam Chat" },
	{ "Limpar Chat", "Clear Chat" },
	{ "Tocar Música", "Play Music" },
	{ "Ferramenta TP", "TP Tool" },
	{ "Voar (Fly Gui)", "Fly Gui" },
	{ "Infinite Yield - Comandos", "InfiniteYield - Cmd" },
	{ "Nameless Admin - Comandos", "Nameless Admin - Cmd" },
	{ "Alternar Ball Orbiting", "Ball Orbiting" },
	{ "Personagem RGB", "RGB Character" },
	{ "Fling Automático ", "Auto Fling " },
	{ "Banir da Casa e Matar Todos", "House Ban kill All" },
	{ "Fling com Barco em Todos", "Fling Boat all" },
	{ "Fling com Bola em Todos", "Fling Ball all" },
	{ "Auto Desbanir", "Auto Unban" },
	{ "Sirene Nuclear", "Nuclear Siren" },
	{ "Batida de Bastão", "Bat Hit" },
	{ "BIO RGB", "RGB BIO" },
	{ "Nome: ", "Name: " },
	{ "Velocidade V1", "Speed V1" },
	{ "Spam de Carro", "Spam Car" },
	{ "Sentar na Cabeça", "Headsit" },
	{ "Servidor", "Server" },
	{ "Casas", "Houses" },
	{ "Itens", "Items" },
	{ "Música", "Music" },
	{ "Música por ID", "Music by ID" },
	{ "Música: Carros, Casas e Props", "Music: Cars, Houses and Props" },
})
local t3 = {
	M = v13:MakeTab({ t1:traduzir("informações"), "ℹ️" }),
	H = v13:MakeTab({ t1:traduzir("Início"), "🏠" }),
	JJ = v13:MakeTab({ t1:traduzir("Jogador"), "👤" }),
	TT = v13:MakeTab({ t1:traduzir("Trolar"), "😈" }),
	S = v13:MakeTab({ "Servidor", "🖥️" }),
	MU = v13:MakeTab({ "Música", "🎵" }),
	Carros = v13:MakeTab({ t1:traduzir("Carro"), "🚗" }),
	CS = v13:MakeTab({ "Casas", "🏘️" }),
	Tp = v13:MakeTab({ t1:traduzir("Portal"), "🌀" }),
	AVT = v13:MakeTab({ t1:traduzir("Roupas"), "👕" }),
	IT = v13:MakeTab({ "Itens", "🎒" }),
	P = v13:MakeTab({ t1:traduzir("Props"), "🧱" }),
	E = v13:MakeTab({ t1:traduzir("Efeitos"), "✨" }),
	SK = v13:MakeTab({ t1:traduzir("SkyBox"), "🌌" }),
	PR = v13:MakeTab({ t1:traduzir("Proteção"), "🛡️" }),
	CFG = v13:MakeTab({ t1:traduzir("Configurações"), "⚙️" }),
}

t3.M:AddDiscordInvite({
	Title = "Flow Hub | Community",
	Description = t1:traduzir("Junte-se à nossa comunidade discord para receber informações sobre a próxima atualização"),
	Logo = FLOW_ICON,
	Invite = DISCORD_INVITE,
})
t3.M:AddSection({ t1:traduzir("Mapa Status") })
t3.M:AddParagraph({
	Title = "Flow Hub",
	Text = "By Lian [flow]"
})


task.defer(function()
	local okCore, Core = pcall(function() return (function()










local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local genv = (getgenv and getgenv()) or _G
local Core = {
	Session = nil,
	Settings = {},
	Running = false,
	_listeners = {},
}


local rawRequest = (syn and syn.request) or request or http_request or (http and http.request)

local function httpCall(method, url, body, token)
	if not rawRequest then return nil, "executor_without_http" end
	local headers = { ["Content-Type"] = "application/json" }
	if token then headers["Authorization"] = "Bearer " .. token end
	local ok, res = pcall(rawRequest, {
		Url = url, Method = method, Headers = headers,
		Body = body and HttpService:JSONEncode(body) or nil,
	})
	if not ok or type(res) ~= "table" then return nil, "network_error" end
	return res
end


function Core:Api(method, path, body, opts)
	opts = opts or {}
	local token = (not opts.noAuth) and self.Session and self.Session.token or nil
	local res, err = httpCall(method, self.ApiUrl .. path, body, token)
	if not res then return nil, { code = err, message = "Could not reach the API" } end

	if res.StatusCode == 401 and not opts.noAuth and not opts.retried then
		if self:Authenticate() then
			opts.retried = true
			return self:Api(method, path, body, opts)
		end
	end
	if opts.raw then
		if res.StatusCode == 200 then return res.Body end
	end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, res.Body or "")
	if not ok then
		if res.StatusCode == 200 and opts.raw then return res.Body end
		return nil, { code = "bad_response", message = "Invalid API response", status = res.StatusCode }
	end
	if res.StatusCode >= 400 or data.ok == false then
		local e = data.error or {}
		return nil, { code = e.code or "error", message = e.message or "Request failed", status = res.StatusCode }
	end
	return data
end


function Core.SendChat(message)
	message = tostring(message or ""):sub(1, 120)
	if message == "" then return false end
	local ok = pcall(function()
		if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			assert(channel, "RBXGeneral not found")
			channel:SendAsync(message)
		else
			ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 3).SayMessageRequest:FireServer(message, "All")
		end
	end)
	return ok
end




local function deviceId()
	local id
	pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end)
	if id and id ~= "" then return tostring(id) end
	pcall(function()
		if isfile and readfile and isfile("FlowHub/device.txt") then id = readfile("FlowHub/device.txt"):gsub("%s+", "") end
		if (not id or id == "") and writefile then
			if makefolder and isfolder and not isfolder("FlowHub") then makefolder("FlowHub") end
			id = HttpService:GenerateGUID(false)
			writefile("FlowHub/device.txt", id)
		end
	end)
	return id
end

function Core:Authenticate()
	local data, err = self:Api("POST", "/v1/auth/session", {
		userId = LocalPlayer.UserId, username = LocalPlayer.Name, displayName = LocalPlayer.DisplayName,
		jobId = game.JobId, placeId = game.PlaceId, device = deviceId(),
	}, { noAuth = true })
	if not data then
		self.LastError = err
		return false, err
	end
	self.Session = { token = data.token, isAdmin = data.isAdmin, role = data.role, permissions = data.permissions or {}, locked = data.adminLocked }
	return true
end

function Core:Can(permission)
	local s = self.Session
	if not s or not s.isAdmin then return false end
	for _, p in ipairs(s.permissions) do if p == "*" or p == permission then return true end end
	return false
end


local function notify(self, title, text, kind)
	pcall(function() self.Lib:Notify({ Title = title, Description = text, Type = kind or "Info", Duration = 5 }) end)
end
local function ack(self, id, status, detail)
	if type(id) == "string" and id:sub(1, 6) == "local:" then return end
	self:Api("POST", "/v1/client/ack", { commandId = id, status = status, detail = detail })
end

local actions = {}
actions.verify = function(self, cmd)
	return Core.SendChat("Flowhub-me")
end
actions.chat = function(self, cmd)
	return Core.SendChat(tostring(cmd.payload and cmd.payload.message or ""))
end
actions.bring = function(self, cmd)
	local admin = Players:GetPlayerByUserId(tonumber(cmd.payload and cmd.payload.toUserId) or 0)
	local mine = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local theirs = admin and admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
	if not (mine and theirs) then return false, "character_unavailable" end
	mine.CFrame = theirs.CFrame * CFrame.new(0, 0, -4)
	return true
end
actions.kick = function(self, cmd)

	local reason = tostring(cmd.payload and cmd.payload.reason or "Requested by an administrator")
	task.delay(0.3, function() LocalPlayer:Kick(reason) end)
	return true
end

actions.kamui = function(self, cmd)

	local fn = genv.FlowHubKamui
	if type(fn) ~= "function" then return false, "kamui_unavailable" end
	local ok, err = pcall(fn)
	if not ok then return false, tostring(err) end
	return true
end


local basic = { frozen = {}, jailParts = nil, jailConn = nil }
local function myChar() return LocalPlayer.Character end
local function myHRP() local c = myChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function myHum() local c = myChar(); return c and c:FindFirstChildOfClass("Humanoid") end

actions.freeze = function()
	local c = myChar()
	if not c then return false, "character_unavailable" end
	for _, d in ipairs(c:GetDescendants()) do
		if d:IsA("BasePart") and not d.Anchored then d.Anchored = true; basic.frozen[d] = true end
	end
	return true
end
actions.unfreeze = function()
	for part in pairs(basic.frozen) do
		if part.Parent then part.Anchored = false end
	end
	basic.frozen = {}
	return true
end
actions.kill = function()
	local c, hum = myChar(), myHum()
	if not (c and hum) then return false, "character_unavailable" end
	hum.Health = 0
	pcall(function() c:BreakJoints() end)
	return true
end
actions.unjail = function()
	if basic.jailConn then basic.jailConn:Disconnect(); basic.jailConn = nil end
	if basic.jailParts then basic.jailParts:Destroy(); basic.jailParts = nil end
	return true
end
actions.jail = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.unjail()
	local center = hrp.Position
	local size, height = 10, 12
	local floorY = center.Y - 3
	local origin = Vector3.new(center.X, floorY, center.Z)
	local PURPLE, DARK = Color3.fromRGB(170, 0, 255), Color3.fromRGB(70, 0, 120)
	local folder = Instance.new("Folder")
	folder.Name = "FlowHubJail"
	folder.Parent = workspace
	local function part(sz, pos, color, transp)
		local p = Instance.new("Part")
		p.Anchored, p.CanCollide, p.CastShadow = true, true, false
		p.Material, p.Color, p.Transparency = Enum.Material.Neon, color, transp or 0
		p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
		p.Size, p.Position = sz, pos
		p.Parent = folder
		return p
	end
	local half = size / 2
	part(Vector3.new(size + 1, 1, size + 1), origin + Vector3.new(0, -0.5, 0), DARK, 0.1)
	local roof = part(Vector3.new(size + 1, 1, size + 1), origin + Vector3.new(0, height + 0.5, 0), DARK, 0.1)

	local n = 8
	for i = 0, n do
		local o = -half + i * (size / n)
		for _, sgn in ipairs({ -1, 1 }) do
			part(Vector3.new(0.3, height, 0.3), origin + Vector3.new(o, height / 2, sgn * half), PURPLE)
			part(Vector3.new(0.3, height, 0.3), origin + Vector3.new(sgn * half, height / 2, o), PURPLE)
		end
	end

	for _, y in ipairs({ 0.2, height / 2, height - 0.2 }) do
		for _, sgn in ipairs({ -1, 1 }) do
			part(Vector3.new(size + 0.4, 0.4, 0.4), origin + Vector3.new(0, y, sgn * half), PURPLE)
			part(Vector3.new(0.4, 0.4, size + 0.4), origin + Vector3.new(sgn * half, y, 0), PURPLE)
		end
	end
	local light = Instance.new("PointLight")
	light.Color, light.Brightness, light.Range = PURPLE, 3, 24
	light.Parent = roof
	basic.jailParts = folder

	local limit = half - 1.2
	basic.jailConn = RunService.Heartbeat:Connect(function()
		local r = myHRP()
		if not r then return end
		local d = r.Position - center
		if math.abs(d.X) > limit or math.abs(d.Z) > limit or r.Position.Y > floorY + height - 1 or r.Position.Y < floorY - 2 then
			r.AssemblyLinearVelocity = Vector3.zero
			r.CFrame = CFrame.new(center) * (r.CFrame - r.CFrame.Position)
		end
	end)
	return true
end
actions.explode = function()
	local c, hrp, hum = myChar(), myHRP(), myHum()
	if not (c and hrp and hum) then return false, "character_unavailable" end
	actions.unjail(); actions.unfreeze()
	local pos = hrp.Position

	hrp.AssemblyLinearVelocity = Vector3.new(math.random(-40, 40), 140, math.random(-40, 40))
	hrp.AssemblyAngularVelocity = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
	local ex = Instance.new("Explosion")
	ex.Position, ex.BlastRadius, ex.BlastPressure = pos, 14, 600000
	ex.DestroyJointRadiusPercent, ex.ExplosionType = 1, Enum.ExplosionType.NoCraters
	ex.Parent = workspace
	task.delay(0.15, function()
		hum.Health = 0
		pcall(function() c:BreakJoints() end)
	end)
	return true
end



local Lighting = game:GetService("Lighting")
local fx = { cleanups = {}, saved = nil, returnCF = nil, token = nil, gui = nil }
local function onClear(fn) table.insert(fx.cleanups, fn) end
local function track(inst) onClear(function() if inst and inst.Parent then inst:Destroy() end end); return inst end
local function saveLighting()
	if fx.saved then return end
	fx.saved = {}
	for _, k in ipairs({ "Ambient", "OutdoorAmbient", "Brightness", "ClockTime", "FogColor", "FogStart", "FogEnd", "ExposureCompensation", "GlobalShadows", "EnvironmentDiffuseScale", "EnvironmentSpecularScale" }) do fx.saved[k] = Lighting[k] end
end
local function newPart(parent, size, pos, color, material, transparency, canCollide)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CastShadow = true, canCollide ~= false, false
	p.Size, p.Position, p.Color = size, pos, color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local function shake(duration, power)
	local hum = myHum()
	if not hum then return end
	local t0, conn = os.clock(), nil
	conn = RunService.RenderStepped:Connect(function()
		if os.clock() - t0 > duration or not hum.Parent then
			conn:Disconnect()
			if hum.Parent then hum.CameraOffset = Vector3.zero end
			return
		end
		hum.CameraOffset = Vector3.new((math.random() - 0.5) * power, (math.random() - 0.5) * power, 0)
	end)
end
local function fxGui()
	if fx.gui and fx.gui.Parent then return fx.gui end
	local g = Instance.new("ScreenGui")
	g.Name, g.ResetOnSpawn, g.IgnoreGuiInset, g.DisplayOrder = "FlowHubFX", false, true, 90
	g.Parent = LocalPlayer:WaitForChild("PlayerGui")
	fx.gui = g
	return g
end

local function banner() end
local function flashScreen(color, seconds)
	local f = Instance.new("Frame")
	f.Size, f.BackgroundColor3, f.BorderSizePixel, f.ZIndex = UDim2.new(1, 0, 1, 0), color, 0, 5
	f.Parent = fxGui()
	TweenService:Create(f, TweenInfo.new(seconds), { BackgroundTransparency = 1 }):Play()
	task.delay(seconds + 0.1, function() f:Destroy() end)
end
local function enterMap(pos)
	local hrp = myHRP()
	if not hrp then return false end
	if not fx.returnCF then fx.returnCF = hrp.CFrame end
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
	return true
end

local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local assetTypeCache = {}
local function assetType(id)
	if assetTypeCache[id] ~= nil then return assetTypeCache[id] end
	local ok, info = pcall(function() return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset) end)
	assetTypeCache[id] = (ok and info and info.AssetTypeId) or false
	return assetTypeCache[id]
end
local function useAsset(id, opts)
	opts = opts or {}
	local kind = assetType(id)
	if kind == 3 then
		local snd = track(Instance.new("Sound"))
		snd.SoundId, snd.Volume, snd.Looped = "rbxassetid://" .. id, opts.volume or 1, opts.looped or false
		snd.Parent = workspace
		snd:Play()
		return snd
	elseif kind == 1 or kind == 13 then
		local img = Instance.new("ImageLabel")
		img.BackgroundTransparency, img.Image = 1, "rbxassetid://" .. id
		img.Size, img.AnchorPoint, img.Position = UDim2.new(0, 520, 0, 520), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0)
		img.Parent = fxGui()
		TweenService:Create(img, TweenInfo.new(opts.seconds or 3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { ImageTransparency = 1 }):Play()
		task.delay((opts.seconds or 3) + 0.2, function() img:Destroy() end)
		return img
	end
end
local function skyFrom(id)
	local kind = assetType(id)
	if kind ~= 1 and kind ~= 13 then return nil end
	local sky = track(Instance.new("Sky"))
	local url = "rbxassetid://" .. id
	sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = url, url, url, url, url, url
	sky.Parent = Lighting
	return sky
end
local function loadModel(id, origin)
	if assetType(id) ~= 10 then return nil end
	local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
	local model = ok and objs and objs[1]
	if not model then
		local ok2, loaded = pcall(function() return InsertService:LoadAsset(id) end)
		model = ok2 and loaded or nil
	end
	if not model then return nil end
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy()
		elseif d:IsA("BasePart") then d.Anchored = true end
	end
	if not model:FindFirstChildWhichIsA("BasePart", true) then model:Destroy(); return nil end
	model.Parent = workspace
	if model:IsA("Model") then model:PivotTo(CFrame.new(origin)) end
	return track(model)
end
local function standInside(model, origin)
	local params = RaycastParams.new()
	params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Include, { model }
	local hit = workspace:Raycast(origin + Vector3.new(0, 400, 0), Vector3.new(0, -800, 0), params)
	enterMap(hit and (hit.Position + Vector3.new(0, 3, 0)) or (origin + Vector3.new(0, 60, 0)))
end
local function autoClear(seconds)
	local t = {}
	fx.token = t
	task.delay(seconds, function() if fx.token == t then actions.cleareffects() end end)
end


local SoundService = game:GetService("SoundService")
local function snd(id, volume, looped)
	local s = track(Instance.new("Sound"))
	s.SoundId = "rbxassetid://" .. tostring(id)
	s.Volume, s.Looped = volume or 1, looped or false
	s.Parent = SoundService
	s:Play()
	return s
end

local function stashLightingObjects()
	for _, o in ipairs(Lighting:GetChildren()) do
		if o:IsA("Sky") or o:IsA("Atmosphere") then
			local parent = o.Parent
			o.Parent = nil
			onClear(function() if not o.Parent then o.Parent = parent end end)
		end
	end
end

local function loadMapModel(id, name, origin, lift)
	local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
	if not ok or type(objs) ~= "table" or #objs == 0 then
		local ok2, loaded = pcall(function() return InsertService:LoadAsset(id) end)
		if not (ok2 and loaded) then return nil end
		objs = loaded:GetChildren()
	end
	local folder = track(Instance.new("Folder"))
	folder.Name = name
	folder.Parent = workspace
	local model = Instance.new("Model")
	model.Name = name .. "_Model"
	model.Parent = folder
	for _, o in ipairs(objs) do o.Parent = model end
	local parts = 0
	for _, d in ipairs(model:GetDescendants()) do
		if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
			d:Destroy()
		elseif d:IsA("BasePart") then
			d.Anchored = true
			parts += 1
		end
	end
	if parts == 0 then folder:Destroy(); return nil end
	local cf, size = model:GetBoundingBox()
	model:PivotTo(model:GetPivot() + Vector3.new(origin.X, origin.Y + size.Y / 2, origin.Z) - cf.Position)
	return { folder = folder, model = model, origin = origin, spawn = Vector3.new(origin.X, origin.Y + (lift or 6), origin.Z) }
end

local function floorSpawn(m, fromHeight)
	local params = RaycastParams.new()
	params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Include, { m.model }
	local cf, size = m.model:GetBoundingBox()
	local y = fromHeight or (cf.Position.Y + size.Y / 2 + 5)
	for _, o in ipairs({ Vector3.zero, Vector3.new(size.X * 0.15, 0, 0), Vector3.new(-size.X * 0.15, 0, 0), Vector3.new(0, 0, size.Z * 0.15), Vector3.new(0, 0, -size.Z * 0.15) }) do
		local hit = workspace:Raycast(Vector3.new(cf.Position.X + o.X, y, cf.Position.Z + o.Z), Vector3.new(0, -(size.Y + 100), 0), params)
		if hit and hit.Instance.CanCollide and hit.Normal.Y > 0.5 then return hit.Position + Vector3.new(0, 4, 0) end
	end
	return nil
end
local function addAtmosphere(density, color, decay)
	local a = track(Instance.new("Atmosphere"))
	a.Density, a.Offset, a.Color, a.Decay, a.Glare, a.Haze = density, 0, color, decay, 0, 0
	a.Parent = Lighting
	return a
end
local function addColor(tint, saturation, contrast, brightness)
	local cc = track(Instance.new("ColorCorrectionEffect"))
	cc.TintColor, cc.Saturation, cc.Contrast, cc.Brightness = tint or Color3.new(1, 1, 1), saturation or 0, contrast or 0, brightness or 0
	cc.Parent = Lighting
	return cc
end
local function addBloom(intensity, size, threshold)
	local b = track(Instance.new("BloomEffect"))
	b.Intensity, b.Size, b.Threshold = intensity, size, threshold
	b.Parent = Lighting
	return b
end
local function holdPlayer()
	local hrp, hum = myHRP(), myHum()
	if not (hrp and hum) then return end
	local ws, jp, jh = hum.WalkSpeed, hum.JumpPower, hum.JumpHeight
	hum.WalkSpeed, hum.JumpPower, hum.JumpHeight = 0, 0, 0
	hrp.Anchored = true
	onClear(function()
		if hrp.Parent then hrp.Anchored = false end
		if hum.Parent then hum.WalkSpeed, hum.JumpPower, hum.JumpHeight = ws, jp, jh end
	end)
end
local function fovPulse(base, amp, speed)
	local cam = workspace.CurrentCamera
	if not cam then return end
	local old, t0 = cam.FieldOfView, os.clock()
	local conn = RunService.RenderStepped:Connect(function()
		cam.FieldOfView = base + math.sin((os.clock() - t0) * speed) * amp
	end)
	onClear(function() conn:Disconnect(); cam.FieldOfView = old end)
end


local JUMPS = {
	jumps1 = { "rbxassetid://126754882337711", "rbxassetid://138873214826309" },
	jumps2 = { "rbxassetid://86379969987314", "rbxassetid://143942090" },
	jumps3 = { "rbxassetid://127382022168206", "rbxassetid://143942090" },
	jumps4 = { "rbxassetid://95973611964555", "rbxassetid://138873214826309" },
	jeffjumpscare = { "rbxthumb://type=Asset&id=120638479&w=420&h=420", "rbxassetid://143942090" },
}
local function jumpscare(image, audio, seconds)
	seconds = seconds or 2.4
	local g = Instance.new("ScreenGui")
	g.Name, g.ResetOnSpawn, g.IgnoreGuiInset, g.DisplayOrder = "FlowHubJump", false, true, 200
	g.Parent = LocalPlayer:WaitForChild("PlayerGui")
	local bg = Instance.new("Frame")
	bg.Size, bg.BackgroundColor3, bg.BorderSizePixel = UDim2.new(1, 0, 1, 0), Color3.new(0, 0, 0), 0
	bg.Parent = g
	local im = Instance.new("ImageLabel")
	im.BackgroundTransparency, im.Image, im.ScaleType = 1, image, Enum.ScaleType.Fit
	im.AnchorPoint, im.Position, im.Size = Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.4, 0, 0.4, 0)
	im.Parent = bg
	local s = Instance.new("Sound")
	s.SoundId, s.Volume = audio, 3
	s.Parent = g
	s:Play()
	TweenService:Create(im, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) }):Play()
	local t0, conn = os.clock(), nil
	conn = RunService.RenderStepped:Connect(function()
		if os.clock() - t0 > seconds or not g.Parent then conn:Disconnect(); return end
		im.Position = UDim2.new(0.5, math.random(-12, 12), 0.5, math.random(-12, 12))
	end)
	task.delay(seconds, function() if g.Parent then g:Destroy() end end)
	return true
end


local function chase(cfg)
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	local look = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
	if look.Magnitude < 0.1 then look = Vector3.new(0, 0, -1) end
	local body = track(newPart(workspace, Vector3.new(1, 1, 1), hrp.Position - look.Unit * 80 + Vector3.new(0, 3, 0), Color3.new(0, 0, 0), Enum.Material.SmoothPlastic, 1, false))
	local bb = Instance.new("BillboardGui")
	bb.Size, bb.AlwaysOnTop, bb.LightInfluence, bb.Adornee = UDim2.new(cfg.w or 8, 0, cfg.h or 10, 0), true, 0, body
	bb.Parent = body
	local im = Instance.new("ImageLabel")
	im.Size, im.BackgroundTransparency, im.Image = UDim2.new(1, 0, 1, 0), 1, cfg.image
	im.Parent = bb
	if cfg.music then snd(cfg.music, cfg.musicVol or 1, true) end
	local token = {}
	fx.token = token
	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		local r = myHRP()
		if not r or not body.Parent then return end
		local to = (r.Position + Vector3.new(0, 1, 0)) - body.Position
		local d = to.Magnitude
		if d <= 5 then
			conn:Disconnect()
			jumpscare(cfg.scareImage, cfg.scareAudio, 2.6)
			if cfg.kill then local h = myHum(); if h then h.Health = 0 end end
			task.delay(0.3, function() if fx.token == token then actions.cleareffects() end end)
			return
		end
		body.Position = body.Position + to.Unit * math.min(cfg.speed * dt, d)
	end)
	onClear(function() conn:Disconnect() end)
	task.delay(cfg.timeout or 45, function() if fx.token == token then actions.cleareffects() end end)
	return true
end

actions.cleareffects = function()
	fx.token = nil
	for i = #fx.cleanups, 1, -1 do pcall(fx.cleanups[i]) end
	fx.cleanups = {}
	if fx.saved then
		for k, v in pairs(fx.saved) do pcall(function() Lighting[k] = v end) end
		fx.saved = nil
	end
	local hrp = myHRP()
	if fx.returnCF and hrp then hrp.CFrame = fx.returnCF end
	fx.returnCF = nil
	return true
end
LocalPlayer.CharacterAdded:Connect(function() fx.returnCF = nil; actions.cleareffects() end)


local imgCache = {}
local function resolveImage(id)
	id = tostring(id):match("%d+")
	if imgCache[id] then return imgCache[id] end
	local url = "rbxassetid://" .. id
	local objs
	local ok, r = pcall(function() return game:GetObjects(url) end)
	if ok and r and r[1] then
		objs = r
	else
		local ok2, m = pcall(function() return InsertService:LoadAsset(tonumber(id)) end)
		if ok2 and m then objs = m:GetChildren() end
	end
	local o = objs and objs[1]
	if o then
		if o:IsA("Decal") or o:IsA("Texture") then url = o.Texture
		elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then url = o.Image end
	end
	imgCache[id] = url
	return url
end




actions.domain = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local token = {}
	fx.token = token
	local gui = fxGui()
	local origin = Vector3.new(0, 700000, 0)


	local black = track(Instance.new("Frame"))
	black.Size, black.BackgroundColor3, black.BorderSizePixel, black.BackgroundTransparency, black.ZIndex = UDim2.new(1, 0, 1, 0), Color3.new(0, 0, 0), 0, 1, 60
	black.Parent = gui
	TweenService:Create(black, TweenInfo.new(0.4), { BackgroundTransparency = 0 }):Play()
	snd(6667923288, 4, false)

	task.delay(0.6, function()
		if fx.token ~= token then return end
		if not myHRP() then return end

		enterMap(origin)
		holdPlayer()
		Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(25, 20, 60), Color3.fromRGB(25, 20, 60)
		Lighting.Brightness, Lighting.ClockTime = 1, 0
		Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.new(0, 0, 0), 2000, 100000
		local sky = track(Instance.new("Sky"))
		local tex = resolveImage(108682468477856)
		sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = tex, tex, tex, tex, tex, tex
		sky.StarCount, sky.CelestialBodiesShown = 5000, false
		sky.Parent = Lighting
		local cc = addColor(Color3.fromRGB(175, 205, 255), 0.35, 0.2, 0)
		local bloom = addBloom(1.8, 40, 0.7)

		local center = origin + Vector3.new(0, 4, 0)

		local src = track(newPart(workspace, Vector3.new(2, 2, 2), center, Color3.new(0, 0, 0), Enum.Material.SmoothPlastic, 1, false))
		local pe = Instance.new("ParticleEmitter")
		pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		pe.Rate, pe.Lifetime, pe.Speed = 260, NumberRange.new(2.5, 4.5), NumberRange.new(50, 110)
		pe.SpreadAngle, pe.LightEmission = Vector2.new(180, 180), 1
		pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.15, 1.4), NumberSequenceKeypoint.new(1, 0) })
		pe.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 190, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 120, 255)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
		})
		pe.Parent = src

		local rings = {}
		local ringColors = { Color3.fromRGB(90, 200, 255), Color3.fromRGB(180, 90, 255), Color3.new(1, 1, 1) }
		for i = 1, 3 do
			local d = 80 + i * 55
			local r = track(newPart(workspace, Vector3.new(0.5, d, d), center, ringColors[i], Enum.Material.Neon, 0.55, false))
			r.Shape = Enum.PartType.Cylinder
			rings[i] = r
		end
		local core = track(newPart(workspace, Vector3.new(40, 40, 40), center + Vector3.new(0, 20, -220), Color3.new(1, 1, 1), Enum.Material.Neon, 0, false))
		core.Shape = Enum.PartType.Ball
		local coreLight = Instance.new("PointLight")
		coreLight.Color, coreLight.Range, coreLight.Brightness = Color3.fromRGB(200, 220, 255), 120, 6
		coreLight.Parent = core
		local t0 = os.clock()
		local spin = RunService.Heartbeat:Connect(function()
			local t = os.clock() - t0
			for i, r in ipairs(rings) do
				r.CFrame = CFrame.new(center) * CFrame.Angles(t * 0.25 * i, t * 0.18 * (4 - i), 0) * CFrame.Angles(0, 0, math.rad(90))
			end
			core.Size = Vector3.one * (40 + math.sin(t * 3) * 6)
			cc.Brightness = math.sin(t * 4) * 0.05
			bloom.Intensity = 1.8 + math.sin(t * 2.4) * 0.6
		end)
		onClear(function() spin:Disconnect() end)

		local overload = track(Instance.new("Frame"))
		overload.Size, overload.BackgroundTransparency, overload.ZIndex = UDim2.new(1, 0, 1, 0), 1, 40
		overload.Parent = gui
		local palette = { Color3.fromRGB(80, 200, 255), Color3.fromRGB(190, 90, 255), Color3.new(1, 1, 1), Color3.fromRGB(255, 80, 200), Color3.fromRGB(60, 90, 255) }
		local bars = {}
		for i = 1, 26 do
			local f = Instance.new("Frame")
			f.BorderSizePixel = 0
			f.Parent = overload
			bars[i] = f
		end
		local last = 0
		local flick = RunService.RenderStepped:Connect(function()
			local now = os.clock()
			if now - last < 0.06 then return end
			last = now
			for _, f in ipairs(bars) do
				f.BackgroundColor3 = palette[math.random(#palette)]
				f.BackgroundTransparency = 0.55 + math.random() * 0.4
				if math.random() < 0.5 then
					f.Size = UDim2.new(math.random() * 0.8 + 0.1, 0, 0, math.random(1, 5))
				else
					f.Size = UDim2.new(0, math.random(1, 5), math.random() * 0.8 + 0.1, 0)
				end
				f.Position = UDim2.new(math.random(), 0, math.random(), 0)
			end
			if math.random() < 0.08 then flashScreen(palette[math.random(#palette)], 0.35) end
		end)
		onClear(function() flick:Disconnect() end)
		fovPulse(70, 9, 2.2)
		shake(10, 0.25)
		TweenService:Create(black, TweenInfo.new(1.2), { BackgroundTransparency = 1 }):Play()
	end)
	task.delay(12.4, function() if fx.token == token then flashScreen(Color3.new(1, 1, 1), 1.2) end end)
	task.delay(13.4, function() if fx.token == token then actions.cleareffects() end end)
	return true
end



actions.backrooms = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local m = loadMapModel(10581711055, "FlowHubBackrooms", Vector3.new(20000, 300, 20260), 7)
	if not m then return false, "model_unavailable" end
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(125, 108, 58), Color3.fromRGB(110, 95, 50)
	Lighting.Brightness, Lighting.GlobalShadows, Lighting.ExposureCompensation = 2, true, 0.15
	Lighting.EnvironmentDiffuseScale, Lighting.EnvironmentSpecularScale = 0, 0
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(70, 58, 25), 60, 650
	addColor(Color3.fromRGB(255, 243, 175), 0.08, 0.08, -0.01)
	addBloom(0.35, 22, 0.92)
	addAtmosphere(0.28, Color3.fromRGB(200, 175, 95), Color3.fromRGB(70, 55, 20))
	snd(7009793551, 2.5, true)

	local nextFlick = os.clock() + 3
	local conn = RunService.Heartbeat:Connect(function()
		if os.clock() < nextFlick then return end
		nextFlick = os.clock() + 2 + math.random() * 5
		Lighting.Brightness = 1.1
		task.delay(0.06, function() if fx.token == token then Lighting.Brightness = 2 end end)
	end)
	onClear(function() conn:Disconnect() end)
	enterMap(m.spawn)
	task.delay(300, function() if fx.token == token then actions.cleareffects() end end)
	return true
end

actions.backrooms188 = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local m = loadMapModel(15169021437, "FlowHubBackrooms188", Vector3.new(90000, 100, 90000), 7)
	if not m then return false, "model_unavailable" end
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(90, 95, 80), Color3.fromRGB(90, 95, 80)
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(60, 65, 55), 40, 500
	addColor(Color3.fromRGB(235, 245, 220), 0.05, 0.1, -0.02)
	enterMap(m.spawn)
	task.delay(300, function() if fx.token == token then actions.cleareffects() end end)
	return true
end



actions.poolrooms = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local m = loadMapModel(79020643964376, "FlowHubPoolrooms", Vector3.new(0, 1000, 0), 5)
	if not m then return false, "model_unavailable" end
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(200, 230, 235), Color3.fromRGB(200, 230, 235)
	Lighting.Brightness, Lighting.ClockTime = 2.2, 12
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(190, 225, 230), 40, 420
	addColor(Color3.fromRGB(235, 250, 255), 0.05, 0.05, 0.02)
	addBloom(0.5, 24, 0.95)
	addAtmosphere(0.18, Color3.fromRGB(190, 225, 235), Color3.fromRGB(150, 200, 210))
	enterMap(m.spawn)
	task.delay(300, function() if fx.token == token then actions.cleareffects() end end)
	return true
end

actions.fnaf = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local origin = Vector3.new(52000, 100, 52000)
	local m = loadMapModel(116333493682543, "FlowHubFNAF", origin, 3)
	if not m then return false, "model_unavailable" end
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(35, 35, 45), Color3.fromRGB(35, 35, 45)
	Lighting.Brightness, Lighting.ClockTime = 0.8, 0
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.new(0, 0, 0), 30, 400
	addColor(Color3.fromRGB(220, 220, 235), -0.1, 0.15, -0.03)
	enterMap(origin + Vector3.new(0, 3, 58))
	task.delay(300, function() if fx.token == token then actions.cleareffects() end end)
	return true
end

actions.bloxfruits = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	local m = loadMapModel(14078055440, "FlowHubBloxFruits", Vector3.new(70000, 100, 70000), 6)
	if not m then return false, "model_unavailable" end
	local token = {}
	fx.token = token
	enterMap(floorSpawn(m) or m.spawn)
	task.delay(300, function() if fx.token == token then actions.cleareffects() end end)
	return true
end


actions.sukunadomain = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(70, 10, 10), Color3.fromRGB(70, 10, 10)
	Lighting.ClockTime = 0
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(40, 0, 0), 40, 260
	addColor(Color3.fromRGB(255, 120, 120), -0.2, 0.3, -0.05)
	addBloom(0.6, 28, 0.9)
	snd(6590147536, 5, true)
	local look = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
	if look.Magnitude < 0.1 then look = Vector3.new(0, 0, -1) end
	loadMapModel(18726352770, "FlowHubSukuna", hrp.Position + look.Unit * 55 - Vector3.new(0, 3, 0), 0)

	local emberSrc = track(newPart(workspace, Vector3.new(90, 1, 90), hrp.Position + Vector3.new(0, 32, 0), Color3.new(0, 0, 0), Enum.Material.SmoothPlastic, 1, false))
	local pe = Instance.new("ParticleEmitter")
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	pe.Rate, pe.Lifetime, pe.Speed = 90, NumberRange.new(3, 5), NumberRange.new(3, 8)
	pe.EmissionDirection, pe.LightEmission, pe.Acceleration = Enum.NormalId.Bottom, 1, Vector3.new(0, -4, 0)
	pe.Size = NumberSequence.new(0.5)
	pe.Color = ColorSequence.new(Color3.fromRGB(255, 90, 40), Color3.fromRGB(255, 200, 80))
	pe.Parent = emberSrc
	flashScreen(Color3.fromRGB(255, 40, 40), 1)
	shake(2, 0.5)
	task.delay(25, function() if fx.token == token then actions.cleareffects() end end)
	return true
end


actions.hollowpurple = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting(); stashLightingObjects()
	local token = {}
	fx.token = token
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(40, 20, 70), Color3.fromRGB(40, 20, 70)
	Lighting.ClockTime = 0
	local sky = track(Instance.new("Sky"))
	local url = "rbxassetid://155146039"
	sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt, sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = url, url, url, url, url, url
	sky.StarCount = 3000
	sky.Parent = Lighting
	addColor(Color3.fromRGB(215, 170, 255), 0.2, 0.15, 0)
	addBloom(0.8, 30, 0.85)
	snd(82386158155875, 3, false)
	local look = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
	if look.Magnitude < 0.1 then look = Vector3.new(0, 0, -1) end
	look = look.Unit
	local right = look:Cross(Vector3.new(0, 1, 0))
	local center = hrp.Position + look * 40 + Vector3.new(0, 10, 0)
	local function orb(color, pos, size)
		local o = track(newPart(workspace, Vector3.new(size, size, size), pos, color, Enum.Material.Neon, 0.1, false))
		o.Shape = Enum.PartType.Ball
		local l = Instance.new("PointLight")
		l.Color, l.Range, l.Brightness = color, 40, 4
		l.Parent = o
		return o
	end
	local blue = orb(Color3.fromRGB(60, 120, 255), center - right * 22, 7)
	local red = orb(Color3.fromRGB(255, 50, 50), center + right * 22, 7)
	local info = TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	TweenService:Create(blue, info, { Position = center }):Play()
	TweenService:Create(red, info, { Position = center }):Play()
	shake(2.2, 0.3)
	task.delay(2.3, function()
		if fx.token ~= token then return end
		blue:Destroy(); red:Destroy()
		flashScreen(Color3.fromRGB(190, 90, 255), 0.8)
		local purple = orb(Color3.fromRGB(170, 0, 255), center, 10)
		TweenService:Create(purple, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = Vector3.new(70, 70, 70), Position = center + look * 60 }):Play()
		shake(2.4, 0.9)
	end)
	task.delay(4.8, function() if fx.token == token then flashScreen(Color3.new(1, 1, 1), 1.4) end end)
	task.delay(6.5, function() if fx.token == token then actions.cleareffects() end end)
	return true
end


actions.sharingan = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	addColor(Color3.fromRGB(255, 110, 110), 0.1, 0.25, -0.03)
	local eye = track(Instance.new("ImageLabel"))
	eye.BackgroundTransparency, eye.Image, eye.ImageTransparency = 1, "rbxassetid://94089399829471", 1
	eye.SizeConstraint, eye.AnchorPoint = Enum.SizeConstraint.RelativeYY, Vector2.new(0.5, 0.5)
	eye.Position, eye.Size, eye.ZIndex = UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.1, 0, 0.1, 0), 30
	eye.Parent = fxGui()
	TweenService:Create(eye, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0.9, 0, 0.9, 0), ImageTransparency = 0.25 }):Play()
	local t0 = os.clock()
	local spin = RunService.RenderStepped:Connect(function() eye.Rotation = ((os.clock() - t0) * 90) % 360 end)
	onClear(function() spin:Disconnect() end)
	task.delay(3, function() if eye.Parent then TweenService:Create(eye, TweenInfo.new(1.5), { ImageTransparency = 1 }):Play() end end)
	snd(9063717772, 2, false)
	flashScreen(Color3.fromRGB(255, 40, 40), 0.8)
	autoClear(8)
	return true
end


actions.flash = function()
	local hrp, hum = myHRP(), myHum()
	if not (hrp and hum) then return false, "character_unavailable" end
	actions.cleareffects()
	local gold = Color3.fromRGB(255, 200, 40)
	local oldSpeed = hum.WalkSpeed
	hum.WalkSpeed = 200
	onClear(function() if hum.Parent then hum.WalkSpeed = oldSpeed end end)
	local a0, a1 = track(Instance.new("Attachment")), track(Instance.new("Attachment"))
	a0.Position, a1.Position = Vector3.new(0, 1.2, 0), Vector3.new(0, -1.2, 0)
	a0.Parent, a1.Parent = hrp, hrp
	local trail = track(Instance.new("Trail"))
	trail.Attachment0, trail.Attachment1, trail.Lifetime = a0, a1, 0.6
	trail.Color, trail.LightEmission = ColorSequence.new(gold), 1
	trail.Transparency = NumberSequence.new(0, 1)
	trail.Parent = hrp
	local pe = track(Instance.new("ParticleEmitter"))
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	pe.Rate, pe.Lifetime, pe.Speed = 60, NumberRange.new(0.4, 0.7), NumberRange.new(6, 14)
	pe.SpreadAngle, pe.LightEmission, pe.Color = Vector2.new(180, 180), 1, ColorSequence.new(gold)
	pe.Size = NumberSequence.new(0.7)
	pe.Parent = hrp
	local light = track(Instance.new("PointLight"))
	light.Color, light.Range, light.Brightness = gold, 18, 3
	light.Parent = hrp
	flashScreen(gold, 0.4)
	autoClear(15)
	return true
end

actions.flashbang = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects()
	local f = track(Instance.new("Frame"))
	f.Size, f.BackgroundColor3, f.BorderSizePixel, f.ZIndex = UDim2.new(1, 0, 1, 0), Color3.new(1, 1, 1), 0, 80
	f.Parent = fxGui()
	local blur = track(Instance.new("BlurEffect"))
	blur.Size = 56
	blur.Parent = Lighting
	shake(0.5, 1.5)
	task.delay(2.2, function()
		if f.Parent then TweenService:Create(f, TweenInfo.new(3.5), { BackgroundTransparency = 1 }):Play() end
		if blur.Parent then TweenService:Create(blur, TweenInfo.new(4.5), { Size = 0 }):Play() end
	end)
	autoClear(8)
	return true
end


actions.c00lkiddmap = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(90, 0, 0), Color3.fromRGB(90, 0, 0)
	addColor(Color3.fromRGB(255, 120, 120), -0.2, 0.2, 0)
	snd(142930434, 3, true)
	local center, count = hrp.Position, 0
	local mine = myChar()
	for _, p in ipairs(workspace:GetDescendants()) do
		if count >= 400 then break end
		if p:IsA("BasePart") and p.Size.Magnitude > 4 and (p.Position - center).Magnitude < 400 and not p:IsDescendantOf(mine) then
			for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Top }) do
				local d = track(Instance.new("Decal"))
				d.Texture, d.Face = "rbxassetid://77872142365910", face
				d.Parent = p
			end
			count += 1
		end
	end
	autoClear(30)
	return true
end

actions.c00lkiddrush = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 0), Color3.fromRGB(80, 0, 0)
	addColor(Color3.fromRGB(255, 140, 140), -0.1, 0.2, 0)
	return chase({
		image = "rbxassetid://77872142365910", w = 9, h = 11, speed = 22,
		music = 118324869664952, musicVol = 4,
		scareImage = "rbxassetid://77872142365910", scareAudio = "rbxassetid://82347871291422", kill = false, timeout = 45,
	})
end


actions.lifeform = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(60, 8, 8), Color3.fromRGB(60, 8, 8)
	Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(45, 0, 0), 30, 260
	addColor(Color3.fromRGB(255, 140, 140), -0.3, 0.2, 0)
	snd(792323017, 0.6, true)
	return chase({
		image = "rbxassetid://92640402847884", w = 9, h = 11, speed = 17,
		music = 1840320106, musicVol = 1,
		scareImage = JUMPS.jumps3[1], scareAudio = JUMPS.jumps3[2], kill = true, timeout = 60,
	})
end


for name, data in pairs(JUMPS) do
	actions[name] = function()
		if not myHRP() then return false, "character_unavailable" end
		return jumpscare(data[1], data[2], 2.4)
	end
end


actions.unloopkill = function()
	if basic.loopConn then basic.loopConn:Disconnect(); basic.loopConn = nil end
	return true
end
actions.loopkill = function()
	if not myHum() then return false, "character_unavailable" end
	actions.unloopkill()
	local function kill() local h = myHum(); if h then h.Health = 0 end end
	basic.loopConn = LocalPlayer.CharacterAdded:Connect(function() task.wait(1); kill() end)
	kill()
	return true
end

actions.unfloat = function()
	if basic.floatBV then basic.floatBV:Destroy(); basic.floatBV = nil end
	return true
end
actions.float = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.unfloat()
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce, bv.Velocity = Vector3.new(1e6, 1e6, 1e6), Vector3.new(0, 28, 0)
	bv.Parent = hrp
	basic.floatBV = bv
	task.delay(20, function() if basic.floatBV == bv then actions.unfloat() end end)
	return true
end

actions.killplus = function()
	local c, hrp = myChar(), myHRP()
	if not (c and hrp) then return false, "character_unavailable" end
	local pos = hrp.Position
	local folder = Instance.new("Folder")
	folder.Name = "FlowHubKillPlus"
	folder.Parent = workspace
	for _ = 1, 24 do
		local p = newPart(folder, Vector3.new(1.2, 1.2, 6), pos + Vector3.new(math.random(-35, 35), math.random(0, 25), math.random(-35, 35)), Color3.fromRGB(255, 30, 30), Enum.Material.Neon, 0.1, false)
		p.CFrame = CFrame.lookAt(p.Position, pos)
		TweenService:Create(p, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = pos }):Play()
	end
	task.delay(0.65, function()
		local h = myHum()
		if h then h.Health = 0 end
		pcall(function() c:BreakJoints() end)
	end)
	task.delay(3, function() folder:Destroy() end)
	return true
end

actions.fling = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.unjail(); actions.unfreeze()
	local a = math.random() * math.pi * 2
	hrp.AssemblyLinearVelocity = Vector3.new(math.cos(a) * 450, 300, math.sin(a) * 450)
	hrp.AssemblyAngularVelocity = Vector3.new(60, 60, 60)
	return true
end

actions.anonny = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	local dir = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
	local t0, conn = os.clock(), nil
	conn = RunService.Heartbeat:Connect(function()
		local r = myHRP()
		if not r or os.clock() - t0 > 1.4 then conn:Disconnect(); return end
		r.AssemblyLinearVelocity = dir.Unit * 90 + Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
	end)
	return true
end

actions.unglitch = function()
	if basic.glitchConn then basic.glitchConn:Disconnect(); basic.glitchConn = nil end
	return true
end
actions.glitch = function()
	if not myHRP() then return false, "character_unavailable" end
	actions.unglitch()
	local t0 = os.clock()
	basic.glitchConn = RunService.Heartbeat:Connect(function()
		local r = myHRP()
		if not r or os.clock() - t0 > 20 then actions.unglitch(); return end
		r.CFrame = r.CFrame * CFrame.new((math.random() - 0.5) * 1.2, (math.random() - 0.5) * 0.8, (math.random() - 0.5) * 1.2) * CFrame.Angles(0, math.rad(math.random(-25, 25)), 0)
	end)
	return true
end

actions.rejoin = function()
	task.delay(0.5, function()
		pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
	end)
	return true
end

actions.ragdoll = function()
	local hum, hrp = myHum(), myHRP()
	if not (hum and hrp) then return false, "character_unavailable" end
	hum.PlatformStand = true
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Ragdoll) end)
	hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(0, 30, 0)
	snd(9113964719, 1, false)
	task.delay(5, function()
		if hum.Parent then
			hum.PlatformStand = false
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
		end
	end)
	return true
end

actions.ungodmode = function()
	if basic.god then
		local h = myHum()
		if h then h.MaxHealth = basic.god.max; h.Health = math.min(h.Health, basic.god.max) end
		if basic.god.ff and basic.god.ff.Parent then basic.god.ff:Destroy() end
		basic.god = nil
	end
	return true
end
actions.godmode = function()
	local c, h = myChar(), myHum()
	if not (c and h) then return false, "character_unavailable" end
	actions.ungodmode()
	local ff = Instance.new("ForceField")
	ff.Visible = false
	ff.Parent = c
	basic.god = { max = h.MaxHealth, ff = ff }
	h.MaxHealth, h.Health = 1e9, 1e9
	return true
end

actions.unspeed = function()
	local h = myHum()
	if h then h.WalkSpeed = basic.speedOld or 16 end
	basic.speedOld = nil
	return true
end
actions.speed = function()
	local h = myHum()
	if not h then return false, "character_unavailable" end
	basic.speedOld = basic.speedOld or h.WalkSpeed
	h.WalkSpeed = 200
	return true
end

local GONER_IDS = { 11274394350, 17822749561, 17812417356, 17812415139, 17771175724, 17822722698, 17772174303, 17770317484, 892268340, 892267099, 2510236649 }
actions.goner = function()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local wear = remotes and remotes:FindFirstChild("Wear")
	if not wear then return false, "wear_unavailable" end
	task.spawn(function()
		for _, id in ipairs(GONER_IDS) do
			pcall(function() wear:InvokeServer(id) end)
			task.wait(0.18)
		end
	end)
	return true
end

actions.nuke = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects(); saveLighting()
	local center = hrp.Position + hrp.CFrame.LookVector * 160 + Vector3.new(0, 40, 0)
	banner("⚠ NUKE INCOMING — RUN ⚠", Color3.fromRGB(255, 70, 50), 6)
	useAsset(792323017, { volume = 1, looped = true })
	local cc = track(Instance.new("ColorCorrectionEffect"))
	cc.Parent = Lighting
	local t0 = os.clock()
	local warn = RunService.Heartbeat:Connect(function()
		local k = (math.sin((os.clock() - t0) * 8) + 1) / 2
		cc.TintColor = Color3.new(1, 1 - k * 0.6, 1 - k * 0.6)
	end)
	onClear(function() warn:Disconnect() end)
	local token = {}
	fx.token = token
	task.delay(5, function()
		if fx.token ~= token then return end
		warn:Disconnect(); cc.TintColor = Color3.new(1, 1, 1)
		Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = Color3.fromRGB(255, 140, 50), 20, 450
		Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(255, 160, 80), Color3.fromRGB(255, 160, 80)
		local ball = track(newPart(workspace, Vector3.new(10, 10, 10), center, Color3.fromRGB(255, 150, 40), Enum.Material.Neon, 0, false))
		ball.Shape = Enum.PartType.Ball
		local wave = track(newPart(workspace, Vector3.new(1, 20, 20), center - Vector3.new(0, 38, 0), Color3.fromRGB(255, 220, 160), Enum.Material.Neon, 0.3, false))
		wave.Shape, wave.Orientation = Enum.PartType.Cylinder, Vector3.new(0, 0, 90)
		TweenService:Create(ball, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Vector3.new(420, 420, 420), Transparency = 0.6 }):Play()
		TweenService:Create(wave, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = Vector3.new(1, 900, 900), Transparency = 1 }):Play()
		flashScreen(Color3.new(1, 1, 1), 2)
		useAsset(105844494615983, { volume = 1, seconds = 2 })
		shake(5, 2.5)
		task.delay(7, function() if fx.token == token then actions.cleareffects() end end)
	end)
	return true
end

actions.blackhole = function()
	local hrp = myHRP()
	if not hrp then return false, "character_unavailable" end
	actions.cleareffects()
	local center = hrp.Position + Vector3.new(0, 45, 0) + hrp.CFrame.LookVector * 30
	local folder = track(Instance.new("Folder"))
	folder.Name = "FlowHubBlackHole"; folder.Parent = workspace
	local core = newPart(folder, Vector3.new(22, 22, 22), center, Color3.new(0, 0, 0), Enum.Material.SmoothPlastic, 0, false)
	core.Shape = Enum.PartType.Ball
	local light = Instance.new("PointLight")
	light.Color, light.Range, light.Brightness = Color3.fromRGB(255, 140, 40), 60, 4
	light.Parent = core
	local rings = {}
	for i = 1, 3 do
		local d = 46 + i * 18
		local r = newPart(folder, Vector3.new(0.6, d, d), center, Color3.fromRGB(255, 170 - i * 35, 40), Enum.Material.Neon, 0.15 + i * 0.15, false)
		r.Shape = Enum.PartType.Cylinder
		rings[i] = r
	end
	local t0 = os.clock()
	local conn = RunService.Heartbeat:Connect(function()
		local t = os.clock() - t0
		for i, r in ipairs(rings) do
			r.CFrame = CFrame.new(center) * CFrame.Angles(0, t * (1 + i * 0.4), 0) * CFrame.Angles(math.rad(20), 0, 0) * CFrame.Angles(0, 0, math.rad(90))
		end
	end)
	onClear(function() conn:Disconnect() end)
	shake(3, 0.5)
	banner("BLACK HOLE", Color3.fromRGB(255, 150, 60), 4)
	useAsset(6933037531, { volume = 1, looped = true })
	autoClear(30)
	return true
end

function Core:HandleCommand(cmd)
	local run = actions[cmd.type]
	if not run then return ack(self, cmd.id, "failed", "unknown_command") end


	local ok, res, why = pcall(run, self, cmd)
	if ok and res then
		ack(self, cmd.id, "done")
	else
		ack(self, cmd.id, "failed", tostring(ok and why or res))
	end
end

function Core:_syncLoop()
	local interval, failures = 4, 0
	while self.Running do
		local data, err = self:Api("POST", "/v1/client/sync", { jobId = game.JobId, placeId = game.PlaceId, username = LocalPlayer.Name })
		if data then
			failures, interval = 0, 4
			for _, cmd in ipairs(data.commands or {}) do task.spawn(self.HandleCommand, self, cmd) end
		else
			failures += 1
			interval = math.min(4 * 2 ^ failures, 30)
			if failures == 1 then warn("[FlowHub] API sync failed: " .. tostring(err and err.code)) end
		end
		task.wait(interval)
	end
end


function Core:LoadAdminPanel()
	if self.PanelLoaded or not (self.Session and self.Session.isAdmin) then return false end
	local code, err = self:Api("GET", "/v1/admin/panel", nil, { raw = true })
	if not code then
		notify(self, "Admin Panel", "Could not load the admin panel: " .. tostring(err and err.message), "Error")
		return false
	end
	local fn, compileErr = loadstring(code)
	if not fn then
		warn("[FlowHub] admin panel compile error: " .. tostring(compileErr))
		return false
	end
	local ok, runErr = pcall(fn, { Core = self, Lib = self.Lib, Window = self.Window })
	if not ok then
		warn("[FlowHub] admin panel runtime error: " .. tostring(runErr))
		notify(self, "Admin Panel", "Panel failed to start (see console)", "Error")
		return false
	end
	self.PanelLoaded = true
	return true
end


function Core:LoadTestMyself()
	if self.TestLoaded or not (self.Session and (self.Session.isAdmin or self.Session.role == "owner")) then return end
	self.TestLoaded = true
	local tab = self.Window:MakeTab({ "Test Myself", "🧪" })
	local message = ""
	local counter = 0
	local function run(kind, payload)
		counter += 1
		self:HandleCommand({
			id = "local:" .. kind .. counter, type = kind,
			fromName = LocalPlayer.Name, fromUserId = LocalPlayer.UserId, payload = payload or {},
		})
	end
	local function spectateSelf()
		local cam = workspace.CurrentCamera
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if cam and hum then cam.CameraSubject = hum end
	end

	tab:AddParagraph({ Title = "Test Myself", Text = "Runs the admin functions directly on yourself, without confirmation dialogs." })
	tab:AddSection({ "Moderation" })
	tab:AddButton({ Name = "Bring", Description = "Teleports you in front of yourself", Callback = function() run("bring", { toUserId = LocalPlayer.UserId }) end })
	tab:AddButton({ Name = "Verify", Description = "Sends the verification chat message", Callback = function() run("verify") end })
	tab:AddButton({ Name = "Kick Player", Description = "Kicks your test character from the server", Callback = function() run("kick", { reason = "Test" }) end })
	tab:AddButton({ Name = "Kamui", Description = "Toggles Kamui FE on your test character", Callback = function() run("kamui") end })
	tab:AddSection({ "Basic Commands" })
	local basicMap = {
		["Freeze Player"] = "freeze", ["Unfreeze Player"] = "unfreeze", ["Kill Player"] = "kill", ["Jail Player"] = "jail", ["Unjail Player"] = "unjail", ["Explode Player"] = "explode",
		["Loop Kill"] = "loopkill", ["Stop Loop Kill"] = "unloopkill", ["Float"] = "float", ["Stop Float"] = "unfloat", ["Kill+"] = "killplus", ["Fling"] = "fling", ["Anonny"] = "anonny",
		["Glitch"] = "glitch", ["Stop Glitch"] = "unglitch", ["Rejoin"] = "rejoin", ["Ragdoll"] = "ragdoll", ["God Mode"] = "godmode", ["Remove God Mode"] = "ungodmode",
		["Speed 200"] = "speed", ["Reset Speed"] = "unspeed", ["Goner"] = "goner",
	}
	local basicOptions = { "Freeze Player", "Unfreeze Player", "Kill Player", "Jail Player", "Unjail Player", "Explode Player", "Loop Kill", "Stop Loop Kill", "Float", "Stop Float", "Kill+", "Fling", "Anonny", "Glitch", "Stop Glitch", "Rejoin", "Ragdoll", "God Mode", "Remove God Mode", "Speed 200", "Reset Speed", "Goner" }
	local basicPick = basicOptions[1]
	tab:AddDropdown({ Name = "Command", Description = "Pick a basic command to run on yourself", Options = basicOptions, Default = basicPick, Callback = function(v) if v then basicPick = v end end })
	tab:AddButton({ Name = "Run command", Description = "Runs the command directly", Callback = function() run(basicMap[basicPick]) end })
	tab:AddSection({ "Maps" })
	local mapMap = { ["Backrooms"] = "backrooms", ["Backrooms Level 188"] = "backrooms188", ["Poolrooms"] = "poolrooms", ["Domain Expansion (Gojo)"] = "domain", ["FNAF Chapter 1"] = "fnaf", ["Blox Fruits"] = "bloxfruits", ["The Lifeform"] = "lifeform" }
	local mapOptions = { "Backrooms", "Backrooms Level 188", "Poolrooms", "Domain Expansion (Gojo)", "FNAF Chapter 1", "Blox Fruits", "The Lifeform" }
	local mapPick = mapOptions[1]
	tab:AddDropdown({ Name = "Map", Description = "Pick a map to enter", Options = mapOptions, Default = mapPick, Callback = function(v) if v then mapPick = v end end })
	tab:AddButton({ Name = "Go to map", Description = "Runs the command directly", Callback = function() run(mapMap[mapPick]) end })
	tab:AddSection({ "Jumpscares" })
	local jumpMap = { ["Jumpscare 1"] = "jumps1", ["Jumpscare 2"] = "jumps2", ["Jumpscare 3"] = "jumps3", ["Jumpscare 4"] = "jumps4", ["Jeff The Killer"] = "jeffjumpscare", ["C00lkidd Rush"] = "c00lkiddrush" }
	local jumpOptions = { "Jumpscare 1", "Jumpscare 2", "Jumpscare 3", "Jumpscare 4", "Jeff The Killer", "C00lkidd Rush" }
	local jumpPick = jumpOptions[1]
	tab:AddDropdown({ Name = "Jumpscare", Description = "Pick a jumpscare to run on yourself", Options = jumpOptions, Default = jumpPick, Callback = function(v) if v then jumpPick = v end end })
	tab:AddButton({ Name = "Run jumpscare", Description = "Runs the command directly", Callback = function() run(jumpMap[jumpPick]) end })
	tab:AddSection({ "Effects" })
	local fxOptions = { "Sukuna Domain", "Hollow Purple", "Sharingan", "Flash", "Flashbang", "C00lkidd Map", "Nuke", "Black Hole", "Clear effects" }
	local fxType = { ["Sukuna Domain"] = "sukunadomain", ["Hollow Purple"] = "hollowpurple", ["Sharingan"] = "sharingan", ["Flash"] = "flash", ["Flashbang"] = "flashbang", ["C00lkidd Map"] = "c00lkiddmap", ["Nuke"] = "nuke", ["Black Hole"] = "blackhole", ["Clear effects"] = "cleareffects" }
	local fxPick = fxOptions[1]
	tab:AddDropdown({ Name = "Effect", Description = "Pick an effect to run on yourself", Options = fxOptions, Default = fxPick, Callback = function(v) if v then fxPick = v end end })
	tab:AddButton({ Name = "Run effect", Description = "Runs the command directly", Callback = function() run(fxType[fxPick]) end })
	tab:AddSection({ "Spectate" })
	tab:AddButton({ Name = "Start Spectate", Description = "Points the camera at yourself", Callback = spectateSelf })
	tab:AddButton({ Name = "Stop Spectate", Description = "Returns the camera to your character", Callback = spectateSelf })
	tab:AddSection({ "CHT" })
	tab:AddTextBox({ Title = "Message", Description = "Text you will be asked to send", PlaceholderText = "Type a message...", Default = "", ClearText = false, Callback = function(v) message = tostring(v or "") end })
	tab:AddButton({ Name = "Send", Description = "Sends the message directly", Callback = function() run("chat", { message = message }) end })
end

function Core:Start(cfg)
	assert(cfg and cfg.ApiUrl and cfg.Lib and cfg.Window, "Core:Start needs ApiUrl, Lib and Window")
	if self.Running then return end
	self.ApiUrl = cfg.ApiUrl:gsub("/+$", "")
	self.Lib, self.Window = cfg.Lib, cfg.Window
	self.Running = true

	task.spawn(function()
		local ok, err = self:Authenticate()
		if ok and self.Session.locked then
			warn("[FlowHub] this account is an admin, but another device is registered for it")
			notify(self, "Admin", "This device is not registered for your admin account", "Error")
		elseif not ok then
			warn("[FlowHub] API unreachable: " .. tostring(err and (err.code or err.message)))
		end
		if not ok then

			warn("[FlowHub] API unavailable — running in normal mode")
			while self.Running and not self.Session do
				task.wait(20)
				self:Authenticate()
			end
		end
		if self.Session and self.Session.isAdmin then
			self:LoadAdminPanel()
			self:LoadTestMyself()
		end
		self:_syncLoop()
	end)
end

function Core:Stop() self.Running = false end

return Core

end)() end)
	if not okCore or not Core then
		warn("[FlowHub] core.lua indisponível — modo normal (sem admin)")
		return
	end
	getgenv().FlowHubCore = Core
	Core:Start({ ApiUrl = API_URL, Lib = lib, Window = v13 })
end)


local t4 = {
	defaultSpeed = 16,
	defaultJumpPower = 50,
	defaultGravity = 196.2,
	colorSpeed = 25,
	updateInterval = 1,
	statusUpdateInterval = 1
}
local t5 = {
	speedValue = t4.defaultSpeed,
	jumpPower = t4.defaultJumpPower,
	gravityValue = t4.defaultGravity
}
local v22 = t3.M:AddParagraph({ t1:traduzir("Tempo De Uso De Script") })
local n1 = 0

task.spawn(function()
	while true do
		v22:Set("  " .. string.format("%02d:%02d:%02d", math.floor(n1 / 3600), math.floor(n1 % 3600 / 60), n1 % 60))
		n1 += t4.statusUpdateInterval
		task.wait(t4.statusUpdateInterval)
	end
end)


local v28 = t3.M:AddParagraph({ t1:traduzir("Quantidade De Pessoas") })

local function v29()
	v28:Set("  " .. #Players:GetPlayers())
end

Players.PlayerAdded:Connect(v29)
Players.PlayerRemoving:Connect(v29)
v29()

local nomeDoJogo = "Unknown Game"
local ok2, result = pcall(function()
	return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)

if ok2 and result then
	nomeDoJogo = result.Name
end

t3.M:AddSection({ t1:traduzir("Mapa Status") })
t3.M:AddParagraph({ Title = "Nome do Jogo", Text = nomeDoJogo })
t3.M:AddParagraph({ Title = "Executor", Text = (identifyexecutor and identifyexecutor() or "Desconhecido") })
task.spawn(function()
	task.wait(0)

	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local LocalPlayer2 = Players2.LocalPlayer
	local v36 = ReplicatedStorage2:WaitForChild("RE"):WaitForChild("1Playe1rTrigge1rEven1t")

	local v36b = ReplicatedStorage2:WaitForChild("RE"):FindFirstChild("1Too1l")

	-- Brookhaven usa 2 remotes diferentes: itens escondidos/VIP vêm por
	-- 1Too1l:InvokeServer("PickingTools", nome); itens de evento por
	-- 1Playe1rTrigge1rEven1t:FireServer("AcceptedToolToServer", nome, player).
	local function hasTool(name)
		local bp = LocalPlayer2:FindFirstChild("Backpack")
		local char = LocalPlayer2.Character
		return (bp and bp:FindFirstChild(name)) or (char and char:FindFirstChild(name))
	end
	local function getLib()
		local env = (getgenv and getgenv()) or _G
		return env.FlowLib or _G.FlowLib
	end
	local function notify(cfg)
		pcall(function()
			local L = getLib()
			if L then L:Notify(cfg) end
		end)
	end
	local function isPt()
		local L = getLib()
		return L and L.Lang == "pt"
	end
	local lastDebug = ""
	local function requestTool(name, eventFirst)
		local function picking()
			if v36b then
				local ok, res = pcall(function() return v36b:InvokeServer("PickingTools", name) end)
				lastDebug = "PickingTools -> ok=" .. tostring(ok) .. " ret=" .. tostring(res)
				print("[Flowbrook] " .. name .. " " .. lastDebug)
			else
				lastDebug = "remote 1Too1l nao encontrado"
			end
		end
		local function accepted()
			pcall(function() v36:FireServer("AcceptedToolToServer", name, LocalPlayer2) end)
		end
		local first, second = picking, accepted
		if eventFirst then first, second = accepted, picking end
		first()
		task.wait(0.4)
		if not hasTool(name) then second() end
	end

	local function v37(p3, label, eventFirst)
		if not p3 then
			return
		end

		requestTool(p3, eventFirst)

		-- O FireServer acima nunca avisa se o servidor aceitou ou ignorou o pedido
		-- (ex: item de evento sazonal fora do período fica mudo). Aqui a gente
		-- confere se a Tool realmente apareceu e avisa o resultado, em vez de
		-- ficar "sem nada acontecer" sem explicação. (Sem task.spawn aninhado: em
		-- alguns executores mobile isso corrompia o upvalue de Lib lá dentro.)
		-- Espera até ~3s a Tool aparecer (o servidor pode demorar) e então EQUIPA
		-- na mão. Antes o item chegava só na Backpack e nunca ia pra mão.
		local got
		for _ = 1, 15 do
			task.wait(0.2)
			local bp = LocalPlayer2:FindFirstChild("Backpack")
			local char = LocalPlayer2.Character
			got = (bp and bp:FindFirstChild(p3)) or (char and char:FindFirstChild(p3))
			if got then break end
		end

		if got and got:IsA("Tool") then
			local char = LocalPlayer2.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and got.Parent ~= char then
				pcall(function() hum:EquipTool(got) end)
				task.wait(0.1)
				if got.Parent ~= char then
					pcall(function() got.Parent = char end)
				end
			end
		end

		if got then
			notify({ Title = "Item", Type = "Success",
				Description = (label or p3) .. (isPt() and " recebido!" or " received!"), Duration = 3 })
		else
			notify({ Title = "Item", Type = "Error",
				Description = (isPt()
					and ("Servidor não liberou \"" .. (label or p3) .. "\" agora (provável item fora do evento/indisponível).")
					or ("Server didn't grant \"" .. (label or p3) .. "\" right now (likely out of event/unavailable).")) .. " [" .. tostring(p3) .. " | " .. lastDebug .. "]",
				Duration = 5 })
		end
	end

	-- Lista única: itens escondidos + Balão de Água. { [nome na lista] = { id, eventFirst } }
	local itemList = {
		["Livro Velho"] = { "AgencyBook" },
		["Chave Velha"] = { "BankGateKey" },
		["Mangueira"] = { "FireHose" },
		["Sacola de Diamantes"] = { "DuffleBagDiamonds" },
		["Chave de Ouro"] = { "OldKey" },
		["Sofa"] = { "Couch" },
		["Espada de Ouro"] = { "SwordGold" },
		["Balão de Água"] = { "Water Balloon", true },
	}
	local function v42(p4)
		local t10 = {}

		for k in pairs(p4) do
			table.insert(t10, k)
		end
		table.sort(t10)

		return t10
	end

	t3.H:AddSection({ t1:traduzir("Search Itens") })

	local selectedItem
	t3.H:AddDropdown({
		Name = t1:traduzir("Itens"),
		Description = t1:traduzir("Selecione um item"),
		Options = v42(itemList),
		Default = "Item",
		Callback = function(p7)
			if p7 and itemList[p7] then selectedItem = p7 end
			-- só seleciona; coleta apenas no botão "Pegar Item"
		end
	})
	t3.H:AddButton({
		Name = t1:traduzir("Pegar Item"),
		Description = t1:traduzir("Pega o item selecionado"),
		Callback = function()
			local it = selectedItem and itemList[selectedItem]
			if it then
				v37(it[1], selectedItem, it[2])
			else
				notify({ Title = "Item", Type = "Info",
					Description = isPt() and "Selecione um item na lista primeiro." or "Select an item from the list first.",
					Duration = 3 })
			end
		end
	})
	t3.H:AddSection({ t1:traduzir("Super Poderes") })

	local function v50(p10, p11)
		local v51 = tonumber(p10)
		local v52 = v51 and v51

		return v52 or p11
	end
	local function v53(p12, p13)
		local Character_ = LocalPlayer.Character

		if Character_ then
			if Character_:FindFirstChild("Humanoid") then
				Character_.Humanoid[p12] = p13
			end
		end
	end

	local speedBox = t3.H:AddTextBox({
		Title = t1:traduzir("Velocidade"),
		Description = "Definir A Velocidade",
		Default = tostring(t4.defaultSpeed),
		PlaceholderText = "Speed",
		ClearText = false,
		Callback = function(p14)
			t5.speedValue = v50(p14, t4.defaultSpeed)
			v53("WalkSpeed", t5.speedValue)
		end
	})
	local jumpBox = t3.H:AddTextBox({
		Title = t1:traduzir("Pulos"),
		Description = t1:traduzir("Definir Os Pulos"),
		Default = tostring(t4.defaultJumpPower),
		PlaceholderText = "Jump",
		ClearText = false,
		Callback = function(p15)
			t5.jumpPower = v50(p15, t4.defaultJumpPower)
			v53("JumpPower", t5.jumpPower)
		end
	})
	local gravityBox = t3.H:AddTextBox({
		Title = t1:traduzir("Gravidade"),
		Description = t1:traduzir("Definir A Gravidade"),
		Default = tostring(t4.defaultGravity),
		PlaceholderText = "Gravity",
		ClearText = false,
		Callback = function(p16)
			t5.gravityValue = v50(p16, t4.defaultGravity)
			workspace.Gravity = t5.gravityValue
		end
	})
	t3.H:AddButton({
		t1:traduzir("Reseta <Velocidade/Gravidade/Pulos>"),
		function()
			t5.jumpPower = t4.defaultJumpPower
			t5.speedValue = t4.defaultSpeed
			t5.gravityValue = t4.defaultGravity
			v53("JumpPower", t5.jumpPower)
			v53("WalkSpeed", t5.speedValue)
			workspace.Gravity = t5.gravityValue
			-- Sem isso as caixas de texto continuavam mostrando o número antigo
			-- mesmo depois do reset (AddTextBox:Set só troca o texto, não dispara o Callback).
			speedBox:Set(t5.speedValue)
			jumpBox:Set(t5.jumpPower)
			gravityBox:Set(t5.gravityValue)
		end
	})

	-- Reaplica Velocidade/Pulo toda vez que o personagem respawna (morte, teleporte,
	-- certas ações do hub, etc). Sem isso o Roblox volta pro WalkSpeed/JumpPower
	-- padrão do jogo a cada novo Humanoid, mesmo que o valor nas caixas de texto
	-- continue mostrando o número que você definiu.
	LocalPlayer.CharacterAdded:Connect(function(char_)
		task.wait(0.1)
		local hum_ = char_:WaitForChild("Humanoid", 5)
		if hum_ then
			hum_.WalkSpeed = t5.speedValue
			hum_.JumpPower = t5.jumpPower
		end
	end)
	t3.H:AddSection({ t1:traduzir("Repetição De Nomes") })

	local v55 = ReplicatedStorage2.RE:FindFirstChild("1RPNam1eTex1t")
	local s1 = ""
	local s2 = ""
	local s3 = ""
	local u59 = false

	t3.H:AddTextBox({
		Title = t1:traduzir("Nome"),
		Description = t1:traduzir("Primeiro Nome Da Repetição!"),
		Default = "",
		PlaceholderText = lib:T("Nick Aqui"),
		ClearText = false,
		Callback = function(p17)
			s1 = p17
		end
	})
	t3.H:AddTextBox({
		Title = t1:traduzir("Nome"),
		Description = t1:traduzir("Segundo Nome Da Repetição!"),
		Default = "",
		PlaceholderText = lib:T("Nick Aqui"),
		ClearText = false,
		Callback = function(p18)
			s2 = p18
		end
	})
	t3.H:AddTextBox({
		Title = t1:traduzir("Nome"),
		Description = t1:traduzir("Terceiro Nome Da Repetição!"),
		Default = "",
		PlaceholderText = lib:T("Nick Aqui"),
		ClearText = false,
		Callback = function(p19)
			s3 = p19
		end
	})

	local function v60()
		return Color3.new(math.random(), math.random(), math.random())
	end

	local v61 = ReplicatedStorage2.RE:FindFirstChild("1RPNam1eColo1r")
	local u62 = false

	local function v63()
		while u62 do
			local v64 = v60()

			v61:FireServer(unpack({
				"PickingRPNameColor",
				v64
			}))
			task.wait(0.5)
		end
	end

	t3.H:AddToggle({
		Name = t1:traduzir("NOME RGB"),
		Description = t1:traduzir("mudar a cor dos nomes automático"),
		Default = false
	}):Callback(function(p20)
		u62 = p20

		if u62 then
			task.spawn(v63)
		end
	end)
	t3.H:AddToggle({
		Name = t1:traduzir("Reptir Nomes"),
		Description = t1:traduzir("Repitir nomes da textbox automaticamente"),
		Default = false
	}):Callback(function(p21)
		u59 = p21

		if p21 then
			task.spawn(function()
				while u59 do
					if v55 then
						v55:FireServer("RolePlayName", s1)
						task.wait(1)
						v55:FireServer("RolePlayName", s2)
						task.wait(1)
						v55:FireServer("RolePlayName", s3)
						task.wait(1)
					end
				end
			end)
		end
	end)
	t3.TT:AddSection({ t1:traduzir("Navio Pirado") })

	local t12 = {
		tornadoActive = false,
		currentShip = nil
	}

	local function v66()
		local Character_ = LocalPlayer.Character

		if not Character_ then
			return nil
		end

		local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return nil
		end

		HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
		task.wait(0.5)
		ReplicatedStorage2:WaitForChild("RE"):FindFirstChild("1Ca1r"):FireServer("PickingBoat", "PirateFree")
		task.wait(1)

		return workspace:WaitForChild("Vehicles"):FindFirstChild(LocalPlayer.Name .. "Car")
	end
	local function v69()
		local t13 = {
			workspace,
			9068077052,
			1
		}

		for i = 1, 5 do
			local v72 = ReplicatedStorage2.RE:FindFirstChild("1Gu1nSound1s")

			if v72 then
				v72:FireServer(unpack(t13))
			end

			if LocalPlayer.Character then
				if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local Sound = Instance.new("Sound")

					Sound.SoundId = "rbxassetid://9068077052"
					Sound.Parent = LocalPlayer.Character.HumanoidRootPart
					Sound:Play()
					task.wait(1.5)
					Sound:Destroy()
				end
			end
		end
	end
	local function v74()
		t12.currentShip = v66()

		if not t12.currentShip then
			return
		end

		local Body = t12.currentShip:FindFirstChild("Body")
		local VehicleSeat = Body and Body:FindFirstChild("VehicleSeat")

		if not VehicleSeat then
			return
		end

		local Character_ = LocalPlayer.Character
		local Humanoid_ = Character_:FindFirstChild("Humanoid")
		local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

		if not Humanoid_ or not HumanoidRootPart then
			return
		end

		repeat
			task.wait(0.1)
			HumanoidRootPart.CFrame = VehicleSeat.CFrame * CFrame.new(0, 1, 0)
		until Humanoid_.SeatPart == VehicleSeat

		task.spawn(v69)
		task.delay(4, function()
			if Humanoid_.SeatPart then
				Humanoid_.Sit = false
			end

			HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)
		end)
		t12.tornadoActive = true
		task.spawn(function()
			local v80 = ReplicatedStorage2:WaitForChild("RE"):WaitForChild("1Player1sCa1r")

			while t12.tornadoActive and t12.currentShip and t12.currentShip.Parent do
				v80:FireServer("Flip")
				task.wait(0.5)
			end
		end)

		local t14 = {
			Vector3.new(-16, 0, -47),
			Vector3.new(-110, 0, -45),
			Vector3.new(16, 0, -55)
		}
		local n4 = 1
		local n5 = 2
		local v84 = math.rad(720)
		local n6 = 0
		local n7 = 0
		local connection

		connection = RunService.Heartbeat:Connect(function(dt)
			if not t12.tornadoActive or not t12.currentShip or not t12.currentShip.PrimaryPart then
				connection:Disconnect()

				return
			end

			local v88 = t14[n4]
			local v89 = t14[n5]

			n6 += 30 * dt / (v88 - v89).Magnitude

			if n6 >= 1 then
				n6 = 0
				n4 = n5
				n5 = n5 % #t14 + 1
			end

			local v90 = v88:lerp(v89, n6)

			n7 += v84 * dt
			t12.currentShip:SetPrimaryPartCFrame(CFrame.new(v90) * CFrame.Angles(0, n7, 0))
		end)
	end
	local function v91()
		t12.tornadoActive = false
		task.spawn(function()
			ReplicatedStorage2:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack({ "DeleteAllVehicles" }))
		end)
	end

	local v92 = t3.TT:AddToggle({
		Name = t1:traduzir("Tornado - Navio Pirata"),
		Description = t1:traduzir("Puxa Navio Pirata para a praça"),
		Default = false
	})

	v92:Callback(function(p22)
		if p22 then
			v74()
			task.wait(5)
			v92:SetValue(false)
		else
			v91()
		end
	end)
end)
task.spawn(function()
	task.wait(3)
	t3.E:AddSection({ t1:traduzir("Items RGB") })

	local u124 = false
	local thread
	local n8 = 1
	local SetAccessoryColor = game:GetService("ReplicatedStorage").Remotes.SetAccessoryColor
	local SetColor = game:GetService("Players").LocalPlayer.PlayerGui.NoResetGUIHandler.AvatarEditorHolder.AvatarEditorMenu.AccessoryAdjustments.Container.MainView.ReflectanceColor.UIColorPicker.SetColor

	local function v129(p31, p32, p33)
		pcall(function()
			SetColor:FireServer(Color3.new(p31, p32, p33))
		end)
		pcall(function()
			SetAccessoryColor:InvokeServer(76584966174761, {
				color = {
					r = p31,
					g = p32,
					b = p33
				}
			})
		end)
	end

	t3.E:AddToggle({
		Name = t1:traduzir("RGB Items"),
		Description = t1:traduzir("o efeito RGB nos itens"),
		Default = false,
		Callback = function(p34)
			u124 = p34

			if p34 then
				thread = task.spawn(function()
					local n9 = 0

					while u124 do
						n9 = (n9 + n8 * 0.005) % 1

						local color3 = Color3.fromHSV(n9, 1, 1)

						v129(color3.R, color3.G, color3.B)
						task.wait(0.05)
					end
				end)
			elseif thread then
				task.cancel(thread)
				thread = nil
			end
		end
	})
	t3.E:AddSlider({
		Name = t1:traduzir("Velocidade RGB"),
		Min = 1,
		Max = 25,
		Increase = 1,
		Default = "1",
		Callback = function(p35)
			n8 = p35
		end
	})
	t3.E:AddSection({ t1:traduzir("Resoluções Da Tela") })

	local function v132(p36)
		getgenv().Resolution = {
			[".gg/scripters"] = p36
		}

		if getgenv().gg_scripters == nil then
			game:GetService("RunService").RenderStepped:Connect(function()
				workspace.CurrentCamera.CFrame *= CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
			end)
		end

		getgenv().gg_scripters = "Aori0001"
	end

	t3.E:AddButton({
		Name = t1:traduzir("Resolução Normal"),
		Callback = function()
			v132(1)
		end
	})
	t3.E:AddButton({
		Name = t1:traduzir("Resolução 0.70"),
		Callback = function()
			v132(0.7)
		end
	})
	t3.E:AddButton({
		Name = t1:traduzir("Resolução 0.80"),
		Callback = function()
			v132(0.8)
		end
	})
	t3.E:AddSection({ t1:traduzir("Sistema Lgbt") })

	local colorSpeed = t4.colorSpeed

	t3.E:AddSlider({
		Name = t1:traduzir("Velocidade das cores"),
		Min = 1,
		Max = 25,
		Increase = 1,
		Default = colorSpeed,
		Callback = function(p37)
			colorSpeed = p37
		end
	})

	local t15 = {
		Color3.new(1, 1, 0),
		Color3.new(0, 0, 1),
		Color3.new(1, 0, 1),
		Color3.new(1, 1, 1),
		Color3.new(0, 1, 0),
		Color3.new(0.5, 0, 1),
		Color3.new(1, 0.647, 0),
		Color3.new(0, 1, 1)
	}
	local t16 = {
		Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(255, 0, 255),
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(255, 165, 0),
		Color3.fromRGB(128, 0, 128),
		Color3.fromRGB(255, 20, 147)
	}
	local t17 = {
		"Bright red",
		"Lime green",
		"Bright blue",
		"Bright yellow",
		"Bright cyan",
		"Hot pink",
		"Royal purple"
	}
	local u137 = false
	local u138 = false
	local u139 = false
	local u140 = false
	local u141 = false

	t3.E:AddToggle({
		Name = t1:traduzir("Cabelo lgbt"),
		Description = t1:traduzir("Mudar a cor de cabelo automático"),
		Default = false,
		Callback = function(p38)
			u137 = p38
		end
	})
	t3.E:AddToggle({
		Name = t1:traduzir("Nome lgbt"),
		Description = t1:traduzir("Mudar a cor do nome automático"),
		Default = false,
		Callback = function(p39)
			u138 = p39
		end
	})
	t3.E:AddToggle({
		Name = t1:traduzir("Bio lgbt"),
		Description = t1:traduzir("Mudar a cor da bio automático"),
		Default = false,
		Callback = function(p40)
			u139 = p40
		end
	})
	t3.E:AddToggle({
		Name = t1:traduzir("Rosas Lgbt"),
		Description = t1:traduzir("Muda a cor da rosa automaticamente"),
		Default = false,
		Callback = function(p41)
			u140 = p41
		end
	})
	t3.E:AddToggle({
		Name = t1:traduzir("Personagem Lgbt"),
		Description = t1:traduzir("Deixa seu personagem RGB automaticamente"),
		Default = false,
		Callback = function(p42)
			u141 = p42
		end
	})
	task.spawn(function()
		local n10 = 1
		local n11 = 1
		local n12 = 1
		local n13 = 1

		while true do
			if u137 then
				local t18 = {
					"ChangeHairColor2",
					t15[n10]
				}

				ReplicatedStorage.RE:FindFirstChild("1Max1y"):FireServer(unpack(t18))
				n10 = n10 % #t15 + 1
			end

			if u138 then
				local t19 = {
					"PickingRPNameColor",
					t16[n11]
				}

				ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(t19))
				n11 = n11 % #t16 + 1
			end

			if u139 then
				local t20 = {
					"PickingRPBioColor",
					t16[n12]
				}

				ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(t20))
				n12 = n12 % #t16 + 1
			end

			if u141 then
				local t21 = { t17[n13] }

				ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(t21))
				n13 = n13 % #t17 + 1
			end

			if u140 then
				local Character_ = LocalPlayer.Character
				local Roses = Character_

				if Roses then
					Roses = Character_:FindFirstChild("Roses")

					if Roses and Roses:FindFirstChild("ToolSound") then
						for _, v in ipairs({
							"rbxassetid://5210399458",
							"rbxassetid://5210414520",
							"rbxassetid://5216708760",
							"rbxassetid://5210414112"
						}) do
							Roses.ToolSound:FireServer(unpack({
								"Roses",
								v
							}))
							task.wait(0.1)
						end
					end
				elseif Roses and Roses:FindFirstChild("ToolSound") then
					for _, v in ipairs({
						"rbxassetid://5210399458",
						"rbxassetid://5210414520",
						"rbxassetid://5216708760",
						"rbxassetid://5210414112"
					}) do
						Roses.ToolSound:FireServer(unpack({
							"Roses",
							v
						}))
						task.wait(0.1)
					end
				end
			end

			task.wait(1 / colorSpeed)
		end
	end)
	t3.E:AddSection({ t1:traduzir("Shader") })
	t3.E:AddButton({
		"Shaders effect Map",
		function()
			local Workspace2 = game:GetService("Workspace")
			local Lighting = game:GetService("Lighting")
			local RunService2 = game:GetService("RunService")
			local Debris = game:GetService("Debris")
			local TweenService2 = game:GetService("TweenService")
			local SoundService = game:GetService("SoundService")
			local LocalPlayer2 = game:GetService("Players").LocalPlayer
			local Model = Workspace2:FindFirstChild("Model")
			local Sound = Instance.new("Sound")

			Sound.SoundId = "rbxassetid://131644923"
			Sound.Volume = 1
			Sound.Parent = SoundService
			Sound:Play()

			if Model then
				local function v165(p43)
					for _, child in pairs(p43:GetChildren()) do
						if child:IsA("BasePart") then
							child.Material = Enum.Material.Basalt
						elseif child:IsA("Model") or child:IsA("Folder") then
							v165(child)
						end
					end
				end

				if Model:FindFirstChild("001_SnowStreet") then
					v165(Model["001_SnowStreet"])
				end

				if Model:FindFirstChild("Street") then
					for _, descendant in pairs(Model.Street:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.Material = Enum.Material.Basalt
						end
					end
				end

				for _, child in pairs(Model:GetChildren()) do
					if child:IsA("BasePart") and (child.Name == "Sidewalk" or child.Name == "Wedge") and child.Material == Enum.Material.SmoothPlastic then
						child.Material = Enum.Material.Cobblestone
					end
				end

				Model.ChildAdded:Connect(function(child)
					if child:IsA("BasePart") and (child.Name == "Sidewalk" or child.Name == "Wedge") and child.Material == Enum.Material.SmoothPlastic then
						child.Material = Enum.Material.Cobblestone
					end
				end)
			end

			local Part = Instance.new("Part")

			Part.Size = Vector3.new(1, 1, 1)
			Part.Transparency = 1
			Part.Anchored = true
			Part.CanCollide = false
			Part.Parent = Workspace2

			local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
			local Sound2 = Instance.new("Sound")

			Sound2.Name = "BirdsSound"
			Sound2.SoundId = "rbxassetid://1237969272"
			Sound2.Looped = true
			Sound2.Volume = 0.05
			Sound2.Parent = Part

			local Sound3 = Instance.new("Sound")

			Sound3.SoundId = "rbxassetid://6654360741"
			Sound3.Volume = 0.05
			Sound3.Looped = false
			Sound3.Parent = Workspace2
			RunService2.Heartbeat:Connect(function()
				if HumanoidRootPart then
					if HumanoidRootPart.Parent then
						Part.Position = HumanoidRootPart.Position + Vector3.new(0, 10, 0)
					end
				end
			end)

			local function v176()
				local ClockTime = Lighting.ClockTime

				return ClockTime >= 18 or ClockTime <= 6
			end

			task.spawn(function()
				while true do
					if v176() then
						if Sound2.IsPlaying then
							Sound2:Stop()

							if Sound3.IsPlaying then
								Sound3:Stop()
							end

							Sound3:Play()
							wait(20)

							continue
						end

						if Sound3.IsPlaying then
							Sound3:Stop()
							Sound3:Play()
							wait(20)

							continue
						end

						Sound3:Play()
					else
						if Sound3.IsPlaying then
							Sound3:Stop()

							if not Sound2.IsPlaying then
								Sound2:Play()
							end

							wait(20)

							continue
						end

						if not Sound2.IsPlaying then
							Sound2:Play()
						end
					end

					wait(20)
				end
			end)

			local Part2 = Instance.new("Part")

			Part2.Anchored = true
			Part2.CanCollide = false
			Part2.Transparency = 1
			Part2.Size = Vector3.new(1, 1, 1)
			Part2.Position = Vector3.new(-27, 19, 15)
			Part2.Parent = Workspace2

			local Attachment = Instance.new("Attachment")

			Attachment.Position = Vector3.new(-27, 19, 15)
			Attachment.Parent = Part2

			local Sound4 = Instance.new("Sound")

			Sound4.Name = "FountainSound"
			Sound4.SoundId = "rbxassetid://4766793559"
			Sound4.Looped = true
			Sound4.Volume = 0.03
			Sound4.EmitterSize = 10
			Sound4.RollOffMode = Enum.RollOffMode.Linear
			Sound4.MaxDistance = 100
			Sound4.Parent = Attachment
			Sound4:Play()

			local Sound5 = Instance.new("Sound")

			Sound5.Name = "MyCustomSound"
			Sound5.SoundId = "rbxassetid://9048659736"
			Sound5.Volume = 0.01
			Sound5.Looped = true
			Sound5.PlayOnRemove = false
			Sound5.Parent = Workspace2
			Sound5:Play()

			local u182 = false
			local t22 = {}
			local Folder = Instance.new("Folder", Workspace2)

			Folder.Name = "ShootingStars"

			local Sound6 = Instance.new("Sound", Workspace2)

			Sound6.SoundId = "rbxassetid://1843520836"
			Sound6.Volume = 0.3
			Sound6.Looped = true
			Sound6.Name = "SpaceAmbience"

			local function v186()
				local Part3 = Instance.new("Part")
				local v188 = math.random(1, 3) * 0.5

				Part3.Size = Vector3.new(v188, v188, v188)
				Part3.Position = Vector3.new(math.random(-1000, 1000), math.random(300, 700), math.random(-1000, 1000))
				Part3.Anchored = true
				Part3.CanCollide = false
				Part3.Material = Enum.Material.Neon

				local t23 = {
					Color3.fromRGB(255, 255, 255),
					Color3.fromRGB(255, 255, 180),
					Color3.fromRGB(180, 200, 255)
				}

				Part3.Color = t23[math.random(1, #t23)]
				Part3.Name = "Star"
				Part3.Parent = Workspace2

				local PointLight = Instance.new("PointLight", Part3)

				PointLight.Brightness = 2 + math.random() * 1.5
				PointLight.Range = 12
				spawn(function()
					while Part3.Parent do
						if not u182 then
							break
						end

						Part3.Transparency = 0.2 + math.sin(tick() * math.random(2, 5)) * 0.2
						RunService2.Heartbeat:Wait()
					end

					if Part3.Parent then
						Part3:Destroy()
					end
				end)
				table.insert(t22, Part3)
			end
			local function v191()
				if not u182 then
					return
				end

				local vector3 = Vector3.new(math.random(-1000, 1000), math.random(350, 600), math.random(-1000, 1000))
				local Unit = Vector3.new(math.random(-1, 1), math.random(-0.1, 0.1), math.random(-1, 1)).Unit
				local v194 = math.random(350, 550)
				local v195 = math.random() <= 0.3
				local color3 = v195 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 220)
				local colorSequence = v195 and ColorSequence.new(Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 230, 50)) or ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 180))
				local Part3 = Instance.new("Part")

				Part3.Size = Vector3.new(0.5, 0.5, 3)
				Part3.Position = vector3
				Part3.Anchored = true
				Part3.CanCollide = false
				Part3.Material = Enum.Material.Neon
				Part3.Color = color3
				Part3.Name = "ShootingStar"
				Part3.Parent = Folder

				local Attachment2 = Instance.new("Attachment", Part3)
				local Attachment3 = Instance.new("Attachment", Part3)

				Attachment3.Position = Vector3.new(0, 0, -3)

				local Trail = Instance.new("Trail", Part3)

				Trail.Attachment0 = Attachment2
				Trail.Attachment1 = Attachment3
				Trail.Lifetime = 0.35
				Trail.Color = colorSequence
				Trail.LightEmission = 1
				Trail.WidthScale = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})

				local PointLight = Instance.new("PointLight", Part3)

				PointLight.Brightness = v195 and 12 or 7
				PointLight.Range = 35
				PointLight.Color = color3

				if v195 then
					local Fire = Instance.new("Fire", Part3)

					Fire.Heat = 15
					Fire.Size = 3.5
					Fire.Color = Color3.fromRGB(255, 110, 0)
					Fire.SecondaryColor = Color3.fromRGB(255, 210, 0)
				end

				local v204 = math.random(1, 1.5)
				local n14 = 0
				local connection

				connection = RunService2.Heartbeat:Connect(function(dt)
					if not u182 then
						connection:Disconnect()

						if Part3.Parent then
							Part3:Destroy()
						end

						return
					end

					n14 += dt

					if not (v204 <= n14) then
						Part3.Position += (Unit + Vector3.new(0, math.sin(n14 * 20) * 0.5, 0)).Unit * v194 * dt

						return
					end

					connection:Disconnect()

					if Part3.Parent then
						Part3:Destroy()
					end
				end)
				Debris:AddItem(Part3, 4)
			end
			local function v207()
				local ClockTime = Lighting.ClockTime
				local v209 = ClockTime >= 18 or ClockTime < 6

				if not v209 or u182 then
					if not v209 and u182 then
						u182 = false

						for _, v in ipairs(t22) do
							if v and v.Parent then
								v:Destroy()
							end
						end

						t22 = {}

						for _, child in ipairs(Folder:GetChildren()) do
							child:Destroy()
						end

						Sound6:Stop()
						Lighting.FogColor = Color3.fromRGB(192, 192, 192)
						Lighting.FogEnd = 100000
						Lighting.Brightness = 2
					end
				else
					u182 = true
					Lighting.FogColor = Color3.fromRGB(10, 10, 30)
					Lighting.FogEnd = 5000
					Lighting.Brightness = 2

					for _, v in ipairs(t22) do
						if v and v.Parent then
							v:Destroy()
						end
					end

					t22 = {}

					for _, child in ipairs(Folder:GetChildren()) do
						child:Destroy()
					end

					for i = 1, 300 do
						v186()
					end

					Sound6:Play()
				end
			end

			task.spawn(function()
				while true do
					if u182 then
						for i = 1, 12 do
							v191()
							task.wait(0.1)
						end
					else
						task.wait(1)
					end
				end
			end)
			task.spawn(function()
				while true do
					v207()
					task.wait(1)
				end
			end)

			local Folder2 = Instance.new("Folder", Workspace2)

			Folder2.Name = "FakeRain"

			local u221 = false
			local Sound7 = Instance.new("Sound", SoundService)

			Sound7.SoundId = "rbxassetid://9111139882"
			Sound7.Volume = 0.2
			Sound7.Looped = true
			Sound7:Play()

			local Sound8 = Instance.new("Sound", SoundService)

			Sound8.SoundId = "rbxassetid://9118823106"
			Sound8.Volume = 0.3
			Sound8.Looped = true
			Sound8:Play()

			local Sound9 = Instance.new("Sound", SoundService)

			Sound9.SoundId = "rbxassetid://9120018695"
			Sound9.Volume = 0.4

			local function v225()
				Sound7.Volume = u221 and 0 or 0.2
			end
			local function v226()
				u221 = true
				v225()

				for i = 1, 120 do
					local Part3 = Instance.new("Part")

					Part3.Size = Vector3.new(0.1, 2, 0.1)
					Part3.Anchored = true
					Part3.CanCollide = false
					Part3.Material = Enum.Material.Glass
					Part3.Transparency = 0.5
					Part3.Color = Color3.fromRGB(160, 160, 255)
					Part3.Position = Vector3.new(math.random(-150, 150), 100, math.random(-150, 150))
					Part3.Parent = Folder2
					TweenService2:Create(Part3, TweenInfo.new(1), {
						Position = Part3.Position - Vector3.new(0, 60, 0)
					}):Play()
					Debris:AddItem(Part3, 1.5)
				end

				wait(1.5)
				u221 = false
				v225()
			end
			local function v229()
				local Part3 = Instance.new("Part")

				Part3.Size = Vector3.new(1, 1000, 1)
				Part3.Anchored = true
				Part3.CanCollide = false
				Part3.Transparency = 0.4
				Part3.Material = Enum.Material.Neon
				Part3.Color = Color3.new(1, 1, 1)
				Part3.Position = Vector3.new(math.random(-100, 100), 500, math.random(-100, 100))
				Part3.Parent = Workspace2
				Lighting.Brightness += 1.5
				Sound9:Play()
				wait(0.1)
				Lighting.Brightness -= 1.5
				Part3:Destroy()
			end

			for _, descendant in pairs(Workspace2:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Material == Enum.Material.SmoothPlastic then
					descendant.Reflectance = 0.25
				end
			end

			task.spawn(function()
				while true do
					v226()

					if math.random() < 0.2 then
						v229()
					end

					wait(1)
				end
			end)
			Lighting.Brightness = 2
			Lighting.GlobalShadows = true
			Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
			Lighting.FogColor = Color3.fromRGB(120, 130, 140)
			Lighting.FogStart = 80
			Lighting.FogEnd = 600
			Lighting.EnvironmentSpecularScale = 1
			Lighting.EnvironmentDiffuseScale = 0.5

			local Sky = Instance.new("Sky")

			Sky.SkyboxBk = "rbxassetid://159454299"
			Sky.SkyboxDn = "rbxassetid://159454296"
			Sky.SkyboxFt = "rbxassetid://159454293"
			Sky.SkyboxLf = "rbxassetid://159454286"
			Sky.SkyboxRt = "rbxassetid://159454300"
			Sky.SkyboxUp = "rbxassetid://159454304"
			Sky.Parent = Lighting

			local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", Lighting)

			ColorCorrectionEffect.Brightness = 0.03
			ColorCorrectionEffect.Contrast = 0.15
			ColorCorrectionEffect.Saturation = 0.05
			ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 240, 220)

			local BloomEffect = Instance.new("BloomEffect", Lighting)

			BloomEffect.Intensity = 0.8
			BloomEffect.Size = 56
			BloomEffect.Threshold = 0.9

			local SunRaysEffect = Instance.new("SunRaysEffect", Lighting)

			SunRaysEffect.Intensity = 0.05
			SunRaysEffect.Spread = 0.8
			Instance.new("BlurEffect", Lighting).Size = 0
		end
	})
end)
task.spawn(function()
	task.wait(4)

	local u237

	local function v238()
		local t24 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= plr then
				table.insert(t24, player.Name)
			end
		end

		return t24
	end

	local u237s
	t3.JJ:AddSection({ "Spectate Player" })
	t3.JJ:AddDropdown({
		Name = "Selecione Players",
		Options = v238(),
		Players = "spec",
		Callback = function(p44)
			u237s = p44
		end
	})

	local Players2 = game:GetService("Players")
	local RunService2 = game:GetService("RunService")
	local LocalPlayer2 = Players2.LocalPlayer
	local u246 = false
	local connection
	local connection2
	local u249

	local function v250()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		u249 = nil

		local Character_ = LocalPlayer2.Character
		local Humanoid_ = Character_ and Character_:FindFirstChildOfClass("Humanoid")

		if Humanoid_ then
			workspace.CurrentCamera.CameraSubject = Humanoid_
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		end
	end
	local function v253(p45)
		if not u246 or not p45 then
			return
		end

		v250()
		u246 = true
		u249 = p45
		connection = RunService2.RenderStepped:Connect(function()
			if not u246 then
				return
			end

			if u249 then
				if u249.Character then
					local Humanoid_ = u249.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid_ then
						workspace.CurrentCamera.CameraSubject = Humanoid_
						workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
					end

					return
				end
			end
		end)
		connection2 = p45.CharacterAdded:Connect(function()
			task.wait(0.1)

			if u246 and u249 == p45 then
				v253(p45)
			end
		end)
	end

	Players2.PlayerRemoving:Connect(function(player)
		if u246 and u249 == player then
			v250()
			u246 = false
		end
	end)
	t3.JJ:AddToggle({
		Name = "Spectar Jogador",
		Player = "spec",
		Default = false,
		Callback = function(p46)
			u246 = p46

			if not p46 then
				v250()

				return
			end

			local v255 = u237s and Players2:FindFirstChild(u237s)

			if v255 then
				v253(v255)
			else
				v250()
			end
		end
	})
	t3.P:AddSection({ "props troll ALL" })

	local u256 = false
	local connection3
	local t25 = {}

	local function v259(p47)
		Character = p47
		HRP = p47:WaitForChild("HumanoidRootPart", 5)
		Humanoid = p47:WaitForChild("Humanoid", 5)
	end

	if LocalPlayer2.Character then
		v259(LocalPlayer2.Character)
	end

	LocalPlayer2.CharacterAdded:Connect(function(character_)
		StopPropRaid()
		task.wait(0.5)
		v259(character_)

		if u256 then
			task.wait(0.5)
			StartPropRaid()
		end
	end)
	pcall(function()
		ReplicatedStorage.RE["1Too1l"]:InvokeServer("PickingTools", "PropMaker")
	end)
	task.wait(0.3)
	pcall(function()
		ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("RequestingPropName", "FurnitureBleachers", "Furniture")
	end)

	local t26 = {}
	local n15 = 0

	local function v262()
		if tick() - n15 < 0.4 then
			return t26
		end

		t26 = {}

		local WorkspaceCom = workspace:FindFirstChild("WorkspaceCom")

		if not WorkspaceCom then
			return t26
		end

		for _, child in ipairs(WorkspaceCom:GetChildren()) do
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:FindFirstChild("SetCurrentCFrame") then
					if child2.Name:lower():find(LocalPlayer2.Name:lower()) then
						table.insert(t26, child2)
					end
				end
			end
		end

		n15 = tick()

		return t26
	end
	local function v268()
		local t27 = {}

		if not HRP then
			return t27
		end

		for _, player in ipairs(Players2:GetPlayers()) do
			if player ~= LocalPlayer2 and player.Character then
				if player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - HRP.Position).Magnitude <= 222 then
					table.insert(t27, player)
				end
			end
		end

		return t27
	end
	local function v272(p48, p49)
		if #p49 == 0 then
			return
		end

		for i, v in ipairs(p48) do
			t25[v] = p49[(i - 1) % #p49 + 1]
		end
	end
	local function v275(p50, p51)
		if #p50 == 0 then
			return nil
		end

		for i, v in ipairs(p50) do
			if v == p51 then
				return p50[i % #p50 + 1]
			end
		end

		return p50[1]
	end

	local n16 = 0
	local n17 = 0
	local n18 = 1

	StartPropRaid = function()
		if connection3 then
			connection3:Disconnect()
		end

		connection3 = RunService2.Heartbeat:Connect(function()
			if Character and HRP then
				if Humanoid and not (Humanoid.Health <= 0) then
					local v281 = v262()
					local v282 = v268()

					if #v281 == 0 or #v282 == 0 then
						return
					end

					v272(v281, v282)
					n16 += math.rad(20)

					if n17 > 4 then
						n18 = -1
					end

					if n17 < -4 then
						n18 = 1
					end

					n17 += 0.3 * n18

					for _, v in ipairs(v281) do
						local v285 = t25[v]

						if v285 and v285.Character then
							local Humanoid_ = v285.Character:FindFirstChild("Humanoid")
							local HumanoidRootPart = v285.Character:FindFirstChild("HumanoidRootPart")

							if Humanoid_ and HumanoidRootPart then
								if Humanoid_.Sit then
									t25[v] = v275(v282, v285)
								else
									local v288 = math.random(2, 5)
									local v289 = n17
									local vector3 = Vector3.new(math.cos(n16) * v288, v289, math.sin(n16) * v288)

									pcall(function()
										v.SetCurrentCFrame:InvokeServer(HumanoidRootPart.CFrame * CFrame.new(vector3))
									end)
								end
							end
						else
							t25[v] = v275(v282, v285)
						end
					end

					return
				end
			end
		end)
	end
	StopPropRaid = function()
		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		t25 = {}
	end
	t3.P:AddToggle({
		Name = "prop sit all",
		Default = false,
		Callback = function(p52)
			u256 = p52

			if p52 then
				StartPropRaid()
			else
				StopPropRaid()
			end
		end
	})

	local u291 = false
	local connection4
	local t28 = {}
	local t29 = {}

	local function v295()
		local t30 = {}

		if not HRP then
			return t30
		end

		for _, player in ipairs(Players2:GetPlayers()) do
			if player ~= LocalPlayer2 and player.Character then
				if player.Character:FindFirstChild("HumanoidRootPart") then
					if player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and (player.Character.HumanoidRootPart.Position - HRP.Position).Magnitude <= 150 then
						table.insert(t30, player)
					end
				end
			end
		end

		return t30
	end
	local function v299(p53)
		local n19 = 0

		for _, v in pairs(t28) do
			if v == p53 then
				n19 += 1
			end
		end

		return n19
	end
	local function v303(p54)
		local v304
		local huge = math.huge

		for _, v in ipairs(p54) do
			local v308 = v299(v)

			if v308 < huge and v308 < 3 then
				huge = v308
				v304 = v
			end
		end

		return v304
	end
	local function v309()
		if connection4 then
			connection4:Disconnect()
		end

		local n20 = 0

		connection4 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			n20 += dt

			local v311 = v262()

			if #v311 == 0 then
				return
			end

			local v312 = v295()

			for i, v in ipairs(v311) do
				local v315 = t28[v]

				if v315 then
					local Character_ = v315.Character

					if not Character_ or not Character_:FindFirstChild("HumanoidRootPart") or not Character_:FindFirstChild("Humanoid") or Character_.Humanoid.Health <= 0 or (Character_.HumanoidRootPart.Position - HRP.Position).Magnitude > 150 then
						t28[v] = nil
						v315 = nil
					end
				end

				if not v315 then
					local v317 = v303(v312)

					t28[v] = v317
					v315 = v317
				end

				if v315 then
					local Humanoid_ = v315.Character:FindFirstChild("Humanoid")
					local HumanoidRootPart = v315.Character:FindFirstChild("HumanoidRootPart")

					if Humanoid_ and HumanoidRootPart then
						if not Humanoid_.Sit then
							if t29[v] and not Humanoid_.Sit then
								t29[v] = nil
							end

							local vector3 = Vector3.new(math.cos(n20 * 3 + i) * 2, -1.5 + math.sin(n20 * 4 + i), math.sin(n20 * 3 + i) * 2)
							local v321 = HumanoidRootPart.CFrame * CFrame.new(vector3) * CFrame.Angles(math.rad(math.sin(n20 * 5 + i) * 120), math.rad(n20 * 180), 0)

							pcall(function()
								v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v321, 0.35))
							end)
						elseif not t29[v] then
							t29[v] = true

							local vector3 = Vector3.new(HumanoidRootPart.Position.X, -460, HumanoidRootPart.Position.Z)

							pcall(function()
								v.SetCurrentCFrame:InvokeServer(CFrame.new(vector3))
							end)
						end
					end
				else
					local cFrame = CFrame.new(HRP.Position + Vector3.new(math.cos(i + n20) * 4, 2 + math.sin(n20 * 2 + i), math.sin(i + n20) * 4))

					pcall(function()
						v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(cFrame, 0.3))
					end)
				end
			end
		end)
	end
	local function v324()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		t28 = {}
		t29 = {}
	end

	t3.P:AddToggle({
		Name = "prop kill all",
		Default = false,
		Callback = function(p55)
			u291 = p55

			if p55 then
				v309()
			else
				v324()
			end
		end
	})
	t3.P:AddSection({ "Seção de jogador local" })

	local u325 = false
	local connection5

	StartCobra = function()
		if connection5 then
			connection5:Disconnect()
		end

		local n21 = 0

		connection5 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			local v328 = v262()

			if #v328 == 0 then
				return
			end

			n21 += dt * 10

			for i, v in ipairs(v328) do
				local v331 = n21 - i * 1.1
				local v332 = -HRP.CFrame.LookVector
				local RightVector = HRP.CFrame.RightVector
				local vector3 = Vector3.new(0, 1, 0)
				local v335 = HRP.Position + v332 * (3.5 * i) + RightVector * (math.sin(v331) * 3.2) + vector3 * (math.cos(v331 * 0.8) * 1.2)
				local cFrame = CFrame.new(v335, v335 + v332)

				pcall(function()
					v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(cFrame, 0.35))
				end)
			end
		end)
	end
	StopCobra = function()
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
	end
	t3.P:AddToggle({
		Name = "Prop Cobra",
		Default = false,
		Callback = function(p56)
			local v337 = p56

			u325 = v337

			if v337 then
				StartCobra()
			else
				StopCobra()
			end
		end
	})

	local u338 = false
	local connection6

	local function v340()
		if connection6 then
			connection6:Disconnect()
		end

		local n22 = 0

		connection6 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			local v342 = v262()

			if #v342 == 0 then
				return
			end

			n22 += dt * 4

			for i, v in ipairs(v342) do
				local v345 = n22 + i * 0.7
				local v346 = 4 + math.sin(n22 + i) * 3
				local v347 = math.cos(n22 * 2 + i) * 4
				local cFrame = CFrame.new(HRP.Position + Vector3.new(math.cos(v345) * v346, v347, math.sin(v345) * v346), HRP.Position)

				pcall(function()
					v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(cFrame, 0.35))
				end)
			end
		end)
	end
	local function v349()
		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end
	end

	t3.P:AddToggle({
		Name = "Furacão de Props",
		Default = false,
		Callback = function(p57)
			u338 = p57

			if p57 then
				v340()
			else
				v349()
			end
		end
	})

	local u350 = false
	local connection7

	local function v352()
		if connection7 then
			connection7:Disconnect()
		end

		local n23 = 0

		connection7 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			local v354 = v262()

			if #v354 == 0 then
				return
			end

			n23 += dt

			for i, v in ipairs(v354) do
				local v357 = 30 + math.sin(n23 + i) * 3
				local v358 = i * 2.5
				local v359 = 12 + i * 2
				local v360 = CFrame.new(HRP.Position + Vector3.new(math.cos(v358) * v359, v357, math.sin(v358) * v359)) * CFrame.Angles(math.rad((n23 * 50 + i * 30) % 360), math.rad((n23 * 35 + i * 20) % 360), 0)

				pcall(function()
					v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v360, 0.3))
				end)
			end
		end)
	end
	local function v361()
		if connection7 then
			connection7:Disconnect()
			connection7 = nil
		end
	end

	t3.P:AddToggle({
		Name = "Props Strela",
		Default = false,
		Callback = function(p58)
			u350 = p58

			if p58 then
				v352()
			else
				v361()
			end
		end
	})

	local u362 = false
	local connection8

	local function v364()
		if connection8 then
			connection8:Disconnect()
		end

		local n24 = 0

		connection8 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			local v366 = v262()

			if #v366 == 0 then
				return
			end

			n24 += dt * 1.8

			local v367 = HRP.Position + HRP.CFrame.LookVector * 8 + Vector3.new(0, 2, 0)
			local v368 = #v366

			for i, v in ipairs(v366) do
				local v371 = (i - 1) / v368 * math.pi * 2
				local v372 = n24
				local v373 = math.cos(v371 + v372) * 6
				local v374 = math.sin(v371 + v372) * 6
				local v375 = CFrame.new(v367 + HRP.CFrame.RightVector * v373 + Vector3.new(0, v374, 0)) * CFrame.Angles(math.rad(v374 * 5), math.rad((v371 + v372) * 180 / math.pi), 0)

				pcall(function()
					v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v375, 0.25))
				end)
			end
		end)
	end
	local function v376()
		if connection8 then
			connection8:Disconnect()
			connection8 = nil
		end
	end

	t3.P:AddToggle({
		Name = "Portal prop",
		Default = false,
		Callback = function(p59)
			u362 = p59

			if p59 then
				v364()
			else
				v376()
			end
		end
	})

	local connection9
	local t31 = {}

	local function v379(p60)
		t31[p60] = {
			nextChange = tick() + math.random() * 0.3,
			targetOffset = Vector3.new(math.random(-20, 20), math.random(-15, 20), math.random(-20, 20)),
			rotSpeed = Vector3.new(math.random(200, 900), math.random(200, 900), math.random(200, 900))
		}
	end
	local function v380()
		if connection9 then
			connection9:Disconnect()
		end

		connection9 = RunService2.Heartbeat:Connect(function()
			if character then
				if character:FindFirstChild("HumanoidRootPart") then
					local HumanoidRootPart = character.HumanoidRootPart
					local v382 = v262()

					if #v382 == 0 then
						return
					end

					for _, v in ipairs(v382) do
						if not t31[v] then
							v379(v)
						end

						local v385 = t31[v]

						if v385.nextChange <= tick() then
							v385.targetOffset = Vector3.new(math.random(-20, 20), math.random(-15, 20), math.random(-20, 20))
							v385.rotSpeed = Vector3.new(math.random(300, 1200), math.random(300, 1200), math.random(300, 1200))
							v385.nextChange = tick() + math.random(15, 45) / 100
						end

						local v386 = HumanoidRootPart.Position + v385.targetOffset
						local v387 = math.rad(tick() * v385.rotSpeed.X % 360)
						local v388 = math.rad(tick() * v385.rotSpeed.Y % 360)
						local v389 = math.rad(tick() * v385.rotSpeed.Z % 360)

						pcall(function()
							v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(CFrame.new(v386) * CFrame.Angles(v387, v388, v389), 0.35))
						end)
					end

					return
				end
			end
		end)
	end
	local function v390()
		if connection9 then
			connection9:Disconnect()
			connection9 = nil
		end

		t31 = {}
	end

	t3.P:AddToggle({
		Name = "Props Doidos",
		Default = false,
		Callback = function(p61)
			if p61 then
				v380()
			else
				v390()
			end
		end
	})
	t3.P:AddSection({ "Selecione uma pessoa para usableAngle" })
	t3.P:AddDropdown({
		Name = "Selecione Players",
		Options = v238(),
		Players = "props",
		Callback = function(p44)
			u237 = p44
		end
	})

	local u391 = false
	local connection10
	local t32 = {}

	local function v394()
		if u237 then
			return Players2:FindFirstChild(u237)
		end

		return nil
	end
	local function v395()
		if connection10 then
			connection10:Disconnect()
		end

		local n25 = 0

		connection10 = RunService2.Heartbeat:Connect(function(dt)
			if not Character or not HRP or not Humanoid or Humanoid.Health <= 0 then
				return
			end

			local v397 = v394()

			if not v397 or not v397.Character then
				return
			end

			local HumanoidRootPart = v397.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid_ = v397.Character:FindFirstChild("Humanoid")

			if not HumanoidRootPart or not Humanoid_ then
				return
			end

			local v400 = v262()

			if #v400 == 0 then
				return
			end

			n25 += dt * 3

			for i, v in ipairs(v400) do
				if not Humanoid_.Sit then
					if t32[v] then
						t32[v] = nil

						local v403 = HRP.Position + Vector3.new(math.cos(i) * 4, 3, math.sin(i) * 4)

						pcall(function()
							v.SetCurrentCFrame:InvokeServer(CFrame.new(v403))
						end)
					else
						local vector3 = Vector3.new(math.cos(n25 + i) * 3, math.sin(n25 * 2 + i) * 2, math.sin(n25 + i * 2) * 3)
						local v405 = HumanoidRootPart.CFrame * CFrame.new(vector3) * CFrame.Angles(math.rad(math.sin(n25 * 4 + i) * 180), math.rad(n25 * 200), math.rad(math.cos(n25 * 3 + i) * 180))

						pcall(function()
							v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v405, 0.35))
						end)
					end
				elseif not t32[v] then
					t32[v] = true

					local vector3 = Vector3.new(HumanoidRootPart.Position.X, 1000000, HumanoidRootPart.Position.Z)

					pcall(function()
						v.SetCurrentCFrame:InvokeServer(CFrame.new(vector3))
					end)
				end
			end
		end)
	end
	local function v407()
		if connection10 then
			connection10:Disconnect()
			connection10 = nil
		end

		t32 = {}
	end

	t3.P:AddToggle({
		Player = "props",
		Name = "prop fling",
		Default = false,
		Callback = function(p62)
			u391 = p62

			if p62 then
				v395()
			else
				v407()
			end
		end
	})

	local u408 = false
	local connection11
	local t33 = {}

	local function v411()
		if u237 then
			return Players2:FindFirstChild(u237)
		end

		return nil
	end
	local function v412()
		if connection11 then
			connection11:Disconnect()
		end

		local n26 = 0

		connection11 = RunService2.Heartbeat:Connect(function(dt)
			if Character then
				if HRP and Humanoid and not (Humanoid.Health <= 0) then
					local v414 = v411()

					if not v414 or not v414.Character then
						return
					end

					local HumanoidRootPart = v414.Character:FindFirstChild("HumanoidRootPart")
					local Humanoid_ = v414.Character:FindFirstChild("Humanoid")

					if not HumanoidRootPart or not Humanoid_ then
						return
					end

					local v417 = v262()

					if #v417 == 0 then
						return
					end

					n26 += dt * 3

					for i, v in ipairs(v417) do
						if not Humanoid_.Sit then
							if t33[v] then
								t33[v] = nil

								local v420 = HRP.Position + Vector3.new(math.cos(i) * 4, 3, math.sin(i) * 4)

								pcall(function()
									v.SetCurrentCFrame:InvokeServer(CFrame.new(v420))
								end)
							else
								local vector3 = Vector3.new(math.cos(n26 + i) * 3, math.sin(n26 * 2 + i) * 2, math.sin(n26 + i * 2) * 3)
								local v422 = HumanoidRootPart.CFrame * CFrame.new(vector3) * CFrame.Angles(math.rad(math.sin(n26 * 4 + i) * 180), math.rad(n26 * 200), math.rad(math.cos(n26 * 3 + i) * 180))

								pcall(function()
									v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v422, 0.35))
								end)
							end
						elseif not t33[v] then
							t33[v] = true

							local vector3 = Vector3.new(HumanoidRootPart.Position.X, -460, HumanoidRootPart.Position.Z)

							pcall(function()
								v.SetCurrentCFrame:InvokeServer(CFrame.new(vector3))
							end)
						end
					end

					return
				end
			end
		end)
	end
	local function v424()
		if connection11 then
			connection11:Disconnect()
			connection11 = nil
		end

		t33 = {}
	end
	local function v425(p63)
		u408 = p63

		if p63 then
			v412()
		else
			v424()
		end
	end

	t3.P:AddToggle({
		Player = "props",
		Name = "prop kill player",
		Default = false,
		Callback = v425
	})

	local u426 = false
	local connection12

	local function v428()
		if u237 then
			return Players2:FindFirstChild(u237)
		end

		return nil
	end
	local function v429()
		if connection12 then
			connection12:Disconnect()
		end

		local n27 = 0

		connection12 = RunService2.Heartbeat:Connect(function(dt)
			if Character and HRP and Humanoid then
				if not (Humanoid.Health <= 0) then
					local v431 = v428()

					if not v431 or not v431.Character then
						return
					end

					local HumanoidRootPart = v431.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local v433 = v262()

					if #v433 == 0 then
						return
					end

					n27 += dt * 1.8

					local v434 = #v433
					local v435 = 6.2831853071795862 - math.rad(70)

					for i, v in ipairs(v433) do
						local v438 = (i - 1) / v434 * v435 + n27
						local v439 = CFrame.new(HumanoidRootPart.Position + Vector3.new(math.cos(v438) * 8, -2.7, math.sin(v438) * 8)) * CFrame.Angles(0, math.rad(v438 * 180 / math.pi), 0)

						pcall(function()
							v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(v439, 0.28))
						end)
					end

					return
				end
			end
		end)
	end
	local function v440()
		if connection12 then
			connection12:Disconnect()
			connection12 = nil
		end
	end

	t3.P:AddToggle({
		Player = "props",
		Name = "prop círculo",
		Default = false,
		Callback = function(p64)
			u426 = p64

			if p64 then
				v429()
			else
				v440()
			end
		end
	})

	local connection13
	local u442 = false

	local function v443()
		if u237 then
			return Players2:FindFirstChild(u237)
		end

		return nil
	end
	local function v444()
		if connection13 then
			connection13:Disconnect()
			connection13 = nil
		end
	end
	local function v445()
		v444()

		local n28 = 0

		connection13 = RunService2.Heartbeat:Connect(function(dt)
			local v447 = v443()

			if not v447 or not v447.Character then
				return
			end

			local HumanoidRootPart = v447.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid_ = v447.Character:FindFirstChild("Humanoid")

			if not HumanoidRootPart or not Humanoid_ or Humanoid_.Health <= 0 then
				return
			end

			local v450 = v262()

			if #v450 == 0 then
				return
			end

			n28 += dt * 10

			for i, v in ipairs(v450) do
				local v453 = n28 - i * 1.1
				local v454 = -HumanoidRootPart.CFrame.LookVector
				local RightVector = HumanoidRootPart.CFrame.RightVector
				local vector3 = Vector3.new(0, 1, 0)
				local v457 = HumanoidRootPart.Position + v454 * (3.5 * i) + RightVector * (math.sin(v453) * 3.2) + vector3 * (math.cos(v453 * 0.8) * 1.2)
				local cFrame = CFrame.new(v457, v457 + v454)

				pcall(function()
					v.SetCurrentCFrame:InvokeServer(v:GetPivot():Lerp(cFrame, 0.35))
				end)
			end
		end)
	end
	local function v459()
		if connection13 then
			connection13:Disconnect()
			connection13 = nil
		end
	end

	t3.P:AddToggle({
		Player = "props",
		Name = "Prop Cobra em player",
		Default = false,
		Callback = function(p65)
			u442 = p65

			if p65 then
				v445()
			else
				v459()
			end
		end
	})
end)
task.spawn(function()
	task.wait(5)

	local u460 = false
	local connection
	local n29 = 5

	t3.SK:AddSection({ "Nuke" })
	t3.SK:AddSlider({
		Name = "Nuke Regulator",
		Min = 1,
		Max = 20,
		Increment = 1,
		Default = 10,
		Callback = function()
		end
	})

	local u463 = false
	local u464
	local u465
	local t34 = {}

	local function v467()
		if u465 then
			pcall(function()
				u465:Stop()
				u465:Destroy()
			end)
			u465 = nil
		end

		if u464 then
			pcall(function()
				u464:Stop()
				u464:Destroy()
			end)
			u464 = nil
		end

		local Character_ = game.Players.LocalPlayer.Character

		if Character_ then
			local Humanoid_ = Character_:FindFirstChild("Humanoid")

			if Humanoid_ then
				local Animator = Humanoid_:FindFirstChild("Animator")

				if Animator then
					for _, v in pairs(Animator:GetPlayingAnimationTracks()) do
						if v.Animation then
							local AnimationId = v.Animation.AnimationId

							if AnimationId == "rbxassetid://70883871260184" or AnimationId == "rbxassetid://3695333486" then
								pcall(function()
									v:Stop()
								end)
							end
						end
					end
				end
			end
		end
	end

	t3.SK:AddToggle({
		Name = "Nuke normal",
		Default = false,
		Callback = function(p66)
			u463 = p66

			if p66 then
				local Character_ = game.Players.LocalPlayer.Character

				if Character_ then
					local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")

					if Humanoid_ then
						local appliedDescription = Humanoid_:GetAppliedDescription()

						t34 = {
							Torso = appliedDescription.Torso,
							RightArm = appliedDescription.RightArm,
							LeftArm = appliedDescription.LeftArm,
							RightLeg = appliedDescription.RightLeg,
							LeftLeg = appliedDescription.LeftLeg,
							Head = appliedDescription.Head
						}
						task.wait(0.2)

						local t35 = {
							123402086843885,
							100839513065432,
							78300682916056,
							86276701020724,
							78409653958165,
							15093053680
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(t35)
						end)
						task.wait(0.3)

						local Animation = Instance.new("Animation")

						Animation.AnimationId = "rbxassetid://70883871260184"
						u464 = Humanoid_:LoadAnimation(Animation)
						u464.Priority = Enum.AnimationPriority.Action4
						u464:Play(0.1, 1, 0.01)
						task.wait(0.5)

						local Animation2 = Instance.new("Animation")

						Animation2.AnimationId = "rbxassetid://3695333486"
						u465 = Humanoid_:LoadAnimation(Animation2)
						u465.Priority = Enum.AnimationPriority.Movement
						u465:Play(0.1, 1, 0)
					end
				end
			else
				v467()
				task.wait(0.2)

				if next(t34) then
					local Character_ = game.Players.LocalPlayer.Character

					if Character_ and Character_:FindFirstChildOfClass("Humanoid") then
						local t36 = {
							t34.Torso,
							t34.RightArm,
							t34.LeftArm,
							t34.RightLeg,
							t34.LeftLeg,
							t34.Head
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack({ t36 }))
						end)
						t34 = {}
					end
				end
			end
		end
	})

	local u482 = false
	local u483
	local u484
	local t37 = {}

	local function v486()
		if u484 then
			pcall(function()
				u484:Stop()
				u484:Destroy()
			end)
			u484 = nil
		end

		if u483 then
			pcall(function()
				u483:Stop()
				u483:Destroy()
			end)
			u483 = nil
		end
	end

	t3.SK:AddToggle({
		Name = "Nuke Bith + Spin",
		Default = false,
		Callback = function(p67)
			u482 = p67

			if p67 then
				local Character_ = game.Players.LocalPlayer.Character

				if Character_ then
					local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")

					if Humanoid_ then
						local appliedDescription = Humanoid_:GetAppliedDescription()

						t37 = {
							Torso = appliedDescription.Torso,
							RightArm = appliedDescription.RightArm,
							LeftArm = appliedDescription.LeftArm,
							RightLeg = appliedDescription.RightLeg,
							LeftLeg = appliedDescription.LeftLeg,
							Head = appliedDescription.Head
						}
						task.wait(0.2)

						local t38 = {
							123402086843885,
							100839513065432,
							78300682916056,
							86276701020724,
							78409653958165,
							15093053680
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(t38)
						end)
						task.wait(0.3)

						local Animation = Instance.new("Animation")

						Animation.AnimationId = "rbxassetid://70883871260184"
						u483 = Humanoid_:LoadAnimation(Animation)
						u483.Priority = Enum.AnimationPriority.Action4
						u483:Play(0.1, 1, 1)
						task.wait(0.1)
						u483:AdjustSpeed(5)
						task.wait(0.3)

						local Animation2 = Instance.new("Animation")

						Animation2.AnimationId = "rbxassetid://3695333486"
						u484 = Humanoid_:LoadAnimation(Animation2)
						u484.Priority = Enum.AnimationPriority.Movement
						u484:Play(0.1, 1, 0)
					end
				end
			else
				v486()
				task.wait(0.2)

				if next(t37) then
					local Character_ = game.Players.LocalPlayer.Character

					if Character_ and Character_:FindFirstChildOfClass("Humanoid") then
						local t39 = {
							t37.Torso,
							t37.RightArm,
							t37.LeftArm,
							t37.RightLeg,
							t37.LeftLeg,
							t37.Head
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack({ t39 }))
						end)
						t37 = {}
					end
				end
			end
		end
	})
	t3.SK:AddSection({ "Spin FE" })
	t3.SK:AddToggle({
		Name = "Spin",
		Default = false,
		Callback = function(p68)
			u460 = p68

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if p68 then
				connection = game:GetService("RunService").Heartbeat:Connect(function()
					local Character_ = game.Players.LocalPlayer.Character

					if not Character_ then
						return
					end

					local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(n29), 0)
				end)
			end
		end
	})
	t3.SK:AddSlider({
		Name = "Velocidade do Spin",
		Min = 1,
		Max = 50,
		Increment = 1,
		Default = 5,
		Callback = function(p69)
			n29 = p69
		end
	})
	t3.SK:AddSection({ "Skybox FE" })
	t3.SK:AddDropdown({
		Name = "Camisas Usável",
		Options = {
			"Hacker",
			"Anonymous",
			"Terror View",
			"Eye",
			"Terror",
			"Scary",
			"Cabeça",
			"Terror White",
			"Terror 2",
			"Rainbow Roblox",
			"Minecraft"
		},
		Callback = function(p70)
			local v497 = ({
				Hacker = 9567541545,
				Anonymous = 733789773,
				["Terror View"] = 6824727407,
				Eye = 10875062346,
				Terror = 6169983602,
				Scary = 239959578,
				["Cabeça"] = 111246708478422,
				["Terror White"] = 4796239811,
				["Terror 2"] = 9170900662,
				["Rainbow Roblox"] = 11511447511,
				Minecraft = 121185563530681
			})[p70]

			if v497 then
				pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearShirt"):InvokeServer(v497)
				end)
			end
		end
	})
	t3.SK:AddTextBox({
		Name = "Adicione um id",
		PlaceholderText = "ids de camisas de preferência",
		Callback = function(p71)
			local v498 = tonumber(p71)

			if v498 then
				pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearShirt"):InvokeServer(v498)
				end)
			end
		end
	})
	_G.SkyboxActive = _G.SkyboxActive or false
	_G.CurrentTrack = _G.CurrentTrack or nil
	_G.RigidTrack = _G.RigidTrack or nil
	_G.savedBodyParts = _G.savedBodyParts or {}

	local function v499()
		if _G.RigidTrack then
			pcall(function()
				_G.RigidTrack:Stop()
				_G.RigidTrack:Destroy()
			end)
			_G.RigidTrack = nil
		end

		if _G.CurrentTrack then
			pcall(function()
				_G.CurrentTrack:Stop()
				_G.CurrentTrack:Destroy()
			end)
			_G.CurrentTrack = nil
		end

		local Character_ = game.Players.LocalPlayer.Character

		if Character_ then
			local Humanoid_ = Character_:FindFirstChild("Humanoid")

			if Humanoid_ then
				local Animator = Humanoid_:FindFirstChild("Animator")

				if Animator then
					for _, v in pairs(Animator:GetPlayingAnimationTracks()) do
						if v.Animation then
							local AnimationId = v.Animation.AnimationId

							if AnimationId == "rbxassetid://70883871260184" or AnimationId == "rbxassetid://3695333486" then
								pcall(function()
									v:Stop()
								end)
							end
						end
					end
				end
			end
		end
	end

	t3.SK:AddToggle({
		Name = "Skybox",
		Default = _G.SkyboxActive or false,
		Callback = function(p72)
			_G.SkyboxActive = p72

			if p72 then
				local Character_ = game.Players.LocalPlayer.Character

				if Character_ then
					local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")

					if Humanoid_ then
						local appliedDescription = Humanoid_:GetAppliedDescription()

						_G.savedBodyParts = {
							Torso = appliedDescription.Torso,
							RightArm = appliedDescription.RightArm,
							LeftArm = appliedDescription.LeftArm,
							RightLeg = appliedDescription.RightLeg,
							LeftLeg = appliedDescription.LeftLeg,
							Head = appliedDescription.Head
						}
						task.wait(0.2)

						local t40 = {
							100839513065432,
							nil,
							nil,
							nil,
							nil,
							nil
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack({ t40 }))
						end)
						task.wait(0.3)

						local Animation = Instance.new("Animation")

						Animation.AnimationId = "rbxassetid://70883871260184"
						_G.CurrentTrack = Humanoid_:LoadAnimation(Animation)
						_G.CurrentTrack.Priority = Enum.AnimationPriority.Action4
						_G.CurrentTrack:Play(0.1, 1, 0.01)
						task.wait(0.5)

						local Animation2 = Instance.new("Animation")

						Animation2.AnimationId = "rbxassetid://3695333486"
						_G.RigidTrack = Humanoid_:LoadAnimation(Animation2)
						_G.RigidTrack.Priority = Enum.AnimationPriority.Movement
						_G.RigidTrack:Play(0.1, 1, 0)
					end
				end
			else
				v499()
				task.wait(0.2)

				if next(_G.savedBodyParts) then
					local Character_ = game.Players.LocalPlayer.Character

					if Character_ and Character_:FindFirstChildOfClass("Humanoid") then
						local t41 = {
							_G.savedBodyParts.Torso,
							_G.savedBodyParts.RightArm,
							_G.savedBodyParts.LeftArm,
							_G.savedBodyParts.RightLeg,
							_G.savedBodyParts.LeftLeg,
							_G.savedBodyParts.Head
						}

						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack({ t41 }))
						end)
						_G.savedBodyParts = {}
					end
				end
			end
		end
	})
end)
task.spawn(function()
	task.wait(7)
	getgenv().FlowHubKamui = (function()
		local Lighting = game:GetService("Lighting")
		local K = { inside = false, busy = false, built = false }
		local DIMENSION_ORIGIN = Vector3.new(0, 1000000, 0)
		local WARP_TIME, WINDUP_TIME = 0.1, 0.87
		local AREA_SIZE, WALL_HEIGHT = 300, 150
		local centralStructurePosition, kamuiMusic, flash, bg, soundKamui

		local function applyKamuiLighting()
			Lighting.Ambient = Color3.new(0, 0, 0)
			Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
			Lighting.FogColor = Color3.new(0, 0, 0)
			Lighting.FogStart = 20
			Lighting.FogEnd = 180
		end
		local function restoreNormalLighting()
			Lighting.Ambient = Color3.fromRGB(127, 127, 127)
			Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
			Lighting.FogEnd = 100000
		end

		local function build()
			if K.built then return end
			K.built = true
			local old = workspace:FindFirstChild("KamuiDimension")
			if old then old:Destroy() end
			local oldFx = LocalPlayer.PlayerGui:FindFirstChild("FlowHubKamuiFX")
			if oldFx then oldFx:Destroy() end

			local folder = Instance.new("Folder")
			folder.Name = "KamuiDimension"
			folder.Parent = workspace
			local function block(size, pos, color)
				local part = Instance.new("Part")
				part.Anchored = true
				part.Size, part.Position = size, pos
				part.Color = color or Color3.new(0, 0, 0)
				part.Material = Enum.Material.SmoothPlastic
				part.Parent = folder
				return part
			end
			block(Vector3.new(AREA_SIZE, 1, AREA_SIZE), DIMENSION_ORIGIN)
			for _, d in ipairs({
				{ Vector3.new(AREA_SIZE / 2, WALL_HEIGHT / 2, 0), Vector3.new(1, WALL_HEIGHT, AREA_SIZE) },
				{ Vector3.new(-AREA_SIZE / 2, WALL_HEIGHT / 2, 0), Vector3.new(1, WALL_HEIGHT, AREA_SIZE) },
				{ Vector3.new(0, WALL_HEIGHT / 2, AREA_SIZE / 2), Vector3.new(AREA_SIZE, WALL_HEIGHT, 1) },
				{ Vector3.new(0, WALL_HEIGHT / 2, -AREA_SIZE / 2), Vector3.new(AREA_SIZE, WALL_HEIGHT, 1) },
			}) do block(d[2], DIMENSION_ORIGIN + d[1]) end
			block(Vector3.new(AREA_SIZE, 1, AREA_SIZE), DIMENSION_ORIGIN + Vector3.new(0, WALL_HEIGHT, 0))

			local seed = 12345
			local function rnd(lo, hi)
				seed = (seed * 9301 + 49297) % 233280
				return lo + (seed / 233280) * (hi - lo)
			end
			for i = 1, 130 do
				local sx, sy, sz = rnd(10, 20), rnd(18, 30), rnd(10, 20)
				if i == 1 then sx, sy, sz = 30, 25, 30 end
				local ox, oz = 0, 0
				if i ~= 1 then
					ox = rnd(-AREA_SIZE / 2 + 8, AREA_SIZE / 2 - 8)
					oz = rnd(-AREA_SIZE / 2 + 8, AREA_SIZE / 2 - 8)
				end
				local b = block(Vector3.new(sx, sy, sz), DIMENSION_ORIGIN + Vector3.new(ox, sy / 2, oz), Color3.new(1, 1, 1))
				local glow = Instance.new("PointLight")
				glow.Brightness, glow.Range, glow.Color = 2, 18, Color3.new(1, 1, 1)
				glow.Parent = b
				if i == 1 then centralStructurePosition = b.Position + Vector3.new(0, sy / 2 + 3, 0) end
			end


			local gui = Instance.new("ScreenGui")
			gui.Name = "FlowHubKamuiFX"
			gui.ResetOnSpawn = false
			gui.IgnoreGuiInset = true
			gui.DisplayOrder = 100
			gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
			bg = Instance.new("ImageLabel")
			bg.BackgroundTransparency = 1
			bg.Size = UDim2.new(0, 700, 0, 700)
			bg.Position = UDim2.new(0.5, 0, 0.5, 0)
			bg.AnchorPoint = Vector2.new(0.5, 0.5)
			bg.Image = "rbxassetid://135542686675252"
			bg.ImageTransparency = 1
			bg.Parent = gui
			flash = Instance.new("Frame")
			flash.Size = UDim2.new(1, 0, 1, 0)
			flash.BackgroundColor3 = Color3.new(0, 0, 0)
			flash.BackgroundTransparency = 1
			flash.BorderSizePixel = 0
			flash.ZIndex = 2
			flash.Parent = gui
			soundKamui = Instance.new("Sound")
			soundKamui.SoundId = "rbxassetid://132492029022208"
			soundKamui.Volume = 1
			soundKamui.Parent = gui
			kamuiMusic = Instance.new("Sound")
			kamuiMusic.SoundId = "rbxassetid://9039981149"
			kamuiMusic.Looped = true
			kamuiMusic.Volume = 0.5


			LocalPlayer.CharacterAdded:Connect(function()
				if K.inside then
					K.inside = false
					restoreNormalLighting()
					kamuiMusic:Stop()
				end
			end)
		end

		local function sharingan()
			flash.BackgroundTransparency = 0.5
			bg.ImageTransparency = 0
			local info = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			TweenService:Create(flash, info, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(bg, info, { ImageTransparency = 1 }):Play()
			soundKamui:Play()
		end

		local function warpEffect(callback)
			local blur = Instance.new("BlurEffect")
			blur.Size = 0
			blur.Parent = Lighting
			local tin = TweenService:Create(blur, TweenInfo.new(WARP_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Size = 24 })
			tin:Play(); tin.Completed:Wait()
			callback()
			local tout = TweenService:Create(blur, TweenInfo.new(WARP_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { Size = 0 })
			tout:Play(); tout.Completed:Wait()
			blur:Destroy()
		end

		local function playWindup(char, humanoid, hrp, callback)
			local walk = humanoid.WalkSpeed
			humanoid.WalkSpeed = 0
			hrp.Anchored = true
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://32729592"
			local track = humanoid:LoadAnimation(anim)
			track:Play()
			local fade = {}
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("BasePart") and obj ~= hrp then
					table.insert(fade, obj)
				elseif obj:IsA("Accessory") then
					local h = obj:FindFirstChild("Handle")
					if h then table.insert(fade, h) end
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					table.insert(fade, obj)
				end
			end
			for _, o in ipairs(fade) do TweenService:Create(o, TweenInfo.new(WINDUP_TIME), { Transparency = 1 }):Play() end
			task.wait(WINDUP_TIME)
			for _, o in ipairs(fade) do o.Transparency = 0 end
			track:Stop()
			humanoid.WalkSpeed = walk
			hrp.Anchored = false
			callback()
		end

		local function parts()
			local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			return char, char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
		end
		local function enter()
			local char, hum, hrp = parts()
			K.returnCFrame = hrp.CFrame
			playWindup(char, hum, hrp, function()
				warpEffect(function()
					applyKamuiLighting()
					hrp.CFrame = CFrame.new(centralStructurePosition)
					kamuiMusic.Parent = hrp
					kamuiMusic:Play()
					sharingan()
				end)
				K.inside = true
			end)
		end
		local function leave()
			local char, hum, hrp = parts()
			playWindup(char, hum, hrp, function()
				warpEffect(function()
					restoreNormalLighting()
					if K.returnCFrame then hrp.CFrame = K.returnCFrame end
					kamuiMusic:Stop()
					sharingan()
				end)
				K.inside = false
			end)
		end

		return function()
			if K.busy then return end
			K.busy = true
			task.spawn(function()
				local ok, err = pcall(function()
					build()
					if K.inside then leave() else enter() end
				end)
				if not ok then warn("[FlowHub] Kamui error: " .. tostring(err)) end
				K.busy = false
			end)
		end
	end)()
	t3.AVT:AddSection({ t1:traduzir("Animação & Reset") })
	t3.AVT:AddButton({
		t1:traduzir("Reseta Avatar"),
		function()
			game:GetService("ReplicatedStorage").Remotes.ResetCharacterAppearance:FireServer()
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Animação home ou muie"),
		function()
			game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ 4418326547 }))
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Melhores Partes") })
	t3.AVT:AddButton({
		t1:traduzir("Cabeça Invisível"),
		function()
			game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ 134082579 }))
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Machado Escuro"),
		function()
			game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ 3240543366 }))
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Sistema de Avatares") })

	local u514

	t3.AVT:AddDropdown({
		Name = t1:traduzir("Selecionar Jogador"),
		Description = " ",
		Options = t2,
		Default = u514,
		Callback = function(p73)
			u514 = p73
		end
	})
	t3.AVT:AddSlider({
		Name = t1:traduzir("Verificação De Parts <Update>"),
		Min = 5,
		Max = 15,
		Increase = 1,
		Default = 25,
		Callback = function()
			print("funcionndo oooooo")
		end
	})
	t3.AVT:AddButton({
		Name = t1:traduzir("Copiar Avatar"),
		Callback = function()
			local Players2 = game:GetService("Players")
			local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
			local function say(title, desc, kind)
				pcall(function()
					local env = (getgenv and getgenv()) or _G
					local L = env.FlowLib or _G.FlowLib
					if L then L:Notify({ Title = title, Description = desc, Type = kind or "Info", Duration = 4 }) end
				end)
			end

			if not u514 then
				say("Copy Avatar", "Selecione um jogador primeiro.", "Error")
				return
			end
			local target = Players2:FindFirstChild(u514)
			local myChar = Players2.LocalPlayer.Character
			local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
			local tgtHum = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
			if not myHum or not tgtHum then
				say("Copy Avatar", "Jogador ou personagem não encontrado.", "Error")
				return
			end

			say("Copy Avatar...", "copiando o avatar, aguarde", "Info")

			-- Wear é um TOGGLE: chamar com o id de algo já vestido tira, e o contrário veste.
			local WearR = Remotes:FindFirstChild("Wear")
			local function wear(id)
				id = tonumber(id)
				if not id or id == 0 or not WearR then return false end
				return pcall(function() WearR:InvokeServer(id) end)
			end

			local function accSet(desc)
				local set = {}
				local ok, list = pcall(function() return desc:GetAccessories(true) end)
				if ok and list then
					for _, v in ipairs(list) do
						if v.AssetId then set[tonumber(v.AssetId)] = true end
					end
				end
				return set
			end
			local function isWorn(id)
				local d = myHum:GetAppliedDescription()
				local sid = tostring(id)
				for _, k in ipairs({ "Shirt", "Pants", "GraphicTShirt", "Face", "IdleAnimation", "WalkAnimation",
					"RunAnimation", "JumpAnimation", "FallAnimation", "ClimbAnimation", "SwimAnimation",
					"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg" }) do
					if tostring(d[k]) == sid then return true end
				end
				for _, v in ipairs(d:GetAccessories(true)) do
					if tostring(v.AssetId) == sid then return true end
				end
				return false
			end

			-- 0) reseta a aparência (volta corpo/roupas ao padrão) antes de copiar
			local ResetR = Remotes:FindFirstChild("ResetCharacterAppearance")
			if ResetR then
				pcall(function() ResetR:FireServer() end)
				task.wait(1.2)
				local c = Players2.LocalPlayer.Character
				myHum = (c and c:FindFirstChildOfClass("Humanoid")) or myHum
			end

			local mine = myHum:GetAppliedDescription()
			local theirs = tgtHum:GetAppliedDescription()
			local mineAcc, theirAcc = accSet(mine), accSet(theirs)

			-- 1) tira TUDO que eu uso (acessórios, camisa, calça, camiseta gráfica, rosto), conferindo
			local removeList = {}
			for id in pairs(mineAcc) do table.insert(removeList, id) end
			for _, k in ipairs({ "Shirt", "Pants", "GraphicTShirt", "Face" }) do
				local m = tonumber(mine[k]) or 0
				if m > 0 then table.insert(removeList, m) end
			end
			for _, id in ipairs(removeList) do
				local tries = 0
				while isWorn(id) and tries < 5 do
					tries += 1
					wear(id)
					task.wait(0.15)
				end
			end

			-- 2) corpo (tronco, braços, pernas, cabeça) + 3) cor do corpo
			local CCB = Remotes:FindFirstChild("ChangeCharacterBody")
			local CBC = Remotes:FindFirstChild("ChangeBodyColor")
			local theirBC = target.Character:FindFirstChild("Body Colors")
			local bodyKeys = { "Torso", "RightArm", "LeftArm", "RightLeg", "LeftLeg", "Head" }
			local function bodyMatches()
				local d = myHum:GetAppliedDescription()
				for _, k in ipairs(bodyKeys) do
					if d[k] ~= theirs[k] then return false end
				end
				return true
			end
			local function dumpBody(tag)
				local d = myHum:GetAppliedDescription()
				local out = {}
				for _, k in ipairs(bodyKeys) do
					table.insert(out, k .. "=" .. tostring(d[k]) .. "/" .. tostring(theirs[k]))
				end
				print("[Flowbrook] corpo " .. tag .. " (meu/alvo): " .. table.concat(out, " "))
			end
			local function applyBody()
				dumpBody("antes")
				if CCB then
					local args = { { theirs.Torso, theirs.RightArm, theirs.LeftArm, theirs.RightLeg, theirs.LeftLeg, theirs.Head } }
					for i = 1, 3 do
						local ok, res = pcall(function() return CCB:InvokeServer(unpack(args)) end)
						print("[Flowbrook] ChangeCharacterBody try " .. i .. " ok=" .. tostring(ok) .. " ret=" .. tostring(res))
						task.wait(0.5)
						if bodyMatches() then break end
					end
				end
				-- plano B: veste cada parte do corpo pelo Wear (toggle, confere se ficou)
				if not bodyMatches() then
					for _, k in ipairs(bodyKeys) do
						local id = tonumber(theirs[k]) or 0
						local cur = tonumber(myHum:GetAppliedDescription()[k]) or 0
						if id > 0 and cur ~= id then
							for _ = 1, 3 do
								wear(id)
								task.wait(0.3)
								if (tonumber(myHum:GetAppliedDescription()[k]) or 0) == id then break end
							end
						end
					end
				end
				dumpBody("depois")
				if theirBC and CBC then
					pcall(function() CBC:FireServer(tostring(theirBC.HeadColor)) end)
					task.wait(0.2)
				end
			end
			applyBody()

			-- 4) veste TUDO do alvo, conferindo se ficou (até 6 tentativas por item)
			local queue = {}
			for _, k in ipairs({ "Shirt", "Pants", "GraphicTShirt", "Face" }) do
				local t = tonumber(theirs[k]) or 0
				if t > 0 then table.insert(queue, t) end
			end
			for id in pairs(theirAcc) do table.insert(queue, id) end
			for _, k in ipairs({ "IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation",
				"FallAnimation", "ClimbAnimation", "SwimAnimation" }) do
				local m, t = tonumber(mine[k]) or 0, tonumber(theirs[k]) or 0
				if t > 0 and m ~= t then table.insert(queue, t) end
			end

			local failed = {}
			for _, id in ipairs(queue) do
				local ok = isWorn(id)
				local tries = 0
				while not ok and tries < 6 do
					tries += 1
					if not wear(id) then break end
					task.wait(0.2)
					ok = isWorn(id)
				end
				if not ok then table.insert(failed, id) end
			end

			-- reaplica o corpo no fim (vestir itens pode sobrescrever)
			if not bodyMatches() then applyBody() end

			-- 5) nome/bio RP (se existirem)
			local bag = target:FindFirstChild("PlayersBag")
			local RPT = game:GetService("ReplicatedStorage"):FindFirstChild("RE") and game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t")
			if bag and RPT then
				local n = bag:FindFirstChild("RPName")
				if n and n.Value ~= "" then pcall(function() RPT:FireServer("RolePlayName", n.Value) end); task.wait(0.2) end
				local b = bag:FindFirstChild("RPBio")
				if b and b.Value ~= "" then pcall(function() RPT:FireServer("RolePlayBio", b.Value) end); task.wait(0.2) end
			end

			if #failed > 0 then
				print("[Flowbrook] Copy Avatar - itens que não equiparam: " .. table.concat(failed, ", "))
			end
			say("Copy Avatar", "Copied Successfully", "Success")
		end
	})
	t3.AVT:AddSection({ "FE Scripts Avt" })
	t3.AVT:AddButton({
		Name = "Panico",
		Description = "Pânico FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/yyyyyyyface/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Morty",
		Description = "Morty FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/Mortyyyyyy/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Rick Sanchez",
		Description = "Rick Sanchez FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/rick-Sanchez-/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Cowboy",
		Description = "Cowboy FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/wjsj/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Guest666",
		Description = "Guest666 FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/swsw/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Camera De Carro",
		Description = "Camera de carro no roblox",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/Carfling/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Fe VR",
		Description = "FE VR",
		Callback = function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

			for _, v in ipairs({
				84451219120140,
				72292903231768
			}) do
				pcall(function()
					ReplicatedStorage2:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(v)
				end)
			end

			task.delay(6, function()
				pcall(function()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty45.lua"))()
				end)
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Obito",
		Description = "Obito FE",
		Callback = function()
			loadstring(game:HttpGet("https://cdn.authguard.org/virtual-file/c47b8a12ca6c4cef840280dafd893e7d"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Shadow",
		Description = "Shadow FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Shadow/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Goner",
		Description = "Goner FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/GONER/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Noly",
		Description = "Noly FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/gubby/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Tubers",
		Description = "Tubers FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/1222/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Mãozinha",
		Description = "Mãozinha FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/slafiznotedio/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "C00LKIDD",
		Description = "C00LKIDD FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/xzzxsx/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Emote v2",
		Description = "Emotes FREE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Herobrine",
		Description = "Herobrine FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/hEROBRINE/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "John Doe",
		Description = "John Doe FE",
		Callback = function()
			pcall(function()
				local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

				ReplicatedStorage2.Remotes.ChangeBodyColor:FireServer("Really black")
				ReplicatedStorage2.Remotes.ChangeCharacterBody:InvokeServer({
					0,
					0,
					0,
					0,
					0,
					0
				})
				ReplicatedStorage2.Remotes.Wear:InvokeServer(119700638189201)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(82561279414761)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(108099676910294)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(82861921093234)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(124476454384081)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(5319900634)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(5319909330)
				ReplicatedStorage2.Remotes.Wear:InvokeServer(5319922112)
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Cartoon Cat",
		Description = "Cartoon Cat FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/cartoon-cat/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Ominitrix",
		Description = "Ominitrix FE",
		Callback = function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Ominitrix/refs/heads/main/Main.txt"))()
			end)
		end
	})
	t3.AVT:AddButton({
		Name = "Jerk",
		Description = "Jerk FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Edge.lua"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Emotes FE",
		Description = "Emotes FE",
		Callback = function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Jeff The Killer",
		Description = "Jeff The Killer FE",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Jeff/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddButton({
		Name = "Minecraft",
		Description = "Minecraft no roblox",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/Minecraft/refs/heads/main/Main.txt"))()
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Super Heróis <Packs>") })

	for k, v in pairs({
		["Homen Aranha"] = {
			14908247332,
			16845737664,
			17582186503,
			4211409027,
			14840793625,
			11774975425,
			18507527463,
			3346307465
		}
	}) do
		t3.AVT:AddButton({
			k,
			function()
				for _, v2 in ipairs(v) do
					game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ v2 }))
					task.wait(0.5)
				end
			end
		})
	end

	for k, v in pairs({
		Batma = {
			3049284724,
			3049285265,
			10647971081,
			11977276041
		}
	}) do
		t3.AVT:AddButton({
			k,
			function()
				for _, v2 in ipairs(v) do
					game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ v2 }))
					task.wait(0.5)
				end
			end
		})
	end

	for k, v in pairs({
		["ADM <Magnus>"] = {
			77933716022362,
			73722333789629,
			91122615317042
		}
	}) do
		t3.AVT:AddButton({
			k,
			function()
				for _, v2 in ipairs(v) do
					game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ v2 }))
					task.wait(0.5)
				end
			end
		})
	end

	local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

	local function v556(p79, p80, p81)
		for _, v in ipairs(p79) do
			Remotes.Wear:InvokeServer(unpack({ v }))
			task.wait(0.4)
		end

		if p80 then
			Remotes.ChangeCharacterBody:InvokeServer(unpack({ {
				p80[1] or 0,
				p80[2] or 0,
				p80[3] or 0,
				p80[4] or 0,
				p80[5] or 0,
				p80[6] or 0
			} }))
			task.wait(0.3)
		end

		if p81 then
			Remotes.ChangeBodyColor:FireServer(unpack({ p81 }))
		end
	end

	t3.AVT:AddSection({ t1:traduzir("Mulher Bonita <Packs>") })
	t3.AVT:AddButton({
		t1:traduzir("Diva"),
		function()
			v556({
				11360863184,
				17656515587,
				18927622972,
				89283403956872,
				16040053134,
				16899958482,
				7074764,
				398633812,
				10767462626
			}, {
				86499666,
				86499698,
				86499716,
				4637243648,
				4637242166,
				86498113
			}, "Pastel brown")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Estilosa"),
		function()
			v556({
				12938939719,
				1018553897,
				80421353242027,
				124139520692742,
				16746345026,
				107641508206263,
				109333206714180,
				17577949104,
				90353843350916,
				16177197399,
				144075659
			}, {
				86499666,
				86499698,
				86499716,
				86500078,
				86500064,
				746767604
			}, "Pastel brown")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Elegância Rosa-Pastel"),
		function()
			v556({
				607785314,
				144076760,
				126583402548463,
				13979330180,
				17336525832,
				88103003332276,
				16687323428,
				18517084101,
				125783616515731,
				18105274965,
				12548809610,
				14708696366,
				10907197686,
				16945491141,
				109260326125093,
				17286711891,
				619511648,
				77427504538679,
				8923596632,
				619512450,
				5319900634,
				619512767
			}, {
				86499666,
				86499698,
				86499716,
				86500078,
				86500064,
				746767604
			}, "Cocoa")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Hello Kitty"),
		function()
			v556({
				13173625676,
				4899180116,
				3810243219,
				93871285817506,
				12350578988,
				16725686557,
				137102739371519,
				18197906770,
				121124788407780,
				7343929525,
				12064732367,
				16860622017,
				6808475694,
				150381051,
				10557360323,
				4300266038,
				6055891536,
				7331163641,
				607785314,
				144076760,
				79519657364119
			}, {
				86499666,
				86499698,
				86499716,
				4637243648,
				4637242166,
				86498113
			}, "Black")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Girl Y2k"),
		function()
			v556({
				117962544014646,
				79090236788624,
				126490351689789,
				87525012171586,
				117202070642397,
				95833326294342,
				18257712999,
				15678185297,
				17006900288
			}, {
				86499666,
				86499698,
				86499716,
				4637243648,
				4637242166,
				86498113
			}, "Light orange")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Girl v2"),
		function()
			v556({
				96165808437053,
				16266670139,
				138071050651366,
				14439161358,
				78467861086741,
				17331454126,
				115581513157249,
				114153430587737,
				125828421311007,
				81108098355950,
				108041588020934,
				17529187838,
				130737457414077,
				12922239190,
				13481364215,
				12070660079,
				16290585600,
				6962749149,
				10482501471
			}, {
				86499666,
				86499698,
				86499716,
				4637243648,
				4637242166,
				86498113
			}, "Light orange")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Informações De Uso"),
		function()
			v13:Dialog({
				Title = "Fun",
				Text = t1:traduzir("•As funções acima já aplicam as roupas completas, portanto, basta apenas modificar o corpo ou a cor."),
				Options = { {
					"Fechar",
					function()
					end
				} }
			})
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Packs <Masculinos") })
	t3.AVT:AddButton({
		t1:traduzir("E os D <Masculino>"),
		function()
			v556({
				619544080,
				4545294588,
				5727822995,
				3131092953,
				14394019402,
				14908247332,
				6105519422,
				100214234209945,
				12655501529,
				5315424251,
				4378579302,
				10569953351,
				4078052877,
				4508445398,
				6070755733,
				10159610478,
				14159848208,
				162068415,
				6093227893
			}, {
				376532000,
				376531012,
				376530220,
				37754710,
				139572789,
				0
			}, "Sun Tan")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Clonado de <Masculino>"),
		function()
			v556({
				619544080,
				4545294588,
				5727822995,
				3131092953,
				14394019402,
				14908247332,
				6105519422,
				100214234209945,
				12655501529,
				5315424251,
				4378579302,
				10569953351,
				4078052877,
				4508445398,
				6070755733,
				10159610478,
				14159848208,
				162068415,
				6093227893
			}, {
				376532000,
				376531012,
				376530220,
				37754710,
				139572789,
				0
			}, "Pale brown")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("LOUD <Masculino>"),
		function()
			v556({
				12300914679,
				14711386122,
				12134711097,
				14250194694,
				11093823714,
				13620518518,
				14610802451,
				71760767936397,
				3343204006,
				10798519329,
				109333206714180,
				124139520692742,
				12930533426,
				80039258998314,
				855783877,
				855776103,
				18615036770,
				15036817621,
				6093229495,
				18220511033,
				90934633702402
			}, {
				376532000,
				376531012,
				376530220,
				37754710,
				139572789,
				0
			}, "Dark nougat")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Fino <Masculino>"),
		function()
			v556({
				80615317017048,
				78515624557784,
				83728028938556,
				15920848733,
				117962544014646,
				123033387074147,
				118006629713408,
				12887129839,
				7189083561,
				12142438478
			}, {
				376532000,
				376531012,
				376530220,
				37754710,
				139572789,
				0
			}, "Dark nougat")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Trajado <Masculino>"),
		function()
			v556({
				15703568073,
				18236504983,
				13479814649,
				18179500302,
				18199811960,
				18863739797,
				11093817656,
				12432342407,
				75844104186976,
				17162919797,
				17513707733,
				82973533809363,
				75623454441613,
				12357069856,
				18538149046,
				95312255683838,
				109333206714180,
				15100020498,
				18507389298,
				124139520692742
			}, {}, "Dark nougat")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Sem dona <Masculino>"),
		function()
			v556({
				14762120248,
				14159814207,
				18264063859,
				15153876013,
				5727822995,
				15483154656,
				8966711821,
				102338622582054,
				10553396797,
				4508445398,
				13620518518,
				6093226569,
				12719043468,
				88040909583438
			}, {}, "Dark nougat")
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Packs Variados <Conjuntos>") })
	t3.AVT:AddButton({
		t1:traduzir(" Paty Urbana"),
		function()
			v556({
				11356850323,
				11437083587,
				11352777399
			}, {
				15539008532,
				15539008875,
				15539008680,
				15539008795,
				15539011945,
				1
			}, "Pastel brown")
		end
	})
	t3.AVT:AddButton({
		t1:traduzir(" Freak Show"),
		function()
			v556({
				113688815143735,
				226948064,
				17475516808
			}, {
				0,
				0,
				0,
				0,
				0,
				0
			}, "Ivory")
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Roupas 3D <Conjuntos>") })

	local t43 = {
		["Mostro do S.A"] = 123609977175226,
		Impostor = 18234669337,
		["Gato Up"] = 18994959003,
		Gato = 77506186615650,
		Galinha = 71251793812515,
		Coelho = 71797333686800,
		Bosta = 77013984520332,
		Cachorro = 18656467256,
		Pinguim = 94944293759578,
		["Shrek do mal"] = 120960401202173,
		["Pepa Pig"] = 92979204778377,
		Pato = 135132836238349,
		MotoMoto = 73215892129281,
		Mosquito = 108052868536435
	}
	local t44 = {}

	for k in pairs(t43) do
		table.insert(t44, k)
	end

	local u562

	t3.AVT:AddDropdown({
		Name = t1:traduzir("Skins 3D"),
		Description = t1:traduzir("Roupas 3D Varias opções Tops!"),
		Options = t44,
		Default = "Roupas",
		Callback = function(p82)
			u562 = p82
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Vestir"),
		function()
			if u562 and t43[u562] then
				local t45 = { t43[u562] }

				game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack(t45))
			end
		end
	})
	t3.AVT:AddSection({ t1:traduzir("Especiais Efeitos <Acessórios>") })

	local t46 = {
		["Fada do Outono"] = 128217885,
		["Fada da Primavera"] = 150381051,
		["Fada do Dia de São Petersburgo"] = 226189871,
		["Fada do Inverno"] = 141742418,
		["Risada de Bruxa"] = 305888394,
		["Chifres Bsp"] = 233705355,
		Ghosdeeri = 132809431,
		["Anjo Brilhante Winas"] = 192557913
	}
	local u565
	local t47 = {}

	for k in pairs(t46) do
		table.insert(t47, k)
	end

	t3.AVT:AddDropdown({
		Name = t1:traduzir("Escolha o Efeito"),
		Description = t1:traduzir("Selecione um acessório para ativar"),
		Options = t47,
		Default = "Efeitos",
		Callback = function(p83)
			u565 = p83
		end
	})
	t3.AVT:AddButton({
		t1:traduzir("Vestir Acessório"),
		function()
			if u565 then
				local v568 = t46[u565]

				if v568 then
					game:GetService("ReplicatedStorage").Remotes.Wear:InvokeServer(unpack({ v568 }))
				end
			end
		end
	})
end)
task.spawn(function()
	task.wait(8)
	task.wait(0.1)
	t3.PR:AddSection({ t1:traduzir("Security Local") })

	local Players2 = game:GetService("Players")
	local Workspace2 = game:GetService("Workspace")
	local LocalPlayer2 = Players2.LocalPlayer
	local u572 = false
	local u573 = false
	local u574 = false
	local t48 = {}
	local u576 = false
	local t49 = {
		"bomb",
		"soccer",
		"boat"
	}

	local function v578(p84, p85)
		if typeof(p84) ~= "string" then
			return false
		end

		local v579 = p84:lower()

		for _, v in ipairs(p85) do
			if v579:find(v) then
				return true
			end
		end

		return false
	end
	local function v582(descendant)
		if not descendant:IsA("BasePart") then
			return
		end

		local v583 = descendant.Name:lower()

		if v583:find("wheel") then
			return
		end

		local v584 = v578(v583, t49)
		local v585 = false
		local Parent = descendant
		local exitTo

		while true do
			if not Parent then
				exitTo = 1

				break
			end

			local v588 = Parent.Name:lower()

			if v588:find("wheel") then
				break
			end

			if not v588:find("car") then
				Parent = Parent.Parent

				continue
			end

			exitTo = 2

			break
		end

		if exitTo ~= 1 then
			if exitTo ~= 2 then
				return
			end

			v585 = true
		end

		if v585 then
			descendant.CanCollide = not u573
		elseif v584 then
			descendant.CanCollide = not u574
		end
	end
	local function v589()
		for _, descendant in ipairs(Workspace2:GetDescendants()) do
			v582(descendant)
		end
	end
	local function v592()
		if u576 then
			return
		end

		u576 = true
		v589()
		table.insert(t48, Workspace2.DescendantAdded:Connect(v582))
	end
	local function v593()
		local Humanoid_ = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

		if Humanoid_ then
			Humanoid_:SetStateEnabled(Enum.HumanoidStateType.Seated, not (u572 or u573))
		end
	end
	local function v595(character_)
		local Humanoid_ = character_:WaitForChild("Humanoid")

		v593()
		table.insert(t48, Humanoid_.StateChanged:Connect(function(old, new)
			if (u572 or u573) and new == Enum.HumanoidStateType.Seated then
				Humanoid_:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end))
	end

	LocalPlayer2.CharacterAdded:Connect(v595)

	if LocalPlayer2.Character then
		v595(LocalPlayer2.Character)
	end

	local function v597()
		if u572 or u573 or u574 then
			v592()
		end

		v593()
		v589()
	end

	local PR = t3.PR
	local v599 = PR
	local AddToggle = PR.AddToggle

	AddToggle(v599, {
		Name = t1:traduzir("Anti Tool"),
		Description = t1:traduzir("Impede sentar via Tool"),
		Default = false
	}):Callback(function(p86)
		u572 = p86
		v597()
	end)
	t3.PR:AddToggle({
		Name = t1:traduzir("Anti Car"),
		Description = t1:traduzir("Impede sentar em Carro"),
		Default = false
	}):Callback(function(p87)
		u573 = p87
		v597()
	end)
	t3.PR:AddToggle({
		Name = t1:traduzir("Anti Script"),
		Description = t1:traduzir("Proteção contra colisões de veículos/objetos"),
		Default = false
	}):Callback(function(p88)
		u574 = p88
		v597()
	end)

	local RunService2 = game:GetService("RunService")
	local connection

	t3.PR:AddToggle({
		Name = t1:traduzir("Anti Bug"),
		Description = t1:traduzir("Bug players/Bug Weapon/Protection rapidez"),
		Default = false
	}):Callback(function(p89)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if p89 then
			connection = RunService2.Stepped:Connect(function()
				local CurrentCamera = workspace.CurrentCamera or workspace:FindFirstChild("Camera")

				if not CurrentCamera then
					return
				end

				for _, child in ipairs(CurrentCamera:GetChildren()) do
					if child:IsA("BasePart") and child.Name == "water" then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end)
		end
	end)
	t3.PR:AddToggle({
		Name = t1:traduzir("Anti ChatSpy"),
		Description = t1:traduzir("Impede que outros vejam seus chats <Creator>"),
		Default = false
	}):Callback(function(p90)
		if p90 then
			local ChatSpy = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("ChatSpy")

			if ChatSpy then
				ChatSpy.Disabled = true
			end
		else
			local ChatSpy = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("ChatSpy")

			if ChatSpy then
				ChatSpy.Disabled = false
			end
		end
	end)
	t3.PR:AddSection("Security Exploits")

	local t50 = {
		Canoe = false,
		Jet = false,
		Heli = false,
		Ball = false
	}

	task.spawn(function()
		local _
		local state = 1
		local WorkspaceCom, v627, forIter, forState, forControl, v631, v632, AirportHanger, v634, JetAirport, forIter2, forState2, forControl2, v639, v640, PoliceStationHeli, forIter3, forState3, forControl3, v645, v646, forIter4, forState4, forControl4, v650

		while true do
			if state == 1 then
				WorkspaceCom = Workspace2:FindFirstChild("WorkspaceCom")

				if WorkspaceCom then
					state = 2
				else
					state = 34
				end
			elseif state == 2 then
				if t50.Canoe then
					state = 3
				else
					state = 9
				end
			elseif state == 3 then
				v627 = WorkspaceCom:FindFirstChild("001_CanoeStorage")

				if v627 then
					state = 4
				else
					state = 9
				end
			elseif state == 4 then
				state = 5
			elseif state == 5 then
				forIter, forState, forControl = ipairs(v627:GetChildren())

				if type(forIter) == 'table' then
					local forMeta = getmetatable(forIter)

					if type(forMeta) == 'table' and forMeta['__iter'] then
						forIter, forState, forControl = (forMeta['__iter'](forIter))
					else
						forIter, forState, forControl = next, forIter, nil
					end
				end

				state = 6
			elseif state == 6 then
				local v652

				v652, v631 = (forIter(forState, forControl))

				if v652 == nil then
					state = 9
				else
					forControl = v652
					state = 7
				end
			elseif state == 7 then
				local Owner = v631:FindFirstChild("Owner")

				if Owner and Owner.Value == LocalPlayer then
					state = 6
				else
					state = 8
				end
			elseif state == 8 then
				v631:Destroy()
				state = 6
			elseif state == 9 then
				if t50.Jet then
					state = 10
				else
					state = 20
				end
			elseif state == 10 then
				v632 = WorkspaceCom:FindFirstChild("001_Airport")

				if v632 then
					state = 11
				else
					state = 20
				end
			elseif state == 11 then
				AirportHanger = v632:FindFirstChild("AirportHanger")

				if AirportHanger then
					state = 12
				else
					state = 20
				end
			elseif state == 12 then
				v634 = AirportHanger:FindFirstChild("001_JetStorage")

				if v634 then
					state = 13
				else
					state = 20
				end
			elseif state == 13 then
				JetAirport = v634:FindFirstChild("JetAirport")

				if JetAirport then
					state = 14
				else
					state = 20
				end
			elseif state == 14 then
				state = 15
			elseif state == 15 then
				forIter2, forState2, forControl2 = ipairs(JetAirport:GetChildren())

				if type(forIter2) == 'table' then
					local forMeta2 = getmetatable(forIter2)

					if type(forMeta2) == 'table' and forMeta2['__iter'] then
						forIter2, forState2, forControl2 = (forMeta2['__iter'](forIter2))
					else
						forIter2, forState2, forControl2 = next, forIter2, nil
					end
				end

				state = 16
			elseif state == 16 then
				local v655

				v655, v639 = (forIter2(forState2, forControl2))

				if v655 == nil then
					state = 20
				else
					forControl2 = v655
					state = 17
				end
			elseif state == 17 then
				if v639.Name == LocalPlayer.Name then
					state = 19
				else
					state = 18
				end
			elseif state == 18 then
				v639:Destroy()
				state = 16
			elseif state == 19 then
				state = 16
			elseif state == 20 then
				if t50.Heli then
					state = 21
				else
					state = 28
				end
			elseif state == 21 then
				v640 = WorkspaceCom:FindFirstChild("001_HeliStorage")

				if v640 then
					state = 22
				else
					state = 28
				end
			elseif state == 22 then
				PoliceStationHeli = v640:FindFirstChild("PoliceStationHeli")

				if PoliceStationHeli then
					state = 23
				else
					state = 28
				end
			elseif state == 23 then
				state = 24
			elseif state == 24 then
				forIter3, forState3, forControl3 = ipairs(PoliceStationHeli:GetChildren())

				if type(forIter3) == 'table' then
					local forMeta3 = getmetatable(forIter3)

					if type(forMeta3) == 'table' and forMeta3['__iter'] then
						forIter3, forState3, forControl3 = (forMeta3['__iter'](forIter3))
					else
						forIter3, forState3, forControl3 = next, forIter3, nil
					end
				end

				state = 25
			elseif state == 25 then
				local v657

				v657, v645 = (forIter3(forState3, forControl3))

				if v657 == nil then
					state = 28
				else
					forControl3 = v657
					state = 26
				end
			elseif state == 26 then
				if v645.Name == LocalPlayer.Name then
					state = 25
				else
					state = 27
				end
			elseif state == 27 then
				v645:Destroy()
				state = 25
			elseif state == 28 then
				if t50.Ball then
					state = 29
				else
					state = 34
				end
			elseif state == 29 then
				v646 = WorkspaceCom:FindFirstChild("001_SoccerBalls")

				if v646 then
					state = 30
				else
					state = 34
				end
			elseif state == 30 then
				state = 31
			elseif state == 31 then
				forIter4, forState4, forControl4 = ipairs(v646:GetChildren())

				if type(forIter4) == 'table' then
					local forMeta4 = getmetatable(forIter4)

					if type(forMeta4) == 'table' and forMeta4['__iter'] then
						forIter4, forState4, forControl4 = (forMeta4['__iter'](forIter4))
					else
						forIter4, forState4, forControl4 = next, forIter4, nil
					end
				end

				state = 32
			elseif state == 32 then
				local v659

				v659, v650 = (forIter4(forState4, forControl4))

				if v659 == nil then
					state = 34
				else
					forControl4 = v659
					state = 33
				end
			elseif state == 33 then
				v650:Destroy()
				state = 32
			elseif state == 34 then
				task.wait(0.2)
				state = 1
			end
		end
	end)
	t3.PR:AddToggle({
		Name = "Anti Ball",
		Default = false,
		Callback = function(p91)
			t50.Ball = p91
		end
	})
	t3.PR:AddToggle({
		Name = "Anti Canoe",
		Default = false,
		Callback = function(p92)
			t50.Canoe = p92
		end
	})
	t3.PR:AddToggle({
		Name = "Anti Jet",
		Default = false,
		Callback = function(p93)
			t50.Jet = p93
		end
	})
	t3.PR:AddToggle({
		Name = "Anti Helicopter",
		Default = false,
		Callback = function(p94)
			t50.Heli = p94
		end
	})
	t3.PR:AddToggle({
		Name = "Anti Canoe",
		Default = false,
		Callback = function(p95)
			t50.Canoe = p95
		end
	})
end)
task.spawn(function()
	task.wait(9)
	t3.JJ:AddMiniMap({
		"Radar",
		Size = 140,
		Zoom = 0.05,
		ShowPlayers = true
	})
	t3.JJ:AddSection({ t1:traduzir("Jogador Local") })

	local t51 = {
		noClip = false,
		infiniteJump = false,
		invisible = false
	}

	local function v661()
		if t51.noClip and LocalPlayer.Character then
			for _, descendant in pairs(LocalPlayer.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end
	end
	local function v664()
		if t51.infiniteJump then
			if LocalPlayer.Character then
				local Humanoid_ = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid_ then
					Humanoid_:ChangeState("Jumping")
				end
			end
		end
	end

	t3.JJ:AddToggle({
		Name = t1:traduzir("Atravessar Paredes"),
		Description = t1:traduzir("Permite atravessar paredes e objetos"),
		Default = false,
		Callback = function(p96)
			t51.noClip = p96
		end
	})
	t3.JJ:AddToggle({
		Name = t1:traduzir("Pulos Infinitos"),
		Description = t1:traduzir("Permite pular infinitamente no ar"),
		Default = false,
		Callback = function(p97)
			t51.infiniteJump = p97
		end
	})

	t3.H:AddSection({ "Crie Nomes Com Extinto" })
	getgenv().CustomText = "New Message!"
	t3.H:AddTextBox({
		Title = "Digite Um Texto",
		Description = "Crie um Nome de extinto",
		Default = "New Message!",
		ClearText = false,
		Callback = function(p102)
			getgenv().CustomText = p102
		end
	})
	t3.H:AddButton({
		"Cria Nome Extinto",
		function()
			if getgenv()._Running then
				warn("A process is already running")

				return
			end

			getgenv()._Running = true

			local Players2 = game:GetService("Players")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local CoreGui = game:GetService("CoreGui")
			local LocalPlayer2 = Players2.LocalPlayer

			ReplicatedStorage2.RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllTools")

			if CoreGui:FindFirstChild("LoadingUI") then
				return
			end

			local t52 = {
				A = {
					"01110",
					"10001",
					"10001",
					"11111",
					"10001",
					"10001",
					"10001"
				},
				B = {
					"11110",
					"10001",
					"10001",
					"11110",
					"10001",
					"10001",
					"11110"
				},
				C = {
					"01110",
					"10001",
					"10000",
					"10000",
					"10000",
					"10001",
					"01110"
				},
				D = {
					"11110",
					"10001",
					"10001",
					"10001",
					"10001",
					"10001",
					"11110"
				},
				E = {
					"11111",
					"10000",
					"10000",
					"11110",
					"10000",
					"10000",
					"11111"
				},
				F = {
					"11111",
					"10000",
					"10000",
					"11110",
					"10000",
					"10000",
					"10000"
				},
				G = {
					"01110",
					"10001",
					"10000",
					"10111",
					"10001",
					"10001",
					"01110"
				},
				H = {
					"10001",
					"10001",
					"10001",
					"11111",
					"10001",
					"10001",
					"10001"
				},
				I = {
					"111",
					"010",
					"010",
					"010",
					"010",
					"010",
					"111"
				},
				J = {
					"00111",
					"00010",
					"00010",
					"00010",
					"10010",
					"10010",
					"01100"
				},
				K = {
					"10001",
					"10010",
					"10100",
					"11000",
					"10100",
					"10010",
					"10001"
				},
				L = {
					"10000",
					"10000",
					"10000",
					"10000",
					"10000",
					"10000",
					"11111"
				},
				M = {
					"10001",
					"11011",
					"10101",
					"10101",
					"10001",
					"10001",
					"10001"
				},
				N = {
					"10001",
					"11001",
					"10101",
					"10011",
					"10001",
					"10001",
					"10001"
				},
				O = {
					"01110",
					"10001",
					"10001",
					"10001",
					"10001",
					"10001",
					"01110"
				},
				P = {
					"11110",
					"10001",
					"10001",
					"11110",
					"10000",
					"10000",
					"10000"
				},
				Q = {
					"01110",
					"10001",
					"10001",
					"10001",
					"10101",
					"10010",
					"01101"
				},
				R = {
					"11110",
					"10001",
					"10001",
					"11110",
					"10100",
					"10010",
					"10001"
				},
				S = {
					"01111",
					"10000",
					"10000",
					"01110",
					"00001",
					"00001",
					"11110"
				},
				T = {
					"11111",
					"00100",
					"00100",
					"00100",
					"00100",
					"00100",
					"00100"
				},
				U = {
					"10001",
					"10001",
					"10001",
					"10001",
					"10001",
					"10001",
					"01110"
				},
				V = {
					"10001",
					"10001",
					"10001",
					"10001",
					"10001",
					"01010",
					"00100"
				},
				W = {
					"10001",
					"10001",
					"10001",
					"10101",
					"10101",
					"11011",
					"10001"
				},
				X = {
					"10001",
					"01010",
					"00100",
					"00100",
					"01010",
					"10001",
					"10001"
				},
				Y = {
					"10001",
					"10001",
					"10001",
					"01010",
					"00100",
					"00100",
					"00100"
				},
				Z = {
					"11111",
					"00001",
					"00010",
					"00100",
					"01000",
					"10000",
					"11111"
				},
				["0"] = {
					"01110",
					"10001",
					"10011",
					"10101",
					"11001",
					"10001",
					"01110"
				},
				["1"] = {
					"00100",
					"01100",
					"00100",
					"00100",
					"00100",
					"00100",
					"01110"
				},
				["2"] = {
					"01110",
					"10001",
					"00001",
					"00010",
					"00100",
					"01000",
					"11111"
				},
				["3"] = {
					"11111",
					"00010",
					"00100",
					"00010",
					"00001",
					"10001",
					"01110"
				},
				["4"] = {
					"00010",
					"00110",
					"01010",
					"10010",
					"11111",
					"00010",
					"00010"
				},
				["5"] = {
					"11111",
					"10000",
					"11110",
					"00001",
					"00001",
					"10001",
					"01110"
				},
				["6"] = {
					"00110",
					"01000",
					"10000",
					"11110",
					"10001",
					"10001",
					"01110"
				},
				["7"] = {
					"11111",
					"00001",
					"00010",
					"00100",
					"01000",
					"10000",
					"10000"
				},
				["8"] = {
					"01110",
					"10001",
					"10001",
					"01110",
					"10001",
					"10001",
					"01110"
				},
				["9"] = {
					"01110",
					"10001",
					"10001",
					"01111",
					"00001",
					"00010",
					"01100"
				},
				[" "] = {
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"00000"
				},
				["!"] = {
					"00100",
					"00100",
					"00100",
					"00100",
					"00100",
					"00000",
					"00100"
				},
				["?"] = {
					"01110",
					"10001",
					"00001",
					"00010",
					"00100",
					"00000",
					"00100"
				},
				["."] = {
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"00110",
					"00110"
				},
				[","] = {
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"00100",
					"01000"
				},
				[":"] = {
					"00000",
					"00110",
					"00110",
					"00000",
					"00110",
					"00110",
					"00000"
				},
				[";"] = {
					"00000",
					"00110",
					"00110",
					"00000",
					"00100",
					"01000",
					"00000"
				},
				["-"] = {
					"00000",
					"00000",
					"00000",
					"11111",
					"00000",
					"00000",
					"00000"
				},
				["+"] = {
					"00000",
					"00100",
					"00100",
					"11111",
					"00100",
					"00100",
					"00000"
				},
				["="] = {
					"00000",
					"11111",
					"00000",
					"11111",
					"00000",
					"00000",
					"00000"
				},
				["/"] = {
					"00001",
					"00010",
					"00100",
					"01000",
					"10000",
					"00000",
					"00000"
				},
				["("] = {
					"00010",
					"00100",
					"01000",
					"01000",
					"01000",
					"00100",
					"00010"
				},
				[")"] = {
					"01000",
					"00100",
					"00010",
					"00010",
					"00010",
					"00100",
					"01000"
				},
				["*"] = {
					"00000",
					"00100",
					"10101",
					"01110",
					"10101",
					"00100",
					"00000"
				},
				["%"] = {
					"11001",
					"11010",
					"00100",
					"01000",
					"10110",
					"10011",
					"00000"
				},
				["@"] = {
					"01110",
					"10001",
					"10011",
					"10101",
					"10111",
					"10000",
					"01110"
				},
				["#"] = {
					"01010",
					"01010",
					"11111",
					"01010",
					"11111",
					"01010",
					"01010"
				},
				["$"] = {
					"00100",
					"01111",
					"10100",
					"01110",
					"00101",
					"11110",
					"00100"
				},
				["&"] = {
					"01100",
					"10010",
					"10100",
					"01000",
					"10101",
					"10010",
					"01101"
				},
				["'"] = {
					"00100",
					"00100",
					"00000",
					"00000",
					"00000",
					"00000",
					"00000"
				},
				_ = {
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"00000",
					"11111"
				}
			}
			local ScreenGui = Instance.new("ScreenGui", CoreGui)

			ScreenGui.Name = "LoadingUI"
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.DisplayOrder = 999999
			ScreenGui.ResetOnSpawn = false
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			local Frame = Instance.new("Frame", ScreenGui)

			Frame.Size = UDim2.new(0, 400, 0, 60)
			Frame.Position = UDim2.new(0.5, -200, 0.5, -30)
			Frame.BackgroundTransparency = 1
			Frame.ZIndex = 5

			local TextLabel = Instance.new("TextLabel", Frame)

			TextLabel.Size = UDim2.new(1, 0, 0, 30)
			TextLabel.Position = UDim2.new(0, 0, 0, 0)
			TextLabel.Text = "Loading..."
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 20
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.ZIndex = 5

			local Frame2 = Instance.new("Frame", Frame)

			Frame2.Size = UDim2.new(1, 0, 0, 20)
			Frame2.Position = UDim2.new(0, 0, 1, -20)
			Frame2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Frame2.BorderSizePixel = 0
			Frame2.ClipsDescendants = true
			Frame2.ZIndex = 5
			Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 10)

			local Frame3 = Instance.new("Frame", Frame2)

			Frame3.Size = UDim2.new(0, 0, 1, 0)
			Frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame3.BorderSizePixel = 0
			Frame3.ZIndex = 5
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 10)
			Instance.new("UIGradient", Frame3).Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 60))
			})

			local TextLabel2 = Instance.new("TextLabel", Frame)

			TextLabel2.Size = UDim2.new(1, 0, 0, 20)
			TextLabel2.Position = UDim2.new(0, 0, 1, 5)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextSize = 16
			TextLabel2.TextColor3 = Color3.new(1, 1, 1)
			TextLabel2.Text = "Tools: 0"
			TextLabel2.ZIndex = 5

			local function v694()
				local n30 = 0

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							n30 += 1
						end
					end
				end

				return n30
			end
			local function v700(p103)
				local n31 = 0

				for match in p103:upper():gmatch(".") do
					local v703 = t52[match]

					if v703 then
						for _, v in ipairs(v703) do
							n31 += v:gsub("0", ""):len()
						end
					else
						warn("Invalid character:", match)
					end
				end

				return n31
			end

			local CustomText = getgenv().CustomText or "New Message!"
			local v707 = v700(CustomText)

			local function v708(p104)
				for i = 1, 100 do
					Frame3.Size = UDim2.new(i / 100, 0, 1, 0)

					local v710 = "/" .. v707

					TextLabel2.Text = "Tools: " .. v694() .. v710
					task.wait(0.03)
				end

				p104()
			end

			v708(function()
				local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
				local Position = HumanoidRootPart.Position

				local function v713(p105)
					HumanoidRootPart.CFrame = CFrame.new(p105)
				end

				v713(Vector3.new(430, -108, 100))
				task.wait(0.5)

				local ClickDetector = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_DayCare").Tools:WaitForChild("FireX"):WaitForChild("ClickDetector")

				repeat
					fireclickdetector(ClickDetector)

					local v715 = "/" .. v707

					TextLabel2.Text = "Tools: " .. v694() + 1 .. v715
					task.wait()
				until v707 <= v694()

				task.wait(1)

				local t53 = {}

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(t53, child)
						end
					end
				end

				if v707 > #t53 then
					warn("Not enough tools, required: " .. v707 .. ", Found: " .. #t53)
					getgenv()._Running = false

					return
				end

				for _, child in ipairs(LocalPlayer2.Character:GetChildren()) do
					if child:IsA("Tool") then
						child.Parent = LocalPlayer2.Backpack
					end
				end

				task.wait(0.2)

				local t54 = {}
				local vector3 = Vector3.new(0, -5, 0)
				local vector32 = Vector3.new(1.2, 1.2, 0)
				local n32 = 1
				local n33 = 0

				for i = 1, #CustomText do
					local v729 = t52[CustomText:sub(i, i):upper()]

					if v729 then
						for i2 = 1, #v729 do
							for i3 = 1, #v729[i2] do
								if v729[i2]:sub(i3, i3) == "1" then
									local v732 = t53[n32]

									if v732 then
										t54[v732] = CFrame.new(vector3.X + (n33 + i3 - 1) * vector32.X, vector3.Y + (i2 - 1) * vector32.Y, vector3.Z)
										n32 += 1
									end
								end
							end
						end

						n33 += #v729[1] + 1
					end
				end

				v713(Position)
				task.wait(3)

				for k, v in pairs(t54) do
					k.Grip = v
				end

				task.wait(3)

				for i = 1, v707 do
					if t53[i] then
						t53[i].Parent = LocalPlayer2.Character
					end
				end

				ScreenGui:Destroy()
				getgenv()._Running = false
			end)
		end
	})
	t3.TT:AddSection({ t1:traduzir("Crie um Muro de tools") })

	local n34 = 100

	t3.TT:AddDropdown({
		Name = "Tamanho Do Muro",
		Description = "Escolha a quantidade de tools para formar o muro",
		Options = {
			"100",
			"200",
			"300",
			"400"
		},
		Default = "Size",
		Flag = "WallSize",
		Callback = function(p106)
			n34 = tonumber(p106)
		end
	})
	t3.TT:AddButton({
		Name = "Criar Muro",
		Callback = function()
			if getgenv()._Running then
				warn("A process is already running")

				return
			end

			getgenv()._Running = true

			local Players2 = game:GetService("Players")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local CoreGui = game:GetService("CoreGui")
			local LocalPlayer2 = Players2.LocalPlayer

			ReplicatedStorage2.RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllTools")

			if CoreGui:FindFirstChild("LoadingUI") then
				return
			end

			local ScreenGui = Instance.new("ScreenGui", CoreGui)

			ScreenGui.Name = "LoadingUI"
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.DisplayOrder = 999999
			ScreenGui.ResetOnSpawn = false
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.new(0, 200, 0, 40)
			Frame.Position = UDim2.new(0, 10, 0, 10)
			Frame.BackgroundTransparency = 1
			Frame.ZIndex = 5
			Frame.Parent = ScreenGui

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.new(0, 30, 0, 30)
			ImageLabel.Position = UDim2.new(0, 0, 0.5, -15)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = "rbxassetid://72495850369898"
			ImageLabel.ZIndex = 5
			ImageLabel.Parent = Frame

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -35, 1, 0)
			TextLabel.Position = UDim2.new(0, 35, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "Flow Hub"
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 20
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.ZIndex = 5
			TextLabel.Parent = Frame

			local ImageLabel2 = Instance.new("ImageLabel", ScreenGui)

			ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
			ImageLabel2.Position = UDim2.new(0, 0, 0, 0)
			ImageLabel2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			ImageLabel2.BorderSizePixel = 0
			ImageLabel2.Image = "rbxassetid://79888503709168"
			ImageLabel2.ImageTransparency = 0
			ImageLabel2.ScaleType = Enum.ScaleType.Stretch
			ImageLabel2.ZIndex = 0

			local TextButton = Instance.new("TextButton", ScreenGui)

			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Position = UDim2.new(0, 0, 0, 0)
			TextButton.BackgroundTransparency = 1
			TextButton.BorderSizePixel = 0
			TextButton.Text = ""
			TextButton.Modal = true
			TextButton.AutoButtonColor = false
			TextButton.ZIndex = 1

			local Frame2 = Instance.new("Frame", ScreenGui)

			Frame2.Size = UDim2.new(0, 400, 0, 60)
			Frame2.Position = UDim2.new(0.5, -200, 0.5, -30)
			Frame2.BackgroundTransparency = 1
			Frame2.ZIndex = 5

			local TextLabel2 = Instance.new("TextLabel", Frame2)

			TextLabel2.Size = UDim2.new(1, 0, 0, 30)
			TextLabel2.Position = UDim2.new(0, 0, 0, 0)
			TextLabel2.Text = "Loading..."
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextSize = 20
			TextLabel2.TextColor3 = Color3.new(1, 1, 1)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.ZIndex = 5

			local Frame3 = Instance.new("Frame", Frame2)

			Frame3.Size = UDim2.new(1, 0, 0, 20)
			Frame3.Position = UDim2.new(0, 0, 1, -20)
			Frame3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Frame3.BorderSizePixel = 0
			Frame3.ClipsDescendants = true
			Frame3.ZIndex = 5
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 10)

			local Frame4 = Instance.new("Frame", Frame3)

			Frame4.Size = UDim2.new(0, 0, 1, 0)
			Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame4.BorderSizePixel = 0
			Frame4.ZIndex = 5
			Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 10)
			Instance.new("UIGradient", Frame4).Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(198, 200, 197)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})

			local TextLabel3 = Instance.new("TextLabel", Frame2)

			TextLabel3.Size = UDim2.new(1, 0, 0, 20)
			TextLabel3.Position = UDim2.new(0, 0, 1, 5)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Font = Enum.Font.GothamBold
			TextLabel3.TextSize = 16
			TextLabel3.TextColor3 = Color3.new(1, 1, 1)
			TextLabel3.Text = "Tools: 0"
			TextLabel3.ZIndex = 5

			local function v752()
				local n35 = 0

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							n35 += 1
						end
					end
				end

				return n35
			end

			local v758 = n34

			local function v759()
				local n36 = 0

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							n36 += 1
						end
					end
				end

				return n36
			end
			local function v765(p107)
				for i = 1, 100 do
					Frame4.Size = UDim2.new(i / 100, 0, 1, 0)

					local v767 = "/" .. v758

					TextLabel3.Text = "Tools: " .. v759() .. v767
					task.wait(0.03)
				end

				p107()
			end

			v765(function()
				local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
				local Position = HumanoidRootPart.Position

				local function v770(p108)
					HumanoidRootPart.CFrame = CFrame.new(p108)
				end

				LocalPlayer2.Character:FindFirstChildOfClass("Humanoid").Sit = false
				v770(Vector3.new(430, -108, 100))
				task.wait(0.5)

				local ClickDetector = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_DayCare").Tools:WaitForChild("FireX"):WaitForChild("ClickDetector")

				repeat
					fireclickdetector(ClickDetector)

					local v772 = "/" .. v758

					TextLabel3.Text = "Tools: " .. v759() + 1 .. v772
					task.wait()
				until v758 <= v759()

				task.wait(1)

				local t55 = {}

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(t55, child)
						end
					end
				end

				if v758 > #t55 then
					warn("Not enough tools, required: " .. v758 .. ", Found: " .. #t55)
					getgenv()._Running = false

					return
				end

				for _, child in ipairs(LocalPlayer2.Character:GetChildren()) do
					if child:IsA("Tool") then
						child.Parent = LocalPlayer2.Backpack
					end
				end

				task.wait(0.2)

				local t56 = {}
				local vector3 = Vector3.new(0, -10, 0)
				local vector32 = Vector3.new(1.5, 1.5, 0)
				local v783 = math.floor(math.sqrt(v758))
				local n37 = 1

				for i = 1, math.ceil(v758 / v783) do
					for i2 = 1, v783 do
						local v787 = t55[n37]

						if v787 then
							t56[v787] = CFrame.new(vector3.X + (i2 - 1) * vector32.X, vector3.Y + (i - 1) * vector32.Y, vector3.Z)
							n37 += 1
						end
					end
				end

				LocalPlayer2.Character:FindFirstChildOfClass("Humanoid").Sit = false
				v770(Position)
				task.wait(3)

				for k, v in pairs(t56) do
					k.Grip = v
				end

				task.wait(3)

				for i = 1, v758 do
					if t55[i] then
						t55[i].Parent = LocalPlayer2.Character
					end
				end

				ScreenGui:Destroy()
				getgenv()._Running = false
			end)
		end
	})
	t3.TT:AddSection({ t1:traduzir("Crie Um Tornado de tools") })

	local n38 = 50

	t3.TT:AddDropdown({
		Name = "Tamanho do Tornado",
		Description = "Escolha quantas ferramentas formarão o tornado",
		Options = {
			"25",
			"50",
			"75",
			"100",
			"150",
			"200"
		},
		Default = "Value",
		Flag = "TornadoSize",
		Callback = function(p109)
			n38 = tonumber(p109)
		end
	})
	t3.TT:AddButton({
		Name = "Criar Tornado",
		Callback = function()
			if getgenv()._Running then
				warn("A process is already running")

				return
			end

			getgenv()._Running = true

			local Players2 = game:GetService("Players")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local CoreGui = game:GetService("CoreGui")
			local RunService2 = game:GetService("RunService")
			local LocalPlayer2 = Players2.LocalPlayer

			ReplicatedStorage2.RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllTools")

			if CoreGui:FindFirstChild("LoadingUI") then
				return
			end

			local ScreenGui = Instance.new("ScreenGui", CoreGui)

			ScreenGui.Name = "LoadingUI"
			ScreenGui.IgnoreGuiInset = true
			ScreenGui.DisplayOrder = 999999
			ScreenGui.ResetOnSpawn = false
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			local Frame = Instance.new("Frame")

			Frame.Size = UDim2.new(0, 200, 0, 40)
			Frame.Position = UDim2.new(0, 10, 0, 10)
			Frame.BackgroundTransparency = 1
			Frame.ZIndex = 5
			Frame.Parent = ScreenGui

			local ImageLabel = Instance.new("ImageLabel")

			ImageLabel.Size = UDim2.new(0, 30, 0, 30)
			ImageLabel.Position = UDim2.new(0, 0, 0.5, -15)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Image = "rbxassetid://72495850369898"
			ImageLabel.ZIndex = 5
			ImageLabel.Parent = Frame

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Size = UDim2.new(1, -35, 1, 0)
			TextLabel.Position = UDim2.new(0, 35, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = "Flow Hub"
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextSize = 20
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.ZIndex = 5
			TextLabel.Parent = Frame

			local ImageLabel2 = Instance.new("ImageLabel", ScreenGui)

			ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
			ImageLabel2.Position = UDim2.new(0, 0, 0, 0)
			ImageLabel2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			ImageLabel2.BorderSizePixel = 0
			ImageLabel2.Image = "rbxassetid://79888503709168"
			ImageLabel2.ImageTransparency = 0
			ImageLabel2.ScaleType = Enum.ScaleType.Stretch
			ImageLabel2.ZIndex = 0

			local TextButton = Instance.new("TextButton", ScreenGui)

			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Position = UDim2.new(0, 0, 0, 0)
			TextButton.BackgroundTransparency = 1
			TextButton.BorderSizePixel = 0
			TextButton.Text = ""
			TextButton.Modal = true
			TextButton.AutoButtonColor = false
			TextButton.ZIndex = 1

			local Frame2 = Instance.new("Frame", ScreenGui)

			Frame2.Size = UDim2.new(0, 400, 0, 60)
			Frame2.Position = UDim2.new(0.5, -200, 0.5, -30)
			Frame2.BackgroundTransparency = 1
			Frame2.ZIndex = 5

			local TextLabel2 = Instance.new("TextLabel", Frame2)

			TextLabel2.Size = UDim2.new(1, 0, 0, 30)
			TextLabel2.Position = UDim2.new(0, 0, 0, 0)
			TextLabel2.Text = "Loading..."
			TextLabel2.Font = Enum.Font.GothamBold
			TextLabel2.TextSize = 20
			TextLabel2.TextColor3 = Color3.new(1, 1, 1)
			TextLabel2.BackgroundTransparency = 1
			TextLabel2.ZIndex = 5

			local Frame3 = Instance.new("Frame", Frame2)

			Frame3.Size = UDim2.new(1, 0, 0, 20)
			Frame3.Position = UDim2.new(0, 0, 1, -20)
			Frame3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Frame3.BorderSizePixel = 0
			Frame3.ClipsDescendants = true
			Frame3.ZIndex = 5
			Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 10)

			local Frame4 = Instance.new("Frame", Frame3)

			Frame4.Size = UDim2.new(0, 0, 1, 0)
			Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame4.BorderSizePixel = 0
			Frame4.ZIndex = 5
			Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 10)
			Instance.new("UIGradient", Frame4).Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(198, 200, 197)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})

			local TextLabel3 = Instance.new("TextLabel", Frame2)

			TextLabel3.Size = UDim2.new(1, 0, 0, 20)
			TextLabel3.Position = UDim2.new(0, 0, 1, 5)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Font = Enum.Font.GothamBold
			TextLabel3.TextSize = 16
			TextLabel3.TextColor3 = Color3.new(1, 1, 1)
			TextLabel3.Text = "Tools: 0"
			TextLabel3.ZIndex = 5

			local function v808()
				local n39 = 0

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							n39 += 1
						end
					end
				end

				return n39
			end

			local v814 = n38

			local function v815()
				local n40 = 0

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							n40 += 1
						end
					end
				end

				return n40
			end
			local function v821(p110)
				for i = 1, 100 do
					Frame4.Size = UDim2.new(i / 100, 0, 1, 0)

					local v823 = "/" .. v814

					TextLabel3.Text = "Tools: " .. v815() .. v823
					task.wait(0.03)
				end

				p110()
			end

			v821(function()
				local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
				local Position = HumanoidRootPart.Position

				local function v826(p111)
					HumanoidRootPart.CFrame = CFrame.new(p111)
				end

				LocalPlayer2.Character:FindFirstChildOfClass("Humanoid").Sit = false
				v826(Vector3.new(430, -108, 100))
				task.wait(0.5)

				local ClickDetector = workspace:WaitForChild("WorkspaceCom"):WaitForChild("001_DayCare").Tools:WaitForChild("FireX"):WaitForChild("ClickDetector")

				repeat
					fireclickdetector(ClickDetector)

					local v828 = "/" .. v814

					TextLabel3.Text = "Tools: " .. v815() + 1 .. v828
					task.wait()
				until v814 <= v815()

				task.wait(1)

				local t57 = {}

				for _, v in ipairs({
					LocalPlayer2.Backpack,
					LocalPlayer2.Character
				}) do
					for _, child in ipairs(v:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(t57, child)
						end
					end
				end

				if v814 > #t57 then
					warn("Not enough tools, required: " .. v814 .. ", Found: " .. #t57)
					getgenv()._Running = false

					return
				end

				for _, child in ipairs(LocalPlayer2.Character:GetChildren()) do
					if child:IsA("Tool") then
						child.Parent = LocalPlayer2.Backpack
					end
				end

				task.wait(0.2)

				local vector3 = Vector3.new(0, -5, 0)
				local v837 = 6.2831853071795862 / v814
				local t58 = {}

				for i, v in ipairs(t57) do
					if i <= v814 then
						local v841 = (i - 1) * v837

						t58[v] = CFrame.new(vector3.X + 8 * math.cos(v841), vector3.Y, vector3.Z + 8 * math.sin(v841)) * CFrame.Angles(0, v841 + 1.5707963267948966, 0)
					end
				end

				LocalPlayer2.Character:FindFirstChildOfClass("Humanoid").Sit = false
				v826(Position)
				task.wait(3)

				for k, v in pairs(t58) do
					k.Grip = v
				end

				task.wait(3)

				for i = 1, v814 do
					if t57[i] then
						t57[i].Parent = LocalPlayer2.Character
					end
				end

				ScreenGui:Destroy()

				local n41 = 0
				local n42 = 0
				local connection = RunService2.Heartbeat:Connect(function(dt)
					n41 += 20 * dt
					n42 += 40 * dt

					if HumanoidRootPart.Parent then
						HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(40 * dt), 0)
					end

					for i, v in ipairs(t57) do
						if i <= v814 and v.Parent == LocalPlayer2.Character then
							local v850 = (i - 1) * v837 + n41

							v.Grip = CFrame.new(vector3.X + 8 * math.cos(v850), vector3.Y, vector3.Z + 8 * math.sin(v850)) * CFrame.Angles(0, v850 + 1.5707963267948966, 0)
						end
					end
				end)
				local connection2 = RunService2.Heartbeat:Connect(function()
					if LocalPlayer2.Character then
						if LocalPlayer2.Character:FindFirstChild("FireX") then
							LocalPlayer2.Character:WaitForChild("FireX"):WaitForChild("ToolSound"):FireServer(unpack({
								"FireX",
								"On"
							}))
						end
					end
				end)

				LocalPlayer2.CharacterRemoving:Connect(function()
					if connection then
						connection:Disconnect()
					end

					if connection2 then
						connection2:Disconnect()
					end
				end)
				getgenv()._Running = false
				getgenv()._CircleRotation = connection
				getgenv()._FireRemote = connection2
			end)
		end
	})
	t3.TT:AddButton({
		Name = "Stop Function",
		Callback = function()
			if getgenv()._CircleRotation then
				getgenv()._CircleRotation:Disconnect()
				getgenv()._CircleRotation = nil
			end

			if getgenv()._FireRemote then
				getgenv()._FireRemote:Disconnect()
				getgenv()._FireRemote = nil
			end

			getgenv()._Running = false
			warn("Tornado interrompido com sucesso.")
		end
	})
	t3.CFG:AddSection({ t1:traduzir("Notificações Mapa") })

	local t59 = {
		joinLeaveEnabled = false,
		deathEnabled = false
	}

	local function v853(p112, p113)
		lib:Notify({
			Title = p112,
			Description = p113,
			Type = "Error",
			Duration = 5
		})
	end
	local function v854(p114)
		p114.CharacterAdded:Connect(function(character_)
			local Humanoid_ = character_:WaitForChild("Humanoid", 5)

			if Humanoid_ then
				Humanoid_.Died:Connect(function()
					if t59.deathEnabled then
						v853("Jogador Morreu", p114.Name .. " " .. lib:T("morreu"), 3)
					end
				end)
			end
		end)

		if p114.Character then
			local Humanoid_ = p114.Character:FindFirstChild("Humanoid")

			if Humanoid_ then
				Humanoid_.Died:Connect(function()
					if t59.deathEnabled then
						v853("Jogador Morreu", p114.Name .. " " .. lib:T("morreu"), 3)
					end
				end)
			end
		end
	end

	t3.CFG:AddToggle({
		Name = t1:traduzir("Notificação: Entrada/Saída"),
		Description = t1:traduzir("Notifica quando jogadores entram ou saem"),
		Default = false,
		Callback = function(p115)
			t59.joinLeaveEnabled = p115
		end
	})
	t3.CFG:AddToggle({
		Name = t1:traduzir("Notificação De Morte"),
		Description = t1:traduzir("Mostra quando um jogador morre"),
		Default = false,
		Callback = function(p116)
			t59.deathEnabled = p116
		end
	})
	Players.PlayerAdded:Connect(function(player)
		if t59.joinLeaveEnabled then
			v853("Jogador Entrou", player.Name .. " " .. lib:T("entrou no jogo"), 5)
		end

		v854(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		if t59.joinLeaveEnabled then
			v853("Jogador Saiu", player.Name .. " " .. lib:T("saiu do jogo"), 5)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		v854(player)
	end

	local Players2 = workspace:FindFirstChild("Players")

	if Players2 then
		Players2.ChildAdded:Connect(function(child)
			if t59.joinLeaveEnabled then
				v853("Entrou na Workspace", child.Name .. " " .. lib:T("entrou na Workspace.Players"), 5)
			end
		end)
		Players2.ChildRemoved:Connect(function(child)
			if t59.joinLeaveEnabled then
				v853("Saiu da Workspace", child.Name .. " " .. lib:T("saiu da Workspace.Players"), 5)
			end
		end)
	end

	t3.JJ:AddSection({ t1:traduzir("Voo & Equipe All") })
	t3.JJ:AddButton({
		t1:traduzir("Fly Chip"),
		function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/realgengar/scripts/refs/heads/main/Fly.Lua", true))()
		end
	})
	t3.JJ:AddButton({
		t1:traduzir("Equipa Todos Items"),
		function()
			local LocalPlayer2 = game.Players.LocalPlayer
			local Backpack = LocalPlayer2:WaitForChild("Backpack")

			for _, child in ipairs(Backpack:GetChildren()) do
				child.Parent = LocalPlayer2.Character
			end
		end
	})
	RunService.Stepped:Connect(updateNoClip)
	UserInputService.JumpRequest:Connect(onJumpRequest)
	t3.Tp:AddSection({ t1:traduzir("Teleporte") })

	local t60 = {
		chasingplayer = nil,
		teleportEnabled = false,
		cameraConnection = nil
	}

	local function v865()
		local t61 = {}

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				table.insert(t61, player.Name)
			end
		end

		return t61
	end
	local function v869()
		if t60.chasingplayer and t60.teleportEnabled then
			local v870 = Players:FindFirstChild(t60.chasingplayer)

			if v870 and v870.Character and LocalPlayer.Character then
				local HumanoidRootPart = v870.Character:FindFirstChild("HumanoidRootPart")
				local HumanoidRootPart2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart and HumanoidRootPart2 then
					HumanoidRootPart2.CFrame = HumanoidRootPart.CFrame
				end
			end
		end
	end
	local function v873()
		if not t60.chasingplayer then
			return
		end

		local v874 = Players:FindFirstChild(t60.chasingplayer)

		if not v874 or not v874.Character then
			return
		end

		local HumanoidRootPart = v874.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local Vehicles = workspace:FindFirstChild("Vehicles")

		if Vehicles then
			for _, child in ipairs(Vehicles:GetChildren()) do
				local Owner = child:FindFirstChild("Owner")

				if Owner and Owner.Value == LocalPlayer.Name then
					child:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)

					break
				end
			end
		end
	end
	local function v880(p117)
		if p117 and t60.chasingplayer then
			local v881 = Players:FindFirstChild(t60.chasingplayer)

			if v881 and v881.Character then
				local Humanoid_ = v881.Character:FindFirstChild("Humanoid")

				if Humanoid_ then
					workspace.CurrentCamera.CameraSubject = Humanoid_
				end
			end
		elseif LocalPlayer.Character then
			local Humanoid_ = LocalPlayer.Character:FindFirstChild("Humanoid")

			if Humanoid_ then
				workspace.CurrentCamera.CameraSubject = Humanoid_
			end
		end
	end

	t3.Tp:AddDropdown({
		Name = t1:traduzir("Escolher Um Jogador"),
		Description = t1:traduzir("Selecione um jogador para usar as funções"),
		Players = "tp",
		Options = v865(),
		Default = "Players",
		Callback = function(p118)
			t60.chasingplayer = p118

			if t60.teleportEnabled then
				v869()
			end
		end
	})
	t3.Tp:AddButton({
		t1:traduzir("Teleportar Com Carro"),
		function()
			v873()
		end
	})
	t3.Tp:AddToggle({
		Name = t1:traduzir("Teleporte Automático"),
		Player = "tp",
		Description = t1:traduzir("Teleporta instantaneamente para o jogador"),
		Default = false,
		Callback = function(p119)
			t60.teleportEnabled = p119

			if p119 then
				v869()
			end
		end
	})
	t3.Tp:AddToggle({
		Name = t1:traduzir("Visualizar Jogador"),
		Player = "tp",
		Description = t1:traduzir("Acompanha o jogador com a câmera"),
		Default = false,
		Callback = function(p120)
			if not p120 then
				if t60.cameraConnection then
					t60.cameraConnection:Disconnect()
					t60.cameraConnection = nil
				end

				v880(false)
			elseif not t60.cameraConnection then
				t60.cameraConnection = RunService.Heartbeat:Connect(function()
					v880(true)
				end)
			end
		end
	})
	t3.JJ:AddSection({ t1:traduzir("Menu Esp") })

	local t62 = {
		showLine = false,
		showHealth = false,
		showName = false,
		showDistance = false,
		drawings = {},
		healthColors = {
			Color3.fromRGB(255, 0, 0),
			Color3.fromRGB(0, 255, 0),
			Color3.fromRGB(0, 0, 255),
			Color3.fromRGB(255, 255, 0),
			Color3.fromRGB(255, 0, 255),
			Color3.fromRGB(0, 255, 255),
			Color3.fromRGB(255, 128, 0)
		},
		healthColorIndex = 1
	}

	local function v885()
		for _, drawing in pairs(t62.drawings) do
			if drawing and drawing.Remove then
				drawing:Remove()
			end
		end

		t62.drawings = {}
	end
	local function v888(p121)
		if p121 == LocalPlayer then
			return
		end

		local Character_ = p121.Character

		if not Character_ then
			return
		end

		local Head = Character_:FindFirstChild("Head")
		local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

		if Head then
			if HumanoidRootPart then
				local v892, v893 = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)

				if not v893 then
					return
				end

				local vector2 = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)

				if t62.showLine then
					local Line = Drawing.new("Line")

					Line.From = vector2
					Line.To = Vector2.new(v892.X, v892.Y)
					Line.Color = Color3.new(1, 1, 1)
					Line.Thickness = 2
					Line.Transparency = 1
					Line.Visible = true
					table.insert(t62.drawings, Line)
				end

				if t62.showHealth then
					local Square = Drawing.new("Square")

					Square.Size = Vector2.new(4, 35)
					Square.Position = Vector2.new(v892.X - 30, v892.Y - 17.5)
					Square.Color = t62.healthColors[t62.healthColorIndex]
					Square.Filled = true
					Square.Transparency = 1
					Square.Visible = true
					table.insert(t62.drawings, Square)
				end

				if t62.showName then
					local Text = Drawing.new("Text")

					Text.Text = p121.DisplayName
					Text.Position = Vector2.new(v892.X, v892.Y - 25)
					Text.Color = Color3.fromRGB(255, 255, 255)
					Text.Center = true
					Text.Size = 18
					Text.Outline = true
					Text.Visible = true
					table.insert(t62.drawings, Text)
				end

				if t62.showDistance then
					local v898 = math.floor((workspace.CurrentCamera.CFrame.Position - Head.Position).Magnitude)
					local Text = Drawing.new("Text")

					Text.Text = v898 .. "m"
					Text.Position = Vector2.new(v892.X, v892.Y + 25)
					Text.Color = Color3.fromRGB(0, 255, 255)
					Text.Center = true
					Text.Size = 16
					Text.Outline = true
					Text.Visible = true
					table.insert(t62.drawings, Text)
				end

				return
			end
		end
	end

	RunService.RenderStepped:Connect(function()
		v885()

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				if player.Character:FindFirstChild("Head") then
					v888(player)
				end
			end
		end
	end)

	for _, v in ipairs({
		{
			name = "Linhas <Esp>",
			key = "showLine",
			desc = "Mostra linhas da posição dos jogadores"
		},
		{
			name = "Vida <Esp>",
			key = "showHealth",
			desc = "Mostra a vida dos jogadores"
		},
		{
			name = "Nome <Esp>",
			key = "showName",
			desc = "Mostra os nomes dos jogadores no mapa"
		},
		{
			name = "Distância <Esp>",
			key = "showDistance",
			desc = "Mostra as distâncias dos jogadores"
		}
	}) do
		t3.JJ:AddToggle({
			Name = v.name,
			Description = v.desc,
			Default = false,
			Callback = function(p122)
				t62[v.key] = p122
			end
		})
	end
end)
task.spawn(function()
	task.wait(10)
	t3.TT:AddSection({ "pirate" })

	local u904 = false
	local n43 = 60
	local u906

	t3.TT:AddSlider({
		Name = t1:traduzir("Velocidade da Rotação"),
		Min = 1,
		Max = 120,
		Increase = 1,
		Default = n43,
		Callback = function(p123)
			n43 = p123
		end
	})

	local t63 = {}
	local Players2 = game:GetService("Players")

	for _, player in ipairs(Players2:GetPlayers()) do
		table.insert(t63, player.Name)
	end

	local v911 = t3.TT:AddDropdown({
		Name = t1:traduzir("Selecionar Jogador"),
		Description = t1:traduzir("Escolha o jogador alvo do barco pirata"),
		Players = "pirate",
		OnLeft = function(n) if u904 then u904 = false; Flow.LeftNotice(n) end end,
		Options = t63,
		Default = "",
		Callback = function(p124)
			u906 = p124
		end
	})

	game:GetService("Players").PlayerAdded:Connect(function()
		t63 = {}

		local Players3 = game:GetService("Players")

		for _, player in ipairs(Players3:GetPlayers()) do
			table.insert(t63, player.Name)
		end

		v911:SetOptions(t63)
	end)
	game:GetService("Players").PlayerRemoving:Connect(function()
		t63 = {}

		local Players3 = game:GetService("Players")

		for _, player in ipairs(Players3:GetPlayers()) do
			table.insert(t63, player.Name)
		end

		v911:SetOptions(t63)
	end)
	t3.TT:AddButton({
		Name = t1:traduzir("Bring Boat Pirate"),
		Description = t1:traduzir("Spawna o barco pirata e persegue o jogador selecionado"),
		Callback = function()
			if u904 then
				return
			end

			if not u906 then
				return
			end

			u904 = true

			local Players3 = game:GetService("Players")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local RunService2 = game:GetService("RunService")
			local LocalPlayer2 = Players3.LocalPlayer
			local Character_ = LocalPlayer2.Character

			if not Character_ then
				u904 = false

				return
			end

			local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

			if not Humanoid_ or not HumanoidRootPart then
				u904 = false

				return
			end

			local v925 = Players3:FindFirstChild(u906)

			if not v925 or not v925.Character then
				u904 = false

				return
			end

			local Humanoid_2 = v925.Character:FindFirstChild("Humanoid")
			local HumanoidRootPart2 = v925.Character:FindFirstChild("HumanoidRootPart")

			if not Humanoid_2 or not HumanoidRootPart2 then
				u904 = false

				return
			end

			local Vehicles = workspace:WaitForChild("Vehicles")

			HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
			task.wait(0.5)
			ReplicatedStorage2:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer("PickingBoat", "PirateFree")
			task.wait(1)

			local v929 = Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car")

			if not v929 then
				u904 = false

				return
			end

			local VehicleSeat = v929:FindFirstChild("Body") and v929.Body:FindFirstChild("VehicleSeat")

			if not VehicleSeat then
				u904 = false

				return
			end

			while true do
				HumanoidRootPart.CFrame = VehicleSeat.CFrame * CFrame.new(0, 1, 0)
				task.wait()

				if Humanoid_.SeatPart == VehicleSeat then
					break
				elseif not u904 then
					break
				end
			end

			if not u904 then
				return
			end

			Humanoid_.Sit = true
			task.wait(0.2)

			local connection

			connection = RunService2.Heartbeat:Connect(function()
				if not u904 then
					connection:Disconnect()

					return
				end

				if Humanoid_.SeatPart ~= VehicleSeat then
					u904 = false
					connection:Disconnect()
					Humanoid_:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
			task.spawn(function()
				local n44 = 0
				local t64 = {
					Vector3.new(1.5, 0, 0),
					Vector3.new(-1.5, 0, 0),
					Vector3.new(0, 0, 1.5),
					Vector3.new(0, 0, -1.5),
					Vector3.new(0, 2, 0),
					Vector3.new(0, -2, 0),
					Vector3.new(2, 1, 2),
					Vector3.new(-2, 1, -2),
					Vector3.new(2, -2, 2),
					Vector3.new(-2, -2, -2),
					Vector3.new(0, 3, 1),
					Vector3.new(0, -3, -1),
					Vector3.new(1, 2, -2),
					Vector3.new(-1, -2, 2),
					Vector3.new(3, 0, 1),
					Vector3.new(-3, 0, -1),
					Vector3.new(1.2, -3.2, 1.2),
					Vector3.new(-1.2, -3.2, -1.2)
				}

				while u904 and v925.Character and HumanoidRootPart2 and Humanoid_.SeatPart == VehicleSeat do
					local Position = HumanoidRootPart2.Position

					n44 += math.rad(n43)

					for _, v in ipairs(t64) do
						if not u904 then
							break
						end

						HumanoidRootPart.CFrame = CFrame.new(Position + v, Position) * CFrame.Angles(n44, n44, n44)
						task.wait(0.005)
					end
				end
			end)
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Parar Boat Pirate"),
		Description = t1:traduzir("Para o barco pirata imediatamente"),
		Callback = function()
			u904 = false

			local Character_ = game.Players.LocalPlayer.Character

			if Character_ then
				local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")

				if Humanoid_ then
					Humanoid_:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end
	})

	local u939
	local s4 = "HumanoidRootPart"

	getgenv().Target = nil
	getgenv().CameraConnection = nil
	getgenv().RunService = nil
	getgenv().flingloop = false

	local t65 = {
		[t1:traduzir("Cabeça")] = "Head",
		[t1:traduzir("Peito Superior")] = "UpperTorso",
		[t1:traduzir("Barriga Inferior")] = "LowerTorso",
		[t1:traduzir("Frente do Corpo")] = "HumanoidRootPart",
		[t1:traduzir("Frente")] = "HumanoidRootPart",
		[t1:traduzir("Traseiro")] = "HumanoidRootPart"
	}

	t3.TT:AddSection({
		Name = t1:traduzir("Pirralhos Trolagem <filho>")
	})

	local v942 = t3.TT:AddDropdown({
		Name = t1:traduzir("Escolher Jogador"),
		Description = t1:traduzir("Selecione quem o pirralho irá seguir"),
		Players = "kid",
		Options = t2,
		Default = "Boneco",
		Callback = function(p125)
			u939 = game.Players:FindFirstChild(p125) and p125 or nil
		end
	})

	t3.TT:AddDropdown({
		Name = t1:traduzir("Selecionar Nome RP"),
		Description = t1:traduzir("Escolha Uma Tag para o pirralho"),
		Options = {
			"oi kkkk",
			"Sou Seu filho",
			"Armaria",
			"Tenho Dono: Lucas",
			"Estoy loco",
			"XALALALAL",
			"ANALFABETO",
			"Criança",
			"Web namoro",
			"Veia",
			"FLOW HUB",
			"KITA!!!!",
			"MÃEEEE",
			"PAIII",
			"BANCOPAN",
			"Calada",
			"Tenho Dona: Lolyta",
			"Uso Hack"
		},
		Default = "Nome",
		Callback = function(p126)
			local RE = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("1RPNam1eTex1t")

			if RE then
				RE:FireServer("RolePlayFollow", p126)
			end
		end
	})
	t3.TT:AddDropdown({
		Name = t1:traduzir("Parte do Corpo"),
		Description = "Onde o pirralho ficará preso no corpo",
		Options = {
			t1:traduzir("Cabeça"),
			t1:traduzir("Peito Superior"),
			t1:traduzir("Barriga Inferior"),
			t1:traduzir("Frente do Corpo"),
			t1:traduzir("Frente"),
			t1:traduzir("Traseiro")
		},
		Default = t1:traduzir("Partes"),
		Callback = function(p127)
			s4 = t65[p127] or "HumanoidRootPart"
		end
	})
	t3.TT:AddToggle({
		Name = t1:traduzir("Visualizar Jogador"),
		Player = "kid",
		Default = false,
		Callback = function(p128)
			local function v944()
				local v945 = p128 and Players:FindFirstChild(u939)
				local Humanoid_ = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")

				if v945 and v945.Character then
					Humanoid_ = v945.Character:FindFirstChild("Humanoid")
				end

				if Humanoid_ then
					workspace.CurrentCamera.CameraSubject = Humanoid_
				end
			end

			if not p128 then
				if getgenv().CameraConnection then
					getgenv().CameraConnection:Disconnect()
					getgenv().CameraConnection = nil
				end

				v944()
			elseif not getgenv().CameraConnection then
				getgenv().CameraConnection = RunService.Heartbeat:Connect(v944)
			end
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Atualizar Jogadores"),
		Callback = function()
			local t66 = {}

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer then
					table.insert(t66, player.Name)
				end
			end

			v942:Set(t66)
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Enviar Pirralho"),
		Callback = function()
			if not u939 then
				return
			end

			local v950 = workspace:FindFirstChild(u939)

			if not v950 then
				return
			end

			local v951 = LocalPlayer
			local ok = not workspace:FindFirstChild(v951.Name)

			if not ok then
				ok = not workspace[v951.Name]:FindFirstChild("FollowCharacter")
			end

			if ok then
				ReplicatedStorage.RE:FindFirstChild("1Bab1yFollo1w"):FireServer("CharacterFollowSpawnPlayer", "BabyBoy")
				task.wait(0.3)
			end

			local FollowCharacter = workspace[v951.Name] and workspace[v951.Name]:FindFirstChild("FollowCharacter")
			local v954 = v950:FindFirstChild(s4)

			if FollowCharacter and v954 then
				FollowCharacter.Parent = v950

				if getgenv().RunService then
					getgenv().RunService:Disconnect()
				end

				getgenv().RunService = RunService.Heartbeat:Connect(function()
					if FollowCharacter and FollowCharacter:FindFirstChild("Torso") then
						FollowCharacter.Torso.BodyPosition.Position = v954.Position
						FollowCharacter.Torso.BodyGyro.CFrame = v954.CFrame
					end
				end)
			else
				warn("A parte '" .. s4 .. "' não existe no jogador alvo.")
			end
		end
	})
	t3.Carros:AddSection({ t1:traduzir("Seção Kill Car") })

	local u955
	local u956 = false
	local u957 = false

	local function v958()
		while u956 and u955 do
			local LocalPlayer2 = game.Players.LocalPlayer
			local Character_ = LocalPlayer2.Character
			local HumanoidRootPart = Character_ and Character_:FindFirstChild("HumanoidRootPart")
			local Vehicles = game.Workspace:FindFirstChild("Vehicles")
			local v963 = Vehicles and Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car")

			if not v963 then
				if HumanoidRootPart then
					HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
					task.wait(0.5)
					game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
					task.wait(0.5)
					v963 = Vehicles and Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car")
				end
			end

			if v963 and u955 then
				local Character_2 = u955.Character
				local HumanoidRootPart2 = Character_2 and Character_2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					v963:SetPrimaryPartCFrame(HumanoidRootPart2.CFrame * CFrame.new(0, 0, -5))

					local BodyVelocity = Instance.new("BodyVelocity")

					BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
					BodyVelocity.Velocity = Vector3.new(500, 200, 500)
					BodyVelocity.Parent = v963.PrimaryPart

					local BodyAngularVelocity = Instance.new("BodyAngularVelocity")

					BodyAngularVelocity.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
					BodyAngularVelocity.AngularVelocity = Vector3.new(0, 200, 0)
					BodyAngularVelocity.Parent = v963.PrimaryPart
					task.wait(0.3)
					BodyVelocity:Destroy()
					BodyAngularVelocity:Destroy()
				end
			end

			task.wait(0.05)
		end
	end
	local function v968()
		local LocalPlayer2 = game.Players.LocalPlayer

		while u957 and u955 do
			local Character_ = u955.Character

			if Character_ then
				local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					workspace.CurrentCamera.CameraSubject = HumanoidRootPart
				end
			end

			task.wait(0.1)
		end

		if LocalPlayer2.Character then
			workspace.CurrentCamera.CameraSubject = LocalPlayer2.Character:FindFirstChild("Humanoid")
		end
	end

	local v972 = t3.Carros:AddDropdown({
		Name = t1:traduzir("Escolha um jogador"),
		Description = t1:traduzir("Selecionar um jogador pra funcionar as funções"),
		Players = "fling",
		OnLeft = function(n) if u956 then u956 = false; Flow.LeftNotice(n) end end,
		Options = {},
		Default = "Players",
		Callback = function(p129)
			u955 = game.Players:FindFirstChild(p129)
		end
	})

	t3.Carros:AddToggle({
		Name = t1:traduzir("Visualizar Jogador"),
		Description = t1:traduzir("Olha jogador de longe qualquer lugar"),
		Player = "fling",
		Default = false
	}):Callback(function(p130)
		u957 = p130
		v968()
	end)
	t3.Carros:AddButton({
		t1:traduzir("Atualizar"),
		function()
			local t67 = {}

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer then
					table.insert(t67, player.Name)
				end
			end

			v972:Set(t67)
		end
	})
	t3.Carros:AddButton({
		t1:traduzir("Inícia Fling"),
		function()
			if u955 then
				u956 = true
				v958()
			end
		end
	})
	t3.Carros:AddButton({
		t1:traduzir("Parar Fling"),
		function()
			u956 = false
		end
	})
	t3.Carros:AddParagraph({
		Title = "Aviso < ⚠️ >",
		Text = "Recomendo Entra no Carro Antes de usa!\nPara Rapidez e eficiência do fling"
	})
	t3.TT:AddSection({ "Method Variados" })

	local u976 = false
	local u977
	local t68
	local connection

	local function v980()
		local Character_ = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local SoccerBall = Character_:FindFirstChild("SoccerBall") or LocalPlayer.Backpack:FindFirstChild("SoccerBall")

		if not SoccerBall then
			return false
		end

		SoccerBall.Parent = Character_

		return true
	end

	t3.TT:AddButton({
		"Ball Orbiting v4 ( da dois clicks )",
		function()
			if u976 then
				return
			end

			if not v980() then
				return
			end

			task.wait(0.5)

			local Character_ = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			local WorkspaceCom = Workspace:FindFirstChild("WorkspaceCom")
			local v986 = WorkspaceCom and WorkspaceCom:FindFirstChild("001_SoccerBalls")

			u977 = v986 and v986:FindFirstChild("Soccer" .. LocalPlayer.Name)

			if not u977 then
				return
			end

			t68 = {
				Anchored = u977.Anchored,
				CanCollide = u977.CanCollide,
				CanTouch = u977.CanTouch
			}
			u977.Anchored = false
			u977.CanCollide = true
			u977.CanTouch = true
			pcall(function()
				u977:SetNetworkOwner(nil)
			end)
			u976 = true
			connection = RunService.Heartbeat:Connect(function()
				if u976 and u977 and u977.Parent and HumanoidRootPart then
					if HumanoidRootPart.Parent and Character_ and Character_.Parent then
						local v987 = tick() * 10

						u977.CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(math.cos(v987) * 3, -1, math.sin(v987) * 3))
						u977.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)

						return
					end
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				u976 = false

				if u977 and t68 then
					u977.Anchored = t68.Anchored
					u977.CanCollide = t68.CanCollide
					u977.CanTouch = t68.CanTouch
				end

				u977 = nil
				t68 = nil
			end)
		end
	})
	t3.TT:AddSection({ t1:traduzir("Funções Mata <Todos>") })
	t3.TT:AddButton({
		Name = t1:traduzir("Mata Geral De Ônibus"),
		Callback = function()
			local Players3 = game:GetService("Players")
			local Workspace2 = game:GetService("Workspace")
			local RunService2 = game:GetService("RunService")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local vector3 = Vector3.new(145.51, -374.09, 21.58)
			local CFrame_

			local function v994()
				local Vehicles = Workspace2:FindFirstChild("Vehicles")

				if Vehicles then
					return Vehicles:FindFirstChild(Players3.LocalPlayer.Name .. "Car")
				end

				return nil
			end
			local function v996(p131, p132)
				while true do
					if not p131 then
						RunService2.RenderStepped:Wait()

						continue
					end

					local v997 = Players3:FindFirstChild(p131)

					if not v997 or not v997.Character then
						RunService2.RenderStepped:Wait()

						continue
					end

					if not v997.Character:FindFirstChild("HumanoidRootPart") then
						RunService2.RenderStepped:Wait()

						continue
					end

					local Humanoid_ = v997.Character:FindFirstChildOfClass("Humanoid")

					if Humanoid_ and Humanoid_.Sit then
						break
					end

					local HumanoidRootPart = v997.Character.HumanoidRootPart
					local v1000 = tick() * 35
					local v1001 = math.sin(v1000) * 10
					local v1002 = math.cos(v1000) * 20
					local v1003 = v994()

					if v1003 then
						v1003:SetPrimaryPartCFrame(HumanoidRootPart.CFrame * CFrame.new(0, 0, v1002))
					end

					RunService2.RenderStepped:Wait()
				end

				local v1004 = v994()

				if v1004 then
					v1004:SetPrimaryPartCFrame(CFrame.new(vector3))
					task.wait(0.2)

					local function v1005()
						local Humanoid_ = Players3.LocalPlayer.Character and Players3.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")

						if Humanoid_ then
							Humanoid_:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end

					v1005()
					task.wait(0.4)
					v1005()
					task.wait(0.5)

					if CFrame_ then
						Players3.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame_
						task.wait(0.1)
						ReplicatedStorage2:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack({ "DeleteAllVehicles" }))
					end
				end

				if p132 then
					p132()
				end
			end
			local function v1007(p133, p134)
				local LocalPlayer2 = Players3.LocalPlayer
				local Character_ = LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()
				local HumanoidRootPart = Character_:WaitForChild("HumanoidRootPart")

				CFrame_ = HumanoidRootPart.CFrame

				local v1011 = v994()

				if not v1011 then
					HumanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
					task.wait(0.5)

					local RE = ReplicatedStorage2:FindFirstChild("RE")

					if RE and RE:FindFirstChild("1Ca1r") then
						RE["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
					end

					task.wait(1)
					v1011 = v994()
				end

				if v1011 then
					local VehicleSeat = v1011:FindFirstChild("Body") and v1011.Body:FindFirstChild("VehicleSeat")

					if VehicleSeat and Character_:FindFirstChildOfClass("Humanoid") and not Character_.Humanoid.Sit then
						while true do
							HumanoidRootPart.CFrame = VehicleSeat.CFrame * CFrame.new(0, 2, 0)
							task.wait()

							if Character_.Humanoid.Sit then
								break
							elseif not v1011.Parent then
								break
							end
						end
					end
				end

				spawn(function()
					v996(p133, p134)
				end)
			end
			local function v1014(p135)
				if #p135 == 0 then
					return
				end

				v1007(table.remove(p135, 1).Name, function()
					task.wait(0.5)
					v1014(p135)
				end)
			end

			v1014(Players3:GetPlayers())
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Matar Geral de Barco "),
		Callback = function()
			local LocalPlayer2 = game.Players.LocalPlayer
			local Character_ = LocalPlayer2.Character
			local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")
			local Vehicles = game.Workspace:FindFirstChild("Vehicles")
			local CFrame_ = HumanoidRootPart.CFrame
			local n45 = 0

			if not Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car") and HumanoidRootPart then
				HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
				task.wait(0.5)
				game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
				task.wait(0.5)

				local v1022 = Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car")

				task.wait(0.5)

				local VehicleSeat = v1022:FindFirstChild("Body") and v1022.Body:FindFirstChild("VehicleSeat")

				if VehicleSeat then
					repeat
						task.wait()
						HumanoidRootPart.CFrame = VehicleSeat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
					until Humanoid_.Sit
				end
			end

			task.wait(0.5)

			local v1024 = Vehicles:FindFirstChild(LocalPlayer2.Name .. "Car")

			if v1024 and not Humanoid_.Sit then
				local VehicleSeat = v1024:FindFirstChild("Body") and v1024.Body:FindFirstChild("VehicleSeat")

				if VehicleSeat then
					repeat
						task.wait()
						HumanoidRootPart.CFrame = VehicleSeat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
					until Humanoid_.Sit
				end
			end

			local BodyGyro = Instance.new("BodyGyro")

			BodyGyro.Parent = v1024.PrimaryPart
			BodyGyro.MaxTorque = Vector3.new(10000000, 10000000, 10000000)
			BodyGyro.P = 10000000
			BodyGyro.CFrame = v1024.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0)

			local function v1027(p136, p137)
				n45 = 0

				local v1028 = tick() + 1

				while tick() < v1028 do
					n45 += 100
					task.wait()

					local function v1029(p138, p139, p140)
						v1024:SetPrimaryPartCFrame(CFrame.new(p138.Position) * p139 * p140)
					end

					v1029(p137, CFrame.new(0, 3, 0), CFrame.Angles(math.rad(n45), 0, 0))
					v1029(p137, CFrame.new(0, -1.5, 2), CFrame.Angles(math.rad(n45), 0, 0))
					v1029(p137, CFrame.new(2, 1.5, 2.25), CFrame.Angles(math.rad(50), 0, 0))
					v1029(p137, CFrame.new(-2.25, -1.5, 2.25), CFrame.Angles(math.rad(30), 0, 0))
					v1029(p137, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(n45), 0, 0))
					v1029(p137, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(n45), 0, 0))
				end
			end

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= LocalPlayer2 then
					local Character_2 = player.Character
					local Humanoid_2 = Character_2 and Character_2:FindFirstChildOfClass("Humanoid")
					local HumanoidRootPart2 = Character_2 and Character_2:FindFirstChild("HumanoidRootPart")

					if Character_2 and Humanoid_2 and HumanoidRootPart2 then
						v1027(Character_2, HumanoidRootPart2, Humanoid_2)
					end
				end
			end

			task.wait(0.5)
			v1024:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
			task.wait(0.5)
			Humanoid_.Sit = false
			task.wait(0.5)
			HumanoidRootPart.CFrame = CFrame_
			BodyGyro:Destroy()
		end
	})
	t3.TT:AddButton({
		t1:traduzir("Joga bola <Todos>"),
		function()
			local Players3 = game:GetService("Players")
			local RunService2 = game:GetService("RunService")

			game:GetService("StarterGui")

			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local LocalPlayer2 = Players3.LocalPlayer
			local v1039 = "WorkspaceCom/001_SoccerBalls/Soccer" .. LocalPlayer2.Name

			getgenv().Target = nil

			local u1040
			local connection2

			local function v1042()
				ReplicatedStorage2.RE:FindFirstChild("1Clea1rTool1s"):FireServer(unpack({
					"PlayerWantsToDeleteTool",
					"SoccerBall"
				}))
				ReplicatedStorage2.RE:FindFirstChild("1Too1l"):InvokeServer(unpack({
					"PickingTools",
					"SoccerBall"
				}))

				repeat
					task.wait()
				until LocalPlayer2.Backpack:FindFirstChild("SoccerBall")

				local SoccerBall = LocalPlayer2.Backpack:FindFirstChild("SoccerBall")

				if not SoccerBall then
					return lib:Notify({
						Title = "warn",
						Description = "ball not found",
						Type = "Error",
						Duration = 4
					})
				end

				SoccerBall.Parent = LocalPlayer2.Character
				task.wait(0.25)
			end
			local function v1044(p141)
				for _, child in ipairs(p141:GetChildren()) do
					if child:IsA("BodyForce") or child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") then
						child:Destroy()
					end
				end
			end
			local function v1047(p142, p143)
				for _, descendant in ipairs(p143:GetDescendants()) do
					if descendant:IsA("BasePart") then
						local NoCollisionConstraint = Instance.new("NoCollisionConstraint")

						NoCollisionConstraint.Part0 = p142
						NoCollisionConstraint.Part1 = descendant
						NoCollisionConstraint.Parent = p142
					end
				end
			end
			local function v1051(p144)
				v1044(p144)

				local BodyForce = Instance.new("BodyForce")

				BodyForce.Force = Vector3.new(900000000, 900000000, 900000000)
				BodyForce.Parent = p144

				local BodyVelocity = Instance.new("BodyVelocity")

				BodyVelocity.Velocity = Vector3.new(900000000, 900000000, 900000000)
				BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				BodyVelocity.P = 10000000
				BodyVelocity.Parent = p144
			end
			local function v1054(p145)
				local Character_ = p145.Character or p145.CharacterAdded:Wait()
				local HumanoidRootPart = Character_:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					return
				end

				local ok, result2 = pcall(function()
					local workspace_ = workspace

					for _, part in ipairs(v1039:split("/")) do
						workspace_ = workspace_:WaitForChild(part, 5)
					end

					return workspace_
				end)

				if not ok or not result2 then
					return
				end

				u1040 = result2
				u1040.Anchored = false
				u1040.CanCollide = true
				u1040.Massless = false
				v1044(u1040)
				v1047(u1040, Character_)
				v1051(u1040)

				if connection2 then
					connection2:Disconnect()
				end

				local Position = HumanoidRootPart.Position
				local u1063 = true

				connection2 = RunService2.Heartbeat:Connect(function()
					if not u1040 or not HumanoidRootPart then
						connection2:Disconnect()

						return
					end

					local Position2 = HumanoidRootPart.Position
					local Magnitude = (Position2 - Position).Magnitude

					Position = Position2

					local v1066 = HumanoidRootPart.Position + Vector3.new(0, -0.5, 0)

					if Magnitude > 1 then
						u1040.CFrame = CFrame.new(v1066 + HumanoidRootPart.CFrame.LookVector * 10)
					else
						u1040.CFrame = CFrame.new(v1066 + Vector3.new(0, u1063 and 3 or -3, 0))
						u1063 = not u1063
					end
				end)
			end
			local function v1067(p146)
				local HumanoidRootPart = p146.Character and p146.Character:FindFirstChild("HumanoidRootPart")

				return HumanoidRootPart and math.abs(HumanoidRootPart.Velocity.Y) > 200
			end
			local function v1069()
				v1042()

				local players = Players3:GetPlayers()
				local n46 = 0

				for _, player in ipairs(players) do
					if player ~= LocalPlayer2 then
						getgenv().Target = player.Name
						v1054(player)

						local n47 = 0

						while n47 < 3 and player.Character do
							if not player.Character:FindFirstChild("Humanoid") or v1067(player) then
								break
							end

							task.wait(0.2)
							n47 += 0.2
						end

						if v1067(player) then
							n46 += 1
						end
					end
				end

				if connection2 then
					connection2:Disconnect()
				end
			end

			v1069()
		end
	})
	t3.TT:AddButton({
		t1:traduzir("Matar Geral v2 <Couch>"),
		function()
			local t69 = {
				"128703509251740",
				"132885275273014",
				"7772283448",
				"17517505567"
			}
			local Players3 = game:GetService("Players")
			local RunService2 = game:GetService("RunService")
			local t70 = {}

			local function v1079()
				local v1080 = t69[math.random(1, #t69)]
				local Sound = Instance.new("Sound")

				Sound.SoundId = "rbxassetid://" .. v1080
				Sound.Volume = 0.5
				Sound.Parent = game.Workspace
				Sound:Play()
				game:GetService("Debris"):AddItem(Sound, 10)
			end
			local function v1082(p147)
				if not p147 then
					return false
				end

				local v1083 = p147.Name:lower()

				return v1083:find("couch") or v1083:find("sofa") or v1083:find("chair") or v1083:find("seat")
			end
			local function v1084()
				RunService2.Heartbeat:Connect(function()
					for _, player in pairs(Players3:GetPlayers()) do
						if player.Character then
							local Humanoid_ = player.Character:FindFirstChildOfClass("Humanoid")

							if Humanoid_ and Humanoid_.Sit then
								local SeatPart = Humanoid_.SeatPart

								if not SeatPart or not v1082(SeatPart) then
									t70[player.UserId] = nil
								elseif not t70[player.UserId] then
									t70[player.UserId] = true
									v1079()
								end
							else
								t70[player.UserId] = nil
							end
						end
					end
				end)
			end

			v1084()
			Players3.PlayerRemoving:Connect(function(player)
				t70[player.UserId] = nil
			end)

			local function v1089()
				game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s"):FireServer(unpack({
					"PlayerWantsToDeleteTool",
					"Couch"
				}))
				task.wait(0.5)
				game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack({
					"PickingTools",
					"Couch"
				}))

				if game.Players.LocalPlayer.Backpack:FindFirstChild("Couch") then
					game.Players.LocalPlayer.Backpack.Couch.Grip = CFrame.new(0, 2, -2.5)
				end

				local function v1090()
					for _, child in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
						if child:IsA("Tool") and child.Name == "Couch" then
							child.Parent = game.Players.LocalPlayer.Character
						end
					end
				end

				v1090()
			end

			if getgenv()._FlingAllRunning then
				return
			end

			getgenv()._FlingAllRunning = true

			local LocalPlayer2 = game.Players.LocalPlayer

			LocalPlayer2:GetMouse()

			local t71 = { "all" }
			local u1095 = false

			local function v1096(p148)
				local v1097 = p148:lower()

				if v1097 == "all" or v1097 == "others" then
					u1095 = true

					return
				end

				if v1097 == "random" then
					local players = Players3:GetPlayers()

					if table.find(players, LocalPlayer2) then
						table.remove(players, table.find(players, LocalPlayer2))
					end

					return players[math.random(#players)]
				end

				if v1097 == "random" or v1097 == "all" or v1097 == "others" then
					return
				end

				local players, v1100 = Players3:GetPlayers()

				for _, v in next, players, v1100 do
					if v == LocalPlayer2 then
						continue
					end

					if v.Name:lower():match("^" .. v1097) then
						return v
					end

					if v.DisplayName:lower():match("^" .. v1097) then
						return v
					end
				end
			end
			local function v1103(p149, p150, p151)
				print(p149)
				print(p150)
				print(p151)
			end
			local function v1104(p152)
				if p152 then
					if p152.Character then
						v1089()
						task.wait(0.5)

						local Character_ = LocalPlayer2.Character

						if not Character_ then
							return
						end

						local Humanoid_ = Character_:FindFirstChildOfClass("Humanoid")
						local RootPart = Humanoid_ and Humanoid_.RootPart

						if not Humanoid_ or not RootPart then
							return
						end

						local Character_2 = p152.Character

						if not Character_2 then
							return
						end

						local Humanoid_2 = Character_2:FindFirstChildOfClass("Humanoid")
						local RootPart2 = Humanoid_2 and Humanoid_2.RootPart
						local Head = Character_2:FindFirstChild("Head")
						local Accessory = Character_2:FindFirstChildOfClass("Accessory")
						local Handle = Accessory and Accessory:FindFirstChild("Handle")

						if not Humanoid_2 or not RootPart2 then
							return
						end

						if RootPart.Velocity.Magnitude < 50 then
							getgenv().OldPos = RootPart.CFrame
						end

						if Head then
							workspace.CurrentCamera.CameraSubject = Head
						elseif Handle then
							workspace.CurrentCamera.CameraSubject = Handle
						else
							workspace.CurrentCamera.CameraSubject = Humanoid_2
						end

						if not Character_2:FindFirstChildWhichIsA("BasePart") then
							return
						end

						local function v1114(p153, p154, p155)
							if not p153 or not p153.Parent then
								return
							end

							RootPart.CFrame = CFrame.new(p153.Position) * p154 * p155
							Character_:SetPrimaryPartCFrame(CFrame.new(p153.Position) * p154 * p155)
							RootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
							RootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
						end
						local function v1115(p156)
							if not p156 or not p156.Parent then
								return
							end

							local now = tick()
							local n48 = 0

							while RootPart and Humanoid_2 and p156.Parent do
								if p156.Velocity.Magnitude < 50 then
									n48 += 100
									v1114(p156, CFrame.new(0, 1.5, 0) + Humanoid_2.MoveDirection * p156.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0) + Humanoid_2.MoveDirection * p156.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(2.25, 1.5, -2.25) + Humanoid_2.MoveDirection * p156.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(-2.25, -1.5, 2.25) + Humanoid_2.MoveDirection * p156.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, 1.5, 0) + Humanoid_2.MoveDirection, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0) + Humanoid_2.MoveDirection, CFrame.Angles(math.rad(n48), 0, 0))
									task.wait()
								else
									v1114(p156, CFrame.new(0, 1.5, Humanoid_2.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, -Humanoid_2.WalkSpeed), CFrame.Angles(0, 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, 1.5, Humanoid_2.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, -RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
									task.wait()
									v1114(p156, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
									task.wait()
								end

								if not p156.Parent or not p152 or not p152.Parent or not p152.Character or p152.Character ~= Character_2 or not Humanoid_2 or Humanoid_2.Sit or Humanoid_.Health <= 0 or now + 10 < tick() or p156.Velocity.Magnitude > 500 then
									break
								end
							end
						end

						workspace.FallenPartsDestroyHeight = (0/0)

						local BodyVelocity = Instance.new("BodyVelocity")

						BodyVelocity.Name = "EpixVel"
						BodyVelocity.Parent = RootPart
						BodyVelocity.Velocity = Vector3.new(1e9, 1e9, 1e9)
						BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						Humanoid_:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

						if not Head then
							v1115(RootPart2)
						elseif (RootPart2.CFrame.p - Head.CFrame.p).Magnitude > 5 then
							v1115(Head)
						else
							v1115(RootPart2)
						end

						if BodyVelocity then
							BodyVelocity:Destroy()
						end

						Humanoid_:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
						workspace.CurrentCamera.CameraSubject = Humanoid_

						if getgenv().OldPos then
							repeat
								RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
								Character_:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
								Humanoid_:ChangeState("GettingUp")
								table.foreach(Character_:GetChildren(), function(p157, p158)
									if p158:IsA("BasePart") then
										local vector3 = Vector3.new()
										local vector32 = Vector3.new()

										p158.Velocity = vector3
										p158.RotVelocity = vector32
									end
								end)
								task.wait()
							until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
						end

						return
					end
				end
			end

			getgenv().Welcome = true

			if not t71[1] then
				return
			end

			for _, v in next, t71, nil do
				v1096(v)
			end

			if u1095 then
				local next_ = next
				local players, v1125 = Players3:GetPlayers()

				for _, v in next_, players, v1125 do
					if v ~= LocalPlayer2 then
						v1104(v)
					end
				end
			end

			for _, v in next, t71, nil do
				if v1096(v) and v1096(v) ~= LocalPlayer2 then
					if v1096(v).UserId ~= (0/0) then
						local v1130 = v1096(v)

						if v1130 then
							v1104(v1130)
						end
					end
				end
			end

			getgenv()._FlingAllRunning = false
			workspace.FallenPartsDestroyHeight = -500
		end
	})

	local LocalPlayer2 = Players.LocalPlayer
	local CurrentCamera = Workspace.CurrentCamera
	local t72 = {
		FLING_VELOCITY = Vector3.new(900000000, 900000000, 900000000),
		MAX_FORCE = Vector3.new(math.huge, math.huge, math.huge),
		POWER = math.huge,
		MIN_FLING_SPEED = 1000,
		TIMEOUT_SECONDS = 5,
		BALL_PHYSICS = PhysicalProperties.new(0.0001, 0, 0),
		ROTATION_SPEED = Vector3.new(45, 60, 30)
	}
	local t73 = {
		adminToolEquipped = false,
		controlledDoors = {},
		blackHole = nil,
		baseAttachment = nil
	}
	local t74 = {
		safeWait = function(p159, p160)
			local now = tick()
			local v1137 = p160 or 5

			while true do
				task.wait()

				if p159() then
					break
				elseif v1137 < tick() - now then
					break
				end
			end

			return p159()
		end,
		getPlayerCharacter = function(p161)
			return p161 and p161.Character
		end,
		validateCharacter = function(p162)
			if p162 then
				return p162:FindFirstChild("HumanoidRootPart") and p162:FindFirstChild("Humanoid")
			end

			return false
		end,
		createBodyVelocity = function(p163)
			local BodyVelocity = p163:FindFirstChildWhichIsA("BodyVelocity")

			if BodyVelocity then
				BodyVelocity:Destroy()
			end

			local BodyVelocity2 = Instance.new("BodyVelocity")

			BodyVelocity2.Name = "FlingPower"
			BodyVelocity2.Velocity = t72.FLING_VELOCITY
			BodyVelocity2.MaxForce = t72.MAX_FORCE
			BodyVelocity2.P = t72.POWER
			BodyVelocity2.Parent = p163

			return BodyVelocity2
		end,
		raycastFromScreen = function(p164)
			local v1140 = CurrentCamera:ScreenPointToRay(p164.X, p164.Y)

			return Workspace:Raycast(v1140.Origin, v1140.Direction * 1000)
		end,
		getPlayerFromHit = function(p165)
			if not p165 or not p165.Instance then
				return nil
			end

			local Model = p165.Instance:FindFirstAncestorOfClass("Model")

			return Players:GetPlayerFromCharacter(Model)
		end
	}
	local t75

	t75 = {
		getSoccerBall = function(p166)
			local v1143 = t74.getPlayerCharacter(p166)
			local Backpack = p166:WaitForChild("Backpack")
			local v1145 = Workspace:WaitForChild("WorkspaceCom"):FindFirstChild("001_SoccerBalls")

			if not v1143 or not v1145 then
				return nil
			end

			local v1146 = v1145:FindFirstChild("Soccer" .. p166.Name)

			if v1146 then
				return v1146
			end

			if not Backpack:FindFirstChild("SoccerBall") and not v1143:FindFirstChild("SoccerBall") then
				local ok = pcall(function()
					ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
				end)

				if not ok then
					lib:Notify({
						Title = "warn",
						Description = "error when catching the ball ",
						Type = "Error",
						Duration = 4
					})

					return nil
				end
			end

			if not t74.safeWait(function()
				return Backpack:FindFirstChild("SoccerBall") or v1143:FindFirstChild("SoccerBall")
			end) then
				return nil
			end

			local SoccerBall = Backpack:FindFirstChild("SoccerBall")

			if SoccerBall then
				SoccerBall.Parent = v1143
			end

			if t74.safeWait(function()
				return v1145:FindFirstChild("Soccer" .. p166.Name)
			end) then
				return v1145:FindFirstChild("Soccer" .. p166.Name)
			end

			return nil
		end,
		prepareBall = function(p167, p168)
			if not p167 then
				return false
			end

			p167.CanCollide = false
			p167.Massless = true
			p167.CustomPhysicalProperties = t72.BALL_PHYSICS

			if p168 then
				p167.Transparency = 1
			end

			return true
		end,
		flingWithBall = function(p169, p170, p171)
			if p169 == LocalPlayer2 then
				return false
			end

			local v1150 = t74.getPlayerCharacter(p169)

			if not t74.validateCharacter(v1150) then
				return false
			end

			local v1151 = t75.getSoccerBall(LocalPlayer2)

			if not v1151 or not t75.prepareBall(v1151, p170) then
				return false
			end

			local HumanoidRootPart = v1150.HumanoidRootPart
			local Humanoid_ = v1150.Humanoid
			local Humanoid_2 = LocalPlayer2.Character.Humanoid

			t74.createBodyVelocity(v1151)
			CurrentCamera.CameraSubject = Humanoid_

			local now = tick()
			local v1156 = false

			repeat
				if HumanoidRootPart.Velocity.Magnitude > 0 then
					local v1157 = HumanoidRootPart.Position + HumanoidRootPart.Velocity / 1.5

					if p171 then
						v1151.CFrame = CFrame.new(v1157.X, v1157.Y + math.sin(tick() * 8) * 3, v1157.Z)
					else
						v1151.CFrame = CFrame.new(v1157)
					end
				else
					for _, child in pairs(v1150:GetChildren()) do
						if child:IsA("BasePart") and child.CanCollide and not child.Anchored then
							v1151.CFrame = child.CFrame

							break
						end
					end
				end

				v1151.Orientation += t72.ROTATION_SPEED

				if t72.MIN_FLING_SPEED < HumanoidRootPart.Velocity.Magnitude then
					v1156 = true

					break
				end

				task.wait(0.00016666666666666666)
			until Humanoid_.Health <= 0 or not v1150:IsDescendantOf(Workspace) or p169.Parent ~= Players or t72.TIMEOUT_SECONDS < tick() - now

			CurrentCamera.CameraSubject = Humanoid_2

			return v1156
		end
	}

	local t76

	t76 = {
		initialize = function()
			t73.blackHole = Instance.new("Part")
			t73.blackHole.Size = Vector3.new(100000, 100000, 100000)
			t73.blackHole.Transparency = 1
			t73.blackHole.Anchored = true
			t73.blackHole.CanCollide = false
			t73.blackHole.Name = "BlackHoleTarget"
			t73.blackHole.Parent = Workspace
			t73.baseAttachment = Instance.new("Attachment")
			t73.baseAttachment.Name = "BlackHoleAttachment"
			t73.baseAttachment.Parent = t73.blackHole
			RunService.Heartbeat:Connect(function()
				local v1161 = t74.getPlayerCharacter(LocalPlayer2)

				if v1161 then
					if v1161:FindFirstChild("HumanoidRootPart") then
						t73.blackHole.CFrame = v1161.HumanoidRootPart.CFrame
					end
				end
			end)

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				t76.setupDoor(descendant)
			end

			Workspace.DescendantAdded:Connect(t76.setupDoor)
		end,
		setupDoor = function(p172)
			if not p172:IsA("BasePart") or p172.Anchored or not string.find(p172.Name, "Door") or p172:FindFirstChild("DoorAttached") then
				return
			end

			p172.CanCollide = false

			for _, child in ipairs(p172:GetChildren()) do
				if child:IsA("AlignPosition") or child:IsA("Torque") or child:IsA("Attachment") then
					child:Destroy()
				end
			end

			Instance.new("BoolValue", p172).Name = "DoorAttached"

			local Attachment = Instance.new("Attachment", p172)
			local AlignPosition = Instance.new("AlignPosition", p172)

			AlignPosition.Attachment0 = Attachment
			AlignPosition.Attachment1 = t73.baseAttachment
			AlignPosition.MaxForce = 1e20
			AlignPosition.MaxVelocity = math.huge
			AlignPosition.Responsiveness = 99999

			local Torque = Instance.new("Torque", p172)

			Torque.Attachment0 = Attachment
			Torque.RelativeTo = Enum.ActuatorRelativeTo.World
			Torque.Torque = Vector3.new(math.random(-1000000, 1000000) * 10000, math.random(-1000000, 1000000) * 10000, math.random(-1000000, 1000000) * 10000)
			table.insert(t73.controlledDoors, {
				Part = p172,
				Align = AlignPosition
			})
		end,
		flingWithDoors = function(p173)
			if p173 == LocalPlayer2 then
				return false
			end

			local v1169 = t74.getPlayerCharacter(p173)

			if not t74.validateCharacter(v1169) then
				return false
			end

			local HumanoidRootPart = v1169.HumanoidRootPart
			local TargetAttachment = HumanoidRootPart:FindFirstChild("TargetAttachment")

			if not TargetAttachment then
				TargetAttachment = Instance.new("Attachment", HumanoidRootPart)
				TargetAttachment.Name = "TargetAttachment"
			end

			for _, controlledDoor in ipairs(t73.controlledDoors) do
				if controlledDoor.Align and controlledDoor.Align.Parent then
					controlledDoor.Align.Attachment1 = TargetAttachment
				end
			end

			local now = tick()
			local v1175 = false

			while tick() - now < t72.TIMEOUT_SECONDS do
				if HumanoidRootPart.Velocity.Magnitude >= 20 then
					v1175 = true

					break
				else
					RunService.Heartbeat:Wait()
				end
			end

			for _, controlledDoor in ipairs(t73.controlledDoors) do
				if controlledDoor.Align and controlledDoor.Align.Parent then
					controlledDoor.Align.Attachment1 = t73.baseAttachment
				end
			end

			return v1175
		end
	}

	local t77 = {
		createTool = function(p174, p175, p176, p177)
			local Backpack = LocalPlayer2:WaitForChild("Backpack")
			local v1180 = Backpack:FindFirstChild(p174)

			if v1180 then
				v1180:Destroy()
			end

			local Tool = Instance.new("Tool")

			Tool.Name = p174
			Tool.RequiresHandle = p175 ~= nil
			Tool.CanBeDropped = false

			if p175 then
				local Part = Instance.new("Part")

				Part.Name = "Handle"
				Part.Size = Vector3.new(1, 1, 1)
				Part.Transparency = 1
				Part.Parent = Tool

				local Decal = Instance.new("Decal")

				Decal.Texture = "rbxassetid://" .. p175
				Decal.Face = Enum.NormalId.Front
				Decal.Parent = Part
			end

			Tool.Equipped:Connect(p176 or function()
			end)
			Tool.Unequipped:Connect(p177 or function()
			end)
			Tool.Parent = Backpack

			return Tool
		end
	}
	local t78 = {
		handleTouch = function(p178, p179, p180)
			if p179 then
				return
			end

			local v1185 = t74.raycastFromScreen(p178[1])
			local v1186 = t74.getPlayerFromHit(v1185)

			if v1186 and v1186 ~= LocalPlayer2 then
				p180(v1186)
			end
		end
	}

	t3.TT:AddSection({ t1:traduzir("Matar Jogadores Com Clique") })
	t3.TT:AddButton({
		Name = t1:traduzir("Clique Admin <Fling>"),
		Callback = function()
			v13:Dialog({
				Title = t1:traduzir("Admin Fling"),
				Text = t1:traduzir("Equipe a bola e use o clique para arremessar jogadores. Ferramenta com câmera automática."),
				Options = {
					{
						"Link Discord",
						function()
							v15()
						end
					},
					{
						"Ativar",
						function()
							t77.createTool("Admin Fling", "775552544", function()
								t73.adminToolEquipped = true
							end, function()
								t73.adminToolEquipped = false
							end)
						end
					}
				}
			})
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Clique Portas <Fling>"),
		Callback = function()
			t76.initialize()
		end
	})
	UserInputService.TouchTap:Connect(function(p181, p182)
		if p182 then
			return
		end

		if t73.adminToolEquipped then
			t78.handleTouch(p181, p182, function(p183)
				spawn(function()
					t75.flingWithBall(p183, true, false)
				end)
			end)
		end

		if t73.blackHole then
			t78.handleTouch(p181, p182, function(p184)
				spawn(function()
					t76.flingWithDoors(p184)
				end)
			end)
		end
	end)

	local Players3 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local Workspace2 = game:GetService("Workspace")
	local UserInputService2 = game:GetService("UserInputService")
	local CurrentCamera2 = Workspace2.CurrentCamera
	local LocalPlayer3 = Players3.LocalPlayer
	local u1193 = false

	t3.TT:AddToggle({
		Name = t1:traduzir("Clique Bola <Fling>"),
		Description = t1:traduzir("trolar jogadores usando isso apenas damdo clique"),
		Default = false,
		Callback = function(p185)
			u1193 = p185
		end
	})

	local function v1194(p186)
		local v1195 = LocalPlayer3
		local Character_ = v1195.Character or v1195.CharacterAdded:Wait()

		Character_:WaitForChild("Humanoid")
		Character_:WaitForChild("HumanoidRootPart")

		local Backpack = v1195:WaitForChild("Backpack")
		local v1198 = Workspace2.WorkspaceCom:FindFirstChild("001_SoccerBalls")

		if not v1198 then
			return
		end

		local function v1199()
			if not Backpack:FindFirstChild("SoccerBall") then
				if not Character_:FindFirstChild("SoccerBall") then
					ReplicatedStorage2.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
				end
			end

			while true do
				task.wait()

				if Backpack:FindFirstChild("SoccerBall") then
					break
				elseif Character_:FindFirstChild("SoccerBall") then
					break
				end
			end

			local SoccerBall = Backpack:FindFirstChild("SoccerBall")

			if SoccerBall then
				SoccerBall.Parent = Character_
			end

			repeat
				task.wait()
			until v1198:FindFirstChild("Soccer" .. v1195.Name)

			return v1198:FindFirstChild("Soccer" .. v1195.Name)
		end

		local v1201 = v1198:FindFirstChild("Soccer" .. v1195.Name) or v1199()

		if not v1201 then
			return
		end

		v1201.CanCollide = false
		v1201.Massless = true
		v1201.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

		if p186 ~= v1195 then
			local Character_2 = p186.Character

			if not Character_2 then
				return
			end

			local HumanoidRootPart = Character_2:FindFirstChild("HumanoidRootPart")
			local Humanoid_ = Character_2:FindFirstChild("Humanoid")

			if not HumanoidRootPart or not Humanoid_ then
				return
			end

			local BodyVelocity = v1201:FindFirstChildWhichIsA("BodyVelocity")

			if BodyVelocity then
				BodyVelocity:Destroy()
			end

			local BodyVelocity2 = Instance.new("BodyVelocity")

			BodyVelocity2.Name = "FlingPower"
			BodyVelocity2.Velocity = Vector3.new(900000000, 900000000, 900000000)
			BodyVelocity2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			BodyVelocity2.P = math.huge
			BodyVelocity2.Parent = v1201

			while true do
				local v1207 = HumanoidRootPart.Position + HumanoidRootPart.Velocity / 1.5

				v1201.CFrame = CFrame.new(v1207.X, v1207.Y + math.sin(tick() * 7) * 2, v1207.Z)
				v1201.Orientation += Vector3.new(45, 60, 30)
				task.wait(0.0002)

				if HumanoidRootPart.Velocity.Magnitude > 1000 then
					break
				elseif Humanoid_.Health <= 0 or not Character_2:IsDescendantOf(Workspace2) or p186.Parent ~= Players3 then
					break
				end
			end
		end
	end

	UserInputService2.TouchTap:Connect(function(p187, p188)
		if u1193 then
			if not p188 then
				local v1208 = p187[1]
				local v1209 = CurrentCamera2:ScreenPointToRay(v1208.X, v1208.Y)
				local hit = Workspace2:Raycast(v1209.Origin, v1209.Direction * 1000)

				if hit and hit.Instance then
					local Model = hit.Instance:FindFirstAncestorOfClass("Model")
					local playerFromCharacter = Players3:GetPlayerFromCharacter(Model)

					if playerFromCharacter and playerFromCharacter ~= LocalPlayer3 then
						v1194(playerFromCharacter)
					end
				end

				return
			end
		end
	end)
	t3.TT:AddSection({ t1:traduzir("Orbitar") })

	local u1213
	local u1214 = false
	local n49 = 20
	local v1216 = t3.TT:AddDropdown({
		Name = t1:traduzir("Selecione Um Jogador"),
		Description = t1:traduzir("Selecione um jogador para orbitar"),
		Players = "orbit",
		Options = {},
		Default = "Players",
		Callback = function(p189)
			u1213 = Players:FindFirstChild(p189)
		end
	})

	t3.TT:AddSlider({
		Name = t1:traduzir("Velocidade <Tween>"),
		Min = 1,
		Max = 9999,
		Increase = 1,
		Default = 20,
		Callback = function(p190)
			n49 = p190
		end
	})
	t3.TT:AddButton({
		Name = t1:traduzir("Atualizar tabela"),
		Callback = function()
			local t79 = {}

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer then
					table.insert(t79, player.Name)
				end
			end

			v1216:Set(t79)
		end
	})
	t3.TT:AddToggle({
		Name = t1:traduzir("Orbita Jogador"),
		Player = "orbit",
		Description = t1:traduzir("Vire um planeta e orbite o jogador"),
		Default = false,
		Callback = function(p191)
			u1214 = p191

			if u1214 then
				if u1213 and u1213.Character then
					if u1213.Character:FindFirstChild("HumanoidRootPart") then
						local Character_ = LocalPlayer2.Character
						local HumanoidRootPart = Character_ and Character_:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart then
							return
						end

						while u1214 and u1213 and u1213.Character do
							if not u1213.Character:FindFirstChild("HumanoidRootPart") then
								break
							end

							local HumanoidRootPart2 = u1213.Character.HumanoidRootPart
							local v1223 = tick() * n49
							local v1224 = HumanoidRootPart2.Position + Vector3.new(math.cos(v1223) * 5, 0, math.sin(v1223) * 5)
							local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
								CFrame = CFrame.new(v1224)
							})

							tween:Play()
							tween.Completed:Wait()
						end
					end
				end
			end
		end
	})
end)
task.spawn(function()
	task.wait(11)

	local t80 = {
		Players = Players,
		Workspace = Workspace,
		LocalPlayer = LocalPlayer,
		Camera = workspace.CurrentCamera,
		AtualizarListaCarros = function(p192)
			local t81 = {}
			local Vehicles = p192.Workspace:FindFirstChild("Vehicles")

			if Vehicles then
				for _, child in ipairs(Vehicles:GetChildren()) do
					if child:IsA("Model") then
						table.insert(t81, child.Name)
					end
				end
			end

			return t81
		end
	}

	t3.Carros:AddSection({ "Carros View" })

	local v1231 = t3.Carros:AddDropdown({
		Name = "Foco < Carros >",
		Description = "Super Foque nos carros de longe",
		Options = t80:AtualizarListaCarros(),
		Default = "Cars",
		Callback = function(p193)
			_G.SelectedVehicle = p193
		end
	})

	t3.Carros:AddToggle({
		Name = "Visualizar Carro",
		Description = "olha carro mesmo estando de longe",
		Default = false,
		Callback = function(p194)
			if p194 then
				if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
					return
				end

				local Vehicles = t80.Workspace:FindFirstChild("Vehicles")

				if not Vehicles then
					return
				end

				local _GSelectedVehicle = Vehicles:FindFirstChild(_G.SelectedVehicle)

				if not _GSelectedVehicle then
					return
				end

				local VehicleSeat = _GSelectedVehicle:FindFirstChildWhichIsA("VehicleSeat", true)

				if not VehicleSeat then
					return
				end

				t80.OriginalCameraSubject = t80.Camera.CameraSubject
				t80.OriginalCameraType = t80.Camera.CameraType
				t80.Camera.CameraSubject = VehicleSeat
				t80.Camera.CameraType = Enum.CameraType.Follow
			elseif t80.OriginalCameraSubject then
				t80.Camera.CameraSubject = t80.OriginalCameraSubject
				t80.Camera.CameraType = t80.OriginalCameraType or Enum.CameraType.Custom
				t80.OriginalCameraSubject = nil
				t80.OriginalCameraType = nil
			end
		end
	})
	t80.Workspace:WaitForChild("Vehicles").ChildAdded:Connect(function()
		v1231:Set(t80:AtualizarListaCarros())
	end)
	t80.Workspace:WaitForChild("Vehicles").ChildRemoved:Connect(function()
		v1231:Set(t80:AtualizarListaCarros())
	end)
	t3.Carros:AddSection({ t1:traduzir("Velocidade Do Carro Sem <GamePass>") })

	local value = 25
	local value2 = "25"

	t3.Carros:AddTextBox({
		Title = t1:traduzir("Definir Velocidade"),
		Description = t1:traduzir("Velocidade do carro preencher o espaço"),
		Default = tostring(value),
		PlaceholderText = t1:traduzir("Velocidade"),
		ClearText = false,
		Callback = function(p195)
			value = tonumber(p195) or value
		end
	})
	t3.Carros:AddTextBox({
		Title = t1:traduzir("Definir Turbo"),
		Description = t1:traduzir("Valor turbo (Velocidade add)"),
		Default = value2,
		PlaceholderText = "Turbo",
		ClearText = false,
		Callback = function(p196)
			value2 = tostring(p196)
		end
	})
	t3.Carros:AddButton({
		Name = t1:traduzir("Mudar Velocidade e Turbo"),
		Callback = function()
			local Vehicles = workspace:FindFirstChild("Vehicles")
			local v1238 = Vehicles and Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
			local Seats = v1238 and v1238:FindFirstChild("Seats")
			local VehicleSeat = Seats and Seats:FindFirstChild("VehicleSeat")

			if VehicleSeat then
				local MaxSpeed = VehicleSeat:FindFirstChild("MaxSpeed")

				if MaxSpeed and MaxSpeed:IsA("NumberValue") then
					MaxSpeed.Value = value
				end

				local Turbo = VehicleSeat:FindFirstChild("Turbo")

				if Turbo and Turbo:IsA("StringValue") then
					Turbo.Value = value2
				end
			end

			local Body = v1238 and v1238:FindFirstChild("Body")
			local VehicleSeat2 = Body and Body:FindFirstChild("VehicleSeat")

			if VehicleSeat2 then
				local TopSpeed = VehicleSeat2:FindFirstChild("TopSpeed")

				if TopSpeed and TopSpeed:IsA("NumberValue") then
					TopSpeed.Value = value
				end

				local Turbo = VehicleSeat2:FindFirstChild("Turbo")

				if Turbo and Turbo:IsA("StringValue") then
					Turbo.Value = value2
				end
			end

			lib:Notify({
				Title = t1:traduzir("Velocidade Aplicada"),
				Description = lib:T("Velocidade") .. ": " .. value .. " | Turbo: " .. value2,
				Type = "Success",
				Duration = 4
			})
		end
	})
	t3.MU:AddSection({ "Música: Carros, Casas e Props" })
	game:GetService("HttpService")

	local s5 = ""
	local t82 = {}
	local t83 = {}
	local t84 = {}
	local t85 = {
		"Phonk",
		"funk",
		"forrozin",
		"Trap",
		"samba",
		"Aleatório"
	}

	local function v1252(p197)
		local v1253 = string.format("https://raw.githubusercontent.com/scriptclient/Apis/main/%s.lua", p197)

		local function v1254()
			return game:HttpGet(v1253)
		end

		local ok, result2 = pcall(v1254)

		if not ok then
			warn("Erro ao buscar categoria:", p197)

			return {}
		end

		local ok3, result3 = pcall(function()
			local chunk = loadstring(result2)

			if chunk then
				return chunk()
			end

			return {}
		end)

		if not ok3 or not result3 then
			warn("Erro ao decodificar:", p197)

			return {}
		end

		for _, v in ipairs(result3) do
			if v.Name and v.Id then
				t84[v.Name] = v.Id
			end
		end

		return result3
	end

	local u1262 = false

	local function v1263(p198)
		if u1262 then
			return
		end

		u1262 = true
		task.spawn(function()
			for k, v in pairs(t82) do
				if k ~= p198 then
					task.spawn(function()
						pcall(function()
							v:Set({ "..." })
							task.wait(0.15)

							local v1266 = t83[k]

							if v1266 then
								v:Set(v1266)
							end
						end)
					end)
				end
			end

			task.wait(0.2)
			u1262 = false
		end)
	end
	local function v1267(p199)
		local v1268 = v1252(p199)
		local t86 = { "..." }

		for _, v in ipairs(v1268) do
			table.insert(t86, v.Name)
		end

		t83[p199] = t86

		if t82[p199] then
			t82[p199]:Set(t86)
		else
			t82[p199] = t3.MU:AddDropdown({
				Name = p199,
				Options = t86,
				Default = "...",
				Callback = function(p200)
					if u1262 then
						return
					end

					if p200 == "..." then
						s5 = ""
					else
						s5 = p200
						v1263(p199)
					end
				end
			})
		end
	end

	for _, v in ipairs(t85) do
		v1267(v)
	end

	task.spawn(function()
		while true do
			task.wait(30)

			for _, v in ipairs(t85) do
				pcall(function()
					v1267(v)
				end)
			end
		end
	end)

	local RE = game:GetService("ReplicatedStorage").RE

	local function v1277()
		pcall(function()
			RE:FindFirstChild("1Player1sCa1r"):FireServer("VehicleMusicStop", "")
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1Player1sCa1r"):FireServer("MusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1Player1sCa1r"):FireServer("CarMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1Player1sHous1e"):FireServer("PickingHouseMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1Hors1eRemot1e"):FireServer("HorseMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1NoMoto1rVehicle1s"):FireServer("PickingScooterMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE:FindFirstChild("1Player1sCa1r"):FireServer("WickedGramophoneMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE.Props:FireServer("PropMusicStop", "", nil, true)
		end)
		task.wait(0.1)
		pcall(function()
			RE.PlayerToolEvent:FireServer("ToolMusicStop", "", nil, true)
		end)
	end
	local function v1278(p201)
		local t87 = {
			{
				remote = RE:FindFirstChild("1Player1sCa1r"),
				event = "PickingVehicleMusicText"
			},
			{
				remote = RE:FindFirstChild("1Player1sCa1r"),
				event = "PickingCarMusicText"
			},
			{
				remote = RE:FindFirstChild("1NoMoto1rVehicle1s"),
				event = "PickingScooterMusicText"
			},
			{
				remote = RE:FindFirstChild("1Player1sHous1e"),
				event = "PickHouseMusicText"
			},
			{
				remote = RE.PlayerToolEvent,
				event = "ToolMusicText"
			}
		}

		for _, v in ipairs(t87) do
			if v.remote then
				pcall(function()
					v.remote:FireServer(v.event, tostring(p201), nil, true)
				end)
				task.wait(0.1)
			end
		end
	end

	t3.MU:AddButton({
		Name = "Tocar Música",
		Callback = function()
			local v1287 = t84[s5]

			if not v1287 then
				return
			end

			v1277()
			task.wait(0.5)
			v1278(v1287)
		end
	})
	t3.MU:AddButton({
		Name = "Parar Música",
		Callback = function()
			v1277()
		end
	})

	local u1288 = false
	local thread

	local function v1290()
		while u1288 do
			for _, child in ipairs(workspace.Vehicles:GetChildren()) do
				if child:FindFirstChild("Owner") then
					if child.Owner.Value == game.Players.LocalPlayer.Name then
						local color3 = Color3.new(math.random(), math.random(), math.random())

						for _, descendant in ipairs(child:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.Color = color3
							end
						end
					end
				end
			end

			wait(0.5)
		end
	end

	t3.Carros:AddToggle({
		Name = t1:traduzir("Carro Colorido <GamePass>"),
		Default = false,
		Callback = function(p202)
			u1288 = p202

			if u1288 then
				thread = coroutine.create(v1290)
				coroutine.resume(thread)
			end
		end
	})

	local function v1296()
		local t93 = {}

		for _, child in pairs(game.Workspace.Vehicles:GetChildren()) do
			table.insert(t93, child.Name)
		end

		return t93
	end

	local u1300

	t3.Carros:AddSection({ t1:traduzir("Carro Funções") })

	local v1301 = t3.Carros:AddDropdown({
		Name = t1:traduzir("Selecione um carro"),
		Description = t1:traduzir("Selecionar Um Carro para as funções"),
		Options = v1296(),
		Default = t1:traduzir("Carros"),
		Callback = function(p203)
			u1300 = p203
		end
	})

	t3.Carros:AddSlider({
		Name = t1:traduzir("Verificação de Carros"),
		Min = 1,
		Max = 25,
		Increase = 1,
		Default = 25,
		Callback = function()
		end
	})
	t3.Carros:AddButton({
		t1:traduzir("Atualizar lista"),
		function()
			v1301:Set(v1296())
		end
	})
	t3.Carros:AddButton({
		Name = t1:traduzir("Teleporta ao Assento"),
		Callback = function()
			local LocalPlayer2 = game.Players.LocalPlayer
			local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

			if u1300 then
				local v1304 = workspace.Vehicles:FindFirstChild(u1300)

				if v1304 and v1304:FindFirstChild("Body") then
					local Body = v1304.Body
					local VehicleSeat

					if Body:FindFirstChild("VehicleSeat") then
						VehicleSeat = Body.VehicleSeat
					elseif Body:FindFirstChild("CarSeatPosition") then
						VehicleSeat = Body.CarSeatPosition
					elseif Body:FindFirstChild("Passenger") then
						VehicleSeat = Body.Passenger
					end

					if VehicleSeat and VehicleSeat:IsA("BasePart") then
						HumanoidRootPart.CFrame = VehicleSeat.CFrame + Vector3.new(0, 3, 0)
					end
				end
			end
		end
	})
	t3.Carros:AddToggle({
		Name = t1:traduzir("Puxa o Carro"),
		Description = t1:traduzir("Teleporta temporariamente o carro até você"),
		Default = false,
		Callback = function(p204)
			if not p204 then
				return
			end

			local LocalPlayer2 = game.Players.LocalPlayer
			local HumanoidRootPart = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			if u1300 then
				local v1309 = workspace.Vehicles:FindFirstChild(u1300)

				if v1309 and v1309:FindFirstChild("Body") then
					local Body = v1309.Body
					local CarSeatPosition = Body:FindFirstChild("CarSeatPosition") or Body:FindFirstChild("VehicleSeat") or Body:FindFirstChild("Passenger")

					if CarSeatPosition and CarSeatPosition:IsA("BasePart") then
						local CFrame_ = HumanoidRootPart.CFrame

						HumanoidRootPart.CFrame = CarSeatPosition.CFrame
						wait(0.8)

						if v1309.PrimaryPart then
							v1309:SetPrimaryPartCFrame(CFrame_)
						else
							v1309:MoveTo(CFrame_.Position)
						end

						HumanoidRootPart.CFrame = CFrame_
					end
				end
			end
		end
	})
	t3.Carros:AddSection({ t1:traduzir("Extreme Carros <Super>") })
	t3.Carros:AddButton({
		Name = t1:traduzir("Fly Carro Free"),
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/realgengar/scripts/refs/heads/main/FlyCar.lua", true))()
		end
	})

	local function v1313()
		for _, child in ipairs(game.Workspace.Vehicles:GetChildren()) do
			for _, descendant in ipairs(child:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Massless = true
				end
			end
		end

		wait(0.3)

		for _, child in ipairs(game.Workspace.Vehicles:GetChildren()) do
			child:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)

			for _, descendant in ipairs(child:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
					descendant.Massless = false
				end
			end
		end
	end

	t3.Carros:AddButton({
		t1:traduzir("Puxa Carros"),
		function()
			v1313()
		end
	})
	t3.Carros:AddButton({
		Name = t1:traduzir("Remover os carros <Todos>"),
		Callback = function()
			local CFrame_ = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
			wait(0.3)
			game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack({
				"PickingBoat",
				"MilitaryBoatFree"
			}))
			wait(1)

			local v1323

			for _, descendant in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"]:GetDescendants()) do
				if descendant:IsA("VehicleSeat") then
					v1323 = descendant
				end
			end

			repeat
				if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then
					return
				end

				if game.Players.LocalPlayer.Character.Humanoid.Sit == true and not game.Players.LocalPlayer.Character.Humanoid.SeatPart == v1323 then
					game.Players.LocalPlayer.Character.Humanoid.Sit = false
				end

				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1323.CFrame
				task.wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1323.CFrame + Vector3.new(0, 1, 0)
				task.wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v1323.CFrame + Vector3.new(0, -1, 0)
				task.wait()
			until game.Players.LocalPlayer.Character.Humanoid.SeatPart == v1323

			for _, descendant in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"]:GetDescendants()) do
				if descendant.Name == "PhysicalWheel" then
					descendant:Destroy()
				end
			end

			local BodyThrust = Instance.new("BodyThrust", game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass)

			BodyThrust.Force = Vector3.new(50000, 0, 50000)
			BodyThrust.Name = "FLING"
			BodyThrust.Location = game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.Position

			for _, child in pairs(game.workspace.Vehicles:GetChildren()) do
				for _, descendant in pairs(child:GetDescendants()) do
					if descendant.Name == "VehicleSeat" then
						local v1333 = descendant
						local BodyVelocity = Instance.new("BodyVelocity", game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass)

						BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						BodyVelocity.P = 1250
						BodyVelocity.Velocity = Vector3.new(0, 0, 0)
						BodyVelocity.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

						for i = 1, 25 do
							local t94 = {
								x = 0,
								y = 0,
								z = 0,
								x = v1333.Position.X,
								y = v1333.Position.Y,
								z = v1333.Position.Z
							}

							t94.x += v1333.Velocity.X / 2
							t94.y += v1333.Velocity.Y / 2
							t94.z += v1333.Velocity.Z / 2

							if t94.y <= -200 then
								game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.CFrame = CFrame.new(0, 1000, 0)
							else
								game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(t94.x, t94.y, t94.z))
								task.wait()
								game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(t94.x, t94.y, t94.z)) + Vector3.new(0, -2, 0)
								task.wait()
								game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(t94.x, t94.y, t94.z)) * CFrame.new(0, 0, 2)
								task.wait()
								game.workspace.Vehicles[game.Players.LocalPlayer.Name .. "Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(t94.x, t94.y, t94.z)) * CFrame.new(2, 0, 0)
								task.wait()
							end

							task.wait()
						end
					end
				end
			end

			task.wait()
			game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack({ "DeleteAllVehicles" }))
			game.Players.LocalPlayer.Character.Humanoid.Sit = false
			wait()

			local BodyVelocity = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)

			BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			BodyVelocity.P = 1250
			BodyVelocity.Velocity = Vector3.new(0, 0, 0)
			BodyVelocity.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
			wait(0.1)

			for i = 1, 2 do
				task.wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame_
			end

			wait(1)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame_
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"):Destroy()
			wait(0.2)
		end
	})

	local u1339 = false
	local t95 = {}

	local function createTextLabel(p205)
		local BillboardGui = Instance.new("BillboardGui")

		BillboardGui.Name = "ESP"
		BillboardGui.Adornee = p205
		BillboardGui.Size = UDim2.new(0, 150, 0, 30)
		BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
		BillboardGui.AlwaysOnTop = true

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextColor3 = Color3.new(0, 1, 0)
		TextLabel.TextScaled = true
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.Parent = BillboardGui
		BillboardGui.Parent = p205

		return TextLabel
	end
	local function v1344(p206)
		u1339 = p206

		if u1339 then
			for _, child in pairs(workspace.Vehicles:GetChildren()) do
				if not child:FindFirstChild("ESP") and child:IsA("Model") and child.PrimaryPart then
					local v1347 = createTextLabel(child)
					local connection = game:GetService("RunService").RenderStepped:Connect(function()
						if u1339 and child then
							if child.PrimaryPart then
								v1347.Text = child.Name .. " | " .. lib:T("Distância") .. ": " .. math.floor((game.Players.LocalPlayer.Character.PrimaryPart.Position - child.PrimaryPart.Position).Magnitude) .. " studs"
							end
						end
					end)

					table.insert(t95, connection)
				end
			end
		else
			for _, v in pairs(t95) do
				v:Disconnect()
			end

			t95 = {}

			for _, child in pairs(workspace.Vehicles:GetChildren()) do
				if child:FindFirstChild("ESP") then
					child.ESP:Destroy()
				end
			end
		end
	end

	t3.Carros:AddSection({ t1:traduzir("Avançado") })
	t3.Carros:AddToggle({
		Name = t1:traduzir("Esp Carros"),
		Description = t1:traduzir("Mostra Carros no mapa"),
		Default = false
	}):Callback(function(p207)
		v1344(p207)
	end)

	local t96 = {
		"SchoolBus",
		"SmartCar",
		"FarmTruck",
		"Cadillac",
		"Excavator",
		"Jeep",
		"NascarTruck",
		"TowTruck",
		"Snowplow",
		"MilitaryTruck",
		"Tank",
		"Limo",
		"FireTruck"
	}
	local u1354 = false

	local function v1355(p208)
		game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack({
			"PickingCar",
			p208
		}))
	end

	t3.Carros:AddToggle({
		Name = t1:traduzir("Codigo Varios Carros"),
		Default = false,
		Callback = function(p209)
			u1354 = p209

			if u1354 then
				task.spawn(function()
					while u1354 do
						for _, v in ipairs(t96) do
							if not u1354 then
								break
							end

							v1355(v)
							wait(0.4)
						end
					end
				end)
			end
		end
	})
end)
task.spawn(function()
	task.wait(12)

	local t97 = {
		{
			Nome = "Agência",
			Ponto = CFrame.new(179, 4, -464)
		},
		{
			Nome = "Oficina Oculta",
			Ponto = CFrame.new(0, 4, -495)
		},
		{
			Nome = "Bastidores",
			Ponto = CFrame.new(192, 4, 272)
		},
		{
			Nome = "Centro Urbano",
			Ponto = CFrame.new(136, 4, 117)
		},
		{
			Nome = "Área do Crime",
			Ponto = CFrame.new(-119, -28, 235)
		},
		{
			Nome = "Casa Deserta",
			Ponto = CFrame.new(986, 4, 63)
		},
		{
			Nome = "Arco",
			Ponto = CFrame.new(-589, 141, -59)
		},
		{
			Nome = "Hospital",
			Ponto = CFrame.new(-309, 4, 71)
		},
		{
			Nome = "Sala Secreta",
			Ponto = CFrame.new(-343, 4, -613)
		},
		{
			Nome = "Ilha Isolada",
			Ponto = CFrame.new(-1925, 23, 127)
		},
		{
			Nome = "Hotéis",
			Ponto = CFrame.new(182, 4, 150)
		},
		{
			Nome = "Montanha",
			Ponto = CFrame.new(-670, 251, 765)
		},
		{
			Nome = "Portal da Agência",
			Ponto = CFrame.new(672, 4, -296)
		},
		{
			Nome = "Esconderijo",
			Ponto = CFrame.new(505, -75, 143)
		},
		{
			Nome = "Escola",
			Ponto = CFrame.new(-312, 4, 211)
		},
		{
			Nome = "Café",
			Ponto = CFrame.new(161, 8, 52)
		},
		{
			Nome = "Cafeteria",
			Ponto = CFrame.new(-97.12, 4.65, 254.99)
		},
		{
			Nome = "Início",
			Ponto = CFrame.new(-26, 4, -23)
		},
		{
			Nome = "Banco",
			Ponto = CFrame.new(2.28, 4.65, 254.58)
		},
		{
			Nome = "Roupas",
			Ponto = CFrame.new(-46.15, 4.65, 253.2)
		},
		{
			Nome = "Refúgio",
			Ponto = CFrame.new(-88.48, 22.05, 262.34)
		},
		{
			Nome = "Clínica Dentária",
			Ponto = CFrame.new(-53.58, 22.15, 265.61)
		}
	}
	local u1359
	local t98 = {}

	for _, v in ipairs(t97) do
		table.insert(t98, v.Nome)
	end

	t3.Tp:AddDropdown({
		Name = t1:traduzir("Local de Teleporte"),
		Description = t1:traduzir("Escolha um destino para teleportar"),
		Options = t98,
		Default = "Local",
		Callback = function(p210)
			for _, v in ipairs(t97) do
				if v.Nome == p210 then
					u1359 = v

					break
				end
			end
		end
	})
	t3.Tp:AddButton({
		Name = t1:traduzir("Teleportar"),
		Description = t1:traduzir("Teleporta para o local selecionado"),
		Callback = function()
			local LocalPlayer2 = game.Players.LocalPlayer

			if LocalPlayer2.Character then
				if LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
					if not u1359 then
						return
					end

					LocalPlayer2.Character.HumanoidRootPart.CFrame = u1359.Ponto
					lib:Notify({
						Title = "Teleport...",
						Description = lib:T("Teleported to") .. ": " .. u1359.Nome,
						Type = "Sucess",
						Duration = 2
					})

					return
				end
			end
		end
	})

	if #t98 > 0 then
		for _, v in ipairs(t97) do
			if v.Nome == t98[1] then
				u1359 = v

				break
			end
		end
	end

	t3.Tp:AddSection({ t1:traduzir("Teleportes Variados") })
	t3.Tp:AddButton({
		t1:traduzir("Servidor Com Pouca Pessoas"),
		function()
			Hop()
		end
	})
	Hop = function()
		local t99 = {}
		local s6 = ""
		local hour = os.date("!*t").hour

		TPReturner = function()
			local data

			if s6 == "" then
				data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			else
				data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. s6))
			end

			if data.nextPageCursor and data.nextPageCursor ~= "null" and data.nextPageCursor ~= nil then
				s6 = data.nextPageCursor
			end

			local n50 = 0

			for _, v in pairs(data.data) do
				local v1375 = true
				local v1376 = tostring(v.id)
				local v1377 = tonumber(v.maxPlayers)

				if tonumber(v.playing) < v1377 then
					for _, v2 in pairs(t99) do
						if n50 == 0 then
							if tonumber(hour) ~= tonumber(v2) then
								pcall(function()
									t99 = {}
									table.insert(t99, hour)
								end)
							end
						elseif v1376 == tostring(v2) then
							v1375 = false
						end

						n50 += 1
					end

					if v1375 == true then
						table.insert(t99, v1376)
						wait(0.1)
						pcall(function()
							wait()
							game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v1376, game.Players.LocalPlayer)
						end)
						wait(0.1)
					end
				end
			end
		end
		Teleport = function()
			while wait(0.1) do
				pcall(function()
					TPReturner()

					if s6 ~= "" then
						TPReturner()
					end
				end)
			end
		end
		Teleport()
	end
	t3.Tp:AddButton({
		t1:traduzir("Servidor inferior"),
		function()
			local huge = math.huge
			local u1381 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
			local id
			local data

			if not _G.FailedServerID then
				_G.FailedServerID = {}
			end

			local function v1384()
				data = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(u1381))

				for _, v in pairs(data.data) do
					pcall(function()
						if type(v) == "table" then
							if v.id and v.playing then
								local v1387 = tonumber(huge)

								if tonumber(v.playing) < v1387 and not table.find(_G.FailedServerID, v.id) then
									huge = v.playing
									id = v.id
								end
							end
						end
					end)
				end
			end

			getservers = function()
				pcall(v1384)

				for k, v in pairs(data) do
					if k == "nextPageCursor" then
						if u1381:find("&cursor=") then
							local pos = u1381:find("&cursor=")

							u1381 = u1381:gsub(u1381:sub(pos), "")
						end

						u1381 ..= "&cursor=" .. v
						pcall(getservers)
					end
				end
			end
			pcall(getservers)
			wait(0.1)

			if id ~= game.JobId then
				local v1391 = #game:GetService("Players"):GetChildren() - 1
			end

			table.insert(_G.FailedServerID, id)
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, id)

			while wait(0.1) do
				pcall(function()
					if not game:IsLoaded() then
						game.Loaded:Wait()
					end

					game.CoreGui.RobloxPromptGui.promptOverlay.DescendantAdded:Connect(function()
						local ErrorPrompt = game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")

						if ErrorPrompt and ErrorPrompt.TitleFrame.ErrorTitle.Text == "Disconnected" then
							if #game.Players:GetPlayers() <= 1 then
								game.Players.LocalPlayer:Kick("\nRejoining...")
								wait(0.1)
								game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
							else
								game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
							end
						end
					end)
				end)
			end
		end
	})
	t3.Tp:AddButton({
		t1:traduzir("Reentra No Servidor"),
		function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
		end
	})
end)
task.spawn(function()
	task.wait(13)
	task.wait(0.1)
	t3.PR:AddSection({ t1:traduzir("Sistema De Variações") })

	local t100 = {}
	local u1394 = false

	t3.PR:AddToggle({
		Name = t1:traduzir("Anti Sit"),
		Description = t1:traduzir("Não Sentar"),
		Default = false,
		Callback = function(p211)
			local LocalPlayer2 = game.Players.LocalPlayer
			local RunService2 = game:GetService("RunService")

			local function v1397()
				for _, v in ipairs(t100) do
					if v and v.Connected then
						v:Disconnect()
					end
				end

				t100 = {}

				local Humanoid_ = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid_ then
					Humanoid_:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				end

				u1394 = false
			end

			if p211 then
				v1397()
				u1394 = true

				local function v1401(p212)
					if p212 then
						p212:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

						local connection = p212.StateChanged:Connect(function(old, new)
							if new == Enum.HumanoidStateType.Seated then
								p212:ChangeState(Enum.HumanoidStateType.GettingUp)
							end
						end)

						table.insert(t100, connection)
					end
				end
				local function v1403(character_)
					local Humanoid_ = character_:WaitForChild("Humanoid")

					v1401(Humanoid_)
				end

				local connection = LocalPlayer2.CharacterAdded:Connect(v1403)

				table.insert(t100, connection)

				if LocalPlayer2.Character then
					v1403(LocalPlayer2.Character)
				end

				local connection2 = RunService2.Heartbeat:Connect(function()
					if u1394 then
						local Humanoid_ = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

						if Humanoid_ then
							Humanoid_:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
						end
					end
				end)

				table.insert(t100, connection2)
			else
				v1397()
			end
		end
	})
	t3.PR:AddToggle({
		Name = t1:traduzir("Anti Skidder"),
		Description = t1:traduzir("Anti Skid > Open Source [ Discord ]"),
		Default = true
	})
	t3.CFG:AddSection({ t1:traduzir("Desenvolvedores") })

	local function v1408(p213, p214, p215)
		local v1409 = workspace:FindFirstChild(p213)

		if not v1409 then
			return
		end

		local Head = v1409:FindFirstChild("Head")

		if not Head or Head:FindFirstChild(p215) then
			return
		end

		local BillboardGui = Instance.new("BillboardGui")

		BillboardGui.Name = p215
		BillboardGui.Adornee = Head
		BillboardGui.Size = UDim2.new(0, 100, 0, 60)
		BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.MaxDistance = 80
		BillboardGui.Parent = Head

		local Frame = Instance.new("Frame", BillboardGui)

		Frame.Name = "TextBG"
		Frame.Size = UDim2.new(1, 0, 0.5, 0)
		Frame.Position = UDim2.new(0, 0, 0.5, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
		Frame.BackgroundTransparency = 0.3
		Frame.BorderSizePixel = 2
		Frame.BorderColor3 = Color3.new(0, 0, 0)
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

		local TextLabel = Instance.new("TextLabel", Frame)

		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = p214
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextScaled = true
		TextLabel.Font = Enum.Font.GothamBold

		local ImageLabel = Instance.new("ImageLabel", BillboardGui)

		ImageLabel.Size = UDim2.new(0, 40, 0, 40)
		ImageLabel.Position = UDim2.new(0.5, -20, 0, 0)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxassetid://72495850369898"
	end

	local t101 = {}

	local function v1416(p216, p217, p218)
		if t101[p218] then
			return
		end

		t101[p218] = true
		task.spawn(function()
			while t101[p218] do
				v1408(p216, p217, p218)
				task.wait(1)
			end
		end)
	end
	local function v1417(p219)
		t101[p219] = nil

		local v1418 = workspace:FindFirstChild(p219 == "ModGuiMod" and "scout7ixs" or "magnusfxp")

		if v1418 and v1418:FindFirstChild("Head") then
			local v1419 = v1418.Head:FindFirstChild(p219)

			if v1419 then
				v1419:Destroy()
			end
		end
	end
	local function v1420(p220, p221, p222)
		for _, v in ipairs(p220) do
			v1416(v, p221, p222 .. "_" .. v)
		end
	end
	local function v1423(p223, p224)
		for _, v in ipairs(p223) do
			local v1426 = p224 .. "_" .. v

			t101[v1426] = nil

			local v1427 = workspace:FindFirstChild(v)

			if v1427 then
				if v1427:FindFirstChild("Head") then
					local v1428 = v1427.Head:FindFirstChild(v1426)

					if v1428 then
						v1428:Destroy()
					end
				end
			end
		end
	end
	local function v1429(p225, p226)
		for k, v in pairs(p225) do
			v1416(k, v, p226 .. "_" .. k)
		end
	end
	local function v1432(p227, p228)
		for k in pairs(p227) do
			local v1434 = p228 .. "_" .. k

			t101[v1434] = nil

			local v1435 = workspace:FindFirstChild(k)

			if v1435 and v1435:FindFirstChild("Head") then
				local v1436 = v1435.Head:FindFirstChild(v1434)

				if v1436 then
					v1436:Destroy()
				end
			end
		end
	end
	local function v1437(p229)
		local ok, result2 = pcall(function()
			return loadstring(game:HttpGet(p229))()
		end)

		if ok and type(result2) == "table" then
			return result2
		end

		return {}
	end

	local t102 = {}
	local t103 = {}

	t3.CFG:AddToggle({
		Name = t1:traduzir("Dev Script"),
		Description = t1:traduzir("Mostra o Moderador do script no servidor"),
		Default = true,
		Callback = function(p230)
			if p230 then
				v1416("scout7ixs", "Developer", "ModGuiMod")
			else
				v1417("ModGuiMod")
			end
		end
	})
	t3.CFG:AddToggle({
		Name = t1:traduzir("Owner Script"),
		Description = t1:traduzir("Mostra o Dono do script no servidor"),
		Default = true,
		Callback = function(p231)
			if p231 then
				v1416("magnusfxp", "Owner", "ModGuiOwner")
			else
				v1417("ModGuiOwner")
			end
		end
	})
	t3.CFG:AddToggle({
		Name = t1:traduzir("Modder Script"),
		Description = t1:traduzir("Mostra os Staffs do servidor"),
		Default = true,
		Callback = function(p232)
			if p232 then
				t102 = v1437("https://raw.githubusercontent.com/scriptclient/Apis/refs/heads/main/modder.lua")

				if #t102 > 0 then
					v1420(t102, "Moderador", "ModGuiStaff")
				end
			elseif #t102 > 0 then
				v1423(t102, "ModGuiStaff")
			end
		end
	})
	t3.CFG:AddToggle({
		Name = t1:traduzir("Personalizado"),
		Description = t1:traduzir("Mostra usuários personalizados"),
		Default = true,
		Callback = function(p233)
			if p233 then
				t103 = v1437("https://raw.githubusercontent.com/scriptclient/Apis/refs/heads/main/custom.lua")

				if next(t103) then
					v1429(t103, "ModGuiCustom")
				end
			elseif next(t103) then
				v1432(t103, "ModGuiCustom")
			end
		end
	})
	t3.JJ:AddSection({ t1:traduzir("Items Tool") })
	t3.JJ:AddButton({
		t1:traduzir("Telecinese"),
		function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/SAZXHUB/Control-update/main/README.md", true))()
		end
	})
	t3.JJ:AddButton({
		Name = t1:traduzir("ShiftLock"),
		Callback = function()
			loadstring(game:HttpGet("https://pastebin.com/raw/N2tiHgyv"))()
		end
	})
	t3.JJ:AddButton({
		t1:traduzir("Pegar Teleport tool"),
		function()
			local mouse = game.Players.LocalPlayer:GetMouse()
			local Tool = Instance.new("Tool")

			Tool.RequiresHandle = false
			Tool.Name = "teleport"
			Tool.Activated:connect(function()
				local v1444 = mouse.Hit + Vector3.new(0, 2.5, 0)

				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v1444.X, v1444.Y, v1444.Z)
			end)
			Tool.Parent = game.Players.LocalPlayer.Backpack
		end
	})
	print("[Flow Hub] loaded - By Lian [flow]")
end)

-- ===== Abas extras portadas (Lian [flow]) - publicas para todos os usuarios =====
task.spawn(function()
local okPort, errPort = pcall(function()
local executor = (identifyexecutor and identifyexecutor()) or "Unknown"
workspace.FallenPartsDestroyHeight = -math.huge
local TrollTab = t3.TT


TrollTab:AddSection({ "Black Hole" })
TrollTab:AddButton({
    Name = "Black Hole",
    Description = " Ativando isso você puxa Parts até o seu personagem",
    Callback = function()
        local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local angle = 1
local radius = 10
local blackHoleActive = false

local function setupPlayer()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local Folder = Instance.new("Folder", Workspace)
    local Part = Instance.new("Part", Folder)
    local Attachment1 = Instance.new("Attachment", Part)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1

    return humanoidRootPart, Attachment1
end

local humanoidRootPart, Attachment1 = setupPlayer()

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(part)
        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, part in pairs(Network.BaseParts) do
                if part:IsDescendantOf(Workspace) then
                    part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(1000000, 1000000, 1000000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 500
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        for _, v in next, Workspace:GetDescendants() do
            ForcePart(v)
        end

        Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)

        spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                angle = angle + math.rad(2)

                local offsetX = math.cos(angle) * radius
                local offsetZ = math.sin(angle) * radius

                Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)
            end
        end)
    else
        Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    humanoidRootPart, Attachment1 = setupPlayer()
    if blackHoleActive then
        toggleBlackHole()
    end
end)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()
local window = library:Window("Lian [flow]")

window:Slider("Radius Blackhole",1,100,10, function(Value)
   radius = Value
end)

window:Toggle("Blackhole", true, function(Value)
       if Value then
            toggleBlackHole()
        else
            blackHoleActive = false
        end
end)

spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        if blackHoleActive then
            angle = angle + math.rad(angleSpeed)
        end
    end
end)

toggleBlackHole()
    end
})


TrollTab:AddSection({ "Puxar Parts" })
TrollTab:AddButton({
    Name = "Puxar Parts",
    Description = "Para usar, chegue perto do Player Selecionado",
    Callback = function()
        -- Gui to Lua
-- Version: 3.2

-- Instances:

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Box = Instance.new("TextBox")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Label = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Button = Instance.new("TextButton")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

--Properties:

Gui.Name = "Gui"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)
Main.Size = UDim2.new(0.240350261, 0, 0.166880623, 0)
Main.Active = true
Main.Draggable = true

Box.Name = "Box"
Box.Parent = Main
Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
Box.BorderSizePixel = 0
Box.Position = UDim2.new(0.0980926454, 0, 0.218712583, 0)
Box.Size = UDim2.new(0.801089942, 0, 0.364963502, 0)
Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Box.PlaceholderText = "Player here"
Box.Text = ""
Box.TextColor3 = Color3.fromRGB(255, 255, 255)
Box.TextScaled = true
Box.TextSize = 31.000
Box.TextWrapped = true

UITextSizeConstraint.Parent = Box
UITextSizeConstraint.MaxTextSize = 31

Label.Name = "Label"
Label.Parent = Main
Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1, 0, 0.160583943, 0)
Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Label.Text = "Bring Parts | Made by: Lian [flow]"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextScaled = true
Label.TextSize = 14.000
Label.TextWrapped = true

UITextSizeConstraint_2.Parent = Label
UITextSizeConstraint_2.MaxTextSize = 21

Button.Name = "Button"
Button.Parent = Main
Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.183284417, 0, 0.656760991, 0)
Button.Size = UDim2.new(0.629427791, 0, 0.277372271, 0)
Button.Font = Enum.Font.Nunito
Button.Text = "Bring | Off"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextSize = 28.000
Button.TextWrapped = true

UITextSizeConstraint_3.Parent = Button
UITextSizeConstraint_3.MaxTextSize = 28

-- Scripts:

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local character
local humanoidRootPart

mainStatus = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		mainStatus = not mainStatus
		Main.Visible = mainStatus
	end
end)

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
	}

	Network.RetainPart = function(Part)
		if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
			table.insert(Network.BaseParts, Part)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			Part.CanCollide = false
		end
	end

	local function EnablePartControl()
		LocalPlayer.ReplicationFocus = Workspace
		RunService.Heartbeat:Connect(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

local function ForcePart(v)
	if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
				x:Destroy()
			end
		end
		if v:FindFirstChild("Attachment") then
			v:FindFirstChild("Attachment"):Destroy()
		end
		if v:FindFirstChild("AlignPosition") then
			v:FindFirstChild("AlignPosition"):Destroy()
		end
		if v:FindFirstChild("Torque") then
			v:FindFirstChild("Torque"):Destroy()
		end
		v.CanCollide = false
		local Torque = Instance.new("Torque", v)
		Torque.Torque = Vector3.new(100000, 100000, 100000)
		local AlignPosition = Instance.new("AlignPosition", v)
		local Attachment2 = Instance.new("Attachment", v)
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = math.huge
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
	end
end

local blackHoleActive = false
local DescendantAddedConnection

local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "Bring Parts | On"
		for _, v in ipairs(Workspace:GetDescendants()) do
			ForcePart(v)
		end

		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive then
				ForcePart(v)
			end
		end)

		spawn(function()
			while blackHoleActive and RunService.RenderStepped:Wait() do
				Attachment1.WorldCFrame = humanoidRootPart.CFrame
			end
		end)
	else
		Button.Text = "Bring Parts | Off"
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
		end
	end
end

local function getPlayer(name)
	local lowerName = string.lower(name)
	for _, p in pairs(Players:GetPlayers()) do
		local lowerPlayer = string.lower(p.Name)
		if string.find(lowerPlayer, lowerName) then
			return p
		elseif string.find(string.lower(p.DisplayName), lowerName) then
			return p
		end
	end
end

local player = nil

local function VDOYZQL_fake_script() -- Box.Script 
	local script = Instance.new('Script', Box)

	script.Parent.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			player = getPlayer(Box.Text)
			if player then
				Box.Text = player.Name
				print("Player found:", player.Name)
			else
				print("Player not found")
			end
		end
	end)
end
coroutine.wrap(VDOYZQL_fake_script)()
local function JUBNQKI_fake_script() -- Button.Script 
	local script = Instance.new('Script', Button)

	script.Parent.MouseButton1Click:Connect(function()
		if player then
			character = player.Character or player.CharacterAdded:Wait()
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
			toggleBlackHole()
		else
			print("Player is not selected")
		end
	end)
end
coroutine.wrap(JUBNQKI_fake_script)()
    end
})

TrollTab:AddSection({ "Invisível" })

TrollTab:AddButton({
    Name = "Ficar Invisível",
    Description = "Ficar invisível FE",
Callback = function()
        
        local args = {
    [1] = {
        [1] = 102344834840946,
        [2] = 70400527171038,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(111858803548721)
local allaccessories = {}

for zxcwefwfecas, xcaefwefas in ipairs({
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.BackAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.FaceAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.FrontAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.NeckAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.HatAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.HairAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.ShouldersAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.WaistAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.GraphicTShirt
}) do
    for scacvdfbdb in string.gmatch(xcaefwefas, "%d+") do
        table.insert(allaccessories, tonumber(scacvdfbdb))
    end
end

wait()

for asdwr,asderg in ipairs(allaccessories) do
    task.spawn(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(asderg)
        print(asderg)
    end)
end
    end
})



local colors = { "Bright red", "Lime green", "Bright blue", "Bright yellow", "Bright cyan", "Hot pink", "Royal purple" }
local rgbEnabled = false

local function changeColor(color)
    local args = { color }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(args))
end

local function toggleRGBCharacter(enabled)
    rgbEnabled = enabled
    if rgbEnabled then
        while rgbEnabled do
            for _, color in ipairs(colors) do
                if not rgbEnabled then return end
                changeColor(color)
                wait(0.5)
            end
        end
    end
end

TrollTab:AddToggle({
    Name = "RGB Character",
    Description = "Deixa seu personagem RGB",
    Default = false,
    Callback = function(value)
        toggleRGBCharacter(value)
    end
})


TrollTab:AddSection({ "Cabelo RGB" })
local hairColors = {
    Color3.new(1, 1, 0), Color3.new(0, 0, 1), Color3.new(1, 0, 1), Color3.new(1, 1, 1),
    Color3.new(0, 1, 0), Color3.new(0.5, 0, 1), Color3.new(1, 0.647, 0), Color3.new(0, 1, 1)
}
local isActive = false


local function changeHairColor()
    local i = 1
    while isActive do
        if not isActive then break end
        local args = { [1] = "ChangeHairColor2", [2] = hairColors[i] }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Max1y"):FireServer(unpack(args))
        wait(0.1)
        i = i % #hairColors + 1
    end
end


TrollTab:AddToggle({
    Name = "Cabelo RGB",
    Description = "Deixa Seu Cabelo RGB",
    Default = false,
    Callback = function(value)
        isActive = value
        if isActive then
            changeHairColor()
        end
    end
})


-- Tab 4: Anti Sit
TrollTab:AddSection({ "Anti Sit" })
TrollTab:AddToggle({
    Name = "Anti Sit",
    Description = "Não Deixa seu personagem Sentar",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local connections = {}
        local runService = game:GetService("RunService")


        local function preventSitting(humanoid)
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                local sitConnection = humanoid.StateChanged:Connect(function(_, newState)
                    if newState == Enum.HumanoidStateType.Seated then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
                table.insert(connections, sitConnection)
            end
        end


        local function monitorCharacter()
            local function onCharacterAdded(character)
                local humanoid = character:WaitForChild("Humanoid")
                preventSitting(humanoid)
            end


            local characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
            table.insert(connections, characterAddedConnection)


            if player.Character then
                onCharacterAdded(player.Character)
            end
        end


        local function resetSitting()
            for _, connection in ipairs(connections) do
                connection:Disconnect()
            end
            connections = {}
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            end
        end


        if Value then
            monitorCharacter()
            local heartbeatConnection = runService.Heartbeat:Connect(function()
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                end
            end)
            table.insert(connections, heartbeatConnection)
        else
            resetSitting()
        end
    end
})

local Troll = t3.TT


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera


local selectedPlayerName = nil
local methodKill = nil
getgenv().Target = nil
local Character = LocalPlayer.Character
local Humanoid = Character and Character:WaitForChild("Humanoid")
local RootPart = Character and Character:WaitForChild("HumanoidRootPart")

-- Função para limpar o sofá (couch)
local function cleanupCouch()
    local char = LocalPlayer.Character
    if char then
        local couch = char:FindFirstChild("Flow.Couch") or LocalPlayer.Backpack:FindFirstChild("Flow.Couch")
        if couch then
            couch:Destroy()
        end
    end
    -- Limpar ferramentas via remoto
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
end

-- Conectar evento CharacterAdded
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    RootPart = newCharacter:WaitForChild("HumanoidRootPart")
    cleanupCouch()
    
    -- Conectar evento Died para o novo Humanoid
    Humanoid.Died:Connect(function()
        cleanupCouch()
    end)
end)

-- Conectar evento Died para o Humanoid inicial, se existir
if Humanoid then
    Humanoid.Died:Connect(function()
        cleanupCouch()
    end)
end

-- Função KillPlayerCouch
local function KillPlayerCouch()
    if not selectedPlayerName then
        warn("Erro: Nenhum jogador selecionado")
        return
    end
    local target = Players:FindFirstChild(selectedPlayerName)
    if not target or not target.Character then
        warn("Erro: Jogador alvo não encontrado ou sem personagem")
        return
    end

    local char = LocalPlayer.Character
    if not char then
        warn("Erro: Personagem do jogador local não encontrado")
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or not tRoot then
        warn("Erro: Componentes necessários não encontrados")
        return
    end

    local originalPos = root.Position 
    local sitPos = Vector3.new(145.51, -350.09, 21.58)

    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
    task.wait(0.2)

    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    task.wait(0.3)

    local tool = LocalPlayer.Backpack:FindFirstChild("Couch")
    if tool then tool.Parent = char end
    task.wait(0.1)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    hum.PlatformStand = false
    cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum

    local align = Instance.new("BodyPosition")
    align.Name = "BringPosition"
    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    align.D = 10
    align.P = 30000
    align.Position = root.Position
    align.Parent = tRoot

    task.spawn(function()
        local angle = 0
        local startTime = tick()
        while tick() - startTime < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Sit then break end

            local hrp = target.Character.HumanoidRootPart
            local adjustedPos = hrp.Position + (hrp.Velocity / 1.5)

            angle += 50
            root.CFrame = CFrame.new(adjustedPos + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(angle), 0, 0)
            align.Position = root.Position + Vector3.new(2, 0, 0)

            task.wait()
        end

        align:Destroy()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum.PlatformStand = false
        cam.CameraSubject = hum

        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.zero
                p.RotVelocity = Vector3.zero
            end
        end

        task.wait(0.1)
        root.CFrame = CFrame.new(sitPos)
        task.wait(0.3)

        local tool = char:FindFirstChild("Couch")
        if tool then tool.Parent = LocalPlayer.Backpack end

        task.wait(0.01)
        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
        task.wait(0.2)
        root.CFrame = CFrame.new(originalPos)
    end)
end

-- Função BringPlayerLLL
local function BringPlayerLLL()
    if not selectedPlayerName then
        warn("Erro: Nenhum jogador selecionado")
        return
    end
    local target = Players:FindFirstChild(selectedPlayerName)
    if not target or not target.Character then
        warn("Erro: Jogador alvo não encontrado ou sem personagem")
        return
    end

    local char = LocalPlayer.Character
    if not char then
        warn("Erro: Personagem do jogador local não encontrado")
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or not tRoot then
        warn("Erro: Componentes necessários não encontrados")
        return
    end

    local originalPos = root.Position 
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
    task.wait(0.2)

    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    task.wait(0.3)

    local tool = LocalPlayer.Backpack:FindFirstChild("Couch")
    if tool then
        tool.Parent = char
    end
    task.wait(0.1)

    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)

    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    hum.PlatformStand = false
    cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum

    local align = Instance.new("BodyPosition")
    align.Name = "BringPosition"
    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    align.D = 10
    align.P = 30000
    align.Position = root.Position
    align.Parent = tRoot

    task.spawn(function()
        local angle = 0
        local startTime = tick()
        while tick() - startTime < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Sit then break end

            local hrp = target.Character.HumanoidRootPart
            local adjustedPos = hrp.Position + (hrp.Velocity / 1.5)

            angle += 50
            root.CFrame = CFrame.new(adjustedPos + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(angle), 0, 0)
            align.Position = root.Position + Vector3.new(2, 0, 0)

            task.wait()
        end

        align:Destroy()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum.PlatformStand = false
        cam.CameraSubject = hum

        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Velocity = Vector3.zero
                p.RotVelocity = Vector3.zero
            end
        end

        task.wait(0.1)
        root.Anchored = true
        root.CFrame = CFrame.new(originalPos)
        task.wait(0.001)
        root.Anchored = false

        task.wait(0.7)
        local tool = char:FindFirstChild("Couch")
        if tool then
            tool.Parent = LocalPlayer.Backpack
        end

        task.wait(0.001)
        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    end)
end

-- Função BringWithCouch
local function BringWithCouch()
    local targetPlayer = Players:FindFirstChild(getgenv().Target)
    if not targetPlayer then
        warn("Erro: Nenhum jogador alvo selecionado")
        return
    end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("Erro: Jogador alvo sem personagem ou HumanoidRootPart")
        return
    end

    local args = { [1] = "ClearAllTools" }
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))
    local args = { [1] = "PickingTools", [2] = "Couch" }
    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)
    if not couch then
        warn("Erro: Sofá não encontrado no Backpack")
        return
    end

    couch.Name = "Flow.Couch"
    local seat1 = couch:FindFirstChild("Seat1")
    local seat2 = couch:FindFirstChild("Seat2")
    local handle = couch:FindFirstChild("Handle")
    if seat1 and seat2 and handle then
        seat1.Disabled = true
        seat2.Disabled = true
        handle.Name = "Handle "
    else
        warn("Erro: Componentes do sofá não encontrados")
        return
    end
    couch.Parent = LocalPlayer.Character

    local tet = Instance.new("BodyVelocity", seat1)
    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    tet.P = 1250
    tet.Velocity = Vector3.new(0, 0, 0)
    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    repeat
        for m = 1, 35 do
            local pos = { x = 0, y = 0, z = 0 }
            local tRoot = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart
            if not tRoot then break end
            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)
            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)
            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)
            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)
            task.wait()
        end
        tet:Destroy()
        couch.Parent = LocalPlayer.Backpack
        task.wait()
        couch:FindFirstChild("Handle ").Name = "Handle"
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        task.wait()
        couch.Parent = LocalPlayer.Backpack
        couch.Handle.Name = "Handle "
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        tet = Instance.new("BodyVelocity", seat1)
        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0, 0, 0)
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
    until targetPlayer.Character and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Sit == true
    task.wait()
    tet:Destroy()
    couch.Parent = LocalPlayer.Backpack
    task.wait()
    couch:FindFirstChild("Handle ").Name = "Handle"
    task.wait(0.3)
    couch.Parent = LocalPlayer.Character
    task.wait(0.3)
    couch.Grip = CFrame.new(Vector3.new(0, 0, 0))
    task.wait(0.3)
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
end

-- Função KillWithCouch
local function KillWithCouch()
    local targetPlayer = Players:FindFirstChild(getgenv().Target)
    if not targetPlayer then
        warn("Erro: Nenhum jogador alvo selecionado")
        return
    end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("Erro: Jogador alvo sem personagem ou HumanoidRootPart")
        return
    end

    local args = { [1] = "ClearAllTools" }
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))
    local args = { [1] = "PickingTools", [2] = "Couch" }
    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)
    if not couch then
        warn("Erro: Sofá não encontrado no Backpack")
        return
    end

    couch.Name = "Flow.Couch"
    local seat1 = couch:FindFirstChild("Seat1")
    local seat2 = couch:FindFirstChild("Seat2")
    local handle = couch:FindFirstChild("Handle")
    if seat1 and seat2 and handle then
        seat1.Disabled = true
        seat2.Disabled = true
        handle.Name = "Handle "
    else
        warn("Erro: Componentes do sofá não encontrados")
        return
    end
    couch.Parent = LocalPlayer.Character

    local tet = Instance.new("BodyVelocity", seat1)
    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    tet.P = 1250
    tet.Velocity = Vector3.new(0, 0, 0)
    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    repeat
        for m = 1, 35 do
            local pos = { x = 0, y = 0, z = 0 }
            local tRoot = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart
            if not tRoot then break end
            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)
            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)
            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)
            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)
            task.wait()
        end
        tet:Destroy()
        couch.Parent = LocalPlayer.Backpack
        task.wait()
        couch:FindFirstChild("Handle ").Name = "Handle"
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        task.wait()
        couch.Parent = LocalPlayer.Backpack
        couch.Handle.Name = "Handle "
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        tet = Instance.new("BodyVelocity", seat1)
        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0, 0, 0)
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
    until targetPlayer.Character and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Sit == true
    task.wait()
    couch.Parent = LocalPlayer.Backpack
    seat1.CFrame = CFrame.new(Vector3.new(9999, -450, 9999))
    seat2.CFrame = CFrame.new(Vector3.new(9999, -450, 9999))
    couch.Parent = LocalPlayer.Character
    task.wait(0.1)
    couch.Parent = LocalPlayer.Backpack
    task.wait(2)
    local bv = seat1:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W")
    if bv then bv:Destroy() end
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
end
    local PlayerSection = Troll:AddSection({ Name = "Troll Player" })

    -- Função para obter lista de jogadores
    local function getPlayerList()
        local players = Players:GetPlayers()
        local playerNames = {}
        for _, player in ipairs(players) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        return playerNames
    end

    local killDropdown = Troll:AddDropdown({
        Name = "Selecionar Jogador",
        Options = getPlayerList(),
        Default = "",
        Callback = function(value)
            selectedPlayerName = value
            getgenv().Target = value
            print("Jogador selecionado: " .. tostring(value))
        end
    })

    Troll:AddButton({
        Name = "Atualizar Player List",
        Callback = function()
            local tablePlayers = Players:GetPlayers()
            local newPlayers = {}
            if killDropdown and #tablePlayers > 0 then
                for _, player in ipairs(tablePlayers) do
                    if player.Name ~= LocalPlayer.Name then
                        table.insert(newPlayers, player.Name)
                    end
                end
                killDropdown:Set(newPlayers)
                print("Lista de jogadores atualizada: ", table.concat(newPlayers, ", "))
                if selectedPlayerName and not Players:FindFirstChild(selectedPlayerName) then
                    selectedPlayerName = nil
                    getgenv().Target = nil
                    killDropdown:SetValue("")
                    print("Seleção resetada, jogador não está mais no servidor.")
                end
            else
                print("Erro: Dropdown não encontrado ou nenhum jogador disponível.")
            end
        end
    })

    Troll:AddButton({
        Name = "Teleportar até o Player",
        Callback = function()
            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then
                print("Erro: Player não selecionado ou não existe")
                return
            end
            local character = LocalPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                warn("Erro: HumanoidRootPart do jogador local não encontrado")
                return
            end

            local targetPlayer = Players:FindFirstChild(selectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            else
                print("Erro: Player alvo não encontrado ou sem HumanoidRootPart")
            end
        end
    })

    Troll:AddToggle({
        Name = "Spectar Player",
        Default = false,
        Callback = function(value)
            local Camera = workspace.CurrentCamera

            local function UpdateCamera()
                if value then
                    local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                    if targetPlayer and targetPlayer.Character then
                        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            Camera.CameraSubject = humanoid
                        end
                    end
                else
                    if LocalPlayer.Character then
                        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            Camera.CameraSubject = humanoid
                        end
                    end
                end
            end

            if value then
                if not getgenv().CameraConnection then
                    getgenv().CameraConnection = RunService.Heartbeat:Connect(UpdateCamera)
                end
            else
                if getgenv().CameraConnection then
                    getgenv().CameraConnection:Disconnect()
                    getgenv().CameraConnection = nil
                end
                UpdateCamera()
            end
        end
    })

    local MethodSection = Troll:AddSection({ Name = "Métodos" })

    Troll:AddDropdown({
        Name = "Selecionar Método para Matar",
        Options = {"Bus", "Couch", "Couch Sem ir até o alvo [BETA]"},
        Default = "",
        Callback = function(value)
            methodKill = value
            print("Método selecionado: " .. tostring(value))
        end
    })

    Troll:AddButton({
        Name = "Matar Player",
        Callback = function()
            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then
                print("Erro: Player não selecionado ou não existe")
                return
            end
            if methodKill == "Couch" then
                KillPlayerCouch()
            elseif methodKill == "Couch Sem ir até o alvo [BETA]" then
                KillWithCouch()
            else
                -- Método de ônibus
                local character = LocalPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    warn("Erro: HumanoidRootPart do jogador local não encontrado")
                    return
                end

                local originalPosition = humanoidRootPart.CFrame

                local function GetBus()
                    local vehicles = game.Workspace:FindFirstChild("Vehicles")
                    if vehicles then
                        return vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
                    end
                    return nil
                end

                local bus = GetBus()

                if not bus then
                    humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
                    task.wait(0.5)
                    local remoteEvent = ReplicatedStorage:FindFirstChild("RE")
                    if remoteEvent and remoteEvent:FindFirstChild("1Ca1r") then
                        remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
                    end
                    task.wait(1)
                    bus = GetBus()
                end

                if bus then
                    local seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")
                    if seat and character:FindFirstChildOfClass("Humanoid") and not character.Humanoid.Sit then
                        repeat
                            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                            task.wait()
                        until character.Humanoid.Sit or not bus.Parent
                        if character.Humanoid.Sit or not bus.Parent then
                            for k, v in pairs(bus.Body:GetChildren()) do
                                if v:IsA("Seat") then
                                    v.CanTouch = false
                                end
                            end
                        end
                    end
                end

                local function TrackPlayer()
                    while true do
                        if selectedPlayerName then
                            local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if targetHumanoid and targetHumanoid.Sit then
                                    if character.Humanoid then
                                        bus:SetPrimaryPartCFrame(CFrame.new(Vector3.new(9999, -450, 9999)))
                                        print("Jogador sentou, levando ônibus para o void!")
                                        task.wait(0.2)

                                        local function simulateJump()
                                            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                                            if humanoid then
                                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                            end
                                        end

                                        simulateJump()
                                        print("Simulando pulo!")
                                        task.wait(0.5)
                                        humanoidRootPart.CFrame = originalPosition
                                        print("Player voltou para a posição inicial.")
                                    end
                                    break
                                else
                                    local targetRoot = targetPlayer.Character.HumanoidRootPart
                                    local time = tick() * 35
                                    local lateralOffset = math.sin(time) * 4
                                    local frontBackOffset = math.cos(time) * 20
                                    bus:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))
                                end
                            end
                        end
                        RunService.RenderStepped:Wait()
                    end
                end

                spawn(TrackPlayer)
            end
        end
    })

    Troll:AddButton({
        Name = "Puxar Player",
        Callback = function()
            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then
                print("Erro: Player não selecionado ou não existe")
                return
            end
            if methodKill == "Couch" then
                BringPlayerLLL()
            elseif methodKill == "Couch Sem ir até o alvo [BETA]" then
                BringWithCouch()
            else
                -- Método de ônibus
                local character = LocalPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    warn("Erro: HumanoidRootPart do jogador local não encontrado")
                    return
                end

                local originalPosition = humanoidRootPart.CFrame

                local function GetBus()
                    local vehicles = game.Workspace:FindFirstChild("Vehicles")
                    if vehicles then
                        return vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
                    end
                    return nil
                end

                local bus = GetBus()

                if not bus then
                    humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
                    task.wait(0.5)
                    local remoteEvent = ReplicatedStorage:FindFirstChild("RE")
                    if remoteEvent and remoteEvent:FindFirstChild("1Ca1r") then
                        remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
                    end
                    task.wait(1)
                    bus = GetBus()
                end

                if bus then
                    local seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")
                    if seat and character:FindFirstChildOfClass("Humanoid") and not character.Humanoid.Sit then
                        repeat
                            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                            task.wait()
                        until character.Humanoid.Sit or not bus.Parent
                    end
                end

                local function TrackPlayer()
                    while true do
                        if selectedPlayerName then
                            local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if targetHumanoid and targetHumanoid.Sit then
                                    if character.Humanoid then
                                        bus:SetPrimaryPartCFrame(originalPosition)
                                        task.wait(0.7)
                                        local args = { [1] = "DeleteAllVehicles" }
                                        ReplicatedStorage.RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
                                    end
                                    break
                                else
                                    local targetRoot = targetPlayer.Character.HumanoidRootPart
                                    local time = tick() * 35
                                    local lateralOffset = math.sin(time) * 4
                                    local frontBackOffset = math.cos(time) * 20
                                    bus:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))
                                end
                            end
                        end
                        RunService.RenderStepped:Wait()
                    end
                end

                spawn(TrackPlayer)
            end
        end
    })


local function houseBanKill()
    if not selectedPlayerName then
        print("Nenhum jogador selecionado!")
        return
    end

    local Player = game.Players.LocalPlayer
    local Backpack = Player.Backpack
    local Character = Player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Houses = game.Workspace:FindFirstChild("001_Lots")
    local OldPos = RootPart.CFrame
    local Angles = 0
    local Vehicles = Workspace.Vehicles
    local Pos

    function Check()
        if Player and Character and Humanoid and RootPart and Vehicles then
            return true
        else
            return false
        end
    end

    local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)
    if selectedPlayer and selectedPlayer.Character then
        if Check() then
            local House = Houses:FindFirstChild(Player.Name .. "House")
            if not House then
                local EHouse
                local availableHouses = {}
                
                -- Coletar todas as casas disponÃ­veis ("For Sale")
                for _, Lot in pairs(Houses:GetChildren()) do
                    if Lot.Name == "For Sale" then
                        for _, num in pairs(Lot:GetDescendants()) do
                            if num:IsA("NumberValue") and num.Name == "Number" and num.Value < 25 and num.Value > 10 then
                                table.insert(availableHouses, {Lot = Lot, Number = num.Value})
                                break
                            end
                        end
                    end
                end

                -- Escolher uma casa aleatÃ³ria da lista
                if #availableHouses > 0 then
                    local randomHouse = availableHouses[math.random(1, #availableHouses)]
                    EHouse = randomHouse.Lot
                    local houseNumber = randomHouse.Number

                    -- Teleportar para o BuyDetector e clicar
                    local BuyDetector = EHouse:FindFirstChild("BuyHouse")
                    Pos = BuyDetector.Position
                    if BuyDetector and BuyDetector:IsA("BasePart") then
                        RootPart.CFrame = BuyDetector.CFrame + Vector3.new(0, -6, 0)
                        task.wait(0.5)
                        local ClickDetector = BuyDetector:FindFirstChild("ClickDetector")
                        if ClickDetector then
                            fireclickdetector(ClickDetector)
                        end
                    end

                    -- Disparar o novo remote event para construir a casa
                    task.wait(0.5)
                    local args = {
                        houseNumber, -- NÃºmero da casa aleatÃ³ria
                        "056_House" -- Tipo da casa
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Lot:BuildProperty"):FireServer(unpack(args))
                else
                    print("Nenhuma casa disponÃ­vel para compra!")
                    return
                end
            end

            task.wait(0.5)
            local PreHouse = Houses:FindFirstChild(Player.Name .. "House")
            if PreHouse then
                task.wait(0.5)
                local Number
                for i, x in pairs(PreHouse:GetDescendants()) do
                    if x.Name == "Number" and x:IsA("NumberValue") then
                        Number = x
                    end
                end
                task.wait(0.5)
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gettin1gHous1e"):FireServer("PickingCustomHouse", "049_House", Number.Value)
            end

            task.wait(0.5)
            local PCar = Vehicles:FindFirstChild(Player.Name .. "Car")
            if not PCar then
                if Check() then
                    RootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingCar", "SchoolBus")
                    task.wait(0.5)
                    local PCar = Vehicles:FindFirstChild(Player.Name .. "Car")
                    task.wait(0.5)
                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
                    if Seat then
                        repeat
                            task.wait()
                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
                        until Humanoid.Sit
                    end
                end
            end

            task.wait(0.5)
            local PCar = Vehicles:FindFirstChild(Player.Name .. "Car")
            if PCar then
                if not Humanoid.Sit then
                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
                    if Seat then
                        repeat
                            task.wait()
                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
                        until Humanoid.Sit
                    end
                end

                local Target = selectedPlayer
                local TargetC = Target.Character
                local TargetH = TargetC:FindFirstChildOfClass("Humanoid")
                local TargetRP = TargetC:FindFirstChild("HumanoidRootPart")
                if TargetC and TargetH and TargetRP then
                    if not TargetH.Sit then
                        while not TargetH.Sit do
                            task.wait()
                            local Fling = function(alvo, pos, angulo)
                                PCar:SetPrimaryPartCFrame(CFrame.new(alvo.Position) * pos * angulo)
                            end
                            Angles = Angles + 100
                            Fling(TargetRP, CFrame.new(0, 1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                            Fling(TargetRP, CFrame.new(0, -1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                            Fling(TargetRP, CFrame.new(2.25, 1.5, -2.25) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                            Fling(TargetRP, CFrame.new(-2.25, -1.5, 2.25) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                            Fling(TargetRP, CFrame.new(0, 1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                            Fling(TargetRP, CFrame.new(0, -1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        end
                        task.wait(0.2)
                        local House = Houses:FindFirstChild(Player.Name .. "House")
                        PCar:SetPrimaryPartCFrame(CFrame.new(House.HouseSpawnPosition.Position))
                        task.wait(0.2)
                        local pedro = Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(30, 30, 30), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(30, 30, 30))
                        local a = workspace:FindPartsInRegion3(pedro, game.Players.LocalPlayer.Character.HumanoidRootPart, math.huge)
                        for i, v in pairs(a) do
                            if v.Name == "HumanoidRootPart" then
                                local b = game:GetService("Players"):FindFirstChild(v.Parent.Name)
                                local args = {
                                    [1] = "BanPlayerFromHouse",
                                    [2] = b,
                                    [3] = v.Parent
                                }
                                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Playe1rTrigge1rEven1t"):FireServer(unpack(args))
                                local args = {
                                    [1] = "DeleteAllVehicles"
                                }
                                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
                            end
                        end
                    end
                end
            end
        end
    end
end

Troll:AddButton({
    Name = "House Ban Kill",
    Callback = houseBanKill
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local cam = workspace.CurrentCamera
local currentPlayers, selectedPlayer = {}, nil
local viewing = false
local flingActive = false

Troll:AddToggle({
    Name = "Auto Fling ",
    Default = false,
    Callback = function(state)

        flingActive = state
        if state and selectedPlayerName then
            local target = Players:FindFirstChild(selectedPlayerName)
            if not target or not target.Character then return end
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not root or not tRoot then return end
            local char = LocalPlayer.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local original = root.CFrame

local args = {
	"ClearAllTools"
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))

task.wait(0.2)


            local args = {
                [1] = "PickingTools",
                [2] = "Couch"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

            task.wait(0.3)
            local tool = LocalPlayer.Backpack:FindFirstChild("Couch")
            if tool then
                tool.Parent = char
            end
				task.wait(0.2)
				game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
task.wait(0.25)

            workspace.FallenPartsDestroyHeight = 0/0
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlingForce"
            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
            bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
            bv.Parent = root
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hum.PlatformStand = false
            cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum

            task.spawn(function()
                local angle = 0
                local parts = {root}
                while flingActive and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
                    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
                    if tHum.Sit then break end
                    angle += 50

                    for _, part in ipairs(parts) do
                        local pos_x = target.Character.HumanoidRootPart.Position.X
                        local pos_y = target.Character.HumanoidRootPart.Position.Y
                        local pos_z = target.Character.HumanoidRootPart.Position.Z
                        pos_x = pos_x + (target.Character.HumanoidRootPart.Velocity.X / 1.5)
                        pos_y = pos_y + (target.Character.HumanoidRootPart.Velocity.Y / 1.5)
                        pos_z = pos_z + (target.Character.HumanoidRootPart.Velocity.Z / 1.5)
                        root.CFrame = CFrame.new(pos_x, pos_y, pos_z) * CFrame.Angles(math.rad(angle), 0, 0)
                    end

                    root.Velocity = Vector3.new(9e8, 9e8, 9e8)
                    root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                    task.wait()
                end
                flingActive = false
                bv:Destroy()
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                hum.PlatformStand = false
                root.CFrame = original
                cam.CameraSubject = hum
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Velocity = Vector3.zero
                        p.RotVelocity = Vector3.zero
                    end
                end
                hum:UnequipTools()
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            end)
        end
    end
})


local function FlingBall(target)

    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local backpack = player:WaitForChild("Backpack")
    local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

    local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") then
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
        end
        repeat task.wait() until backpack:FindFirstChild("SoccerBall")
        backpack.SoccerBall.Parent = character
        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. player.Name)
        character.SoccerBall.Parent = backpack
        return ServerBalls:FindFirstChild("Soccer" .. player.Name)
    end

    local Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name) or GetBall()
    Ball.CanCollide = false
    Ball.Massless = true
    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

    if target ~= player then
        local tchar = target.Character
        if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
            local troot = tchar.HumanoidRootPart
            local thum = tchar.Humanoid

            if Ball:FindFirstChildWhichIsA("BodyVelocity") then
                Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy()
            end

            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlingPower"
            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 9e900
            bv.Parent = Ball

            workspace.CurrentCamera.CameraSubject = thum
            local StartTime = os.time()
            repeat
                if troot.Velocity.Magnitude > 0 then
                -- Cálculo da posição ajustada com base na velocidade do alvo
                local pos_x = troot.Position.X + (troot.Velocity.X / 1.5)
                local pos_y = troot.Position.Y + (troot.Velocity.Y / 1.5)
                local pos_z = troot.Position.Z + (troot.Velocity.Z / 1.5)

                -- Posiciona a bola diretamente na posição ajustada
                local position = Vector3.new(pos_x, pos_y, pos_z)
                Ball.CFrame = CFrame.new(position)
                Ball.Orientation += Vector3.new(45, 60, 30)
else
for i, v in pairs(tchar:GetChildren()) do
if v:IsA("BasePart") and v.CanCollide and not v.Anchored then
Ball.CFrame = v.CFrame
task.wait(1/6000)
end
end
end
                task.wait(1/6000)
            until troot.Velocity.Magnitude > 1000 or thum.Health <= 0 or not tchar:IsDescendantOf(workspace) or target.Parent ~= players
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

Troll:AddButton({
    Name = "Fling Ball",
    Callback = function()
        FlingBall(game:GetService("Players")[selectedPlayerName])
    end
})

local Players = game:GetService('Players')
local lplayer = Players.LocalPlayer

local function isItemInInventory(itemName)
    for _, item in pairs(lplayer.Backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    return false
end

local function equipItem(itemName)
    local item = lplayer.Backpack:FindFirstChild(itemName)
    if item then
        lplayer.Character.Humanoid:EquipTool(item)
    end
end

local function unequipItem(itemName)
    local item = lplayer.Character:FindFirstChild(itemName)
    if item then
        item.Parent = lplayer.Backpack
    end
end

local function ActiveAutoFling(targetPlayer)
    if not isItemInInventory("Couch") then
        local args = { [1] = "PickingTools", [2] = "Couch" }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
    end

    equipItem("Couch")
    getgenv().flingloop = true

    while getgenv().flingloop do
        local function flingloopfix()
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local AllBool = false

            local SkidFling = function(TargetPlayer)
                local Character = Player.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Humanoid and Humanoid.RootPart
                local TCharacter = TargetPlayer.Character
                local THumanoid, TRootPart, THead, Accessory, Handle

                if TCharacter:FindFirstChildOfClass("Humanoid") then
                    THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
                end
                if THumanoid and THumanoid.RootPart then
                    TRootPart = THumanoid.RootPart
                end
                if TCharacter:FindFirstChild("Head") then
                    THead = TCharacter.Head
                end
                if TCharacter:FindFirstChildOfClass("Accessory") then
                    Accessory = TCharacter:FindFirstChildOfClass("Accessory")
                end
                if Accessory and Accessory:FindFirstChild("Handle") then
                    Handle = Accessory.Handle
                end

                if Character and Humanoid and RootPart then
                    if RootPart.Velocity.Magnitude < 50 then
                        getgenv().OldPos = RootPart.CFrame
                    end
                    if THumanoid and THumanoid.Sit and not AllBool then
                        unequipItem("Couch")
                        getgenv().flingloop = false
                        return
                    end
                    if THead then
                        workspace.CurrentCamera.CameraSubject = THead
                    elseif not THead and Handle then
                        workspace.CurrentCamera.CameraSubject = Handle
                    elseif THumanoid and TRootPart then
                        workspace.CurrentCamera.CameraSubject = THumanoid
                    end

                    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                        return
                    end

                    local FPos = function(BasePart, Pos, Ang)
                        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                    end

                    local SFBasePart = function(BasePart)
                        local TimeToWait = 2
                        local Time = tick()
                        local Angle = 0
                        repeat
                            if RootPart and THumanoid then
                                if BasePart.Velocity.Magnitude < 50 then
                                    Angle = Angle + 100
                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                                    task.wait()
                                else
                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                                    task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                    task.wait()
                                end
                            else
                                break
                            end
                        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait or getgenv().flingloop == false
                    end

                    workspace.FallenPartsDestroyHeight = 0/0
                    local BV = Instance.new("BodyVelocity")
                    BV.Name = "SpeedDoPai"
                    BV.Parent = RootPart
                    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                    if TRootPart and THead then
                        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                            SFBasePart(THead)
                        else
                            SFBasePart(TRootPart)
                        end
                    elseif TRootPart and not THead then
                        SFBasePart(TRootPart)
                    elseif not TRootPart and THead then
                        SFBasePart(THead)
                    elseif not TRootPart and not THead and Accessory and Handle then
                        SFBasePart(Handle)
                    end
                    BV:Destroy()
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    workspace.CurrentCamera.CameraSubject = Humanoid

                    repeat
                        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                        Humanoid:ChangeState("GettingUp")
                        table.foreach(Character:GetChildren(), function(_, x)
                            if x:IsA("BasePart") then
                                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                            end
                        end)
                        task.wait()
                    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25

                    workspace.FallenPartsDestroyHeight = getgenv().FPDH
                end
            end

            if AllBool then
                for _, x in next, Players:GetPlayers() do
                    SkidFling(x)
                end
            end

            if targetPlayer then
                SkidFling(targetPlayer)
            end

            task.wait()
        end

        wait()
        pcall(flingloopfix)
    end
end

local kill = Troll:AddSection({Name = "Fling Boat"})

Troll:AddButton({
    Name = "Fling - Boat",
    Callback = function()
        if not selectedPlayerName or not game.Players:FindFirstChild(selectedPlayerName) then
            warn("Nenhum jogador selecionado ou não existe")
            return
        end

        local Player = game.Players.LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local Vehicles = game.Workspace:FindFirstChild("Vehicles")

        if not Humanoid or not RootPart then
            warn("Humanoid ou RootPart inválido")
            return
        end

        local function spawnBoat()
            RootPart.CFrame = CFrame.new(1754, -2, 58)
            task.wait(0.5)
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
            task.wait(1)
            return Vehicles:FindFirstChild(Player.Name.."Car")
        end

        local PCar = Vehicles:FindFirstChild(Player.Name.."Car") or spawnBoat()
        if not PCar then
            warn("Falha ao spawnar o barco")
            return
        end

        local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
        if not Seat then
            warn("Assento não encontrado")
            return
        end

        repeat 
            task.wait(0.1)
            RootPart.CFrame = Seat.CFrame * CFrame.new(0, 1, 0)
        until Humanoid.SeatPart == Seat

        print("Barco spawnado!")

        local TargetPlayer = game.Players:FindFirstChild(selectedPlayerName)
        if not TargetPlayer or not TargetPlayer.Character then
            warn("Jogador não encontrado")
            return
        end

        local TargetC = TargetPlayer.Character
        local TargetH = TargetC:FindFirstChildOfClass("Humanoid")
        local TargetRP = TargetC:FindFirstChild("HumanoidRootPart")

        if not TargetRP or not TargetH then
            warn("Humanoid ou RootPart do alvo não encontrado")
            return
        end

        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = PCar.PrimaryPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 369, 0) 

        print("Fling ativo!")

        local function moveCar(TargetRP, offset)
            if PCar and PCar.PrimaryPart then
                PCar:SetPrimaryPartCFrame(CFrame.new(TargetRP.Position + offset))
            end
        end

        task.spawn(function()
            while PCar and PCar.Parent and TargetRP and TargetRP.Parent do
                task.wait(0.01) 
                
                moveCar(TargetRP, Vector3.new(0, 1, 0))  
                moveCar(TargetRP, Vector3.new(0, -2.25, 5))  
                moveCar(TargetRP, Vector3.new(0, 2.25, 0.25))  
                moveCar(TargetRP, Vector3.new(-2.25, -1.5, 2.25))  
                moveCar(TargetRP, Vector3.new(0, 1.5, 0))  
                moveCar(TargetRP, Vector3.new(0, -1.5, 0))  

                if PCar and PCar.PrimaryPart then
                    local Rotation = CFrame.Angles(
                        math.rad(math.random(-369, 369)),  
                        math.rad(math.random(-369, 369)), 
                        math.rad(math.random(-369, 369))
                    )
                    PCar:SetPrimaryPartCFrame(CFrame.new(TargetRP.Position + Vector3.new(0, 1.5, 0)) * Rotation)
                end
            end

            if Spin and Spin.Parent then
                Spin:Destroy()
                print("Fling desativado")
            end
        end)
    end
})
print("Fling - Boat button created")

Troll:AddButton({
    Name = "Desligar Fling - Boat",
    Callback = function()
        local Player = game.Players.LocalPlayer
        local Character = Player.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Vehicles = game.Workspace:FindFirstChild("Vehicles")

        if not RootPart or not Humanoid then
            warn("Nenhum RootPart ou Humanoid encontrado!")
            return
        end

        Humanoid.PlatformStand = true
        print("Jogador paralisado para reduzir efeitos do spin.")

        for _, obj in pairs(RootPart:GetChildren()) do
            if obj:IsA("BodyAngularVelocity") or obj:IsA("BodyVelocity") then
                obj:Destroy()
            end
        end
        print("Spin e forças removidas do jogador.")

        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles")
        task.wait(0.5)

        local PCar = Vehicles and Vehicles:FindFirstChild(Player.Name.."Car")
        if PCar and PCar.PrimaryPart then
            for _, obj in pairs(PCar.PrimaryPart:GetChildren()) do
                if obj:IsA("BodyAngularVelocity") or obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
            print("Spin removido do barco.")
        end

        task.wait(1)

        local safePos = Vector3.new(0, 1000, 0)
        local bp = Instance.new("BodyPosition", RootPart)
        bp.Position = safePos
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        local bg = Instance.new("BodyGyro", RootPart)
        bg.CFrame = RootPart.CFrame
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

        print("Jogador está preso na coordenada segura.")

        task.wait(3)

        bp:Destroy()
        bg:Destroy()
        Humanoid.PlatformStand = false

        print("Jogador liberado, seguro na posição.")
    end
})

local kill = Troll:AddSection({Name = "Click Kill Methods"})

Troll:AddButton({
  Name = "Click Fling Portas [Beta]",
Description = "Para Usar, Recomendo chegar perto de outras portas, apos ela ir até você, clique no jogador que deseja flingar",
  Callback = function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Alvo invisível (BlackHole)
local BlackHole = Instance.new("Part")
BlackHole.Size = Vector3.new(100000, 100000, 100000)
BlackHole.Transparency = 1
BlackHole.Anchored = true
BlackHole.CanCollide = false
BlackHole.Name = "BlackHoleTarget"
BlackHole.Parent = Workspace

-- Attachment base no BlackHole
local baseAttachment = Instance.new("Attachment")
baseAttachment.Name = "Lian_BlackHoleAttachment"
baseAttachment.Parent = BlackHole

-- Atualiza posição do BlackHole
RunService.Heartbeat:Connect(function()
	BlackHole.CFrame = HRP.CFrame
end)

-- Lista de portas controladas
local ControlledDoors = {}

-- Prepara uma porta para ser controlada
local function SetupPart(part)
	if not part:IsA("BasePart") or part.Anchored or not string.find(part.Name, "Door") then return end
	if part:FindFirstChild("Lian_Attached") then return end

	part.CanCollide = false

	for _, obj in ipairs(part:GetChildren()) do
		if obj:IsA("AlignPosition") or obj:IsA("Torque") or obj:IsA("Attachment") then
			obj:Destroy()
		end
	end

	local marker = Instance.new("BoolValue", part)
	marker.Name = "Lian_Attached"

	local a1 = Instance.new("Attachment", part)

	local align = Instance.new("AlignPosition", part)
	align.Attachment0 = a1
	align.Attachment1 = baseAttachment
	align.MaxForce = 1e20
	align.MaxVelocity = math.huge
	align.Responsiveness = 99999

	local torque = Instance.new("Torque", part)
	torque.Attachment0 = a1
	torque.RelativeTo = Enum.ActuatorRelativeTo.World
	torque.Torque = Vector3.new(
		math.random(-10e5, 10e5) * 10000,
		math.random(-10e5, 10e5) * 10000,
		math.random(-10e5, 10e5) * 10000
	)

	table.insert(ControlledDoors, {Part = part, Align = align})
end

-- Detecta e prepara portas existentes
for _, obj in ipairs(Workspace:GetDescendants()) do
	if obj:IsA("BasePart") and string.find(obj.Name, "Door") then
		SetupPart(obj)
	end
end

-- Novas portas no futuro
Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and string.find(obj.Name, "Door") then
		SetupPart(obj)
	end
end)

-- Flinga jogador com timeout e retorno
local function FlingPlayer(player)
	local char = player.Character
	if not char then return end
	local targetHRP = char:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local targetAttachment = targetHRP:FindFirstChild("SHNMAX_TargetAttachment")
	if not targetAttachment then
		targetAttachment = Instance.new("Attachment", targetHRP)
		targetAttachment.Name = "SHNMAX_TargetAttachment"
	end

	for _, data in ipairs(ControlledDoors) do
		if data.Align then
			data.Align.Attachment1 = targetAttachment
		end
	end

	local start = tick()
	local flingDetected = false

	while tick() - start < 5 do
		if targetHRP.Velocity.Magnitude >= 20 then
			flingDetected = true
			break
		end
		RunService.Heartbeat:Wait()
	end

	-- Sempre retorna as portas
	for _, data in ipairs(ControlledDoors) do
		if data.Align then
			data.Align.Attachment1 = baseAttachment
		end
	end
end

-- Clique (funciona no mobile)
UserInputService.TouchTap:Connect(function(touchPositions, processed)
	if processed then return end
	local pos = touchPositions[1]
	local camera = Workspace.CurrentCamera
	local unitRay = camera:ScreenPointToRay(pos.X, pos.Y)
	local raycast = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)

	if raycast and raycast.Instance then
		local hit = raycast.Instance
		local player = Players:GetPlayerFromCharacter(hit:FindFirstAncestorOfClass("Model"))
		if player and player ~= LocalPlayer then
			FlingPlayer(player)
		end
	end
end)
  end
})


Troll:AddButton({
    Name = "Click Fling Couch (Tool)",
    Callback = function()

local jogadores = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local entrada = game:GetService("UserInputService")
local eu = jogadores.LocalPlayer
local cam = workspace.CurrentCamera

local podeClicar = true
local ferramentaEquipada = false
local NOME_FERRAMENTA = "Click Fling Couch"

local mochila = eu:WaitForChild("Backpack")

if not mochila:FindFirstChild(NOME_FERRAMENTA) and not (eu.Character and eu.Character:FindFirstChild(NOME_FERRAMENTA)) then
	local ferramenta = Instance.new("Tool")
	ferramenta.Name = NOME_FERRAMENTA
	ferramenta.RequiresHandle = false
	ferramenta.CanBeDropped = false

	ferramenta.Equipped:Connect(function()
		ferramentaEquipada = true
	end)

	ferramenta.Unequipped:Connect(function()
		ferramentaEquipada = false
	end)

	ferramenta.Parent = mochila
end

local function jogarComSofa(alvo)
	if not ferramentaEquipada then return end
	if not alvo or not alvo.Character or alvo == eu then return end

	local jogando = true
	local raiz = eu.Character and eu.Character:FindFirstChild("HumanoidRootPart")
	local alvoRaiz = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
	if not raiz or not alvoRaiz then return end

	local boneco = eu.Character
	local humano = boneco:FindFirstChildOfClass("Humanoid")
	local posOriginal = raiz.CFrame

	rep:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
	task.wait(0.2)

	rep.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
	task.wait(0.3)

	local sofa = eu.Backpack:FindFirstChild("Couch")
	if sofa then
		sofa.Parent = boneco
	end
	task.wait(0.1)

	game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
	task.wait(0.25)

	workspace.FallenPartsDestroyHeight = 0/0

	local forca = Instance.new("BodyVelocity")
	forca.Name = "ForcaJogada"
	forca.Velocity = Vector3.new(9e8, 9e8, 9e8)
	forca.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	forca.Parent = raiz

	humano:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	humano.PlatformStand = false
	cam.CameraSubject = alvo.Character:FindFirstChild("Head") or alvoRaiz or humano

	task.spawn(function()
		local angulo = 0
		local partes = {raiz}
		while jogando and alvo and alvo.Character and alvo.Character:FindFirstChildOfClass("Humanoid") do
			local alvoHum = alvo.Character:FindFirstChildOfClass("Humanoid")
			if alvoHum.Sit then break end
			angulo += 50

			for _, parte in ipairs(partes) do
				local hrp = alvo.Character.HumanoidRootPart
				local pos = hrp.Position + hrp.Velocity / 1.5
				raiz.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(angulo), 0, 0)
			end

			raiz.Velocity = Vector3.new(9e8, 9e8, 9e8)
			raiz.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			task.wait()
		end

		jogando = false
		forca:Destroy()
		humano:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		humano.PlatformStand = false
		raiz.CFrame = posOriginal
		cam.CameraSubject = humano

		for _, p in pairs(boneco:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Velocity = Vector3.zero
				p.RotVelocity = Vector3.zero
			end
		end

		humano:UnequipTools()
		rep.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
	end)

	while jogando do
		task.wait()
	end
end

entrada.TouchTap:Connect(function(toques, processado)
	if processado or not podeClicar or not ferramentaEquipada then return end

	local pos = toques[1]
	local raio = cam:ScreenPointToRay(pos.X, pos.Y)
	local acerto = workspace:Raycast(raio.Origin, raio.Direction * 1000)

	if acerto and acerto.Instance then
		local alvo = jogadores:GetPlayerFromCharacter(acerto.Instance:FindFirstAncestorOfClass("Model"))
		if alvo and alvo ~= eu then
			podeClicar = false
			jogarComSofa(alvo)
			task.delay(2, function()
				podeClicar = true
			end)
		end
	end
end)
end
})

Troll:AddButton({
    Name = "Click Fling Ball (Tool)",
    Callback = function()
local jogadores = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local mundo = game:GetService("Workspace")
local entrada = game:GetService("UserInputService")
local cam = mundo.CurrentCamera
local eu = jogadores.LocalPlayer

local NOME_FERRAMENTA = "Click Fling Ball"
local ferramentaEquipada = false

local mochila = eu:WaitForChild("Backpack")
if not mochila:FindFirstChild(NOME_FERRAMENTA) then
	local ferramenta = Instance.new("Tool")
	ferramenta.Name = NOME_FERRAMENTA
	ferramenta.RequiresHandle = false
	ferramenta.CanBeDropped = false

	ferramenta.Equipped:Connect(function()
		ferramentaEquipada = true
	end)

	ferramenta.Unequipped:Connect(function()
		ferramentaEquipada = false
	end)

	ferramenta.Parent = mochila
end

-- Função FlingBall (bola)
local function FlingBall(target)
    

    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local backpack = player:WaitForChild("Backpack")
    local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

    local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") and not character:FindFirstChild("SoccerBall") then
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
        end

        repeat task.wait() until backpack:FindFirstChild("SoccerBall") or character:FindFirstChild("SoccerBall")

        local ballTool = backpack:FindFirstChild("SoccerBall")
        if ballTool then
            ballTool.Parent = character
        end

        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. player.Name)

        return ServerBalls:FindFirstChild("Soccer" .. player.Name)
    end

    local Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name) or GetBall()
    Ball.CanCollide = false
    Ball.Massless = true
    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

    if target ~= player then
        local tchar = target.Character
        if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
            local troot = tchar.HumanoidRootPart
            local thum = tchar.Humanoid

            if Ball:FindFirstChildWhichIsA("BodyVelocity") then
                Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy()
            end

            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlingPower"
            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 9e900
            bv.Parent = Ball

            workspace.CurrentCamera.CameraSubject = thum

            repeat
                if troot.Velocity.Magnitude > 0 then
                    local pos = troot.Position + (troot.Velocity / 1.5)
                    Ball.CFrame = CFrame.new(pos)
                    Ball.Orientation += Vector3.new(45, 60, 30)
                else
                    for i, v in pairs(tchar:GetChildren()) do
                        if v:IsA("BasePart") and v.CanCollide and not v.Anchored then
                            Ball.CFrame = v.CFrame
                            task.wait(1/6000)
                        end
                    end
                end
                task.wait(1/6000)
            until troot.Velocity.Magnitude > 1000 or thum.Health <= 0 or not tchar:IsDescendantOf(workspace) or target.Parent ~= players

            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

-- Toque na tela para aplicar a bola
entrada.TouchTap:Connect(function(toques, processado)
	if not ferramentaEquipada or processado then return end
	local pos = toques[1]
	local raio = cam:ScreenPointToRay(pos.X, pos.Y)
	local hit = mundo:Raycast(raio.Origin, raio.Direction * 1000)
	if hit and hit.Instance then
		local modelo = hit.Instance:FindFirstAncestorOfClass("Model")
		local jogador = jogadores:GetPlayerFromCharacter(modelo)
		if jogador and jogador ~= eu then
			FlingBall(jogador)
		end
	end
end)

end
})

Troll:AddButton({
    Name = "Click Kill Couch (Tool)",
    Callback = function()

local jogadores = game:GetService("Players")
local rep = game:GetService("ReplicatedStorage")
local loop = game:GetService("RunService")
local mundo = game:GetService("Workspace")
local entrada = game:GetService("UserInputService")

local eu = jogadores.LocalPlayer
local cam = mundo.CurrentCamera

local NOME_FERRAMENTA = "Click Kill Couch"
local ferramentaEquipada = false
local nomeAlvo = nil
local loopTP = nil
local sofaEquipado = false
local base = nil
local posInicial = nil
local raiz = nil

local mochila = eu:WaitForChild("Backpack")
if not mochila:FindFirstChild(NOME_FERRAMENTA) then
	local ferramenta = Instance.new("Tool")
	ferramenta.Name = NOME_FERRAMENTA
	ferramenta.RequiresHandle = false
	ferramenta.CanBeDropped = false

	ferramenta.Equipped:Connect(function()
		ferramentaEquipada = true
	end)

	ferramenta.Unequipped:Connect(function()
		ferramentaEquipada = false
		nomeAlvo = nil
		limparSofa()
	end)

	ferramenta.Parent = mochila
end

function limparSofa()
	if loopTP then
		loopTP:Disconnect()
		loopTP = nil
	end

	if sofaEquipado then
		local boneco = eu.Character
		if boneco then
			local sofa = boneco:FindFirstChild("Couch")
			if sofa then
				sofa.Parent = eu.Backpack
				sofaEquipado = false
			end
		end
	end

	if base then
		base:Destroy()
		base = nil
	end

	if getgenv().AntiSit then
		getgenv().AntiSit:Set(false)
	end

	local humano = eu.Character and eu.Character:FindFirstChildOfClass("Humanoid")
	if humano then
		humano:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		humano:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	if posInicial and raiz then
		raiz.CFrame = posInicial
		posInicial = nil
	end
end

function pegarSofa()
	local boneco = eu.Character
	if not boneco then return end
	local mochila = eu.Backpack

	if not mochila:FindFirstChild("Couch") and not boneco:FindFirstChild("Couch") then
		local args = { "PickingTools", "Couch" }
		rep.RE["1Too1l"]:InvokeServer(unpack(args))
		task.wait(0.1)
	end

	local sofa = mochila:FindFirstChild("Couch") or boneco:FindFirstChild("Couch")
	if sofa then
		sofa.Parent = boneco
		sofaEquipado = true
	end
end

function posAleatoriaAbaixo(boneco)
	local rp = boneco:FindFirstChild("HumanoidRootPart")
	if not rp then return Vector3.new() end
	local offset = Vector3.new(math.random(-2, 2), -5.1, math.random(-2, 2))
	return rp.Position + offset
end

function tpAbaixo(alvo)
	if not alvo or not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end

	local meuBoneco = eu.Character
	local minhaRaiz = meuBoneco and meuBoneco:FindFirstChild("HumanoidRootPart")
	local humano = meuBoneco and meuBoneco:FindFirstChildOfClass("Humanoid")

	if not minhaRaiz or not humano then return end

	humano:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

	if not base then
		base = Instance.new("Part")
		base.Size = Vector3.new(10, 1, 10)
		base.Anchored = true
		base.CanCollide = true
		base.Transparency = 0.5
		base.Parent = mundo
	end

	local destino = posAleatoriaAbaixo(alvo.Character)
	base.Position = destino
	minhaRaiz.CFrame = CFrame.new(destino)

	humano:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
end

function arremessarComSofa(alvo)
	if not alvo then return end
	nomeAlvo = alvo.Name
	local boneco = eu.Character
	if not boneco then return end

	posInicial = boneco:FindFirstChild("HumanoidRootPart") and boneco.HumanoidRootPart.CFrame
	raiz = boneco:FindFirstChild("HumanoidRootPart")
	pegarSofa()

	loopTP = loop.Heartbeat:Connect(function()
		local alvoAtual = jogadores:FindFirstChild(nomeAlvo)
		if not alvoAtual or not alvoAtual.Character or not alvoAtual.Character:FindFirstChild("Humanoid") then
			limparSofa()
			return
		end
		if getgenv().AntiSit then
			getgenv().AntiSit:Set(true)
		end
		tpAbaixo(alvoAtual)
	end)

	task.spawn(function()
		local alvoAtual = jogadores:FindFirstChild(nomeAlvo)
		while alvoAtual and alvoAtual.Character and alvoAtual.Character:FindFirstChild("Humanoid") do
			task.wait(0.05)
			if alvoAtual.Character.Humanoid.SeatPart then
				local buraco = CFrame.new(265.46, -450.83, -59.93)
				alvoAtual.Character.HumanoidRootPart.CFrame = buraco
				eu.Character.HumanoidRootPart.CFrame = buraco
				task.wait(0.4)
				limparSofa()
				task.wait(0.2)
				if posInicial then
					eu.Character.HumanoidRootPart.CFrame = posInicial
				end
				break
			end
		end
	end)
end

entrada.TouchTap:Connect(function(toques, processado)
	if not ferramentaEquipada or processado then return end
	local pos = toques[1]
	local raio = cam:ScreenPointToRay(pos.X, pos.Y)
	local hit = mundo:Raycast(raio.Origin, raio.Direction * 1000)
	if hit and hit.Instance then
		local modelo = hit.Instance:FindFirstAncestorOfClass("Model")
		local jogador = jogadores:GetPlayerFromCharacter(modelo)
		if jogador and jogador ~= eu then
			arremessarComSofa(jogador)
		end
	end
end)
end
})

local kill = Troll:AddSection({Name = "All methods"})

Troll:AddButton({
    Name = "Kill All Bus",
    Callback = function()
        local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local destination = Vector3.new(145.51, -374.09, 21.58) 
local originalPosition = nil  

local function GetBus()  
    local vehicles = Workspace:FindFirstChild("Vehicles")  
    if vehicles then  
        return vehicles:FindFirstChild(Players.LocalPlayer.Name.."Car")  
    end  
    return nil  
end  

local function TrackPlayer(selectedPlayerName, callback)
    while true do  
        if selectedPlayerName then  
            local targetPlayer = Players:FindFirstChild(selectedPlayerName)  
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then  
                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")  
                if targetHumanoid and targetHumanoid.Sit then  
                    local bus = GetBus()
                    if bus then
                        bus:SetPrimaryPartCFrame(CFrame.new(destination))   
                        print("Jogador sentou, levando ônibus para o void!")  

                        task.wait(0.2)  

                        local function simulateJump()  
                            local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")  
                            if humanoid then  
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)  
                            end  
                        end  

                        simulateJump()  
                        print("Simulando primeiro pulo!")  

                        task.wait(0.4)  
                        simulateJump()
                        print("Simulando segundo pulo!")  

                        task.wait(0.5)
                        if originalPosition then
                            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition  
                            print("Player voltou para a posição inicial Xique")  

                            task.wait(0.1)
                            local args = {
                                [1] = "DeleteAllVehicles"
                            }
                            ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
                            print("Todos os veículos foram deletados!")
                        end
                    end
                    break  
                else  
                    local targetRoot = targetPlayer.Character.HumanoidRootPart  
                    local time = tick() * 35
               
                    local lateralOffset = math.sin(time) * 10  -- Movimento lateral rápido  
                    local frontBackOffset = math.cos(time) * 20  -- Movimento frente/trás
                      
                    local bus = GetBus()
                    if bus then
                        bus:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(0, 0, frontBackOffset))  
                    end
                end  
            end  
        end  
        RunService.RenderStepped:Wait()  
    end
    
    if callback then
        callback()
    end
end  

local function StartKillBusao(playerName, callback)
    local selectedPlayerName = playerName

    local player = Players.LocalPlayer  
    local character = player.Character or player.CharacterAdded:Wait()  
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  

    originalPosition = humanoidRootPart.CFrame  

    local bus = GetBus()  

    if not bus then  
        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)  
        task.wait(0.5)  
        local remoteEvent = ReplicatedStorage:FindFirstChild("RE")  
        if remoteEvent and remoteEvent:FindFirstChild("1Ca1r") then  
            remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")  
        end  
        task.wait(1)  
        bus = GetBus()  
    end  

    if bus then  
        local seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")  
        if seat and character:FindFirstChildOfClass("Humanoid") and not character.Humanoid.Sit then  
            repeat  
                humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)  
                task.wait()  
            until character.Humanoid.Sit or not bus.Parent  
        end  
    end  

    spawn(function()
        TrackPlayer(selectedPlayerName, callback)
    end)
end

local function PerformActionForAllPlayers(players)
    if #players == 0 then
        return
    end

    local player = table.remove(players, 1)
    StartKillBusao(player.Name, function()
        task.wait(0.5)
        PerformActionForAllPlayers(players)
    end)
end

PerformActionForAllPlayers(Players:GetPlayers())
    end
})
print("Kill All Bus button created")

Troll:AddButton({
    Name = "House Ban kill All",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")


local function executeScriptForPlayer(targetPlayer)
    local Player = game.Players.LocalPlayer
    local Backpack = Player.Backpack
    local Character = Player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Houses = game.Workspace:FindFirstChild("001_Lots")
    local OldPos = RootPart.CFrame
    local Angles = 0
    local Vehicles = Workspace.Vehicles
    local Pos


    function Check()
        if Player and Character and Humanoid and RootPart and Vehicles then
            return true
        else
            return false
        end
    end


    if Check() then
        local House = Houses:FindFirstChild(Player.Name.."House")
        if not House then
            local EHouse
            for _, Lot in pairs(Houses:GetChildren()) do
                if Lot.Name == "For Sale" then
                    for _, num in pairs(Lot:GetDescendants()) do
                        if num:IsA("NumberValue") and num.Name == "Number" and num.Value < 25 and num.Value > 10 then
                            EHouse = Lot
                            break
                        end
                    end
                end
            end


            local BuyDetector = EHouse:FindFirstChild("BuyHouse")
            Pos = BuyDetector.Position
            if BuyDetector and BuyDetector:IsA("BasePart") then
                RootPart.CFrame = BuyDetector.CFrame + Vector3.new(0, -6, 0)
                task.wait(0.5)
                local ClickDetector = BuyDetector:FindFirstChild("ClickDetector")
                if ClickDetector then
                    fireclickdetector(ClickDetector)
                end
            end
        end


        task.wait(0.5)
        local PreHouse = Houses:FindFirstChild(Player.Name .. "House")
        if PreHouse then
            task.wait(0.5)
            local Number
            for i, x in pairs(PreHouse:GetDescendants()) do
                if x.Name == "Number" and x:IsA("NumberValue") then
                    Number = x
                end
            end
            task.wait(0.5)
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gettin1gHous1e"):FireServer("PickingCustomHouse", "049_House", Number.Value)
        end


        task.wait(0.5)
        local PCar = Vehicles:FindFirstChild(Player.Name.."Car")
        if not PCar then
            if Check() then
                RootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
                task.wait(0.5)
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingCar", "SchoolBus")
                task.wait(0.5)
                local PCar = Vehicles:FindFirstChild(Player.Name.."Car")
                task.wait(0.5)
                local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
                if Seat then
                    repeat
                        task.wait()
                        RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
                    until Humanoid.Sit
                end
            end
        end


        task.wait(0.5)
        local PCar = Vehicles:FindFirstChild(Player.Name.."Car")
        if PCar then
            if not Humanoid.Sit then
                local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
                if Seat then
                    repeat
                        task.wait()
                        RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
                    until Humanoid.Sit
                end
            end


            local Target = targetPlayer
            local TargetC = Target.Character
            local TargetH = TargetC:FindFirstChildOfClass("Humanoid")
            local TargetRP = TargetC:FindFirstChild("HumanoidRootPart")
            if TargetC and TargetH and TargetRP then
                if not TargetH.Sit then
                    while not TargetH.Sit do
                        task.wait()
                        local Fling = function(alvo, pos, angulo)
                            PCar:SetPrimaryPartCFrame(CFrame.new(alvo.Position) * pos * angulo)
                        end
                        Angles = Angles + 100
                        Fling(TargetRP, CFrame.new(0, 1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        Fling(TargetRP, CFrame.new(0, -1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        Fling(TargetRP, CFrame.new(2.25, 1.5, -2.25) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        Fling(TargetRP, CFrame.new(-2.25, -1.5, 2.25) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        Fling(TargetRP, CFrame.new(0, 1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                        Fling(TargetRP, CFrame.new(0, -1.5, 0) + TargetH.MoveDirection * TargetRP.Velocity.Magnitude / 1.10, CFrame.Angles(math.rad(Angles), 0, 0))
                    end
                    task.wait(0.2)
                    local House = Houses:FindFirstChild(Player.Name.."House")
                    PCar:SetPrimaryPartCFrame(CFrame.new(House.HouseSpawnPosition.Position))
                    task.wait(0.2)
                    local pedro = Region3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(30,30,30), game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(30,30,30))
                    local a = workspace:FindPartsInRegion3(pedro, game.Players.LocalPlayer.Character.HumanoidRootPart, math.huge)
                    for i, v in pairs(a) do
                        if v.Name == "HumanoidRootPart" then
                            local b = game:GetService("Players"):FindFirstChild(v.Parent.Name)
                            local args = {
                                [1] = "BanPlayerFromHouse",
                                [2] = b,
                                [3] = v.Parent
                            }
                            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Playe1rTrigge1rEven1t"):FireServer(unpack(args))
                        end
                    end
                end
            end
        end
    end


    -- Deletar o veículo
    local deleteArgs = {
        [1] = "DeleteAllVehicles"
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(deleteArgs))
end


-- Iterar sobre todos os jogadores no mapa
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Player then
        executeScriptForPlayer(player)
       task.wait(2)
    end
end
    end
})
print("House Ban kill All button created")

Troll:AddButton({
    Name = "Fling Boat all",
    Callback = function()
        local Player = game.Players.LocalPlayer
    local Character = Player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Vehicles = game.Workspace:FindFirstChild("Vehicles")
    local OldPos = RootPart.CFrame
    local Angles = 0
    local PCar = Vehicles:FindFirstChild(Player.Name.."Car")
    
    -- Se nÃ£o tiver um carro, cria um  
            if not PCar then  
                if RootPart then  
                    RootPart.CFrame = CFrame.new(1754, -2, 58)  
                    task.wait(0.5)  
                    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")  
                    task.wait(0.5)  
                    PCar = Vehicles:FindFirstChild(Player.Name.."Car")  
                    task.wait(0.5)  
                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")  
                    if Seat then  
                        repeat  
                            task.wait()  
                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)  
                        until Humanoid.Sit  
                    end  
                end  
            end  
      
            task.wait(0.5)  
            PCar = Vehicles:FindFirstChild(Player.Name.."Car")  
      
            -- Se o carro existir, teletransporta para o assento se necessÃ¡rio  
            if PCar then  
                if not Humanoid.Sit then  
                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")  
                    if Seat then  
                        repeat  
                            task.wait()  
                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)  
                        until Humanoid.Sit  
                    end  
                end  
            end  
      
            -- Adiciona o BodyGyro ao carro para controle de movimento  
            local SpinGyro = Instance.new("BodyGyro")  
            SpinGyro.Parent = PCar.PrimaryPart  
            SpinGyro.MaxTorque = Vector3.new(1e7, 1e7, 1e7)  
            SpinGyro.P = 1e7  
            SpinGyro.CFrame = PCar.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0)  
      
            -- FunÃ§Ã£o de Fling em cada jogador por 3 segundos  
            local function flingPlayer(TargetC, TargetRP, TargetH)
    Angles = 0  
                local endTime = tick() + 1  -- Define o tempo final em 2 segundos a partir de agora  
                while tick() < endTime do  
                    Angles = Angles + 100  
                    task.wait()  
      
                    -- Movimentos e Ã¢ngulos para o Fling  
                    local kill = function(alvo, pos, angulo)  
                        PCar:SetPrimaryPartCFrame(CFrame.new(alvo.Position) * pos * angulo)  
                    end  
      
                    -- Fling para vÃ¡rias posiÃ§Ãµes ao redor do TargetRP  
                    kill(TargetRP, CFrame.new(0, 3, 0), CFrame.Angles(math.rad(Angles), 0, 0))  
                    kill(TargetRP, CFrame.new(0, -1.5, 2), CFrame.Angles(math.rad(Angles), 0, 0))  
                    kill(TargetRP, CFrame.new(2, 1.5, 2.25), CFrame.Angles(math.rad(50), 0, 0))  
                    kill(TargetRP, CFrame.new(-2.25, -1.5, 2.25), CFrame.Angles(math.rad(30), 0, 0))  
                    kill(TargetRP, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))  
                    kill(TargetRP, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))  
                end  
            end  
      
            -- Itera sobre todos os jogadores  
            for _, Target in pairs(game.Players:GetPlayers()) do  
                -- Pula o jogador local  
                if Target ~= Player then  
                    local TargetC = Target.Character  
                    local TargetH = TargetC and TargetC:FindFirstChildOfClass("Humanoid")  
                    local TargetRP = TargetC and TargetC:FindFirstChild("HumanoidRootPart")  
      
                    -- Se encontrar o alvo e seus componentes, executa o fling  
                    if TargetC and TargetH and TargetRP then  
                        flingPlayer(TargetC, TargetRP, TargetH)  -- Fling no jogador atual  
                    end  
                end  
            end  
      
            -- Retorna o jogador para sua posiÃ§Ã£o original  
            task.wait(0.5)  
            PCar:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))  
            task.wait(0.5)  
            Humanoid.Sit = false  
            task.wait(0.5)  
            RootPart.CFrame = OldPos  
      
            -- Remove o BodyGyro apÃ³s o efeito  
            SpinGyro:Destroy()  
    end
})
print("Fling Boat All button created")

Troll:AddButton({
    Name = "Auto Fling All",
    Callback = function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local cam = workspace.CurrentCamera


    local function ProcessPlayer(target)
        if not target or not target.Character or target == LocalPlayer then return end
        
        local flingActive = true
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not root or not tRoot then return end
        
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local original = root.CFrame

    
        ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
        task.wait(0.2)

  
        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
        task.wait(0.3)

        local tool = LocalPlayer.Backpack:FindFirstChild("Couch")
        if tool then
            tool.Parent = char
        end
task.wait(0.1)

game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
task.wait(0.25)

        workspace.FallenPartsDestroyHeight = 0/0

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlingForce"
        bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root

        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        hum.PlatformStand = false
        cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum

 
        task.spawn(function()
            local angle = 0
            local parts = {root}
            while flingActive and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do
                local tHum = target.Character:FindFirstChildOfClass("Humanoid")
                if tHum.Sit then break end
                angle += 50

                for _, part in ipairs(parts) do
                    local hrp = target.Character.HumanoidRootPart
                    local pos = hrp.Position + hrp.Velocity / 1.5
                    root.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(angle), 0, 0)
                end

                root.Velocity = Vector3.new(9e8, 9e8, 9e8)
                root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                task.wait()
            end

         
            flingActive = false
            bv:Destroy()
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum.PlatformStand = false
            root.CFrame = original
            cam.CameraSubject = hum

            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Velocity = Vector3.zero
                    p.RotVelocity = Vector3.zero
                end
            end

            hum:UnequipTools()
            ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
        end)
       
        while flingActive do
            task.wait()
        end
    end


    for _, player in ipairs(Players:GetPlayers()) do
        ProcessPlayer(player)
			end
    end
})

Troll:AddButton({
    Name = "Bring All Couch [melhor]",
    Callback = function()
        local args = {
    [1] = "ClearAllTools"
}

game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))

wait(0.2)

toolselcted = "Couch"
dupeamot = 25 --Put amouth to dupe
picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupando"),Text=lib:T("Nao Clique em nada quando tiver dupando . "), Button1 = lib:T(" Eu entendi") ,Duration=5})
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Because It will break the script and you will need to rejoin."), Button1 = lib:T("Eu entendi") ,Duration=5}) 
duping = true
oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
    task.wait()
    game.Players.LocalPlayer.Character.Humanoid.Sit = false
end
wait(0.1)
if game:GetService("Workspace"):FindFirstChild("Camera") then
    game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() 
end
for m=1,2 do 
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
end
task.wait(0.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
wait(0.5)
for aidj,afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if afh.Name == toolselcted == false then
        if afh:IsA("Tool") then
            afh.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end
for aiefhiewhwf,dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if dvjbvj:IsA("Tool") then
        if dvjbvj.Name == toolselcted == false then
            dvjbvj:Destroy()
        end
    end
end
for ttjtjutjutjjtj,ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
        if ddvdvdsvdfbrnytytmvdv.name == toolselcted == false then
            ddvdvdsvdfbrnytytmvdv:Destroy()
        end
    end
end
for findin,toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if toollel:IsA("Tool") then
        if toollel.Name == toolselcted then
            toollllfoun2 = true
            for basc,aijfw in pairs(toollel:GetDescendants()) do
                if aijfw.Name == "Handle" then
                    aijfw.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                    toollel.Parent = game.Players.LocalPlayer.Backpack
                    toollel.Parent = game.Players.LocalPlayer.Character
                    tollllahhhh = toollel
                    task.wait()
                end
            end
        else 
            toollllfoun2 = false
        end
    end
end
for fiifi,toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if toollll:IsA("Tool") then
        if toollll.Name == toolselcted then
            toollllfoun = true
            for nana,jjsjsj in pairs(toollll:GetDescendants()) do
                if jjsjsj.Name == "Handle" then
                    toollll.Parent = game.Players.LocalPlayer.Character
                    wait()
                    jjsjsj.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                    toollll.Parent = game.Players.LocalPlayer.Backpack
                    toollll.Parent = game.Players.LocalPlayer.Character
                    toolllffel = toollll
                end
            end
        else 
            toollllfoun = false
        end
    end
end
if toollllfoun == true then
    if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then  
        toollllfoun = false 
    end
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
    toollllfoun = false
end
if toollllfoun2 == true then
    if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then 
        toollllfoun2 = false 
    end
    repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
    toollllfoun2 = false
end
wait(0.1)
for m=1, dupeamot do
    if duping == false then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false 
        return 
    end
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() 
    end
    if m <= dupeamot then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupando vida"),Text="Se tem".." "..m.." ".."Duped".." "..toolselcted.."!",Duration=0.5})
    elseif m == dupeamot or m >= dupeamot - 1 then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupando"),Text="Se tem".." "..m.." ".."Duped".." "..toolselcted.."!".." ".."Duping tools is done now, Please wait a little bit to respawn.",Duration=4})
    end
    local args = {
        [1] = "PickingTools",
        [2] = toolselcted
    }
    
    picktoolremote:InvokeServer(unpack(args))
    game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselcted).Parent = game.Players.LocalPlayer.Character
    if duping == false then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false 
        return 
    end
    wait()
    game:GetService("Players").LocalPlayer.Character[toolselcted]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
    game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Backpack
    game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Character
    repeat  
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() 
        end
        task.wait() 
    until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted) == nil
end
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
wait()
duping = false

for wwefef,weifwwe in pairs(game.Players:GetPlayers()) do
    if weifwwe.Name == game.Players.LocalPlayer.Name == false then
        ewoifjwoifjiwo = wwefef
    end
end
for m=1,ewoifjwoifjiwo do
    game.Players.LocalPlayer.Backpack.Couch.Name = "couch"..m
end
wait()
for weofefawd,iwiejguiwg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if iwiejguiwg.Name == "couch"..weofefawd then
        iwiejguiwg.Handle.Name = "Handle "
    end
end
wait(0.2)
local function bring(skjdfuwiruwg,woiejewg)
    if woiejewg == nil == false then
        game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg]:FindFirstChild("Seat1").Disabled = true
        game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg]:FindFirstChild("Seat2").Disabled = true
        game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character
        tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg]:FindFirstChild("Handle "))
        tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0,0,0)
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        repeat
            for m=1,35 do
                local pos = {x=0, y=0, z=0}
                pos.x = woiejewg.Character.HumanoidRootPart.Position.X
                pos.y = woiejewg.Character.HumanoidRootPart.Position.Y
                pos.z = woiejewg.Character.HumanoidRootPart.Position.Z
                pos.x = pos.x + woiejewg.Character.HumanoidRootPart.Velocity.X / 2
                pos.y = pos.y + woiejewg.Character.HumanoidRootPart.Velocity.Y / 2
                pos.z = pos.z + woiejewg.Character.HumanoidRootPart.Velocity.Z / 2
                game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg]:FindFirstChild("Seat1").CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(-2,2,0)
                task.wait()
            end
            game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack
            wait()
            game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg]:FindFirstChild("Handle ").Name = "Handle"
            wait(0.2)
            game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character
            wait()
            game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack
            game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg].Handle.Name = "Handle "
            wait(0.2)
            game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character
            tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg]:FindFirstChild("Seat1"))
            tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            tet.P = 1250
            tet.Velocity = Vector3.new(0,0,0)
            tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        until woiejewg.Character.Humanoid.Sit == true
        wait()
        game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg]:FindFirstChild("Handle "):FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"):Destroy()
        game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack
        wait()
        game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg]:FindFirstChild("Handle ").Name = "Handle"
        wait(0.2)
        game.Players.LocalPlayer.Backpack["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character
        wait()
        game.Players.LocalPlayer.Character["couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack
    end
end
for mwef,weuerg in pairs(game.Players:GetPlayers()) do
    if weuerg.Name == game.Players.LocalPlayer.Name == false then
        spawn(function()
            bring(mwef,weuerg)
        end)
    end
end
    end
})
print("Bring All Couch button created")

Troll:AddButton({
    Name = "Kill All Couch [melhor]",
    Callback = function()
        local args = {
    [1] = "ClearAllTools"
}

game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))

wait(0.2)

local initialPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

local part = Instance.new("Part")
part.Size = Vector3.new(5000, 10, 5000)
part.Position = Vector3.new(0, -500, 0)
part.Anchored = true
part.CanCollide = true
part.Parent = game.Workspace
task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
wait(2)
toolselcted = "Couch"
dupeamot = 25 -- dupe
picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupando"),Text=lib:T("Nao clique em nada"), Button1 = lib:T("Eu entendi") ,Duration=5})
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupando"),Text=lib:T("Espere"), Button1 = lib:T("Tendeu") ,Duration=5})
duping = true
oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
    task.wait()
    game.Players.LocalPlayer.Character.Humanoid.Sit = false
end
wait(0.1)
if game:GetService("Workspace"):FindFirstChild("Camera") then
    game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
end
for m=1,2 do 
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
end
task.wait(0.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
wait(0.5)
for aidj,afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if afh.Name == toolselcted == false then
        if afh:IsA("Tool") then
            afh.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end
for aiefhiewhwf,dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if dvjbvj:IsA("Tool") then
        if dvjbvj.Name == toolselcted == false then
            dvjbvj:Destroy()
        end
    end
end
for ttjtjutjutjjtj,ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
        if ddvdvdsvdfbrnytytmvdv.Name == toolselcted == false then
            ddvdvdsvdfbrnytytmvdv:Destroy()
        end
    end
end
for findin,toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
    if toollel:IsA("Tool") then
        if toollel.Name == toolselcted then
            toollllfoun2 = true
            for basc,aijfw in pairs(toollel:GetDescendants()) do
                if aijfw.Name == "Handle" then
                    aijfw.Name = "HÃ¢Â�Â¥aÃ¢Â�Â¥nÃ¢Â�Â¥dÃ¢Â�Â¥lÃ¢Â�Â¥e"
                    toollel.Parent = game.Players.LocalPlayer.Backpack
                    toollel.Parent = game.Players.LocalPlayer.Character
                    tollllahhhh = toollel
                    task.wait()
                end
            end
        else 
            toollllfoun2 = false
        end
    end
end
for fiifi,toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if toollll:IsA("Tool") then
        if toollll.Name == toolselcted then
            toollllfoun = true
            for nana,jjsjsj in pairs(toollll:GetDescendants()) do
                if jjsjsj.Name == "Handle" then
                    toollll.Parent = game.Players.LocalPlayer.Character
                    wait()
                    jjsjsj.Name = "HÃ¢Â�Â¥aÃ¢Â�Â¥nÃ¢Â�Â¥dÃ¢Â�Â¥lÃ¢Â�Â¥e"
                    toollll.Parent = game.Players.LocalPlayer.Backpack
                    toollll.Parent = game.Players.LocalPlayer.Character
                    toolllffel = toollll
                end
            end
        else 
            toollllfoun = false
        end
    end
end
if toollllfoun == true then
    if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then 
        toollllfoun = false 
    end
    repeat 
        wait() 
    until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
    toollllfoun = false
end
if toollllfoun2 == true then
    if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then 
        toollllfoun2 = false 
    end
    repeat 
        wait() 
    until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
    toollllfoun2 = false
end
wait(0.1)
for m=1, dupeamot do
    if duping == false then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false 
        return 
    end
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() 
    end
    if m <= dupeamot then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text="Agora c Tem".." "..m.." ".."Duped".." "..toolselcted.."!",Duration=0.5})
    elseif m == dupeamot or m >= dupeamot - 1 then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text="Agora c tem".." "..m.." ".."Duped".." "..toolselcted.."!".." ".."As tools Tao sendo dupada Clica em nada nao fiote",Duration=4})
    end
    local args = {
        [1] = "PickingTools",
        [2] = toolselcted
    }

    picktoolremote:InvokeServer(unpack(args)) 
    game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselcted).Parent = game.Players.LocalPlayer.Character 
    if duping == false then 
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false 
        return 
    end 
    wait() 
    game:GetService("Players").LocalPlayer.Character[toolselcted]:FindFirstChild("Handle").Name = "HÃ¢Â�Â¥aÃ¢Â�Â¥nÃ¢Â�Â¥dÃ¢Â�Â¥lÃ¢Â�Â¥e" 
    game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Backpack 
    game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Character 
    repeat 
        if game:GetService("Workspace"):FindFirstChild("Camera") then 
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() 
        end 
        task.wait() 
    until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted) == nil 
end 
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false 
repeat 
    wait() 
until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil 
repeat 
    wait() 
until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf 
wait() 
duping = false 
for wwefef,weifwwe in pairs(game.Players:GetPlayers()) do 
    if weifwwe.Name == game.Players.LocalPlayer.Name == false then 
        ewoifjwoifjiwo = wwefef 
    end 
end 
for m=1,ewoifjwoifjiwo do 
    game.Players.LocalPlayer.Backpack.Couch.Name = "Flow Couch"..m 
end 
wait() 
for weofefawd,iwiejguiwg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
    if iwiejguiwg.Name == "Flow Couch"..weofefawd then 
        iwiejguiwg.Handle.Name = "Handle " 
    end 
end 
wait(0.2) 
local function bring(skjdfuwiruwg,woiejewg) 
    if woiejewg == nil == false then 
        game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Seat1").Disabled = true 
        game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Seat2").Disabled = true 
        game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character 
        tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Handle ")) 
        tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge) 
        tet.P = 1250 
        tet.Velocity = Vector3.new(0,0,0) 
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W" 
        repeat 
            for m=1,35 do 
                local pos = {x=0, y=0, z=0} 
                pos.x = woiejewg.Character.HumanoidRootPart.Position.X 
                pos.y = woiejewg.Character.HumanoidRootPart.Position.Y 
                pos.z = woiejewg.Character.HumanoidRootPart.Position.Z 
                pos.x = pos.x + woiejewg.Character.HumanoidRootPart.Velocity.X / 2 
                pos.y = pos.y + woiejewg.Character.HumanoidRootPart.Velocity.Y / 2 
                pos.z = pos.z + woiejewg.Character.HumanoidRootPart.Velocity.Z / 2 
                game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Seat1").CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(-2,2,0) 
                task.wait() 
            end 
            game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack 
            wait() 
            game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Handle ").Name = "Handle" 
            wait(0.2) 
            game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character 
            wait() 
            game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack 
            game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg].Handle.Name = "Handle " 
            wait(0.2) 
            game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character 
            tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Seat1")) 
            tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge) 
            tet.P = 1250 
            tet.Velocity = Vector3.new(0,0,0) 
            tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W" 
        until woiejewg.Character.Humanoid.Sit == true 
        wait() 
        game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Handle "):FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"):Destroy() 
        game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack 
        wait() 
        game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg]:FindFirstChild("Handle ").Name = "Handle" 
        wait(0.2) 
        game.Players.LocalPlayer.Backpack["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Character 
        wait() 
        game.Players.LocalPlayer.Character["Flow Couch"..skjdfuwiruwg].Parent = game.Players.LocalPlayer.Backpack 
    end 
end 
for mwef,weuerg in pairs(game.Players:GetPlayers()) do 
    if weuerg.Name == game.Players.LocalPlayer.Name == false then 
        spawn(function() bring(mwef,weuerg) end) 
    end 
end 

-- Função para teletransportar o jogador de volta à posição inicial após 10 segundos
task.delay(14, function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(initialPosition)
end)

-- Função para limpar todas as ferramentas 0.5 segundos após teletransporte para a posição inicial
task.delay(14.1, function()
    game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))
end)
    end
})
print("Kill All Couch button created")  

Troll:AddButton({
    Name = "Fling Ball all",
    Callback = function()
local player=game:GetService("Players").LocalPlayer
local SoccerBalls=workspace.WorkspaceCom["001_SoccerBalls"]
local MyBall=SoccerBalls:FindFirstChild("Soccer"..player.Name)

if not MyBall then
if not player.Backpack:FindFirstChild("SoccerBall") then
local args={[1]="PickingTools",[2]="SoccerBall"}
game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
task.wait()
player.Backpack.SoccerBall.Parent=player.Character
repeat MyBall=SoccerBalls:FindFirstChild("Soccer"..player.Name) task.wait() until MyBall
player.Character.SoccerBall.Parent=player.Backpack
task.wait()
else
player.Backpack.SoccerBall.Parent=player.Character
repeat MyBall=SoccerBalls:FindFirstChild("Soccer"..player.Name) task.wait() until MyBall
player.Character.SoccerBall.Parent=player.Backpack
end
end


for i,v in pairs(game.Players:GetPlayers()) do
if v~=game.Players.LocalPlayer then
local target=v
local TCharacter=target.Character or target.CharacterAdded:Wait()
local THumanoidRootPart=TCharacter:WaitForChild("HumanoidRootPart")
if not MyBall or not THumanoidRootPart then return end

for _,v in pairs(MyBall:GetChildren()) do
if v:IsA("BodyMover") then v:Destroy() end
end

local bodyVelocity=Instance.new("BodyVelocity")
bodyVelocity.Velocity=Vector3.new(9e8,9e8,9e8)
bodyVelocity.MaxForce=Vector3.new(1/0,1/0,1/0)
bodyVelocity.P=1e10
bodyVelocity.Parent=MyBall

local bv=Instance.new("BodyVelocity")
bv.Velocity=Vector3.new(9e8,9e8,9e8)
bv.MaxForce=Vector3.new(1/0,1/0,1/0)
bv.P=1e9
bv.Parent=THumanoidRootPart

local oldPos=THumanoidRootPart.Position
workspace.CurrentCamera.CameraSubject=THumanoidRootPart

repeat
local velocity=THumanoidRootPart.Velocity.Magnitude
local parts={}
for _,v in pairs(TCharacter:GetDescendants()) do
if v:IsA("BasePart") and v.CanCollide and not v.Anchored then table.insert(parts,v) end
end
for _,part in ipairs(parts) do
local pos_x=target.Character.HumanoidRootPart.Position.X
local pos_y=target.Character.HumanoidRootPart.Position.Y
local pos_z=target.Character.HumanoidRootPart.Position.Z
pos_x=pos_x+(target.Character.HumanoidRootPart.Velocity.X/1.5)
pos_y=pos_y+(target.Character.HumanoidRootPart.Velocity.Y/1.5)
pos_z=pos_z+(target.Character.HumanoidRootPart.Velocity.Z/1.5)
MyBall.CFrame=CFrame.new(pos_x,pos_y,pos_z)
task.wait(1/6000)
end
task.wait(1/6000)
until THumanoidRootPart.Velocity.Magnitude>5000 or TCharacter.Humanoid.Health==0 or target.Parent~=game.Players or THumanoidRootPart.Parent~=TCharacter or TCharacter~=target.Character

end
end

workspace.CurrentCamera.CameraSubject=game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
  end
})


local Tab = t3.AVT

Tab:AddSection({ Name = "Copiar Skin" })



local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Target = nil

-- FunÃ§Ã£o para obter os nomes dos jogadores
local function GetPlayerNames()
    local PlayerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(PlayerNames, player.Name)
    end
    return PlayerNames
end

-- Dropdown de seleÃ§Ã£o de jogador
local Dropdown = Tab:AddDropdown({
    Name = "Selecionar Jogador",
    Options = GetPlayerNames(),
    Default = Target,
    Callback = function(Value)
        Target = Value
    end
})

-- Atualiza opÃ§Ãµes do dropdown quando alguÃ©m entra ou sai
local function UpdateDropdown()
    Dropdown:Refresh(GetPlayerNames(), true)
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

Tab:AddButton({
    Name = "Copiar Avatar",
    Callback = function()
        if not Target then return end

        local LP = Players.LocalPlayer
        local LChar = LP.Character
        local TPlayer = Players:FindFirstChild(Target)

        if TPlayer and TPlayer.Character then
            local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")

            if LHumanoid and THumanoid then
                -- RESETAR LOCALPLAYER
                local LDesc = LHumanoid:GetAppliedDescription()

                -- Remover acessÃ³rios, roupas e face atuais
                for _, acc in ipairs(LDesc:GetAccessories(true)) do
                    if acc.AssetId and tonumber(acc.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                        task.wait(0.2)
                    end
                end

                if tonumber(LDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                    task.wait(0.2)
                end

                -- COPIAR DO JOGADOR ALVO
                local PDesc = THumanoid:GetAppliedDescription()

                -- Enviar partes do corpo
                local argsBody = {
                    [1] = {
                        [1] = PDesc.Torso,
                        [2] = PDesc.RightArm,
                        [3] = PDesc.LeftArm,
                        [4] = PDesc.RightLeg,
                        [5] = PDesc.LeftLeg,
                        [6] = PDesc.Head
                    }
                }
                Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
                task.wait(0.5)

                if tonumber(PDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                    task.wait(0.3)
                end

                for _, v in ipairs(PDesc:GetAccessories(true)) do
                    if v.AssetId and tonumber(v.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                        task.wait(0.3)
                    end
                end

                local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
                if SkinColor then
                    Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                    task.wait(0.3)
                end

                if tonumber(PDesc.IdleAnimation) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))
                    task.wait(0.3)
                end

                -- Nome, bio e cor
                local Bag = TPlayer:FindFirstChild("PlayersBag")
                if Bag then
                    if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPNameColor") then
                        Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBioColor") then
                        Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
})

-- Definir cores para o efeito RGB
local colors = {
    Color3.new(1, 0, 0),       -- Vermelho
    Color3.new(0, 1, 0),       -- Verde
    Color3.new(0, 0, 1),       -- Azul
    Color3.new(1, 1, 0),       -- Amarelo
    Color3.new(0, 1, 1),       -- Ciano
    Color3.new(1, 0, 1)        -- Magenta
}

-- Variável para controlar o estado do toggle House RGB
local isHouseRGBActive = false

-- Função para alterar a cor da casa
local function changeColor()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remoteEvent = replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Player1sHous1e")
    
    if not remoteEvent then
        warn("RemoteEvent '1Player1sHous1e' não encontrado.")
        return
    end

    while isHouseRGBActive do
        for _, color in ipairs(colors) do
            if not isHouseRGBActive then return end
            local args = {
                [1] = "ColorPickHouse",
                [2] = color
            }
            pcall(function()
                remoteEvent:FireServer(unpack(args))
            end)
            task.wait(0.8)
        end
    end
end

local function toggleHouseRGB(state)
    isHouseRGBActive = state
    if isHouseRGBActive then
        print("House RGB Activated")
        spawn(changeColor)
    else
        print("House RGB Deactivated")
    end
end

-- Variáveis globais
local isUnbanActive = false
local HouseTab = t3.CS
local SelectHouse = nil
local NoclipDoor = nil

-- Função para obter lista de casas
local function getHouseList()
    local Tabela = {}
    local lots = workspace:FindFirstChild("001_Lots")
    if lots then
        for _, House in ipairs(lots:GetChildren()) do
            if House.Name ~= "For Sale" and House:IsA("Model") then
                table.insert(Tabela, House.Name)
            end
        end
    end
    return Tabela
end

-- Dropdown para selecionar casas
pcall(function()
    HouseTab:AddDropdown({
        Name = "Selecione a Casa",
        Options = getHouseList(),
        Default = "...",
        Callback = function(Value)
            SelectHouse = Value
            if NoclipDoor then
                NoclipDoor:Set(false)
            end
            print("Casa selecionada: " .. tostring(Value))
        end
    })
end)

-- Função para atualizar a lista de casas
local function DropdownHouseUpdate()
    local Tabela = getHouseList()
    print("DropdownHouseUpdate called. Houses found:", #Tabela)
    pcall(function()
        HouseTab:ClearDropdown("Selecione a Casa") -- Tentar limpar dropdown, se suportado
        HouseTab:AddDropdown({
            Name = "Selecione a Casa",
            Options = Tabela,
            Default = "...",
            Callback = function(Value)
                SelectHouse = Value
                if NoclipDoor then
                    NoclipDoor:Set(false)
                end
            end
        })
    end)
end

-- Inicializar dropdown
pcall(DropdownHouseUpdate)

-- Botão para atualizar lista de casas
pcall(function()
    HouseTab:AddButton({
        Name = "Atualizar Lista de Casas",
        Callback = function()
            print("Atualizar Lista de Casas button clicked.")
            pcall(DropdownHouseUpdate)
        end
    })
end)

-- Botão para teleportar para casa
pcall(function()
    HouseTab:AddButton({
        Name = "Teleportar para Casa",
        Callback = function()
            local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
            if House and game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(House.WorldPivot.Position)
            else
                print("Casa não encontrada: " .. tostring(SelectHouse))
            end
        end
    })
end)

-- Botão para teleportar para cofre
pcall(function()
    HouseTab:AddButton({
        Name = "Teleportar para Cofre",
        Callback = function()
            local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
            if House and House:FindFirstChild("HousePickedByPlayer") and game.Players.LocalPlayer.Character then
                local safe = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_Safe")
                if safe then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safe.WorldPivot.Position)
                else
                    print("Cofre não encontrado na casa: " .. tostring(SelectHouse))
                end
            else
                print("Casa não encontrada: " .. tostring(SelectHouse))
            end
        end
    })
end)

-- Toggle para atravessar porta
pcall(function()
    NoclipDoor = HouseTab:AddToggle({
        Name = "Atravessar Porta da Casa",
        Description = "",
        Default = false,
        Callback = function(Value)
            pcall(function()
                local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                if House and House:FindFirstChild("HousePickedByPlayer") then
                    local housepickedbyplayer = House.HousePickedByPlayer
                    local doors = housepickedbyplayer.HouseModel:FindFirstChild("001_HouseDoors")
                    if doors and doors:FindFirstChild("HouseDoorFront") then
                        for _, Base in ipairs(doors.HouseDoorFront:GetChildren()) do
                            if Base:IsA("BasePart") then
                                Base.CanCollide = not Value
                            end
                        end
                    end
                end
            end)
        end
    })
end)

-- Toggle para tocar campainha
pcall(function()
    HouseTab:AddToggle({
        Name = "Tocar Campainha",
        Description = "",
        Default = false,
        Callback = function(Value)
            getgenv().FlowHubAutoSpawnDoorbellValue = Value
            spawn(function()
                while getgenv().FlowHubAutoSpawnDoorbellValue do
                    local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                    if House and House:FindFirstChild("HousePickedByPlayer") then
                        local doorbell = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_DoorBell")
                        if doorbell and doorbell:FindFirstChild("TouchBell") then
                            pcall(function()
                                fireclickdetector(doorbell.TouchBell.ClickDetector)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })
end)

-- Toggle para bater na porta
pcall(function()
    HouseTab:AddToggle({
        Name = "Bater na Porta",
        Description = "",
        Default = false,
        Callback = function(Value)
            getgenv().FlowHubAutoSpawnDoorValue = Value
            spawn(function()
                while getgenv().FlowHubAutoSpawnDoorValue do
                    local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                    if House and House:FindFirstChild("HousePickedByPlayer") then
                        local doors = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_HouseDoors")
                        if doors and doors:FindFirstChild("HouseDoorFront") and doors.HouseDoorFront:FindFirstChild("Knock") then
                            pcall(function()
                                fireclickdetector(doors.HouseDoorFront.Knock.TouchBell.ClickDetector)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })
end)
pcall(function()
    HouseTab:AddSection({ Name = "Teleporte Para Casas" })
end)

-- Lista de casas para teletransporte
local casas = {
    ["Casa 1"] = Vector3.new(260.29, 4.37, 209.32),
    ["Casa 2"] = Vector3.new(234.49, 4.37, 228.00),
    ["Casa 3"] = Vector3.new(262.79, 21.37, 210.84),
    ["Casa 4"] = Vector3.new(229.60, 21.37, 225.40),
    ["Casa 5"] = Vector3.new(173.44, 21.37, 228.11),
    ["Casa 6"] = Vector3.new(-43, 21, -137),
    ["Casa 7"] = Vector3.new(-40, 36, -137),
    ["Casa 11"] = Vector3.new(-21, 40, 436),
    ["Casa 12"] = Vector3.new(155, 37, 433),
    ["Casa 13"] = Vector3.new(255, 35, 431),
    ["Casa 14"] = Vector3.new(254, 38, 394),
    ["Casa 15"] = Vector3.new(148, 39, 387),
    ["Casa 16"] = Vector3.new(-17, 42, 395),
    ["Casa 17"] = Vector3.new(-189, 37, -247),
    ["Casa 18"] = Vector3.new(-354, 37, -244),
    ["Casa 19"] = Vector3.new(-456, 36, -245),
    ["Casa 20"] = Vector3.new(-453, 38, -295),
    ["Casa 21"] = Vector3.new(-356, 38, -294),
    ["Casa 22"] = Vector3.new(-187, 37, -295),
    ["Casa 23"] = Vector3.new(-410, 68, -447),
    ["Casa 24"] = Vector3.new(-348, 69, -496),
    ["Casa 28"] = Vector3.new(-103, 12, 1087),
    ["Casa 29"] = Vector3.new(-730, 6, 808),
    ["Casa 30"] = Vector3.new(-245, 7, 822),
    ["Casa 31"] = Vector3.new(639, 76, -361),
    ["Casa 32"] = Vector3.new(-908, 6, -361),
    ["Casa 33"] = Vector3.new(-111, 70, -417),
    ["Casa 34"] = Vector3.new(230, 38, 569),
    ["Casa 35"] = Vector3.new(-30, 13, 2209)
}

-- Criar lista de nomes de casas ordenada
local casasNomes = {}
for nome, _ in pairs(casas) do
    table.insert(casasNomes, nome)
end

table.sort(casasNomes, function(a, b)
    local numA = tonumber(a:match("%d+")) or 0
    local numB = tonumber(b:match("%d+")) or 0
    return numA < numB
end)

-- Dropdown para teletransporte
pcall(function()
    HouseTab:AddDropdown({
        Name = "Selecionar Casa",
        Options = casasNomes,
        Callback = function(casaSelecionada)
            local player = game.Players.LocalPlayer
            if player and player.Character then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(casas[casaSelecionada])
            end
        end
    })
end)

-- Label após dropdown
pcall(function()
    HouseTab:AddLabel("Teleporte para a Casa que Quiser")
end)

-- Seção para Auto Unban
pcall(function()
    HouseTab:AddSection({ Name = "Auto Unban" })
end)

-- Toggle para Auto Unban
pcall(function()
    HouseTab:AddToggle({
        Name = "Auto Unban",
        Default = false,
        Callback = function(state)
            isUnbanActive = state
            if isUnbanActive then
                print("Auto Unban Activated")
                spawn(startAutoUnban)
            else
                print("Auto Unban Deactivated")
            end
        end
    })
end)

-- Label após Auto Unban
pcall(function()
    HouseTab:AddLabel("Te desbane automaticamente das Casas")
end)

-- Seção para Casa RGB
pcall(function()
    HouseTab:AddSection({ Name = "Casa RGB" })
end)

-- Toggle para Casa RGB
pcall(function()
    HouseTab:AddToggle({
        Name = "Casa RGB",
        Default = false,
        Callback = function(state)
            toggleHouseRGB(state)
        end
    })
end)

-- Label após Casa RGB
pcall(function()
    HouseTab:AddLabel("Deixa a sua casa RGB")
end)

-- Função para Auto Unban
function startAutoUnban()
    while isUnbanActive do
        pcall(function()
            for _, v in pairs(game:GetService("Workspace"):WaitForChild("001_Lots"):GetDescendants()) do
                if v.Name:match("^BannedBlock%d+$") then
                    v:Destroy()
                end
            end
        end)
        task.wait(1)
    end
end

local Tab = t3.MU

-- Create a section
Tab:AddSection({"Audio Todos os Players"})

-- Lista de áudios
local audios = {
    {Name = "Yamete Kudasai", ID = 108494476595033},
    {Name = "Gritinho", ID = 5710016194},
    {Name = "Jumpscare Horroroso", ID = 85435253347146},
    {Name = "Áudio Alto", ID = 6855150757},
    {Name = "Ruído", ID = 120034877160791},
    {Name = "Jumpscare 2", ID = 110637995610528},
    {Name = "Risada Da Bruxa Minecraft", ID = 116214940486087},
    {Name = "The Boiled One", ID = 137177653817621},
    {Name = "Deitei Um Ave Maria Doido", ID = 128669424001766},
    {Name = "Mandrake Detected", ID = 9068077052},
    {Name = "Aaaaaaaaa", ID = 80156405968805},
    {Name = "AAAHHHH", ID = 9084006093},
    {Name = "amongus", ID = 6651571134},
    {Name = "Sus", ID = 6701126635},
    {Name = "Gritao AAAAAAAAA", ID = 5853668794},
    {Name = "UHHHHH COFFCOFF", ID = 7056720271},
    {Name = "SUS", ID = 7153419575},
    {Name = "Sonic.exe", ID = 2496367477},
    {Name = "Tubers93 1", ID = 270145703},
    {Name = "Tubers93 2", ID = 18131809532},
    {Name = "John's Laugh", ID = 130759239},
    {Name = "Nao sei KKKK", ID = 6549021381},
    {Name = "Grito", ID = 80156405968805},
    {Name = "Sus Audio", ID = 7705506391},
    {Name = "AAAH", ID = 7772283448},
    {Name = "Gay, gay", ID = 18786647417},
    {Name = "Bat Hit", ID = 7129073354},
    {Name = "Nuclear Siren", ID = 675587093},
    {Name = "Sem ideia de nome KK", ID = 7520729342},
    {Name = "Grito 2", ID = 91412024101709},
    {Name = "Estora tímpano", ID = 268116333},
    {Name = "Gemidão", ID = 106835463235574},
    {Name = "Toma Jack", ID = 132603645477541},
    {Name = "Pede ifood pede", ID = 133843750864059},
    {Name = "I Ghost The down", ID = 84663543883498},
    {Name = "Compre OnLine Na shoope", ID = 8747441609},
    {Name = "Uh Que Nojo", ID = 103440368630269},
    {Name = "Sai dai Lava Prato", ID = 101232400175829},
    {Name = "Seloko num compensa", ID = 78442476709262},
}

local selectedAudioID

-- Adicionar uma textbox para inserir o ID do áudio
Tab:AddTextBox({
    Name = "Insira o ID do Áudio ou Musica",
    Description = "Digite o ID do áudio",
    PlaceholderText = "ID do áudio",
    Callback = function(value)
        selectedAudioID = tonumber(value)
    end
})

-- Adicionar uma dropdown para selecionar o áudio
local audioNames = {}
for _, audio in ipairs(audios) do
    table.insert(audioNames, audio.Name)
end

Tab:AddDropdown({
    Name = "Selecione o Áudio",
    Description = "Escolha um áudio da lista",
    Options = audioNames,
    Default = audioNames[1],
    Flag = "selected_audio",
    Callback = function(value)
        for _, audio in ipairs(audios) do
            if audio.Name == value then
                selectedAudioID = audio.ID
                break
            end
        end
    end
})

-- Controle do loop
local audioLoop = false

-- Nova seção para loop de áudio
Tab:AddSection({"Loop de Audio"})

-- Função para tocar o áudio repetidamente
local function playLoopedAudio()
    while audioLoop do
        if selectedAudioID then
            local args = {
                [1] = game:GetService("Workspace"),
                [2] = selectedAudioID,
                [3] = 1,
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gu1nSound1s"):FireServer(unpack(args))

            -- Criar e tocar o áudio
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. selectedAudioID
            sound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            sound:Play()
        else
            warn("Nenhum áudio selecionado!")
        end

        task.wait(0.5) -- Pequeno delay para evitar sobrecarga
    end
end

-- Toggle para loop de áudio
Tab:AddToggle({
    Name = "Loop Tocar Áudio",
    Description = "Ativa o loop do áudio",
    Default = false,
    Flag = "audio_loop",
    Callback = function(value)
        audioLoop = value
        if audioLoop then
            task.spawn(playLoopedAudio) -- Inicia o loop em uma nova thread
        end
    end
})

-- Adicionar um parágrafo como label
Tab:AddParagraph({"Info", "Loop de tocar Áudio (Todos players do Server ouvem)"})

-- Função para tocar o áudio normal
local function playAudio()
    if selectedAudioID then
        local args = {
            [1] = game:GetService("Workspace"),
            [2] = selectedAudioID,
            [3] = 1,
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gu1nSound1s"):FireServer(unpack(args))

        -- Criar e tocar o áudio
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. selectedAudioID
        sound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        sound:Play()
    else
        warn("Nenhum áudio selecionado!")
    end
end

-- Nova seção para tocar áudio
Tab:AddSection({"Tocar Áudio"})

-- Botão para tocar o áudio
Tab:AddButton({"Tocar Áudio", function()
    playAudio()
end})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local audioID = 6314880174 -- ID fixo do áudio

local function Audio_All_ClientSide(ID)
    local function CheckFolderAudioAll()
        local FolderAudio = workspace:FindFirstChild("Audio all client")
        if not FolderAudio then
            FolderAudio = Instance.new("Folder")
            FolderAudio.Name = "Audio all client"
            FolderAudio.Parent = workspace
        end
        return FolderAudio
    end

    local function CreateSound(ID)
        if type(ID) ~= "number" then
            print("Insira um número válido!")
            return nil
        end

        local Folder_Audio = CheckFolderAudioAll()
        if Folder_Audio then
            local Sound = Instance.new("Sound")
            Sound.SoundId = "rbxassetid://" .. ID
            Sound.Volume = 1
            Sound.Looped = false
            Sound.Parent = Folder_Audio
            Sound:Play()
            task.wait(1) -- Tempo de espera antes de remover o som
            Sound:Destroy()
        end
    end

    CreateSound(ID)
end

local function Audio_All_ServerSide(ID)
    if type(ID) ~= "number" then
        print("Insira um número válido!")
        return nil
    end

    local GunSoundEvent = ReplicatedStorage:FindFirstChild("1Gu1nSound1s", true)
    if GunSoundEvent then
        GunSoundEvent:FireServer(workspace, ID, 1)
    end
end

-- Toggle para "Estorar ouvido de geral"
Tab:AddToggle({
    Name = "Estorar ouvido de geral KK",
    Description = "Toca áudio repetidamente para todos",
    Default = false,
    Flag = "audio_spam",
    Callback = function(value)
        getgenv().Audio_All_loop_fast = value

        while getgenv().Audio_All_loop_fast do
            Audio_All_ServerSide(audioID)
            task.spawn(function()
                Audio_All_ClientSide(audioID)
            end)
            task.wait(0.03) -- Delay extremamente rápido (0.03 segundos)
        end
    end
})

Tab:AddParagraph({"Info", "Todos do server ouvem o áudio"})


local Tab = t3.S


-- Shutdown Custom Section
local Section = Tab:AddSection({
    Name = "Shutdown Personalizado"
})

-- Shutdown Server Button
Tab:AddButton({
    Name = "Shutdown Servidor",
    Callback = function()
        for m = 1, 495 do
            local args = {
                [1] = "PickingTools",
                [2] = "FireHose"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            local args = {
                [1] = "FireHose",
                [2] = "DestroyFireHose"
            }
            game:GetService("Players").LocalPlayer.Backpack.FireHose.ToolSound:FireServer(unpack(args))
        end
        local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -475, 999999999.414)
        local rootpart = game.Players.LocalPlayer.Character.HumanoidRootPart
        repeat wait() until rootpart.Parent == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Shutdown Concluído, Agora Vai Desligar"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait()
        for _, ergeg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if ergeg.Name == "FireHose" then
                ergeg.Parent = game.Players.LocalPlayer.Character
            end
        end
        wait(0.2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Iniciando duplicação, seja paciente"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, -475, 9999)
    end
})

-- Shutdown Server (Internet Error) Button
Tab:AddButton({
    Name = "Shutdown Servidor (Erro de Internet)",
    Callback = function()
        for m = 1, 535 do
            local args = {
                [1] = "PickingTools",
                [2] = "FireHose"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            local args = {
                [1] = "FireHose",
                [2] = "DestroyFireHose"
            }
            game:GetService("Players").LocalPlayer.Backpack.FireHose.ToolSound:FireServer(unpack(args))
        end
        local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -475, 999999999.414)
        local rootpart = game.Players.LocalPlayer.Character.HumanoidRootPart
        repeat wait() until rootpart.Parent == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Shutdown Concluído, Agora Vai Desligar"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait()
        for _, ergeg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if ergeg.Name == "FireHose" then
                ergeg.Parent = game.Players.LocalPlayer.Character
            end
        end
        wait(0.2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Iniciando duplicação, seja paciente"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, -475, 9999)
    end
})

-- Shutdown Server (Timeout Error) Button
Tab:AddButton({
    Name = "Shutdown Servidor (Erro de Conexão Expirada)",
    Callback = function()
        for m = 1, 635 do
            local args = {
                [1] = "PickingTools",
                [2] = "FireHose"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            local args = {
                [1] = "FireHose",
                [2] = "DestroyFireHose"
            }
            game:GetService("Players").LocalPlayer.Backpack.FireHose.ToolSound:FireServer(unpack(args))
        end
        local oldcf = game. ascended
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Shutdown Concluído, Agora Vai Desligar"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait()
        for _, ergeg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if ergeg.Name == "FireHose" then
                ergeg.Parent = game.Players.LocalPlayer.Character
            end
        end
        wait(0.2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Script de Dupe"),
            Text = lib:T("Iniciando duplicação, seja paciente"),
            Button1 = lib:T("Ok"),
            Duration = 5
        })
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, -475, 9999)
    end
})

-- Lag Laptop Section
local Section = Tab:AddSection({
    Name = "Lag com Laptop"
})

-- Toggle State for Lag Laptop
local toggles = { LagLaptop = false }

-- Function to Simulate Normal Click
local function clickNormally(object)
    local clickDetector = object:FindFirstChildWhichIsA("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
    end
end

-- Function to Lag Game with Laptop
local function lagarJogoLaptop(laptopPath, maxTeleports)
    if laptopPath then
        local teleportCount = 0
        while teleportCount < maxTeleports and toggles.LagLaptop do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = laptopPath.CFrame
            clickNormally(laptopPath)
            teleportCount = teleportCount + 1
            wait(0.0001)
        end
    else
        warn("Laptop não encontrado.")
    end
end

-- Lag Laptop Toggle
Tab:AddToggle({
    Name = "Lag com Laptop",
    Default = false,
    Callback = function(state)
        toggles.LagLaptop = state
        if state then
            local laptopPath = workspace:FindFirstChild("WorkspaceCom"):FindFirstChild("001_GiveTools"):FindFirstChild("Laptop")
            if laptopPath then
                spawn(function()
                    lagarJogoLaptop(laptopPath, 999999999)
                end)
            else
                warn("Laptop não encontrado.")
            end
        else
            print("Lag com Laptop desativado.")
        end
    end
})

-- Lag Laptop Paragraph
Tab:AddParagraph({
    "Informação de Lag",
    "O efeito de lag começa após 35 segundos"
})

-- Lag Phone Section
local Section = Tab:AddSection({
    Name = "Lag com Telefone"
})

-- Toggle State for Lag Phone
toggles.LagPhone = false

-- Function to Lag Game with Phone
local function lagarJogoPhone(phonePath, maxTeleports)
    if phonePath then
        local teleportCount = 0
        while teleportCount < maxTeleports and toggles.LagPhone do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = phonePath.CFrame
            clickNormally(phonePath)
            teleportCount = teleportCount + 1
            wait(0.01)
        end
    else
        warn("Telefone não encontrado.")
    end
end

-- Lag Phone Toggle
Tab:AddToggle({
    Name = "Lag com Telefone",
    Default = false,
    Callback = function(state)
        toggles.LagPhone = state
        if state then
            local phonePath = workspace:FindFirstChild("WorkspaceCom"):FindFirstChild("001_CommercialStores"):FindFirstChild("CommercialStorage1"):FindFirstChild("Store"):FindFirstChild("Tools"):FindFirstChild("Iphone")
            if phonePath then
                spawn(function()
                    lagarJogoPhone(phonePath, 999999)
                end)
            else
                warn("Telefone não encontrado.")
            end
        else
            print("Lag com Telefone desativado.")
        end
    end
})

-- Lag Phone Paragraph
Tab:AddParagraph({
    "Informação de Lag",
    "O script começa a causar lag após 35 segundos"
})

local Section = Tab:AddSection({
    Name = "Lag com Bomba"
})


local BombActive = false

Tab:AddToggle({
    Name = "Lag com Bomba",
    Default = false,
    Callback = function(Value)
        if Value then
            BombActive = true

            local Player = game.Players.LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local RootPart = Character:WaitForChild("HumanoidRootPart")
            local WorkspaceService = game:GetService("Workspace")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Bomb = WorkspaceService:WaitForChild("WorkspaceCom"):WaitForChild("001_CriminalWeapons"):WaitForChild("GiveTools"):WaitForChild("Bomb")

            task.spawn(function()
                while BombActive do
                    if Bomb and RootPart then
                        RootPart.CFrame = Bomb.CFrame
                        fireclickdetector(Bomb.ClickDetector) -- Aciona o ClickDetector da bomba
                        task.wait(0.00001) -- Delay mínimo para evitar travamentos
                    else
                        task.wait(0.0001) 
                    end
                end
            end)

            task.spawn(function()
                while BombActive do
                    if Bomb and RootPart then
                        local VirtualInputManager = game:GetService("VirtualInputManager")
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0) 
                        task.wait(1.5)
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0) 

                        -- Executa o FireServer com o nome do jogador
                        local args = {
                            [1] = "Bomb" .. Player.Name -- Usa o nome do jogador atual
                        }
                        ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Blo1wBomb1sServe1r"):FireServer(unpack(args))
                    end
                    task.wait(1.5) -- Intervalo de 1 segundo para clique e FireServer
                end
            end)
        else
            -- Desativando a funcionalidade
            BombActive = false
        end
    end
})

Tab:AddParagraph({
    "Informação de Lag",
    "O script começa a causar lag após 35 segundos"
})

local Tab = t3.H

local isNameActive = false
local isBioActive = false

local SectionRGBName = Tab:AddSection({
    Name = "Nome RGB"
})

Tab:AddToggle({
    Name = "Nome RGB",
    Description = "Ativar Nome RGB",
    Default = false,
    Callback = function(value)
        isNameActive = value
        print(value and "RGB Name ativado" or "RGB Name desativado")
    end
})


local SectionRGBBio = Tab:AddSection({
    Name = "RGB BIO"
})

Tab:AddToggle({
    Name = "RGB BIO",
    Description = "Ativar RGB BIO",
    Default = false,
    Callback = function(value)
        isBioActive = value
        print(value and "RGB BIO ativado" or "RGB BIO desativado")
    end
})


local vibrantColors = {
    Color3.fromRGB(255, 0, 0),   -- Vermelho
    Color3.fromRGB(0, 255, 0),   -- Verde
    Color3.fromRGB(0, 0, 255),   -- Azul
    Color3.fromRGB(255, 255, 0), -- Amarelo
    Color3.fromRGB(255, 0, 255), -- Magenta
    Color3.fromRGB(0, 255, 255), -- Ciano
    Color3.fromRGB(255, 165, 0), -- Laranja
    Color3.fromRGB(128, 0, 128), -- Roxo
    Color3.fromRGB(255, 20, 147) -- Rosa choque
}

spawn(function()
    while true do
        if isNameActive then
            local randomColor = vibrantColors[math.random(#vibrantColors)]
            local args = {
                [1] = "PickingRPNameColor",
                [2] = randomColor
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(args))
        end
        wait(0.7)
    end
end)

spawn(function()
    while true do
        if isBioActive then
            local randomColor = vibrantColors[math.random(#vibrantColors)]
            local args = {
                [1] = "PickingRPBioColor",
                [2] = randomColor
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eColo1r"):FireServer(unpack(args))
        end
        wait(0.7)
    end
end)

local SectionNames = Tab:AddSection({
    Name = "Adicionar Nomes no Jogador"
})

local names = {
    {"Anonymus", " Anonymus "},
    {"PRO", " PRO "},
    {"ERR0R_666", " ERR0R_666 "},
    {"DARKNE1SSS", " DARKNE1SSS "},
    {"GHOST", " GHOST "},
    {"JOKER", " JOKER "},
    {"ADMIN", " ADMIN "},
    {"TUBERS93", " TUBERS 93 "},
    {"CO0LKID", " CO0 LKID "},
    {"GAME ATTACKED BY LIAN [FLOW]", " GAME ATTACKED BY LIAN [FLOW] "},
    {"INC0MUN", " INC0MUN"},
    {"BAD BOY", " BAD BOY "}
}

for _, name in ipairs(names) do
    Tab:AddButton({
        Name = lib:T("Name: ") .. name[1],
        Callback = function()
            game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayName", name[2])
        end
    })
end


local CarTab = t3.Carros

-- Colors for RGB
local colors = {
    Color3.new(1, 0, 0),     -- Red
    Color3.new(0, 1, 0),     -- Green
    Color3.new(0, 0, 1),     -- Blue
    Color3.new(1, 1, 0),     -- Yellow
    Color3.new(1, 0, 1),     -- Magenta
    Color3.new(0, 1, 1),     -- Cyan
    Color3.new(0.5, 0, 0.5), -- Purple
    Color3.new(1, 0.5, 0)    -- Orange
}

-- Replicated Storage Service
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = replicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r")

-- RGB Color Change Logic
local isColorChanging = false
local colorChangeCoroutine = nil

local function changeCarColor()
    while isColorChanging do
        for _, color in ipairs(colors) do
            if not isColorChanging then return end
            local args = {
                [1] = "PickingCarColor",
                [2] = color
            }
            remoteEvent:FireServer(unpack(args))
            wait(1)
        end
    end
end

CarTab:AddButton({
    Name = "Remove All Cars",
    Callback = function()
        local ofnawufn = false

if ofnawufn == true then
    return
end
ofnawufn = true

local cawwfer = "MilitaryBoatFree" -- Alterado para MilitaryBoatFree
local oldcfffff = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58) -- Coordenadas atualizadas
wait(0.3)

local args = {
    [1] = "PickingBoat", -- Alterado para PickingBoat
    [2] = cawwfer
}

game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
wait(1)

local wrinfjn
for _, errb in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"]:GetDescendants()) do
    if errb:IsA("VehicleSeat") then
        wrinfjn = errb
    end
end

repeat
    if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then return end
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
        if not game.Players.LocalPlayer.Character.Humanoid.SeatPart == wrinfjn then
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame + Vector3.new(0,1,0)
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame + Vector3.new(0,-1,0)
    task.wait()
until game.Players.LocalPlayer.Character.Humanoid.SeatPart == wrinfjn

for _, wifn in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"]:GetDescendants()) do
    if wifn.Name == "PhysicalWheel" then
        wifn:Destroy()
    end
end

local FLINGED = Instance.new("BodyThrust", game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass) 
FLINGED.Force = Vector3.new(50000, 0, 50000) 
FLINGED.Name = "FLOW HUB FLING"
FLINGED.Location = game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.Position

for _, wvwvwasc in pairs(game.workspace.Vehicles:GetChildren()) do
    for _, ascegr in pairs(wvwvwasc:GetDescendants()) do
        if ascegr.Name == "VehicleSeat" then
            local targetcar = ascegr
            local tet = Instance.new("BodyVelocity", game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass)
            tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            tet.P = 1250
            tet.Velocity = Vector3.new(0,0,0)
            tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
            for m=1,25 do
                local pos = {x=0, y=0, z=0}
                pos.x = targetcar.Position.X
                pos.y = targetcar.Position.Y
                pos.z = targetcar.Position.Z
                pos.x = pos.x + targetcar.Velocity.X / 2
                pos.y = pos.y + targetcar.Velocity.Y / 2
                pos.z = pos.z + targetcar.Velocity.Z / 2
                if pos.y <= -200 then
                    game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(0,1000,0)
                else
                    game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z))
                    task.wait()
                    game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) + Vector3.new(0,-2,0)
                    task.wait()
                    game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(0,0,2)
                    task.wait()
                    game.workspace.Vehicles[
game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(2,0,0)
                    task.wait()
                end
                task.wait()
            end
        end
    end
end

task.wait()
local args = {
    [1] = "DeleteAllVehicles"
}

game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
game.Players.LocalPlayer.Character.Humanoid.Sit = false
wait()
local tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
tet.P = 1250
tet.Velocity = Vector3.new(0,0,0)
tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
wait(0.1)
for m=1,2 do 
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcfffff
end
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcfffff
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"):Destroy()
wait(0.2)
ofnawufn = false
    end
})

CarTab:AddParagraph({"Informação:", "Recomendo usar 2 vezes para garantir que todos os veículos sejam removidos"})

CarTab:AddButton({
    Name = "Bring All Cars",
    Callback = function()
        for _, v in next, workspace.Vehicles:GetChildren() do
            v:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character:GetPrimaryPartCFrame())
        end
    end
})

CarTab:AddParagraph({"Informação:", "Puxa todos os carros do servidor até você"})

-- Speed V1 Section
local SpeedSection = CarTab:AddSection({"Speed V1"})

local Speed = 50
local Turbo = 50

local function ChangeCarSpeedAndTurbo(speedValue, turboValue)
    local player = game.Players.LocalPlayer
    local car = workspace.Vehicles:FindFirstChild(player.Name .. "Car")

    if car then
        local body = car:FindFirstChild("Body").VehicleSeat
        if body then
            body.TopSpeed.Value = speedValue
            body.Turbo.Value = turboValue
            wait(0.1)
            redzlib:MakeNotification({
                Name = "Flow Hub",
                Content = "Done, You can Move Now!",
                Time = 5
            })
        else
            redzlib:MakeNotification({
                Name = "Error",
                Content = "Sit in car first!",
                Time = 5
            })
        end
    else
        redzlib:MakeNotification({
            Name = "Error",
            Content = "Put a Car First!",
            Time = 5
        })
    end
end

CarTab:AddTextBox({
    Name = "Speed",
    PlaceholderText = "50",
    Callback = function(value)
        local newSpeed = tonumber(value)
        if newSpeed then
            Speed = newSpeed
        end
    end
})

CarTab:AddTextBox({
    Name = "Turbo",
    PlaceholderText = "50",
    Callback = function(value)
        local newTurbo = tonumber(value)
        if newTurbo then
            Turbo = newTurbo
        end
    end
})

CarTab:AddTextBox({
    Name = "Drift",
    PlaceholderText = "50",
    Callback = function(value)
        local args = {
            [1] = "DriftingNumber",
            [2] = value
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sCa1r"):FireServer(unpack(args))
    end
})

CarTab:AddButton({
    Name = "Aplicar Velocidade, Turbo e drift",
    Callback = function()
        ChangeCarSpeedAndTurbo(Speed, Turbo)
    end
})

-- Turbo V2 Section
local TurboSection = CarTab:AddSection({"Turbo V2"})

CarTab:AddButton({
    Name = "Turbo V2 [Melhor]",
    Callback = function()
     local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

local voando = false
local velocidade = 30

local telaGui = Instance.new("ScreenGui", player.PlayerGui)

local function criarBotaoImagem(nome, posicao, idImagem, rotacao, acao)
    local botao = Instance.new("ImageButton", telaGui)
    botao.Size = UDim2.new(0, 60, 0, 60)
    botao.Position = posicao
    botao.BackgroundTransparency = 1
    botao.Image = "rbxassetid://" .. idImagem
    botao.Rotation = rotacao
    botao.MouseButton1Down:Connect(acao)
    return botao
end

local botaoFrente = criarBotaoImagem("BotaoFrente", UDim2.new(0, 10, 0.35, 0), "18478249606", 0, function()
    voando = true
    while voando do
        if humanoidRootPart then
            humanoidRootPart.Velocity = humanoidRootPart.CFrame.LookVector * velocidade
        end
        task.wait()
    end
end)

local botaoTras = criarBotaoImagem("BotaoTras", UDim2.new(0, 10, 0.5, 0), "18478249606", 180, function()
    voando = true
    while voando do
        if humanoidRootPart then
            humanoidRootPart.Velocity = -humanoidRootPart.CFrame.LookVector * velocidade
        end
        task.wait()
    end
end)

local botaoEsquerda = criarBotaoImagem("BotaoEsquerda", UDim2.new(1, -210, 0.3, 0), "18478249606", -90, function()
    voando = true
    while voando do
        if humanoidRootPart then
            humanoidRootPart.Velocity = -humanoidRootPart.CFrame.RightVector * velocidade
        end
        task.wait()
    end
end)

local botaoDireita = criarBotaoImagem("BotaoDireita", UDim2.new(1, -140, 0.3, 0), "18478249606", 90, function()
    voando = true
    while voando do
        if humanoidRootPart then
            humanoidRootPart.Velocity = humanoidRootPart.CFrame.RightVector * velocidade
        end
        task.wait()
    end
end)

local function pararVoo()
    voando = false
    if humanoidRootPart then
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

botaoFrente.MouseButton1Up:Connect(pararVoo)
botaoTras.MouseButton1Up:Connect(pararVoo)
botaoEsquerda.MouseButton1Up:Connect(pararVoo)
botaoDireita.MouseButton1Up:Connect(pararVoo)

local botaoTurbo = Instance.new("ImageButton", telaGui)
botaoTurbo.Size = UDim2.new(0, 60, 0, 60)
botaoTurbo.Position = UDim2.new(1, -130, 0, 10)
botaoTurbo.BackgroundTransparency = 1
botaoTurbo.Image = "rbxassetid://97607579386418"
botaoTurbo.MouseButton1Down:Connect(function()
    velocidade = 300
end)

-- Botão de minimizar (com "+" ou "-" dependendo do estado)
local botaoMinimizar = Instance.new("TextButton", telaGui)
botaoMinimizar.Size = UDim2.new(0, 60, 0, 60)
botaoMinimizar.Position = UDim2.new(0, 10, 0, 10)  -- Alterado para o canto superior esquerdo
botaoMinimizar.BackgroundTransparency = 1
botaoMinimizar.Text = "-"  -- Inicia com o símbolo de "-"
botaoMinimizar.TextSize = 40
botaoMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)

local botoes = {botaoFrente, botaoTras, botaoEsquerda, botaoDireita, botaoTurbo}

local minimizado = false

local function alternarBotoes()
    minimizado = not minimizado
    for _, botao in ipairs(botoes) do
        botao.Visible = not minimizado
    end
    -- Alterar o texto do botão de minimizar
    if minimizado then
        botaoMinimizar.Text = "+"
    else
        botaoMinimizar.Text = "-"
    end
end

botaoMinimizar.MouseButton1Down:Connect(alternarBotoes)    
    end
})

CarTab:AddParagraph({"Informação:", "Ambos os turbos não precisam de Gamepass"})

-- Music Section
local MusicSection = t3.MU:AddSection({"Music by ID"})

local musicIds = {
    "71373562243752", "138129019858244", "138480372357526", "122199933878670",
    "74187181906707", "82793916573031", "107421761958790", "91394092603440",
    "113198957973421", "81452315991527", "93786060174790", "74752089069476",
    "131592235762789", "132081774507495", "124394293950763", "83381647646350",
    "16190782181", "1841682637", "3148329638", "124928367733395",
    "106317184644394", "100247055114504", "107035638005233", "109351649716900",
    "84751398517083", "125259969174449", "89269071829332", "88094479399489",
    "72440232513341", "92893359226454", "111281710445018", "98677515506006",
    "105882833374061", "104541292443133", "105832154444494", "84733736048142",
    "94718473830640", "130324826943718", "123039027577735", "113312785512702",
    "139161205970637", "113768944849093", "135667903253566", "81335392002580",
    "77428091165211", "14145624031", "8080255618", "8654835474",
    "13530439502", "18841894272", "90323407842935", "136932193331774",
    "113504863495384", "1836175030", "79998949362539", "109188610023287",
    "134939857094956", "132245626038510", "124567809277408", "72591334498716",
    "76578817848504", "17422156627", "81902909302285", "130449561461006",
    "110519234838026", "106434295960535", "86271123924168", "85481949732828",
    "106476166672589", "87968531262747", "73966367524216", "137962454483542",
    "98371771055411", "111668097052966", "140095882383991", "122873874738223",
    "105461615542794"
}

local function playCarMusic(musicId)
    if musicId and musicId ~= "" then
        local carArgs = {
            [1] = "PickingCarMusicText",
            [2] = musicId
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sCa1r"):FireServer(unpack(carArgs))
    end
end

local function playScooterMusic(musicId)
    if musicId and musicId ~= "" then
        local scooterArgs = {
            [1] = "PickingScooterMusicText",
            [2] = musicId
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer(unpack(scooterArgs))
    end
end

local function playHouseMusic(musicId)
    if musicId and musicId ~= "" then
        local houseArgs = {
            [1] = "PickHouseMusicText",
            [2] = musicId
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer(unpack(houseArgs))
    end
end

t3.MU:AddTextBox({
    Name = "Music ID (Gamepass Required)",
    PlaceholderText = "Enter Music ID",
    Callback = function(value)
        playCarMusic(value)
        playScooterMusic(value)
        playHouseMusic(value)
    end
})

t3.MU:AddDropdown({
    Name = "Select Music (Gamepass Required)",
    Options = musicIds,
    Callback = function(value)
        playCarMusic(value)
        playScooterMusic(value)
        playHouseMusic(value)
    end
})

t3.MU:AddParagraph({"Note", "O script de música funciona em todos os carros e casas"})

-- Car RGB Section
local RGBSection = CarTab:AddSection({"Car RGB"})

CarTab:AddToggle({
    Name = "Car RGB",
    Default = false,
    Callback = function(state)
        isColorChanging = state
        if isColorChanging then
            colorChangeCoroutine = coroutine.create(changeCarColor)
            coroutine.resume(colorChangeCoroutine)
        end
    end
})

CarTab:AddParagraph({"Note", "Ativando isso deixará seu carro RGB"})

-- Spam Horn Section
local HornSection = CarTab:AddSection({"Spam Horn"})

local spamming = false
local args = {"Horn"}

local function spamHorn()
    while spamming do
        remoteEvent:FireServer(unpack(args))
        wait(0.1)
    end
end

CarTab:AddToggle({
    Name = "Spam Horn",
    Default = false,
    Callback = function(value)
        spamming = value
        if spamming then
            spawn(spamHorn)
        end
    end
})

-- Fly Car Section
local FlySection = CarTab:AddSection({"Fly Car"})

CarTab:AddButton({
    Name = "Fly Car",
    Callback = function()
        --by Lian
-- Version: 4.1

-- Instances:
local Flymguiv2 = Instance.new("ScreenGui")
local Drag = Instance.new("Frame")
local FlyFrame = Instance.new("Frame")
local ddnsfbfwewefe = Instance.new("TextButton")
local Speed = Instance.new("TextBox")
local Fly = Instance.new("TextButton")
local Speeed = Instance.new("TextLabel")
local Stat = Instance.new("TextLabel")
local Stat2 = Instance.new("TextLabel")
local Unfly = Instance.new("TextButton")
local Vfly = Instance.new("TextLabel")
local Close = Instance.new("TextButton")
local Minimize = Instance.new("TextButton")
local Flyon = Instance.new("Frame")
local W = Instance.new("TextButton")
local S = Instance.new("TextButton")

--Properties:

Flymguiv2.Name = "Car Fly gui v2"
Flymguiv2.Parent = game.CoreGui
Flymguiv2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Drag.Name = "Drag"
Drag.Parent = Flymguiv2
Drag.Active = true
Drag.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Drag.BorderSizePixel = 0
Drag.Draggable = true
Drag.Position = UDim2.new(0.482438415, 0, 0.454874992, 0)
Drag.Size = UDim2.new(0, 237, 0, 27)

FlyFrame.Name = "FlyFrame"
FlyFrame.Parent = Drag
FlyFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FlyFrame.BorderSizePixel = 0
FlyFrame.Draggable = true
FlyFrame.Position = UDim2.new(-0.00200000009, 0, 0.989000022, 0)
FlyFrame.Size = UDim2.new(0, 237, 0, 139)

ddnsfbfwewefe.Name = "ddnsfbfwewefe"
ddnsfbfwewefe.Parent = FlyFrame
ddnsfbfwewefe.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
ddnsfbfwewefe.BorderSizePixel = 0
ddnsfbfwewefe.Position = UDim2.new(-0.000210968778, 0, -0.00395679474, 0)
ddnsfbfwewefe.Size = UDim2.new(0, 237, 0, 27)
ddnsfbfwewefe.Font = Enum.Font.SourceSans
ddnsfbfwewefe.Text = "by Lian [flow]"
ddnsfbfwewefe.TextColor3 = Color3.fromRGB(255, 255, 255)
ddnsfbfwewefe.TextScaled = true
ddnsfbfwewefe.TextSize = 14.000
ddnsfbfwewefe.TextWrapped = true

Speed.Name = "Speed"
Speed.Parent = FlyFrame
Speed.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
Speed.BorderColor3 = Color3.fromRGB(0, 0, 191)
Speed.BorderSizePixel = 0
Speed.Position = UDim2.new(0.445025861, 0, 0.402877688, 0)
Speed.Size = UDim2.new(0, 111, 0, 33)
Speed.Font = Enum.Font.SourceSans
Speed.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
Speed.Text = "50"
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.TextScaled = true
Speed.TextSize = 14.000
Speed.TextWrapped = true

Fly.Name = "Fly"
Fly.Parent = FlyFrame
Fly.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Fly.BorderSizePixel = 0
Fly.Position = UDim2.new(0.0759493634, 0, 0.705797076, 0)
Fly.Size = UDim2.new(0, 199, 0, 32)
Fly.Font = Enum.Font.SourceSans
Fly.Text = "Enable"
Fly.TextColor3 = Color3.fromRGB(255, 255, 255)
Fly.TextScaled = true
Fly.TextSize = 14.000
Fly.TextWrapped = true
Fly.MouseButton1Click:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	Fly.Visible = false
	Stat2.Text = "On"
	Stat2.TextColor3 = Color3.fromRGB(0, 255, 0)
	Unfly.Visible = true
	Flyon.Visible = true
	local BV = Instance.new("BodyVelocity",HumanoidRP)
	local BG = Instance.new("BodyGyro",HumanoidRP)
	BV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	game:GetService('RunService').RenderStepped:connect(function()
	BG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
	BG.D = 5000
	BG.P = 100000
	BG.CFrame = game.Workspace.CurrentCamera.CFrame
	end)
end)

Speeed.Name = "Speeed"
Speeed.Parent = FlyFrame
Speeed.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Speeed.BorderSizePixel = 0
Speeed.Position = UDim2.new(0.0759493634, 0, 0.402877688, 0)
Speeed.Size = UDim2.new(0, 87, 0, 32)
Speeed.ZIndex = 0
Speeed.Font = Enum.Font.SourceSans
Speeed.Text = "Speed:"
Speeed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speeed.TextScaled = true
Speeed.TextSize = 14.000
Speeed.TextWrapped = true

Stat.Name = "Stat"
Stat.Parent = FlyFrame
Stat.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Stat.BorderSizePixel = 0
Stat.Position = UDim2.new(0.299983799, 0, 0.239817441, 0)
Stat.Size = UDim2.new(0, 85, 0, 15)
Stat.Font = Enum.Font.SourceSans
Stat.Text = "Status:"
Stat.TextColor3 = Color3.fromRGB(255, 255, 255)
Stat.TextScaled = true
Stat.TextSize = 14.000
Stat.TextWrapped = true

Stat2.Name = "Stat2"
Stat2.Parent = FlyFrame
Stat2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Stat2.BorderSizePixel = 0
Stat2.Position = UDim2.new(0.546535194, 0, 0.239817441, 0)
Stat2.Size = UDim2.new(0, 27, 0, 15)
Stat2.Font = Enum.Font.SourceSans
Stat2.Text = "Off"
Stat2.TextColor3 = Color3.fromRGB(255, 0, 0)
Stat2.TextScaled = true
Stat2.TextSize = 14.000
Stat2.TextWrapped = true

Unfly.Name = "Unfly"
Unfly.Parent = FlyFrame
Unfly.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Unfly.BorderSizePixel = 0
Unfly.Position = UDim2.new(0.0759493634, 0, 0.705797076, 0)
Unfly.Size = UDim2.new(0, 199, 0, 32)
Unfly.Visible = false
Unfly.Font = Enum.Font.SourceSans
Unfly.Text = "Disable"
Unfly.TextColor3 = Color3.fromRGB(255, 255, 255)
Unfly.TextScaled = true
Unfly.TextSize = 14.000
Unfly.TextWrapped = true
Unfly.MouseButton1Click:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	Fly.Visible = true
	Stat2.Text = "Off"
	Stat2.TextColor3 = Color3.fromRGB(255, 0, 0)
	wait()
	Unfly.Visible = false
	Flyon.Visible = false
	HumanoidRP:FindFirstChildOfClass("BodyVelocity"):Destroy()
	HumanoidRP:FindFirstChildOfClass("BodyGyro"):Destroy()
end)

Vfly.Name = "Vfly"
Vfly.Parent = Drag
Vfly.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Vfly.BorderSizePixel = 0
Vfly.Size = UDim2.new(0, 57, 0, 27)
Vfly.Font = Enum.Font.SourceSans
Vfly.Text = "Car fly"
Vfly.TextColor3 = Color3.fromRGB(255, 255, 255)
Vfly.TextScaled = true
Vfly.TextSize = 14.000
Vfly.TextWrapped = true

Close.Name = "Close"
Close.Parent = Drag
Close.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.875, 0, 0, 0)
Close.Size = UDim2.new(0, 27, 0, 27)
Close.Font = Enum.Font.SourceSans
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextScaled = true
Close.TextSize = 14.000
Close.TextWrapped = true
Close.MouseButton1Click:Connect(function()
	Flymguiv2:Destroy()
end)

Minimize.Name = "Minimize"
Minimize.Parent = Drag
Minimize.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
Minimize.BorderSizePixel = 0
Minimize.Position = UDim2.new(0.75, 0, 0, 0)
Minimize.Size = UDim2.new(0, 27, 0, 27)
Minimize.Font = Enum.Font.SourceSans
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextScaled = true
Minimize.TextSize = 14.000
Minimize.TextWrapped = true
function Mini()
	if Minimize.Text == "-" then
		Minimize.Text = "+"
		FlyFrame.Visible = false
	elseif Minimize.Text == "+" then
		Minimize.Text = "-"
		FlyFrame.Visible = true
	end
end
Minimize.MouseButton1Click:Connect(Mini)

Flyon.Name = "Fly on"
Flyon.Parent = Flymguiv2
Flyon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Flyon.BorderSizePixel = 0
Flyon.Position = UDim2.new(0.117647067, 0, 0.550284624, 0)
Flyon.Size = UDim2.new(0.148000002, 0, 0.314999998, 0)
Flyon.Visible = false
Flyon.Active = true
Flyon.Draggable = true

W.Name = "W"
W.Parent = Flyon
W.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
W.BorderSizePixel = 0
W.Position = UDim2.new(0.134719521, 0, 0.0152013302, 0)
W.Size = UDim2.new(0.708999991, 0, 0.499000013, 0)
W.Font = Enum.Font.SourceSans
W.Text = "^"
W.TextColor3 = Color3.fromRGB(255, 255, 255)
W.TextScaled = true
W.TextSize = 14.000
W.TextWrapped = true
W.TouchLongPress:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

W.MouseButton1Click:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

S.Name = "S"
S.Parent = Flyon
S.BackgroundColor3 = Color3.fromRGB(0, 150, 191)
S.BorderSizePixel = 0
S.Position = UDim2.new(0.134000003, 0, 0.479999989, 0)
S.Rotation = 180.000
S.Size = UDim2.new(0.708999991, 0, 0.499000013, 0)
S.Font = Enum.Font.SourceSans
S.Text = "^"
S.TextColor3 = Color3.fromRGB(255, 255, 255)
S.TextScaled = true
S.TextSize = 14.000
S.TextWrapped = true
S.TouchLongPress:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)

S.MouseButton1Click:Connect(function()
	local HumanoidRP = game.Players.LocalPlayer.Character.HumanoidRootPart
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * -Speed.Text
	wait(.1)
	HumanoidRP.BodyVelocity.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * 0
end)
    end
})

CarTab:AddParagraph({"Note", "Ativando isso você pode voar com o seu carro"})

-- Spam Cars Section
local SpamCarSection = CarTab:AddSection({"Spam Car"})

local carList = {
    "SchoolBus", "SmartCar", "FarmTruck", "Cadillac", "Excavator",
    "Jeep", "NascarTruck", "TowTruck", "Snowplow", "MilitaryTruck",
    "Tank", "Limo", "FireTruck"
}

local spamCarsActive = false

local function spawnCar(carName)
    local args = {
        [1] = "PickingCar",
        [2] = carName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
end

CarTab:AddToggle({
    Name = "Spam Cars",
    Default = false,
    Callback = function(state)
        spamCarsActive = state
        if spamCarsActive then
            task.spawn(function()
                while spamCarsActive do
                    for _, carName in ipairs(carList) do
                        if not spamCarsActive then break end
                        spawnCar(carName)
                        wait(0.4)
                    end
                end
            end)
        end
    end
})

CarTab:AddParagraph({"Informação:", "Spamar vários carros"})



-- Variáveis globais
local pl = game.Players.LocalPlayer
local players = {}

-- Função para atualizar a lista de players
local function updatePlayerList()
    players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        table.insert(players, player.Name)
    end
    return players
end

-- Inicializa a lista de players
updatePlayerList()

-- Aba Child
local ChildTab = t3.TT

local Section = ChildTab:AddSection({
    Name = "Child"
})

local chasingplayer = nil
local playerChild = ChildTab:AddDropdown({
    Name = "Selecione um player para perseguir",
    Options = players,
    Default = "",
    Callback = function(selected)
        if game.Players:FindFirstChild(selected) then
            chasingplayer = selected
        else
            chasingplayer = nil
        end
    end
})

ChildTab:AddButton({
    Name = "Atualizar Player List",
    Callback = function()
        local updatedPlayers = updatePlayerList()
        if playerChild and updatedPlayers then
            pcall(function()
                playerChild:Refresh(updatedPlayers)
            end)
            if chasingplayer and not game.Players:FindFirstChild(chasingplayer) then
                chasingplayer = nil
                pcall(function()
                    playerChild:Set("")
                end)
            end
        end
    end
})

-- Eventos de entrada/saída de players
game.Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    local updatedPlayers = updatePlayerList()
    if playerChild and updatedPlayers then
        pcall(function()
            playerChild:Refresh(updatedPlayers)
        end)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    task.wait(0.1)
    local updatedPlayers = updatePlayerList()
    if playerChild and updatedPlayers then
        pcall(function()
            playerChild:Refresh(updatedPlayers)
        end)
        if chasingplayer == player.Name then
            chasingplayer = nil
            pcall(function()
                playerChild:Set("")
            end)
        end
    end
end)

ChildTab:AddButton({
    Name = "Enviar criança",
    Callback = function()
        if not chasingplayer then
            warn("Nenhum jogador selecionado!")
            return
        end
        if not workspace:FindFirstChild(pl.Name) or not workspace[pl.Name]:FindFirstChild("FollowCharacter") then
            local args = {
                [1] = "CharacterFollowSpawnPlayer",
                [2] = "BabyBoy"
            }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))
            end)
            if not success then
                warn("Erro ao enviar criança: " .. err)
            end
        end
        
        task.wait(0.2)
        
        if workspace:FindFirstChild(pl.Name) then
            for _, v in pairs(workspace[pl.Name]:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end

        local target = chasingplayer
        if workspace:FindFirstChild(target) and workspace:FindFirstChild(pl.Name) and workspace[pl.Name]:FindFirstChild("FollowCharacter") then
            workspace[pl.Name].FollowCharacter.Parent = workspace[target]

            if rawget(getgenv(), "RunService") then
                return
            end

            getgenv().RunService = game:GetService("RunService").Heartbeat:Connect(function()
                local followCharacter = workspace[target]:FindFirstChild("FollowCharacter")
                if followCharacter and followCharacter:FindFirstChild("Torso") and followCharacter.Torso:FindFirstChild("BodyPosition") then
                    local humanoidRootPart = workspace[target]:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        followCharacter.Torso.BodyPosition.Position = humanoidRootPart.Position - (humanoidRootPart.CFrame.LookVector * 3)
                        followCharacter.Torso.BodyGyro.CFrame = humanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})

ChildTab:AddButton({
    Name = "Retornar criança",
    Callback = function()
        if rawget(getgenv(), "RunService") then
            getgenv().RunService:Disconnect()
            getgenv().RunService = nil
        end

        local args = { [1] = "DeleteFollowCharacter" }
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))
        end)
        if not success then
            warn("Erro ao retornar criança: " .. err)
        end

        local args1 = { [1] = "CharacterFollowSpawnPlayer", [2] = "BabyBoy" }
        success, err = pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args1))
        end)
        if not success then
            warn("Erro ao spawnar criança: " .. err)
        end
    end
})

ChildTab:AddToggle({
    Name = "Spectar Player",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera

        if Value then
            if not chasingplayer then
                warn("Nenhum jogador selecionado para spectar!")
                return false
            end

            if not rawget(getgenv(), "CameraConnection") then
                getgenv().CameraConnection = RunService.Heartbeat:Connect(function()
                    local targetPlayer = Players:FindFirstChild(chasingplayer)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                        Camera.CameraSubject = targetPlayer.Character.Humanoid
                    else
                        if rawget(getgenv(), "CameraConnection") then
                            getgenv().CameraConnection:Disconnect()
                            getgenv().CameraConnection = nil
                        end
                        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
                    end
                end)
            end
        else
            if rawget(getgenv(), "CameraConnection") then
                getgenv().CameraConnection:Disconnect()
                getgenv().CameraConnection = nil
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end
})

ChildTab:AddParagraph({
    Title = "FE",
    Content = "Funcionalidades FE"
})

-- Aba Local Player
local LocalPlayerTab = t3.JJ

local Section
Section = LocalPlayerTab:AddSection({
    Name = "Spam Chat"
})

local TextSave
local tcs = game:GetService("TextChatService")
local chat = tcs.ChatInputBarConfiguration and tcs.ChatInputBarConfiguration.TargetTextChannel

function sendchat(msg)
    if not msg or msg == "" then return end
    if tcs.ChatVersion == Enum.ChatVersion.LegacyChatService then
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(msg, "All")
        end)
        if not success then
            warn("Erro ao enviar chat: " .. err)
        end
    elseif chat then
        local success, err = pcall(function()
            chat:SendAsync(msg)
        end)
        if not success then
            warn("Erro ao enviar chat: " .. err)
        end
    end
end

LocalPlayerTab:AddTextBox({
    Name = "Enter text",
    PlaceholderText = "Digite a mensagem",
    Callback = function(text)
        TextSave = text
    end
})

LocalPlayerTab:AddButton({
    Name = "Send Chat",
    Callback = function()
        sendchat(TextSave)
    end
})

getgenv().FlowHubEnviarDelay = 1

LocalPlayerTab:AddSlider({
    Name = "Delay do Spam",
    Min = 0.4,
    Max = 10,
    Default = 1,
    Increment = 0.1,
    Callback = function(Value)
        getgenv().FlowHubEnviarDelay = Value
    end
})

LocalPlayerTab:AddToggle({
    Name = "Spam Chat",
    Default = false,
    Flag = "Spawn de textos",
    Callback = function(Value)
        getgenv().FlowHubSpawnText = Value
        while getgenv().FlowHubSpawnText do
            sendchat(TextSave)
            task.wait(getgenv().FlowHubEnviarDelay)
        end
    end
})

LocalPlayerTab:AddButton({
    Name = "Spam chat Hacked By Flow Hub",
    Callback = function()
        if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then 
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("hi\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\rServer: Hacked by Flow Hub")
        else 
            print("Nadaa")
    end
end
})

LocalPlayerTab:AddButton({
    Name = "Clear Chat",
    Callback = function()
        if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then 
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("hi\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\rServer: Chat Cleared")
        else 
            print("Nadaa")
    end
end
})

Section = LocalPlayerTab:AddSection({
    Name = "Headsit"
})

local selectedHeadSit = nil
local headSitConnection = nil

local headSitDropdown = LocalPlayerTab:AddDropdown({
    Name = "Selecionar Player",
    Default = "",
    Options = players,
    Callback = function(Value)
        selectedHeadSit = Value
    end
})

LocalPlayerTab:AddToggle({
    Name = "Head Sit (Cavalinho)",
    Default = false,
    Callback = function(bool)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        if not selectedHeadSit or selectedHeadSit == "" then
            warn("Nenhum jogador selecionado para Head Sit!")
            return false
        end

        local selectedPlayer = game.Players:FindFirstChild(selectedHeadSit)

        if bool then
            if selectedPlayer and selectedPlayer.Character then
                humanoid.Sit = true

                if headSitConnection then
                    headSitConnection:Disconnect()
                end

                headSitConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") and humanoid.Sit then
                        local targetHead = selectedPlayer.Character.Head
                        humanoidRootPart.CFrame = targetHead.CFrame * CFrame.Angles(0, 0, 0) * CFrame.new(0, 1.6, 0.4)
                    else
                        if headSitConnection then
                            headSitConnection:Disconnect()
                            headSitConnection = nil
                            humanoid.Sit = false
                        end
                    end
                end)
            else
                warn("Jogador selecionado não encontrado ou sem Character!")
                return false
            end
        else
            if headSitConnection then
                headSitConnection:Disconnect()
                headSitConnection = nil
            end
            humanoid.Sit = false
        end
    end
})

LocalPlayerTab:AddButton({
    Name = "Atualizar tabela",
    Callback = function()
        local updatedPlayers = updatePlayerList()
        if headSitDropdown and updatedPlayers then
            pcall(function()
                headSitDropdown:Refresh(updatedPlayers)
            end)
            if selectedHeadSit and not game.Players:FindFirstChild(selectedHeadSit) then
                selectedHeadSit = nil
                pcall(function()
                    headSitDropdown:Set("")
                end)
            end
        end
    end
})

local Tab = t3.Tp -- -- Nome do ícone: 'portal' em minúsculo para teleporte

-- Botões de Teleporte
local teleportButtons = {
    {"Aos Bastidores", CFrame.new(192, 4, 272)},
    {"Ao Centro Urbano", CFrame.new(136, 4, 117)},
    {"À Área do Crime", CFrame.new(-119, -28, 235)},
    {"À Casa Deserta", CFrame.new(986, 4, 63)},
    {"Ao Portal da Agência", CFrame.new(672, 4, -296)},
    {"Ao Esconderijo", CFrame.new(505, -75, 143)},
    {"À Escola", CFrame.new(-312, 4, 211)},
    {"Ao Café Brook", CFrame.new(161, 8, 52)},
    {"Ao Ponto Inicial", CFrame.new(-26, 4, -23)},
    {"Ao Arco Principal", CFrame.new(-589, 141, -59)},
    {"Ao Hospital", CFrame.new(-309, 4, 71)},
    {"À Base da Agência", CFrame.new(179, 4, -464)},
    {"À Sala Oculta da Oficina", CFrame.new(0, 4, -495)},
    {"À Sala Secreta 2", CFrame.new(-343, 4, -613)},
    {"À Ilha Isolada", CFrame.new(-1925, 23, 127)},
    {"À Praça dos Hotéis", CFrame.new(182, 4, 150)},
    {"Escalar Montanha 1", CFrame.new(-670, 251, 765)},
    {"Ao Banco Principal", CFrame.new(2.28, 4.65, 254.58)},
    {"À Loja de Roupas", CFrame.new(-46.15, 4.65, 253.20)},
    {"Ao Refúgio", CFrame.new(-88.48, 22.05, 262.34)},
    {"À Clínica Dentária", CFrame.new(-53.58, 22.15, 265.61)},
    {"À Cafeteria", CFrame.new(-97.12, 4.65, 254.99)}
}

for _, btn in ipairs(teleportButtons) do
    Tab:AddButton({
        btn[1],
        function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = btn[2]
        end
    })
end


local ToolsTab = t3.IT

-- Tabela de cores
local colorsTable = {
    {Name = "Vermelho", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Laranja", Color = Color3.fromRGB(255, 165, 0)},
    {Name = "Amarelo", Color = Color3.fromRGB(255, 255, 0)},
    {Name = "Verde", Color = Color3.fromRGB(0, 255, 0)},
    {Name = "Ciano", Color = Color3.fromRGB(0, 255, 255)},
    {Name = "Azul", Color = Color3.fromRGB(0, 0, 255)},
    {Name = "Roxo", Color = Color3.fromRGB(128, 0, 128)},
    {Name = "Preto", Color = Color3.fromRGB(0, 0, 0)}
}

-- Botão para colorir o mapa
ToolsTab:AddButton({
    Name = "Colorir Mapa Chão [Muito OP]",
    Callback = function()
      local toolselected = "PaintRoller"
local dupeamot = 100
local picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
local cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
local duping = true
local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame


local TablaGripPos = {}
for i = 1, 100 do
    if i == 1 then
        table.insert(TablaGripPos, Vector3.new(0, 5, 0)) 
    else
        table.insert(TablaGripPos, Vector3.new((i - 1) * 1.2, 5, 0)) 
    end
end

local toolCount = 0
for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == toolselected then
        toolCount = toolCount + 1
    end
end
for _, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == toolselected then
        toolCount = toolCount + 1
    end
end

if toolCount >= dupeamot then
    -- Desequipa e move as ferramentas para as posições definidas
    for i, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolselected then
            tool.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolselected then
            tool.Parent = game.Players.LocalPlayer.Character
            local gripPosIndex = math.min(i, #TablaGripPos)
            local gripPos = TablaGripPos[gripPosIndex]
            tool.GripPos = gripPos
        end
    end
else
    
    local args = {
        [1] = "ClearAllTools"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))
    
    wait(0.2)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = lib:T("Flow Hub Dupe"),
        Text = lib:T("Não Clique em nada enquanto as tool estiverem sendo dupadas"),
        Button1 = lib:T("Tendeu"),
        Duration = 3
    })
    
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
        task.wait()
        game.Players.LocalPlayer.Character.Humanoid.Sit = false
    end
    
    wait(0.1)
    
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
    end
    
    for m = 1, 2 do
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
    end
    
    task.wait(0.2)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
    wait(0.5)
    
    for aidj, afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if not afh.Name == toolselected then
            if afh:IsA("Tool") then
                afh.Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end
    
    for aiefhiewhwf, dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if dvjbvj:IsA("Tool") then
            if not dvjbvj.Name == toolselected then
                dvjbvj:Destroy()
            end
        end
    end
    
    for ttjtjutjutjjtj, ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
            if not ddvdvdsvdfbrnytytmvdv.name == toolselected then
                ddvdvdsvdfbrnytytmvdv:Destroy()
            end
        end
    end
    
    for findin, toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if toollel:IsA("Tool") then
            if toollel.Name == toolselected then
                toollllfoun2 = true
                for basc, aijfw in pairs(toollel:GetDescendants()) do
                    if aijfw.Name == "Handle" then
                        aijfw.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                        toollel.Parent = game.Players.LocalPlayer.Backpack
                        toollel.Parent = game.Players.LocalPlayer.Character
                        tolllahhhh = toollel
                        task.wait()
                    end
                end
            else
                toollllfoun2 = false
            end
        end
    end
    
    for fiifi, toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if toollll:IsA("Tool") then
            if toollll.Name == toolselected then
                toollllfoun = true
                for nana, jjsjsj in pairs(toollll:GetDescendants()) do
                    if jjsjsj.Name == "Handle" then
                        toollll.Parent = game.Players.LocalPlayer.Character
                        wait()
                        jjsjsj.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                        toollll.Parent = game.Players.LocalPlayer.Backpack
                        toollll.Parent = game.Players.LocalPlayer.Character
                        toolllffel = toollll
                    end
                end
            else
                toollllfoun = false
            end
        end
    end
    
    if toollllfoun == true then
        if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then
            toollllfoun = false
        end
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
        toollllfoun = false
    end
    
    if toollllfoun2 == true then
        if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then
            toollllfoun2 = false
        end
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
        toollllfoun2 = false
    end
    
    wait(0.1)
    
    for m = 1, dupeamot do
        if duping == false then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            return
        end
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        if m <= dupeamot then
        elseif m == dupeamot or m >= dupeamot - 1 then
        end
        local args = {
            [1] = "PickingTools",
            [2] = toolselected
        }
        picktoolremote:InvokeServer(unpack(args))
        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselected).Parent = game.Players.LocalPlayer.Character
        if duping == false then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            return
        end
        wait()
        game:GetService("Players").LocalPlayer.Character[toolselected]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselected).Parent = game.Players.LocalPlayer.Backpack
        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselected).Parent = game.Players.LocalPlayer.Character
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Flow Hub Tool"),
            Text = "Tool Dupada: " .. m .. " / " .. dupeamot,
            Duration = 1
        })
        repeat
            if game:GetService("Workspace"):FindFirstChild("Camera") then
                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
            end
            task.wait()
        until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselected) == nil
    end
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    repeat
        wait()
    until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
    repeat
        wait()
    until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
    
    for z, x in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if x.Name == toolselected then
            toolamouth = z
        end
    end
    
    wait()
    duping = false
    wait(0.1)
    
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
            local gripPosIndex = math.min(i, #TablaGripPos)
            local gripPos = TablaGripPos[gripPosIndex]
            if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                tool.GripPos = gripPos
            else
                warn("", tool.Name, "")
            end
        end
    end
    
    wait(1)
    
    function EquiparTudo()
        
        local player = game:GetService("Players").LocalPlayer
        
        
        local function changeAnimation(tool)  
            if tool:FindFirstChild("CycleNextAnimation") then  
                tool.CycleNextAnimation:FireServer()  
            end  
        end
        
        
        for _, tool in ipairs(player.Backpack:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then  
                changeAnimation(tool)  
            end  
        end
        
        
        local character = player.Character or player.CharacterAdded:Wait()  
        for _, tool in ipairs(character:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then  
                changeAnimation(tool)  
            end  
        end
        
    end
    
    EquiparTudo()
    wait(1)
    EquiparTudo()
    wait(1)
    EquiparTudo()
    
    function startSpin()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        task.wait(1)  
        
        local spinSpeed = math.rad(1750) 
  
        RunService.RenderStepped:Connect(function(dt)  
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, spinSpeed * dt, 0)  
        end)
        
    end
    
    startSpin()
end
    end
})

ToolsTab:AddButton({
    Name = "Colorir Mapa Céu [Muito OP]",
    Callback = function()
       local toolselected = "PaintRoller"
local dupeamot = 100
local picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
local cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
local duping = true
local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame


local TablaGripPos = {}
for i = 1, 100 do
    if i == 1 then
        table.insert(TablaGripPos, Vector3.new(2, 50, -50)) 
    else
        table.insert(TablaGripPos, Vector3.new((i - 1) * 2, 50, -50)) 
    end
end

local toolCount = 0
for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == toolselected then
        toolCount = toolCount + 1
    end
end
for _, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if tool:IsA("Tool") and tool.Name == toolselected then
        toolCount = toolCount + 1
    end
end

if toolCount >= dupeamot then
    -- Desequipa e move as ferramentas para as posições definidas
    for i, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolselected then
            tool.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == toolselected then
            tool.Parent = game.Players.LocalPlayer.Character
            local gripPosIndex = math.min(i, #TablaGripPos)
            local gripPos = TablaGripPos[gripPosIndex]
            tool.GripPos = gripPos
        end
    end
else
    
    local args = {
        [1] = "ClearAllTools"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))
    
    wait(0.2)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = lib:T("Flow Hub Dupe"),
        Text = lib:T("Não Clique em nada enquanto as tool estiverem sendo dupadas"),
        Button1 = lib:T("Tendeu"),
        Duration = 3
    })
    
    if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
        task.wait()
        game.Players.LocalPlayer.Character.Humanoid.Sit = false
    end
    
    wait(0.1)
    
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
    end
    
    for m = 1, 2 do
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
    end
    
    task.wait(0.2)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
    wait(0.5)
    
    for aidj, afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if not afh.Name == toolselected then
            if afh:IsA("Tool") then
                afh.Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end
    
    for aiefhiewhwf, dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if dvjbvj:IsA("Tool") then
            if not dvjbvj.Name == toolselected then
                dvjbvj:Destroy()
            end
        end
    end
    
    for ttjtjutjutjjtj, ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
            if not ddvdvdsvdfbrnytytmvdv.name == toolselected then
                ddvdvdsvdfbrnytytmvdv:Destroy()
            end
        end
    end
    
    for findin, toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if toollel:IsA("Tool") then
            if toollel.Name == toolselected then
                toollllfoun2 = true
                for basc, aijfw in pairs(toollel:GetDescendants()) do
                    if aijfw.Name == "Handle" then
                        aijfw.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                        toollel.Parent = game.Players.LocalPlayer.Backpack
                        toollel.Parent = game.Players.LocalPlayer.Character
                        tolllahhhh = toollel
                        task.wait()
                    end
                end
            else
                toollllfoun2 = false
            end
        end
    end
    
    for fiifi, toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if toollll:IsA("Tool") then
            if toollll.Name == toolselected then
                toollllfoun = true
                for nana, jjsjsj in pairs(toollll:GetDescendants()) do
                    if jjsjsj.Name == "Handle" then
                        toollll.Parent = game.Players.LocalPlayer.Character
                        wait()
                        jjsjsj.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                        toollll.Parent = game.Players.LocalPlayer.Backpack
                        toollll.Parent = game.Players.LocalPlayer.Character
                        toolllffel = toollll
                    end
                end
            else
                toollllfoun = false
            end
        end
    end
    
    if toollllfoun == true then
        if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then
            toollllfoun = false
        end
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
        toollllfoun = false
    end
    
    if toollllfoun2 == true then
        if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then
            toollllfoun2 = false
        end
        repeat
            wait()
        until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
        toollllfoun2 = false
    end
    
    wait(0.1)
    
    for m = 1, dupeamot do
        if duping == false then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            return
        end
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        if m <= dupeamot then
        elseif m == dupeamot or m >= dupeamot - 1 then
        end
        local args = {
            [1] = "PickingTools",
            [2] = toolselected
        }
        picktoolremote:InvokeServer(unpack(args))
        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselected).Parent = game.Players.LocalPlayer.Character
        if duping == false then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            return
        end
        wait()
        game:GetService("Players").LocalPlayer.Character[toolselected]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselected).Parent = game.Players.LocalPlayer.Backpack
        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselected).Parent = game.Players.LocalPlayer.Character
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Flow Hub Tool"),
            Text = "Tool Dupada: " .. m .. " / " .. dupeamot,
            Duration = 1
        })
        repeat
            if game:GetService("Workspace"):FindFirstChild("Camera") then
                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
            end
            task.wait()
        until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselected) == nil
    end
    
    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    repeat
        wait()
    until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
    repeat
        wait()
    until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
    
    for z, x in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if x.Name == toolselected then
            toolamouth = z
        end
    end
    
    wait()
    duping = false
    wait(0.1)
    
    for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = game.Players.LocalPlayer.Character
            local gripPosIndex = math.min(i, #TablaGripPos)
            local gripPos = TablaGripPos[gripPosIndex]
            if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                tool.GripPos = gripPos
            else
                warn("", tool.Name, "")
            end
        end
    end
    
    wait(1)
    
    function EquiparTudo()
        
        local player = game:GetService("Players").LocalPlayer
        
        
        local function changeAnimation(tool)  
            if tool:FindFirstChild("CycleNextAnimation") then  
                tool.CycleNextAnimation:FireServer()  
            end  
        end
        
        
        for _, tool in ipairs(player.Backpack:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then  
                changeAnimation(tool)  
            end  
        end
        
        
        local character = player.Character or player.CharacterAdded:Wait()  
        for _, tool in ipairs(character:GetChildren()) do  
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then  
                changeAnimation(tool)  
            end  
        end
        
    end
    
    EquiparTudo()
    wait(1)
    EquiparTudo()
    wait(1)
    EquiparTudo()
    
    function startSpin()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        task.wait(1)  
        
        local spinSpeed = math.rad(1750) 
  
        RunService.RenderStepped:Connect(function(dt)  
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, spinSpeed * dt, 0)  
        end)
    
    
    end
    
    startSpin() end
end
})
-- Variável para armazenar a cor selecionada
local selectedColor = colorsTable[1].Color

-- Função para aplicar a cor selecionada
local function applySelectedColor()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character
    local args = {selectedColor}

    local function changeToolColor(tool)
        if tool:IsA("Tool") and tool.Name == "PaintRoller" then
            local SetColor = tool:FindFirstChild("SetColor", true)
            if SetColor then
                SetColor:FireServer(unpack(args))
            end
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        changeToolColor(tool)
    end
    for _, tool in ipairs(character:GetChildren()) do
        changeToolColor(tool)
    end
end

-- Função para equipar e desequipar ferramentas
local function equipAndUnequipTools(callback)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character

    local function unequipTools()
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then
                tool.Parent = backpack
            end
        end
    end

    local function equipTools()
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "PaintRoller" then
                tool.Parent = character
            end
        end
    end

    unequipTools()
    wait(0.7)
    if callback then callback() end
    wait(0.7)
    equipTools()
end

-- Dropdown para selecionar a cor
ToolsTab:AddDropdown({
    Name = "Selecione a Cor",
    Description = "Escolha uma cor para aplicar",
    Options = (function()
        local colorNames = {}
        for _, color in ipairs(colorsTable) do
            table.insert(colorNames, color.Name)
        end
        return colorNames
    end)(),
    Default = colorsTable[1].Name,
    Callback = function(selected)
        for _, color in ipairs(colorsTable) do
            if color.Name == selected then
                selectedColor = color.Color
                equipAndUnequipTools(applySelectedColor)
                break
            end
        end
    end
})

-- Função para aplicar ciclo RGB
local function applyRGBCycle()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character
    local toolIndex = 0
    local totalColors = #colorsTable

    local function changeToolColor(tool, color)
        if tool:IsA("Tool") and tool.Name == "PaintRoller" then
            local SetColor = tool:FindFirstChild("SetColor", true)
            if SetColor then
                SetColor:FireServer(color)
            end
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool.Name == "PaintRoller" then
            toolIndex = toolIndex + 1
            local color = colorsTable[(toolIndex - 1) % totalColors + 1].Color
            changeToolColor(tool, color)
        end
    end
    for _, tool in ipairs(character:GetChildren()) do
        if tool.Name == "PaintRoller" then
            toolIndex = toolIndex + 1
            local color = colorsTable[(toolIndex - 1) % totalColors + 1].Color
            changeToolColor(tool, color)
        end
    end
end

-- Botão para aplicar ciclo de cores
ToolsTab:AddButton({
    Name = "Colorido",
    Callback = function()
        equipAndUnequipTools(applyRGBCycle)
    end
})

-- Combinações de cores
local colorCombinations = {}
for i, color1 in ipairs(colorsTable) do
    for j, color2 in ipairs(colorsTable) do
        if i ~= j then
            table.insert(colorCombinations, {Name = color1.Name .. " e " .. color2.Name, Colors = {color1.Color, color2.Color}})
        end
    end
end

-- Dropdown para combinações de cores
ToolsTab:AddDropdown({
    Name = "Selecione a Combinação de Cores",
    Description = "Escolha uma combinação de cores",
    Options = (function()
        local combinationNames = {}
        for _, combination in ipairs(colorCombinations) do
            table.insert(combinationNames, combination.Name)
        end
        return combinationNames
    end)(),
    Default = colorCombinations[1].Name,
    Callback = function(selected)
        for _, combination in ipairs(colorCombinations) do
            if combination.Name == selected then
                local function applyDoubleColor()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    local backpack = LocalPlayer.Backpack
                    local character = LocalPlayer.Character
                    local toolIndex = 0
                    local colors = combination.Colors

                    local function changeToolColor(tool, color)
                        if tool:IsA("Tool") and tool.Name == "PaintRoller" then
                            local SetColor = tool:FindFirstChild("SetColor", true)
                            if SetColor then
                                SetColor:FireServer(color)
                            end
                        end
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool.Name == "PaintRoller" then
                            toolIndex = toolIndex + 1
                            local color = colors[(toolIndex - 1) % 2 + 1]
                            changeToolColor(tool, color)
                        end
                    end
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool.Name == "PaintRoller" then
                            toolIndex = toolIndex + 1
                            local color = colors[(toolIndex - 1) % 2 + 1]
                            changeToolColor(tool, color)
                        end
                    end
                end
                equipAndUnequipTools(applyDoubleColor)
                break
            end
        end
    end
})

-- Referências aos remotes
local cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
local picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")

-- Seção de controle de itens
local Section = ToolsTab:AddSection({
    Name = "Items Control"
})

-- Botão para limpar todas as ferramentas
ToolsTab:AddButton({
    Name = "Clear All Tools",
    Callback = function()
        local args = {
            [1] = "ClearAllTools"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))
    end
})

-- Seção para equipar itens
Section = ToolsTab:AddSection({
    Name = "Equip Items"
})

-- Botão para equipar todos os itens
ToolsTab:AddButton({
    Name = "Equipar todos os itens",
    Callback = function()
        for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = game.Players.LocalPlayer.Character
            end
        end
    end
})

-- Seção para N4zi Grip
Section = ToolsTab:AddSection({
    Name = "N4zi Grip"
})

-- Botão para Giant Joust Blue N4zi
ToolsTab:AddButton({
    Name = "Giant Joust Blue N4zi",
    Callback = function()
       toolselcted = "JoustBlue"
        dupeamot = 175 --Put amouth to dupe
        picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
                                duping = true
                                oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                                        task.wait()
                                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                end
                                wait(0.1)
                                if game:GetService("Workspace"):FindFirstChild("Camera") then
                                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                        for m=1,2 do task.wait()
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                                                end
                                                task.wait(0.2)
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                                wait(0.5)
                                for aidj,afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if afh.Name == toolselcted == false then
                                                if afh:IsA("Tool") then
                                                        afh.Parent = game.Players.LocalPlayer.Backpack
                                                end
                                        end
                                end
                                for aiefhiewhwf,dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                        if dvjbvj:IsA("Tool") then
                                                if dvjbvj.Name == toolselcted == false then
                                                        dvjbvj:Destroy()
                                                end
                                        end
                                end
                                for ttjtjutjutjjtj,ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
                                                if ddvdvdsvdfbrnytytmvdv.name == toolselcted == false then
                                                        ddvdvdsvdfbrnytytmvdv:Destroy()
                                                end
                                        end
                                end
                                for findin,toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if toollel:IsA("Tool") then
                                                if toollel.Name == toolselcted then
                                                        toollllfoun2 = true
                                                        for basc,aijfw in pairs(toollel:GetDescendants()) do
                                                                if aijfw.Name == "Handle" then
                                                                        aijfw.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                                                        toollel.Parent = game.Players.LocalPlayer.Backpack
                                                                toollel.Parent = game.Players.LocalPlayer.Character
                                                                tollllahhhh = toollel
                                                                task.wait()
                                                        end
                                                end
                                        else toollllfoun2 = false
                                        end
                                end
                        end
                                for fiifi,toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                        if toollll:IsA("Tool") then
                                                if toollll.Name == toolselcted then
                                                        toollllfoun = true
                                                        for nana,jjsjsj in pairs(toollll:GetDescendants()) do
                                                                if jjsjsj.Name == "Handle" then
                                                                        toollll.Parent = game.Players.LocalPlayer.Character
                                                wait()
                                                jjsjsj.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                                toollll.Parent = game.Players.LocalPlayer.Backpack
                                                toollll.Parent = game.Players.LocalPlayer.Character
                                                toolllffel = toollll
                                                                end
                                                        end
                                                else toollllfoun = false
                                        end
                                end
                                end
                                if toollllfoun == true then
                                                                        if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then  toollllfoun = false end
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
                                toollllfoun = false
                                end
                                if toollllfoun2 == true then
                                        if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then toollllfoun2 = false end
                                        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
                                        toollllfoun2 = false
                                end
                                wait(1)
                                for m=1, dupeamot do
                                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                                if m <= dupeamot then
                elseif m == dupeamot or m >= dupeamot - 1 then
                end
                                        local args = {
                                                [1] = "PickingTools",
                                                [2] = toolselcted
                                        }
                                        
                                        picktoolremote:InvokeServer(unpack(args))
                                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselcted).Parent = game.Players.LocalPlayer.Character
                                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                                        wait()
                                        game:GetService("Players").LocalPlayer.Character[toolselcted]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Backpack
                                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Character
                                        repeat         if game:GetService("Workspace"):FindFirstChild("Camera") then
                                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                                 task.wait() until
                                                 game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted) == nil
                                end
                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
                                for z,x in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                        if x.Name == toolselcted then
                                                toolamouth = z
                                        end
                                end
                                wait()
                                duping = false
   wait(1)


local TablaGripPos = {
                      Vector3.new(0, 3, 6),
                      Vector3.new(1, 3, 6),
                      Vector3.new(2, 3, 6),
                      Vector3.new(3, 3, 6),
                      Vector3.new(4, 3, 6),
                      Vector3.new(5, 3, 6),
                      Vector3.new(6, 3, 6),
                      Vector3.new(0, 3, 17),
                      Vector3.new(1, 3, 17),
                      Vector3.new(2, 3, 17),
                      Vector3.new(3, 3, 17),
                      Vector3.new(4, 3, 17),
                      Vector3.new(5, 3, 17),
                      Vector3.new(6, 3, 17),
                      Vector3.new(0, 3, 30),
                      Vector3.new(1, 3, 30),
                      Vector3.new(2, 3, 30),
                      Vector3.new(3, 3, 30),
                      Vector3.new(4, 3, 30),
                      Vector3.new(5, 3, 30),
                      Vector3.new(6, 3, 30),
                      Vector3.new(0, 3, 43),
                      Vector3.new(1, 3, 43),
                      Vector3.new(2, 3, 43),
                      Vector3.new(3, 3, 43),
                      Vector3.new(4, 3, 43),
                      Vector3.new(5, 3, 43),
                      Vector3.new(6, 3, 43),
                      Vector3.new(0, 3, 55),
                      Vector3.new(1, 3, 55),
                      Vector3.new(2, 3, 55),
                      Vector3.new(3, 3, 55),
                      Vector3.new(4, 3, 55),
                      Vector3.new(5, 3, 55),
                      Vector3.new(6, 3, 55),
                      Vector3.new(-1 , 3, 6),
                      Vector3.new(-2 , 3, 6),
                      Vector3.new(-3 , 3, 6),
                      Vector3.new(-4 , 3, 6),
                      Vector3.new(-5 , 3, 6),
                      Vector3.new(-6 , 3, 6),
                      Vector3.new(-7 , 3, 6),
                      Vector3.new(-8 , 3, 6),
                      Vector3.new(-9 , 3, 6),
                      Vector3.new(-10 , 3, 6),
                      Vector3.new(-11 , 3, 6),
                      Vector3.new(-12 , 3, 6),
                      Vector3.new(-13 , 3, 6),
                      Vector3.new(-14 , 3, 6),
                      Vector3.new(-15 , 3, 6),
                      Vector3.new(-16 , 3, 6),
                      Vector3.new(-17 , 3, 6),
                      Vector3.new(-18 , 3, 6),
                      Vector3.new(-19 , 3, 6),
                      Vector3.new(-20 , 3, 6),
                      Vector3.new(-21 , 3, 6),
                      Vector3.new(1 , 3, 55),
                      Vector3.new(2 , 3, 55),
                      Vector3.new(3 , 3, 55),
                      Vector3.new(4 , 3, 55),
                      Vector3.new(5 , 3, 55),
                      Vector3.new(6 , 3, 55),
                      Vector3.new(7 , 3, 55),
                      Vector3.new(8 , 3, 55),
                      Vector3.new(9 , 3, 55),
                      Vector3.new(10 , 3, 55),
                      Vector3.new(11 , 3, 55),
                      Vector3.new(12 , 3, 55),
                      Vector3.new(13 , 3, 55),
                      Vector3.new(14 , 3, 55),
                      Vector3.new(15 , 3, 55),
                      Vector3.new(16 , 3, 55),
                      Vector3.new(17 , 3, 55),
                      Vector3.new(18 , 3, 55),
                      Vector3.new(19 , 3, 55),
                      Vector3.new(20 , 3, 55),
                      Vector3.new(21 , 3, 55),
                      Vector3.new(22 , 3, 55),
                      Vector3.new(-16, 3, 43),
                                   Vector3.new(-17, 3, 43),
                      Vector3.new(-18, 3, 43),
                      Vector3.new(-19, 3, 43),
                      Vector3.new(-20, 3, 43),
                      Vector3.new(-21, 3, 43),
                      Vector3.new(-16, 3, 43),
                      Vector3.new(-15, 3, 43),
                      Vector3.new(-16, 3, 43),
                                                Vector3.new(-17, 3, 55),
                      Vector3.new(-18, 3, 55),
                      Vector3.new(-19, 3, 55),
                      Vector3.new(-20, 3, 55),
                      Vector3.new(-21, 3, 55),
                      Vector3.new(-16, 3, 55),
                      Vector3.new(-15, 3, 55),
                      Vector3.new(0, 3, 55),
                      Vector3.new(1, 3, 55),
                      Vector3.new(2, 3, 55),
                      Vector3.new(3, 3, 55),
                      Vector3.new(4, 3, 55),
                      Vector3.new(5, 3, 55),
                      Vector3.new(6, 3, 55),
         Vector3.new(23 , 3, 55),
         Vector3.new(24 , 3, 55),
          Vector3.new(25 , 3, 55),
           Vector3.new(26 , 3, 55),
            Vector3.new(27 , 3, 55),
                         Vector3.new(-1 , 3, 30),
                      Vector3.new(-2 , 3, 30),
                      Vector3.new(-3 , 3, 30),
                      Vector3.new(-4 , 3, 30),
                      Vector3.new(-5 , 3, 30),
                      Vector3.new(-6 , 3, 30),
                      Vector3.new(-7 , 3, 30),
                      Vector3.new(-8 , 3, 30),
                      Vector3.new(-9 , 3, 30),
                      Vector3.new(-10 , 3, 30),
                      Vector3.new(-11 , 3, 30),
                      Vector3.new(-12 , 3, 30),
                      Vector3.new(-13 , 3, 30),
                      Vector3.new(-14 , 3, 30),
                      Vector3.new(-15 , 3, 30),
                      Vector3.new(-16 , 3, 30),
                      Vector3.new(-17 , 3, 30),
                      Vector3.new(-18 , 3, 30),
                      Vector3.new(-19 , 3, 30),
                      Vector3.new(-20 , 3, 30),
                      Vector3.new(-21 , 3, 30),
                          Vector3.new(1 , 3, 30),
                      Vector3.new(2 , 3, 30),
                      Vector3.new(3 , 3, 30),
                      Vector3.new(4 , 3, 30),
                      Vector3.new(5 , 3, 30),
                      Vector3.new(6 , 3, 30),
                      Vector3.new(7 , 3, 30),
                      Vector3.new(8 , 3, 30),
                      Vector3.new(9 , 3, 30),
                      Vector3.new(10 , 3, 30),
                      Vector3.new(11 , 3, 30),
                      Vector3.new(12 , 3, 30),
                      Vector3.new(13 , 3, 30),
                      Vector3.new(14 , 3, 30),
                      Vector3.new(15 , 3, 30),
                      Vector3.new(16 , 3, 30),
                      Vector3.new(17 , 3, 30),
                      Vector3.new(18 , 3, 30),
                      Vector3.new(19 , 3, 30),
                      Vector3.new(20 , 3, 30),
                      Vector3.new(21 , 3, 30),
                      Vector3.new(22 , 3, 30),
                      Vector3.new(23 , 3, 30),
                      Vector3.new(24 , 3, 30),
                      Vector3.new(25 , 3, 30),
                      Vector3.new(26 , 3, 30),
                      Vector3.new(27 , 3, 30),
                      Vector3.new(28 , 3, 30),
                      Vector3.new(28, 3, 6),
                      Vector3.new(27, 3, 6),
                      Vector3.new(26, 3, 6),
                      Vector3.new(25, 3, 6),
                      Vector3.new(24, 3, 6),
                      Vector3.new(23, 3, 6),
                      Vector3.new(22, 3, 6),
                      Vector3.new(21, 3, 6),
                      Vector3.new(21, 3, 17),
                      Vector3.new(22, 3, 17),
                      Vector3.new(23, 3, 17),
                      Vector3.new(24, 3, 17),
                      Vector3.new(25, 3, 17),
                      Vector3.new(26, 3, 17),
                      Vector3.new(27, 3, 17),
                      Vector3.new(28, 3, 17),
                         }
                          for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                              if tool:IsA("Tool") then
                                  -- Przeniesienie narzÄ™dzia do postaci gracza
                                  tool.Parent = game.Players.LocalPlayer.Character
                                  
                                  -- Ustalanie indeksu pozycji chwytu
                                  local gripPosIndex = math.min(i, #TablaGripPos)
                                  local gripPos = TablaGripPos[gripPosIndex]
                          
                                  -- Ustawienie pozycji chwytu (GripPos), jeÅ›li narzÄ™dzie jest w postaci gracza
                                  if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                                      tool.GripPos = gripPos
                                  else
                                      warn("", tool.Name, "")
                                  end
                              end
                          end
    end
})

-- Botão para Giant Joust Red N4zi
ToolsTab:AddButton({
    Name = "Giant Joust Red N4zi",
    Callback = function()
        toolselcted = "JoustRed"
        dupeamot = 175 --Put amouth to dupe
        picktoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        cleartoolremote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s")
                                duping = true
                                oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                                        task.wait()
                                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                end
                                wait(0.1)
                                if game:GetService("Workspace"):FindFirstChild("Camera") then
                                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                        for m=1,2 do task.wait()
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                                                end
                                                task.wait(0.2)
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                                wait(0.5)
                                for aidj,afh in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if afh.Name == toolselcted == false then
                                                if afh:IsA("Tool") then
                                                        afh.Parent = game.Players.LocalPlayer.Backpack
                                                end
                                        end
                                end
                                for aiefhiewhwf,dvjbvj in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                        if dvjbvj:IsA("Tool") then
                                                if dvjbvj.Name == toolselcted == false then
                                                        dvjbvj:Destroy()
                                                end
                                        end
                                end
                                for ttjtjutjutjjtj,ddvdvdsvdfbrnytytmvdv in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if ddvdvdsvdfbrnytytmvdv:IsA("Tool") then
                                                if ddvdvdsvdfbrnytytmvdv.name == toolselcted == false then
                                                        ddvdvdsvdfbrnytytmvdv:Destroy()
                                                end
                                        end
                                end
                                for findin,toollel in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                        if toollel:IsA("Tool") then
                                                if toollel.Name == toolselcted then
                                                        toollllfoun2 = true
                                                        for basc,aijfw in pairs(toollel:GetDescendants()) do
                                                                if aijfw.Name == "Handle" then
                                                                        aijfw.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                                                        toollel.Parent = game.Players.LocalPlayer.Backpack
                                                                toollel.Parent = game.Players.LocalPlayer.Character
                                                                tollllahhhh = toollel
                                                                task.wait()
                                                        end
                                                end
                                        else toollllfoun2 = false
                                        end
                                end
                        end
                                for fiifi,toollll in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                        if toollll:IsA("Tool") then
                                                if toollll.Name == toolselcted then
                                                        toollllfoun = true
                                                        for nana,jjsjsj in pairs(toollll:GetDescendants()) do
                                                                if jjsjsj.Name == "Handle" then
                                                                        toollll.Parent = game.Players.LocalPlayer.Character
                                                wait()
                                                jjsjsj.Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                                toollll.Parent = game.Players.LocalPlayer.Backpack
                                                toollll.Parent = game.Players.LocalPlayer.Character
                                                toolllffel = toollll
                                                                end
                                                        end
                                                else toollllfoun = false
                                        end
                                end
                                end
                                if toollllfoun == true then
                                                                        if game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil then  toollllfoun = false end
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(toolllffel) == nil
                                toollllfoun = false
                                end
                                if toollllfoun2 == true then
                                        if game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil then toollllfoun2 = false end
                                        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild(tollllahhhh) == nil
                                        toollllfoun2 = false
                                end
                                wait(1)
                                for m=1, dupeamot do
                                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                                if m <= dupeamot then
                elseif m == dupeamot or m >= dupeamot - 1 then
                end
                                        local args = {
                                                [1] = "PickingTools",
                                                [2] = toolselcted
                                        }
                                        
                                        picktoolremote:InvokeServer(unpack(args))
                                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolselcted).Parent = game.Players.LocalPlayer.Character
                                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                                        wait()
                                        game:GetService("Players").LocalPlayer.Character[toolselcted]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Backpack
                                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolselcted).Parent = game.Players.LocalPlayer.Character
                                        repeat         if game:GetService("Workspace"):FindFirstChild("Camera") then
                                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                                                 task.wait() until
                                                 game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolselcted) == nil
                                end
                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
                                for z,x in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                        if x.Name == toolselcted then
                                                toolamouth = z
                                        end
                                end
                                wait()
                                duping = false
   wait(1)


local TablaGripPos = {
                      Vector3.new(0, 3, 6),
                      Vector3.new(1, 3, 6),
                      Vector3.new(2, 3, 6),
                      Vector3.new(3, 3, 6),
                      Vector3.new(4, 3, 6),
                      Vector3.new(5, 3, 6),
                      Vector3.new(6, 3, 6),
                      Vector3.new(0, 3, 17),
                      Vector3.new(1, 3, 17),
                      Vector3.new(2, 3, 17),
                      Vector3.new(3, 3, 17),
                      Vector3.new(4, 3, 17),
                      Vector3.new(5, 3, 17),
                      Vector3.new(6, 3, 17),
                      Vector3.new(0, 3, 30),
                      Vector3.new(1, 3, 30),
                      Vector3.new(2, 3, 30),
                      Vector3.new(3, 3, 30),
                      Vector3.new(4, 3, 30),
                      Vector3.new(5, 3, 30),
                      Vector3.new(6, 3, 30),
                      Vector3.new(0, 3, 43),
                      Vector3.new(1, 3, 43),
                      Vector3.new(2, 3, 43),
                      Vector3.new(3, 3, 43),
                      Vector3.new(4, 3, 43),
                      Vector3.new(5, 3, 43),
                      Vector3.new(6, 3, 43),
                      Vector3.new(0, 3, 55),
                      Vector3.new(1, 3, 55),
                      Vector3.new(2, 3, 55),
                      Vector3.new(3, 3, 55),
                      Vector3.new(4, 3, 55),
                      Vector3.new(5, 3, 55),
                      Vector3.new(6, 3, 55),
                      Vector3.new(-1 , 3, 6),
                      Vector3.new(-2 , 3, 6),
                      Vector3.new(-3 , 3, 6),
                      Vector3.new(-4 , 3, 6),
                      Vector3.new(-5 , 3, 6),
                      Vector3.new(-6 , 3, 6),
                      Vector3.new(-7 , 3, 6),
                      Vector3.new(-8 , 3, 6),
                      Vector3.new(-9 , 3, 6),
                      Vector3.new(-10 , 3, 6),
                      Vector3.new(-11 , 3, 6),
                      Vector3.new(-12 , 3, 6),
                      Vector3.new(-13 , 3, 6),
                      Vector3.new(-14 , 3, 6),
                      Vector3.new(-15 , 3, 6),
                      Vector3.new(-16 , 3, 6),
                      Vector3.new(-17 , 3, 6),
                      Vector3.new(-18 , 3, 6),
                      Vector3.new(-19 , 3, 6),
                      Vector3.new(-20 , 3, 6),
                      Vector3.new(-21 , 3, 6),
                      Vector3.new(1 , 3, 55),
                      Vector3.new(2 , 3, 55),
                      Vector3.new(3 , 3, 55),
                      Vector3.new(4 , 3, 55),
                      Vector3.new(5 , 3, 55),
                      Vector3.new(6 , 3, 55),
                      Vector3.new(7 , 3, 55),
                      Vector3.new(8 , 3, 55),
                      Vector3.new(9 , 3, 55),
                      Vector3.new(10 , 3, 55),
                      Vector3.new(11 , 3, 55),
                      Vector3.new(12 , 3, 55),
                      Vector3.new(13 , 3, 55),
                      Vector3.new(14 , 3, 55),
                      Vector3.new(15 , 3, 55),
                      Vector3.new(16 , 3, 55),
                      Vector3.new(17 , 3, 55),
                      Vector3.new(18 , 3, 55),
                      Vector3.new(19 , 3, 55),
                      Vector3.new(20 , 3, 55),
                      Vector3.new(21 , 3, 55),
                      Vector3.new(22 , 3, 55),
                      Vector3.new(-16, 3, 43),
                                   Vector3.new(-17, 3, 43),
                      Vector3.new(-18, 3, 43),
                      Vector3.new(-19, 3, 43),
                      Vector3.new(-20, 3, 43),
                      Vector3.new(-21, 3, 43),
                      Vector3.new(-16, 3, 43),
                      Vector3.new(-15, 3, 43),
                      Vector3.new(-16, 3, 43),
                                                Vector3.new(-17, 3, 55),
                      Vector3.new(-18, 3, 55),
                      Vector3.new(-19, 3, 55),
                      Vector3.new(-20, 3, 55),
                      Vector3.new(-21, 3, 55),
                      Vector3.new(-16, 3, 55),
                      Vector3.new(-15, 3, 55),
                      Vector3.new(0, 3, 55),
                      Vector3.new(1, 3, 55),
                      Vector3.new(2, 3, 55),
                      Vector3.new(3, 3, 55),
                      Vector3.new(4, 3, 55),
                      Vector3.new(5, 3, 55),
                      Vector3.new(6, 3, 55),
         Vector3.new(23 , 3, 55),
         Vector3.new(24 , 3, 55),
          Vector3.new(25 , 3, 55),
           Vector3.new(26 , 3, 55),
            Vector3.new(27 , 3, 55),
                         Vector3.new(-1 , 3, 30),
                      Vector3.new(-2 , 3, 30),
                      Vector3.new(-3 , 3, 30),
                      Vector3.new(-4 , 3, 30),
                      Vector3.new(-5 , 3, 30),
                      Vector3.new(-6 , 3, 30),
                      Vector3.new(-7 , 3, 30),
                      Vector3.new(-8 , 3, 30),
                      Vector3.new(-9 , 3, 30),
                      Vector3.new(-10 , 3, 30),
                      Vector3.new(-11 , 3, 30),
                      Vector3.new(-12 , 3, 30),
                      Vector3.new(-13 , 3, 30),
                      Vector3.new(-14 , 3, 30),
                      Vector3.new(-15 , 3, 30),
                      Vector3.new(-16 , 3, 30),
                      Vector3.new(-17 , 3, 30),
                      Vector3.new(-18 , 3, 30),
                      Vector3.new(-19 , 3, 30),
                      Vector3.new(-20 , 3, 30),
                      Vector3.new(-21 , 3, 30),
                          Vector3.new(1 , 3, 30),
                      Vector3.new(2 , 3, 30),
                      Vector3.new(3 , 3, 30),
                      Vector3.new(4 , 3, 30),
                      Vector3.new(5 , 3, 30),
                      Vector3.new(6 , 3, 30),
                      Vector3.new(7 , 3, 30),
                      Vector3.new(8 , 3, 30),
                      Vector3.new(9 , 3, 30),
                      Vector3.new(10 , 3, 30),
                      Vector3.new(11 , 3, 30),
                      Vector3.new(12 , 3, 30),
                      Vector3.new(13 , 3, 30),
                      Vector3.new(14 , 3, 30),
                      Vector3.new(15 , 3, 30),
                      Vector3.new(16 , 3, 30),
                      Vector3.new(17 , 3, 30),
                      Vector3.new(18 , 3, 30),
                      Vector3.new(19 , 3, 30),
                      Vector3.new(20 , 3, 30),
                      Vector3.new(21 , 3, 30),
                      Vector3.new(22 , 3, 30),
                      Vector3.new(23 , 3, 30),
                      Vector3.new(24 , 3, 30),
                      Vector3.new(25 , 3, 30),
                      Vector3.new(26 , 3, 30),
                      Vector3.new(27 , 3, 30),
                      Vector3.new(28 , 3, 30),
                      Vector3.new(28, 3, 6),
                      Vector3.new(27, 3, 6),
                      Vector3.new(26, 3, 6),
                      Vector3.new(25, 3, 6),
                      Vector3.new(24, 3, 6),
                      Vector3.new(23, 3, 6),
                      Vector3.new(22, 3, 6),
                      Vector3.new(21, 3, 6),
                      Vector3.new(21, 3, 17),
                      Vector3.new(22, 3, 17),
                      Vector3.new(23, 3, 17),
                      Vector3.new(24, 3, 17),
                      Vector3.new(25, 3, 17),
                      Vector3.new(26, 3, 17),
                      Vector3.new(27, 3, 17),
                      Vector3.new(28, 3, 17),
                         }
                          for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                              if tool:IsA("Tool") then
                                  -- Przeniesienie narzÄ™dzia do postaci gracza
                                  tool.Parent = game.Players.LocalPlayer.Character
                                  
                                  -- Ustalanie indeksu pozycji chwytu
                                  local gripPosIndex = math.min(i, #TablaGripPos)
                                  local gripPos = TablaGripPos[gripPosIndex]
                          
                                  -- Ustawienie pozycji chwytu (GripPos), jeÅ›li narzÄ™dzie jest w postaci gracza
                                  if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                                      tool.GripPos = gripPos
                                  else
                                      warn("", tool.Name, "")
                                  end
                              end
                          end
    end
})

-- Botão para Fire N4zi
ToolsTab:AddButton({
    Name = "Fire N4zi",
    Callback = function()
        local nametools = "crystal nazi lel"
        local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Dupe Script"),
            Text = lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."),
            Button1 = lib:T("I understand"),
            Duration = 5
        })
        local toolthatiwanttodupe = "PaperbagFire"
        local tools = "PaperbagFire"
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
            task.wait()
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
        wait(0.1)
        local args = {
            [1] = "ClearAllTools"
        }
        cleartoolremote:FireServer(unpack(args))
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        for m = 1, 2 do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
        end
        task.wait(0.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        wait(0.3)
        local duping = true
        for m = 1, 57 do
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            if game:GetService("Workspace"):FindFirstChild("Camera") then
                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
            end
            local args = {
                [1] = "PickingTools",
                [2] = toolthatiwanttodupe
            }
            picktoolremote:InvokeServer(unpack(args))
            game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            wait()
            game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "Hândlê"
            game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
            game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            repeat
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                    game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
                end
                wait()
            until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local toolgrip = true
        duping = false
        wait()
        local gripBase = CFrame.new(-0.290086746, 0.0755810738, -0.0109872818, 0.0439560413, 0.509705901, -0.859225094, -0.0591450632, -0.857220173, -0.511542261, -0.997281134, 0.0733042806, -0.00753343105)
        local gripPositions = {
            Vector3.new(0, 0, 0), Vector3.new(0, 0.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 1.5, 0),
            Vector3.new(0, 2, 0), Vector3.new(0, 2.5, 0), Vector3.new(0, 3, 0), Vector3.new(0, 3.5, 0),
            Vector3.new(0, 4, 0), Vector3.new(0, 4.5, 0), Vector3.new(0, 5, 0), Vector3.new(0, 5, -1),
            Vector3.new(0, 5, -2), Vector3.new(0, 5, -3), Vector3.new(0, 5, -4), Vector3.new(0, 5, -5),
            Vector3.new(0, 5, -6), Vector3.new(0, 5, -7), Vector3.new(0, 5, -8), Vector3.new(0, 5, -9),
            Vector3.new(0, 5, -10), Vector3.new(0, 5.5, -10), Vector3.new(0, 6, -10), Vector3.new(0, 6.5, -10),
            Vector3.new(0, 7, -10), Vector3.new(0, 7.5, -10), Vector3.new(0, 8, -10), Vector3.new(0, 8.5, -10),
            Vector3.new(0, 9, -10), Vector3.new(0, 9.5, -10), Vector3.new(0, 10, -10), Vector3.new(0, 10, -5),
            Vector3.new(0, 10, -4.5), Vector3.new(0, 10, -4), Vector3.new(0, 10, -3.5), Vector3.new(0, 10, -3),
            Vector3.new(0, 10, -2.5), Vector3.new(0, 10, -2), Vector3.new(0, 10, -1.5), Vector3.new(0, 10, -1),
            Vector3.new(0, 10, -0.5), Vector3.new(0, 10, 0), Vector3.new(0, 9, -5), Vector3.new(0, 8, -5),
            Vector3.new(0, 7, -5), Vector3.new(0, 6, -5), Vector3.new(0, 5, -5), Vector3.new(0, 4, -5),
            Vector3.new(0, 3, -5), Vector3.new(0, 2, -5), Vector3.new(0, 1, -5), Vector3.new(0, 0, -5),
            Vector3.new(0, 0, -10), Vector3.new(0, 0, -9), Vector3.new(0, 0, -8), Vector3.new(0, 0, -7),
            Vector3.new(0, 0, -6)
        }
        for _, pos in ipairs(gripPositions) do
            game.Players.LocalPlayer.Backpack[tools].Grip = gripBase + pos
            game.Players.LocalPlayer.Backpack[tools].Name = nametools
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
        wait(0.5)
        for _, tool in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == nametools then
                tool.Parent = game:GetService("Players").LocalPlayer.Character
            end
        end
    end
})

-- Botão para Crystal N4zi
ToolsTab:AddButton({
    Name = "Crystal N4zi",
    Callback = function()
        local nametools = "crystal nazi lel"
        local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Dupe Script"),
            Text = lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."),
            Button1 = lib:T("I understand"),
            Duration = 5
        })
        local toolthatiwanttodupe = "Crystal"
        local tools = "Crystal"
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
            task.wait()
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
        wait(0.1)
        local args = {
            [1] = "ClearAllTools"
        }
        cleartoolremote:FireServer(unpack(args))
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        for m = 1, 2 do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
        end
        task.wait(0.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        wait(0.3)
        local duping = true
        for m = 1, 57 do
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            if game:GetService("Workspace"):FindFirstChild("Camera") then
                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
            end
            local args = {
                [1] = "PickingTools",
                [2] = toolthatiwanttodupe
            }
            picktoolremote:InvokeServer(unpack(args))
            game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            wait()
            game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "Hândlê"
            game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
            game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            repeat
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                    game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
                end
                wait()
            until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local toolgrip = true
        duping = false
        wait()
        local gripBase = CFrame.new(-0.290086746, 0.0755810738, -0.0109872818, 0.0439560413, 0.509705901, -0.859225094, -0.0591450632, -0.857220173, -0.511542261, -0.997281134, 0.0733042806, -0.00753343105)
        local gripPositions = {
            Vector3.new(0, 0, 0), Vector3.new(0, 0.5, 0), Vector3.new(0, 1, 0), Vector3.new(0, 1.5, 0),
            Vector3.new(0, 2, 0), Vector3.new(0, 2.5, 0), Vector3.new(0, 3, 0), Vector3.new(0, 3.5, 0),
            Vector3.new(0, 4, 0), Vector3.new(0, 4.5, 0), Vector3.new(0, 5, 0), Vector3.new(0, 5, -1),
            Vector3.new(0, 5, -2), Vector3.new(0, 5, -3), Vector3.new(0, 5, -4), Vector3.new(0, 5, -5),
            Vector3.new(0, 5, -6), Vector3.new(0, 5, -7), Vector3.new(0, 5, -8), Vector3.new(0, 5, -9),
            Vector3.new(0, 5, -10), Vector3.new(0, 5.5, -10), Vector3.new(0, 6, -10), Vector3.new(0, 6.5, -10),
            Vector3.new(0, 7, -10), Vector3.new(0, 7.5, -10), Vector3.new(0, 8, -10), Vector3.new(0, 8.5, -10),
            Vector3.new(0, 9, -10), Vector3.new(0, 9.5, -10), Vector3.new(0, 10, -10), Vector3.new(0, 10, -5),
            Vector3.new(0, 10, -4.5), Vector3.new(0, 10, -4), Vector3.new(0, 10, -3.5), Vector3.new(0, 10, -3),
            Vector3.new(0, 10, -2.5), Vector3.new(0, 10, -2), Vector3.new(0, 10, -1.5), Vector3.new(0, 10, -1),
            Vector3.new(0, 10, -0.5), Vector3.new(0, 10, 0), Vector3.new(0, 9, -5), Vector3.new(0, 8, -5),
            Vector3.new(0, 7, -5), Vector3.new(0, 6, -5), Vector3.new(0, 5, -5), Vector3.new(0, 4, -5),
            Vector3.new(0, 3, -5), Vector3.new(0, 2, -5), Vector3.new(0, 1, -5), Vector3.new(0, 0, -5),
            Vector3.new(0, 0, -10), Vector3.new(0, 0, -9), Vector3.new(0, 0, -8), Vector3.new(0, 0, -7),
            Vector3.new(0, 0, -6)
        }
        for _, pos in ipairs(gripPositions) do
            game.Players.LocalPlayer.Backpack[tools].Grip = gripBase + pos
            game.Players.LocalPlayer.Backpack[tools].Name = nametools
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
        wait(0.5)
        for _, tool in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == nametools then
                tool.Parent = game:GetService("Players").LocalPlayer.Character
            end
        end
    end
})

-- Botão para FireX N4zi
ToolsTab:AddButton({
    Name = "FireX N4zi",
    Callback = function()
        local nametools = "nazi firex lel"
        local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Dupe Script"),
            Text = lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."),
            Button1 = lib:T("I understand"),
            Duration = 5
        })
        local toolthatiwanttodupe = "FireX"
        local tools = "FireX"
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
            task.wait()
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
        wait(0.1)
        local args = {
            [1] = "ClearAllTools"
        }
        cleartoolremote:FireServer(unpack(args))
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        for m = 1, 2 do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
        end
        task.wait(0.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        wait(0.3)
        local duping = true
        for m = 1, 71 do
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            if game:GetService("Workspace"):FindFirstChild("Camera") then
                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
            end
            local args = {
                [1] = "PickingTools",
                [2] = toolthatiwanttodupe
            }
            picktoolremote:InvokeServer(unpack(args))
            game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            if duping == false then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                return
            end
            wait()
            game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "Hândlê"
            game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
            game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
            repeat
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                    game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
                end
                wait()
            until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local toolgrip = true
        duping = false
        wait()
        local gripBase = CFrame.new(0.0538333468, -0.264812469, -0.0177594293, 0.999998629, 0, 0.00164011808, 0, 1, 0, -0.00164011808, 0, 0.999998629)
        local gripPositions = {
            Vector3.new(0, -2, 0), Vector3.new(0, -4, 0), Vector3.new(0, -6, 0), Vector3.new(0, -8, 0),
            Vector3.new(0, -10, 0), Vector3.new(0, -12, 0), Vector3.new(0, -14, 0), Vector3.new(1, -14, 0),
            Vector3.new(2, -14, 0), Vector3.new(3, -14, 0), Vector3.new(4, -14, 0), Vector3.new(5, -14, 0),
            Vector3.new(6, -14, 0), Vector3.new(7, -14, 0), Vector3.new(8, -14, 0), Vector3.new(9, -14, 0),
            Vector3.new(10, -14, 0), Vector3.new(11, -14, 0), Vector3.new(12, -14, 0), Vector3.new(13, -14, 0),
            Vector3.new(14, -14, 0), Vector3.new(15, -14, 0), Vector3.new(16, -14, 0), Vector3.new(17, -14, 0),
            Vector3.new(18, -14, 0), Vector3.new(19, -14, 0), Vector3.new(20, -14, 0), Vector3.new(20, -16, 0),
            Vector3.new(20, -18, 0), Vector3.new(20, -20, 0), Vector3.new(20, -22, 0), Vector3.new(20, -24, 0),
            Vector3.new(20, -26, 0), Vector3.new(20, -28, 0), Vector3.new(20, -30, 0), Vector3.new(10, -30, 0),
            Vector3.new(10, -28, 0), Vector3.new(10, -26, 0), Vector3.new(10, -24, 0), Vector3.new(10, -22, 0),
            Vector3.new(10, -20, 0), Vector3.new(10, -18, 0), Vector3.new(10, -16, 0), Vector3.new(10, -14, 0),
            Vector3.new(10, -12, 0), Vector3.new(10, -10, 0), Vector3.new(10, -8, 0), Vector3.new(10, -6, 0),
            Vector3.new(10, -4, 0), Vector3.new(10, -2, 0), Vector3.new(11, -2, 0), Vector3.new(12, -2, 0),
            Vector3.new(13, -2, 0), Vector3.new(14, -2, 0), Vector3.new(15, -2, 0), Vector3.new(16, -2, 0),
            Vector3.new(17, -2, 0), Vector3.new(18, -2, 0), Vector3.new(19, -2, 0), Vector3.new(20, -2, 0),
            Vector3.new(1, -30, 0), Vector3.new(0, -30, 0), Vector3.new(2, -30, 0), Vector3.new(3, -30, 0),
            Vector3.new(4, -30, 0), Vector3.new(5, -30, 0), Vector3.new(6, -30, 0), Vector3.new(7, -30, 0),
            Vector3.new(8, -30, 0), Vector3.new(9, -30, 0)
        }
        for _, pos in ipairs(gripPositions) do
            game.Players.LocalPlayer.Backpack[tools].Grip = gripBase + pos
            game.Players.LocalPlayer.Backpack[tools].Name = nametools
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
        wait(0.5)
        for _, tool in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == nametools then
                tool.Parent = game:GetService("Players").LocalPlayer.Character
            end
        end
    end
})

-- Seção para Aura Grip
Section = ToolsTab:AddSection({
    Name = "Aura Grip"
})

-- Botão para Couch Aura
ToolsTab:AddButton({
    Name = "Couch Aura",
    Callback = function()
    nametools = "Couch Spray lel"
                oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                toolthatiwanttodupe = "Couch"
                tools = "Couch"
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
                wait(0.1)
                local args = {
                        [1] = "ClearAllTools"
                }
                
                cleartoolremote:FireServer(unpack(args))
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                for m=1,2 do task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                        end
                        task.wait(0.2)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                wait(0.3)
                duping = true
                for m=1, 124 do
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                        local args = {
                                [1] = "PickingTools",
                                [2] = toolthatiwanttodupe
                        }
                        
                        picktoolremote:InvokeServer(unpack(args))
                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        wait()
                        game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "HÃ¢ÂÂ¥aÃ¢ÂÂ¥nÃ¢ÂÂ¥dÃ¢ÂÂ¥lÃ¢ÂÂ¥e"
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        repeat                 if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                toolgrip = true
                duping = false
                wait()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")


print("done")
wait(1)
local TablaGripPos = {
       Vector3.new(0, 0, 0),
  Vector3.new(10, 0, 0),
  Vector3.new(20, 0, 0),
  Vector3.new(30, 0, 0),
  Vector3.new(40, 0, 0),
  Vector3.new(50, 0, 0),
  Vector3.new(60, 0, 0),                      
  Vector3.new(-0, 0, 0),
  Vector3.new(-10, 0, 0),
  Vector3.new(-20, 0, 0),
  Vector3.new(-30, 0, 0),
  Vector3.new(-40, 0, 0),
  Vector3.new(-50, 0, 0),
  Vector3.new(-60, 0, 0),
                      Vector3.new(0, 0, 30),
  Vector3.new(10, 0, 30),
  Vector3.new(20, 0, 30),
  Vector3.new(30, 0, 30),
  Vector3.new(40, 0, 30),
  Vector3.new(50, 0, 30),
  Vector3.new(60, 0, 30),
  Vector3.new(-0, 0, 30),
  Vector3.new(-10, 0, 30),
  Vector3.new(-20, 0, 30),
  Vector3.new(-30, 0, 30),
  Vector3.new(-40, 0, 30),
  Vector3.new(-50, 0, 30),
  Vector3.new(-60, 0, 30),
                          Vector3.new(0, 0, 45),
  Vector3.new(10, 0, 45),
  Vector3.new(20, 0, 45),
  Vector3.new(30, 0, 45),
  Vector3.new(40, 0, 45),
  Vector3.new(50, 0, 45),
  Vector3.new(60, 0, 45),
  Vector3.new(-0, 0, 45),
  Vector3.new(-10, 0, 45),
  Vector3.new(-20, 0, 45),
  Vector3.new(-30, 0, 45),
  Vector3.new(-40, 0, 45),
  Vector3.new(-50, 0, 45),
  Vector3.new(-60, 0, 45),
  Vector3.new(0, 0, 15),
  Vector3.new(10, 0, 15),
  Vector3.new(20, 0, 15),
  Vector3.new(30, 0, 15),
  Vector3.new(40, 0, 15),
  Vector3.new(50, 0, 15),
  Vector3.new(60, 0, 15),                          
  Vector3.new(-0, 0, 15),
  Vector3.new(-10, 0, 15),
  Vector3.new(-20, 0, 15),
  Vector3.new(-30, 0, 15),
  Vector3.new(-40, 0, 15),
  Vector3.new(-50, 0, 15),
  Vector3.new(-60, 0, 15),
Vector3.new(0, 0, -15),
  Vector3.new(10, 0, -15),
  Vector3.new(20, 0, -15),
  Vector3.new(30, 0, -15),
  Vector3.new(40, 0, -15),
  Vector3.new(50, 0, -15),
  Vector3.new(60, 0, -15),                      
  Vector3.new(-0, 0, -15),
  Vector3.new(-10, 0, -15),
  Vector3.new(-20, 0, -15),
  Vector3.new(-30, 0, -15),
  Vector3.new(-40, 0, -15),
  Vector3.new(-50, 0, -15),
  Vector3.new(-60, 0, -15),
  Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -30),
  Vector3.new(20, 0, -30),
  Vector3.new(30, 0, -30),
  Vector3.new(40, 0, -30),
  Vector3.new(50, 0, -30),
  Vector3.new(60, 0, -30),                          
  Vector3.new(-0, 0, -30),
  Vector3.new(-10, 0, -30),
  Vector3.new(-20, 0, -30),
  Vector3.new(-30, 0, -30),
  Vector3.new(-40, 0, -30),
  Vector3.new(-50, 0, -30),
  Vector3.new(-60, 0, -30),
    Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -45),
  Vector3.new(20, 0, -45),
  Vector3.new(30, 0, -45),
  Vector3.new(40, 0, -45),
  Vector3.new(50, 0, -45),
  Vector3.new(60, 0, -45),                          
  Vector3.new(-0, 0, -45),
  Vector3.new(-10, 0, -45),
  Vector3.new(-20, 0, -45),
  Vector3.new(-30, 0, -45),
  Vector3.new(-40, 0, -45),
  Vector3.new(-50, 0, -45),
  Vector3.new(-60, 0, -45),
    Vector3.new(10, 0, -60),
  Vector3.new(20, 0, -60),
  Vector3.new(30, 0, -60),
  Vector3.new(40, 0, -60),
  Vector3.new(50, 0, -60),
  Vector3.new(60, 0, -60),                          
  Vector3.new(-0, 0, -60),
  Vector3.new(-10, 0, -60),
  Vector3.new(-20, 0, -60),
  Vector3.new(-30, 0, -60),
  Vector3.new(-40, 0, -60),
  Vector3.new(-50, 0, -60),
  Vector3.new(-60, 0, -60),
  Vector3.new(10, 0, -75),
  Vector3.new(20, 0, -75),
  Vector3.new(30, 0, -75),
  Vector3.new(40, 0, -75),
  Vector3.new(50, 0, -75),
  Vector3.new(60, 0, -75),                          
  Vector3.new(-0, 0, -75),
  Vector3.new(-10, 0, -75),
  Vector3.new(-20, 0, -75),
  Vector3.new(-30, 0, -75),
  Vector3.new(-40, 0, -75),
  Vector3.new(-50, 0, -75),
  Vector3.new(-60, 0, -75),


     }
      for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
          if tool:IsA("Tool") then
              tool.Parent = game.Players.LocalPlayer.Character
              local gripPosIndex = math.min(i, #TablaGripPos)
              local gripPos = TablaGripPos[gripPosIndex]
              
              if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                  tool.GripPos = gripPos
              else
                  warn("", tool.Name, "")
              end
          end
      end           
    end
})

-- Botão para Fire Aura
ToolsTab:AddButton({
    Name = "Fire Aura",
    Callback = function()
        nametools = "fire Spray lel"
                oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                toolthatiwanttodupe = "PaperbagFire"
                tools = "PaperbagFire"
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
                wait(0.1)
                local args = {
                        [1] = "ClearAllTools"
                }
                
                cleartoolremote:FireServer(unpack(args))
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                for m=1,2 do task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                        end
                        task.wait(0.2)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                wait(0.3)
                duping = true
                for m=1, 124 do
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                        local args = {
                                [1] = "PickingTools",
                                [2] = toolthatiwanttodupe
                        }
                        
                        picktoolremote:InvokeServer(unpack(args))
                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        wait()
                        game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "HÃ¢ÂÂ¥aÃ¢ÂÂ¥nÃ¢ÂÂ¥dÃ¢ÂÂ¥lÃ¢ÂÂ¥e"
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        repeat                 if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                toolgrip = true
                duping = false
                wait()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")


print("done")
wait(1)
local TablaGripPos = {
       Vector3.new(0, 0, 0),
  Vector3.new(10, 0, 0),
  Vector3.new(20, 0, 0),
  Vector3.new(30, 0, 0),
  Vector3.new(40, 0, 0),
  Vector3.new(50, 0, 0),
  Vector3.new(60, 0, 0),                      
  Vector3.new(-0, 0, 0),
  Vector3.new(-10, 0, 0),
  Vector3.new(-20, 0, 0),
  Vector3.new(-30, 0, 0),
  Vector3.new(-40, 0, 0),
  Vector3.new(-50, 0, 0),
  Vector3.new(-60, 0, 0),
                      Vector3.new(0, 0, 30),
  Vector3.new(10, 0, 30),
  Vector3.new(20, 0, 30),
  Vector3.new(30, 0, 30),
  Vector3.new(40, 0, 30),
  Vector3.new(50, 0, 30),
  Vector3.new(60, 0, 30),
  Vector3.new(-0, 0, 30),
  Vector3.new(-10, 0, 30),
  Vector3.new(-20, 0, 30),
  Vector3.new(-30, 0, 30),
  Vector3.new(-40, 0, 30),
  Vector3.new(-50, 0, 30),
  Vector3.new(-60, 0, 30),
                          Vector3.new(0, 0, 45),
  Vector3.new(10, 0, 45),
  Vector3.new(20, 0, 45),
  Vector3.new(30, 0, 45),
  Vector3.new(40, 0, 45),
  Vector3.new(50, 0, 45),
  Vector3.new(60, 0, 45),
  Vector3.new(-0, 0, 45),
  Vector3.new(-10, 0, 45),
  Vector3.new(-20, 0, 45),
  Vector3.new(-30, 0, 45),
  Vector3.new(-40, 0, 45),
  Vector3.new(-50, 0, 45),
  Vector3.new(-60, 0, 45),
  Vector3.new(0, 0, 15),
  Vector3.new(10, 0, 15),
  Vector3.new(20, 0, 15),
  Vector3.new(30, 0, 15),
  Vector3.new(40, 0, 15),
  Vector3.new(50, 0, 15),
  Vector3.new(60, 0, 15),                          
  Vector3.new(-0, 0, 15),
  Vector3.new(-10, 0, 15),
  Vector3.new(-20, 0, 15),
  Vector3.new(-30, 0, 15),
  Vector3.new(-40, 0, 15),
  Vector3.new(-50, 0, 15),
  Vector3.new(-60, 0, 15),
Vector3.new(0, 0, -15),
  Vector3.new(10, 0, -15),
  Vector3.new(20, 0, -15),
  Vector3.new(30, 0, -15),
  Vector3.new(40, 0, -15),
  Vector3.new(50, 0, -15),
  Vector3.new(60, 0, -15),                      
  Vector3.new(-0, 0, -15),
  Vector3.new(-10, 0, -15),
  Vector3.new(-20, 0, -15),
  Vector3.new(-30, 0, -15),
  Vector3.new(-40, 0, -15),
  Vector3.new(-50, 0, -15),
  Vector3.new(-60, 0, -15),
  Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -30),
  Vector3.new(20, 0, -30),
  Vector3.new(30, 0, -30),
  Vector3.new(40, 0, -30),
  Vector3.new(50, 0, -30),
  Vector3.new(60, 0, -30),                          
  Vector3.new(-0, 0, -30),
  Vector3.new(-10, 0, -30),
  Vector3.new(-20, 0, -30),
  Vector3.new(-30, 0, -30),
  Vector3.new(-40, 0, -30),
  Vector3.new(-50, 0, -30),
  Vector3.new(-60, 0, -30),
    Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -45),
  Vector3.new(20, 0, -45),
  Vector3.new(30, 0, -45),
  Vector3.new(40, 0, -45),
  Vector3.new(50, 0, -45),
  Vector3.new(60, 0, -45),                          
  Vector3.new(-0, 0, -45),
  Vector3.new(-10, 0, -45),
  Vector3.new(-20, 0, -45),
  Vector3.new(-30, 0, -45),
  Vector3.new(-40, 0, -45),
  Vector3.new(-50, 0, -45),
  Vector3.new(-60, 0, -45),
    Vector3.new(10, 0, -60),
  Vector3.new(20, 0, -60),
  Vector3.new(30, 0, -60),
  Vector3.new(40, 0, -60),
  Vector3.new(50, 0, -60),
  Vector3.new(60, 0, -60),                          
  Vector3.new(-0, 0, -60),
  Vector3.new(-10, 0, -60),
  Vector3.new(-20, 0, -60),
  Vector3.new(-30, 0, -60),
  Vector3.new(-40, 0, -60),
  Vector3.new(-50, 0, -60),
  Vector3.new(-60, 0, -60),
  Vector3.new(10, 0, -75),
  Vector3.new(20, 0, -75),
  Vector3.new(30, 0, -75),
  Vector3.new(40, 0, -75),
  Vector3.new(50, 0, -75),
  Vector3.new(60, 0, -75),                          
  Vector3.new(-0, 0, -75),
  Vector3.new(-10, 0, -75),
  Vector3.new(-20, 0, -75),
  Vector3.new(-30, 0, -75),
  Vector3.new(-40, 0, -75),
  Vector3.new(-50, 0, -75),
  Vector3.new(-60, 0, -75),


     }
      for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
          if tool:IsA("Tool") then
              tool.Parent = game.Players.LocalPlayer.Character
              local gripPosIndex = math.min(i, #TablaGripPos)
              local gripPos = TablaGripPos[gripPosIndex]
              
              if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                  tool.GripPos = gripPos
              else
                  warn("", tool.Name, "")
              end
          end
      end           
    end
})

-- Botão para Water Aura
ToolsTab:AddButton({
    Name = "Water Aura",
    Callback = function()
        nametools = "water Spray lel"
                oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                toolthatiwanttodupe = "WateringCan"
                tools = "WateringCan"
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
                wait(0.1)
                local args = {
                        [1] = "ClearAllTools"
                }
                
                cleartoolremote:FireServer(unpack(args))
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                for m=1,2 do task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                        end
                        task.wait(0.2)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                wait(0.3)
                duping = true
                for m=1, 124 do
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                        local args = {
                                [1] = "PickingTools",
                                [2] = toolthatiwanttodupe
                        }
                        
                        picktoolremote:InvokeServer(unpack(args))
                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        wait()
                        game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "HÃ¢ÂÂ¥aÃ¢ÂÂ¥nÃ¢ÂÂ¥dÃ¢ÂÂ¥lÃ¢ÂÂ¥e"
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        repeat                 if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                toolgrip = true
                duping = false
                wait()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")


print("done")
wait(1)
local TablaGripPos = {
       Vector3.new(0, 0, 0),
  Vector3.new(10, 0, 0),
  Vector3.new(20, 0, 0),
  Vector3.new(30, 0, 0),
  Vector3.new(40, 0, 0),
  Vector3.new(50, 0, 0),
  Vector3.new(60, 0, 0),                      
  Vector3.new(-0, 0, 0),
  Vector3.new(-10, 0, 0),
  Vector3.new(-20, 0, 0),
  Vector3.new(-30, 0, 0),
  Vector3.new(-40, 0, 0),
  Vector3.new(-50, 0, 0),
  Vector3.new(-60, 0, 0),
                      Vector3.new(0, 0, 30),
  Vector3.new(10, 0, 30),
  Vector3.new(20, 0, 30),
  Vector3.new(30, 0, 30),
  Vector3.new(40, 0, 30),
  Vector3.new(50, 0, 30),
  Vector3.new(60, 0, 30),
  Vector3.new(-0, 0, 30),
  Vector3.new(-10, 0, 30),
  Vector3.new(-20, 0, 30),
  Vector3.new(-30, 0, 30),
  Vector3.new(-40, 0, 30),
  Vector3.new(-50, 0, 30),
  Vector3.new(-60, 0, 30),
                          Vector3.new(0, 0, 45),
  Vector3.new(10, 0, 45),
  Vector3.new(20, 0, 45),
  Vector3.new(30, 0, 45),
  Vector3.new(40, 0, 45),
  Vector3.new(50, 0, 45),
  Vector3.new(60, 0, 45),
  Vector3.new(-0, 0, 45),
  Vector3.new(-10, 0, 45),
  Vector3.new(-20, 0, 45),
  Vector3.new(-30, 0, 45),
  Vector3.new(-40, 0, 45),
  Vector3.new(-50, 0, 45),
  Vector3.new(-60, 0, 45),
  Vector3.new(0, 0, 15),
  Vector3.new(10, 0, 15),
  Vector3.new(20, 0, 15),
  Vector3.new(30, 0, 15),
  Vector3.new(40, 0, 15),
  Vector3.new(50, 0, 15),
  Vector3.new(60, 0, 15),                          
  Vector3.new(-0, 0, 15),
  Vector3.new(-10, 0, 15),
  Vector3.new(-20, 0, 15),
  Vector3.new(-30, 0, 15),
  Vector3.new(-40, 0, 15),
  Vector3.new(-50, 0, 15),
  Vector3.new(-60, 0, 15),
Vector3.new(0, 0, -15),
  Vector3.new(10, 0, -15),
  Vector3.new(20, 0, -15),
  Vector3.new(30, 0, -15),
  Vector3.new(40, 0, -15),
  Vector3.new(50, 0, -15),
  Vector3.new(60, 0, -15),                      
  Vector3.new(-0, 0, -15),
  Vector3.new(-10, 0, -15),
  Vector3.new(-20, 0, -15),
  Vector3.new(-30, 0, -15),
  Vector3.new(-40, 0, -15),
  Vector3.new(-50, 0, -15),
  Vector3.new(-60, 0, -15),
  Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -30),
  Vector3.new(20, 0, -30),
  Vector3.new(30, 0, -30),
  Vector3.new(40, 0, -30),
  Vector3.new(50, 0, -30),
  Vector3.new(60, 0, -30),                          
  Vector3.new(-0, 0, -30),
  Vector3.new(-10, 0, -30),
  Vector3.new(-20, 0, -30),
  Vector3.new(-30, 0, -30),
  Vector3.new(-40, 0, -30),
  Vector3.new(-50, 0, -30),
  Vector3.new(-60, 0, -30),
    Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -45),
  Vector3.new(20, 0, -45),
  Vector3.new(30, 0, -45),
  Vector3.new(40, 0, -45),
  Vector3.new(50, 0, -45),
  Vector3.new(60, 0, -45),                          
  Vector3.new(-0, 0, -45),
  Vector3.new(-10, 0, -45),
  Vector3.new(-20, 0, -45),
  Vector3.new(-30, 0, -45),
  Vector3.new(-40, 0, -45),
  Vector3.new(-50, 0, -45),
  Vector3.new(-60, 0, -45),
    Vector3.new(10, 0, -60),
  Vector3.new(20, 0, -60),
  Vector3.new(30, 0, -60),
  Vector3.new(40, 0, -60),
  Vector3.new(50, 0, -60),
  Vector3.new(60, 0, -60),                          
  Vector3.new(-0, 0, -60),
  Vector3.new(-10, 0, -60),
  Vector3.new(-20, 0, -60),
  Vector3.new(-30, 0, -60),
  Vector3.new(-40, 0, -60),
  Vector3.new(-50, 0, -60),
  Vector3.new(-60, 0, -60),
  Vector3.new(10, 0, -75),
  Vector3.new(20, 0, -75),
  Vector3.new(30, 0, -75),
  Vector3.new(40, 0, -75),
  Vector3.new(50, 0, -75),
  Vector3.new(60, 0, -75),                          
  Vector3.new(-0, 0, -75),
  Vector3.new(-10, 0, -75),
  Vector3.new(-20, 0, -75),
  Vector3.new(-30, 0, -75),
  Vector3.new(-40, 0, -75),
  Vector3.new(-50, 0, -75),
  Vector3.new(-60, 0, -75),


     }
      for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
          if tool:IsA("Tool") then
              tool.Parent = game.Players.LocalPlayer.Character
              local gripPosIndex = math.min(i, #TablaGripPos)
              local gripPos = TablaGripPos[gripPosIndex]
              
              if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                  tool.GripPos = gripPos
              else
                  warn("", tool.Name, "")
              end
          end
      end
    end
})

-- Botão para Light Aura
ToolsTab:AddButton({
    Name = "Light Aura",
    Callback = function()
        nametools = "light Spray lel"
                oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game:GetService("StarterGui"):SetCore("SendNotification",{Title=lib:T("Dupe Script"),Text=lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."), Button1 = lib:T("I understand") ,Duration=5})
                toolthatiwanttodupe = "FlashLight"
                tools = "FlashLight"
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
                wait(0.1)
                local args = {
                        [1] = "ClearAllTools"
                }
                
                cleartoolremote:FireServer(unpack(args))
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                for m=1,2 do task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                        end
                        task.wait(0.2)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                wait(0.3)
                duping = true
                for m=1, 124 do
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                        local args = {
                                [1] = "PickingTools",
                                [2] = toolthatiwanttodupe
                        }
                        
                        picktoolremote:InvokeServer(unpack(args))
                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        wait()
                        game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "HÃ¢ÂÂ¥aÃ¢ÂÂ¥nÃ¢ÂÂ¥dÃ¢ÂÂ¥lÃ¢ÂÂ¥e"
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        repeat                 if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                toolgrip = true
                duping = false
                wait()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")


print("done")
wait(1)
local TablaGripPos = {
       Vector3.new(0, 0, 0),
  Vector3.new(10, 0, 0),
  Vector3.new(20, 0, 0),
  Vector3.new(30, 0, 0),
  Vector3.new(40, 0, 0),
  Vector3.new(50, 0, 0),
  Vector3.new(60, 0, 0),                      
  Vector3.new(-0, 0, 0),
  Vector3.new(-10, 0, 0),
  Vector3.new(-20, 0, 0),
  Vector3.new(-30, 0, 0),
  Vector3.new(-40, 0, 0),
  Vector3.new(-50, 0, 0),
  Vector3.new(-60, 0, 0),
                      Vector3.new(0, 0, 30),
  Vector3.new(10, 0, 30),
  Vector3.new(20, 0, 30),
  Vector3.new(30, 0, 30),
  Vector3.new(40, 0, 30),
  Vector3.new(50, 0, 30),
  Vector3.new(60, 0, 30),
  Vector3.new(-0, 0, 30),
  Vector3.new(-10, 0, 30),
  Vector3.new(-20, 0, 30),
  Vector3.new(-30, 0, 30),
  Vector3.new(-40, 0, 30),
  Vector3.new(-50, 0, 30),
  Vector3.new(-60, 0, 30),
                          Vector3.new(0, 0, 45),
  Vector3.new(10, 0, 45),
  Vector3.new(20, 0, 45),
  Vector3.new(30, 0, 45),
  Vector3.new(40, 0, 45),
  Vector3.new(50, 0, 45),
  Vector3.new(60, 0, 45),
  Vector3.new(-0, 0, 45),
  Vector3.new(-10, 0, 45),
  Vector3.new(-20, 0, 45),
  Vector3.new(-30, 0, 45),
  Vector3.new(-40, 0, 45),
  Vector3.new(-50, 0, 45),
  Vector3.new(-60, 0, 45),
  Vector3.new(0, 0, 15),
  Vector3.new(10, 0, 15),
  Vector3.new(20, 0, 15),
  Vector3.new(30, 0, 15),
  Vector3.new(40, 0, 15),
  Vector3.new(50, 0, 15),
  Vector3.new(60, 0, 15),                          
  Vector3.new(-0, 0, 15),
  Vector3.new(-10, 0, 15),
  Vector3.new(-20, 0, 15),
  Vector3.new(-30, 0, 15),
  Vector3.new(-40, 0, 15),
  Vector3.new(-50, 0, 15),
  Vector3.new(-60, 0, 15),
Vector3.new(0, 0, -15),
  Vector3.new(10, 0, -15),
  Vector3.new(20, 0, -15),
  Vector3.new(30, 0, -15),
  Vector3.new(40, 0, -15),
  Vector3.new(50, 0, -15),
  Vector3.new(60, 0, -15),                      
  Vector3.new(-0, 0, -15),
  Vector3.new(-10, 0, -15),
  Vector3.new(-20, 0, -15),
  Vector3.new(-30, 0, -15),
  Vector3.new(-40, 0, -15),
  Vector3.new(-50, 0, -15),
  Vector3.new(-60, 0, -15),
  Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -30),
  Vector3.new(20, 0, -30),
  Vector3.new(30, 0, -30),
  Vector3.new(40, 0, -30),
  Vector3.new(50, 0, -30),
  Vector3.new(60, 0, -30),                          
  Vector3.new(-0, 0, -30),
  Vector3.new(-10, 0, -30),
  Vector3.new(-20, 0, -30),
  Vector3.new(-30, 0, -30),
  Vector3.new(-40, 0, -30),
  Vector3.new(-50, 0, -30),
  Vector3.new(-60, 0, -30),
    Vector3.new(0, 0, -30),
  Vector3.new(10, 0, -45),
  Vector3.new(20, 0, -45),
  Vector3.new(30, 0, -45),
  Vector3.new(40, 0, -45),
  Vector3.new(50, 0, -45),
  Vector3.new(60, 0, -45),                          
  Vector3.new(-0, 0, -45),
  Vector3.new(-10, 0, -45),
  Vector3.new(-20, 0, -45),
  Vector3.new(-30, 0, -45),
  Vector3.new(-40, 0, -45),
  Vector3.new(-50, 0, -45),
  Vector3.new(-60, 0, -45),
    Vector3.new(10, 0, -60),
  Vector3.new(20, 0, -60),
  Vector3.new(30, 0, -60),
  Vector3.new(40, 0, -60),
  Vector3.new(50, 0, -60),
  Vector3.new(60, 0, -60),                          
  Vector3.new(-0, 0, -60),
  Vector3.new(-10, 0, -60),
  Vector3.new(-20, 0, -60),
  Vector3.new(-30, 0, -60),
  Vector3.new(-40, 0, -60),
  Vector3.new(-50, 0, -60),
  Vector3.new(-60, 0, -60),
  Vector3.new(10, 0, -75),
  Vector3.new(20, 0, -75),
  Vector3.new(30, 0, -75),
  Vector3.new(40, 0, -75),
  Vector3.new(50, 0, -75),
  Vector3.new(60, 0, -75),                          
  Vector3.new(-0, 0, -75),
  Vector3.new(-10, 0, -75),
  Vector3.new(-20, 0, -75),
  Vector3.new(-30, 0, -75),
  Vector3.new(-40, 0, -75),
  Vector3.new(-50, 0, -75),
  Vector3.new(-60, 0, -75),


     }
      for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
          if tool:IsA("Tool") then
              tool.Parent = game.Players.LocalPlayer.Character
              local gripPosIndex = math.min(i, #TablaGripPos)
              local gripPos = TablaGripPos[gripPosIndex]
              
              if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                  tool.GripPos = gripPos
              else
                  warn("", tool.Name, "")
              end
          end
      end
    end
})

-- Botão para Smoke Aura
ToolsTab:AddButton({
    Name = "Smoke Aura",
    Callback = function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = lib:T("Dupe Script"),
            Text = lib:T("Please do not equip any tools or unequip tools or click tools on inventory. It will break the script."),
            Button1 = lib:T("I understand"),
            Duration = 5
        })
        local args = {
            [1] = "ClearAllTools"
        }
        cleartoolremote:FireServer(unpack(args))
        if game:GetService("Workspace"):FindFirstChild("Camera") then
            game:GetService("Workspace"):FindFirstChild("Camera"):Destroy()
        end
        wait(0.3)
        for i = 1, 124 do
            local args = {
                [1] = "PickingTools",
                [2] = "FireHose"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            local args = {
                [1] = "FireHose",
                [2] = "DestroyFireHose"
            }
            game:GetService("Players").LocalPlayer.Backpack.FireHose.ToolSound:FireServer(unpack(args))
        end
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        wait(8)
        local TablaGripPos = {
            Vector3.new(0, 0, 0), Vector3.new(10, 0, 0), Vector3.new(20, 0, 0), Vector3.new(30, 0, 0),
            Vector3.new(40, 0, 0), Vector3.new(50, 0, 0), Vector3.new(60, 0, 0), Vector3.new(-0, 0, 0),
            Vector3.new(-10, 0, 0), Vector3.new(-20, 0, 0), Vector3.new(-30, 0, 0), Vector3.new(-40, 0, 0),
            Vector3.new(-50, 0, 0), Vector3.new(-60, 0, 0), Vector3.new(0, 0, 30), Vector3.new(10, 0, 30),
            Vector3.new(20, 0, 30), Vector3.new(30, 0, 30), Vector3.new(40, 0, 30), Vector3.new(50, 0, 30),
            Vector3.new(60, 0, 30), Vector3.new(-0, 0, 30), Vector3.new(-10, 0, 30), Vector3.new(-20, 0, 30),
            Vector3.new(-30, 0, 30), Vector3.new(-40, 0, 30), Vector3.new(-50, 0, 30), Vector3.new(-60, 0, 30),
            Vector3.new(0, 0, 45), Vector3.new(10, 0, 45), Vector3.new(20, 0, 45), Vector3.new(30, 0, 45),
            Vector3.new(40, 0, 45), Vector3.new(50, 0, 45), Vector3.new(60, 0, 45), Vector3.new(-0, 0, 45),
            Vector3.new(-10, 0, 45), Vector3.new(-20, 0, 45), Vector3.new(-30, 0, 45), Vector3.new(-40, 0, 45),
            Vector3.new(-50, 0, 45), Vector3.new(-60, 0, 45), Vector3.new(0, 0, 15), Vector3.new(10, 0, 15),
            Vector3.new(20, 0, 15), Vector3.new(30, 0, 15), Vector3.new(40, 0, 15), Vector3.new(50, 0, 15),
            Vector3.new(60, 0, 15), Vector3.new(-0, 0, 15), Vector3.new(-10, 0, 15), Vector3.new(-20, 0, 15),
            Vector3.new(-30, 0, 15), Vector3.new(-40, 0, 15), Vector3.new(-50, 0, 15), Vector3.new(-60, 0, 15),
            Vector3.new(0, 0, -15), Vector3.new(10, 0, -15), Vector3.new(20, 0, -15), Vector3.new(30, 0, -15),
            Vector3.new(40, 0, -15), Vector3.new(50, 0, -15), Vector3.new(60, 0, -15), Vector3.new(-0, 0, -15),
            Vector3.new(-10, 0, -15), Vector3.new(-20, 0, -15), Vector3.new(-30, 0, -15), Vector3.new(-40, 0, -15),
            Vector3.new(-50, 0, -15), Vector3.new(-60, 0, -15), Vector3.new(0, 0, -30), Vector3.new(10, 0, -30),
            Vector3.new(20, 0, -30), Vector3.new(30, 0, -30), Vector3.new(40, 0, -30), Vector3.new(50, 0, -30),
            Vector3.new(60, 0, -30), Vector3.new(-0, 0, -30), Vector3.new(-10, 0, -30), Vector3.new(-20, 0, -30),
            Vector3.new(-30, 0, -30), Vector3.new(-40, 0, -30), Vector3.new(-50, 0, -30), Vector3.new(-60, 0, -30),
            Vector3.new(0, 0, -30), Vector3.new(10, 0, -45), Vector3.new(20, 0, -45), Vector3.new(30, 0, -45),
            Vector3.new(40, 0, -45), Vector3.new(50, 0, -45), Vector3.new(60, 0, -45), Vector3.new(-0, 0, -45),
            Vector3.new(-10, 0, -45), Vector3.new(-20, 0, -45), Vector3.new(-30, 0, -45), Vector3.new(-40, 0, -45),
            Vector3.new(-50, 0, -45), Vector3.new(-60, 0, -45), Vector3.new(10, 0, -60), Vector3.new(20, 0, -60),
            Vector3.new(30, 0, -60), Vector3.new(40, 0, -60), Vector3.new(50, 0, -60), Vector3.new(60, 0, -60),
            Vector3.new(-0, 0, -60), Vector3.new(-10, 0, -60), Vector3.new(-20, 0, -60), Vector3.new(-30, 0, -60),
            Vector3.new(-40, 0, -60), Vector3.new(-50, 0, -60), Vector3.new(-60, 0, -60), Vector3.new(10, 0, -75),
            Vector3.new(20, 0, -75), Vector3.new(30, 0, -75), Vector3.new(40, 0, -75), Vector3.new(50, 0, -75),
            Vector3.new(60, 0, -75), Vector3.new(-0, 0, -75), Vector3.new(-10, 0, -75), Vector3.new(-20, 0, -75),
            Vector3.new(-30, 0, -75), Vector3.new(-40, 0, -75), Vector3.new(-50, 0, -75), Vector3.new(-60, 0, -75)
        }
        for i, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = game.Players.LocalPlayer.Character
                local gripPosIndex = math.min(i, #TablaGripPos)
                local gripPos = TablaGripPos[gripPosIndex]
                if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then
                    tool.GripPos = gripPos
                else
                    warn("Ferramenta ", tool.Name, " não está no personagem.")
                end
            end
        end
    end
})

-- Seção para D1ck Grip
Section = ToolsTab:AddSection({
    Name = "D1ck Grip"
})

-- Botão para Black D1ck
ToolsTab:AddButton({
    Name = "Black D1ck",
    Callback = function()
                        oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                toolthatiwanttodupe = "Box"
                tools = "Box"
                if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                        task.wait()
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
                wait(0.1)
                local args = {
                        [1] = "ClearAllTools"
                }
                
                cleartoolremote:FireServer(unpack(args))
                if game:GetService("Workspace"):FindFirstChild("Camera") then
                        game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                for m=1,2 do task.wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -490, 999999999.414, 0.974360406, -0.175734088, 0.14049761, -0.133441404, 0.0514053069, 0.989722729, -0.181150302, -0.983094692, 0.0266370922)
                        end
                        task.wait(0.2)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                wait(0.3)
                duping = true
                for m=1, 76 do
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end
                        local args = {
                                [1] = "PickingTools",
                                [2] = toolthatiwanttodupe
                        }
                        
                        picktoolremote:InvokeServer(unpack(args))
                        game:GetService("Players").LocalPlayer.Backpack:WaitForChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        if duping == false then game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false return end
                        wait()
                        game:GetService("Players").LocalPlayer.Character[toolthatiwanttodupe]:FindFirstChild("Handle").Name = "Hâ¥aâ¥nâ¥dâ¥lâ¥e"
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Backpack
                        game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(toolthatiwanttodupe).Parent = game.Players.LocalPlayer.Character
                        repeat                 if game:GetService("Workspace"):FindFirstChild("Camera") then
                                game:GetService("Workspace"):FindFirstChild("Camera"):Destroy() end wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild(toolthatiwanttodupe) == nil
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") == nil
                repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                toolgrip = true
                duping = false
                wait(1)
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -1.5, 0)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, 2)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, 6)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, 8)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, -8)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, -6)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, 0, -2)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -1, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -2, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -3, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -4, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -5, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -6, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -7, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -8, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -9, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10, -10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, -9)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, -8)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, -6)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10, -5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -11.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -12.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -13.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -14.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -15.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -16.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -17.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -18.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -19.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -20.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -21.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -22.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -23.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -24.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -25.5, -4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -26, -3.5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -27, -2.5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -27, -1.5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -27, -1.5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -1, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -2, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -3, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -4, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -5, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -6, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -7, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -8, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -9, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10, 10)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, 9)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, 8)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, 6)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10, 5)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -10.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -11.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -12.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -13.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -14.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -15.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -16.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -17.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -18.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -19.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -20.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -21.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -22.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -23.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -24.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -25.5, 4)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -26, 3)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -27, 2)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Backpack[tools].Grip = CFrame.new(-0.784089804, 0.623452663, 0.928474426, 0.611631632, 0.0202812403, -0.790882647, 0.107864097, 0.988198876, 0.108758211, 0.783755124, -0.151827812, 0.602226019) + Vector3.new(0, -27, 0)
                game.Players.LocalPlayer.Backpack[tools].Name = "Big Black Dick Lmao"
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcframe
                wait(0.5)
                for _, tool in ipairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                                if tool.Name == nametools then
                                 tool.Parent = game:GetService("Players").LocalPlayer.Character
                                end
                        end
                end
    end
})

local UniversalTab = t3.JJ

-- Seção para Scripts Universais
Section = UniversalTab:AddSection({
    Name = "Scripts Universais"
})

-- Botão para Rael Hub Brook
UniversalTab:AddButton({
    Name = "Rael Hub Brook",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/The-Mimic-Rael-Hub-20921"))()
    end
})

-- Botão para ShiftLock


-- Botão para Ghost Hub
UniversalTab:AddButton({
    Name = "Ghost Hub",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-GhostHub-16534"))()
    end
})

-- Botão para Infinite Yield
UniversalTab:AddButton({
    Name = "InfiniteYield - Cmd",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- Botão para TP Tool


-- Botão para Fly Gui
UniversalTab:AddButton({
    Name = "Fly Gui",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Fly-v3-7412"))()
    end
})

-- Botão para Nameless Admin 
UniversalTab:AddButton({
    Name = "Nameless Admin - Cmd",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    end
})





end)
if not okPort then warn("[Flow Hub] extra tabs error: " .. tostring(errPort)) end
end)
task.delay(5, function() pcall(function() lib.SweepSections() end) end)
