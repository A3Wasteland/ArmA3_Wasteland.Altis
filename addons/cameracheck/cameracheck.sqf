// @file Name: cameraChecks.sqf
// @file Author: AgentRev, Wiking
 
if (!hasInterface) exitWith {};
 
private ["_fpOnFoot", "_forceFP", "_forceFPveh"];
_fpOnFoot = (difficultyEnabled "3rdPersonView" && ["A3W_firstPersonCamOnFoot"] call isConfigOn);
_fpNotDriver = (difficultyEnabled "3rdPersonView" && ["A3W_firstPersonCamNotDriver"] call isConfigOn);
 
while {true} do
{
	waitUntil
	{
		_forceFP = (_fpOnFoot && alive player && cameraOn == player);  //check if camera is on player
		_forceFPveh = (_fpNotDriver && alive player &&  cameraOn == (vehicle player) && (player != driver (vehicle player))); //Camera on player in vehicle, not driver
		((_forceFP && cameraView == "EXTERNAL") || (_forceFPveh && cameraView == "EXTERNAL") || cameraView == "GROUP")
	};
 
if (cameraView == "GROUP") then   //Disable Commander View
{
	cameraOn switchCamera "EXTERNAL";
};
 
if (_forceFP && cameraView == "EXTERNAL") then
{
	cameraOn switchCamera "INTERNAL";
};

if (_forceFPveh && cameraView == "EXTERNAL") then
{
	cameraOn switchCamera "INTERNAL";
};
};