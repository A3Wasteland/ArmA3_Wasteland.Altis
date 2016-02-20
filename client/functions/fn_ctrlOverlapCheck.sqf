// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_ctrlOverlapCheck.sqf
//	@file Author: AgentRev

// Simple function to determine if 2 dialog controls are overlapping each other in any way

// based on the following code by "e.James": http://stackoverflow.com/a/306379

#define VAL_IN_RANGE(VAL, VMIN, VMAX) ((VAL >= VMIN) && (VAL <= VMAX))

private ["_ctrl1", "_ctrl2", "_c1Pos", "_c2Pos", "_c1X", "_c1Y", "_c1W", "_c1H", "_c2X", "_c2Y", "_c2W", "_c2H"];

_ctrl1 = param [0, controlNull, [controlNull,[]]]; // control or ctrlPosition array
_ctrl2 = param [1, controlNull, [controlNull,[]]];

_c1Pos = if (_ctrl1 isEqualType []) then { _ctrl1 } else { ctrlPosition _ctrl1 };
_c2Pos = if (_ctrl2 isEqualType []) then { _ctrl2 } else { ctrlPosition _ctrl2 };

_c1X = _c1Pos select 0;
_c1Y = _c1Pos select 1;
_c1W = _c1Pos select 2;
_c1H = _c1Pos select 3;

_c2X = _c2Pos select 0;
_c2Y = _c2Pos select 1;
_c2W = _c2Pos select 2;
_c2H = _c2Pos select 3;

(VAL_IN_RANGE(_c1X, _c2X, _c2X + _c2W) || VAL_IN_RANGE(_c2X, _c1X, _c1X + _c1W)) &&
(VAL_IN_RANGE(_c1Y, _c2Y, _c2Y + _c2H) || VAL_IN_RANGE(_c2Y, _c1Y, _c1Y + _c1H))
