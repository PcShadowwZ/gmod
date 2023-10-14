PC_Leveling = PC_Leveling or {}
PC_Leveling.Config = PC_Leveling.Config or {}
PC_Leveling.AllSkills = PC_Leveling.AllSkills or {}
PC_Leveling.XP = PC_Leveling.XP or {}
PC_Leveling.Levels = PC_Leveling.Levels or {}

net.Receive("lvlup_effect" ,function()
	local pos = net.ReadVector() + Vector(0,0,60)
	local power = 20
	local col = Color(255,175,25)
	local duration = 3
	local emitter = ParticleEmitter(pos)
	for i = 0, 100 do -- Do 100 particles
		local part = emitter:Add( "particles/flamelet"..math.random(1,5), pos ) 
		if ( part ) then
			part:SetDieTime( duration ) 
			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 0 )
			part:SetStartSize( 5 )
			part:SetEndSize( 0 )
			part:SetGravity( Vector(0,0,-100) ) 
			part:SetVelocity( VectorRand() * 150 ) 
			part:SetColor(math.random(0,255), math.random(0,255), math.random(0,255))
		end
	end
	
	emitter:Finish()
end)

net.Receive("PC_Leveling_SendXP", function()
    local id = net.ReadUInt(5)
    local xp = net.ReadUInt(24)
    PC_Leveling.XP[id] = xp
end)

net.Receive("PC_Leveling_SendLevel", function()
    local id = net.ReadUInt(5)
    local level = net.ReadUInt(24)
    PC_Leveling.Levels[id] = level
end)

local MAIN = {}

function MAIN:Init()
    PC_Leveling = PC_Leveling or {}
    self.NamePnl = vgui.Create("DPanel", self)
    self.NamePnl:Dock(TOP)
    self.NamePnl:SetTall(VoidUI.Scale(85))
    self.NamePnl.Paint = function(s,w,h)
        draw.SimpleText("Leveling", "GlobalFont_60", w/2, VoidUI.Scale(40), color_white, 1, 1)
        draw.RoundedBox(4, w/2 - VoidUI.Scale(200), VoidUI.Scale(70), VoidUI.Scale(400), VoidUI.Scale(3), Color(200,200,0,230))
    end

    self.SeasonTasks = self.NamePnl:Add("DButton")
    self.SeasonTasks:Dock(LEFT)
    self.SeasonTasks:SetWide(VoidUI.Scale(200))
    self.SeasonTasks:DockMargin(5,10,5,5)
    self.SeasonTasks:SetText("")
    self.SeasonTasks.Paint = function(s,w,h)
        draw.RoundedBox(20, 0, 0, w, h, s:IsHovered() and Color(15, 15, 15) or Color(25, 25, 25))
        draw.RoundedBox(20, 3, 3, w - 6, h - 6, s:IsHovered() and Color(20, 20, 20) or Color(30, 30, 30))
        draw.SimpleText("Special Tasks", "GlobalFont_25", w/2, h/2, color_white, 1, 1)
    end
    self.SeasonTasks.DoClick = function()
        local frame = vgui.Create("XeninUI.Frame")
        frame:SetSize(300,600)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Hints")
        for i = 1, 5 do
            local pnl = vgui.Create("DButton", frame)
            pnl:Dock(TOP)
            pnl:DockMargin(5,5,5,5)
            pnl:SetText("")
            pnl:SetTall(100)
            pnl.Paint = function(s,w,h)
                draw.RoundedBox(20, 0, 0, w, h, s:IsHovered() and Color(15, 15, 15) or Color(25, 25, 25))
                draw.RoundedBox(20, 3, 3, w - 6, h - 6, s:IsHovered() and Color(20, 20, 20) or Color(30, 30, 30))
                draw.SimpleText("Hint "..i, "GlobalFont_45", w/2, h/2, color_white, 1, 1)
                if LocalPlayer():PC_Leveling_GetLevel(10) < (i * 2) then
                    XeninUI:DrawBlur(s, 2.5)
                    draw.SimpleTextOutlined("LVL ".. (i * 2) .. " Required", "GlobalFont_35", w/2, h/2, Color(255,55,55), 1, 1, 2, Color(0,0,0))
                end
            end
            pnl.DoClick = function()
                net.Start("leveling_hint")
                    net.WriteUInt(i, 4)
                net.SendToServer()
            end
        end
    end

    self.Scroller = self:Add("DPanelList")
    self.Scroller:Dock(FILL)
    self.Scroller:DockMargin(0, 0, 0, 0)
    self.Scroller:EnableVerticalScrollbar()
    self.Scroller:SetPadding(VoidUI.Scale(9))
    self.Scroller:SetSpacing(VoidUI.Scale(10))
    self.Scroller:EnableHorizontal(true)
    self.Scroller.VBar.Paint = function(s,w,h)
        draw.RoundedBox(20, 0, 0, w, h, Color(0, 0, 0))
    end
    self:Build()
end

