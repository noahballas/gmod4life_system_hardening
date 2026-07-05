G4L.VehicleGod = G4L.VehicleGod or {}
G4L.VehicleGod.PermanentModels = G4L.VehicleGod.PermanentModels or {}

local function cfg()
    return G4L.Config and G4L.Config.VehicleGod or {}
end

function G4L.VehicleGod.GetConfig()
    return cfg()
end

function G4L.VehicleGod.IsEnabled()
    return cfg().Enabled ~= false
end

function G4L.VehicleGod.NormalizeModel(model)
    if not isstring(model) or model == "" then return "" end
    return string.lower(model)
end

function G4L.VehicleGod.IsSVMODLoaded()
    return SVMOD ~= nil
end

function G4L.VehicleGod.GetDriverSeat(veh)
    if not G4L.VehicleGod.IsSVMODLoaded() then return nil end
    if not SVMOD:IsVehicle(veh) then return nil end
    if veh.SV_IsPassengerSeat and veh:SV_IsPassengerSeat() then
        return veh:SV_GetDriverSeat()
    end
    return veh
end

function G4L.VehicleGod.IsSVMODVehicle(veh)
    if not G4L.VehicleGod.IsSVMODLoaded() then return false end
    return SVMOD:IsVehicle(veh)
end

function G4L.VehicleGod.ResolveSeat(ent, maxDepth)
    if not IsValid(ent) then return nil end
    maxDepth = maxDepth or 8

    local function tryEntity(e)
        if G4L.VehicleGod.IsSVMODVehicle(e) then
            return G4L.VehicleGod.GetDriverSeat(e)
        end
    end

    local seat = tryEntity(ent)
    if IsValid(seat) then return seat end

    local parent = ent:GetParent()
    local depth = 0
    while IsValid(parent) and depth < maxDepth do
        seat = tryEntity(parent)
        if IsValid(seat) then return seat end
        parent = parent:GetParent()
        depth = depth + 1
    end

    if ent.GetChildren then
        for _, child in ipairs(ent:GetChildren()) do
            seat = tryEntity(child)
            if IsValid(seat) then return seat end
        end
    end

    if ent:IsVehicle() then
        seat = tryEntity(ent)
        if IsValid(seat) then return seat end
    end

    return nil
end

function G4L.VehicleGod.IsAdmin(ply)
    if not IsValid(ply) then return false end
    if ply:IsSuperAdmin() then return true end
    local groups = cfg().AdminGroups or {}
    return groups[string.lower(ply:GetUserGroup() or "")] == true
end

function G4L.VehicleGod.GetVehicleModel(seat)
    if not IsValid(seat) then return "" end
    seat = G4L.VehicleGod.GetDriverSeat(seat) or seat
    return G4L.VehicleGod.NormalizeModel(seat:GetModel())
end

function G4L.VehicleGod.ModelInList(model, list)
    if not list then return false end
    model = G4L.VehicleGod.NormalizeModel(model)
    for _, entry in ipairs(list) do
        if G4L.VehicleGod.NormalizeModel(entry) == model then
            return true
        end
    end
    return false
end

function G4L.VehicleGod.GetConfigMatch(seat)
    if not IsValid(seat) then return nil end

    local model = G4L.VehicleGod.GetVehicleModel(seat)

    if G4L.VehicleGod.ModelInList(model, cfg().AlwaysGodModels) then
        return { source = "always_model", id = model, label = model, locked = true }
    end

    for id, entry in pairs(cfg().Vehicles or {}) do
        if istable(entry) and G4L.VehicleGod.ModelInList(model, entry.models) then
            return {
                source = "config",
                id = id,
                label = entry.label or id,
                locked = true,
            }
        end
    end

    return nil
end

function G4L.VehicleGod.IsConfigLocked(seat)
    return G4L.VehicleGod.GetConfigMatch(seat) ~= nil
end

function G4L.VehicleGod.IsPermanentModel(model)
    model = G4L.VehicleGod.NormalizeModel(model)
    if model == "" then return false end

    if SERVER and G4L.VehicleGod.Store and G4L.VehicleGod.Store.IsPermanentModel then
        return G4L.VehicleGod.Store.IsPermanentModel(model)
    end

    return G4L.VehicleGod.PermanentModels[model] == true
end

function G4L.VehicleGod.ShouldBeGod(seat)
    if not G4L.VehicleGod.IsEnabled() then return false end
    if not IsValid(seat) then return false end
    if G4L.VehicleGod.GetConfigMatch(seat) then return true end

    local model = G4L.VehicleGod.GetVehicleModel(seat)
    return G4L.VehicleGod.IsPermanentModel(model)
end

function G4L.VehicleGod.IsGod(seat)
    return G4L.VehicleGod.ShouldBeGod(seat)
end

function G4L.VehicleGod.GetHudConfig()
    return cfg().Hud or {}
end

local HUD_NW = "G4L_VehicleGod_Hud"

function G4L.VehicleGod.IsStaffHudEnabled(ply)
    if not IsValid(ply) then return false end
    return ply:GetNWBool(HUD_NW, false)
end

function G4L.VehicleGod.CanDrawHud(ply)
    local hud = G4L.VehicleGod.GetHudConfig()
    if hud.AdminsOnly ~= false and not G4L.VehicleGod.IsAdmin(ply) then return false end
    return G4L.VehicleGod.IsStaffHudEnabled(ply)
end

function G4L.VehicleGod.CanDrawAdminCrosshair(ply)
    if not G4L.VehicleGod.CanDrawHud(ply) then return false end
    return G4L.VehicleGod.GetHudConfig().AdminCrosshair ~= false
end

function G4L.VehicleGod.CanDrawPlayerIndicator(ply)
    if not G4L.VehicleGod.CanDrawHud(ply) then return false end
    return G4L.VehicleGod.GetHudConfig().PlayerIndicator ~= false
end

G4L.VehicleGod.HudNWKey = HUD_NW
