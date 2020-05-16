local mod = {
  id = "weapon_select",
  name = "Weapon Select",
  version = "1.0.1",
  requirements = {},
  modApiVersion = "2.5.3",
  icon = "img/icon.png",
  loadedSquads = false
}

--- List of skills hidden in vanilla that this mod will add
local EXTRA_SKILLS = {
  "Passive_Ammo", "Vek_Beetle", "Vek_Hornet", "Vek_Scarab"
}
-- checks if the secret squad is unlocked
local function secretSquadUnlocked(self)
  return Profile and Profile.squads and Profile.squads[11]
end

--[[--
  Helper function to load mod scripts
  @param  name   Script path relative to mod directory
]]
function mod:loadScript(path)
  return require(self.scriptPath..path)
end

function mod:metadata()
end

function mod:init()
  for _, skill in ipairs(EXTRA_SKILLS) do
    modApi:addWeaponDrop(skill, false)
  end

  -- hide secret squad weapons when not unlocked
  Vek_Beetle.GetUnlocked = secretSquadUnlocked
  Vek_Hornet.GetUnlocked = secretSquadUnlocked
  Vek_Scarab.GetUnlocked = secretSquadUnlocked

  -- load in weapons from all mod squads
  -- done during first load so we run after mods have a chance to load
  modApi:addModsFirstLoadedHook(function()
    for _, squad in ipairs(modApi.mod_squads) do
      -- iterate through each squad member's skill list (skip 1 as its the squad name)
      for i = 2, #squad do
        local pawn = _G[squad[i]]
        if pawn ~= nil and type(pawn.SkillList) == "table" then
          for _, skill in ipairs(pawn.SkillList) do
            if modApi.weaponDeck[skill] == nil then
              -- default to false, in case there is a reason it was disabled
              modApi:addWeaponDrop(skill, false)
            end
          end
        end
      end
    end
  end)
end

function mod:load(options,version)
end

return mod
