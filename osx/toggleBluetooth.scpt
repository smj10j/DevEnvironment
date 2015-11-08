#!/usr/bin/osascript

on alfred_script(q)
	tell application "System Events"

		tell process "System Preferences"
			activate
		end tell
	
		tell application "System Preferences"
			set current pane to pane "com.apple.preferences.Bluetooth"
		end tell

		tell process "System Preferences"

			set statName to name of button 3 of window 1 as string
			set failSafe to 0

			repeat until statName is not name of button 3 of window 1 as string ¬
				or failSafe is 10
				click button 3 of window 1
				set failSafe to failSafe + 1
				delay 0.1
			end repeat
	
		end tell

		tell application "System Preferences"
			quit
		end tell
	end tell
end alfred_script