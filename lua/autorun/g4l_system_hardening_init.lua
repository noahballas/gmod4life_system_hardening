AddCSLuaFile("g4l_system_hardening/config.lua")
AddCSLuaFile("g4l_system_hardening/sh_core.lua")
AddCSLuaFile("g4l_system_hardening/sh_lang.lua")
AddCSLuaFile("g4l_system_hardening/cl_fonts.lua")
AddCSLuaFile("g4l_system_hardening/cl_menu.lua")
AddCSLuaFile("g4l_system_hardening/cl_god.lua")
AddCSLuaFile("weapons/gmod_tool/stools/g4l_system_hardening.lua")

include("g4l_system_hardening/config.lua")
include("g4l_system_hardening/sh_core.lua")
include("g4l_system_hardening/sh_lang.lua")

if SERVER then
    include("g4l_system_hardening/sv_storage.lua")
    include("g4l_system_hardening/sv_networking.lua")
    include("g4l_system_hardening/sv_god.lua")
end

if CLIENT then
    include("g4l_system_hardening/cl_fonts.lua")
    include("g4l_system_hardening/cl_menu.lua")
    include("g4l_system_hardening/cl_god.lua")
end