function MAIN:Build()
    PC_Leveling = PC_Leveling or {}
    for k, v in SortedPairs(PC_Leveling.AllSkills) do
        local pnl = vgui.Create("DButton",self.Scroller)
        pnl:SetSize(VoidUI.Scale(505),VoidUI.Scale(75))
        pnl:DockMargin(3,3,3,3)
        pnl:SetTall(VoidUI.Scale(75))
        pnl:SetText("")
        local nextLvl = PC_Leveling.Levels[k] + 1
        if PC_Leveling.Levels[k] == #PC_Leveling.AllSkills[k].levels then
            nextLvl = PC_Leveling.Levels[k]
        end

        pnl.Paint = function(s,w,h)
            local xp = PC_Leveling.XP[k]
            local nextXP = PC_Leveling.AllSkills[k].levels[nextLvl].Xp
            draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15))
            draw.RoundedBox(0, 2, 2, w-4, h-4, Color(35, 35, 35))
            if s:IsHovered() then
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0,100))
            end
                
            draw.SimpleText(v.name, "GlobalFont_25", 4, 4, color_white, 0, 3)
            draw.SimpleText("XP: "..xp.."/"..nextXP, "GlobalFont_25", w/2, 4, color_white, 1, 3)
            draw.SimpleText("Level: ".. PC_Leveling.Levels[k], "GlobalFont_25", w - 8, 4, color_white, 2, 3)

            draw.RoundedBox(0, 4, h/2.25, w - 8, h/2.5, Color(20, 20, 20))

            draw.RoundedBox(0, 6, h/2.25 + 2, (w - 12) * math.Clamp((xp / nextXP),0,1), h/2.5 - 4, Color(20, 125, 20))

            if PC_Leveling.AllSkills[k].dissabled then
                XeninUI:DrawBlur(s, 2.5)
                draw.SimpleText("SOON", "GlobalFont_30", w/2, h/2, Color(255,55,55), 1, 1)
            end

        end
        pnl.DoClick = function()
            if PC_Leveling.AllSkills[k].dissabled then return end
            if IsValid(levelFrame) then
                levelFrame:Remove()
            end
            levelFrame = vgui.Create("XeninUI.Frame")
            levelFrame:SetSize(450,math.Clamp((100 + (#PC_Leveling.AllSkills[k].levels - 1) * 45), 100, 1000))
            levelFrame:Center()
            levelFrame:MakePopup()
            levelFrame:SetTitle(PC_Leveling.AllSkills[k].name)
            levelFrame.Paint = function(s,w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(20,20,20))
            end
            local scroller = vgui.Create("XeninUI.Scrollpanel.Wyvern", levelFrame)
            scroller:Dock(FILL)
                for i, j in SortedPairs(PC_Leveling.AllSkills[k].levels) do
                    if i == 0 then continue end
                    local but = vgui.Create("DButton",scroller)
                    but:Dock(TOP)
                    but:DockMargin(3,3,3,3)
                    but:SetTall(40)
                    but:SetText("")
                    but.Paint = function(s,w,h)
                        local xp = PC_Leveling.XP[k]
                        local nextXP = PC_Leveling.AllSkills[k].levels[nextLvl].Xp

                        draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))
                        
                        if PC_Leveling.Levels[k] < i then
                            draw.RoundedBox(8, 0, 0, w, h, Color(150, 15, 15))
                        end

                        if xp >= nextXP and i == (nextLvl) then
                            draw.RoundedBox(8, 0, 0, w, h, Color(15, 150, 15))
                        end

                        if s:IsHovered() then
                            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0,100))
                        end
                        draw.SimpleText("Lvl: "..i.." [".. xp .."/".. PC_Leveling.AllSkills[k].levels[i].Xp .."]", "GlobalFont_20", 4, h/2, color_white, 0, 1)
                        draw.SimpleText("Reward: "..j.RewardName, "GlobalFont_20", w - 4, h/2, color_white, 2, 1)
                        if PC_Leveling.Levels[k] < i then
                            --XeninUI:DrawBlur(self, 0.5)
                            --HUD:WebImage("https://i.imgur.com/tt2NiHl.png", w/2.5, h/4, VoidUI.Scale(60), VoidUI.Scale(60), nil, nil, nil, nil)
                        end
                    end
                    but.DoClick = function()
                        local xp = PC_Leveling.XP[k]
                        local nextXP = PC_Leveling.AllSkills[k].levels[nextLvl].Xp
                        if PC_Leveling.Levels[k] + 1 == i and (xp >= nextXP) then
                            net.Start("PC_Leveling_ClaimLevel")
                                net.WriteUInt(k,5)
                            net.SendToServer()
                            levelFrame:Remove()
                            timer.Simple(0.1, function()
                                if IsValid(self) then
                                    self.Scroller:Clear()
                                    self:Build()
                                end
                            end)
                        end
                    end
                end
        end
        self.Scroller:AddItem(pnl)
    end
end

function MAIN:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, Color(25,25,25))
end

vgui.Register("PC_LEVELING_MAIN", MAIN, "DPanel")

concommand.Add("level_menu", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(1200,800)
    frame:Center()
    frame:MakePopup()

    local MP = vgui.Create("PC_LEVELING_MAIN",frame)
    MP:Dock(FILL)
end)