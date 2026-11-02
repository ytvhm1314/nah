--[[
    ========================================================================
    HarvardUI - Standalone Roblox UI Framework
    Extracted & Reconstructed from Harvard Hub (HK.luau)
    Aesthetic: Crimson / Dark Glass Acrylic with Lucide Icons & Lerp Physics
    ========================================================================
--]]

local HarvardUI = {}
HarvardUI.__index = HarvardUI

-- Services
local cloneref = cloneref or function(svc) return svc end
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextService = cloneref(game:GetService("TextService"))
local GuiService = cloneref(game:GetService("GuiService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

-- GUI Root resolver
local function getGuiParent()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local gui = Instance.new("Folder")
        syn.protect_gui(gui)
        gui.Parent = CoreGui
        return gui
    elseif pcall(function() return CoreGui.Name end) then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Default Theme (Crimson Dark Palette)
local Theme = {
    TextPrimary    = Color3.fromHex("f0f0f4"),
    TextSub        = Color3.fromHex("9898a2"),
    TextMuted      = Color3.fromHex("686872"),
    TextOnAccent   = Color3.fromHex("000000"),
    StatusBad      = Color3.fromHex("d50000"),
    StatusGood     = Color3.fromHex("2fbf71"),
    SurfaceHeader  = Color3.fromHex("18181c"),
    SurfaceElement = Color3.fromHex("26262c"),
    SurfaceHover   = Color3.fromHex("303038"),
    SurfaceField   = Color3.fromHex("1c1c21"),
    SurfaceSection = Color3.fromHex("1e1e24"),
    SurfaceWell    = Color3.fromHex("121216"),
    SurfaceChip    = Color3.fromHex("0c0c0f"),
    Hairline       = Color3.fromHex("323338"),
    BodyTop        = Color3.fromHex("2a2a2f"),
    BodyMid        = Color3.fromHex("1a1a1e"),
    BodyBot        = Color3.fromHex("101013"),
    BodyTopA       = 0.05,
    BodyMidA       = 0.13,
    BodyBotA       = 0.42,
    SweepSpeed     = 0.22,
    AccentA        = Color3.fromHex("a30000"),
    AccentMid      = Color3.fromHex("f43120"),
    AccentB        = Color3.fromHex("d50000"),
    AccentDark     = Color3.fromHex("7a0000"),
    RadiusSm       = 5,
    RadiusMd       = 6,
    RadiusLg       = 8,
    GapSm          = 6,
    GapMd          = 8,
    GapLg          = 12,
    GapXl          = 14,
    RowH           = 34,
    HeaderH        = 40
}

HarvardUI.Theme = Theme

-- Fonts
local FontFamilies = {
    sans = "rbxasset://fonts/families/Montserrat.json",
    mono = "rbxasset://fonts/families/RobotoMono.json"
}

local FontFallback = {
    [Enum.FontWeight.Regular]  = Enum.Font.Gotham,
    [Enum.FontWeight.Medium]   = Enum.Font.GothamMedium,
    [Enum.FontWeight.SemiBold] = Enum.Font.GothamBold,
    [Enum.FontWeight.Bold]     = Enum.Font.GothamBold
}

local function setFont(object, family, weight)
    weight = weight or Enum.FontWeight.Regular
    local ok = pcall(function()
        object.FontFace = Font.new(FontFamilies[family] or FontFamilies.sans, weight)
    end)
    if not ok then
        object.Font = FontFallback[weight] or Enum.Font.Gotham
    end
end

-- Lucide Icon Catalog (asset IDs from Harvard Hub)
local Icons = {
    plus                 = 10734924532,
    x                    = 10747384394,
    pin                  = 10734922324,
    info                 = 10723415903,
    check                = 10709790644,
    ["chevron-down"]     = 10709790948,
    ["chevron-up"]       = 10709791523,
    ["chevron-left"]     = 10709791281,
    ["chevron-right"]    = 10709791437,
    crown                = 10709818626,
    ["trash-2"]          = 10747362241,
    swords               = 10734975692,
    eye                  = 10723346959,
    bell                 = 10709775704,
    coins                = 10709811110,
    users                = 10747373426,
    palette              = 10734910430,
    map                  = 10734886202,
    camera               = 10709789686,
    bug                  = 10709782845,
    search               = 10734943674,
    ["alert-triangle"]   = 10709753149,
    shield               = 10734951847,
    ["sliders-horizontal"] = 10734963191,
    save                 = 10734941499,
    ["bar-chart-3"]      = 10709770431
}

HarvardUI.Icons = Icons

-- Typography Style Specs
local TextSpecs = {
    windowTitle = { family = "sans", weight = Enum.FontWeight.SemiBold, size = 15, color = "TextPrimary" },
    windowChip  = { family = "sans", weight = Enum.FontWeight.Bold, size = 15, color = "TextPrimary" },
    rowLabel    = { family = "sans", weight = Enum.FontWeight.Medium, size = 13, color = "TextPrimary" },
    rowButton   = { family = "sans", weight = Enum.FontWeight.SemiBold, size = 13, color = "TextOnAccent" },
    rowEntry    = { family = "sans", weight = Enum.FontWeight.SemiBold, size = 13, color = "TextPrimary" },
    rowStat     = { family = "sans", weight = Enum.FontWeight.Medium, size = 14, color = "TextPrimary" },
    captionKey  = { family = "sans", weight = Enum.FontWeight.Medium, size = 12, color = "TextSub" },
    captionSub  = { family = "sans", weight = Enum.FontWeight.Regular, size = 10, color = "TextMuted" },
    captionStat = { family = "sans", weight = Enum.FontWeight.Bold, size = 12, color = "TextSub" },
    monoValue   = { family = "mono", weight = Enum.FontWeight.Medium, size = 11, color = "TextOnAccent" },
    monoMeta    = { family = "mono", weight = Enum.FontWeight.Medium, size = 10, color = "TextMuted" },
    monoStat    = { family = "mono", weight = Enum.FontWeight.Medium, size = 13, color = "TextSub" }
}

-- Basic UI Primitives
local function corner(parent, radius)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, radius)
    uic.Parent = parent
    return uic
end

local function stroke(parent, color, thickness)
    local uis = Instance.new("UIStroke")
    uis.Color = color or Theme.Hairline
    uis.Thickness = thickness or 1
    uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uis.Parent = parent
    return uis
end

local function pad(parent, top, right, bottom, left)
    local uip = Instance.new("UIPadding")
    uip.PaddingTop = UDim.new(0, top or 0)
    uip.PaddingRight = UDim.new(0, right or 0)
    uip.PaddingBottom = UDim.new(0, bottom or 0)
    uip.PaddingLeft = UDim.new(0, left or 0)
    uip.Parent = parent
    return uip
end

local function vlist(parent, gap, sortOrder)
    local uil = Instance.new("UIListLayout")
    uil.FillDirection = Enum.FillDirection.Vertical
    uil.Padding = UDim.new(0, gap or Theme.GapSm)
    uil.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    uil.Parent = parent
    return uil
end

local function hlist(parent, gap)
    local uil = Instance.new("UIListLayout")
    uil.FillDirection = Enum.FillDirection.Horizontal
    uil.VerticalAlignment = Enum.VerticalAlignment.Center
    uil.Padding = UDim.new(0, gap or Theme.GapMd)
    uil.SortOrder = Enum.SortOrder.LayoutOrder
    uil.Parent = parent
    return uil
end

local function flexFill(element, offset, scaleX, scaleY)
    if not offset then return false end
    element.Size = UDim2.new(1, -offset, scaleX or 1, scaleY or 0)
    return true
end

local function label(parent, text, style, layoutOrder)
    local spec = TextSpecs[style] or TextSpecs.rowLabel
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Text = text or ""
    lbl.TextColor3 = Theme[spec.color] or Theme.TextPrimary
    lbl.TextSize = spec.size
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.LayoutOrder = layoutOrder or 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    setFont(lbl, spec.family, spec.weight)
    lbl.Parent = parent
    return lbl
end

local function caption(parent, text, layoutOrder)
    local lbl = label(parent, text, "captionSub", layoutOrder)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.Size = UDim2.new(1, 0, 0, 0)
    lbl.TextWrapped = true
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    return lbl
end

local function accentGradient(parent, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentA),
        ColorSequenceKeypoint.new(0.53, Theme.AccentMid),
        ColorSequenceKeypoint.new(1, Theme.AccentB)
    })
    grad.Rotation = rotation or 0
    grad.Parent = parent
    return grad
