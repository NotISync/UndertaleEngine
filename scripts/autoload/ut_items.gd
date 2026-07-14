#PUT ALL EXISTING ITEMS IN YOUR GAME HERE
extends Node

@onready var items : Dictionary = {
	#HEAL ITEMS
	"bandage" : Bandage.new(),
	"monster_candy" : MonsterCandy.new(),
	"spider_donut" : SpiderDonut.new(),
	"spider_cider" : SpiderCider.new(),
	"butterscotch_pie" : ButterscotchPie.new(),
	"snail_pie" : SnailPie.new(),
	"snowman_piece" : SnowmanPiece.new(),
	"nice_cream" : NiceCream.new(),
	"bisicle" : Bisicle.new(),
	"unisicle" : Unisicle.new(),
	"cinnamon_bunny" : CinnamonBun.new(),
	"astronaut_food" : AstronautFood.new(),
	"crab_apple" : CrabApple.new(),
	"sea_tea" : SeaTea.new(),
	"abandoned_quiche" : AbandonedQuiche.new(),
	"temmie_flakes" : TemmieFlakes.new(),
	"dog_salad" : DogSalad.new(),
	"instant_noodles" : InstantNoodles.new(),
	"hot_dog" : HotDog.new(),
	"hot_cat" : HotCat.new(),
	"junk_food" : JunkFood.new(),
	"hush_puppy" : HushPuppy.new(),
	"starfait" : Starfait.new(),
	"glamburger" : Glamburger.new(),
	"legendary_hero" : LegendaryHero.new(),
	"face_steak" : FaceSteak.new(),
	"popato_chisps" : PopatoChisps.new(),
	"bad_memory" : BadMemory.new(),
	"dream" : Dream.new(),
	"puppydough_icecream" : PuppydoughIcecream.new(),
	"pumpkin_rings" : PumpkinRings.new(),
	"croquet_roll" : CroquetRoll.new(),
	"ghost_fruit" : GhostFruit.new(),
	"stoic_onion" : StoicOnion.new(),
	"rock_candy" : RockCandy.new(),
	
	#WEAPONS
	"stick" : Stick.new(),
	"toy_knife" : ToyKnife.new(),
	"tough_glove" : ToughGlove.new(),
	"ballet_shoes" : BalletShoes.new(),
	"torn_notebook" : TornNotebook.new(),
	"burnt_pan" : BurntPan.new(),
	"empty_gun" : EmptyGun.new(),
	"worn_dagger" : WornDagger.new(),
	"real_knife" : RealKnife.new(),
	
	#ARMOR
	"faded_ribbon" : FadedRibbon.new(),
	"manly_bandanna" : ManlyBandanna.new(),
	"old_tutu" : OldTutu.new(),
	"cloudy_glasses" : CloudyGlasses.new(),
	"temmie_armor" : TemmieArmor.new(),
	"stained_apron" : StainedApron.new(),
	"cowboy_hat" : CowboyHat.new(),
	"heart_locket" : HeartLocket.new(),
	"the_locket" : TheLocket.new(),
	
	#MISC
	"punch_card" : PunchCard.new(),
	"annoying_dog" : AnnoyingDog.new(),
	"dog_residue_0" : DogResidue.new(0),
	"dog_residue_1" : DogResidue.new(1),
	"dog_residue_2" : DogResidue.new(2),
	"dog_residue_3" : DogResidue.new(3),
	"dog_residue_4" : DogResidue.new(4),
	"dog_residue_5" : DogResidue.new(5),
	"undyne_letter" : UndyneLetter.new(0),
	"undyne_letter_ex" : UndyneLetter.new(1),
	"mystery_key" : MysteryKey.new(),
}

func sort_inventory():
	while (true):
		var found1 = false
		for i in range(settings.player_save.inventory.size() - 1, 0, -1):
			if(settings.player_save.inventory[i] != "" && settings.player_save.inventory[i - 1] == ""):
				var temp = settings.player_save.inventory[i]
				settings.player_save.inventory[i] = settings.player_save.inventory[i-1]
				settings.player_save.inventory[i-1] = temp
				if i != settings.player_save.inventory.size() - 1:
					found1 = true
		if !found1:
			break
			
func sort_box_inventory():
	while (true):
		var found1 = false
		for i in range(settings.player_save.box_inventory.size() - 1, 0, -1):
			if(settings.player_save.box_inventory[i] != "" && settings.player_save.box_inventory[i - 1] == ""):
				var temp = settings.player_save.box_inventory[i]
				settings.player_save.box_inventory[i] = settings.player_save.box_inventory[i-1]
				settings.player_save.box_inventory[i-1] = temp
				if i != settings.player_save.box_inventory.size() - 1:
					found1 = true
		if !found1:
			break
