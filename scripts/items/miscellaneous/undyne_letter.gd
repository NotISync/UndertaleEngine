extends Miscellaneous
class_name UndyneLetter

var id = 0

func _init(type := 0):
	id = type
	names = ["Undyne's Letter", "UndynLetr", "Letter"] if (type == 0) else ["Undyne Letter EX", "UndynLtrX", "Letter"]

func use(inventory_slot : int):
	vars.main_writer.writer_text = get_use_text()
	await vars.main_writer.done
	done.emit()
	
func get_use_text() -> String:
	return "(enable:z)(enable:x)(sound:mono2)* You tried to open the letter,(delay:0.5)\n  but...(pc)* It's been shut so tightly,(delay:0.5)\n  you'd need a chainsaw in\n  order to open it.(pc)"

func get_info_text() -> String:
	match(id):
		0:
			return "(enable:z)(enable:x)(sound:mono2)* \"Undyne's Letter\" - Unique\n* Letter written for Dr.\n  Alphys.(pc)"
		1:
			return "(enable:z)(enable:x)(sound:mono2)* \"Undyne's Letter EX\" - Unique\n* It has DON'T DROP IT\n  written on it.(pc)"
		_:
			return "(enable:z)(enable:x)(sound:mono2)* Error!(pc)"
