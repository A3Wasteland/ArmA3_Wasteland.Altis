// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// A3Wasteland config file
// You will need to shutdown the server to edit settings in this file!

// All saving is done via the server's profileNamespace by default; iniDBI will be automatically used if you have if installed
// if you have any doubts and/or questions about the mission find us at a3wasteland.com 
// This file is overridden by the external file "A3Wasteland_settings\main_config.sqf" if present

// General settings
A3W_startHour = 15;                // In-game hour at mission start (0 to 23)
A3W_timeMultiplierDay = 1.0;       // Sets the speed of time between 5 AM and 8 PM (for example, 6.0 means 6 hours in-game will pass in 1 real hour)
A3W_timeMultiplierNight = 1.0;     // Sets the speed of time between 8 PM and 5 AM
A3W_moonLight = 1;                 // Moon light during night (0 = no, 1 = yes)
A3W_teamPlayersMap = 1;            // Show all friendly players on the map at all times, regardless of difficulty level (0 = no, 1 = yes)
A3W_globalVoiceWarnTimer = 5;      // Number of seconds for which global voice chat must be active before triggering a warning (0 = disabled)
A3W_globalVoiceMaxWarns = 5;       // Number of global voice warnings after which the player will be killed and crashed (0 = disabled)
A3W_antiHackMinRecoil = 1.0;       // Minimum recoil coefficient enforced by the antihack (recommended values: default = 1.0, TMR Mod = 0.5, VTS Weapon Resting = 0.25)
A3W_spawnBeaconCooldown = 5*60;    // Number of seconds to wait between each use of an individual spawn beacon (0 = disabled)
A3W_spawnBeaconSpawnHeight = 1500; // Altitude in meters at which players will spawn when using spawn beacons (0 = ground/sea)
A3W_vehicleThermals = 0;		   // Allow vehicles to use thermals (0 = disabled)
A3W_resupplyCostPR = 4;			   // Determine resupply cost by vehicle store cost / A3W_resupplyCostPR. (4 = default, %25 percent)
A3W_firstPersonCamOnFoot = 0;	   // Lock infantry to first person view
A3W_firstPersonCamNotDriver = 0;   // Lock all vehicle seating positions besides driver to first person view

// Store settings
A3W_showGunStoreStatus = 1;        // Show enemy and friendly presence at gunstores on map (0 = no, 1 = yes)
A3W_gunStoreIntruderWarning = 1;   // Warn players in gunstore areas of enemy intruders (0 = no, 1 = yes)
A3W_remoteBombStoreRadius = 75;    // Prevent players from placing remote explosives within this distance from any store (0 = disabled)
A3W_vehiclePurchaseCooldown = 60;  // Number of seconds to wait before allowing someone to purchase another vehicle, don't bother setting it too high because it can be bypassed by rejoining


// Player settings
A3W_startingMoney = 100;           // Amount of money that players start with
A3W_unlimitedStamina = 1;          // Allow unlimited sprinting, jumping, etc. (0 = no, 1 = yes) - this also removes energy drinks from the mission
A3W_bleedingTime = 60;             // Time in seconds for which to allow revive after a critical injury (minimum 10 seconds)

// Persistence settings
A3W_savingMethod = "extDB";      // Method used for saving data ("profile", "iniDB", "extDB")
A3W_playerSaving = 1;              // Save player data like position, health, inventory, etc. (0 = no, 1 = yes)
A3W_moneySaving = 1;               // If playerSaving = 1, save player money amount (0 = no, 1 = yes)
A3W_combatAbortDelay = 60;         // If playerSaving = 1, delay in seconds for which to disable abort and respawn buttons after firing or being shot (0 = none)
A3W_purchasedVehicleSaving = 1;    // Save vehicles purchased at vehicle stores between server restarts (0 = no, 1 = yes)
A3W_missionVehicleSaving = 1;      // Save vehicles captured from missions between server restarts (0 = no, 1 = yes)
A3W_baseSaving = 1;                // Save locked base parts between server restarts (0 = no, 1 = yes)
A3W_boxSaving = 1;                 // Save locked weapon crates and their contents between server restarts (0 = no, 1 = yes)
A3W_staticWeaponSaving = 1;        // Save locked static weapons and their magazines between server restarts (0 = no, 1 = yes)
A3W_warchestSaving = 1;            // Save warchest objects deployed by players between server restarts (0 = no, 1 = yes)
A3W_warchestMoneySaving = 1;       // Save warchest team money between server restarts (0 = no, 1 = yes)
A3W_spawnBeaconSaving = 1;         // Save spawn beacons between server restarts (0 = no, 1 = yes)
A3W_objectLifetime = 5*24;         // Maximum lifetime in hours for saved objects (baseparts, crates, etc. except vehicles) across server restarts (0 = no time limit)
A3W_vehicleLifetime = 0;           // Maximum lifetime in hours for saved vehicles across server restarts, regardless of usage (0 = no time limit)
A3W_vehicleMaxUnusedTime = 2*24;   // Maximum parking time in hours after which unused saved vehicles will be marked for deletion (0 = no time limit)
A3W_serverSavingInterval = 1*60;   // Interval in seconds between automatic vehicle & object saves; should be kept at 1 min for profileNamespace and iniDB, while for extDB it can be relaxed to 3-5 mins

