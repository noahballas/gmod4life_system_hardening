# GMod4Life System Hardening

**SVMod | Blindage système** — god mode **permanent** sur les véhicules **SVMOD**, par modèle.

Développé par **[GMod4Life](https://gmod4life-community.fr/)**, open source et **utilisable sur n'importe quel serveur** Garry's Mod équipé de SVMOD — pas réservé à la communauté GMod4Life.

> Version : **1.4.1**

Rendez vos véhicules SVMOD invulnérables de façon **permanente**, par modèle. Détection automatique au spawn, configuration lua, persistance JSON staff, menu admin et toolgun.

### Fonctionnalités

- God permanent SVMOD par modèle (`AlwaysGodModels`, `Vehicles`, `permanent_models.json`)
- Détection auto au spawn, patch dégâts SVMOD (santé, roues, collisions, explosions)
- Menu `g4l_god_menu`, toolgun, menu contextuel (C), API `G4L.VehicleGod.*`
- HUD staff activable/désactivable in-game (désactivé par défaut, staff only)
- Multilingue **FR / EN**

---

## Prérequis

- [SVMOD](https://github.com/TomLaVachette/svmod) installé et actif sur le serveur
- Véhicules compatibles SVMOD (`SVMOD:IsVehicle`)

---

## Installation

1. Placez le dossier `gmod4life_system_hardening` dans `garrysmod/addons/`
2. Redémarrez le serveur (ou `lua_refresh` en dev)
3. Configurez `lua/g4l_system_hardening/config.lua`
4. (Optionnel) Ajoutez des modèles en jeu via `g4l_god_menu` — sauvegardés dans `data/gmod4life_system_hardening/permanent_models.json`

---

## Fonctionnement

Un véhicule SVMOD est **invulnérable de façon permanente** si son **modèle** est présent dans :

| Source | Fichier | Retirable en jeu ? |
|--------|---------|-------------------|
| Config lua | `AlwaysGodModels` / `Vehicles["id"]` | Non — éditer `config.lua` |
| Staff | `data/gmod4life_system_hardening/permanent_models.json` | Oui — menu / toolgun / C |

À chaque spawn SVMOD, le modèle est détecté automatiquement. Le patch bloque santé, roues, collisions et explosions.

---

## Configuration

Fichier : `lua/g4l_system_hardening/config.lua`

```lua
G4L.Config.VehicleGod = {
    Enabled = true,
    DefaultLanguage = "fr",
    DataDir = "gmod4life_system_hardening",

    ApplyConfigOnSpawn = true,
    AutoRepairOnEnable = true,
    ProtectOccupants = false,

    Hud = {
        AdminCrosshair = true,
        PlayerIndicator = true,
        AdminsOnly = true,
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
| `g4l_god_menu` | Menu admin (config, JSON, véhicules actifs, toggle HUD) |
| `g4l_god_toggle` | Basculer blindage permanent du modèle visé |
| `g4l_god_add` | Ajouter le modèle visé au JSON permanent |
| `g4l_god_remove` | Retirer le modèle visé du JSON permanent |
| `g4l_god_list` | Lister tous les modèles blindés |
| `g4l_god_clear` | Vider le JSON (ne touche pas à `config.lua`) |
| `g4l_god_repair` | Réparer le véhicule SVMOD visé |
| `g4l_god_apply` | Réappliquer le blindage sur tous les véhicules SVMOD |

> Réservé aux groupes staff définis dans `AdminGroups`.

---

## Toolgun — System Hardening

Catégorie **GMod4Life** dans le menu toolgun.

| Action | Effet |
|--------|--------|
| Clic gauche | Basculer blindage permanent du modèle visé |
| Clic droit | Réparer le véhicule visé |
| Rechargement (R) | Infos véhicule visé |

---

## Menu contextuel (touche C)

- **Ajouter blindage permanent** — enregistre le modèle dans le JSON
- **Retirer blindage permanent** — retire le modèle du JSON
- **Blindage permanent (config)** — verrouillé via `config.lua` (cadenas)

---

## HUD staff

- **Désactivé par défaut** pour tous (y compris staff)
- Activable via **« Activer le HUD »** dans `g4l_god_menu`
- **Jamais visible** pour les joueurs normaux
- Affiche : infobox sur véhicule visé + badge en conduisant

Convar client (langue) :

```
g4l_system_hardening_lang fr   -- ou en
```

## Blindage temporaire vs permanent

| Système | Type | Addon |
|---------|------|-------|
| **Blindage permanent** | Invulnérabilité totale par modèle | `gmod4life_system_hardening` |
| **Blindage temporaire** | Anti-balles sur un véhicule (session) | `dmod_admin` (menu C staff) |

---

## Structure

```
gmod4life_system_hardening/
├── README.md
├── version.txt
└── lua/
    ├── autorun/g4l_system_hardening_init.lua
    ├── g4l_system_hardening/
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
    └── weapons/gmod_tool/stools/g4l_system_hardening.lua
```

---

## Compatibilité

- DarkRP (notifications si présent)
- Patch SVMOD non intrusif
- Multilingue **FR / EN**

---

## Crédits

Addon développé par **[GMod4Life](https://gmod4life-community.fr/)** — libre d'utilisation sur tout serveur Garry's Mod compatible SVMOD.
