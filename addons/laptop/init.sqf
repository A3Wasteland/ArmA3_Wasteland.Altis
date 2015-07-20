/*
 =======================================================================================================================

	File:		init.sqf
	Author:		T-800a

=======================================================================================================================
*/

enableSaving [ false, false ];

call compile preprocessFile "addons\laptop\downloadData.sqf";

waitUntil { !isNil "downloadDataDONE" };
