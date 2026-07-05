# GMod4Life System Hardening

> Version: **1.4.1**  
> Default language: **English** (`DefaultLanguage = "en"` in `config.lua`)  
> Available languages: **EN / FR**

Developed by **[GMod4Life](https://gmod4life-community.fr/)** — open source and usable on **any** Garry's Mod server running SVMOD.

---

## English

**SVMod | System Hardening** — permanent god mode for **SVMOD** vehicles, by model.

Make SVMOD vehicles **permanently invulnerable** by model. Automatic detection on spawn, lua configuration, staff JSON persistence, admin menu, and toolgun.

### Features

- Permanent SVMOD god by model (`AlwaysGodModels`, `Vehicles`, `permanent_models.json`)
- Auto detection on spawn, SVMOD damage patch (health, wheels, collisions, explosions)
- `g4l_god_menu` menu, toolgun, context menu (C), `G4L.VehicleGod.*` API
- Toggleable staff HUD (disabled by default, staff only)
- Multilingual **EN / FR**

### Requirements

- [SVMOD](https://github.com/TomLaVachette/svmod) installed and active
- SVMOD-compatible vehicles (`SVMOD:IsVehicle`)

### Installation

1. Place `gmod4life_system_hardening` in `garrysmod/addons/`
2. Restart the server (or `lua_refresh` in dev)
3. Edit `lua/g4l_system_hardening/config.lua`
4. (Optional) Add models in-game via `g4l_god_menu` — saved to `data/gmod4life_system_hardening/permanent_models.json`

### How it works

A SVMOD vehicle is **permanently invulnerable** if its **model** is listed in:

| Source | File | Removable in-game? |
|--------|------|--------------------|
| Lua config | `AlwaysGodModels` / `Vehicles["id"]` | No — edit `config.lua` |
| Staff | `data/gmod4life_system_hardening/permanent_models.json` | Yes — menu / toolgun / C |

On every SVMOD spawn, the model is detected automatically. The patch blocks health, wheels, collisions, and explosions.

### Configuration

File: `lua/g4l_system_hardening/config.lua`

```lua
G4L.Config.VehicleGod = {
    Enabled = true,
    DefaultLanguage = "en",
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
            label = "Police car",
            models = { "models/lonewolfie/dodge_charger_2015_police.mdl" },
        },
    },
}
```

Set `DefaultLanguage = "fr"` for French.

### Commands

| Command | Description |
|---------|-------------|
| `g4l_god_menu` | Admin menu (config, JSON, live vehicles, HUD toggle) |
| `g4l_god_toggle` | Toggle permanent hardening for aimed model |
| `g4l_god_add` | Add aimed model to permanent JSON |
| `g4l_god_remove` | Remove aimed model from permanent JSON |
| `g4l_god_list` | List all hardened models |
| `g4l_god_clear` | Clear JSON (does not touch `config.lua`) |
| `g4l_god_repair` | Repair aimed SVMOD vehicle |
| `g4l_god_apply` | Reapply hardening on all SVMOD vehicles |

> Restricted to staff groups defined in `AdminGroups`.

### Toolgun — System Hardening

Category **GMod4Life** in the toolgun menu.

| Action | Effect |
|--------|--------|
| Left click | Toggle permanent hardening for aimed model |
| Right click | Repair aimed vehicle |
| Reload (R) | Vehicle info |

### Context menu (C key)

> Provided by **`dmod_admin`** (`cl_context_options.lua` → vehicle **Delete**) when both addons are installed.

- **Add permanent hardening** — saves model to JSON
- **Remove permanent hardening** — removes model from JSON
- **Permanent hardening (config)** — locked via `config.lua` (padlock)

### Staff HUD

- **Disabled by default** for everyone (including staff)
- Enable via **"Enable HUD"** in `g4l_god_menu`
- **Never visible** to regular players
- Shows: infobox on aimed vehicle + badge while driving

Client convar (language override):

```
g4l_system_hardening_lang en   -- or fr (empty = auto from config)
```

### Permanent vs temporary hardening

| System | Type | Addon |
|--------|------|-------|
| **Permanent hardening** | Full invulnerability by model | `gmod4life_system_hardening` |
| **Temporary hardening** | Bullet protection on one vehicle (session) | `dmod_admin` (staff C menu) |

### File structure

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
    │   └── cl_fonts.lua
    └── weapons/gmod_tool/stools/g4l_system_hardening.lua
```

### Compatibility

- DarkRP (notifications if present)
- Non-intrusive SVMOD patch
- Multilingual **EN / FR**

---

## Français

**SVMod | Blindage système** — god mode **permanent** sur les véhicules **SVMOD**, par modèle.

Rendez vos véhicules SVMOD invulnérables de façon **permanente**, par modèle. Détection automatique au spawn, configuration lua, persistance JSON staff, menu admin et toolgun.

### Fonctionnalités

- God permanent SVMOD par modèle (`AlwaysGodModels`, `Vehicles`, `permanent_models.json`)
- Détection auto au spawn, patch dégâts SVMOD (santé, roues, collisions, explosions)
- Menu `g4l_god_menu`, toolgun, menu contextuel (C), API `G4L.VehicleGod.*`
- HUD staff activable/désactivable in-game (désactivé par défaut, staff only)
- Multilingue **EN / FR**

### Prérequis

- [SVMOD](https://github.com/TomLaVachette/svmod) installé et actif sur le serveur
- Véhicules compatibles SVMOD (`SVMOD:IsVehicle`)

### Installation

1. Placez le dossier `gmod4life_system_hardening` dans `garrysmod/addons/`
2. Redémarrez le serveur (ou `lua_refresh` en dev)
3. Configurez `lua/g4l_system_hardening/config.lua`
4. (Optionnel) Ajoutez des modèles en jeu via `g4l_god_menu` — sauvegardés dans `data/gmod4life_system_hardening/permanent_models.json`

### Fonctionnement

Un véhicule SVMOD est **invulnérable de façon permanente** si son **modèle** est présent dans :

| Source | Fichier | Retirable en jeu ? |
|--------|---------|-------------------|
| Config lua | `AlwaysGodModels` / `Vehicles["id"]` | Non — éditer `config.lua` |
| Staff | `data/gmod4life_system_hardening/permanent_models.json` | Oui — menu / toolgun / C |

À chaque spawn SVMOD, le modèle est détecté automatiquement. Le patch bloque santé, roues, collisions et explosions.

### Configuration

Fichier : `lua/g4l_system_hardening/config.lua`

```lua
G4L.Config.VehicleGod = {
    Enabled = true,
    DefaultLanguage = "en",  -- mettre "fr" pour le français
    DataDir = "gmod4life_system_hardening",
    -- ...
}
```

### Commandes

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

### Toolgun — System Hardening

Catégorie **GMod4Life** dans le menu toolgun.

| Action | Effet |
|--------|--------|
| Clic gauche | Basculer blindage permanent du modèle visé |
| Clic droit | Réparer le véhicule visé |
| Rechargement (R) | Infos véhicule visé |

### Menu contextuel (touche C)

> Option fournie par **`dmod_admin`** si les deux addons sont installés.

- **Ajouter blindage permanent** — enregistre le modèle dans le JSON
- **Retirer blindage permanent** — retire le modèle du JSON
- **Blindage permanent (config)** — verrouillé via `config.lua`

### HUD staff

- **Désactivé par défaut** pour tous (y compris staff)
- Activable via **« Activer le HUD »** dans `g4l_god_menu`
- **Jamais visible** pour les joueurs normaux

Convar client (langue) :

```
g4l_system_hardening_lang fr   -- ou en (vide = config serveur)
```

### Blindage temporaire vs permanent

| Système | Type | Addon |
|---------|------|-------|
| **Blindage permanent** | Invulnérabilité totale par modèle | `gmod4life_system_hardening` |
| **Blindage temporaire** | Anti-balles sur un véhicule (session) | `dmod_admin` (menu C staff) |

### Compatibilité

- DarkRP (notifications si présent)
- Patch SVMOD non intrusif
- Multilingue **EN / FR**

---

## Credits / Crédits

Addon developed by **[GMod4Life](https://gmod4life-community.fr/)** — free to use on any SVMOD-compatible Garry's Mod server.

Addon développé par **[GMod4Life](https://gmod4life-community.fr/)** — libre d'utilisation sur tout serveur Garry's Mod compatible SVMOD.