end

local activeSweeps = {}
local sweepConnection = nil

local function accentSweep(parent)
    parent.ClipsDescendants = true
    local sweep = Instance.new("Frame")
    sweep.Name = "Sweep"
    sweep.BackgroundColor3 = Color3.new(1, 1, 1)
    sweep.BorderSizePixel = 0
    sweep.Size = UDim2.new(2, 0, 1, 0)
    sweep.Position = UDim2.new(-1, 0, 0, 0)
    sweep.ZIndex = parent.ZIndex
    sweep.Parent = parent

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentA),
        ColorSequenceKeypoint.new(0.125, Theme.AccentMid),
        ColorSequenceKeypoint.new(0.25, Theme.AccentB),
        ColorSequenceKeypoint.new(0.375, Theme.AccentMid),
        ColorSequenceKeypoint.new(0.5, Theme.AccentA),
        ColorSequenceKeypoint.new(0.625, Theme.AccentMid),
        ColorSequenceKeypoint.new(0.75, Theme.AccentB),
        ColorSequenceKeypoint.new(0.875, Theme.AccentMid),
        ColorSequenceKeypoint.new(1, Theme.AccentA)
    })
    grad.Parent = sweep
    table.insert(activeSweeps, sweep)

    if not sweepConnection then
        sweepConnection = RunService.RenderStepped:Connect(function()
            local offset = (os.clock() * (Theme.SweepSpeed or 0.22)) % 1
            local pos = UDim2.new(offset - 1, 0, 0, 0)
            for i = #activeSweeps, 1, -1 do
                local s = activeSweeps[i]
                if s and s.Parent then
                    s.Position = pos
                else
                    table.remove(activeSweeps, i)
                end
            end
            if #activeSweeps == 0 and sweepConnection then
                sweepConnection:Disconnect()
                sweepConnection = nil
            end
        end)
    end
    return sweep
end

local function bodyGradient(parent)
    parent.BackgroundColor3 = Color3.new(1, 1, 1)
    local grad = Instance.new("UIGradient")
    grad.Rotation = 90
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.BodyTop),
        ColorSequenceKeypoint.new(0.48, Theme.BodyMid),
        ColorSequenceKeypoint.new(1, Theme.BodyBot)
    })
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, Theme.BodyTopA),
        NumberSequenceKeypoint.new(0.48, Theme.BodyMidA),
        NumberSequenceKeypoint.new(1, Theme.BodyBotA)
    })
    grad.Parent = parent
    return grad
end

local function shadow(parent, inset, spread, blur, transparency, cornerRad)
    local sh = Instance.new("ImageLabel")
    sh.Name = "Shadow"
    sh.BackgroundTransparency = 1
    sh.AnchorPoint = Vector2.new(0.5, 0.5)
    sh.Position = UDim2.fromScale(0.5, 0.5)
    sh.Size = UDim2.new(1, 24, 1, 24)
    sh.ZIndex = math.max(1, parent.ZIndex - 1)
    sh.Image = "rbxassetid://1316045217"
    sh.ImageColor3 = Color3.new(0, 0, 0)
    sh.ImageTransparency = transparency or 0.4
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(10, 10, 118, 118)
    sh.Parent = parent
    return sh
end

local function icon(parent, name, size, color, zIndex)
    local img = Instance.new("ImageLabel")
    img.Name = "Icon_" .. tostring(name)
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = "rbxassetid://" .. tostring(Icons[name] or Icons.info)
    img.ImageColor3 = color or Theme.TextSub
    img.ScaleType = Enum.ScaleType.Fit
    img.Size = UDim2.fromOffset(size or 16, size or 16)
    if zIndex then img.ZIndex = zIndex end
    img.Parent = parent
    return img
end

local function chevron(parent)
    local ch = Instance.new("Frame")
    ch.Name = "Chevron"
    ch.BackgroundTransparency = 1
    ch.Size = UDim2.fromOffset(16, 16)
    ch.LayoutOrder = 99
    ch.Parent = parent

    local ic = icon(ch, "chevron-down", 16, Theme.TextSub)
    ic.AnchorPoint, ic.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)

    return {
        frame = ch,
        setOpen = function(isOpen)
            ic.Rotation = isOpen and 180 or 0
            ic.ImageColor3 = isOpen and Theme.AccentMid or Theme.TextSub
        end
    }
end

-- Mouse / Hit testing
local function getPointerPosition(input)
    if input and input.UserInputType == Enum.UserInputType.Touch then
        local inset = GuiService:GetGuiInset()
        return input.Position.X + inset.X, input.Position.Y + inset.Y
    end
    local mouseLoc = UserInputService:GetMouseLocation()
    return mouseLoc.X, mouseLoc.Y
