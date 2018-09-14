	if myHero.charName ~= "Pantheon" then return end
	
	local _shadow = myHero.pos
	
	require "DamageLib"
	
	keybindings = { [ITEM_1] = HK_ITEM_1, [ITEM_2] = HK_ITEM_2, [ITEM_3] = HK_ITEM_3, [ITEM_4] = HK_ITEM_4, [ITEM_5] = HK_ITEM_5, [ITEM_6] = HK_ITEM_6}


local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
function SetMovement(bool)
	if _G.EOWLoaded then
		EOW:SetMovements(bool)
		EOW:SetAttacks(bool)
	elseif _G.SDK then
		SDK.Orbwalker:SetMovement(bool)
		SDK.Orbwalker:SetAttack(bool)
	else
		GOS.BlockMovement = not bool
		GOS.BlockAttack = not bool
	end
	if bool then
		castSpell.state = 0
	end
end

class "Pantheon"
local Scriptname, Version, = "Attempted Pantheon","v1.0"
end

function Pantheon:_init
		self:LoadSpells()
		self:LoadMenu()
		Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	local orbwalkername = ""
	if _G.SDK then
		orbwalkername = "IC'S orbwalker"
	elseif _G.EOW then
		orbwalkername = "GSO orbwalker"	
	elseif _G.GOS then
		orbwalkername = "Noddy orbwalker"
	else
		orbwalkername = "Orbwalker not found"
	
	end
	PrintChat(Scriptname.." "..Version.." - Loaded..."..orbwalkername..)
end


--[[SPELLS]]
function Pantheon:LoadSpells()
	Q = {Delay = 0.25, Range = 600}
	W = {Delay = 0.25, Range = 600} 
	E = {Delay = 0.25, Range = 600}
	E = {Range = 5500}
end


function Pantheon:LoadMenu()
	self.menu = MenuElement({type = MENU, id = "Pantheon", name = "AttemptedPantheoN leftIcon="https://vignette.wikia.nocookie.net/leagueoflegends/images/9/98/Pantheon_DragonslayerSkin.jpg/revision/latest?cb=20170621200102"})
	
	--[[CUMbo]]
	self.menu:MenuElement({id = "Combo", name = "CUMbo"})
	self.Menu.Combo:MenuElement({id = "comboUseQ", name = "Use Q", value = true})
	self.Menu.Combo:MenuElement({id = "comboUseW", name = "Use W", value = true})
	self.Menu.Combo:MenuElement({id = "comboUseE", name = "Use E", value = true})
	self.Menu.Combo:MenuElement({id = "comboActive", name = "Combo key", key = string.byte(" ")})
	
	--[[Harass]]
	self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
	self.Menu.Harass:MenuElement({id = "harassUseQ", name = "Use Q", value = true})
	self.Menu.Harass:MenuElement({id = "harassUseW", name = "Use W", value = true})
	self.Menu.Harass:MenuElement({id = "harassUseE", name = "Use E", value = true})
	self.Menu.Harass:MenuElement({id = "harassMana", name = "Minimal mana percent:", value = 30, min = 0, max = 101, identifier = "%"})
	self.Menu.Harass:MenuElement({id = "harassActive", name = "Harass key", key = string.byte("C")})
	
	--[[Draw]]
	self.Menu:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
    self.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = true, tooltip = "Only draws spells when they're ready"})
    self.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = true}) 
	self.Menu.Draw:MenuElement({id = "DrawTarget", name = "Draw Target [?]", value = true, tooltip = "Draws current target"})
	
	 --Misc
	self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc"})
	self.Menu.Misc:MenuElement({id = "lvEnabled", name = "Enable AutoLeveler", value = true})
	self.Menu.Misc:MenuElement({id = "Block", name = "Block on Level 1", value = true})
	self.Menu.Misc:MenuElement({id = "Order", name = "Skill Priority", drop = {"[Q] - [W] - [E] > Max [Q]","[Q] - [E] - [W] > Max [Q]","[W] - [Q] - [E] > Max [W]","[W] - [E] - [Q] > Max [W]","[E] - [Q] - [W] > Max [E]","[E] - [W] - [Q] > Max [E]"}})
	
