if myHero.charName ~= "Yasuo" then return print("Hello "..myHero.name.." this script don't support "..myHero.charName) end

require("DamageLib")
require("Eternal Prediction")


--Menu

local Yasuo = MenuElement({type = MENU, name = "SMOOT's Yasuo", id = "smootyasuo"})
Yasuo:MenuElement({type = MENU, name = "Combo", id = "Combo"})
Yasuo:MenuElement({type = MENU, name = "LaneClear", id = "LaneClear"})
Yasuo:MenuElement({type = MENU, name = "LastHit", id = "LastHit"})
Yasuo:MenuElement({type = MENU, name = "Misc", id = "Misc"})
--Combo Alt Menu
Yasuo.Combo:MenuElement({id = "useQ", name = "Use Q", value = true})
Yasuo.Combo:MenuElement({id = "useE", name = "Use E", value = true})
Yasuo.Combo:MenuElement({id = "useW", name = "Use W ( Maybe Coming Soon.. )", value = true})
Yasuo.Combo:MenuElement({id = "useQQQ", name = "Wait Use Q ( Hose ) ", value = true})
Yasuo.Combo:MenuElement({id = "egap", name = "Use E gap ", value = true})
--LaneClear Alt Menu
Yasuo.LaneClear:MenuElement({id = "laneclearQ", name = "Use Q", value = true})
Yasuo.LaneClear:MenuElement({id = "laneclearE", name = "Use E", value = true})
--LastHit Alt Menu
Yasuo.LastHit:MenuElement({id = "lasthitQ", name = "Use Q", value = true})
Yasuo.LastHit:MenuElement({id = "lasthitE", name = "Use E", value = true})
Yasuo.LastHit:MenuElement({id = "lasthitfast", name = "Use Q+E fast", value = true})
--Misc Alt Menu
Yasuo.Misc:MenuElement({id = "autoR", name = "Auto R", value = true})
Yasuo.Misc:MenuElement({id = "useRmisc", name = "Auto R x enemy", value = 2 , min = 1, max = 5, step = 1 })
Yasuo.Misc:MenuElement({id = "autoIgnite", name = "Auto Ignite", value = true})
Yasuo.Misc:MenuElement({id = "predSet", name = "Prediction for Q : ", value = true, value = 0.25, min = 0.01, max = 1, step = 0.01})



--Degisken
local ignite = nil
local ignite2 = nil
local QQData = { speed = myHero:GetSpellData(_Q).speed , delay = 0.25 , width = myHero:GetSpellData(_Q).width }
local QQ = Prediction:SetSpell(QQData, TYPE_LINE, true)
local EStackName = "YasuoDashScalar"
local hava	= {[29]=true,[30]=true}
--Fonksiyonlar
function hasbuffE(hedef)
	if _G.SDK.BuffManager:GetBuffCount(hedef, EStackName) > 0  then
		return true
	end
	return false
end
function CanCast(spell)
if myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 then
return true
else
return false
end
end
function eEndPos(unit)

    if unit ~= nil then
        if _G.SDK.Utilities:GetDistanceSquared(myHero,unit) < 410 then
           dashPointT = myHero + (Vector(unit) - myHero):Normalized() * 485
        else 
           dashPointT = myHero + (Vector(unit) - myHero):Normalized() * (_G.SDK.Utilities:GetDistanceSquared(myHero,unit) + 65)
        end
        return dashPointT
    end
end
function getNearestMinion(unit)

    local closestMinion = nil
    local nearestDistance = 0
		for i=0, Game.MinionCount() do
			local minyon = Game.Minion(i)
			if(minyon ~= nil and minyon.isEnemy) then
				if(_G.SDK.Utilities:GetDistanceSquared(myHero,minyon) <= myHero:GetSpellData(_E).range * myHero:GetSpellData(_E).range) then
					if(_G.SDK.Utilities:GetDistanceSquared(eEndPos(minyon),unit) and nearestDistance < _G.SDK.Utilities:GetDistanceSquared(myHero,minyon)) then
						nearestDistance = _G.SDK.Utilities:GetDistanceSquared(myHero,minyon)
						closestMinion = minyon
					end
				end
			end
		end
		
    return closestMinion
