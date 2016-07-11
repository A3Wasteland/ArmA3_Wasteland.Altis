// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_selectRandomWeightedPairs.sqf
//	@file Author: AgentRev

private _pairs = _this;
private _values = [];
private _weights = [];

{
	_x params ["_value", ["_weight",1,[0]]];
	_values pushBack _value;
	_weights pushBack _weight;
} forEach _pairs;

[_values, _weights] call fn_selectRandomWeighted