end
function Pantheon:AutoLevel()
  if self.Menu.Misc.lvEnabled:Value() == false then return end
  local Sequence = {
    [1] = { HK_Q, HK_W, HK_E, HK_Q, HK_Q, HK_R, HK_Q, HK_W, HK_Q, HK_W, HK_R, HK_W, HK_W, HK_E, HK_E, HK_R, HK_E, HK_E },
    [2] = { HK_Q, HK_E, HK_W, HK_Q, HK_Q, HK_R, HK_Q, HK_E, HK_Q, HK_E, HK_R, HK_E, HK_E, HK_W, HK_W, HK_R, HK_W, HK_W },
    [3] = { HK_W, HK_Q, HK_E, HK_W, HK_W, HK_R, HK_W, HK_Q, HK_W, HK_Q, HK_R, HK_Q, HK_Q, HK_E, HK_E, HK_R, HK_E, HK_E },
    [4] = { HK_W, HK_E, HK_Q, HK_W, HK_W, HK_R, HK_W, HK_E, HK_W, HK_E, HK_R, HK_E, HK_E, HK_Q, HK_Q, HK_R, HK_Q, HK_Q },
    [5] = { HK_E, HK_Q, HK_W, HK_E, HK_E, HK_R, HK_E, HK_Q, HK_E, HK_Q, HK_R, HK_Q, HK_Q, HK_W, HK_W, HK_R, HK_W, HK_W },
    [6] = { HK_E, HK_W, HK_Q, HK_E, HK_E, HK_R, HK_E, HK_W, HK_E, HK_W, HK_R, HK_W, HK_W, HK_Q, HK_Q, HK_R, HK_Q, HK_Q },
  }
  local Slot = nil
  local Tick = 0
  local SkillPoints = myHero.levelData.lvl - (myHero:GetSpellData(_Q).level + myHero:GetSpellData(_W).level + myHero:GetSpellData(_E).level + myHero:GetSpellData(_R).level)
  local level = myHero.levelData.lvl
  local Check = Sequence[self.Menu.Misc.Order:Value()][level - SkillPoints + 1]
  if SkillPoints > 0 then
    if self.Menu.Misc.Block:Value() and level == 1 then return end
    if GetTickCount() - Tick > 800 and
      Check ~= nil then
      Control.KeyDown(HK_LUS)
      Control.KeyDown(Check)
      Slot = Check
      Tick = GetTickCount()
    end
  end
  if Control.IsKeyDown(HK_LUS) then
    Control.KeyUp(HK_LUS)
  end
  if Slot and Control.IsKeyDown(Slot) then
    Control.KeyUp(Slot)
  end
end





function Pantheon:Tick()

if GOS:GetMode() == "Combo" then 
        self:Combo()
elseif GOS:GetMode() == "Harass" then 
        self:Harass()
elseif GOS:GetMode() == "Farm" then 
        self:Farm()
elseif GOS:GetMode() == "LastHit" then 
        self:LastHit()
    end
end

function Pantheon:Combo()
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Combo.ComboQ:Value() and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end


local wtarget = self:GetTarget(W.range)

if wtarget and self.Menu.Combo.ComboW:Value() and self:CanCast(_W)then
local castPos = wtarget
self:CastW(castPos)
end


local etarget = self:GetTarget(E.range)
if etarget and self.Menu.Combo.ComboE:Value() and not self:CanCast(_W) and self:CanCast(_E)then
local castPos = etarget
self:CastE(castPos)
	end
end

function Pantheon:LastHit()
    -- LASTHIT LOGIC HERE
end

function Pantheon:CastQ(position)
    if position then
	    Control.SetCursorPos(position)
        Control.CastSpell(HK_Q, position)
    end
end

function Pantheon:CastW(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_W, position)
    end
end

function Pantheon:CastE(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_E, position)
    end
end

function Pantheon:CastR(target)
    if target then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_R, target)
    end
end

function Pantheon:Draw()
    if myHero.dead then return end

    if self.Menu.Draw.DrawReady:Value() then
        if self:IsReady(_Q) and self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_W) and self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_E) and self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    else
        if self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    end


    if self.Menu.Draw.DrawTarget:Value() then
        local drawTarget = self:GetTarget(Q.Range)
        if drawTarget then
            Draw.Circle(drawTarget.pos,80,3,Draw.Color(255, 255, 0, 0))
        end
    end
end

function Pantheon:Mode()
    if Orbwalker["Combo"].__active then
        return "Combo"
    elseif Orbwalker["Harass"].__active then
        return "Harass"
    elseif Orbwalker["Farm"].__active then
        return "Farm"
    elseif Orbwalker["LastHit"].__active then
        return "LastHit"
    end
    return ""
end

function Pantheon:GetTarget(range)
    local target
    for i = 1,Game.HeroCount() do
        local hero = Game.Hero(i)
        if hero.isTargetable and not hero.dead and hero.team ~= myHero.team then
            target = hero
            break
        end
    end
    return target
end



function Pantheon:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Pantheon:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Pantheon:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Pantheon:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

function Pantheon:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Pantheon:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Pantheon:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end




function OnLoad()
    Pantheon()
end
