extends Consumable
class_name GhostFruit

func _init():
	names = ["Ghost Fruit", "GhostFrut", "GhstFruit"]
	heals = [16,16,16]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You ate the Ghost Fruit.\n" + str(hp_message(16)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Ghost Fruit\" - Heals 16 HP\n* If eaten,(delay:0.5) it will never\n  pass to the other side.(pc)"
