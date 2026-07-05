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
