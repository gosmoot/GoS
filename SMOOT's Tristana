if myHero.charName ~= "Tristana" then return print("Hello "..myHero.name.." this champion not Tristana") end
require("DamageLib")
----Menu
local Tris = MenuElement({type = MENU, name = "SMOOT's Tristana", id = "smoottristana"})
Tris:MenuElement({type = MENU, name = "Combo", id = "Combo"})
Tris:MenuElement({type = MENU, name = "Draw", id = "Draw"})
--Combo Alt Menu
Tris.Combo:MenuElement({id = "botrk" , name = "Use Botrk", value = true})
Tris.Combo:MenuElement({id = "useQ", name = "Use Q", value = true})
Tris.Combo:MenuElement({id = "useE", name = "Use E", value = true})
Tris.Combo:MenuElement({id = "useR", name = "Use R ( One Shot )", value = true})
Tris.Combo:MenuElement({id = "BRAIN", name = "Use W ( USE YOUR BRAIN !!!!!!!!)", value = true})
--Draw
Tris.Draw:MenuElement({id = "drawE", name = "Draw E range", value = true})
Tris.Draw:MenuElement({id = "drawW", name = "Draw W range", value = true})
Tris.Draw:MenuElement({id = "drawR", name = "Draw R range", value = true})

--END

------
local is = {
	[ITEM_1] = HK_ITEM_1,
	[ITEM_2] = HK_ITEM_2,
	[ITEM_3] = HK_ITEM_3,
	[ITEM_4] = HK_ITEM_4,
	[ITEM_5] = HK_ITEM_5,
	[ITEM_6] = HK_ITEM_6,
	[ITEM_7] = HK_ITEM_7,
}

----------------------------------------------------------------------------------------------------------------------------------
function Combo(abc)

	if(Tris.Combo.botrk:Value()) then
	local dizi = {}
	for i = ITEM_1,ITEM_7 do
		local id = myHero:GetItemData(i).itemID 
		if id > 0 then
			dizi[id] = i
		end
	end
	local itm = dizi[3153]
	
	if itm and myHero:GetSpellData(itm).currentCd == 0 then
			Control.CastSpell(is[itm],abc)
	end
	end
	if(myHero:GetSpellData(_E).currentCd == 0 and myHero:GetSpellData(_E).mana/myHero.maxMana and myHero:GetSpellData(_E).level > 0 and Tris.Combo.useE:Value()==true) then
	Control.CastSpell(HK_E,abc.pos)
	end
	if(myHero:GetSpellData(_Q).currentCd == 0 and myHero:GetSpellData(_Q).mana/myHero.maxMana and myHero:GetSpellData(_Q).level > 0 and Tris.Combo.useQ:Value()==true) then
	Control.CastSpell(HK_Q)
	end

end
function Cizim()
if myHero.dead == true then return end
if(Tris.Draw.drawE:Value() == true and myHero:GetSpellData(_E).currentCd == 0 and myHero:GetSpellData(_E).mana/myHero.maxMana and myHero:GetSpellData(_E).level > 0) then
Draw.Circle(myHero.pos, myHero:GetSpellData(_E).range, 5, Draw.Color(255,255,255,0))
end
if(Tris.Draw.drawW:Value() == true and myHero:GetSpellData(_W).currentCd == 0 and myHero:GetSpellData(_W).mana/myHero.maxMana and myHero:GetSpellData(_W).level > 0) then
Draw.Circle(myHero.pos, myHero:GetSpellData(_W).range, 5, Draw.Color(255,118,238,0))
end

end

function OnTick()
	if(myHero.dead) then return end
	local ultihedef = _G.SDK.TargetSelector:GetTarget(myHero:GetSpellData(_R).range)
	local RDamage = 0
	local abcHealth = 0
	if(ultihedef) then
	RDamage = getdmg("R", ultihedef, myHero)
	abcHealth = ultihedef.health
	if(RDamage >= abcHealth and myHero:GetSpellData(_R).currentCd == 0 and myHero:GetSpellData(_R).mana/myHero.maxMana and myHero:GetSpellData(_R).level > 0 and Tris.Combo.useR:Value()) then
	print("R kullandım")
	Control.CastSpell(HK_R, ultihedef.pos)
	end
	end
	local hedef = _G.SDK.TargetSelector:GetTarget(myHero:GetSpellData(_E).range)
	if hedef then

	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then 
	print("hedef secildi : "..hedef.charName)
		Combo(hedef)
	end
	
	end
end
Callback.Add("Tick", function() OnTick() end)
Callback.Add("Draw", function() Cizim() end)
