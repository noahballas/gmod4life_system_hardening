G4L.VehicleGod.Lang = G4L.VehicleGod.Lang or {}

local phrases = {
    fr = {
        addon_name = "G4L SVMOD God",
        no_svmod = "SVMOD n'est pas installe sur ce serveur.",
        no_vehicle = "Visez un vehicule SVMOD valide.",
        no_permission = "Vous n'avez pas la permission.",
        god_permanent_added = "God permanent ajoute pour :model:",
        god_permanent_removed = "God permanent retire pour :model:",
        god_permanent_cleared = "Liste JSON des god permanents videe.",
        god_config_locked = "God permanent via config (:id:) — modifiez config.lua pour retirer.",
        god_already_permanent = "Ce modele est deja en god permanent.",
        god_not_permanent = "Ce modele n'est pas dans la liste permanente.",
        god_list_empty = "Aucun modele en god permanent.",
        hud_god = "GOD SVMOD",
        context_add_permanent = "Ajouter god permanent",
        context_remove_permanent = "Retirer god permanent",
        context_config = "God permanent (config)",
        tool_name = "G4L SVMOD God",
        tool_desc = "God permanent SVMOD — ajoute ou retire un modele de la liste",
        tool_left = "Basculer god permanent",
        tool_right = "Reparer le vehicule",
        tool_reload = "Infos vehicule",
        tool_hud = "Clic G : God permanent | Clic D : Reparation | R : Infos",
        info_health = "Sante : :current: / :max: (:percent:%)",
        info_model = "Modele : :model:",
        info_god = "God permanent : :state:",
        info_source = "Source : :source:",
        state_on = "OUI",
        state_off = "NON",
        source_config = "Config lua",
        source_always = "AlwaysGodModels",
        source_permanent = "JSON permanent",
        menu_title = "G4L SVMOD God — Permanent",
        menu_tab_config = "Config lua",
        menu_tab_permanent = "JSON permanent",
        menu_tab_world = "Monde (live)",
        menu_add_aim = "Ajouter le modele vise",
        menu_remove = "Retirer la selection JSON",
        menu_apply = "Reappliquer sur les vehicules",
        menu_reload = "Actualiser",
        menu_close = "Fermer",
        menu_col_id = "ID",
        menu_col_label = "Label",
        menu_col_model = "Modele",
        menu_col_source = "Source",
        menu_empty = "Aucune entree.",
        menu_hint_config = "God permanent par modele. Config lua + data/permanent_models.json",
        menu_command = "Commande : g4l_god_menu",
    },
    en = {
        addon_name = "G4L SVMOD God",
        no_svmod = "SVMOD is not installed on this server.",
        no_vehicle = "Aim at a valid SVMOD vehicle.",
        no_permission = "You do not have permission.",
        god_permanent_added = "Permanent god added for :model:",
        god_permanent_removed = "Permanent god removed for :model:",
        god_permanent_cleared = "Permanent JSON list cleared.",
        god_config_locked = "Permanent god via config (:id:) — edit config.lua to remove.",
        god_already_permanent = "This model is already permanently god.",
        god_not_permanent = "This model is not in the permanent list.",
        god_list_empty = "No permanently god models.",
        hud_god = "SVMOD GOD",
        context_add_permanent = "Add permanent god",
        context_remove_permanent = "Remove permanent god",
        context_config = "Permanent god (config)",
        tool_name = "G4L SVMOD God",
        tool_desc = "Permanent SVMOD god — add or remove a model from the list",
        tool_left = "Toggle permanent god",
        tool_right = "Repair vehicle",
        tool_reload = "Vehicle info",
        tool_hud = "LMB: Permanent god | RMB: Repair | R: Info",
        info_health = "Health: :current: / :max: (:percent:%)",
        info_model = "Model: :model:",
        info_god = "Permanent god: :state:",
        info_source = "Source: :source:",
        state_on = "YES",
        state_off = "NO",
        source_config = "Config lua",
        source_always = "AlwaysGodModels",
        source_permanent = "Permanent JSON",
        menu_title = "G4L SVMOD God — Permanent",
        menu_tab_config = "Config lua",
        menu_tab_permanent = "Permanent JSON",
        menu_tab_world = "World (live)",
        menu_add_aim = "Add aimed model",
        menu_remove = "Remove JSON selection",
        menu_apply = "Reapply on vehicles",
        menu_reload = "Refresh",
        menu_close = "Close",
        menu_col_id = "ID",
        menu_col_label = "Label",
        menu_col_model = "Model",
        menu_col_source = "Source",
        menu_empty = "No entries.",
        menu_hint_config = "Permanent god by model. Config lua + data/permanent_models.json",
        menu_command = "Command: g4l_god_menu",
    },
}

G4L.VehicleGod.Phrases = phrases

function G4L.VehicleGod.GetLangCode(ply)
    if CLIENT and IsValid(ply) and ply == LocalPlayer() then
        local cvar = GetConVar("g4l_svmod_god_lang")
        if cvar and cvar:GetString() ~= "" then
            return string.lower(cvar:GetString())
        end
    end

    if IsValid(ply) then
        local lang = ply:GetNWString("G4L_Lang", "")
        if lang ~= "" then return string.lower(lang) end
    end

    local cfgLang = G4L.Config and G4L.Config.VehicleGod and G4L.Config.VehicleGod.DefaultLanguage
    if isstring(cfgLang) and cfgLang ~= "" then
        return string.lower(cfgLang)
    end

    return "fr"
end

function G4L.VehicleGod.L(key, replacements, ply)
    local lang = G4L.VehicleGod.GetLangCode(ply)
    local pack = phrases[lang] or phrases.fr
    local text = pack[key] or phrases.en[key] or key

    if replacements then
        for k, v in pairs(replacements) do
            text = string.Replace(text, ":" .. k .. ":", tostring(v))
        end
    end

    return text
end

function G4L.VehicleGod.GetSourceLabel(seat, ply)
    local match = G4L.VehicleGod.GetConfigMatch(seat)
    if match then
        if match.source == "always_model" then
            return G4L.VehicleGod.L("source_always", nil, ply)
        end
        return G4L.VehicleGod.L("source_config", nil, ply) .. " (" .. match.id .. ")"
    end

    local model = G4L.VehicleGod.GetVehicleModel(seat)
    if model ~= "" and G4L.VehicleGod.IsPermanentModel(model) then
        return G4L.VehicleGod.L("source_permanent", nil, ply)
    end

    return "-"
end

if CLIENT then
    CreateClientConVar("g4l_svmod_god_lang", "", true, false, "G4L SVMOD God language (fr/en, empty = auto)")
end
