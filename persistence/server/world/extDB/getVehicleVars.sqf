// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getVehicleVars.sqf
//	@file Author: AgentRev

// DB column name, vLoad variable name

[
	["", "_vehicleID"], // CONCAT('"',ID,'"') in a3wasteland.ini
	["Class", "_class"],
	["Position", "_pos"],
	["Direction", "_dir"],
	["Velocity", "_vel"],
	["Flying", "_flying"],
	["Damage", "_damage"],
	["Fuel", "_fuel"],
	["HitPoints", "_hitPoints"],
	["AnimPhases", "_animPhases"],
	["OwnerUID", "_owner"],
	["LockState", "_lockState"],
	["Variables", "_variables"],
	["Textures", "_textures"],
	["Weapons", "_weapons"],
	["Magazines", "_magazines"],
	["Items", "_items"],
	["Backpacks", "_backpacks"],
	["TurretMagazines", "_turretMags"], // deprecated
	["TurretMagazines2", "_turretMags2"], // regular mags
	["TurretMagazines3", "_turretMags3"], // pylons
	["AmmoCargo", "_ammoCargo"],
	["FuelCargo", "_fuelCargo"],
	["RepairCargo", "_repairCargo"]
]
