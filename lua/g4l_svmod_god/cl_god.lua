local function getAimedSeat()
    local tr = LocalPlayer():GetEyeTrace()
    if not tr.Hit or not IsValid(tr.Entity) then return nil end
    return G4L.VehicleGod.ResolveSeat(tr.Entity)
end

local function drawVehicleInfo(seat)
    if not IsValid(seat) then return end

    local health = seat.SV_GetHealth and seat:SV_GetHealth() or 0
    local maxHealth = seat.SV_GetMaxHealth and seat:SV_GetMaxHealth() or 0
    local percent = maxHealth > 0 and math.Round(health / maxHealth * 100) or 0
    local god = G4L.VehicleGod.IsGod(seat)

    local lines = {
        G4L.VehicleGod.L("info_model", { model = seat:GetModel() or "?" }),
        G4L.VehicleGod.L("info_health", { current = health, max = maxHealth, percent = percent }),
        G4L.VehicleGod.L("info_god", {
            state = god and G4L.VehicleGod.L("state_on") or G4L.VehicleGod.L("state_off"),
        }),
    }

    if god then
        table.insert(lines, G4L.VehicleGod.L("info_source", { source = G4L.VehicleGod.GetSourceLabel(seat) }))
    end

    local scr = seat:GetPos():ToScreen()
    if not scr.visible then return end

    surface.SetFont("G4L.VehicleGod:Bold14")
    local maxW = 0
    local totalH = 0
    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        maxW = math.max(maxW, w)
        totalH = totalH + h + 4
    end

    local boxW = maxW + 20
    local boxH = totalH + 12
    local x = scr.x - boxW / 2
    local y = scr.y - boxH - 24

    draw.RoundedBox(8, x, y, boxW, boxH, Color(18, 24, 38, 230))
    if god then
        draw.RoundedBoxEx(8, x, y, 4, boxH, Color(255, 210, 80), true, false, true, false)
    end

    local lineY = y + 8
    for i, line in ipairs(lines) do
        local col = Color(230, 235, 245)
        if god and i >= 3 then col = Color(255, 210, 80) end
        draw.SimpleText(line, "G4L.VehicleGod:Bold14", scr.x, lineY, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        local _, h = surface.GetTextSize(line)
        lineY = lineY + h + 4
    end
end

hook.Add("HUDPaint", "G4L.VehicleGod:AdminInfo", function()
    if not G4L.VehicleGod.IsAdmin(LocalPlayer()) then return end

    local seat = getAimedSeat()
    if IsValid(seat) then
        drawVehicleInfo(seat)
    end
end)

hook.Add("HUDPaint", "G4L.VehicleGod:Indicator", function()
    if not G4L.VehicleGod.GetConfig().ShowHudIndicator then return end

    local ply = LocalPlayer()
    local veh = ply:GetVehicle()
    if not IsValid(veh) then return end

    local seat = G4L.VehicleGod.ResolveSeat(veh) or G4L.VehicleGod.GetDriverSeat(veh) or veh
    if not G4L.VehicleGod.IsGod(seat) then return end

    local text = G4L.VehicleGod.L("hud_god")
    surface.SetFont("G4L.VehicleGod:Bold18")
    local w, h = surface.GetTextSize(text)

    local x = ScrW() / 2 - w / 2 - 12
    local y = ScrH() - 120

    draw.RoundedBox(8, x, y, w + 24, h + 12, Color(18, 24, 38, 210))
    draw.SimpleText(text, "G4L.VehicleGod:Bold18", ScrW() / 2, y + 6, Color(255, 210, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end)
