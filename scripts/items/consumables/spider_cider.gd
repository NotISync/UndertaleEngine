extends Consumable
class_name SpiderCider

func _init():
	names = ["Spider Cider", "SpidrCidr", "SpdrCider"]
	heals = [24,24,24]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You drank the Spider Cider.\n" + str(hp_message(24)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Spider Cider\" - Heals 24 HP\n* Made with whole spiders,(delay:0.5)\n  not just the juice.(pc)"
