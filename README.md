# SVMod | Blindage système

Addon **GMod4Life** pour Garry's Mod — god mode **permanent** sur les véhicules **SVMOD**, par modèle.

> Version : **1.4.1**

---

## Prérequis

- [SVMOD](https://github.com/TomLaVachette/svmod) installé et actif sur le serveur
- Véhicules compatibles SVMOD (`SVMOD:IsVehicle`)

---

## Installation

1. Placez le dossier `gmod4life_svmod_god` dans `garrysmod/addons/`
2. Redémarrez le serveur (ou `lua_refresh` en dev)
3. Configurez `lua/g4l_svmod_god/config.lua`
4. (Optionnel) Ajoutez des modèles en jeu via `g4l_god_menu` — sauvegardés dans `data/g4l_svmod_god/permanent_models.json`

---

## Fonctionnement

Un véhicule SVMOD est **invulnérable de façon permanente** si son **modèle** est présent dans :

| Source | Fichier | Retirable en jeu ? |
|--------|---------|-------------------|
| Config lua | `AlwaysGodModels` / `Vehicles["id"]` | Non — éditer `config.lua` |
| Staff | `data/g4l_svmod_god/permanent_models.json` | Oui — menu / toolgun / C |

À chaque spawn SVMOD, le modèle est détecté automatiquement. Le patch bloque santé, roues, collisions et explosions.

---

## Configuration

Fichier : `lua/g4l_svmod_god/config.lua`

```lua
G4L.Config.VehicleGod = {
    Enabled = true,
    DefaultLanguage = "fr",

    ApplyConfigOnSpawn = true,
    AutoRepairOnEnable = true,
    ProtectOccupants = false,

    Hud = {
        AdminCrosshair = true,   -- infobox véhicule visé
        PlayerIndicator = true,  -- badge "GOD SVMOD"
        AdminsOnly = true,       -- jamais visible pour les joueurs
    },

    AdminGroups = { ... },

    AlwaysGodModels = {
        "models/lonewolfie/bugatti_veyron_grandsport.mdl",
    },

    Vehicles = {
        ["police"] = {
            label = "Voiture police",
            models = { "models/lonewolfie/dodge_charger_2015_police.mdl" },
        },
    },
}
```

---

## Commandes

| Commande | Description |
|----------|-------------|
| `g4l_god_menu` | Menu admin (config, JSON, véhicules actifs, **toggle HUD**) |
| `g4l_god_toggle` | Basculer god permanent du modèle visé |
| `g4l_god_add` | Ajouter le modèle visé au JSON permanent |
| `g4l_god_remove` | Retirer le modèle visé du JSON permanent |
| `g4l_god_list` | Lister tous les modèles en god permanent |
| `g4l_god_clear` | Vider le JSON (ne touche pas à `config.lua`) |
| `g4l_god_repair` | Réparer le véhicule SVMOD visé |
| `g4l_god_apply` | Réappliquer le blindage sur tous les véhicules SVMOD |

> Réservé aux groupes staff définis dans `AdminGroups`.

---

## Toolgun — G4L SVMOD God

Catégorie **GMod4Life** dans le menu toolgun.

| Action | Effet |
|--------|--------|
| Clic gauche | Basculer god permanent du modèle visé |
| Clic droit | Réparer le véhicule visé |
| Rechargement (R) | Infos véhicule visé |

---

## Menu contextuel (touche C)

- **Ajouter god permanent** — enregistre le modèle dans le JSON
- **Retirer god permanent** — retire le modèle du JSON
- **God permanent (config)** — verrouillé via `config.lua` (cadenas)

---

## HUD staff

- **Désactivé par défaut** pour tous (y compris staff)
- Activable via le bouton **« Activer le HUD »** dans `g4l_god_menu`
- **Jamais visible** pour les joueurs normaux (`AdminsOnly = true`)
- Affiche : infobox sur véhicule visé + badge en conduisant

Convar client (langue uniquement) :

```
g4l_svmod_god_lang fr   -- ou en
```

---

## API développeur

```lua
G4L.VehicleGod.IsGod(seat)
G4L.VehicleGod.ShouldBeGod(seat)
G4L.VehicleGod.GetConfigMatch(seat)
G4L.VehicleGod.IsPermanentModel(model)
G4L.VehicleGod.ResolveSeat(ent)
G4L.VehicleGod.AddPermanent(seat, ply)
G4L.VehicleGod.RemovePermanent(seat, ply)
G4L.VehicleGod.TogglePermanent(seat, ply)
```

---

## Blindage temporaire vs permanent

| Système | Type | Addon |
|---------|------|-------|
| **God permanent** | Invulnérabilité totale par modèle | `gmod4life_svmod_god` |
| **Blindage temporaire** | Anti-balles sur un véhicule (session) | `dmod_admin` (menu C staff) |

Les deux systèmes sont **indépendants**.

---

## Structure

```
gmod4life_svmod_god/
├── README.md
├── version.txt
└── lua/
    ├── autorun/g4l_svmod_god_init.lua
    ├── g4l_svmod_god/
    │   ├── config.lua
    │   ├── sh_core.lua
    │   ├── sh_lang.lua
    │   ├── sv_god.lua
    │   ├── sv_storage.lua
    │   ├── sv_networking.lua
    │   ├── cl_menu.lua
    │   ├── cl_god.lua
    │   ├── cl_properties.lua
    │   └── cl_fonts.lua
    └── weapons/gmod_tool/stools/g4l_svmod_god.lua
```

---

## Compatibilité

- DarkRP (notifications si présent)
- Patch SVMOD non intrusif
- Multilingue **FR / EN**

---

## GMod4Life

Développé pour [GMod4Life](https://gmod4life-community.fr/) — code sécurisé, config claire, prêt production.

**Licence** — voir les conditions GModStore / G4L.
