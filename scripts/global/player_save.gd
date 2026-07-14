extends Resource
class_name PlayerSave

@export var player = {
	name = "CHARA",
	lv = 1,
	current_hp = 20,
	current_kr = 0,
	max_hp = 20,
	atk = 0,
	def = 0,
	exp = 0,
	weapon = "stick",
	armor = "bandage",
	gold = 0,
	kills = 0,
	base_atk = 10,
	base_def = 10,
	}

@export var inventory : Array = [ #Don't erase indexes from this Array!!!!
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]
	
@export var contacts : Array = [ #Don't erase indexes from this Array!!!!
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]
	
@export var box_inventory : Array = [ #Don't erase indexes from this Array!!!!
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	""
	]

#Data that saves when you save the game. Will be resetted if you reset.
@export var data = {
	name = "",
	lv = 0,
	save_name = "EMPTY",
	murder_level = 0,
	pacifist_level = 0,
	genocide = false,
	player_room = 0,
	place_name = "--",
	animation = "down",
	position = Vector2(0, 0),
	time = 0.0,
	resets = -1,
	hard_mode = false,
	death_count = 0,
	step_encounter = [0, 0.0, 0.0, 0.0],
	}

func get_weapon() -> Weapon:
	return ut_items.items[player.weapon]
	
func get_armor() -> Armor:
	return ut_items.items[player.armor]

func get_item(index : int) -> Item:
	return ut_items.items[inventory[index]]
	
func get_item_box(index : int) -> Item:
	return ut_items.items[box_inventory[index]]

func get_inventory_size() -> int:
	for i in len(inventory):
		if(inventory[i] == ""):
			return i
	return len(inventory)

func get_contacts_size() -> int:
	for i in len(contacts):
		if(contacts[i] == ""):
			return i
	return len(contacts)
	
func get_box_size() -> int:
	for i in len(box_inventory):
		if(box_inventory[i] == ""):
			return i
	return len(box_inventory)