end
function Combo()
	Ignite()
	AutoR()
	local mPos
	for a=1, Game.HeroCount() do
	local hero = Game.Hero(a)
		if(_G.SDK.Utilities:IsValidTarget(hero) and _G.SDK.Utilities:IsInRange(myHero,hero,myHero:GetSpellData(_R).range) and hero.isEnemy and _G.SDK.Utilities:IsValidTarget(hero)) then

			if _G.SDK.Utilities:GetDistanceSquared(myHero.pos,hero.pos) > myHero:GetSpellData(_E).range * myHero:GetSpellData(_E).range and CanCast(_E) then
            mPos = getNearestMinion(hero)
				if mPos and _G.SDK.Utilities:IsValidTarget(mPos) then 
					Control.CastSpell(HK_E, mPos)
					Control.CastSpell(HK_E, hero)
				elseif _G.SDK.Utilities:GetDistanceSquared(myHero.pos,hero.pos) < (myHero:GetSpellData(_E).range * myHero:GetSpellData(_E).range)*2 then
				end
			end
			local pred = QQ:GetPrediction(hero, myHero.pos)
			if(myHero:GetSpellData(_Q).name == "YasuoQ3W" and Yasuo.Combo.useQQQ:Value() and CanCast(_Q)) then
				local pred = QQ:GetPrediction(hero, myHero.pos)
				--print("Ayarlar tamam. Hedef : "..hero.charName)
				if( pred and pred.hitChance>=Yasuo.Misc.predSet:Value()) then
					if(_G.SDK.Utilities:GetDistanceSquared(myHero.pos,hero.pos) <= myHero:GetSpellData(_E).range * myHero:GetSpellData(_E).range and CanCast(_Q) and CanCast(_E)) then
						--Control.CastSpell(HK_E, pred.castPos)
						Control.CastSpell(HK_Q, hero.pos)
					elseif CanCast(_Q) then	
						Control.CastSpell(HK_Q, pred.castPos)
					end
				end
			end
			if(myHero:GetSpellData(_Q).name == "YasuoQ3W" and CanCast(_Q)) then
				Control.CastSpell(HK_Q, pred.castPos)
			end
			if(Yasuo.Combo.useQ:Value() and CanCast(_Q) and myHero:GetSpellData(_Q).name ~= "YasuoQ3W" and _G.SDK.Utilities:GetDistanceSquared(myHero.pos,hero.pos) <= myHero:GetSpellData(_Q).range * myHero:GetSpellData(_Q).range) then
				Control.CastSpell(HK_Q, pred.castPos)
			end
			if(Yasuo.Combo.useE:Value() and CanCast(_E)) then
				Control.CastSpell(HK_E, hero)
			end
		end
	end
end

function LaneClear()
local minionyeni = nil
local enyakindusman = nil
for a=1, Game.HeroCount() do
	local hero = Game.Hero(a)
	if(_G.SDK.Utilities:IsValidTarget(hero) and _G.SDK.Utilities:IsInRange(myHero,hero,300) and hero.isEnemy) then
		if enyakindusman == nil then
			enyakindusman = hero
		elseif _G.SDK.Utilities:GetDistanceSquared(enyakindusman.pos, hero.pos) > _G.SDK.Utilities:GetDistanceSquared(hero.pos, enyakindusman.pos) then
			enyakindusman = hero
		end
	end
end
	for i=1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if( _G.SDK.Utilities:IsValidTarget(minion) and _G.SDK.Utilities:IsInRange(myHero,minion,myHero:GetSpellData(_E).range) and minion.isEnemy)	then
			if( minionyeni == nil ) then 
				minionyeni = minion
			elseif ( minion.health < minionyeni.health ) then
				minionyeni = minion
			end
		end
	end
	
	local minionhase = false
	if( _G.SDK.Utilities:IsValidTarget(minionyeni) and _G.SDK.Utilities:IsInRange(myHero,minionyeni,500))	then
		if(hasbuffE(minionyeni)) then
			minionhase = true
		end
		local pred = QQ:GetPrediction(Game.Minion(i), myHero.pos)
		if(Yasuo.LaneClear.laneclearE:Value() and CanCast(_E) and minionhase == false and _G.SDK.Utilities:IsInRange(myHero,minionyeni,500)) then
		Control.CastSpell(HK_E, miniononyeni)
		Control.CastSpell(HK_Q, pred.castPos)
		elseif Yasuo.LaneClear.laneclearQ and CanCast(_Q) then
		Control.CastSpell(HK_Q, pred.castPos)
		end		
	end
end
function LastHit()
	local QDamage = 0
	local minyon = nil
	local es = _G.SDK.BuffManager:GetBuffCount(myHero, EStackName)
	local topdamageE = ((50 + (10 * myHero:GetSpellData(_E).level)) * (1 + (0.25 * es))) + (myHero.bonusDamage * 0.2)
	
	for i = 1, Game.MinionCount() do
		if _G.SDK.Utilities:IsValidTarget(Game.Minion(i)) and _G.SDK.Utilities:IsInRange(myHero, Game.Minion(i), myHero:GetSpellData(_E).range) then
		local EDamage = DamageHesapla(myHero, Game.Minion(i), topdamageE)
		QDamage = getdmg("Q",Game.Minion(i), myHero)
		local pred = QQ:GetPrediction(Game.Minion(i), myHero.pos)
		if Game.Minion(i).isEnemy and Game.Minion(i).health < EDamage and CanCast(_E) and Yasuo.LastHit.lasthitE:Value() then
			Control.CastSpell(HK_E, Game.Minion(i))
		elseif Game.Minion(i).isEnemy and Game.Minion(i).health < QDamage and CanCast(_Q) and Yasuo.LastHit.lasthitQ:Value() and pred and pred.hitChance>=Yasuo.Misc.predSet:Value() then
			Control.CastSpell(HK_Q, pred.castPos)
		else if CanCast(_Q) and CanCast(_E) and Game.Minion(i).isEnemy and Game.Minion(i).health > QDamage and Game.Minion(i).health < QDamage + EDamage and Yasuo.LastHit.lasthitfast:Value() and pred and pred.hitChance>=Yasuo.Misc.predSet:Value() then
			Control.CastSpell(HK_Q, pred.castPos)
			Control.CastSpell(HK_E, Game.Minion(i))		
		end
		end
	end
