if CLIENT then
	surface.CreateFont("bold", {font = "LemonMilk" , size = 19, weight = 500, color = Color(0,0,0,255)}) --http://www.dafont.com/marsneveneksk.d4012 - font creator
	surface.CreateFont("bold_x", {font = "Trebuchet18" , size = 18, weight = 600, color = Color(0,0,0,255)})
	surface.CreateFont("normal", {font = "Trebuchet18", color = Color(0,0,0,255)})

	function OpenAchievementGUI()

		if main then
			return
		end
				
		main = vgui.Create( "DFrame" )
		main:SetSize( 1024, 400 )
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
			surface.SetTextPos( main:GetWide() / 2 - surface.GetTextSize( "Achievements" ) / 2, 6 ) 
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
			surface.SetFont( "bold_x" )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( 17, 0.5 ) 
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
		
		local panel_left = vgui.Create("DPanel", inside)
		panel_left:SetPos(5,5)
		panel_left:SetSize(615, 355)
		panel_left:SetBackgroundColor(Color(255,255,255))
		
		local panel_right = vgui.Create("DPanel", inside)
		panel_right:SetPos(625,5)
		panel_right:SetSize(380, 355)
		panel_right:SetBackgroundColor(Color(255,255,255))
		
		local achievement_name = vgui.Create("DLabel", panel_right)
		achievement_name:SetPos(5,5)
		achievement_name:SetText("")
		
		local achievement_desc = vgui.Create("DLabel", panel_right)
		achievement_desc:SetPos(5,30)
		achievement_desc:SetText("")
		
		local locked_lbl = vgui.Create("DLabel", panel_left)
		surface.SetFont("bold")
		local locked_size = surface.GetTextSize("Locked")
		locked_lbl:SetPos(150 - (locked_size / 2), 10)
		locked_lbl:SetFont("bold")
		locked_lbl:SetTextColor(Color(0,0,0))
		locked_lbl:SetText("Locked")
		locked_lbl:SizeToContents()
		
		local unlocked_lbl = vgui.Create("DLabel", panel_left)
		surface.SetFont("bold")
		local unlocked_size = surface.GetTextSize("Unlocked")
		unlocked_lbl:SetPos(460 - (unlocked_size / 2), 10)
		unlocked_lbl:SetFont("bold")
		unlocked_lbl:SetTextColor(Color(0,0,0))
		unlocked_lbl:SetText("Unlocked")
		unlocked_lbl:SizeToContents()
		
		local scroll = vgui.Create("DScrollPanel", panel_left);
		scroll:SetPos(5,35)
		scroll:SetSize(605,315)
		
		local achievement_lock_list = vgui.Create("DListView", scroll)
		achievement_lock_list:SetMultiSelect(false)
		achievement_lock_list:AddColumn("Achievement Name")
		achievement_lock_list:SetSize(300,315)
		
		local achievement_unlock_list = vgui.Create("DListView", scroll)
		achievement_unlock_list:SetMultiSelect(false)
		achievement_unlock_list:AddColumn("Achievement Name")
		achievement_unlock_list:SetSize(300,315)
		achievement_unlock_list:SetPos(305,0)
		
		achievement_lock_list.OnRowSelected = function(panel, line)
		
			for _,achievement in pairs(Achievements.List) do
				if achievement_lock_list:GetLine(line):GetValue(1) == achievement.displayname then
					achievement_name:SetFont("bold")
					achievement_name:SetTextColor(Color(0,0,0))
					achievement_name:SetText(achievement.displayname)
					achievement_name:SizeToContents()
					achievement_desc:SetFont("normal")
					achievement_desc:SetTextColor(Color(0,0,0))
					achievement_desc:SetText(achievement.description)
					achievement_desc:SizeToContents()
				end
			end
		
		end
		
		achievement_unlock_list.OnRowSelected = function(panel, line)
		
			for _,achievement in pairs(Achievements.List) do
				if achievement_unlock_list:GetLine(line):GetValue(1) == achievement.displayname then
					achievement_name:SetFont("bold")
					achievement_name:SetTextColor(Color(0,0,0))
					achievement_name:SetText(achievement.displayname)
					achievement_name:SizeToContents()
					achievement_desc:SetFont("normal")
					achievement_desc:SetTextColor(Color(0,0,0))
					achievement_desc:SetText(achievement.description)
					achievement_desc:SizeToContents()
				end
			end
		
		end
		
		for _,achievement in pairs(Achievements.List) do
			if table.HasValue(Achievements.Completed, achievement.name) then
				achievement_unlock_list:AddLine(achievement.displayname)
			else
				achievement_lock_list:AddLine(achievement.displayname)
			end
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