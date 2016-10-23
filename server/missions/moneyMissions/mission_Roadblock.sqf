// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright � 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Roadblock.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private [ "_box1", "_barGate", "_bunker1", "_bunker2", "_obj1", "_obj2", "_drop_item", "_drugpile", "_cashamount", "_cashpile", "_cash"];

_setupVars =
{
	_missionType = "Roadblock";
	_locationsArray = RoadblockMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_markerDir = markerDir _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete;

	_bargate = createVehicle ["Land_BarGate_F", _missionPos, [], 0, "NONE"];
	_bargate setDir _markerDir;
	_bunker1 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [6.5,-2,-4.1], [], 0, "NONE"];
	_obj1 = createVehicle ["I_GMG_01_high_F", _bargate modelToWorld [6.5,-2,-4.1], [], 0, "NONE"];
	_bunker1 setDir _markerDir;
	_bunker2 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [-8,-2,-4.1], [], 0, "NONE"];
	_obj2 = createVehicle ["I_GMG_01_high_F", _bargate modelToWorld [-8,-2,-4.1], [], 0, "NONE"];
	_bunker2 setDir _markerDir;

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_obj1, _obj2, _barGate, _bunker1, _bunker2];  
	{ _x setVariable ["allowDamage", false, true] } forEach [_obj1, _obj2, _barGate, _bunker1, _bunker2];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos,8,12] call createCustomGroup3;

	_missionHintText = format ["Armed bandits have set up a <t color='%1'>Roadblock</t> and are stopping all vehicles! Stop them and retrieve any drugs or money!", moneyMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_barGate, _bunker1, _bunker2, _obj1, _obj2];
};

_drop_item = 
{
	private["_item", "_pos"];
	_item = _this select 0;
	_pos = _this select 1;

	if (isNil "_item" || {typeName _item != typeName [] || {count(_item) != 2}}) exitWith {};
	if (isNil "_pos" || {typeName _pos != typeName [] || {count(_pos) != 3}}) exitWith {};

	private["_id", "_class"];
	_id = _item select 0;
	_class = _item select 1;

	private["_obj"];
	_obj = createVehicle [_class, _pos, [], 5, "None"];
	_obj setPos ([_pos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
	_obj setVariable ["mf_item_id", _id, true];
};

_successExec =
{
	// Mission completed
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_obj1, _obj2, _barGate, _bunker1, _bunker2];
	{ deleteVehicle _x } forEach [_obj1, _obj2, _barGate, _bunker1, _bunker2];
	{ _x setVariable ["allowDamage", true, true] } forEach [_obj1, _obj2, _barGate, _bunker1, _bunker2];

	_drugpile = selectRandom [4,8];

	for "_i" from 1 to _drugpile do
	{
		private["_item"];
		_item = selectRandom [["lsd", "Land_WaterPurificationTablets_F"],["marijuana", "Land_VitaminBottle_F"],["cocaine","Land_PowderedMilk_F"],["heroin", "Land_PainKillers_F"]];
		[_item, _lastPos] call _drop_item;
	};

	_cashamount = round(random 25000);
	_cashpile = selectRandom [3,5];

	for "_i" from 1 to _cashpile do
	{
		_cash = createVehicle ["Land_Money_F",[(_lastPos select 0), (_lastPos select 1) - 5,0],[], 0, "NONE"];
		_cash setPos ([_lastPos, [[2 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable ["cmoney", _cashamount, true];
		_cash setVariable ["owner", "world", true];
	};

	_successHintMessage = format ["The roadblock has been captured. The drugs and money are yours"];
};

_this call moneyMissionProcessor;