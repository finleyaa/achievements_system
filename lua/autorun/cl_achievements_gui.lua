if CLIENT then
	surface.CreateFont("bold", {font = "Trebuchet18" , size = 15, weight = 600, color = Color(0,0,0,255)})
	surface.CreateFont("normal", {font = "Trebuchet18", color = Color(0,0,0,255)})

	function OpenAchievementGUI()

		if main then
			return
		end
				
		main = vgui.Create( "DFrame" )
		main:SetSize( 300, 400 )
		main:SetTitle( "" )
		main:SetVisible( true )
		main:ShowCloseButton( true )
		main:MakePopup()
		main:Center()	
		main.btnMaxim:Hide()
		main.btnMinim:Hide() 
		main.btnClose:Hide()
		main.Paint = function()
			surface.SetDrawColor( 50, 50, 50, 135 )
			surface.DrawOutlinedRect( 0, 0, main:GetWide(), main:GetTall() )
			surface.SetDrawColor( 2, 134, 242, 240 )
			surface.DrawRect( 1, 1, main:GetWide() - 2, main:GetTall() - 2 )
			surface.SetFont( "bold" )
			surface.SetTextPos( main:GetWide() / 2 - surface.GetTextSize( "Achievements" ) / 2, 3 ) 
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.DrawText( "Achievements" )
		end
		
		local close = vgui.Create( "DButton", main )
		close:SetPos( main:GetWide() - 50, 0 )
		close:SetSize( 44, 22 )
		close:SetText( "" )
				
		local colorv = Color( 150, 150, 150, 250 )
		function PaintClose()
			if not main then 
				return 
			end
			surface.SetDrawColor( colorv )
			surface.DrawRect( 1, 1, close:GetWide() - 2, close:GetTall() - 2 )	
			surface.SetFont( "bold" )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( 16, 3 ) 
			surface.DrawText( "x" )
			return true
		end
		
		close.Paint = PaintClose		
		close.OnCursorEntered = function()
			colorv = Color( 195, 75, 0, 250 )
			PaintClose()
		end	
		
		close.OnCursorExited = function()
			colorv = Color( 150, 150, 150, 250 )
			PaintClose()
		end	
		
		close.OnMousePressed = function()
			colorv = Color( 170, 0, 0, 250 )
			PaintClose()
		end	
		
		close.OnMouseReleased = function()
			if not LocalPlayer().InProgress then
				main:Close()
			end
		end	
		
		main.OnClose = function()
			main:Remove()
			if main then
				main = nil
			end
		end	
		
		local inside = vgui.Create( "DPanel", main )
		inside:SetPos( 7, 27 )
		inside:SetSize( main:GetWide() - 14, main:GetTall() - 34 )
		inside.Paint = function()
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, inside:GetWide(), inside:GetTall() )
			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.DrawRect( 1, 1, inside:GetWide() - 2, inside:GetTall() - 2 )
		end
		
		local scroll = vgui.Create("DScrollPanel", inside);
		scroll:Dock(FILL);
		scroll:DockMargin(1, 1, 1, 1);
		
		local x, y = 10, 10
		
		for _,achievement in pairs(Achievements.List) do
			local achievement_label_part1 = vgui.Create("DLabel", scroll)
			local achievement_label_part2 = vgui.Create("DLabel", scroll)
			if table.HasValue(Achievements.Completed, achievement.name) then
				achievement_label_part1:SetFont("bold")
				achievement_label_part1:SetText(achievement.displayname)
				achievement_label_part2:SetFont("normal")
				achievement_label_part2:SetText(achievement.description .. "\nUnlocked!")
				achievement_label_part1:SetTextColor(Color(0,0,0,255))
				achievement_label_part2:SetTextColor(Color(0,0,0,255))
			else
				achievement_label_part1:SetFont("bold")
				achievement_label_part1:SetText(achievement.displayname)
				achievement_label_part2:SetFont("normal")
				achievement_label_part2:SetText(achievement.description .. "\nLocked!")
				achievement_label_part1:SetTextColor(Color(255,0,0,255))
				achievement_label_part2:SetTextColor(Color(255,0,0,255))
			end
			achievement_label_part1:SizeToContents()
			achievement_label_part1:SetPos(x, y)
			achievement_label_part2:SizeToContents()
			achievement_label_part2:SetPos(x, y+13)
			y = y + 45
		end
		
	end

	net.Receive("achievements_updateply", function()

		Achievements.List = net.ReadTable()
		Achievements.Completed = net.ReadTable()
		OpenAchievementGUI()

	end)

	concommand.Add("achievements_gui", function()

		net.Start("achievements_requestupdate")
		net.SendToServer()

	end)
end