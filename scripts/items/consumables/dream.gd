extends Consumable
class_name Dream

func _init():
	names = ["Dream", "LastDream", "LastDream"]
	heals = [999,999,999]

func get_use_text() -> String:
	if(vars.dream):
		return "(enable:z)(enable:x)(sound:mono2)* The dream came true!(pc)"
	vars.dream = true
	return "(enable:z)(enable:x)(sound:mono2)* Through DETERMINATION,(delay:0.5) the\n  dream became true.(pc)"

func get_info_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* \"Dream\" Heals 12 HP\n* The goal of \"Determination.\"(pc)"
