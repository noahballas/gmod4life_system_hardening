local function createFonts()
    surface.CreateFont("G4L.VehicleGod:Bold24", {
        font = "Montserrat Bold",
        size = 24,
        extended = true,
        antialias = true,
    })

    surface.CreateFont("G4L.VehicleGod:Bold20", {
        font = "Montserrat Bold",
        size = 20,
        extended = true,
        antialias = true,
    })

    surface.CreateFont("G4L.VehicleGod:Bold18", {
        font = "Montserrat Bold",
        size = 18,
        extended = true,
        antialias = true,
    })

    surface.CreateFont("G4L.VehicleGod:Bold14", {
        font = "Montserrat Bold",
        size = 14,
        extended = true,
        antialias = true,
    })
end

createFonts()
hook.Add("OnScreenSizeChanged", "G4L.VehicleGod:Fonts", createFonts)

net.Receive("G4L.VehicleGod:SyncPermanent", function()
    G4L.VehicleGod.PermanentModels = {}

    local count = net.ReadUInt(16)
    for i = 1, count do
        local model = net.ReadString()
        if model ~= "" then
            G4L.VehicleGod.PermanentModels[G4L.VehicleGod.NormalizeModel(model)] = true
        end
    end
end)

net.Receive("G4L.VehicleGod:Notify", function()
    local msg = net.ReadString()
    local typ = net.ReadUInt(3)

    local colors = {
        [0] = Color(120, 220, 160),
        [1] = Color(255, 120, 120),
        [2] = Color(255, 200, 80),
    }

    chat.AddText(colors[typ] or colors[0], "[G4L Hardening] ", Color(255, 255, 255), msg)
end)
