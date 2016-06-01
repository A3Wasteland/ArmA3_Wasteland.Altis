How to add new boxes to the Airdrop System:

1)  Come up with a stringItemName for your box, e.g.: "superAwesomeBox1"

2)	Now you need to add this in two places:
		2.1)	server\functions\fn_refillbox.sqf  			--> This is where you define what is in the box
		2.2)	addons\APOC_Airdrop_Assistance\config.sqf	--> Here's where you add it to the airdrop menu


Adding Box Types to fn_refillbox.sqf
	So, here's some magic that the devs conjured up, and we're going to dip into that little pool.
	
	First, add a new case in the only switch structure in the file, just before the last " }; "
		[code]
		case "superAwesomeBox1":
		{
		};
		[/code]
	
	So now the switch command will have a new option when it goes a-searchin'
	However, inside our case, we need the variable _boxItems (array of arrays)
	So, now we'll have this:
		[code]
		case "superAwesomeBox1":
		{
			_boxItems = [
				["type", ["itemClassName 1", "itemClassName 2"], Quantity1],
				["type", ["itemClassName 3", "itemClassName 4"], Quantity2]
			];
		};
		[/code]

	Now, that array, inside of the _boxItems array has to be formatted just so.  The first part needs to
	be one of three types "wep", "itm", or "mag".  This tells the next function what type of items it is dealing with.
	You'll need to look up the configs to figure out what your item is classified as.  Look in the existing
	files for inspiration.
	
	Now what is unique, is that the array of classnames -->["itemClassName 1", "itemClassName 2"]<-- is used to 
	generate a list of random things the box will have in it.  The number of random items from that list is 
	determined by the Quantity1 integer that is at the end of the parent array.  So, if Quantity1 = 1 in our case
	we would end up with either 1 "itemClassName 1" or 1 "itemClassName 2".  If Quantity1=2, then we might have
	2 of "itemClassname 1", or 1&1, or 2 of "itemClassName 2".
	
	So there's also a magical 4th term in the "wep" category array- it is the number of magazines for each weapon
	that is added out of the array.
	
	Now, if you want specific items to spawn in a crate, you'll need to have separate lines for each item you want 
	added in.  This is somewhat messy, but doable.
	
Adding Box Types to addons\...Airdrop...\config.sqf
	Here's an easy part.  You just need to add your new box type into the APOC_AA_SupOptions array of arrays
	[code]
	APOC_AA_SupOptions =
	[
	// ["stringItemName", 	"Crate Type for fn_refillBox 	,Price," drop type"]
	["Launchers", 			"mission_USLaunchers", 			25000, "supply"],
	["Assault Rifle", 		"mission_USSpecial", 			10000, "supply"],
	["Sniper Rifles", 		"airdrop_Snipers", 				25000, "supply"],
	["DLC Rifles", 			"airdrop_DLC_Rifles", 			35000, "supply"],
	["DLC LMGs", 			"airdrop_DLC_LMGs", 			35000, "supply"],
	["Super Awesome Box",	"superAwesomeBox1",			  1000000, "supply"],
	
	//"Menu Text",			"Crate Type", 			"Cost", "drop type"
	["Food",				"Land_Sacks_goods_F",	5000, 	"picnic"],
	["Water",				"Land_BarrelWater_F",	5000, 	"picnic"]
	];
	[/code]
	
	So look at the line for the Super Awesome Box.  The first string is the text you want to see in the menu for the player.
	The second string the name of the box that you put into the fn_refillbox.sqf file.  The third part, the number, is the cost 
	you want the box to cost.  The fourth needs to be "supply", for a multitude of reasons.
	
	With all of this, you should now have new options within the Airdrop Menus.  Good Luck!
	