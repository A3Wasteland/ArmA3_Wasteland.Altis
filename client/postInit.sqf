// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: postInit.sqf
//	@file Author: AgentRev

if (hasInterface) then
{
	waitUntil {!isNull player};
	player setVariable ["playerSpawning", true, true];
};