end

local function findWindowAncestor(elem)
    local cur = elem
    while cur and not (cur.GetAttribute and cur:GetAttribute("hlWin")) do
        cur = cur.Parent
    end
    return cur
end

local function getWindowDepth(elem)
    local p = elem.Parent
    return elem.ZIndex * 100000 + (p and table.find(p:GetChildren(), elem) or 0)
end

local function findTopWindowAt(x, y, container)
    local bestDepth, topWin
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible and child:GetAttribute("hlWin") then
            local pos, size = child.AbsolutePosition, child.AbsoluteSize
            if x >= pos.X and y >= pos.Y and x <= pos.X + size.X and y <= pos.Y + size.Y then
                local depth = getWindowDepth(child)
                if not bestDepth or depth > bestDepth then
                    bestDepth, topWin = depth, child
                end
            end
        end
    end
    return topWin
end

local function pressOnTop(elem, input)
    local win = findWindowAncestor(elem)
    if not win or not win.Parent then return true end
    local x, y = getPointerPosition(input)
    local top = findTopWindowAt(x, y, win.Parent)
    return top == nil or top == win
end

-- Hoverable Row
local function row(parent, text, layoutOrder, height, flexOffset)
    local r = Instance.new("Frame")
    r.Name = "Row"
    r.BackgroundColor3 = Theme.SurfaceElement
    r.BorderSizePixel = 0
    r.Size = UDim2.new(1, 0, 0, height or Theme.RowH)
    r.LayoutOrder = layoutOrder or 1
    r.Parent = parent

    corner(r, Theme.RadiusMd)
    stroke(r, Theme.Hairline, 1)
    pad(r, 0, Theme.GapLg, 0, Theme.GapLg)

    local hl = hlist(r, Theme.GapMd)
    local lbl = label(r, text, "rowLabel", 1)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    flexFill(lbl, flexOffset or 24)

    return r, lbl, hl
end

local function hoverable(elem, clickable)
    local baseColor = elem.BackgroundColor3
    elem.MouseEnter:Connect(function()
        if pressOnTop(elem) then
            TweenService:Create(elem, TweenInfo.new(0.14, Enum.EasingStyle.Quint), {
                BackgroundColor3 = Theme.SurfaceHover
            }):Play()
        end
    end)
    elem.MouseLeave:Connect(function()
        TweenService:Create(elem, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = baseColor
        }):Play()
    end)

    if not clickable then return nil end
    elem.Active = true
    return {
        onClick = function(callback)
            elem.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    if pressOnTop(elem, input) then
                        callback()
                    end
                end
            end)
        end
    }
end

-- Tooltip System
local Tooltip = { frame = nil, label = nil, target = nil, showAt = 0, conn = nil }

local function ensureTip(container)
    if Tooltip.frame then return end
    local tipFrame = Instance.new("Frame")
    tipFrame.Name = "Tooltip"
    tipFrame.BackgroundColor3 = Theme.SurfaceHeader
    tipFrame.BorderSizePixel = 0
    tipFrame.AutomaticSize = Enum.AutomaticSize.XY
    tipFrame.Size = UDim2.fromOffset(0, 0)
    tipFrame.Visible = false
    tipFrame.ZIndex = 500
    tipFrame.Parent = container

    corner(tipFrame, Theme.RadiusSm)
    stroke(tipFrame, Color3.fromHex("4a4a55"), 1)
    pad(tipFrame, 6, 8, 6, 8)

    local tipLabel = Instance.new("TextLabel")
    tipLabel.BackgroundTransparency = 1
    tipLabel.AutomaticSize = Enum.AutomaticSize.XY
    tipLabel.Size = UDim2.fromOffset(0, 0)
    tipLabel.TextWrapped = true
    tipLabel.TextXAlignment = Enum.TextXAlignment.Left
    tipLabel.TextYAlignment = Enum.TextYAlignment.Top
    tipLabel.TextColor3 = Color3.fromHex("e8e8ee")
    tipLabel.TextSize = 11
    tipLabel.ZIndex = 501
    setFont(tipLabel, "sans", Enum.FontWeight.Medium)
    tipLabel.Parent = tipFrame

    local constraint = Instance.new("UISizeConstraint")
    constraint.MaxSize = Vector2.new(240, math.huge)
    constraint.Parent = tipLabel

    Tooltip.frame = tipFrame
    Tooltip.label = tipLabel

    Tooltip.conn = RunService.RenderStepped:Connect(function()
        if not Tooltip.target then return end
        local now = os.clock()
        if not Tooltip.frame.Visible then
            if now < Tooltip.showAt then return end
            Tooltip.frame.Visible = true
            Tooltip.frame.BackgroundTransparency = 1
            Tooltip.label.TextTransparency = 1
            TweenService:Create(Tooltip.frame, TweenInfo.new(0.16), { BackgroundTransparency = 0 }):Play()
            TweenService:Create(Tooltip.label, TweenInfo.new(0.16), { TextTransparency = 0 }):Play()
        end
        local mousePos = UserInputService:GetMouseLocation()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
        local tipW, tipH = Tooltip.frame.AbsoluteSize.X, Tooltip.frame.AbsoluteSize.Y
        local posX = (mousePos.X + 16 + tipW > viewport.X) and (mousePos.X - 16 - tipW) or (mousePos.X + 16)
        local posY = (mousePos.Y + 18 + tipH > viewport.Y) and (mousePos.Y - 12 - tipH) or (mousePos.Y + 18)
        Tooltip.frame.Position = UDim2.fromOffset(posX, posY)
    end)
end

local function hideTip()
    Tooltip.target = nil
    if Tooltip.frame then Tooltip.frame.Visible = false end
end

local function tip(target, text)
    if not text or text == "" then return target end
    target.MouseEnter:Connect(function()
        if not Tooltip.frame then return end
        Tooltip.target = target
        Tooltip.showAt = os.clock() + 0.45
        Tooltip.frame.Visible = false
        Tooltip.label.Text = text
    end)
    target.MouseLeave:Connect(function()
        if Tooltip.target == target then hideTip() end
    end)
    target.Destroying:Connect(function()
        if Tooltip.target == target then hideTip() end
    end)
    return target
end

-- Draggable Windows
local windowZRank = 0
local function raiseWindow(targetWindow)
    windowZRank = windowZRank + 1
    targetWindow:SetAttribute("hlTop", windowZRank)
    targetWindow.ZIndex = 20 + windowZRank
end

local function makeDraggable(handle, targetFrame)
    local dragging = false
    local dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            if pressOnTop(handle, input) then
                dragging = true
                dragStart = input.Position
                startPos = targetFrame.Position
                raiseWindow(targetFrame)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
