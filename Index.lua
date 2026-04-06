-- [[ SERVIÇOS DO ROBLOX ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- [[ CONFIGURAÇÕES GERAIS ]] --
local URL = "https://th-system-database-default-rtdb.firebaseio.com/whitelist.json"
local Player = Players.LocalPlayer
local Nick = Player.Name
local Camera = workspace.CurrentCamera

-- CORES PADRÃO HYDRA
local VERDE = Color3.fromRGB(0, 255, 100)
local ROXO = Color3.fromRGB(170, 0, 255)
local BRANCO = Color3.fromRGB(255, 255, 255)

-- Limpeza de UI antiga
if CoreGui:FindFirstChild("TH_Skech_Final") then CoreGui.TH_Skech_Final:Destroy() end
if CoreGui:FindFirstChild("TH_Login_Premium") then CoreGui.TH_Login_Premium:Destroy() end

-- [[ VARIÁVEIS DO CHEAT ]] --
_G.Aimbot = false
_G.ShowFOV = false
_G.FOVSize = 100
_G.Smooth = 0.5
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_Line = false
_G.ESP_Dist = false
_G.ESP_ADM = false
_G.Fly = false
_G.Speed = 16
_G.GodMode = false
_G.AntiKick = false

-- [[ FUNÇÃO DO MENU PRINCIPAL ]] --
local function AbrirMenuTH()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TH_Skech_Final"
    ScreenGui.ResetOnSpawn = false

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5; FOVCircle.Color = ROXO; FOVCircle.Filled = false; FOVCircle.Transparency = 1

    -- Sistema ESP Completo
    local function CreateESP(Target)
        local Box = Drawing.new("Square"); Box.Thickness = 1; Box.Filled = false; Box.Color = ROXO
        local Line = Drawing.new("Line"); Line.Thickness = 1; Line.Color = ROXO
        local Name = Drawing.new("Text"); Name.Size = 14; Name.Center = true; Name.Outline = true; Name.Color = BRANCO
        local Dist = Drawing.new("Text"); Dist.Size = 13; Dist.Center = true; Dist.Outline = true; Dist.Color = BRANCO

        RunService.RenderStepped:Connect(function()
            if Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and Target.Character.Humanoid.Health > 0 then
                local Root = Target.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
                local isADM = Target:GetRankInGroup(0) > 100 or Target.Name:lower():find("admin") or Target.Name:lower():find("staff")
                local CurrentColor = (_G.ESP_ADM and isADM) and Color3.new(1, 0, 0) or ROXO

                if OnScreen then
                    local SX, SY = 2000/Pos.Z, 3000/Pos.Z
                    Box.Visible = _G.ESP_Box; Box.Size = Vector2.new(SX, SY); Box.Position = Vector2.new(Pos.X - SX/2, Pos.Y - SY/2); Box.Color = CurrentColor
                    Line.Visible = _G.ESP_Line; Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Line.To = Vector2.new(Pos.X, Pos.Y + SY/2); Line.Color = CurrentColor
                    Name.Visible = _G.ESP_Name; Name.Text = (_G.ESP_ADM and isADM) and "[ADM] "..Target.Name or Target.Name; Name.Position = Vector2.new(Pos.X, Pos.Y - SY/2 - 15)
                    Dist.Visible = _G.ESP_Dist; Dist.Text = math.floor((Root.Position - Player.Character.HumanoidRootPart.Position).Magnitude).."m"; Dist.Position = Vector2.new(Pos.X, Pos.Y + SY/2 + 5)
                else Box.Visible = false; Line.Visible = false; Name.Visible = false; Dist.Visible = false end
            else Box.Visible = false; Line.Visible = false; Name.Visible = false; Dist.Visible = false end
        end)
    end
    for _, p in pairs(Players:GetPlayers()) do if p ~= Player then CreateESP(p) end end
    Players.PlayerAdded:Connect(function(p) if p ~= Player then CreateESP(p) end end)

    -- Design do Menu
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(15,15,15); Instance.new("UICorner", Main)
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10,10,10); Instance.new("UICorner", Sidebar)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -140, 1, -20); Container.Position = UDim2.new(0, 140, 0, 10); Container.BackgroundTransparency = 1
    
    local Logo = Instance.new("TextLabel", Sidebar); Logo.Size = UDim2.new(1, 0, 0, 50); Logo.RichText = true
    Logo.Text = '<font color="rgb(255,255,255)">TH</font> <font color="rgb(0,255,100)">SYSTEM</font>\n<font color="rgb(170,0,255)">HYDRA V1</font>'
    Logo.Font = "GothamBold"; Logo.TextSize = 14; Logo.BackgroundTransparency = 1

    local Pages, TabBtns, Count = {}, {}, 0

    local function AddTab(name)
        local P = Instance.new("ScrollingFrame", Container); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0; Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
        local B = Instance.new("TextButton", Sidebar); B.Size = UDim2.new(1, -10, 0, 35); B.Position = UDim2.new(0, 5, 0, 60 + (Count * 40)); B.BackgroundTransparency = 1; B.Text = "  "..name; B.Font = "GothamSemibold"; B.TextColor3 = Color3.fromRGB(130,130,130); B.TextSize = 14; B.TextXAlignment = "Left"
        B.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages) do v.Visible = false end; for _,v in pairs(TabBtns) do TS:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130,130,130)}):Play() end
            P.Visible = true; TS:Create(B, TweenInfo.new(0.2), {TextColor3 = ROXO}):Play()
        end)
        Pages[name] = P; TabBtns[name] = B; Count = Count + 1; return P
    end

    local function CreateGroup(parent, title)
        local G = Instance.new("Frame", parent); G.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", G); Instance.new("UIStroke", G).Color = Color3.fromRGB(40,40,40)
        local T = Instance.new("TextLabel", G); T.Size = UDim2.new(1, -10, 0, 30); T.Position = UDim2.new(0, 10, 0, 0); T.Text = title; T.Font = "GothamBold"; T.TextColor3 = BRANCO; T.TextSize = 13; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1
        local C = Instance.new("Frame", G); C.Position = UDim2.new(0, 10, 0, 35); C.BackgroundTransparency = 1; local L = Instance.new("UIListLayout", C); L.Padding = UDim.new(0, 5)
        L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() C.Size = UDim2.new(1, -20, 0, L.AbsoluteContentSize.Y); G.Size = UDim2.new(1, -10, 0, L.AbsoluteContentSize.Y + 45) end)
        return C
    end

    local function AddToggle(parent, text, callback)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 30); F.BackgroundTransparency = 1
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, -40, 1, 0); L.Text = text; L.TextColor3 = Color3.fromRGB(150,150,150); L.Font = "Gotham"; L.TextSize = 13; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
        local B = Instance.new("TextButton", F); B.Size = UDim2.new(0, 34, 0, 16); B.Position = UDim2.new(1, -35, 0.5, -8); B.BackgroundColor3 = Color3.fromRGB(45,45,45); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(1,0)
        local ball = Instance.new("Frame", B); ball.Size = UDim2.new(0, 12, 0, 12); ball.Position = UDim2.new(0, 2, 0.5, -6); ball.BackgroundColor3 = BRANCO; Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)
        local s = false; B.MouseButton1Click:Connect(function() s = not s; callback(s); TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = s and ROXO or Color3.fromRGB(45,45,45)}):Play(); TS:Create(ball, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play() end)
    end

    local function AddSlider(parent, text, min, max, start, callback)
        local F = Instance.new("Frame", parent); F.Size = UDim2.new(1, 0, 0, 45); F.BackgroundTransparency = 1
        local L = Instance.new("TextLabel", F); L.Size = UDim2.new(1, 0, 0, 20); L.Text = text..": "..start; L.TextColor3 = Color3.fromRGB(130,130,130); L.Font = "Gotham"; L.TextSize = 12; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
        local Bar = Instance.new("Frame", F); Bar.Size = UDim2.new(1, 0, 0, 4); Bar.Position = UDim2.new(0, 0, 0, 30); Bar.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", Bar)
        local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((start-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = ROXO; Instance.new("UICorner", Fill)
        Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (max - min) * pos); L.Text = text..": "..val; callback(val)
            end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end end)
    end

    local function AddButton(parent, text, callback)
        local B = Instance.new("TextButton", parent); B.Size = UDim2.new(1, 0, 0, 30); B.BackgroundColor3 = Color3.fromRGB(30,30,30); B.Text = text; B.Font = "GothamSemibold"; B.TextColor3 = BRANCO; B.TextSize = 12; Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(callback)
    end

    -- TAB AIMBOT
    local T1 = AddTab("Aimbot"); local G1 = CreateGroup(T1, "Combate")
    AddToggle(G1, "Ativar Aimbot", function(v) _G.Aimbot = v end)
    AddToggle(G1, "Mostrar FOV", function(v) _G.ShowFOV = v end)
    AddSlider(G1, "FOV Tam.", 10, 500, 100, function(v) _G.FOVSize = v end)
    AddSlider(G1, "Suavidade", 1, 10, 5, function(v) _G.Smooth = v/10 end)

    -- TAB VISUALS
    local T2 = AddTab("Visuals"); local G2 = CreateGroup(T2, "ESP Settings")
    AddToggle(G2, "ESP Box", function(v) _G.ESP_Box = v end)
    AddToggle(G2, "ESP Name", function(v) _G.ESP_Name = v end)
    AddToggle(G2, "ESP Line", function(v) _G.ESP_Line = v end)
    AddToggle(G2, "ESP Dist", function(v) _G.ESP_Dist = v end)
    AddToggle(G2, "ESP ADM", function(v) _G.ESP_ADM = v end)

    -- TAB EXPLOITS
    local T3 = AddTab("Exploits"); local GE = CreateGroup(T3, "Puxar Itens")
    AddButton(GE, "Puxar AK Trovoa", function() 
        for _, o in pairs(game:GetDescendants()) do if o:IsA("Tool") and o.Name:find("AK") then o:Clone().Parent = Player.Backpack end end 
    end)
    AddButton(GE, "Puxar Tudo do Mapa", function()
        for _, obj in pairs(game:GetDescendants()) do if obj:IsA("Tool") then obj:Clone().Parent = Player.Backpack end end
    end)
    AddButton(GE, "Limpar Mochila", function()
        for _, tool in pairs(Player.Backpack:GetChildren()) do tool:Destroy() end
    end)

    -- TAB RANGE
    local T4 = AddTab("Range"); local GR = CreateGroup(T4, "Movimentação")
    AddToggle(GR, "Ativar Fly (Câmera)", function(v) _G.Fly = v end)
    AddSlider(GR, "Velocidade Speed", 16, 300, 16, function(v) _G.Speed = v end)
    AddToggle(GR, "GodMode (AutoHeal)", function(v) _G.GodMode = v end)

    -- TAB RAGE (EXATAMENTE COMO PEDIDO)
    local T_Rage = AddTab("Rage"); local G_R = CreateGroup(T_Rage, "BYPASS ANTBAN")
    AddToggle(G_R, "Bypass Anti-Kick", function(v) 
        _G.AntiKick = v
        if v then
            local mt = getrawmetatable(game); setreadonly(mt, false); local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if getnamecallmethod():lower() == "kick" then return nil end
                return old(self, ...)
            end); setreadonly(mt, true)
        end
    end)

    -- [ LOOP DE FUNÇÕES ] --
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = _G.ShowFOV; FOVCircle.Radius = _G.FOVSize; FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = _G.Speed
            if _G.GodMode then Player.Character.Humanoid.Health = 100 end
            if _G.Fly and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * (_G.Speed * 2.2)
            end
        end

        if _G.Aimbot then
            local target, dist = nil, _G.FOVSize
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local p, screen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if screen then
                        local m = (Vector2.new(p.X, p.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if m < dist then dist = m; target = v end
                    end
                end
            end
            if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position), _G.Smooth) end
        end
    end)

    -- Controles do Menu
    local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1,-35, 0, 5); Close.Text = "−"; Close.TextColor3 = BRANCO; Close.BackgroundTransparency = 1; Close.TextSize = 25
    local Open = Instance.new("ImageButton", ScreenGui); Open.Size = UDim2.new(0, 45, 0, 45); Open.Position = UDim2.new(0.05, 0, 0.2, 0); Open.BackgroundColor3 = Color3.fromRGB(10,10,10); Open.Image = "rbxassetid://6031763426"; Open.ImageColor3 = ROXO; Open.Visible = false; Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Open).Color = ROXO
    Close.MouseButton1Click:Connect(function() Main.Visible = false; Open.Visible = true end)
    Open.MouseButton1Click:Connect(function() Main.Visible = true; Open.Visible = false end)

    Pages["Aimbot"].Visible = true; TS:Create(TabBtns["Aimbot"], TweenInfo.new(0.2), {TextColor3 = ROXO}):Play()
