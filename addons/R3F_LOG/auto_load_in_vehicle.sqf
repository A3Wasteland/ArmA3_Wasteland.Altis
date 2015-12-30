/**
 * Load automatically and instantly a list of sereval objects and/or class names into a vehicle/cargo.
 * 
 * @param 0 the vehicle or cargo to be loaded
 * @param 1 the array of objects and/or class name to load in, which can be a mix of these elements :
 *              object's name set in the editor or object's script variable
 *              class name as a string, if so an object of this class name will be spawned, then loaded
 *              an array ["class_name", quantity] to spawn then load several objects of the same type
 * 
 * @usage The following command loads my_object1 and my_object2 into my_vehicle
 * @usage nul = [my_vehicle, [my_object1, my_object2] ] execVM "R3F_LOG\USER_FUNCT\auto_load_in_vehicle.sqf";
 * 
 * @usage The following command spawns and loads one "Box_IND_Ammo_F" and one "Box_IND_Grenades_F" into my_vehicle
 * @usage nul = [my_vehicle, ["Box_IND_Ammo_F", "Box_IND_Grenades_F"] ] execVM "R3F_LOG\USER_FUNCT\auto_load_in_vehicle.sqf";
 * 
 * @usage The following command spawns and loads two "Box_IND_Ammo_F" and one "Box_IND_Grenades_F" into my_vehicle
 * @usage nul = [my_vehicle, [ ["Box_IND_Ammo_F", 2], "Box_IND_Grenades_F" ] ] execVM "R3F_LOG\USER_FUNCT\auto_load_in_vehicle.sqf";
 * 
 * @usage The following command loads my_object1, two "Box_IND_Ammo_F" and one "Box_IND_Grenades_F" into my_vehicle
 * @usage nul = [my_vehicle, [ my_object1, ["Box_IND_Ammo_F", 2], "Box_IND_Grenades_F" ] ] execVM "R3F_LOG\USER_FUNCT\auto_load_in_vehicle.sqf";
 * 
 * @usage You can replace "my_vehicle" by "this" if you put the line in the initialization line in the mission editor.
 */

if (isServer) then
{
	waitUntil {!isNil "R3F_LOG_active"};
	
	if (R3F_LOG_active) then
	{
		_this call R3F_LOG_FNCT_transporteur_charger_auto;
	};
};