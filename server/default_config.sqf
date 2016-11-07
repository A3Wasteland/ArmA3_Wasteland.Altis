// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// A3Wasteland config file
// You will need to shutdown the server to edit settings in this file!
// All saving is done via the server's profileNamespace by default; iniDBI will be automatically used if you have if installed
// if you have any doubts and/or questions about the mission find us at a3wasteland.com
// This file is overriden by the external file "A3Wasteland_settings\main_config.sqf" if present

// General settings
A3W_teamPlayersMap = 1;            // Show all friendly players on the map at all times, regardless of difficulty level (0 = no, 1 = yes)
//A3W_disableGlobalVoice = 1;        // Auto-switch channel to Direct communication whenever broadcasting voice on global, unless being admin (0 = no, 1 = yes)
A3W_uavControl = "group";          // Restrict connection to UAVs based on ownership ("owner", "group", "side")
A3W_disableUavFeed = 1;            // Force disable UAV PIP feed to prevent thermal camera abuse (0 = no, 1 = yes)
A3W_disableBuiltInThermal = 1;     // Display a black screen if the player tries to use thermal vision built-in a handheld weapon like Titan launcher (0 = no, 1 = yes)
A3W_teamBalance = 50;              // Max percentage of players allowed on Opfor/Blufor from total server population (0 = off) Bluefor/opfor can only exceed this limit if both grow in similar size.

// Time settings
A3W_startHour = 5;                // In-game hour at mission start (0 to 23) - time is saved and restored between server restarts if A3W_timeSaving = 1
A3W_timeMultiplierDay = 1.0;       // Sets the speed of time between 5 AM and 8 PM (for example, 6.0 means 6 hours in-game will pass in 1 real hour)
A3W_timeMultiplierNight = 4.0;     // Sets the speed of time between 8 PM and 5 AM
A3W_moonLight = 1;                 // Moon light during night (0 = no, 1 = yes)

// Player settings
A3W_startingMoney = 10000;          // Amount of money that players start with
A3W_maxMoney = 100000000;            // Maximum amount of money that will save on players and crates
A3W_survivalSystem = 1;            // Food and water are required to stay alive (0 = no, 1 = yes) - 0 removes food and water items from the mission
A3W_unlimitedStamina = 1;          // Allow unlimited sprinting, jumping, etc. (0 = no, 1 = yes) - this also removes energy drinks from the mission
A3W_bleedingTime = 240;             // Time in seconds for which to allow revive after a critical injury (minimum 10 seconds)
A3W_headshotNoRevive = 1;          // Instant death on fatal headshot by enemy player with non-explosive ammo (0 = no, 1 = yes)
A3W_customDeathMessages = 1;       // If difficulty option deathMessages=0, display custom messages related to causes of death, as defined in fn_deathMessage.sqf (0 = no, 1 = yes)
A3W_healthTime = 7*60;             // Seconds till death once starving or dehydrated
A3W_hungerTime = 160*60;           // Seconds till starving
A3W_thirstTime = 120*60;           // Seconds till dehydrated

// Spawn settings
A3W_townSpawnCooldown = 15*60;      // Number of seconds to wait between each spawn on a specific town (0 = disabled)
A3W_spawnBeaconCooldown = 15*60;    // Number of seconds to wait between each use of a specific spawn beacon (0 = disabled)
A3W_spawnBeaconSpawnHeight = 1500;  // Altitude in meters at which players will spawn when using spawn beacons (0 = ground/sea)
A3W_maxSpawnBeacons = 1;            // Maxmimum number of spawn beacons (0 = disabled)

// Antihack settings
A3W_antiHackUnitCheck = 1;         // Detect players who spawn unauthorized AI units (0 = no, 1 = yes) - disable if you have custom unit scripts/mods like AI recruitment or ALiVE
A3W_antiHackMinRecoil = 1.0;       // Mininum recoil coefficient enforced by the antihack (recommended values: default = 1.0, TMR Mod = 0.5, VTS Weapon Resting = 0.25) (minimum: 0.02)

