#KDE can lockup for many reasons, including xrandr, xsetwacom operations. Resetting the driving applications can be an effective workaround to improve reliability.
_reset_KDE() {
	#kquitapp plasmashell ; sleep 0.5 ; pkill plasmashell ; sleep 0.1 ; pkill -KILL plasmashell ; sleep 0.1 ; plasmashell & exit
	
	#if pgrep plasmashell
	#then
		#kquitapp plasmashell ; sleep 3 ; plasmashell &
		if type kquitapp > /dev/null 2>&1
		then
			kquitapp plasmashell
		else
			pkill plasmashell
			killall plasmashell
		fi
		sleep 0.5
		pkill plasmashell
		killall plasmashell
		sleep 0.1
		pkill -KILL plasmashell
		killall plasmashell
		sleep 0.1
		
		plasmashell &
	#fi
	disown -a -h -r
	disown -a -r
}
