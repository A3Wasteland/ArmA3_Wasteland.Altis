// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: briefing.sqf

if (!hasInterface) exitWith {};

waitUntil {!isNull player};

player createDiarySubject ["infos", "Infos and Help"];
player createDiarySubject ["changelog", "Changelog"];
player createDiarySubject ["credits", "Credits"];

player createDiaryRecord ["changelog",
[
"v1.1b",
"
<br/>[Added] Marksmen DLC content
<br/>[Added] Prevent usage of commander camera
<br/>[Added] Emergency eject hotkey (Ctrl + " + actionKeysNames "GetOut" + ")
<br/>[Added] Restricted UAV connection to owner's group
<br/>[Changed] Improved purchased vehicle setup time
<br/>[Changed] Admins can now use global voice chat
<br/>[Changed] Updated antihack
<br/>[Fixed] Corpses not being ejected from vehicles
<br/>[Fixed] Thermal imaging not working for UAVs
<br/>[Fixed] Various minor bugfixes and optimizations
"
]];

player createDiaryRecord ["changelog",
[
"v1.1",
"
<br/>[Added] ATMs
<br/>[Added] Union Jack vehicle color
<br/>[Added] Skins hidden in gamefiles for MH-9, Mohawk, and Taru
<br/>[Added] Improved admin spectate camera by micovery
<br/>[Added] Earplugs (End key)
<br/>[Changed] Full rewrite of vehicle respawning system
<br/>[Fixed] Player moved to position too early during save restore
<br/>[Fixed] Mission timeout not extending on AI kill
<br/>[Fixed] Admin teamkill unlocking
<br/>[Fixed] Improved FPS fix
<br/>[Fixed] Running animation parachute glitch
<br/>[Fixed] Various other minor bugfixes and optimizations
"
]];

player createDiaryRecord ["changelog",
[
"v1.0c",
"
<br/>[Added] MySQL support via extDB extension
<br/>[Added] Town Invasion mission
<br/>[Added] Chain-reaction player kill tracking
<br/>[Added] Force Save action for purchased and captured vehicles
<br/>[Added] Autokick players previously detected by antihack
<br/>[Added] Entity caching script for headless client
<br/>[Added] Tron suits to general store
<br/>[Added] Red lines on map for AIs wandering away from missions
<br/>[Changed] Mission timeout gets extended on AI kill
<br/>[Changed] Transport Heli mission Taru variant to Bench
<br/>[Changed] Spawn beacon item drop to sleeping bag
<br/>[Fixed] More money exploits
<br/>[Fixed] Scoreboard ordering
<br/>[Fixed] Vehicle repair & refuel sometimes not working
<br/>[Fixed] Injured players' corpses being deleted on disconnect
<br/>[Fixed] Static weapon disassembly prevention
<br/>[Fixed] Excess bought rockets ending up in uniform or vest
<br/>[Fixed] Various other minor bugfixes and optimizations
"
]];

player createDiaryRecord ["changelog",
[
"v1.0b",
"
<br/>[Added] Helicopters DLC content
<br/>[Added] Revamped respawn menu
<br/>[Added] 250m altitude limit for territory capture
<br/>[Added] HALO insertion on spawn beacons
<br/>[Added] New vehicle store textures
<br/>[Changed] Increased damage done to planes by 50%
<br/>[Changed] Plane engines shutdown when above 90% damage
<br/>[Changed] Player names can also be toggled with Home key
<br/>[Changed] Increased ATGM UAV price
<br/>[Changed] Increased prices from thermal scopes again
<br/>[Changed] Minor edits to spawn loadouts
<br/>[Fixed] FPS drop that began in v0.9h
<br/>[Fixed] Saved UAVs not being connectable
<br/>[Fixed] Indies unable to get in UGVs
<br/>[Fixed] Blinking fog
<br/>[Fixed] Clipped numbers on scoreboard
<br/>[Fixed] Minor other optimizations and fixes
"
]];

player createDiaryRecord ["changelog",
[
"v1.0",
"
<br/>[Added] Custom scoreboard
<br/>[Added] Mission and store vehicle saving
<br/>[Added] Player markers on GPS and UAV Terminal
<br/>[Added] Holster actions
<br/>[Changed] Full rewrite of side mission system
<br/>[Changed] Windows key toggles player marker names too
<br/>[Changed] New loading picture by Gameaholic.se
<br/>[Fixed] Weapon sometimes disppearing when moving objects
<br/>[Fixed] More money duping exploits
<br/>[Fixed] Store menu sizes on smaller aspect ratios
<br/>[Fixed] Hunger and thirst reset on rejoin
<br/>[Fixed] Other minor optimizations and fixes
"
]];

