// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getVehicleVars.sqf
//	@file Author: AgentRev

// [key name, data type], vLoad variable name

[
	[["Class", "STRING"], "_class"],
	[["Position", "ARRAY"], "_pos"],
	[["Direction", "ARRAY"], "_dir"],
	[["HoursAlive", "NUMBER"], "_hoursAlive"],
	[["HoursUnused", "NUMBER"], "_hoursUnused"],
	[["Damage", "NUMBER"], "_damage"],
	[["Fuel", "NUMBER"], "_fuel"],
	[["HitPoints", "ARRAY"], "_hitPoints"],
	[["AnimPhases", "ARRAY"], "_animPhases"],
	[["OwnerUID", "STRING"], "_owner"],
	[["LockState", "NUMBER"], "_lockState"],
	[["Variables", "ARRAY"], "_variables"],
	[["Textures", "ARRAY"], "_textures"],
	[["Weapons", "ARRAY"], "_weapons"],
	[["Magazines", "ARRAY"], "_magazines"],
	[["Items", "ARRAY"], "_items"],
	[["Backpacks", "ARRAY"], "_backpacks"],
	[["TurretMagazines", "ARRAY"], "_turretMags"], // deprecated
	[["TurretMagazines2", "ARRAY"], "_turretMags2"], // regular mags
	[["TurretMagazines3", "ARRAY"], "_turretMags3"], // pylons
	[["AmmoCargo", "NUMBER"], "_ammoCargo"],
	[["FuelCargo", "NUMBER"], "_fuelCargo"],
	[["RepairCargo", "NUMBER"], "_repairCargo"]
]
