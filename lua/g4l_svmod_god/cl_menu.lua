G4L.VehicleGod.MenuFrame = G4L.VehicleGod.MenuFrame or nil

local COL = {
    bg = Color(18, 24, 38),
    panel = Color(26, 34, 54),
    accent = Color(255, 210, 80),
    text = Color(235, 240, 250),
    muted = Color(160, 170, 190),
    good = Color(120, 220, 160),
}

local function styleButton(btn, accent)
    btn:SetFont("G4L.VehicleGod:Bold14")
    btn:SetTextColor(COL.text)
    btn.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, s:IsHovered() and Color(40, 52, 78) or COL.panel)
        if accent then
            draw.RoundedBoxEx(6, 0, 0, 3, h, COL.accent, true, false, true, false)
        end
    end
end

local function styleHeader(parent, text)
    local lbl = vgui.Create("DLabel", parent)
    lbl:Dock(TOP)
    lbl:DockMargin(8, 8, 8, 4)
    lbl:SetFont("G4L.VehicleGod:Bold16")
    lbl:SetTextColor(COL.accent)
    lbl:SetText(text)
    lbl:SizeToContents()
end

local function addRow(list, cols, onClick)
    local row = list:Add("DPanel")
    row:Dock(TOP)
    row:DockMargin(0, 0, 0, 4)
    row:SetTall(34)
    row.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, s:IsHovered() and Color(34, 44, 68) or Color(30, 38, 58))
    end

    local x = 8
    for i, col in ipairs(cols) do
        local lbl = vgui.Create("DLabel", row)
        lbl:SetPos(x, 8)
        lbl:SetFont("G4L.VehicleGod:Bold14")
        lbl:SetTextColor(i == #cols and COL.good or COL.text)
        lbl:SetText(col)
        lbl:SizeToContents()
        x = x + (i == 1 and 160 or 280)
    end

    if onClick then
        row.OnMousePressed = function(_, code)
            if code == MOUSE_LEFT then onClick() end
        end
    end
end

function G4L.VehicleGod.OpenMenu(data)
    if IsValid(G4L.VehicleGod.MenuFrame) then
        G4L.VehicleGod.MenuFrame:Remove()
    end

    G4L.VehicleGod.MenuSelectedModel = nil

    local frame = vgui.Create("DFrame")
    G4L.VehicleGod.MenuFrame = frame
    frame:SetSize(820, 580)
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame.Paint = function(_, w, h)
        draw.RoundedBox(10, 0, 0, w, h, COL.bg)
        draw.SimpleText(G4L.VehicleGod.L("menu_title"), "G4L.VehicleGod:Bold20", 16, 12, COL.accent, TEXT_ALIGN_LEFT)
        draw.SimpleText(G4L.VehicleGod.L("menu_hint_config"), "G4L.VehicleGod:Bold14", 16, 38, COL.muted, TEXT_ALIGN_LEFT)
    end

    local top = vgui.Create("DPanel", frame)
    top:Dock(TOP)
    top:SetTall(48)
    top:DockMargin(12, 52, 12, 0)
    top.Paint = function() end

    local btnAdd = vgui.Create("DButton", top)
    btnAdd:Dock(LEFT)
    btnAdd:SetWide(220)
    btnAdd:DockMargin(0, 0, 8, 0)
    btnAdd:SetText(G4L.VehicleGod.L("menu_add_aim"))
    styleButton(btnAdd, true)
    btnAdd.DoClick = function()
        net.Start("G4L.VehicleGod:MenuAction")
            net.WriteString("add_aim")
            net.WriteString("")
        net.SendToServer()
    end

    local btnApply = vgui.Create("DButton", top)
    btnApply:Dock(LEFT)
    btnApply:SetWide(160)
    btnApply:DockMargin(0, 0, 8, 0)
    btnApply:SetText(G4L.VehicleGod.L("menu_apply"))
    styleButton(btnApply)
    btnApply.DoClick = function()
        net.Start("G4L.VehicleGod:MenuAction")
            net.WriteString("apply")
            net.WriteString("")
        net.SendToServer()
    end

    local btnRefresh = vgui.Create("DButton", top)
    btnRefresh:Dock(LEFT)
    btnRefresh:SetWide(120)
    btnRefresh:DockMargin(0, 0, 8, 0)
    btnRefresh:SetText(G4L.VehicleGod.L("menu_reload"))
    styleButton(btnRefresh)
    btnRefresh.DoClick = function()
        net.Start("G4L.VehicleGod:MenuAction")
            net.WriteString("refresh")
            net.WriteString("")
        net.SendToServer()
    end

    local btnClose = vgui.Create("DButton", top)
    btnClose:Dock(RIGHT)
    btnClose:SetWide(100)
    btnClose:SetText(G4L.VehicleGod.L("menu_close"))
    styleButton(btnClose)
    btnClose.DoClick = function() frame:Close() end

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)
    sheet:DockMargin(12, 8, 12, 52)

    local function makeScrollTab(title)
        local page = vgui.Create("DPanel")
        page.Paint = function(_, w, h) draw.RoundedBox(8, 0, 0, w, h, COL.panel) end
        local scroll = vgui.Create("DScrollPanel", page)
        scroll:Dock(FILL)
        scroll:DockMargin(8, 8, 8, 8)
        sheet:AddSheet(title, page, "icon16/table.png")
        return scroll
    end

    local tabConfig = makeScrollTab(G4L.VehicleGod.L("menu_tab_config"))
    styleHeader(tabConfig, G4L.VehicleGod.L("menu_col_id") .. " | " .. G4L.VehicleGod.L("menu_col_label") .. " | " .. G4L.VehicleGod.L("menu_col_model"))
    if #(data.config or {}) == 0 then
        addRow(tabConfig, { G4L.VehicleGod.L("menu_empty") })
    else
        for _, entry in ipairs(data.config or {}) do
            addRow(tabConfig, {
                entry.id or "?",
                entry.label or entry.id or "?",
                table.concat(entry.models or {}, ", "),
            })
        end
    end

    local tabPermanent = makeScrollTab(G4L.VehicleGod.L("menu_tab_permanent"))
    styleHeader(tabPermanent, G4L.VehicleGod.L("menu_col_label") .. " | " .. G4L.VehicleGod.L("menu_col_model"))
    if #(data.permanent or {}) == 0 then
        addRow(tabPermanent, { G4L.VehicleGod.L("menu_empty") })
    else
        for _, entry in ipairs(data.permanent or {}) do
            addRow(tabPermanent, {
                entry.label or entry.model,
                entry.model or "?",
                G4L.VehicleGod.L("state_on"),
            }, function()
                G4L.VehicleGod.MenuSelectedModel = entry.model
            end)
        end
    end

    local tabWorld = makeScrollTab(G4L.VehicleGod.L("menu_tab_world"))
    styleHeader(tabWorld, G4L.VehicleGod.L("menu_col_model") .. " | " .. G4L.VehicleGod.L("menu_col_source"))
    if #(data.world or {}) == 0 then
        addRow(tabWorld, { G4L.VehicleGod.L("menu_empty") })
    else
        for _, entry in ipairs(data.world or {}) do
            addRow(tabWorld, {
                entry.model or "?",
                entry.source or "?",
                G4L.VehicleGod.L("state_on"),
            })
        end
    end

    local btnRemove = vgui.Create("DButton", frame)
    btnRemove:Dock(BOTTOM)
    btnRemove:SetTall(36)
    btnRemove:DockMargin(12, 0, 12, 12)
    btnRemove:SetText(G4L.VehicleGod.L("menu_remove"))
    styleButton(btnRemove)
    btnRemove.DoClick = function()
        if not G4L.VehicleGod.MenuSelectedModel then return end
        net.Start("G4L.VehicleGod:MenuAction")
            net.WriteString("remove_permanent")
            net.WriteString(G4L.VehicleGod.MenuSelectedModel)
        net.SendToServer()
    end
end

net.Receive("G4L.VehicleGod:OpenMenu", function()
    local raw = net.ReadString()
    local data = util.JSONToTable(raw) or {}
    G4L.VehicleGod.OpenMenu(data)
end)

concommand.Add("g4l_god_menu", function()
    if not G4L.VehicleGod.IsAdmin(LocalPlayer()) then return end
    net.Start("G4L.VehicleGod:RequestMenu")
    net.SendToServer()
end)
