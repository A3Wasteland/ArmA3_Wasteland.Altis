// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellIncludesStart.sqf
//	@file Author: AgentRev

#define PRICE_DEBUGGING false
#define CARGO_STRING(OBJ) (str getWeaponCargo OBJ + str getMagazineCargo OBJ + str getItemCargo OBJ + str getBackpackCargo OBJ)
#define GET_HALF_PRICE(PRICE) ((ceil (((PRICE) / 2) / 5)) * 5)

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};
