if(myHero.charName ~= "Kalista") then return end

--[[
]]









--Menu
local K = MenuElement({type = MENU, name = "SMOOT's Kalista", id = "smootkalista"})
K:MenuElement({type = MENU, name = "LaneClear", id = "LaneClear"})
K:MenuElement({type = MENU, name = "Combo", id = "Combo"})
K:MenuElement({type = MENU, name = "Harass", id = "Harass"})
K:MenuElement({type = MENU, name = "Draw", id = "Draww"})
-------Alt Menuler
--LaneClear
--K.LaneClear:MenuElement({id = "q", name = "Use Q", value = 1})
K.LaneClear:MenuElement({id = "kacminyonoldureyim", name = " 'X' minion kill with E Spell.", value = 2,min = 0, max = 5, step = 1})
--Combo
--K.Combo:MenuElement({id = "qc", name = "Use Q"})
K.Combo:MenuElement({id = "botrk" , name = "Use Botrk"})
K.Combo:MenuElement({id = "minionComboHarass", name = "If killable minion press E (Enemy HP : %..)", value = 40, min = 0,max = 100, step = 10})
--Harass
K.Harass:MenuElement({id = "minionHarass", name = "If killable minion press E", value = true})
--Draw
K.Draww:MenuElement({id = "drawE", name = "Draw E range", value = true})
K.Draww:MenuElement({id = "drawHP", name = "Draw E damage %", value = true})






--Buyu
local E = { range = 1000, delay = 200 }
local Q = { range = 1150, delay = 0.35, speed = 2400}
--Degisken
local EStackName = "kalistaexpungemarker"
--Gerekli Fonksiyonlar

function Hazirmi(skill)
	return Game.CanUseSpell(skill) == 0
end

local is = {
	[ITEM_1] = HK_ITEM_1,
	[ITEM_2] = HK_ITEM_2,
	[ITEM_3] = HK_ITEM_3,
	[ITEM_4] = HK_ITEM_4,
	[ITEM_5] = HK_ITEM_5,
	[ITEM_6] = HK_ITEM_6,
	[ITEM_7] = HK_ITEM_7,
}
function Botrk()
	local dizi = {}
	for i = ITEM_1,ITEM_7 do
		local id = myHero:GetItemData(i).itemID 
		if id > 0 then
			dizi[id] = i
		end
	end
	local itm = dizi[3153]
	
	if itm and myHero:GetSpellData(itm).currentCd == 0 and K.Combo.botrk:Value() then
	--print(""..tostring(itm))
		local target = _G.SDK.ObjectManager:GetEnemyHeroes(E.range)
		if target then
			Control.CastSpell(is[itm],target)
			--print("buldum")
		end
	end
end
--Thanks for this function !
function HasBuff(unit, buffname)
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff and buff.count > 0 and buff.name:lower() == buffname:lower()  then 
      return true
    end
  end
  return false
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

function EHasar(a)
    local e = StackGetir(a)-1
	local level = myHero:GetSpellData(_E).level
	local etabanhasar = ({20, 30, 40, 50, 60})[level] + 0.6* (myHero.totalDamage)
	local stackhasar = (e*(({10, 14, 19, 25, 32})[level]+({0.2, 0.225, 0.25, 0.275, 0.3})[level] * myHero.totalDamage))
	return DamageHesapla(myHero,a,etabanhasar + stackhasar)
end

function StackGetir(a)
	return _G.SDK.BuffManager:GetBuffCount(a, EStackName)
end

function HedefHasarKontrol(unit)
	if(unit == nil) then
		return false
	end

	return EHasar(unit) > unit.health
end

function DusmanOlurmu()

	local dusman = _G.SDK.ObjectManager:GetEnemyHeroes(E.range)
	local a = 0
	for i = 0, #dusman do
		local dusmann = dusman[i]
		if(HedefHasarKontrol(dusman[i]) and StackGetir(dusmann) >= a) then
			a = a + 1
		end
	end
	return a
end


function MinyonOlurmu()
	local dminyon = _G.SDK.ObjectManager:GetEnemyMinions(E.range)
	local a = 0
	for i = 0, #dminyon do
		local enemy = dminyon[i]
		if(HedefHasarKontrol(dminyon[i])) then
			a = a + 1
		end
	end
	return a
