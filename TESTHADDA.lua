local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local P = Players.LocalPlayer

local function f(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    return o
end

-- MAIN GUI
local Gui = f("ScreenGui", {
    Parent = P:WaitForChild("PlayerGui"),
    Name = "Hadda_TP_SCRIPT"  -- Cambié el nombre aquí
})

local Frame = f("Frame", {
    Parent = Gui,
    Size = UDim2.new(0,250,0,140),
    Position = UDim2.new(0.5,-125,0.3,0),
    BackgroundColor3 = Color3.fromRGB(60,20,20),
    BackgroundTransparency = 0.3,
    Active = true,
    Draggable = true
})
f("UICorner", { Parent = Frame, CornerRadius = UDim.new(0,10) })

-- HEADER
local Header = f("TextLabel", {
    Parent = Frame,
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1,
    Text = "Hadda TP Script",  -- Cambié el texto aquí
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255)
})

-- CLOSE BUTTON
local Close = f("TextButton", {
    Parent = Frame,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(1,-34,0,6),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
    BorderSizePixel = 0,
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(230,230,230)
})
f("UICorner", { Parent = Close, CornerRadius = UDim.new(0,6) })
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- SET SPAWN BUTTON
local SetSpawnBtn = f("TextButton", {
    Parent = Frame,
    Size = UDim2.new(0,220,0,40),
    Position = UDim2.new(0,15,0,50),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
    BorderSizePixel = 0,
    Text = "Set Spawn",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255)
})
f("UICorner", { Parent = SetSpawnBtn, CornerRadius = UDim.new(0,8) })

-- TELEPORT BUTTON
local TeleportBtn = f("TextButton", {
    Parent = Frame,
    Size = UDim2.new(0,220,0,40),
    Position = UDim2.new(0,15,0,95),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
    BorderSizePixel = 0,
    Text = "Teleport",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255)
})
f("UICorner", { Parent = TeleportBtn, CornerRadius = UDim.new(0,8) })

-- Variables
local savedPos = nil

-- SET SPAWN BEHAVIOR
SetSpawnBtn.MouseButton1Click:Connect(function()
    local char = P.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        SetSpawnBtn.Text = "Spawn Set!"
        task.wait(1)
        SetSpawnBtn.Text = "Set Spawn"
    end
end)

-- TELEPORT BEHAVIOR (using Flying Carpet - FASTER)
TeleportBtn.MouseButton1Click:Connect(function()
    if not savedPos then
        TeleportBtn.Text = "Set spawn first!"
        task.wait(1)
        TeleportBtn.Text = "Teleport"
        return
    end
    
    -- Find Flying Carpet in backpack
    local backpack = P:WaitForChild("Backpack")
    local flyingCarpet = backpack:FindFirstChild("Flying Carpet")
    
    if not flyingCarpet then
        TeleportBtn.Text = "No Flying Carpet!"
        task.wait(1)
        TeleportBtn.Text = "Teleport"
        return
    end
    
    local char = P.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        local root = char.HumanoidRootPart
        
        -- Equip the Flying Carpet
        humanoid:EquipTool(flyingCarpet)
        
        -- Wait for it to equip
        task.wait(0.05)
        
        -- Find the carpet part in the character
        local carpetPart = char:FindFirstChild("Handle") or char:FindFirstChild("Carpet")
        
        if carpetPart then
            -- Instantly teleport the carpet to destination
            carpetPart.CFrame = CFrame.new(savedPos + Vector3.new(0, 3, 0))
        end
        
        -- Teleport player to saved position instantly
        root.CFrame = CFrame.new(savedPos)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.Velocity = Vector3.new(0, 0, 0)
        
        -- Wait 2 seconds then unequip the carpet
        task.wait(2)
        humanoid:UnequipTools()
        
        TeleportBtn.Text = "Teleported!"
        task.wait(1)
        TeleportBtn.Text = "Teleport"
    end
end)
