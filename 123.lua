--[[
  UNIVERSAL ESP Script (Lua/Luau)
  (โค้ดนี้คือโค้ดที่คุณต้องการอัปโหลดขึ้น GitHub)
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESP_TOGGLE = true 
local ESP_COLOR = Color3.fromRGB(0, 255, 255)
local ESP_DEPTH = Enum.DepthMode.AlwaysOnTop

local function createHighlight(instance)
    if instance:FindFirstChild("ESPHighlight") then
        return instance:FindFirstChild("ESPHighlight")
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = instance
    highlight.FillTransparency = 0.6
    highlight.DepthMode = ESP_DEPTH
    highlight.Parent = instance
    return highlight
end

local function updateESP()
    if not ESP_TOGGLE or not LocalPlayer then
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            pcall(function()
                player.Character:FindFirstChild("ESPHighlight"):Destroy()
            end)
            continue
        end

        local Character = player.Character

        if Character and Character.Parent then
            local success, humanoid = pcall(function()
                return Character:FindFirstChildOfClass("Humanoid")
            end)

            if success and humanoid and humanoid.Health > 0 then
                local PartToAdorn = Character:FindFirstChild("HumanoidRootPart") or Character

                if PartToAdorn then
                    createHighlight(PartToAdorn)
                end
            else
                pcall(function()
                    Character:FindFirstChild("ESPHighlight"):Destroy()
                end)
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- ทำให้สามารถควบคุมได้ผ่าน Console/Executor Command
function toggleESP()
    ESP_TOGGLE = not ESP_TOGGLE
    print("[ESP Toggle]: ESP ตอนนี้สถานะ: " .. tostring(ESP_TOGGLE))
    
    if not ESP_TOGGLE then
        for _, player in pairs(Players:GetPlayers()) do
            pcall(function()
                player.Character:FindFirstChild("ESPHighlight"):Destroy()
            end)
        end
    end
end

print("✅ ESP Script Loaded Successfully!")