// Store settings
A3W_showGunStoreStatus = 1;        // Show enemy and friendly presence at gunstores on map (0 = no, 1 = yes)
A3W_gunStoreIntruderWarning = 0;   // Warn players in gunstore areas of enemy intruders (0 = no, 1 = yes)
A3W_remoteBombStoreRadius = 300;   // Prevent players from placing any kind of explosive on the ground within this distance from any store (0 = disabled)
A3W_poiObjLockDistance = 600;      // Prevent players from locking objects within this distance from points of interest (stores & mission spawns)
A3W_vehiclePurchaseCooldown = 60;  // Number of seconds to wait before allowing someone to purchase another vehicle, don't bother setting it too high because it can be bypassed by rejoining
A3W_lockVehicles = ["MRAP_01_base_F", "MRAP_02_base_F", "MRAP_03_base_F", "Truck_01_base_F", "Truck_02_base_F", "Truck_03_base_F", "Wheeled_APC_F", "Tank_F", "Helicopter_Base_F", "Plane", "UGV_01_base_F", "LSV_01_base_F", "LSV_02_base_F"];		// List of class names for vehicles that should be automatically locked and saved when bought

// ATM settings
A3W_atmEnabled = 1;                // Enable ATM system (0 = no, 1 = yes)
A3W_atmMaxBalance = 100000000;        // Maximum amount of money that can be stored in a bank account (don't go over 16777216 as numbers start losing accuracy)
A3W_atmTransferFee = 5;            // Fee in percent charged to players for money transfers to other players (0 to 50)
A3W_atmTransferAllTeams = 0;       // Allow money transfers between players of all teams/sides (0 = same team only, 1 = all teams)
A3W_atmEditorPlacedOnly = 0;       // Only allow access via ATMs placed from the mission editor (0 = all ATMs from towns & editor allowed, 1 = ATMs from editor only) Note: Stratis has no town ATMs, only editor ones.
A3W_atmMapIcons = 1;               // Draw small icons on the map that indicate ATM locations (0 = no, 1 = yes)
A3W_atmRemoveIfDisabled = 1;       // Remove all ATMs from map if A3W_atmEnabled is set to 0 (0 = no, 1 = yes)

A3W_bountyMax = 294000;            // Maximum amount of money that can be set as a bounty on someone
A3W_bountyMinStart = 2500;         // Minimum amount of money to start a bounty on someone
A3W_bountyRewardPerc = 70;         // Percentage of cost that goes to bounty reward
A3W_bountyLifetime = 4*24;         // Maximum lifetime in hours for bounty kills to store in DB (storing bounty kills is to prevent from forming groups with someone you collected bounty on)

// Not currently implemented, soon
/*A3W_atmBounties = 1;
A3W_bountyMax = 100000;
A3W_bountyMin = 1000;
A3W_bountyFee = 50;
A3W_bountyKillsLifetime = 3*24;*/

// Persistence settings
A3W_savingMethod = "extDB";        // Method used for saving data ("profile", "iniDB", "extDB")
A3W_playerSaving = 1;              // Save player data like position, health, inventory, etc. (0 = no, 1 = yes)
A3W_moneySaving = 1;               // If playerSaving = 1, save player money amount (0 = no, 1 = yes)
A3W_playerStatsGlobal = 1;         // If playerSaving = 1 and savingMethod = "extDB", players' stats on the scoreboard will be their all-time global values from all servers of your database (0 = no, 1 = yes)
A3W_timeSaving = 1;                // Save and restore in-game clock time between server restarts (0 = no, 1 = yes)
A3W_weatherSaving = 1;             // Save and restore weather settings between server restarts (0 = no, 1 = yes)
A3W_combatAbortDelay = 60;         // If playerSaving = 1, delay in seconds for which to disable abort and respawn buttons after firing or being shot (0 = none)
A3W_vehicleSaving = 1;             // Save purchased and captured vehicles between server restarts (0 = no, 1 = yes)
A3W_baseSaving = 1;                // Save locked base parts between server restarts (0 = no, 1 = yes)
A3W_boxSaving = 1;                 // Save locked weapon crates and their contents between server restarts (0 = no, 1 = yes)
A3W_staticWeaponSaving = 1;        // Save locked static weapons and their magazines between server restarts (0 = no, 1 = yes)
A3W_warchestSaving = 0;            // Save warchest objects deployed by players between server restarts (0 = no, 1 = yes)
A3W_warchestMoneySaving = 0;       // Save warchest team money between server restarts (0 = no, 1 = yes)
A3W_spawnBeaconSaving = 1;         // Save spawn beacons between server restarts (0 = no, 1 = yes)
A3W_objectLifetime = 7*24;         // Maximum lifetime in hours for saved objects (baseparts, crates, etc. except vehicles) across server restarts (0 = no time limit)
A3W_vehicleLifetime = 0;           // Maximum lifetime in hours for saved vehicles across server restarts, regardless of usage (0 = no time limit)
A3W_vehicleMaxUnusedTime = 7*24;   // Maximum parking time in hours after which unused saved vehicles will be marked for deletion (0 = no time limit)
A3W_serverSavingInterval = 1*60;   // Interval in seconds between automatic vehicle & object saves; should be kept at 1 min for profileNamespace and iniDB, while for extDB it can be relaxed to 3-5 mins
A3W_mineSaving = 1;                // Save placed mines between server restarts (0 = no, 1 = yes)
A3W_mineLifetime = 7*24;           // Maximum lifetime in hours for saved mines across server restarts (0 = no time limit)
A3W_privateStorage = 1;            // Enable persistent private storage locations across the map (0 = no, 1 = yes)
A3W_privateParking = 1;            // If vehicleSaving = 1 and savingMethod = "extDB" or "sock", enable persistent private parking locations across the map (0 = no, 1 = yes)
A3W_privateParkingLimit = 2;       // Maximum amount of vehicles allowed in private parking (0 = no limit)
A3W_privateParkingCost = 2500;     // Cost to retrieve an individual vehicle from private parking
A3W_vehicleLocking = 1;            // Enable vehicle locking and lockpicking (0 = no, 1 = yes)

