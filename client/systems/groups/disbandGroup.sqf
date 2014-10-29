// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: disbandGroup.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

{
	[_x] join grpNull;
}forEach units group player;
