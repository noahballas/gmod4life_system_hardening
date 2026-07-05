if CLIENT then return end

util.AddNetworkString("G4L.VehicleGod:Toggle")
util.AddNetworkString("G4L.VehicleGod:Notify")
util.AddNetworkString("G4L.VehicleGod:OpenMenu")
util.AddNetworkString("G4L.VehicleGod:RequestMenu")
util.AddNetworkString("G4L.VehicleGod:MenuAction")
util.AddNetworkString("G4L.VehicleGod:SyncPermanent")

G4L.VehicleGod._patched = G4L.VehicleGod._patched or false

local function notify(ply, key, typ, replacements)
    if not IsValid(ply) then return end
    typ = typ or 0
    local msg = G4L.VehicleGod.L(key, replacements, ply)

    net.Start("G4L.VehicleGod:Notify")
        net.WriteString(msg)
        net.WriteUInt(typ, 3)
    net.Send(ply)

    if DarkRP and DarkRP.notify then
        DarkRP.notify(ply, typ, 5, msg)
    end
end

G4L.VehicleGod.Notify = notify

function G4L.VehicleGod.BroadcastPermanentSync(ply)
    local models = {}
    for model in pairs(G4L.VehicleGod.Store.GetPermanentModels()) do
        table.insert(models, model)
    end

    net.Start("G4L.VehicleGod:SyncPermanent")
        net.WriteUInt(#models, 16)
        for _, model in ipairs(models) do
            net.WriteString(model)
        end

    if IsValid(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

local function getTraceSeat(ply)
    local tr = ply:GetEyeTrace()
    if not tr.Hit or not IsValid(tr.Entity) then return nil end
    return G4L.VehicleGod.ResolveSeat(tr.Entity)
end

local function repairVehicle(seat)
    if not IsValid(seat) or not seat.SV_FullRepair then return end
    seat:SV_FullRepair()
end

function G4L.VehicleGod.AddPermanent(seat, ply)
    if not IsValid(seat) then return false end

    local model = G4L.VehicleGod.GetVehicleModel(seat)
    if model == "" then return false end

    if G4L.VehicleGod.IsConfigLocked(seat) then
        if IsValid(ply) then
            notify(ply, "god_config_locked", 2, { id = G4L.VehicleGod.GetConfigMatch(seat).id })
        end
        repairVehicle(seat)
        return false
    end

    if G4L.VehicleGod.Store.IsPermanentModel(model) then
        if IsValid(ply) then notify(ply, "god_already_permanent", 2) end
        return false
    end

    G4L.VehicleGod.Store.SetPermanentModel(model, true, {
        label = seat:GetModel() or model,
        by = IsValid(ply) and ply:Nick() or "console",
    })

    repairVehicle(seat)
    G4L.VehicleGod.BroadcastPermanentSync()

    if IsValid(ply) then notify(ply, "god_permanent_added", 0, { model = model }) end
    return true
end

function G4L.VehicleGod.RemovePermanent(seat, ply)
    if not IsValid(seat) then return false end

    local model = G4L.VehicleGod.GetVehicleModel(seat)

    if G4L.VehicleGod.IsConfigLocked(seat) then
        if IsValid(ply) then
            notify(ply, "god_config_locked", 2, { id = G4L.VehicleGod.GetConfigMatch(seat).id })
        end
        return false
    end

    if not G4L.VehicleGod.Store.IsPermanentModel(model) then
        if IsValid(ply) then notify(ply, "god_not_permanent", 1) end
        return false
    end

    G4L.VehicleGod.Store.SetPermanentModel(model, false)
    G4L.VehicleGod.BroadcastPermanentSync()

    if IsValid(ply) then notify(ply, "god_permanent_removed", 0, { model = model }) end
    return true
end

function G4L.VehicleGod.TogglePermanent(seat, ply)
    if not IsValid(seat) then return false end

    local model = G4L.VehicleGod.GetVehicleModel(seat)

    if G4L.VehicleGod.IsConfigLocked(seat) then
        if IsValid(ply) then
            notify(ply, "god_config_locked", 2, { id = G4L.VehicleGod.GetConfigMatch(seat).id })
        end
        repairVehicle(seat)
        return false
    end

    if G4L.VehicleGod.Store.IsPermanentModel(model) then
        return G4L.VehicleGod.RemovePermanent(seat, ply)
    end

    return G4L.VehicleGod.AddPermanent(seat, ply)
end

function G4L.VehicleGod.ApplyAllPermanent()
    if not G4L.VehicleGod.IsSVMODLoaded() then return end

    for _, veh in ipairs(ents.GetAll()) do
        if G4L.VehicleGod.IsSVMODVehicle(veh) and veh.SV_IsDriverSeat and veh:SV_IsDriverSeat() then
            if G4L.VehicleGod.ShouldBeGod(veh) then
                repairVehicle(veh)
            end
        end
    end
end

local function patchSVMOD()
    if not G4L.VehicleGod.IsSVMODLoaded() or G4L.VehicleGod._patched then return end
    if not SVMOD.Metatable or not SVMOD.Metatable.SV_SetHealth then return end

    G4L.VehicleGod._patched = true

    local origSetHealth = SVMOD.Metatable.SV_SetHealth
    function SVMOD.Metatable:SV_SetHealth(value)
        local veh = self
        if self.SV_IsPassengerSeat and self:SV_IsPassengerSeat() then
            veh = self:SV_GetDriverSeat()
        end

        if IsValid(veh) and G4L.VehicleGod.ShouldBeGod(veh) then
            value = math.max(value, veh:SV_GetMaxHealth())
        end

        return origSetHealth(self, value)
    end

    if SVMOD.Metatable.SV_DealDamageToWheel then
        local origWheel = SVMOD.Metatable.SV_DealDamageToWheel
        function SVMOD.Metatable:SV_DealDamageToWheel(wheelID, amount)
            if G4L.VehicleGod.ShouldBeGod(self) then return end
            return origWheel(self, wheelID, amount)
        end
    end

    local wheelFns = { "SV_SetWheelFLHealth", "SV_SetWheelFRHealth", "SV_SetWheelRLHealth", "SV_SetWheelRRHealth" }
    for _, fnName in ipairs(wheelFns) do
        if SVMOD.Metatable[fnName] then
            local orig = SVMOD.Metatable[fnName]
            SVMOD.Metatable[fnName] = function(self, value)
                if G4L.VehicleGod.ShouldBeGod(self) then
                    value = 100
                end
                return orig(self, value)
            end
        end
    end
end

hook.Add("InitPostEntity", "G4L.VehicleGod:Init", function()
    patchSVMOD()
    G4L.VehicleGod.BroadcastPermanentSync()
    timer.Simple(1, G4L.VehicleGod.ApplyAllPermanent)
end)

hook.Add("SV_Enabled", "G4L.VehicleGod:Patch", function()
    patchSVMOD()
    G4L.VehicleGod.ApplyAllPermanent()
end)

hook.Add("PlayerInitialSpawn", "G4L.VehicleGod:Sync", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            G4L.VehicleGod.BroadcastPermanentSync(ply)
        end
    end)
end)

timer.Create("G4L.VehicleGod:WaitSVMOD", 2, 30, function()
    if G4L.VehicleGod.IsSVMODLoaded() then
        patchSVMOD()
        timer.Remove("G4L.VehicleGod:WaitSVMOD")
    end
end)

hook.Add("SV_VehicleLoaded", "G4L.VehicleGod:Loaded", function(veh)
    if not G4L.VehicleGod.GetConfig().ApplyConfigOnSpawn then return end
    if not IsValid(veh) or not veh.SV_IsDriverSeat or not veh:SV_IsDriverSeat() then return end
    timer.Simple(0, function()
        if IsValid(veh) and G4L.VehicleGod.ShouldBeGod(veh) then
            repairVehicle(veh)
        end
    end)
end)

hook.Add("EntityTakeDamage", "G4L.VehicleGod:ProtectOccupants", function(ent, dmginfo)
    if not G4L.VehicleGod.GetConfig().ProtectOccupants then return end
    if not IsValid(ent) or not ent:IsPlayer() then return end

    local veh = ent:GetVehicle()
    if not IsValid(veh) then return end

    local seat = G4L.VehicleGod.ResolveSeat(veh) or G4L.VehicleGod.GetDriverSeat(veh)
    if not IsValid(seat) or not G4L.VehicleGod.ShouldBeGod(seat) then return end

    if dmginfo:GetDamageType() == DMG_VEHICLE then
        return true
    end
end)

hook.Add("PostCleanupMap", "G4L.VehicleGod:Cleanup", function()
    timer.Simple(1, G4L.VehicleGod.ApplyAllPermanent)
end)

concommand.Add("g4l_god_toggle", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end
    if not IsValid(ply) then return end

    local seat = getTraceSeat(ply)
    if not IsValid(seat) then
        notify(ply, "no_vehicle", 1)
        return
    end

    G4L.VehicleGod.TogglePermanent(seat, ply)
end)

concommand.Add("g4l_god_add", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end
    if not IsValid(ply) then return end

    local seat = getTraceSeat(ply)
    if not IsValid(seat) then
        notify(ply, "no_vehicle", 1)
        return
    end

    G4L.VehicleGod.AddPermanent(seat, ply)
end)

concommand.Add("g4l_god_remove", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end
    if not IsValid(ply) then return end

    local seat = getTraceSeat(ply)
    if not IsValid(seat) then
        notify(ply, "no_vehicle", 1)
        return
    end

    G4L.VehicleGod.RemovePermanent(seat, ply)
end)

concommand.Add("g4l_god_list", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end

    local function printLine(msg)
        if IsValid(ply) then ply:ChatPrint("[G4L Hardening] " .. msg) else print("[G4L Hardening] " .. msg) end
    end

    printLine("--- Config ---")
    for id, entry in pairs(G4L.VehicleGod.GetConfig().Vehicles or {}) do
        printLine("  [" .. id .. "] " .. (entry.label or id) .. " -> " .. table.concat(entry.models or {}, ", "))
    end
    for _, model in ipairs(G4L.VehicleGod.GetConfig().AlwaysGodModels or {}) do
        printLine("  [always] " .. model)
    end

    printLine("--- Permanent (JSON) ---")
    local count = 0
    for model, entry in pairs(G4L.VehicleGod.Store.GetPermanentModels()) do
        count = count + 1
        printLine("  " .. model .. " (" .. (entry.by or "?") .. ")")
    end

    if IsValid(ply) and count == 0 and table.Count(G4L.VehicleGod.GetConfig().Vehicles or {}) == 0 and #(G4L.VehicleGod.GetConfig().AlwaysGodModels or {}) == 0 then
        notify(ply, "god_list_empty", 1)
    end
end)

concommand.Add("g4l_god_clear", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end

    G4L.VehicleGod.Store.ClearPermanent()
    G4L.VehicleGod.BroadcastPermanentSync()
    notify(ply, "god_permanent_cleared", 0)
end)

concommand.Add("g4l_god_repair", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end
    if not IsValid(ply) then return end

    local seat = getTraceSeat(ply)
    if not IsValid(seat) then
        notify(ply, "no_vehicle", 1)
        return
    end

    repairVehicle(seat)
end)

concommand.Add("g4l_god_apply", function(ply)
    if IsValid(ply) and not G4L.VehicleGod.IsAdmin(ply) then
        notify(ply, "no_permission", 1)
        return
    end

    G4L.VehicleGod.ApplyAllPermanent()
end)

-- Compat anciennes fonctions
G4L.VehicleGod.ToggleGod = G4L.VehicleGod.TogglePermanent
G4L.VehicleGod.ApplyAllConfig = G4L.VehicleGod.ApplyAllPermanent
