if (!isServer) exitWith {};

// Admin menu (U key) access levels

/*******************************************************
 Player UID examples :

	"1234567887654321", // Meatwad
	"8765432112345678", // Master Shake
	"1234876543211234", // Frylock
	"1337133713371337"  // Carl

 Important: Don't put a coma at the end of the last one
********************************************************/

// Low Administrators: manage & spectate players, remove hacked vehicles
lowAdmins = compileFinal str
[
	// Put player UIDs here
];

// High Administrators: manage & spectate players, remove hacked vehicles, show player tags
highAdmins = compileFinal str
[
	// Put player UIDs here
];

// Server Owners: access to everything
serverOwners = compileFinal str
[
	// Put player UIDs here
];

/********************************************************/

publicVariable "lowAdmins";
publicVariable "highAdmins";
publicVariable "serverOwners";
