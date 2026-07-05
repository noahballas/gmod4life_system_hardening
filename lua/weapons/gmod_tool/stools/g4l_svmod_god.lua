TOOL.Category = "GMod4Life"
TOOL.Name = "#tool.g4l_svmod_god.name"
TOOL.Command = nil
TOOL.ConfigName = ""

if CLIENT then
    language.Add("tool.g4l_svmod_god.name", "G4L SVMOD God")
    language.Add("tool.g4l_svmod_god.desc", "Toggle god mode on SVMOD vehicles")
    language.Add("tool.g4l_svmod_god.left", "Toggle god mode")
    language.Add("tool.g4l_svmod_god.right", "Repair vehicle")
    language.Add("tool.g4l_svmod_god.reload", "Vehicle info")
end

local function isAdmin(ply)
    return G4L and G4L.VehicleGod and G4L.VehicleGod.IsAdmin(ply)
end

local function getVehicle(trace)
    if not IsValid(trace.Entity) then return nil end
    return G4L.VehicleGod.ResolveSeat(trace.Entity)
end

function TOOL:LeftClick(trace)
    if CLIENT then return true end
    if not isAdmin(self:GetOwner()) then return false end

    local seat = getVehicle(trace)
    if not IsValid(seat) then return false end

    G4L.VehicleGod.TogglePermanent(seat, self:GetOwner())
    return true
end

function TOOL:RightClick(trace)
    if CLIENT then return true end
    if not isAdmin(self:GetOwner()) then return false end

    local seat = getVehicle(trace)
    if not IsValid(seat) then return false end

    self:GetOwner():ConCommand("g4l_god_repair")
    return true
end

function TOOL:Reload(trace)
    if CLIENT then return true end
    if not isAdmin(self:GetOwner()) then return false end
    return IsValid(getVehicle(trace))
end

function TOOL:DrawHUD()
    if not G4L or not G4L.VehicleGod then return end
    if not G4L.VehicleGod.IsAdmin(LocalPlayer()) then return end

    draw.SimpleText(G4L.VehicleGod.L("addon_name"), "G4L.VehicleGod:Bold18", 20, ScrH() - 72, Color(255, 210, 80), TEXT_ALIGN_LEFT)
    draw.SimpleText(G4L.VehicleGod.L("tool_hud"), "G4L.VehicleGod:Bold14", 20, ScrH() - 50, Color(255, 255, 255), TEXT_ALIGN_LEFT)

    if not G4L.VehicleGod.IsSVMODLoaded() then
        draw.SimpleText(G4L.VehicleGod.L("no_svmod"), "G4L.VehicleGod:Bold14", 20, ScrH() - 30, Color(255, 120, 120), TEXT_ALIGN_LEFT)
    end
end

function TOOL.BuildCPanel(panel)
    panel:Help(G4L and G4L.VehicleGod and G4L.VehicleGod.L("tool_desc") or "Toggle god mode on SVMOD vehicles.")
    panel:Help(G4L.VehicleGod.L("menu_command"))
    panel:Help("g4l_god_toggle | g4l_god_add | g4l_god_remove | g4l_god_menu")
end
