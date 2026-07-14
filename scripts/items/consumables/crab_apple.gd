extends Consumable
class_name CrabApple

func _init():
	names = ["Crab Apple", "CrabApple", "CrabApple"]
	heals = [18,18,18]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Crab Apple.\n" + str(hp_message(18)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Crab Apple\" Heals 18 HP\n* An aquatic fruit that\n  resembles a crustacean.(pc)"
