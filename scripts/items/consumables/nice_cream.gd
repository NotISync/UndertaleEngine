extends Consumable
class_name NiceCream

func _init():
	names = ["Nice Cream", "NiceCream", "NiceCream"]
	heals = [15,15,15]

func get_use_text() -> String:
	match(floor(randf_range(0, 7))):
		0:
			return "(enable:z)(enable:x)(sound:mono2)* You're just great!\n" + str(hp_message(15)) + "(pc)"
		1:
			return "(enable:z)(enable:x)(sound:mono2)* You look nice today!\n" + str(hp_message(15)) + "(pc)"
		2:
			return "(enable:z)(enable:x)(sound:mono2)* Are those claws natural?\n" + str(hp_message(15)) + "(pc)"
		3:
			return "(enable:z)(enable:x)(sound:mono2)* You're super spiffy!\n" + str(hp_message(15)) + "(pc)"
		4:
			return "(enable:z)(enable:x)(sound:mono2)* Have a wonderful day!\n" + str(hp_message(15)) + "(pc)"
		5:
			return "(enable:z)(enable:x)(sound:mono2)* Is this as sweet as you?\n" + str(hp_message(15)) + "(pc)"
		6:
			return "(enable:z)(enable:x)(sound:mono2)* (lp)An illustration of a hug.(rp)\n" + str(hp_message(15)) + "(pc)"
		7:
			return "(enable:z)(enable:x)(sound:mono2)* Love yourself! I love you!\n" + str(hp_message(15)) + "(pc)"
		_:
			return "(enable:z)(enable:x)(sound:mono2)* Error!\n" + str(hp_message(15)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Nice Cream\" - Heals 15 HP\n* Instead of a joke,(delay:0.5) the\n  wrapper says something nice.(pc)"
