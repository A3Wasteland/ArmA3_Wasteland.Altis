// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getTeamMarkerColor.sqf
//	@file Author: Bewilderbeest, AgentRev

private ["_team", "_isOwner", "_markerColor"];

_team = _this select 0;
_isOwner = param [1, false];

//diag_log format["getTeamMarkerColor called with %1", _this];

_markerColor = if (_isOwner) then
{
	switch (_team) do
	{
		case BLUFOR: { "ColorWEST" };
		case OPFOR:  { "ColorEAST" };
		default      { "ColorGUER" };
	};
}
else
{
	switch (_team) do
	{
		case BLUFOR: { "ColorBlue" };
		case OPFOR:  { "ColorRed" };
		default      { "ColorGreen" };
	};
};

//diag_log format["getTeamMarkerColor returning %1", _markerColor];

_markerColor
