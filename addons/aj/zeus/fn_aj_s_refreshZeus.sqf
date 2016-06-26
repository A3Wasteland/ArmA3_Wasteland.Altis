scriptName "fn_aj_s_refreshZeus";
// @file Name: fn_aj_s_refreshZeus.sqf
// @file Author:  wiking.at
// @file Author: www.armajunkies.de

if (isServer) then {
    // Refresh map objects if zeus ui is opened
	
	private "_zeusUID";
	_zeusUID = _this;	
	_zeusUID = missionnamespace  getvariable[_zeusUID,0];
	
		{
		_zeusUID addCuratorEditableObjects [[_x],true];
		} 
		foreach (allMissionObjects "All");

	
};