// iniDB settings
PDB_PlayerFileID = "A3W_";         // Player savefile prefix (if you run multiple servers, keep it the same for all of them)
PDB_ObjectFileID = "A3W_";         // Object savefile prefix (if you run multiple servers, change it to a unique value for each server)

// extDB settings
A3W_extDB_ServerID = 1;            // Server ID to use in the database for the particular server running off this config file; if you have multiple servers, they all need different IDs
A3W_extDB_Environment = "normal";  // Value used to separate player & object data from multiple environments running on the same map (e.g. "normal", "hardcore", "dev", etc. can be whatever you want)
A3W_extDB_SaveUnlockedObjects = 1; // Save and restore unlocked baseparts that were locked at least once during their lifetime (0 = no, 1 = yes)
A3W_extDB_ConfigName = "A3W";      // Name of the connection config from extdb-conf.ini to be used (the one within [brackets])
A3W_extDB_IniName = "a3wasteland"; // Name of the INI file in extDB\db_custom to be used
A3W_extDB_Debug = 0;               // Log all queries to server RPT (0 = no, 1 = yes)

// Spawning settings
A3W_serverSpawning = 1;            // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_vehicleSpawning = 1;           // If serverSpawning = 1, spawn vehicles in towns (0 = no, 1 = yes)
A3W_vehicleQuantity = 200;         // Approximate number of land vehicles to be spawned in towns
A3W_boatSpawning = 1;              // If serverSpawning = 1, spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;              // If serverSpawning = 1, spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 1;             // If serverSpawning = 1, spawn planes at some airfields (0 = no, 1 = yes)
A3W_boxSpawning = 0;               // If serverSpawning = 1, spawn weapon crates in 50% towns (0 = no, 1 = yes)
A3W_baseBuilding = 1;              // If serverSpawning = 1, spawn base parts in towns (0 = no, 1 = yes)
A3W_essentialsSpawning = 1;			// If serverSpawning = 1, spawn essential items (food, water and ammo crates) in towns (0 = no, 1 = yes. If A3W_baseBuilding = 1, then essentialsSpawning = 1;)


// Loot settings
A3W_buildingLootWeapons = 0;       // Spawn weapon loot in all buildings (0 = no, 1 = yes)
A3W_buildingLootSupplies = 1;      // Spawn supply loot (backpacks & player items) in all buildings (0 = no, 1 = yes)
A3W_buildingLootChances = 25;      // Chance percentage that loot will spawn at each spot in a building (0 to 100)
A3W_vehicleLoot = 2;               // Level of loot added to vehicles (0 = none, 1 = weapon OR items, 2 = weapon AND items, 3 = two weapons AND items) - 2 or 3 recommended if buildingLoot = 0

// Territory settings
A3W_territoryCaptureTime = 3*60;   // Time in seconds needed to capture a territory
A3W_territoryPayroll = 1;          // Periodically reward sides and indie groups based on how many territories they own (0 = no, 1 = yes)
A3W_payrollInterval = 30*60;       // Delay in seconds between each payroll
A3W_payrollAmount = 100;           // Amount of money rewarded per territory on each payroll
A3W_territoryAllowed = [0,1,2,3,4,5,6,7,8,9]; //Territory Allowed (0:KAVALA,1:ALTISAIR,2:PYRGOS,3:SELANKANO,4:KORE,5:ZAROS,6:DOCKS,7:GHOST,8:ABDERA,9:PANOCHORI)

// Mission settings
A3W_serverMissions = 1;            // Enable server missions (0 = no, 1 = yes)
A3W_missionsDifficulty = 0;        // Missions difficulty (0 = normal, 1 = hard)
A3W_missionFarAiDrawLines = 1;     // Draw small red lines on the map from mission markers to individual units & vehicles which are further away than 75m from the objective (0 = no, 1 = yes)
A3W_missionsQuantity = 6;          // Number of missions running at the same time (0 to 6)
A3W_heliPatrolMissions = 1;        // Enable missions involving flying helicopters piloted by AI (0 = no, 1 = yes)
A3W_underWaterMissions = 1;        // Enable underwater missions which require diving gear (0 = no, 1 = yes)
A3W_mainMissionDelay = 10*60;      // Time in seconds between Main Missions
A3W_mainMissionTimeout = 60*60;    // Time in seconds that a Main Mission will run for, unless completed
A3W_sideMissionDelay = 5*60;       // Time in seconds between Side Missions
A3W_sideMissionTimeout = 45*60;    // Time in seconds that a Side Mission will run for, unless completed
A3W_moneyMissionDelay = 15*60;     // Time in seconds between Money Missions
A3W_moneyMissionTimeout = 60*60;   // Time in seconds that a Money Mission will run for, unless completed