end
--Combo ve LaneClear
function Combo()
Botrk()
--Minyon
	local deger = K.Combo.minionComboHarass:Value()
	local dminyon = _G.SDK.ObjectManager:GetEnemyMinions(E.range)
	local msayisi = 0
	for i = 0, #dminyon do
	local enemy = dminyon[i]
	if(HedefHasarKontrol(enemy))
	then
	msayisi = msayisi + 1
	end
	end
--Dusman
	local abc = _G.SDK.ObjectManager:GetEnemyHeroes(E.range)
	for qwe=0, #abc do
	if(_G.SDK.Utilities:IsValidTarget(abc[qwe]) and StackGetir(abc[qwe])) then
	local hesap = (100*math.floor(EHasar(abc[qwe]))/abc[qwe].health)
	if(hesap >= deger and msayisi > 1) then
	Control.CastSpell(_E)
	end
	end
	end
end

function Clear()
	if(Hazirmi(_E)) then 
	local deger = K.LaneClear.kacminyonoldureyim:Value()
	local dminyon = _G.SDK.ObjectManager:GetEnemyMinions(E.range)
	local msayisi = 0
	for i = 0, #dminyon do
	local enemy = dminyon[i]
	if(HedefHasarKontrol(enemy))
	then
	msayisi = msayisi + 1
	end
	end
	if(msayisi >= deger) then
		Control.CastSpell(HK_E)
	end
	end
end

function Harass()
local b = _G.SDK.ObjectManager:GetEnemyMinions(E.range)
local sayi = 0
for a=0, #b do
if(HedefHasarKontrol(b[i])) then sayi = sayi + 1 end
end
local hedef = _G.SDK.ObjectManager:GetEnemyHeroes(E.range)
if(_G.SDK.Utilities:IsValidTarget(hedef) and K.Harass.minionHarass:Value() and Hazirmi(_E) and StackGetir(hedef)>0 and sayi >0) then
Control.CastSpell(HK_E)
end
end

function Cizim()
if(Hazirmi(_E) == false or K.Draww.drawE:Value()==false) then return end

		Draw.Circle(myHero.pos, E.range, 5, Draw.Color(255,255,255,0))
if(K.Draww.drawHP:Value() == true) then
		local dusman = _G.SDK.ObjectManager:GetEnemyHeroes(E.Range)
		local y = ""
		local hesap = 0
	for i = 0, #dusman do
		local h = dusman[i]
	if(_G.SDK.Utilities:IsValidTarget(h) and StackGetir(h) > 0) then
		hesap = (100*math.floor(EHasar(h))/math.floor(h.health))
		y = "%"..tostring(hesap)
		if(hesap > 50) then
			Draw.Text(y,15,h.pos:To2D(),Draw.Color(255,139,35,35))
		end
		if(hesap < 50) then
			Draw.Text(y,15,h.pos:To2D(),Draw.Color(255,240,248,255))
		end
		if(hesap >= 100) then
		y = "KILL HIM!!!!!!!!!"
			Draw.Text(Y,20,h.pos:To2D(),Draw.Color(255,118,238,0))
		end
	end

		local minyon = _G.SDK.ObjectManager:GetEnemyMinions(E.Range)
	for i = 0, #minyon do
		local h = minyon[i]
	if(_G.SDK.Utilities:IsValidTarget(h) and StackGetir(h) > 0) then
		hesap = (100*math.floor(EHasar(h))/math.floor(h.health))
		y = "%"..tostring(hesap)
		if(hesap > 50) then
			Draw.Text(y,15,h.pos:To2D(),Draw.Color(255,139,35,35))
		end
		if(hesap < 50) then
			Draw.Text(y,15,h.pos:To2D(),Draw.Color(255,240,248,255))
		end
		if(hesap >= 100) then
			Draw.Text("KILL HIM!!!!!",15,h.pos:To2D(),Draw.Color(255,118,238,0))
		end
	end
	end
end
end
end

function OnTick()
	if(myHero.dead) then return end
	if(DusmanOlurmu() > 0) then Control.CastSpell(HK_E) end
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then 
		Combo()
	end

	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then 
		Clear()
	end
	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then 
		Harass()
	end
end

Callback.Add("Tick", function() OnTick() end)
Callback.Add("Draw", function() Cizim() end)
