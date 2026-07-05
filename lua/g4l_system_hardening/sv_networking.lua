if CLIENT then return end

local function sendMenu(ply)
    local payload = G4L.VehicleGod.Store.BuildMenuPayload(ply)
    net.Start("G4L.VehicleGod:OpenMenu")
        net.WriteString(util.TableToJSON(payload))
    net.Send(ply)
end

net.Receive("G4L.VehicleGod:Toggle", function(_, ply)
    if not G4L.VehicleGod.IsAdmin(ply) then
        G4L.VehicleGod.Notify(ply, "no_permission", 1)
        return
    end

    local ent = net.ReadEntity()
    local seat = G4L.VehicleGod.ResolveSeat(ent) or (IsValid(ent) and G4L.VehicleGod.GetDriverSeat(ent))
    if not IsValid(seat) then
        G4L.VehicleGod.Notify(ply, "no_vehicle", 1)
        return
    end

    G4L.VehicleGod.TogglePermanent(seat, ply)
end)

net.Receive("G4L.VehicleGod:RequestMenu", function(_, ply)
    if not G4L.VehicleGod.IsAdmin(ply) then
        G4L.VehicleGod.Notify(ply, "no_permission", 1)
        return
    end

    sendMenu(ply)
end)

net.Receive("G4L.VehicleGod:MenuAction", function(_, ply)
    if not G4L.VehicleGod.IsAdmin(ply) then
        G4L.VehicleGod.Notify(ply, "no_permission", 1)
        return
    end

    local action = net.ReadString()
    local model = net.ReadString()

    if action == "refresh" then
        sendMenu(ply)
        return
    end

    if action == "apply" then
        G4L.VehicleGod.ApplyAllPermanent()
        sendMenu(ply)
        return
    end

    if action == "toggle_hud" then
        local enabled = not G4L.VehicleGod.IsStaffHudEnabled(ply)
        ply:SetNWBool(G4L.VehicleGod.HudNWKey or "G4L_VehicleGod_Hud", enabled)
        G4L.VehicleGod.Notify(ply, enabled and "hud_enabled" or "hud_disabled", 0)
        sendMenu(ply)
        return
    end

    if action == "remove_permanent" and model ~= "" then
        G4L.VehicleGod.Store.SetPermanentModel(model, false)
        G4L.VehicleGod.BroadcastPermanentSync()
        G4L.VehicleGod.Notify(ply, "god_permanent_removed", 0, { model = model })
        sendMenu(ply)
        return
    end

    if action == "add_aim" then
        local seat = nil
        local tr = ply:GetEyeTrace()
        if tr.Hit and IsValid(tr.Entity) then
            seat = G4L.VehicleGod.ResolveSeat(tr.Entity)
        end

        if not IsValid(seat) then
            G4L.VehicleGod.Notify(ply, "no_vehicle", 1)
            return
        end

        G4L.VehicleGod.AddPermanent(seat, ply)
        sendMenu(ply)
        return
    end
end)

concommand.Add("g4l_god_menu", function(ply)
    if not IsValid(ply) then return end
    if not G4L.VehicleGod.IsAdmin(ply) then
        G4L.VehicleGod.Notify(ply, "no_permission", 1)
        return
    end

    sendMenu(ply)
end)
