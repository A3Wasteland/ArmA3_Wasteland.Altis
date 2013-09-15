#include "macros.hpp"
disableSerialization;
private ["_currentCtrl", "_selectedIndex"];

_currentCtrl = _this select 0;    // not really used
_selectedIndex = _this select 1;

// ***
// *** Select the config namespace
// *** and set some global variables to inital values
// ***

switch (_selectedIndex) do 
{
	case 0:
	{
		CurrentRoot = configFile;
		CurrentConfig = configFile;
		ConfigPath = [configFile];
	};
	
	case 1:
	{
		CurrentRoot = missionConfigFile;
		CurrentConfig = missionConfigFile;
		ConfigPath = [missionConfigFile];
	};
    
	case 2:
	{
		CurrentRoot = campaignConfigFile;
		CurrentConfig = campaignConfigFile;
		ConfigPath = [campaignConfigFile];
	}; 
};
GVAR(IndexOrder) = [];

[CurrentRoot,ConfigPath] call GFNC(showConfig);
