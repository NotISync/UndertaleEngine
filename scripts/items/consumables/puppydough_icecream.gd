extends Consumable
class_name PuppydoughIcecream

func _init():
	names = ["Puppydough Icecream", "PDIceCram", "Ice Cream"]
	heals = [28,28,28]

func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* Mmm!(delay:0.5) Tastes like puppies.\n" + str(hp_message(28)) + "(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Puppydough Icecream\"\n* Heals 28 HP.(delay:0.5)\n* Made by young pups.(pc)"
