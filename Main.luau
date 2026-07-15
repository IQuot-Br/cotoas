-- Garante que o script roda apenas no cliente (jogador)
if not game:IsLoaded() then game.Loaded:Wait() end

-- Criando a Interface (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local FlyButton = Instance.new("TextButton")

-- Propriedades do Painel Principal
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Permite arrastar o painel pela tela

-- Título do Painel
TextLabel.Parent = MainFrame
TextLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Meu Script Luau"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16

-- Botão de Voar
FlyButton.Parent = MainFrame
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
FlyButton.Position = UDim2.new(0.1, 0, 0.4, 0)
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.Text = "Ativar Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 18

-- Sistema de Voo (Fly)
local flying = false
local speed = 50
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyButton.Text = "Desativar Fly"
        FlyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Reinicia referências ao corpo
        character = player.Character
        local torso = character:FindFirstChild("HumanoidRootPart")
        if not torso then return end
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.Parent = torso
        
        -- Loop de movimento baseado na câmera
        task.spawn(function()
            local camera = workspace.CurrentCamera
            while flying and torso and torso.Parent do
                task.wait()
                local moveDirection = Vector3.new(0,0,0)
                
                -- Detecta inputs básicos de movimento da câmera
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                
                bv.velocity = moveDirection * speed
            end
            if bv then bv:Destroy() end
        end)
    else
        FlyButton.Text = "Ativar Fly"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)
