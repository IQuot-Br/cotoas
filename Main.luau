-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Cria a janela principal do Script
local Window = Rayfield:CreateWindow({
   Name = "Die of Death Hub",
   LoadingTitle = "Carregando Utilitários para DoD...",
   LoadingSubtitle = "por Seu Nome",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DieOfDeathConfig",
      FileName = "DoDHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite",
      RememberJoins = true 
   },
   KeySystem = false,
})

-- Variáveis de Controle
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local EspEnabled = false
local InfStamina = false

-- Loop do ESP para destacar Jogadores e Assassinos
task.spawn(function()
    while task.wait(1) do
        if EspEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- Procura ou cria o marcador visual (Highlight)
                    local highlight = player.Character:FindFirstChild("DoD_ESP")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "DoD_ESP"
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = player.Character
                    end
                    
                    -- Se o jogador tiver atributos de Killer ou ferramentas de assassino, fica vermelho
                    -- Nota: Ajustável de acordo com as tags internas do jogo
                    if player:FindFirstChild("Killer") or player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho para o Assassino
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 100) -- Verde para Sobreviventes
                    end
                end
            end
        else
            -- Limpa o ESP se for desligado
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("DoD_ESP") then
                    player.Character.DoD_ESP:Destroy()
                end
            end
        end
    end
end)

-- Loop para travar a Stamina (Modificável com base na mecânica do jogo)
task.spawn(function()
    while task.wait() do
        if InfStamina then
            local stats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("Data")
            if stats and stats:FindFirstChild("Stamina") then
                stats.Stamina.Value = 100
            end
        end
    end
end)

-- ----------------------------------------------------
-- ABA 1: VISUAIS (Wallhack para Sobrevivência)
-- ----------------------------------------------------
local VisualsTab = Window:CreateTab("Visuais", 4483362458)
local VisualsSection = VisualsTab:CreateSection("Rastreamento")

VisualsTab:CreateToggle({
   Name = "Ativar Wallhack (ESP)",
   CurrentValue = false,
   Flag = "DoDEspToggle",
   Callback = function(Value)
       EspEnabled = Value
   end,
})

-- ----------------------------------------------------
-- ABA 2: MOVIMENTAÇÃO (Escapar do Assassino)
-- ----------------------------------------------------
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local MoveSection = MovementTab:CreateSection("Melhorias Físicas")

-- Altera a velocidade para correr mais rápido que o assassino
MovementTab:CreateSlider({
   Name = "Velocidade de Corrida",
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 16,
   Flag = "DoDSpeedSlider", 
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Força o pulo infinito para alcançar locais altos
local infJump = false
MovementTab:CreateToggle({
   Name = "Pulo Infinito (Acessar Telhados)",
   CurrentValue = false,
   Flag = "DoDJumpToggle",
   Callback = function(Value)
       infJump = Value
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
               LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
           end
       end)
   end,
})

-- Notificação Inicial
Rayfield:Notify({
   Name = "Die of Death Hub",
   Content = "Script carregado! Use com sabedoria para escapar do Assassino.",
   Duration = 5,
   Image = 4483362458,
})
