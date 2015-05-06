/*
	File: fn_onSliderChange.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Called when the slider is changed for any field and updates the view distance for it.
*/
private["_mode","_value"];
_mode = [_this,0,-1,[0]] call BIS_fnc_param;
_value = [_this,1,-1,[0]] call BIS_fnc_param;
if(_mode == -1 OR _value == -1) exitWith {};
disableSerialization;

switch (_mode) do
{
	case 0:
	{
		tawvd_foot = round(_value);
		ctrlSetText[2902,format["%1",tawvd_foot]];
		[] call TAWVD_fnc_updateViewDistance;
	};
	
	case 1:
	{
		tawvd_car = round(_value);
		ctrlSetText[2912,format["%1",tawvd_car]];
		[] call TAWVD_fnc_updateViewDistance;
	};
	
	case 2:
	{
		tawvd_air = round(_value);
		ctrlSetText[2922,format["%1",tawvd_air]];
		[] call TAWVD_fnc_updateViewDistance;
	};
	
	case 3: {
		tawvd_object = round(_value);
		ctrlSetText[2942,format["%1",tawvd_object]];
		setObjectViewDistance [tawvd_object,100];
	};
};

if(tawvd_syncObject) then {
	sliderSetPosition[2941, tawvd_object];
	ctrlSetText[2942,format["%1",tawvd_object]];
};