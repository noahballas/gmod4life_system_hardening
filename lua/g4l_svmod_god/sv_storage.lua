if CLIENT then return end

G4L.VehicleGod.Store = G4L.VehicleGod.Store or {}

local function getStorePath()
    local dir = G4L.VehicleGod.GetConfig().DataDir or "g4l_svmod_god"
    return dir .. "/permanent_models.json"
end

function G4L.VehicleGod.Store.Load()
    local path = getStorePath()
    if not file.Exists(path, "DATA") then
        return { models = {} }
    end

    local raw = file.Read(path, "DATA")
    local data = util.JSONToTable(raw or "") or {}
    data.models = data.models or {}
    return data
end

function G4L.VehicleGod.Store.Save(data)
    local path = getStorePath()
    local dir = G4L.VehicleGod.GetConfig().DataDir or "g4l_svmod_god"
    file.CreateDir(dir)
    file.Write(path, util.TableToJSON(data, true))
end

function G4L.VehicleGod.Store.SetPermanentModel(model, enabled, meta)
    model = G4L.VehicleGod.NormalizeModel(model)
    if model == "" then return end

    local data = G4L.VehicleGod.Store.Load()

    if enabled then
        data.models[model] = {
            model = model,
            label = meta and meta.label or model,
            added_at = os.time(),
            by = meta and meta.by or "",
        }
    else
        data.models[model] = nil
    end

    G4L.VehicleGod.Store.Save(data)
end

function G4L.VehicleGod.Store.GetPermanentModels()
    return G4L.VehicleGod.Store.Load().models or {}
end

function G4L.VehicleGod.Store.IsPermanentModel(model)
    model = G4L.VehicleGod.NormalizeModel(model)
    if model == "" then return false end
    return G4L.VehicleGod.Store.GetPermanentModels()[model] ~= nil
end

function G4L.VehicleGod.Store.ClearPermanent()
    G4L.VehicleGod.Store.Save({ models = {} })
end

function G4L.VehicleGod.Store.BuildMenuPayload(ply)
    local payload = {
        config = {},
        permanent = {},
        world = {},
        hud_enabled = IsValid(ply) and G4L.VehicleGod.IsStaffHudEnabled(ply) or false,
    }

    for id, entry in pairs(G4L.VehicleGod.GetConfig().Vehicles or {}) do
        table.insert(payload.config, {
            id = id,
            label = entry.label or id,
            models = entry.models or {},
        })
    end

    for model, entry in pairs(G4L.VehicleGod.Store.GetPermanentModels()) do
        table.insert(payload.permanent, {
            model = model,
            label = entry.label or model,
            by = entry.by or "",
        })
    end

    for _, seat in ipairs(ents.GetAll()) do
        if G4L.VehicleGod.IsSVMODVehicle(seat) and seat.SV_IsDriverSeat and seat:SV_IsDriverSeat() then
            if G4L.VehicleGod.IsGod(seat) then
                table.insert(payload.world, {
                    model = seat:GetModel() or "",
                    source = G4L.VehicleGod.GetSourceLabel(seat),
                })
            end
        end
    end

    table.sort(payload.config, function(a, b) return a.id < b.id end)
    table.sort(payload.permanent, function(a, b) return (a.label or a.model) < (b.label or b.model) end)
    table.sort(payload.world, function(a, b) return (a.model or "") < (b.model or "") end)

    return payload
end
