AddCSLuaFile("g4l_svmod_god/config.lua")
AddCSLuaFile("autorun/sh_g4l_svmod_god.lua")
AddCSLuaFile("g4l_svmod_god/sh_core.lua")
AddCSLuaFile("g4l_svmod_god/sh_lang.lua")
AddCSLuaFile("g4l_svmod_god/cl_fonts.lua")
AddCSLuaFile("g4l_svmod_god/cl_properties.lua")
AddCSLuaFile("g4l_svmod_god/cl_menu.lua")
AddCSLuaFile("g4l_svmod_god/cl_god.lua")
AddCSLuaFile("weapons/gmod_tool/stools/g4l_svmod_god.lua")

include("g4l_svmod_god/config.lua")
include("autorun/sh_g4l_svmod_god.lua")
include("g4l_svmod_god/sh_core.lua")
include("g4l_svmod_god/sh_lang.lua")

if SERVER then
    include("g4l_svmod_god/sv_storage.lua")
    include("g4l_svmod_god/sv_networking.lua")
    include("g4l_svmod_god/sv_god.lua")
end

if CLIENT then
    include("g4l_svmod_god/cl_fonts.lua")
    include("g4l_svmod_god/cl_properties.lua")
    include("g4l_svmod_god/cl_menu.lua")
    include("g4l_svmod_god/cl_god.lua")
end