end

-- CONTROLS IMPLEMENTATION

-- 1. Toggle
local function toggle(parent, text, getter, setter, layoutOrder, tooltipText)
    local rowFrame = row(parent, text, layoutOrder, nil, 46)
    local rowClick = hoverable(rowFrame, true)

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = Theme.SurfaceField
    track.BorderSizePixel = 0
    track.Size = UDim2.fromOffset(38, 20)
    track.LayoutOrder = 2
    track.Parent = rowFrame

    corner(track, 10)
    local trackStroke = stroke(track, Theme.Hairline, 1)
    local grad = accentGradient(track, 0)
    grad.Enabled = false

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.BackgroundColor3 = Theme.TextMuted
    knob.BorderSizePixel = 0
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = UDim2.fromOffset(2, 3)
    knob.ZIndex = 2
    knob.Parent = track
    corner(knob, 7)

    local initialized = false
    local function render()
        local isEnabled = getter() and true or false
        grad.Enabled = isEnabled
        track.BackgroundColor3 = isEnabled and Color3.new(1, 1, 1) or Theme.SurfaceField
        trackStroke.Transparency = isEnabled and 1 or 0
        knob.BackgroundColor3 = isEnabled and Theme.TextOnAccent or Theme.TextMuted
        local targetPos = UDim2.fromOffset(isEnabled and 22 or 2, 3)

        if initialized and knob:IsDescendantOf(game) then
            TweenService:Create(knob, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = targetPos
            }):Play()
        else
            knob.Position = targetPos
        end
        initialized = true
    end

    render()
    rowClick.onClick(function()
        setter(not getter())
        render()
    end)
    tip(rowFrame, tooltipText)

    return { row = rowFrame, render = render }
end

