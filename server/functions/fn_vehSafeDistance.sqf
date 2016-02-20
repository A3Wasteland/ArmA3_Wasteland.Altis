// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_vehSafeDistance.sqf
//	@file Author: AgentRev

_vehSize = sizeOf typeOf _this;
(_vehSize / 2) + random (_vehSize / 6)
