// A3Wasteland config file
// You will need to shutdown the server to edit settings in this file!
// To enable base saving your server NEEDS to run with the iniDBI mod! Get it at http://forums.bistudio.com/showthread.php?167927
// if you have any doubts and/or questions about the mission find us at a3wasteland.com 

// General settings
A3W_startHour = 15;                 // In-game hour at mission start (0 to 23)
A3W_moonLight = 1;                 // Moon light during night (0 = no, 1 = yes)
A3W_startingMoney = 100;           // Amount of money that players start with
A3W_showGunStoreStatus = 1;        // Show enemy and friendly presence at gunstores on map (0 = no, 1 = yes)
A3W_gunStoreIntruderWarning = 1;   // Warn players in gunstore areas of enemy intruders (0 = no, 1 = yes)

// Persistence settings (requires iniDBI addon)
A3W_playerSaving = 0;              // Save player data like position, health, inventory, etc. (0 = no, 1 = yes)
A3W_moneySaving = 1;               // If playerSaving = 1, save player money amount (0 = no, 1 = yes)
A3W_combatAbortDelay = 60;         // If playerSaving = 1, delay in seconds for which to disable abort and respawn buttons after firing or being shot (0 = none)
A3W_baseSaving = 0;                // Save locked base parts between server restarts (0 = no, 1 = yes)
A3W_boxSaving = 0;                 // Save locked weapon crates and their contents between server restarts (0 = no, 1 = yes)
A3W_warchestSaving = 0;            // Save warchest objects deployed by players between server restarts (0 = no, 1 = yes)
A3W_warchestMoneySaving = 0;       // Save warchest team money between server restarts (0 = no, 1 = yes)
A3W_spawnBeaconSaving = 0;         // Save spawn beacons between server restarts (0 = no, 1 = yes)
A3W_objectLifetime = 5*24;         // Maximum lifetime in hours for saved objects (baseparts, crates, etc.) across server restarts (0 = no time limit)
PDB_ServerID = "A3W_";             // iniDB savefiles prefix (change this in case you run multiple servers from the same folder)

// Spawning settings
A3W_serverSpawning = 1;            // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_vehicleSpawning = 1;           // If serverSpawning = 1, spawn vehicles in towns (0 = no, 1 = yes)
A3W_boatSpawning = 1;              // If serverSpawning = 1, spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;              // If serverSpawning = 1, spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 1;             // If serverSpawning = 1, spawn planes at some airfields (0 = no, 1 = yes)
A3W_boxSpawning = 0;               // If serverSpawning = 1, spawn weapon crates in 50% towns (0 = no, 1 = yes)
A3W_baseBuilding = 1;              // If serverSpawning = 1, spawn base parts in towns (0 = no, 1 = yes)

// Loot settings
A3W_buildingLoot = 1;              // Spawn loot in all buildings (0 = no, 1 = yes)
A3W_vehicleloot = 1;               // Level of loot added to vehicles (0 = none, 1 = weapon OR items, 2 = weapon AND items, 3 = two weapons AND items) - 2 or 3 recommended if buildingLoot = 0

// Mission settings
A3W_serverMissions = 1;            // Enable server missions (0 = no, 1 = yes)
A3W_missionsDifficulty = 0;        // Missions difficulty (0 = normal, 1 = hard)

// Work-in-progress to be included in v1:
// A3W_heliPatrolMissions = 1;        // Enable missions involving flying helicopters piloted by AI (0 = no, 1 = yes)
// A3W_underWaterMissions = 1;        // Enable underwater missions which require diving gear (0 = no, 1 = yes)
// A3W_mainMissionTimeout = 60*60;    // Time in seconds that a Main Mission will run for, unless completed
// A3W_mainMissionDelay = 10*60;      // Time in seconds between Main Missions
// A3W_sideMissionTimeout = 45*60;    // Time in seconds that a Side Mission will run for, unless completed
// A3W_sideMissionDelay = 5*60;       // Time in seconds between Side Missions
// A3W_moneyMissionTimeout = 60*60;   // Time in seconds that a Money Mission will run for, unless completed
// A3W_moneyMissionDelay = 15*60;     // Time in seconds between Money Missions
// A3W_missionCompleteRadius = 99999; // Radius from a mission in which a player must be present in order mark it as complete after AIs are killed
