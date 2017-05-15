// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findPilot.sqf
//	@file Author: AgentRev

// this is to make up for the lack of a goddamn "pilot" command to find out whoever the fuck is directly responsible for the movement of a particular vehicle regardless of who's in the driver seat

params [["_vehicle",objNull,[objNull]]];
private _pilot = objNull;

switch (true) do
{
	case (isUavConnected _vehicle): { _pilot = (uavControl _vehicle) select 0 };
	case (isCopilotEnabled _vehicle): { _pilot = _vehicle turretUnit [0] };
};

[_pilot, driver _vehicle] select isNull _pilot
