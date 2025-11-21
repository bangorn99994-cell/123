local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. สร้างหน้าต่าง (คุณสามารถเปลี่ยนชื่อตรงนี้เป็น F และ By A ได้เลยครับ)
local Window = Rayfield:CreateWindow({
   Name = "ESP Panel | มองทะลุ", -- เปลี่ยนตรงนี้เป็น "F" ได้
   LoadingTitle = "Loading ESP...",
   LoadingSubtitle = "By Gemini", -- เปลี่ยนตรงนี้เป็น "By A" ได้
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "ESP_Config" -- เปลี่ยนตรงนี้เป็น "free Fire" ได้
   },
   KeySystem = false,
})

-- 2. สร้างแท็บ
local VisualTab = Window:CreateTab("Visuals (ภาพ)", 4483362458)

-- 3. ระบบ ESP (Logic)
local ESP_Enabled = false
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function AddHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- สีตัว (แดง)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- สีขอบ (ขาว)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- คำสั่งที่ทำให้มองทะลุกำแพง
        highlight.Parent = player.Character
    end
end

local function RemoveHighlight(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") then
        player.Character.ESPHighlight:Destroy()
    end
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if ESP_Enabled then
                AddHighlight(player)
            else
                RemoveHighlight(player)
            end
        end
    end
end

-- อัปเดตตลอดเวลาเมื่อมีคนตาย/เกิดใหม่
RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        UpdateESP()
    end
end)

-- 4. สร้างปุ่ม Toggle ในเมนู
VisualTab:CreateToggle({
   Name = "เปิด/ปิด มองทะลุ (ESP Player)",
   CurrentValue = false,
   Flag = "ESP_Toggle", 
   Callback = function(Value)
       ESP_Enabled = Value
       
       if not Value then
           -- ถ้าปิด ให้ลบ ESP ออกทันที
           for _, player in pairs(Players:GetPlayers()) do
               RemoveHighlight(player)
           end
       end
   end,
})

-- แจ้งเตือนเมื่อโหลดเสร็จ
Rayfield:Notify({
   Title = "พร้อมใช้งาน",
   Content = "ระบบ ESP โหลดเสร็จสิ้น",
   Duration = 5,
   Image = 4483362458,
})
