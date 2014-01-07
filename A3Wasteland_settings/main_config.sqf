// A3Wasteland config file
// You will need to shutdown the server to edit settings in this file!
// To enable base saving your server NEEDS to run with the @iniDB mod!
// if you have any doubts and/or questions about the mission find us at a3wasteland.com 

A3W_buildingLoot = 1;        // Spawn and respawn Loot inside buildings in citys (0 = no, 1 = yes)
A3W_startHour = 6;           // In-game hour at mission start (0 to 23)
A3W_moonLight = 1;           // Moon light during night (0 = no, 1 = yes)
A3W_missionsDifficulty = 0;  // Missions difficulty (0 = normal, 1 = hard)
A3W_serverMissions = 1;      // Server main & side missions (0 = no, 1 = yes)
A3W_serverSpawning = 1;      // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_boxSpawning = 1;         // If serverSpawning = 1, also spawn ammo boxes in some towns (0 = no, 1 = yes)
A3W_boatSpawning = 1;        // If serverSpawning = 1, also spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;        // If serverSpawning = 1, also spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 1;       // If serverSpawning = 1, also spawn planes at some airfields (0 = no, 1 = yes)
A3W_baseBuilding = 1;        // If serverSpawning = 1, also spawn basebuilding parts in towns (0 = no, 1 = yes)
A3W_vehicleloot = "medium";
A3W_sideMissionTimeout = (5*60);    // Time in seconds that a Side Mission will run for, unless completed
A3W_sideMissionDelayTime = (1*60);  // Time in seconds between Side Missions, once one is over
A3W_moneyMissionTimeout = (8*60);    // Time in seconds that a Money Mission will run for, unless completed
A3W_moneyMissionDelayTime = (1.2*60);  // Time in seconds between Money Missions, once one is over
A3W_mainMissionTimeout = (10*60);    // Time in seconds that a Main Mission will run for, unless completed
A3W_mainMissionDelayTime = (1.5*60);// Time in seconds between Main Missions, once one is over
A3W_missionRadiusTrigger = 99999;   // Player must be nearer to mission than this in order to complete the mission after killing all AI
A3W_baseSaving = 1;          // Save base objects between restarts (0 = no, 1 = yes) - requires iniDB mod 
A3W_boxSaving = 1;
PDB_ServerID = "any";        // iniDB saves prefix (change this in case you run multiple servers from the same folder)

A3W_showlocationmarker = true;     // If true, shows a red circle in which the player currently is
A3W_showgunstorestatus = false;     // If true shows friendly/enemy state of gun stores