player createDiaryRecord ["changelog",
[
"0.9h",
"
<br/>[Added] Custom revive system based on Farooq's Revive
<br/>[Added] Territory payroll at regular intervals
<br/>[Added] Emergency eject and free parachutes (jump key)
<br/>[Added] Player names toggled with Windows key
<br/>[Added] Increased missile damage against tanks and helis
<br/>[Added] Ability to stash money in weapon crates
<br/>[Added] Ability to sell vehicle inventory at stores
<br/>[Added] More money shipment mission variants
<br/>[Added] Reduced wheel damage from collisions
<br/>[Added] Wreck salvaging
<br/>[Added] Selling bin in stores
<br/>[Added] Karts DLC content in stores
<br/>[Added] Camo sniper rifles in gunstore
<br/>[Added] Repair Offroad in vehicle store
<br/>[Added] Team players on map as server option
<br/>[Added] Unlimited stamina server option
<br/>[Added] Static weapon saving server option
<br/>[Added] More push vehicle actions
<br/>[Added] Paradrop option for airlifted vehicles
<br/>[Added] Preload checkbox on respawn menu
<br/>[Added] Remote explosives store distance restriction
<br/>[Added] Server time multipliers for day and night
<br/>[Added] Addon-less profileNamespace server persistence
<br/>[Added] Linux server compatibility
<br/>[Added] Basic support for headless client
<br/>[Changed] Independent territory capture is now group-based
<br/>[Changed] Towns blocked if more enemies than friendlies
<br/>[Changed] Increased ammo/fuel/repair cargo for resupply trucks
<br/>[Changed] Increased territory capture rewards for Altis
<br/>[Changed] Increased money mission rewards
<br/>[Changed] Weapon loot in buildings now disabled by default
<br/>[Changed] Mission crates loot was made more random
<br/>[Changed] Thermal imaging is now available on UAVs
<br/>[Changed] Increased vehicle store prices
<br/>[Changed] Increased prices for thermal optics
<br/>[Changed] Increased player icons up to 2000m
<br/>[Changed] Improved antihack
<br/>[Changed] Improved FPS
<br/>[Fixed] Vehicle store purchase errors due to server lag
<br/>[Fixed] Corpse created when leaving with player saving
<br/>[Fixed] Custom vehicle damage handling not working
<br/>[Fixed] Indie-indie spawn beacon stealing
<br/>[Fixed] Repair kit and jerrycan distance limit
<br/>[Fixed] Spawn beacon packing and stealing restrictions
<br/>[Fixed] Not able to lock static weapons
<br/>[Fixed] Unbreakable store windows
<br/>[Fixed] Stratis airbase gunstore desk glitches
<br/>[Fixed] Missions sometimes completing instantaneously
<br/>[Fixed] Object ammo/fuel/repair cargo not saving
<br/>[Fixed] Respawn menu aspect ratio on some resolutions
<br/>[Fixed] Minor bugs with group system
<br/>[Fixed] Minor bugs with player items
<br/>[Fixed] Various other minor bugfixes and optimizations
"
]];