-- 2. Slider
local function slider(parent, text, unit, minVal, maxVal, isFloat, getter, setter, layoutOrder, tooltipText, step)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider"
    sliderFrame.BackgroundColor3 = Theme.SurfaceElement
    sliderFrame.BorderSizePixel = 0
    sliderFrame.AutomaticSize = Enum.AutomaticSize.Y
    sliderFrame.Size = UDim2.new(1, 0, 0, 0)
    sliderFrame.LayoutOrder = layoutOrder or 1
    sliderFrame.Parent = parent

    corner(sliderFrame, Theme.RadiusMd)
    stroke(sliderFrame, Theme.Hairline, 1)
    pad(sliderFrame, 7, 12, 9, 12)
    vlist(sliderFrame, Theme.GapSm)

    local head = Instance.new("Frame")
    head.Name = "Head"
    head.BackgroundTransparency = 1
    head.AutomaticSize = Enum.AutomaticSize.Y
    head.Size = UDim2.new(1, 0, 0, 0)
    head.LayoutOrder = 1
    head.Parent = sliderFrame
    vlist(head, 1)

    local topLabel = label(head, text, "rowLabel", 1)
    topLabel.Size = UDim2.new(1, 0, 0, 18)

    if unit and unit ~= "" then
        local unitLabel = label(head, unit, "captionSub", 2)
        unitLabel.Size = UDim2.new(1, 0, 0, 12)
    end

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = Theme.SurfaceField
    track.BorderSizePixel = 0
    track.Size = UDim2.new(1, 0, 0, 18)
    track.ClipsDescendants = true
    track.LayoutOrder = 2
    track.Active = true
    track.Parent = sliderFrame

    corner(track, Theme.RadiusSm)
    stroke(track, Theme.Hairline, 1)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.fromScale(0, 1)
    fill.Parent = track
    corner(fill, Theme.RadiusSm)
    accentGradient(fill, 0)

    local valLabel = Instance.new("TextLabel")
    valLabel.Name = "Value"
    valLabel.BackgroundTransparency = 1
    valLabel.Size = UDim2.new(1, -8, 1, 0)
    valLabel.Position = UDim2.fromOffset(0, 0)
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.TextColor3 = Theme.TextOnAccent
    valLabel.TextSize = 11
    valLabel.ZIndex = 3
    setFont(valLabel, "mono", Enum.FontWeight.Medium)
    valLabel.Parent = fill

    local function formatVal(num)
        if step and step > 0 then
            return string.format("%.3f", num):gsub("0+$", ""):gsub("%.$", "")
        elseif isFloat then
            return string.format("%.1f", num)
        else
            return tostring(math.floor(num + 0.5))
        end
    end

    local function render()
        local cur = getter()
        local alpha = math.clamp((cur - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.fromScale(alpha, 1)
        valLabel.Text = formatVal(cur)

        if alpha < 0.22 then
            valLabel.Parent = track
            valLabel.TextColor3 = Theme.TextPrimary
        else
            valLabel.Parent = fill
            valLabel.TextColor3 = Theme.TextOnAccent
        end
    end

    render()

    local isDragging = false
    local function applyInput(posX)
        if track.AbsoluteSize.X <= 0 then return end
        local ratio = math.clamp((posX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = minVal + (maxVal - minVal) * ratio
        local finalVal
        if step and step > 0 then
            finalVal = math.floor(raw / step + 0.5) * step
        elseif isFloat then
            finalVal = math.floor(raw * 10 + 0.5) / 10
        else
            finalVal = math.floor(raw + 0.5)
        end
        setter(math.clamp(finalVal, minVal, maxVal))
        render()
    end

    track.InputBegan:Connect(function(input)
        if pressOnTop(track, input) and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = true
            applyInput(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            applyInput(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    tip(sliderFrame, tooltipText)
    return { holder = sliderFrame, render = render }
end

-- 3. Dropdown
local function dropdown(parent, text, items, getter, setter, layoutOrder, tooltipText)
    local dropFrame = Instance.new("Frame")
    dropFrame.Name = "Dropdown"
    dropFrame.BackgroundTransparency = 1
    dropFrame.AutomaticSize = Enum.AutomaticSize.Y
    dropFrame.Size = UDim2.new(1, 0, 0, 0)
    dropFrame.LayoutOrder = layoutOrder or 1
    dropFrame.Parent = parent

    vlist(dropFrame, Theme.GapSm)

    local rowFrame = row(dropFrame, text, 1, nil, 140)
    local rowClick = hoverable(rowFrame, true)

    local chev = chevron(rowFrame)
    local curLabel = label(rowFrame, "", "rowStat", 2)
    curLabel.Size = UDim2.new(0, 110, 1, 0)
    curLabel.TextXAlignment = Enum.TextXAlignment.Right
    curLabel.TextTruncate = Enum.TextTruncate.AtEnd
    curLabel.TextColor3 = Theme.AccentMid

    local menu = Instance.new("ScrollingFrame")
    menu.Name = "Menu"
    menu.BackgroundColor3 = Theme.SurfaceField
    menu.BorderSizePixel = 0
    menu.AutomaticCanvasSize = Enum.AutomaticSize.Y
    menu.CanvasSize = UDim2.new()
    menu.ScrollBarThickness = 4
    menu.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 95)
    menu.Visible = false
    menu.LayoutOrder = 2
    menu.Parent = dropFrame

    corner(menu, Theme.RadiusMd)
    stroke(menu, Theme.Hairline, 1)
    pad(menu, 4, 4, 4, 4)
    vlist(menu, 4)

    local isOpen = false
    local optionButtons = {}

    local function setDropdownOpen(openState)
        isOpen = openState
        chev.setOpen(isOpen)
        local count = #items
        local itemH = 26
        local maxVisible = math.clamp(count, 1, 6)
        menu.Size = UDim2.new(1, 0, 0, maxVisible * (itemH + 4) + 4)
        menu.Visible = isOpen
    end

    local function render()
        local currentVal = getter()
        curLabel.Text = tostring(currentVal)
        for val, btn in pairs(optionButtons) do
            local isSelected = (val == currentVal)
            btn.BackgroundColor3 = isSelected and Theme.SurfaceHover or Theme.SurfaceElement
            btn.TextColor3 = isSelected and Theme.AccentMid or Theme.TextSub
        end
    end

    for idx, item in ipairs(items) do
        local val = type(item) == "table" and item.value or item
        local display = type(item) == "table" and (item.label or item.text or item.value) or tostring(item)

        local btn = Instance.new("TextButton")
        btn.Name = tostring(val)
        btn.BackgroundColor3 = Theme.SurfaceElement
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.Text = display
        btn.TextColor3 = Theme.TextSub
        btn.TextSize = 12
        btn.LayoutOrder = idx
        setFont(btn, "sans", Enum.FontWeight.Medium)
        btn.Parent = menu
        corner(btn, 4)

        btn.MouseButton1Click:Connect(function()
            setter(val)
            setDropdownOpen(false)
            render()
        end)
        optionButtons[val] = btn
    end

    render()
    rowClick.onClick(function()
        setDropdownOpen(not isOpen)
    end)

    tip(rowFrame, tooltipText)
    return { holder = dropFrame, render = render, setOpen = setDropdownOpen }
end

-- 4. Button & ButtonRow
local function button(parent, text, style, callback, layoutOrder, tooltipText)
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder or 1
    setFont(btn, "sans", Enum.FontWeight.SemiBold)
    btn.Parent = parent

    corner(btn, Theme.RadiusMd)

    if style == "accent" or style == "danger" then
        btn.BackgroundTransparency = 1
        btn.TextTransparency = 1

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.BackgroundColor3 = Color3.new(1, 1, 1)
        fill.BorderSizePixel = 0
        fill.Size = UDim2.fromScale(1, 1)
        fill.ZIndex = btn.ZIndex
        fill.Parent = btn
        corner(fill, Theme.RadiusMd)

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentB),
            ColorSequenceKeypoint.new(0.5, Theme.AccentDark),
            ColorSequenceKeypoint.new(1, Theme.AccentB)
        })
        grad.Parent = fill

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.ZIndex = btn.ZIndex + 1
        lbl.Text = btn.Text
        lbl.TextColor3 = Theme.TextOnAccent
        lbl.TextSize = btn.TextSize
        setFont(lbl, "sans", Enum.FontWeight.SemiBold)
        lbl.Parent = btn

        btn:GetPropertyChangedSignal("Text"):Connect(function()
            lbl.Text = btn.Text
        end)
        btn.MouseEnter:Connect(function()
            fill.BackgroundColor3 = Color3.new(0.78, 0.78, 0.78)
        end)
        btn.MouseLeave:Connect(function()
            fill.BackgroundColor3 = Color3.new(1, 1, 1)
        end)
    else
        btn.BackgroundColor3 = Theme.SurfaceElement
        btn.TextColor3 = Theme.TextPrimary
        stroke(btn, Theme.Hairline, 1)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Theme.SurfaceHover
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Theme.SurfaceElement
        end)
    end

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    tip(btn, tooltipText)
    return btn
end

local function buttonRow(parent, layoutOrder)
    local r = Instance.new("Frame")
    r.Name = "ButtonRow"
    r.BackgroundTransparency = 1
    r.Size = UDim2.new(1, 0, 0, 32)
    r.LayoutOrder = layoutOrder or 1
    r.Parent = parent

    local hl = hlist(r, Theme.GapSm)
    local buttons = {}

    local rowApi = { holder = r }
    function rowApi:Add(btnText, style, callback, tooltipText)
        local b = button(r, btnText, style, callback, #buttons + 1, tooltipText)
        b.Size = UDim2.new(0, 0, 1, 0)
        table.insert(buttons, b)

        for _, item in ipairs(buttons) do
            item.Size = UDim2.new(1 / #buttons, -((#buttons - 1) * Theme.GapSm / #buttons), 1, 0)
        end
        return b
    end

    return rowApi
end

-- 5. TextInput
local function textInput(parent, text, getter, setter, layoutOrder, tooltipText, placeholder)
    local rowFrame = row(parent, text, layoutOrder, nil, 160)

    local box = Instance.new("TextBox")
    box.Name = "Input"
    box.BackgroundColor3 = Theme.SurfaceField
    box.BorderSizePixel = 0
    box.Size = UDim2.new(0, 140, 0, 24)
    box.LayoutOrder = 2
    box.Text = tostring(getter() or "")
    box.PlaceholderText = placeholder or "Type here..."
    box.PlaceholderColor3 = Theme.TextMuted
    box.TextColor3 = Theme.TextPrimary
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Center
    setFont(box, "sans", Enum.FontWeight.Medium)
    box.Parent = rowFrame

    corner(box, Theme.RadiusSm)
    stroke(box, Theme.Hairline, 1)

    box.FocusLost:Connect(function()
        setter(box.Text)
    end)

    tip(rowFrame, tooltipText)
    return {
        holder = rowFrame,
        render = function()
            box.Text = tostring(getter() or "")
        end
    }
end

-- 6. Section (Collapsible Accordion)
local function section(parent, text, layoutOrder, tooltipText)
    local sec = Instance.new("Frame")
    sec.Name = "Section"
    sec.BackgroundTransparency = 1
    sec.AutomaticSize = Enum.AutomaticSize.Y
    sec.Size = UDim2.new(1, 0, 0, 0)
    sec.LayoutOrder = layoutOrder or 1
    sec.Parent = parent

    vlist(sec, Theme.GapSm)

    local headFrame, titleLabel = row(sec, text, 1, nil, 24)
    headFrame.BackgroundColor3 = Theme.SurfaceSection
    setFont(titleLabel, "sans", Enum.FontWeight.SemiBold)

    local headClick = hoverable(headFrame, true)
    local chev = chevron(headFrame)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundColor3 = Theme.SurfaceWell
    content.BorderSizePixel = 0
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Visible = false
    content.LayoutOrder = 2
    content.Parent = sec

    corner(content, Theme.RadiusMd)
    vlist(content, Theme.GapSm)
    pad(content, 6, 6, 6, 6)

    local isOpen = false
    local function setOpen(openState)
        isOpen = openState and true or false
        chev.setOpen(isOpen)
        titleLabel.TextColor3 = isOpen and Theme.AccentMid or Theme.TextPrimary
        content.Visible = isOpen
    end

    headClick.onClick(function()
        setOpen(not isOpen)
    end)

    if tooltipText and tooltipText ~= "" then
        local desc = label(content, tooltipText, "captionSub", -1000)
        desc.Name = "Description"
        desc.TextSize = 11
        desc.AutomaticSize = Enum.AutomaticSize.Y
        desc.Size = UDim2.new(1, 0, 0, 0)
        desc.TextWrapped = true
        desc.TextYAlignment = Enum.TextYAlignment.Top
        pad(desc, 2, 4, 2, 4)
    end

    tip(headFrame, tooltipText)

    return {
        holder = sec,
        content = content,
        setOpen = setOpen,
        isOpen = function() return isOpen end
    }
end

-- 7. Subwindow / Dialog (Independent Window)
local function window(parentGui, options)
    options = options or {}
    local win = Instance.new("Frame")
    win.Name = options.name or "Window"
    win.BackgroundColor3 = Color3.new(1, 1, 1)
    win.BorderSizePixel = 0
    win.Size = UDim2.fromOffset(options.width or 320, options.height or 420)
    win.Position = options.position or UDim2.fromOffset(60, 60)
    win.Visible = options.visible ~= false
    win.Active = true
    win.ClipsDescendants = true
    win.ZIndex = 2
    win:SetAttribute("hlWin", true)
    win.Parent = parentGui

    corner(win, Theme.RadiusLg)
    stroke(win, Theme.Hairline, 1)
    bodyGradient(win)
    shadow(win)

    -- Top Accent Sweep Bar
    local sweepBand = Instance.new("Frame")
    sweepBand.Name = "AccentBar"
    sweepBand.BackgroundColor3 = Color3.new(1, 1, 1)
    sweepBand.BorderSizePixel = 0
    sweepBand.Size = UDim2.new(1, 0, 0, 3)
    sweepBand.ZIndex = 5
    sweepBand.Parent = win
    accentSweep(sweepBand)

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = Theme.SurfaceHeader
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, Theme.HeaderH)
    header.Position = UDim2.fromOffset(0, 3)
    header.Active = true
    header.ZIndex = 3
    header.Parent = win

    pad(header, 0, 12, 0, 14)
    hlist(header, Theme.GapMd)
    makeDraggable(header, win)

    if options.icon and Icons[options.icon] then
        local ic = icon(header, options.icon, 16, Color3.new(1, 1, 1), 4)
        ic.LayoutOrder = 1
    end

    local titleLbl = label(header, options.title or "Window", "windowTitle", 2)
    flexFill(titleLbl, 60)

    -- Pin Button
    local pinBtn = Instance.new("TextButton")
    pinBtn.Name = "Pin"
    pinBtn.BackgroundColor3 = Theme.SurfaceElement
    pinBtn.BorderSizePixel = 0
    pinBtn.Size = UDim2.fromOffset(20, 20)
    pinBtn.Text = ""
    pinBtn.LayoutOrder = 4
    pinBtn.ZIndex = 4
    pinBtn.Parent = header
    corner(pinBtn, 10)
    local pinStroke = stroke(pinBtn, Theme.Hairline, 1)

    local pinIcon = icon(pinBtn, "pin", 13, Theme.TextMuted, 5)
    pinIcon.AnchorPoint, pinIcon.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)

    local isPinned = false
    local function setPinned(state)
        isPinned = state and true or false
        pinIcon.ImageColor3 = isPinned and Theme.AccentMid or Theme.TextMuted
        pinStroke.Color = isPinned and Theme.AccentMid or Theme.Hairline
        pinBtn.BackgroundColor3 = isPinned and Theme.SurfaceHover or Theme.SurfaceElement
    end

    pinBtn.MouseButton1Click:Connect(function()
        setPinned(not isPinned)
        if options.onPinChanged then options.onPinChanged(isPinned) end
    end)
    tip(pinBtn, "Pin window to remain visible.")

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.BackgroundColor3 = Theme.SurfaceElement
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Text = ""
    closeBtn.LayoutOrder = 5
    closeBtn.ZIndex = 4
    closeBtn.Parent = header
    corner(closeBtn, 10)
    stroke(closeBtn, Theme.Hairline, 1)

    local closeIcon = icon(closeBtn, "x", 12, Theme.TextMuted, 5)
    closeIcon.AnchorPoint, closeIcon.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)

    closeBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        if options.onClose then options.onClose() end
    end)

    -- Divider
    local div = Instance.new("Frame")
    div.Name = "Divider"
    div.BackgroundColor3 = Theme.Hairline
    div.BorderSizePixel = 0
    div.Size = UDim2.new(1, 0, 0, 1)
    div.Position = UDim2.fromOffset(0, 3 + Theme.HeaderH)
    div.ZIndex = 3
    div.Parent = win

    -- Scrollable Body
    local body = Instance.new("ScrollingFrame")
    body.Name = "Body"
    body.BackgroundTransparency = 1
    body.BorderSizePixel = 0
    body.Position = UDim2.fromOffset(0, 4 + Theme.HeaderH)
    body.Size = UDim2.new(1, 0, 1, -(4 + Theme.HeaderH + Theme.RadiusLg))
    body.CanvasSize = UDim2.new()
    body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    body.ScrollBarThickness = 4
    body.ScrollBarImageColor3 = Color3.fromHex("50505f")
    body.ZIndex = 3
    body.Parent = win

    pad(body, 10, Theme.GapLg, Theme.GapXl, Theme.GapLg)
    local bodyList = vlist(body, Theme.GapSm)

    return {
        frame = win,
        header = header,
        body = body,
        title = titleLbl,
        isPinned = function() return isPinned end,
        setPinned = setPinned
    }