// iniDB settings
PDB_PlayerFileID = "A3W_";         // Player savefile prefix (if you run multiple servers, keep it the same for all of them)
PDB_ObjectFileID = "A3W_";         // Object savefile prefix (if you run multiple servers, change it to a unique value for each server)

// extDB settings
A3W_extDB_ServerID = 1;            // Server ID to use in the database for the particular server running off this config file; if you have multiple servers, they all need different IDs
A3W_extDB_Environment = "normal";  // Value used to separate player & object data from multiple environments running on the same map (e.g. "normal", "hardcore", "dev", etc. can be whatever you want)
A3W_extDB_playerSaveCrossMap = 1;  // Player saves are shared across maps in same environment, with player location saved separately for each map; death resets save on all maps (0 = no, 1 = yes)
A3W_extDB_GhostingTimer = 0;   // Number of seconds a player has to wait when switching between servers running the same map (0 = disabled)
A3W_extDB_GhostingAdmins = 0;      // Apply ghosting restriction to server admins (0 = no, 1 = yes)
A3W_extDB_SaveUnlockedObjects = 0; // Save and restore unlocked baseparts that were purchased or locked at least once during their lifetime (0 = no, 1 = yes)
A3W_extDB_ConfigName = "A3W";      // Name of the connection config from extdb-conf.ini to be used (the one within [brackets])
A3W_extDB_IniName = "a3wasteland"; // Name of the INI file in extDB\sql_custom_v2 to be used
A3W_extDB_Misc = 0;                // Enable extDB Misc Protocol (0 = no, 1 = yes) - no associated features implemented in vanilla A3W
A3W_extDB_Steam = 0;               // Enable extDB Steam Protocol (0 = no, 1 = yes) - no associated features implemented in vanilla A3W
A3W_extDB_Rcon = 0;                // Enable extDB Rcon Protocol (0 = no, 1 = yes) - no associated features implemented in vanilla A3W
A3W_extDB_RconName = "RCON";       // Name of the Rcon config from extdb-conf.ini to be used (the one within [brackets])
A3W_extDB_RconCommands = "KICK-ADDBAN"; // List of dash-separated RCON commands allowed via extDB_Rcon

// Headless client settings
A3W_hcPrefix = "A3W_HC";           // Prefix of the headless client unit names in mission.sqm
A3W_hcObjCaching = 1;              // Enable headless client object caching (0 = no, 1 = yes)
A3W_hcObjCachingID = 1;            // ID of the headless client in charge of object caching (1 or 2)
A3W_hcObjCleanup = 1;              // Enable headless client server cleanup (0 = no, 1 = yes)
A3W_hcObjCleanupID = 1;            // ID of the headless client in charge of object saving (1 or 2)
A3W_hcObjSaving = 1;               // Enable headless client vehicle & object saving (0 = no, 1 = yes)
A3W_hcObjSavingID = 1;             // ID of the headless client in charge of object saving (1 or 2)

