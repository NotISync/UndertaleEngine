extends Consumable
class_name CinnamonBun

func _init():
	names = ["Cinnamon Bun", "CinnaBun", "C. Bun"]
	heals = [22,22,22]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You eat the Cinnamon Bunny.\n" + str(hp_message(22)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Cinnamon Bunny\" - Heals 22 HP\n* A cinnamon roll in the shape\n  of a bunny.(pc)"