player createDiaryRecord ["changelog",
[
"0.9g",
"
<br/>[Added] - Vehicle stores
<br/>[Added] - New lootspawner by Na_Palm, stuff in ALL buildings
<br/>[Added] - New jets and truck added in A3 v1.14
<br/>[Added] - New AAF vehicles added in A3 v1.08
<br/>[Added] - New camos for Mk20 and MX in gunstores
<br/>[Added] - Ability to push plane backwards
<br/>[Added] - Ability to sell quadbike contents like crates
<br/>[Added] - Abort delay during combat when player saving on
<br/>[Changed] - Improved respawn menu
<br/>[Changed] - Respawn now longer to preload destination
<br/>[Changed] - Optimized player icons
<br/>[Changed] - Optimized FPS fix
<br/>[Changed] - Improved server persistence (requires iniDBI v1.4+)
<br/>[Changed] - Improved player saving (server-specific)
<br/>[Changed] - Improved base saving (server-specific)
<br/>[Changed] - Reduced starting gear
<br/>[Changed] - Modified some store prices
<br/>[Changed] - Reduced initial fuel in cars and helis
<br/>[Changed] - Removed Buzzard jet from too short runways
<br/>[Changed] - Removed Kavala castle territory for use as base
<br/>[Changed] - Increased vehicle repair time to 20 sec.
<br/>[Changed] - Increased owner unlocking time to 10 sec.
<br/>[Changed] - Toggling spawn beacon perms is now instant
<br/>[Changed] - Improved Take option for player items
<br/>[Changed] - Added option to cancel towing selection
<br/>[Changed] - Added machine gunner to main mission NPCs
<br/>[Changed] - Added grenadier to side mission NPCs
<br/>[Fixed] - Error messages in various menus
<br/>[Fixed] - Crash when toggling spawn beacon perms
<br/>[Fixed] - Error when hacking warchests
<br/>[Fixed] - Vehicle towing and lifting positions
<br/>[Fixed] - Repair Vehicle option showing for brand new vehicles
<br/>[Fixed] - Vest purchase price
<br/>[Fixed] - Vest and helmet armor value
<br/>[Fixed] - NPC leader now has launcher ammo
"
]];

player createDiaryRecord ["changelog",
[
"0.9f",
"
<br/>[Added] - Money missions
<br/>[Added] - Sell Crate Items option at stores when moving crate
<br/>[Changed] - Reorganized loots for crates and trucks
<br/>[Fixed] - Broken Warchest menu
<br/>[Fixed] - Spawn beacons not working for Independent groups
<br/>[Fixed] - Player icons position inside buildings
<br/>[Fixed] - MRAPs and quadbikes not spawning
<br/>[Fixed] - Broken money rewards for territories
"
]];

player createDiaryRecord ["changelog",
[
"0.9e",
"
<br/>[Added] - Territory system
<br/>[Added] - Jumping option (step over while running)
<br/>[Added] - New weapons from v1.04 update
<br/>[Changed] - Water and food now use water bottles and baked beans
<br/>[Fixed] - Store object purchases not operating as intended
<br/>[Fixed] - Objects purchased from stores not saving properly
<br/>[Fixed] - Minor server-side memory leak
"
]];

player createDiaryRecord ["changelog",
[
"0.9d",
"
<br/>[Added] - Store object purchases
<br/>[Changed] - New UI by KoS
"
]];

player createDiaryRecord ["changelog",
[
"0.9c",
"
<br/>[Changed] - Instant money pickup and drop
<br/>[Changed] - Increased plane and heli spawning odds
<br/>[Fixed] - FPS fix improvements
<br/>[Fixed] - Vehicles disappearing when untowed or airdropped
"
]];

player createDiaryRecord ["changelog",
[
"0.9b",
"
<br/>[Initial release] - Welcome to Altis!
"
]];


player createDiaryRecord ["credits",
[
"Credits",
"
<br/><font size='16' color='#BBBBBB'>Developed by A3Wasteland.com:</font>
<br/>	* AgentRev (TeamPlayerGaming)
<br/>	* JoSchaap (GoT/Tweakers.net)
<br/>	* MercyfulFate
<br/>	* His_Shadow (KoS/KillonSight)
<br/>	* Bewilderbeest (KoS/KillonSight)
<br/>	* Torndeco
<br/>	* Del1te (404Games)
<br/>
<br/><font size='16' color='#BBBBBB'>Original Arma 2 Wasteland missions by:</font>
<br/>	* Tonic
<br/>	* Sa-Matra
<br/>	* MarKeR
<br/>
<br/><font size='16' color='#BBBBBB'>Improved and ported to Arma 3 by 404Games:</font>
<br/>	* Deadbeat
<br/>	* Costlyy
<br/>	* Pulse
<br/>	* Domuk
<br/>
<br/><font size='16' color='#BBBBBB'>Other contributors:</font>
<br/>	* 82ndab-Bravo17 (GitHub)
<br/>	* afroVoodo (Armaholic)
<br/>	* Austerror (GitHub)
<br/>	* AWA (OpenDayZ)
<br/>	* bodybag (Gameaholic.se)
<br/>	* code34 (iniDBI)
<br/>	* Das Attorney (Jump MF)
<br/>	* Ed! (404Games forums)
<br/>	* Farooq (GitHub)
<br/>	* HatchetHarry (GitHub)
<br/>	* Hub (TeamPlayerGaming)
<br/>	* k4n30 (GitHub)
<br/>	* Krunch (GitHub)
<br/>	* madbull (R3F)
<br/>	* Mainfrezzer (Magnon)
<br/>	* meat147 (GitHub)
<br/>	* micovery (GitHub)
<br/>	* Na_Palm (BIS forums)
<br/>	* red281gt (GitHub)
<br/>	* RockHound (BierAG)
<br/>	* s3kShUn61 (GitHub)
<br/>	* Sa-Matra (BIS forums)
<br/>	* Sanjo (GitHub)
<br/>	* SCETheFuzz (GitHub)
<br/>	* Shockwave (A3W forums)
<br/>	* SicSemperTyrannis (iniDB)
<br/>	* SPJESTER (404Games forums)
<br/>	* spunFIN (BIS forums)
<br/>	* Tonic (BIS forums)
<br/>	* wiking.at (A3W forums)
<br/>	* Zenophon (BIS Forums)
<br/>
<br/><font size='16'>Thanks A LOT to everyone involved for the help and inspiration!</font>
"
]];


