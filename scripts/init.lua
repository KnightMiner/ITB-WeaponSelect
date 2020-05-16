local mod = {
  id = "weapon_select",
  name = "Weapon Select",
  version = "1.0.1",
  requirements = {},
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
  local shop = self:loadScript("shop")
  for _, skill in ipairs(EXTRA_SKILLS) do
    shop:addWeapon(skill, false)
  end

  -- hide secret squad weapons when not unlocked
  Vek_Beetle.GetUnlocked = secretSquadUnlocked
  Vek_Hornet.GetUnlocked = secretSquadUnlocked
  Vek_Scarab.GetUnlocked = secretSquadUnlocked
end

function mod:load(options,version)
  local shop = self:loadScript("shop")
  shop:load()

  -- load in weapons from all mod squads
  -- done during load so we run after the shop's load hook
  if not self.loadedSquads then
    self.loadedSquads = true
    modApi:addModsLoadedHook(function()
      for _, squad in ipairs(modApi.mod_squads) do
        -- iterate through each squad member's skill list
        for i = 2, #squad do
          local pawn = _G[squad[i]]
          if pawn ~= nil and pawn.SkillList ~= nil then
            for _, skill in ipairs(pawn.SkillList) do
              shop:addWeapon(skill, false)
            end
          end
        end
      end
    end)
  end
end

return mod
