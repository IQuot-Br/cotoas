-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Cria a janela principal do Script
local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Hub",
   LoadingTitle = "Injetando Utilitários MM2...",
   LoadingSubtitle = "por Seu Nome",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MM2Config",
      FileName = "MM2Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite",
      RememberJoins = true 
   },
   KeySystem = false,
})

-- Variáveis Globais de Controle
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local EspEnabled = false
local AutoFarmCoins = false

-- Função Auxiliar para Identificar Funções/Cargos no MM2
local function getRoleColor(player)
    -- Verifica pelas ferramentas na mochila ou nas mãos (Faca = Assassino, Arma = Sheriff)
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if (backpack and backpack:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then
        return Color3.fromRGB(255, 0, 0) -- Vermelho para Murderer
    elseif (backpack and backpack:FindFirstChild("Gun")) or (character and character:FindFirstChild("Gun")) then
        return Color3.fromRGB(0, 0, 255) -- Azul para Sheriff
    end
    return Color3.fromRGB(0, 255, 100) -- Verde para Inocente
end

-- Loop do ESP (Wallhack Dinâmico)
task.spawn(function()
    while task.wait(1) do
        if EspEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local highlight = player.Character:FindFirstChild("MM2_ESP")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "MM2_ESP"
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.4
                        highlight.Parent = player.Character
                    end
                    -- Atualiza a cor em tempo real baseada no cargo
                    highlight.FillColor = getRoleColor(player)
                end
            end
        else
            -- Limpa o ESP se for desligado
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("MM2_ESP") then
                    player.Character.MM2_ESP:Destroy()
                end
            end
        end
    end
end)

-- Loop do Auto Farm de Moedas (Teleporta para moedas próximas)
task.spawn(function()
    while task.wait(0.3) do
        if AutoFarmCoins and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Procura o contêiner de moedas do mapa (varia conforme a versão do mapa no MM2)
            local coinContainer = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in pairs(coinContainer:GetChildren()) do
                    if coin:IsA("BasePart") or coin:FindFirstChild("TouchInterest") then
                        -- Teleporta o jogador direto para a moeda
                        LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.1) -- Pequena pausa para evitar travamento ou kick por velocidade
                        break
                    end
                end
            end
        end
    end
end)

-- ----------------------------------------------------
-- ABA 1: VISUAIS (Saber quem são os alvos)
-- ----------------------------------------------------
local VisualsTab = Window:CreateTab("Visuais", 4483362458)
local VisualsSection = VisualsTab:CreateSection("Rastreamento de Funções")

VisualsTab:CreateToggle({
   Name = "Ativar Wallhack (ESP)",
   CurrentValue = false,
   Flag = "MM2EspToggle",
   Callback = function(Value)
       EspEnabled = Value
   end,
})

-- ----------------------------------------------------
-- ABA 2: FARM / UTILITÁRIOS
-- ----------------------------------------------------
local FarmTab = Window:CreateTab("Farm & Utils", 4483362458)
local FarmSection = FarmTab:CreateSection("Automação")

FarmTab:CreateToggle({
   Name = "Auto Coletar Moedas (Auto Farm)",
   CurrentValue = false,
   Flag = "MM2FarmToggle",
   Callback = function(Value)
       AutoFarmCoins = Value
   end,
})

FarmTab:CreateButton({
   Name = "Teleportar para a Arma Cadastrada",
   Callback = function()
       -- Se o Sheriff morrer, a arma cai no chão como um item coletável
       local droppedGun = Workspace:FindFirstChild("GunDrop")
       if droppedGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = droppedGun.CFrame
       else
           Rayfield:Notify({
               Name = "Aviso",
               Content = "Nenhuma arma caída no chão no momento.",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

-- ----------------------------------------------------
-- ABA 3: MOVIMENTAÇÃO
-- ----------------------------------------------------
local MoveTab = Window:CreateTab("Movimento", 4483362458)
local MoveSection = MoveTab:CreateSection("Melhorias Físicas")

MoveTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 16,
   Flag = "MM2SpeedSlider", 
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

-- Notificação Inicial
Rayfield:Notify({
   Name = "MM2 Script Ativo",
   Content = "Vermelho = Assassino | Azul = Sheriff | Verde = Inocente",
   Duration = 6,
   Image = 4483362458,
})