end
end
function Ignite()
	local igdamage = 50 + 20 * myHero.levelData.lvl
	local ighedef = _G.SDK.TargetSelector:GetTarget(myHero:GetSpellData(ignite).range)
	local hedefHealth
	if Yasuo.Misc.autoIgnite:Value() and _G.SDK.Utilities:IsValidTarget(ighedef) and myHero:GetSpellData(ignite).currentCd == 0 then
		hedefHealth = ighedef.health
		if igdamage >= hedefHealth + 20 then
			Control.CastSpell(ignite2, ighedef.pos)
			--print("IGNITE ATILDI")
		end
	end
end

function AutoR()
	local count = 0
	local dusmang = _G.SDK.ObjectManager:GetEnemyHeroes(myHero:GetSpellData(_R).range)
	for i = 0, #dusmang do
		local h = dusmang[i]
		if h and h.isEnemy and _G.SDK.Utilities:IsValidTarget(h) then
			for a=0, 63 do
				local bgetir = h:GetBuff(a)
				if bgetir and hava[bgetir.type] and bgetir.count > 0 then
					count = count + 1
				end
			end
		end
	end
	if(count >= Yasuo.Misc.useRmisc:Value() and Yasuo.Misc.autoR:Value() and CanCast(_R)) then
		Control.CastSpell(HK_R)
	end
end

function DamageHesapla(source, target, amount)
	local ArmorPenPercent = source.armorPenPercent
	local ArmorPenFlat = source.armorPen * (0.6 + (0.4 * (target.levelData.lvl / 18)))
	local BonusArmorPen = source.bonusArmorPenPercent

	local armor = target.armor
	
	local bonusArmor = target.bonusArmor
	local baseArmor =  armor - bonusArmor
	if bonusArmor < 0 then print("CalcPhysicalDamage : smth wrong with "..source.charName.." on "..target.charName) end
	
	local value = nil
	if armor <= 0 then
		value = 2 - 100 / (100 - armor)
	else
		baseArmor = baseArmor*ArmorPenPercent
		bonusArmor = bonusArmor*ArmorPenPercent*BonusArmorPen
		armor = baseArmor + bonusArmor
		if armor > ArmorPenFlat then
			armor = armor - ArmorPenFlat
		end
		value = 100 /(100 + armor)
	end
	if target.type ~= myHero.type then
		return value * amount
	end	
	if target.charName == "Garen" and HasBuff(target,"GarenW") then
		amount = amount*0.7
	elseif target.charName == "MaoKai" and HasBuff(target,"MaokaiDrainDefense") then
		amount = amount*0.7

	elseif target.charName == "MasterYi" and HasBuff(target,"Meditate") then
		amount = amount - amount * ({0.5, 0.55, 0.6, 0.65, 0.7})[target:GetSpellData(_W).level]
	elseif target.charName == "Braum" and HasBuff(target,"BraumShieldRaise") then
		amount = amount*(1 - ({0.3, 0.325, 0.35, 0.375, 0.4})[target:GetSpellData(_E).level])	
	elseif target.charName == "Urgot" and HasBuff(target,"urgotswapdef") then
		amount = amount*(1 - ({0.3, 0.4, 0.5})[target:GetSpellData(_R).level])
	elseif target.charName == "Amumu" and HasBuff(target,"Tantrum") then
		amount = amount - ({2, 4, 6, 8, 10})[target:GetSpellData(_E).level]
	elseif target.charName == "Annie" and HasBuff(target,"MoltenShield") then
		amount = amount*(1 - ({0.16,0.22,0.28,0.34,0.4})[target:GetSpellData(_E).level])		
	end
	return value * amount
end
function OnTick()
local ignite = nil
	if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" then 
		ignite = SUMMONER_1
		ignite2 = HK_SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" then
		ignite = SUMMONER_2
		ignite2 = HK_SUMMONER_2
	end
	Ignite()
	AutoR()
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then 
		LastHit()
	end
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then 
		LaneClear()
	end
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then 
		Combo()
	end

end
Callback.Add("Tick", function() OnTick() end)
