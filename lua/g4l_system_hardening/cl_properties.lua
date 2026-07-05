local function canUseGodProperty(ent, ply)
    if not IsValid(ent) or not IsValid(ply) then return false end
    if not G4L.VehicleGod.IsAdmin(ply) then return false end
    if not G4L.VehicleGod.IsSVMODLoaded() then return false end
    return IsValid(G4L.VehicleGod.ResolveSeat(ent))
end

hook.Add("CanProperty", "G4L.SystemHardening:AllowProperty", function(ply, property, ent)
    if property ~= "g4l_system_hardening_toggle" then return end
    if canUseGodProperty(ent, ply) then return true end
    return false
end)

properties.Add("g4l_system_hardening_toggle", {
    MenuLabel = "Blindage SVMOD permanent",
    Order = 651,
    MenuIcon = "icon16/shield.png",

    Filter = function(self, ent, ply)
        if not canUseGodProperty(ent, ply) then return false end
        self.target = G4L.VehicleGod.ResolveSeat(ent)
        return IsValid(self.target)
    end,

    Action = function(self, ent)
        if not G4L.VehicleGod.IsAdmin(LocalPlayer()) then return end

        local seat = G4L.VehicleGod.ResolveSeat(ent) or self.target
        if not IsValid(seat) then return end

        net.Start("G4L.VehicleGod:Toggle")
            net.WriteEntity(seat)
        net.SendToServer()
    end,

    OnCreate = function(self, menu, option)
        if not IsValid(self.target) then return end

        if G4L.VehicleGod.IsConfigLocked(self.target) then
            option:SetText(G4L.VehicleGod.L("context_config"))
            option:SetIcon("icon16/lock.png")
            return
        end

        if G4L.VehicleGod.IsGod(self.target) then
            option:SetText(G4L.VehicleGod.L("context_remove_permanent"))
        else
            option:SetText(G4L.VehicleGod.L("context_add_permanent"))
        end
    end,
})