end

-- [[ TELA DE LOGIN PREMIUM ]] --
local function IniciarLogin()
    local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "TH_Login_Premium"; sg.IgnoreGuiInset = true
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(1, 0, 1, 0); main.BackgroundColor3 = Color3.fromRGB(10,10,10)
    
    local container = Instance.new("Frame", main); container.Size = UDim2.new(0, 800, 0, 200); container.Position = UDim2.new(0.5, -400, 0.4, -100); container.BackgroundTransparency = 1
    local thLabel = Instance.new("TextLabel", container); thLabel.Size = UDim2.new(1, 0, 0, 80); thLabel.RichText = true; thLabel.Text = '<font color="rgb(255,255,255)">TH</font> <font color="rgb(0,255,100)">SYSTEM</font>'; thLabel.Font = "GothamBold"; thLabel.TextSize = 75; thLabel.BackgroundTransparency = 1
    local hydraLabel = Instance.new("TextLabel", container); hydraLabel.Size = UDim2.new(1, 0, 0, 40); hydraLabel.Position = UDim2.new(0, 0, 0, 85); hydraLabel.Text = "& HYDRA V1"; hydraLabel.Font = "GothamBold"; hydraLabel.TextSize = 35; hydraLabel.TextColor3 = ROXO; hydraLabel.BackgroundTransparency = 1

    local barBg = Instance.new("Frame", main); barBg.Size = UDim2.new(0.4, 0, 0, 4); barBg.Position = UDim2.new(0.3, 0, 0.7, 0); barBg.BackgroundColor3 = Color3.fromRGB(30,30,30); Instance.new("UICorner", barBg)
    local barFill = Instance.new("Frame", barBg); barFill.Size = UDim2.new(0, 0, 1, 0); barFill.BackgroundColor3 = ROXO; Instance.new("UICorner", barFill)
    local status = Instance.new("TextLabel", main); status.Size = UDim2.new(1, 0, 0, 50); status.Position = UDim2.new(0, 0, 0.75, 0); status.Text = "VERIFICANDO WHITELIST: 0%"; status.Font = "Gotham"; status.TextColor3 = BRANCO; status.TextSize = 14; status.BackgroundTransparency = 1

    task.spawn(function()
        local authorized = false
        local success, result = pcall(function() return game:HttpGet(URL) end)
        for i = 1, 100 do
            barFill.Size = UDim2.new(i/100, 0, 1, 0); status.Text = "VERIFICANDO WHITELIST: " .. i .. "%"
            if i == 50 and success then
                local data = HttpService:JSONDecode(result)
                for k, v in pairs(data) do
                    local tNick = type(v) == "table" and (v.nick or k) or k
                    if string.lower(tostring(tNick)) == string.lower(Nick) and v.status == "ativo" then authorized = true end
                end
            end
            task.wait(0.02)
        end
        if authorized then status.Text = "ACESSO PERMITIDO!"; task.wait(0.5); sg:Destroy(); AbrirMenuTH()
        else status.Text = "ERRO: NICK NÃO ENCONTRADO!"; barFill.BackgroundColor3 = Color3.new(1,0,0); task.wait(3); sg:Destroy() end
    end)
end

IniciarLogin()