// HEADLESS CLIENT NOTES:
// The IDs of HCs are assigned according to the order they connect to the server. The first HC to connect will have ID 1, and the second one will have ID 2.
// It is possible to set both caching and saving IDs to 1, which means both features will run on a single HC, therefore eliminating the need for a second one.
// For object saving, you must make sure that the HC runs from the same folder as your server, or that it has the same config files, as the HC will read them directly like the server.
// For saving with extDB, both server and HC need to connect to the same database, and with iniDB, both server and HC need to access the same db folder.
// HC saving only works with extDB and iniDB. It does NOT work with profileNamespace, as loading takes place on the server and saving on the HC, so loading will fail as profile files are separate.

// Server spawn settings
A3W_serverSpawning = 1;            // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_vehicleSpawning = 1;           // If serverSpawning = 1, spawn vehicles in towns (0 = no, 1 = yes)
A3W_vehicleQuantity = 200;         // Approximate number of land vehicles to be spawned in towns
A3W_boatSpawning = 1;              // If serverSpawning = 1, spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;              // If serverSpawning = 1, spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 0;             // If serverSpawning = 1, spawn planes at some airfields (0 = no, 1 = yes)
A3W_boxSpawning = 0;               // If serverSpawning = 1, spawn weapon crates in 50% towns (0 = no, 1 = yes)
A3W_baseBuilding = 0;              // If serverSpawning = 1, spawn base parts in towns (0 = no, 1 = yes)
A3W_essentialsSpawning = 0;        // If serverSpawning = 1, spawn essential items (food sacks, water barrels, minor supply crates) in towns (0 = no, 1 = yes)

// Loot settings
/*A3W_buildingLootWeapons = 0;       // Spawn weapon loot in all buildings (0 = no, 1 = yes)
A3W_buildingLootSupplies = 0;      // Spawn supply loot (backpacks & player items) in all buildings (0 = no, 1 = yes)
A3W_buildingLootChances = 0;*/       // Chance percentage that loot will spawn at each spot in a building (0 to 100)
A3W_vehicleLoot = 2;               // Level of loot added to vehicles (0 = none, 1 = weapon OR items, 2 = weapon AND items, 3 = two weapons AND items) - 2 or 3 recommended if buildingLoot = 0
A3W_simpleLoot = 0;                // Spawn loot in all buildings (0 = no, 1 = yes)

// Territory settings
A3W_territoryCaptureTime = 5*60;   // Time in seconds needed to capture a territory
A3W_territoryPayroll = 1;          // Periodically reward sides and indie groups based on how many territories they own (0 = no, 1 = yes)
A3W_payrollInterval = 20*60;       // Delay in seconds between each payroll
A3W_payrollAmount = 3500;           // Amount of money rewarded per territory on each payroll
A3W_territoryAllowed = [0, 1, 2, 3, 4, 5, 6, 7]; //Territories allowed

// Mission settings
A3W_serverMissions = 1;            // Enable server missions (0 = no, 1 = yes)
A3W_missionsDifficulty = 1;        // Missions difficulty (0 = normal, 1 = hard)
A3W_missionFarAiDrawLines = 1;     // Draw small red lines on the map from mission markers to individual units & vehicles which are further away than 75m from the objective (0 = no, 1 = yes)
A3W_missionsQuantity = 4;          // Number of missions running at the same time (0 to 6)
A3W_heliPatrolMissions = 1;        // Enable missions involving flying helicopters piloted by AI (0 = no, 1 = yes)
A3W_waterMissionLimit =  1 ;       // Limite o número de missões de água simultâneos
A3W_underWaterMissions = 1;        // Enable underwater missions which require diving gear (0 = no, 1 = yes)
A3W_mainMissionDelay = 15*60;       // Time in seconds between Main Missions
A3W_mainMissionTimeout = 60*60;    // Time in seconds that a Main Mission will run for, unless completed
A3W_sideMissionDelay = 25*60;       // Time in seconds between Side Missions
A3W_sideMissionTimeout = 60*60;    // Time in seconds that a Side Mission will run for, unless completed
A3W_moneyMissionDelay = 35*60;     // Time in seconds between Money Missions
A3W_moneyMissionTimeout = 60*60;   // Time in seconds that a Money Mission will run for, unless completed