player createDiaryRecord ["infos",
[
"Hints and Tips",
"
<br/><font size='18'>A3Wasteland</font>
<br/>
<br/>* At the start of the game, spread out and find supplies before worrying about where to establish a meeting place or a base, supplies are important and very valuable.
<br/>
<br/>* When picking a base location, it is best advised to pick a place that is out of the way and not so obvious such as airports, cities, map-bound bases, etc. remember, players randomly spawn in and around towns and could even spawn inside your base should you set it up in a town.
<br/>
<br/>* If you spawn in an area with no vehicles or supplies in the immediate area, DO NOT just click respawn from the pause menu, chances are if you search an area of a few hundred meters, you will find something.
<br/>
<br/>* Always be on the lookout for nightvision. they are located in the ammo crates, and there are pairs scattered throughout vehicles. You can also purchase them from the gunstores. Nighttime without them SUCKS, and if you have them, you can conduct stealth raids on enemy bases under the cover of complete darkness.
<br/>
<br/>* When you set up a base, never leave your supplies unguarded, one guard will suffice, but it is recommended you have at least 2, maybe 3 guards at base at all times.
<br/>
<br/>* There are very aggressive AI characters that spawn with most missions and will protect the mission objectives with deadly force, be aware of them.
"
]];

player createDiaryRecord ["infos",
[
"About Wasteland",
"
<br/>Wasteland is a team versus team versus team sandbox survival experience. The objective of this mission is to rally your faction, scavenge supplies, weapons, and vehicles, and destroy the other factions. It is survival at its best! Keep in mind this is a work in progress, please direct your reports to http://forums.a3wasteland.com/
<br/>
<br/>FAQ:
<br/>
<br/>Q. What am I supposed to do here?
<br/>A. See the above description
<br/>
<br/>Q. Where can I get a gun?
<br/>A. Weapons are found in one of three places, first in ammo crates that come as rewards from missions, inside and outside buildings, and second, in the gear section of the vehicles, which also randomly spawn around the map. The last place to find a gun would be at the gunshops located throughout the map. You can also find them on dead players whose bodies have not yet been looted.
<br/>
<br/>Q. What are the blue circles on the map?
<br/>A. The circles represent town limits. If friendly soldiers are in a town, you can spawn there from the re-spawn menu; however if there is an enemy presence, you will not be able to spawn there.
<br/>
<br/>Q. Why is it so dark, I cant see.
<br/>A. The server has a day/night cycle just like in the real world, and as such, night time is a factor in your survival. It is recommended that you find sources of light or use your Nightvision Goggles as the darkness sets in.
<br/>
<br/>Q. Is it ok for me to shoot my team mates?
<br/>A. If you are member of BLUFOR or OPFOR teams, then you are NOT allowed to shoot or steal items and vehicles from other players. If you play as Independent, you are free to engage anyone as well as team up with anyone you want.
<br/>
<br/>Q. Whats with the canisters, baskets and big bags?
<br/>A. This game has a food and water system that you must stay on top of if you hope to survive. You can collect food and water from food sacks and wells, or baskets and plastic canisters dropped by dead players. Food and water will also randomly spawn around the map.
<br/>
<br/>Q. I saw someone breaking a rule, what do I do?
<br/>A. Simply go into global chat and get the attention of one of the admins or visit our forums, and make a report if the offense is serious.
"
]];