end

-- Export Low-level UIKit
HarvardUI.UIKit = {
    Theme         = Theme,
    Icons         = Icons,
    setFont       = setFont,
    corner        = corner,
    stroke        = stroke,
    pad           = pad,
    vlist         = vlist,
    hlist         = hlist,
    flexFill      = flexFill,
    label         = label,
    caption       = caption,
    accentGradient = accentGradient,
    accentSweep   = accentSweep,
    bodyGradient  = bodyGradient,
    shadow        = shadow,
    icon          = icon,
    chevron       = chevron,
    row           = row,
    hoverable     = hoverable,
    ensureTip     = ensureTip,
    tip           = tip,
    hideTip       = hideTip,
    makeDraggable = makeDraggable,
    raiseWindow   = raiseWindow,
    toggle        = toggle,
    slider        = slider,
    dropdown      = dropdown,
    button        = button,
    buttonRow     = buttonRow,
    textInput     = textInput,
    section       = section,
    window        = window
}

-- ========================================================================
-- HIGH-LEVEL WINDOW & TAB BUILDER (THE MAIN HARVARD HUB SHELL)
-- ========================================================================

function HarvardUI:CreateWindow(config)
    config = config or {}
    local winTitle = config.Title or "Harvard Hub"
    local winSubTitle = config.SubTitle or "v1.0"
    local winSize = config.Size or UDim2.fromOffset(620, 420)
    local winPos = config.Position or UDim2.fromOffset(80, 80)
    local toggleKey = config.Keybind or Enum.KeyCode.RightControl

    local guiParent = getGuiParent()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HarvardHubUI_" .. tostring(math.random(1000, 9999))
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = guiParent

    ensureTip(screenGui)

    -- Main Hub Container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainHub"
    mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    mainFrame.BorderSizePixel = 0
    mainFrame.Size = winSize
    mainFrame.Position = winPos
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 10
    mainFrame:SetAttribute("hlWin", true)
    mainFrame.Parent = screenGui

    corner(mainFrame, Theme.RadiusLg)
    stroke(mainFrame, Theme.Hairline, 1)
    bodyGradient(mainFrame)
    shadow(mainFrame)

    -- Top Accent Sweep
    local topBand = Instance.new("Frame")
    topBand.Name = "TopBand"
    topBand.BackgroundColor3 = Color3.new(1, 1, 1)
    topBand.BorderSizePixel = 0
    topBand.Size = UDim2.new(1, 0, 0, 3)
    topBand.ZIndex = 15
    topBand.Parent = mainFrame
    accentSweep(topBand)

    -- Hub Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = Theme.SurfaceHeader
    header.BorderSizePixel = 0
    header.Position = UDim2.fromOffset(0, 3)
    header.Size = UDim2.new(1, 0, 0, Theme.HeaderH)
    header.ZIndex = 12
    header.Active = true
    header.Parent = mainFrame

    corner(header, Theme.RadiusLg)
    pad(header, 0, 14, 0, 16)
    hlist(header, Theme.GapMd)
    makeDraggable(header, mainFrame)

    local hubIcon = icon(header, "crown", 18, Color3.new(1, 1, 1), 13)
    accentGradient(hubIcon, 45)

    local titleLbl = label(header, winTitle, "windowTitle", 2)
    titleLbl.Size = UDim2.new(0, 0, 1, 0)
    titleLbl.AutomaticSize = Enum.AutomaticSize.X

    local chip = Instance.new("TextLabel")
    chip.Name = "VersionChip"
    chip.BackgroundColor3 = Theme.SurfaceChip
    chip.BorderSizePixel = 0
    chip.Size = UDim2.fromOffset(42, 18)
    chip.Text = winSubTitle
    chip.TextColor3 = Theme.TextSub
    chip.TextSize = 10
    chip.LayoutOrder = 3
    chip.ZIndex = 13
    setFont(chip, "mono", Enum.FontWeight.Medium)
    chip.Parent = header
    corner(chip, 4)
    stroke(chip, Theme.Hairline, 1)

    local flexSpacer = Instance.new("Frame")
    flexSpacer.BackgroundTransparency = 1
    flexSpacer.Size = UDim2.new(1, -220, 1, 0)
    flexSpacer.LayoutOrder = 4
    flexSpacer.Parent = header

    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.BackgroundColor3 = Theme.SurfaceElement
    minBtn.BorderSizePixel = 0
    minBtn.Size = UDim2.fromOffset(22, 22)
    minBtn.Text = "-"
    minBtn.TextColor3 = Theme.TextSub
    minBtn.TextSize = 14
    minBtn.LayoutOrder = 5
    minBtn.ZIndex = 13
    setFont(minBtn, "sans", Enum.FontWeight.Bold)
    minBtn.Parent = header
    corner(minBtn, 6)
    stroke(minBtn, Theme.Hairline, 1)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.BackgroundColor3 = Theme.SurfaceElement
    closeBtn.BorderSizePixel = 0
    closeBtn.Size = UDim2.fromOffset(22, 22)
    closeBtn.Text = ""
    closeBtn.LayoutOrder = 6
    closeBtn.ZIndex = 13
    closeBtn.Parent = header
    corner(closeBtn, 6)
    stroke(closeBtn, Theme.Hairline, 1)

    local closeIc = icon(closeBtn, "x", 12, Theme.TextSub, 14)
    closeIc.AnchorPoint, closeIc.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)

    -- Layout Container (Below Header)
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.BackgroundTransparency = 1
    container.Position = UDim2.fromOffset(0, 3 + Theme.HeaderH)
    container.Size = UDim2.new(1, 0, 1, -(3 + Theme.HeaderH))
    container.ZIndex = 11
    container.Parent = mainFrame

    -- Left Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Theme.SurfaceHeader
    sidebar.BorderSizePixel = 0
    sidebar.Size = UDim2.new(0, 150, 1, 0)
    sidebar.ZIndex = 11
    sidebar.Parent = container

    stroke(sidebar, Theme.Hairline, 1)
    pad(sidebar, 10, 8, 10, 8)
    local tabListLayout = vlist(sidebar, 4)

    -- Right Content View
    local contentView = Instance.new("Frame")
    contentView.Name = "ContentView"
    contentView.BackgroundTransparency = 1
    contentView.Position = UDim2.fromOffset(150, 0)
    contentView.Size = UDim2.new(1, -150, 1, 0)
    contentView.ZIndex = 11
    contentView.Parent = container

    -- Tab Content Header (Breadcrumbs)
    local pageHeader = Instance.new("Frame")
    pageHeader.Name = "PageHeader"
    pageHeader.BackgroundTransparency = 1
    pageHeader.Size = UDim2.new(1, 0, 0, 42)
    pageHeader.Parent = contentView

    pad(pageHeader, 8, 16, 4, 16)
    vlist(pageHeader, 2)

    local pageTitle = label(pageHeader, "Select Tab", "windowTitle", 1)
    pageTitle.Size = UDim2.new(1, 0, 0, 18)
    local pageDesc = label(pageHeader, "", "captionSub", 2)
    pageDesc.Size = UDim2.new(1, 0, 0, 14)

    -- Pages Container
    local pagesFolder = Instance.new("Frame")
    pagesFolder.Name = "Pages"
    pagesFolder.BackgroundTransparency = 1
    pagesFolder.Position = UDim2.fromOffset(0, 42)
    pagesFolder.Size = UDim2.new(1, 0, 1, -42)
    pagesFolder.Parent = contentView

    -- Window State Management
    local isMinimized = false
    local originalSize = winSize
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            container.Visible = false
            mainFrame.Size = UDim2.fromOffset(winSize.X.Offset, Theme.HeaderH + 3)
        else
            mainFrame.Size = originalSize
            container.Visible = true
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Toggle Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Window API Object
    local Window = {
        ScreenGui   = screenGui,
        MainFrame   = mainFrame,
        Tabs        = {},
        ActiveTab   = nil
    }

    function Window:SelectTab(tabObj)
        if Window.ActiveTab == tabObj then return end
        for _, t in ipairs(Window.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Theme.SurfaceHeader
            t.Label.TextColor3 = Theme.TextSub
            t.Icon.ImageColor3 = Theme.TextSub
            t.Indicator.Visible = false
        end
        Window.ActiveTab = tabObj
        tabObj.Page.Visible = true
        tabObj.Button.BackgroundColor3 = Theme.SurfaceHover
        tabObj.Label.TextColor3 = Theme.TextPrimary
        tabObj.Icon.ImageColor3 = Color3.new(1, 1, 1)
        tabObj.Indicator.Visible = true

        pageTitle.Text = tabObj.Name
        pageDesc.Text = tabObj.Description or ""
    end

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIconName = tabConfig.Icon or "swords"
        local tabDesc = tabConfig.Description or ""

        -- Tab Button in Sidebar
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabName
        tabBtn.BackgroundColor3 = Theme.SurfaceHeader
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.LayoutOrder = #Window.Tabs + 1
        tabBtn.ZIndex = 12
        tabBtn.Parent = sidebar
        corner(tabBtn, Theme.RadiusSm)

        local tabBtnHlist = hlist(tabBtn, Theme.GapSm)
        pad(tabBtn, 0, 8, 0, 8)

        local tabIc = icon(tabBtn, tabIconName, 14, Theme.TextSub, 13)
        tabIc.LayoutOrder = 1

        local tabLbl = label(tabBtn, tabName, "rowLabel", 2)
        tabLbl.TextColor3 = Theme.TextSub
        tabLbl.Size = UDim2.new(1, -24, 1, 0)
        setFont(tabLbl, "sans", Enum.FontWeight.Medium)

        -- Active Accent Indicator
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.BackgroundColor3 = Theme.AccentMid
        indicator.BorderSizePixel = 0
        indicator.Position = UDim2.fromOffset(-8, 6)
        indicator.Size = UDim2.fromOffset(3, 20)
        indicator.Visible = false
        indicator.ZIndex = 13
        indicator.Parent = tabBtn
        corner(indicator, 2)

        -- Tab Page Container (Scrolling)
        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. tabName
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.fromScale(1, 1)
        page.CanvasSize = UDim2.new()
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = Color3.fromHex("50505f")
        page.Visible = false
        page.Parent = pagesFolder

        pad(page, 10, 16, 20, 16)
        local pageLayout = vlist(page, Theme.GapSm)

        local tabObj = {
            Name        = tabName,
            Description = tabDesc,
            Button      = tabBtn,
            Label       = tabLbl,
            Icon        = tabIc,
            Indicator   = indicator,
            Page        = page
        }

        tabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(tabObj)
        end)

        table.insert(Window.Tabs, tabObj)
        if #Window.Tabs == 1 then
            Window:SelectTab(tabObj)
        end

        -- Tab Building Functions
        function tabObj:CreateSection(secTitle, secDesc)
            local sec = section(page, secTitle, nil, secDesc)
            local secContent = sec.content

            local secApi = { Section = sec }

            function secApi:AddToggle(txt, defaultVal, callback, tipTxt)
                local state = defaultVal and true or false
                return toggle(secContent, txt, function() return state end, function(newVal)
                    state = newVal
                    if callback then callback(state) end
                end, nil, tipTxt)
            end

            function secApi:AddSlider(txt, min, max, defaultVal, callback, options)
                options = options or {}
                local val = defaultVal or min
                return slider(secContent, txt, options.Unit or "", min, max, options.IsFloat or false,
                    function() return val end,
                    function(newVal)
                        val = newVal
                        if callback then callback(val) end
                    end,
                    nil, options.Tooltip, options.Step)
            end

            function secApi:AddDropdown(txt, itemsList, defaultVal, callback, tipTxt)
                local current = defaultVal or (itemsList[1] and (type(itemsList[1]) == "table" and itemsList[1].value or itemsList[1]))
                return dropdown(secContent, txt, itemsList,
                    function() return current end,
                    function(newVal)
                        current = newVal
                        if callback then callback(current) end
                    end,
                    nil, tipTxt)
            end

            function secApi:AddButton(txt, callback, style, tipTxt)
                return button(secContent, txt, style or "subtle", callback, nil, tipTxt)
            end

            function secApi:AddButtonRow()
                return buttonRow(secContent)
            end

            function secApi:AddInput(txt, defaultVal, callback, tipTxt, placeholder)
                local current = defaultVal or ""
                return textInput(secContent, txt,
                    function() return current end,
                    function(newVal)
                        current = newVal
                        if callback then callback(current) end
                    end,
                    nil, tipTxt, placeholder)
            end

            function secApi:AddLabel(txt, style)
                return label(secContent, txt, style or "captionSub")
            end

            function secApi:AddCaption(txt)
                return caption(secContent, txt)
            end

            return secApi
        end

        return tabObj
    end

    function Window:CreateSubWindow(subOptions)
        return window(screenGui, subOptions)
    end

    function Window:Destroy()
        screenGui:Destroy()
    end

    return Window
end

return HarvardUI
