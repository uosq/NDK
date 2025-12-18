# Navet's Development Kit for Lmaobox

Made to help people make Lua Scripts for Lmaobox

## How to build

* Requirements
	* [Luabundler Cli](https://github.com/Benjamin-Dobell/luabundler)

Instructions:

* Run `build.sh`. If it doesn't exist, a `build` folder will be created


## How to use

1. Require `ndk.lua`
2. Use some functions
3. That's it :)

Example

```lua title="Convert a Entity to CTFPlayer"
local ndk = require("ndk")
local localPlayer = ndk.Reinterpret(entities.GetLocalPlayer(), ndk.GetPlayerClass())
assert(localPlayer)
print(localPlayer:m_nTickBase())
---output: 12345678
```

## How to use CVar manager

Example

```lua title="Get a ConVar value"
local ndk = require("ndk")
local cvarManager = ndk.GetConVarManager()

cvarManager:Init() --- start our manager
cvarManager:RegisterConVar("helloworld", 10.0)

local cvar = cvarManager:GetConVar("helloworld")
print(cvar:GetNumber(), cvar:GetString())

---output:
---10
---10.0
```

## How to **Reinterpret**

`ndk.Reinterpret` is a special function that converts a `Entity` or `table` into the specified class (second parameter)

Example

```lua title="Reinterpreting local player's weapon to Weapon"
local ndk = require("ndk")
local localPlayer = ndk.Reinterpret(entities.GetLocalPlayer(), ndk.GetPlayerClass())
assert(localPlayer, "Local player is nil!")

local weapon = ndk.Reinterpret(localplayer:m_hActiveWeapon(), ndk.GetWeaponClass())
assert(weapon, "Weapon is nil!")

print(weapon:CanPrimaryAttack())
print(weapon:m_iClip1())
```