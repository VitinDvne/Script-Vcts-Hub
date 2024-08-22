-- Vict Hub - Blox Fruits Complete Script

-- Criação da interface
local VictHubUI = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local farmButton = Instance.new("TextButton")
local questButton = Instance.new("TextButton")
local titleLabel = Instance.new("TextLabel")
local afkLabel = Instance.new("TextLabel")

-- Configuração da UI
VictHubUI.Name = "VictHubUI"
VictHubUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
VictHubUI.ResetOnSpawn = false

mainFrame.Name = "MainFrame"
mainFrame.Parent = VictHubUI
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BorderSizePixel = 3

titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleLabel.Size = UDim2.new(0, 300, 0, 50)
titleLabel.Text = "Vict Hub - Blox Fruits"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

farmButton.Name = "FarmButton"
farmButton.Parent = mainFrame
farmButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
farmButton.Size = UDim2.new(0, 200, 0, 50)
farmButton.Position = UDim2.new(0.5, -100, 0, 70)
farmButton.Text = "Toggle Auto-Farm"
farmButton.Font = Enum.Font.SourceSansBold
farmButton.TextSize = 20
farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)

questButton.Name = "QuestButton"
questButton.Parent = mainFrame
questButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
questButton.Size = UDim2.new(0, 200, 0, 50)
questButton.Position = UDim2.new(0.5, -100, 0, 140)
questButton.Text = "Toggle Auto-Quest"
questButton.Font = Enum.Font.SourceSansBold
questButton.TextSize = 20
questButton.TextColor3 = Color3.fromRGB(255, 255, 255)

afkLabel.Name = "AFKLabel"
afkLabel.Parent = mainFrame
afkLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
afkLabel.Size = UDim2.new(0, 300, 0, 40)
afkLabel.Position = UDim2.new(0, 0, 1, -50)
afkLabel.Text = "Anti-AFK: Activated"
afkLabel.Font = Enum.Font.SourceSans
afkLabel.TextSize = 18
afkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Variáveis de controle
local autoFarmEnabled = false
local autoQuestEnabled = false
local antiAfkEnabled = true

-- Função Anti-AFK
if antiAfkEnabled then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Função Auto-Farm
function AutoFarm()
    while autoFarmEnabled do
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        -- Identifica o inimigo mais próximo
        local enemies = game.Workspace.Enemies:GetChildren()
        local closestEnemy = nil
        local minDistance = math.huge
        
        for _, enemy in ipairs(enemies) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (enemy.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                if distance < minDistance then
                    closestEnemy = enemy
                    minDistance = distance
                end
            end
        end

        -- Move-se para o inimigo e ataca
        if closestEnemy then
            humanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame
            wait(0.5)
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
        end

        wait(1)
    end
end

-- Função Auto-Quest
function AutoQuest()
    while autoQuestEnabled do
        local player = game.Players.LocalPlayer
        local questGiver = game.Workspace:FindFirstChild("QuestGiver")

        if questGiver then
            player.Character.HumanoidRootPart.CFrame = questGiver.HumanoidRootPart.CFrame
            wait(1)
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("QuestAccept")
        end
        wait(10)
    end
end

-- Função para ligar/desligar o Auto-Farm
farmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        farmButton.Text = "Auto-Farm: ON"
        spawn(AutoFarm)
    else
        farmButton.Text = "Auto-Farm: OFF"
    end
end)

-- Função para ligar/desligar o Auto-Quest
questButton.MouseButton1Click:Connect(function()
    autoQuestEnabled = not autoQuestEnabled
    if autoQuestEnabled then
        questButton.Text = "Auto-Quest: ON"
        spawn(AutoQuest)
    else
        questButton.Text = "Auto-Quest: OFF"
    end
end)

-- Anti-Ban Práticas Gerais:
-- 1. Limite o uso de funções automáticas a intervalos irregulares (use 'wait(math.random(min, max))' em vez de 'wait()' para simular ação humana).
-- 2. Não execute o script de forma contínua por longos períodos sem pausas.
-- 3. Evite comportamento excessivamente óbvio (ex: movimentos repetitivos e previsíveis).

