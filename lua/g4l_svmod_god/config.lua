--[[
    G4L SVMOD God — God PERMANENT par modele
    Tout vehicule SVMOD dont le modele est liste ici ou en JSON reste invulnerable.
]]

G4L = G4L or {}
G4L.Config = G4L.Config or {}

G4L.Config.VehicleGod = {
    Enabled = true,
    DefaultLanguage = "fr",

    -- Fichier des modeles ajoutes en jeu : data/g4l_svmod_god/permanent_models.json
    DataDir = "g4l_svmod_god",

    ApplyConfigOnSpawn = true,
    AutoRepairOnEnable = true,
    ProtectOccupants = false,
    ShowHudIndicator = true,

    AdminGroups = {
        ["superadmin"] = true,
        ["super-admin"] = true,
        ["responsable"] = true,
        ["Res.SuperAdmin"] = true,
        ["administrateur"] = true,
        ["admin"] = true,
        ["moderateur"] = true,
        ["modo"] = true,
    },

    -- Modeles en god permanent (config lua, redemarrage requis pour retirer)
    AlwaysGodModels = {
        -- "models/tdmcars/courier_truck.mdl",
        -- "models/lonewolfie/dodge_charger_2015_police.mdl",
    },

    -- Entrees par ID — god permanent par modele
    Vehicles = {
        --[[
        ["police"] = {
            label = "Voiture police",
            models = { "models/lonewolfie/dodge_charger_2015_police.mdl" },
        },
        ]]
    },
}
