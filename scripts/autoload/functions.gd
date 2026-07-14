extends Node

#CREATE YOUR OWN FUNCTIONS HERE!!!!

func exp_for_lv(current_lv) -> int:
	match(current_lv):
		1:
			return 10
		2:
			return 30
		3:
			return 70
		4:
			return 120
		5:
			return 200
		6:
			return 300
		7:
			return 500
		8:
			return 800
		9:
			return 1200
		10:
			return 1700
		11:
			return 2500
		12:
			return 3500
		13:
			return 5000
		14:
			return 7000
		15:
			return 10000
		16:
			return 15000
		17:
			return 25000
		18:
			return 50000
		19:
			return 99999
	return 0

func hp_for_lv(current_lv) -> int:
	return (16 + (current_lv * 4))
	
func atk_for_lv(current_lv) -> int:
	return ((current_lv - 1) * 2)

func def_for_lv(current_lv) -> int:
	return ((current_lv - 1) / 4)

func easter_egg_name(get_name) -> Array:
	match(get_name.to_lower()):
		"":
			return ["You must choose a name.", false]
		"aaaaaa":
			return ["Not very creative...?", true]
		"asgore":
			return ["You cannot.", false]
		"toriel":
			return ["I think you should\nthink of your own\nname, my child.", false]
		"sans":
			return ["nope.", false]
		"undyne":
			return ["Get your OWN name!", false]
		"flowey":
			return ["I already CHOSE\nthat name.", false]
		"chara":
			return ["The true name.", true]
		"alphys":
			return ["D-don't do that.", false]
		"alphy":
			return ["Uh.... OK?", true]
		"papyru":
			return ["I'LL ALLOW IT!!!", true]
		"napsta", "blooky":
			return ["............\n(lp)They're powerless to\nstop you.(rp)", true]
		"murder", "mercy":
			return ["That's a little on-\nthe-nose, isn't it...?", true]
		"asriel":
			return ["...", false]
		"frisk":
			return ["WARNING: This name will\nmake your life hell.\nProceed anyway?", true]
		"catty":
			return ["Bratty! Bratty!\nThat's MY name!", true]
		"bratty":
			return ["Like, OK I guess.", true]
		"mtt", "metta", "mett":
			return ["OOOOH!!! ARE YOU\nPROMOTING MY BRAND?", true]
		"gerson":
			return ["Wah ha ha! Why not?", true]
		"shyren":
			return ["...?", true]
		"aaron":
			return ["Is this name correct? ; (rp)", true]
		"temmie":
			return ["hOI!", true]
		"woshua":
			return ["Clean name.", true]
		"jerry":
			return ["Jerry.", true]
		"bpants":
			return ["You are really scraping the\nbottom of the barrel.", true]
		"gaster":
			settings.restart_game()
			return ["Is this name correct?", true]
		_:
			if(settings.player_save.data.name != ""):
				return ["A name has already\nbeen chosen.", true]
			else:
				return ["Is this name correct?", true]
