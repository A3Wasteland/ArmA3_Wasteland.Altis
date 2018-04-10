// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadScoreboard.sqf
//	@file Author: AgentRev

#include "score_defines.hpp"

disableSerialization;
9123 cutRsc ["ScoreGUI", "PLAIN", 1e11];

_code =
{
	private ["_bluforColor", "_opforColor", "_indieColor", "_civColor", "_defColor", "_allPlayers", "_i", "_scoreOrdering", "_players", "_playerCount", "_playerIndex", "_iStart", "_id", "_index", "_entry", "_player", "_isPlayer", "_bgColor", "_entryBG", "_entryTColor", "_textColor", "_entryRank", "_entryName", "_entryPKills", "_entryAIKills", "_entryDeaths", "_entryRevives", "_entryCaptures", "_teams", "_grp", "_side", "_teamCount", "_playerTeam", "_playerTeamIndex", "_team", "_isPlayerTeam", "_isGroup", "_teamName", "_entryTerritories"];

	if (!alive player) then
	{
		("BIS_fnc_respawnCounter" call BIS_fnc_rscLayer) cutFadeOut 0; // hide default respawn counter
	};

	if (!isNull _display) then
	{
		_bluforColor = ["Map", "BLUFOR"] call BIS_fnc_displayColorGet;
		_opforColor = ["Map", "OPFOR"] call BIS_fnc_displayColorGet;
		_indieColor = ["Map", "Independent"] call BIS_fnc_displayColorGet;
		_civColor = ["Map", "Civilian"] call BIS_fnc_displayColorGet;
		_defColor = [0,0,0,1]; //["Map", "Unknown"] call BIS_fnc_displayColorGet;

		_allPlayers = allPlayers - entities "HeadlessClient_F";

		// Exclude headless
		/*for "_i" from (count _allPlayers - 1) to 0 step -1 do
		{
			if (side (_allPlayers select _i) == sideLogic) then
			{
				_allPlayers deleteAt _i;
			};
		};*/

		_scoreOrdering = { ((([_x, "playerKills"] call fn_getScore) - ([_x, "teamKills"] call fn_getScore)) * 1000) + ([_x, "aiKills"] call fn_getScore) };
		_players = [_allPlayers, [], _scoreOrdering, "DESCEND"] call BIS_fnc_sortBy;
		_playerCount = count _players;
		_playerIndex = _players find player;

		_iStart = A3W_scoreboard_pScrollIndex min (_playerCount - scoreGUI_PList_Length) max 0;
		A3W_scoreboard_pScrollIndex = _iStart;

		for "_i" from 1 to scoreGUI_PList_Length do
		{
			_id = _i - 1;
			_index = _id + _iStart;
			_entry = _display displayCtrl scoreGUI_PListEntry(_id);

			if (_playerCount >= _i) then
			{
				if ((_playerIndex < _index && _i == 1) || (_playerIndex > _index && _i == scoreGUI_PList_Length)) then { _index = _playerIndex };
				_player = if (_index != -1) then { _players select _index };
				if (isNil "_player") then { _player = objNull };
				_isPlayer = (_player == player);

				_bgColor = if (_i % 2 == 0) then { [scoreGUI_Entry_BGColor_Default2] } else { [scoreGUI_Entry_BGColor_Default] };

				/*switch (true) do
				{
					//case (_isPlayer):                     { [scoreGUI_Entry_BGColor_Player] };
					//case (group _player == group player): { [scoreGUI_Entry_BGColor_Group] };
					default                               { [scoreGUI_Entry_BGColor_Default] };
				};*/

				_entryBG = _display displayCtrl scoreGUI_PListEntry_BG(_id);
				_entryBG ctrlSetBackgroundColor _bgColor;

				_entryTColor = _display displayCtrl scoreGUI_PListEntry_TColor(_id);
				_entryTColor ctrlSetBackgroundColor (switch (side group _player) do
				{
					case BLUFOR:      { _bluforColor };
					case OPFOR:       { _opforColor };
					case INDEPENDENT: { _indieColor };
					case CIVILIAN:    { _civColor };
					default           { _defColor };
				});

				_textColor = switch (true) do
				{
					case (_isPlayer):                     { [1, 0.85, 0, 1] }; // Yellow player color
					case (group _player == group player): { [0.45, 0.85, 0.35, 1] }; // Green group color
					default                               { [1, 1, 1, 1] };
				};

				_entryRank = _display displayCtrl scoreGUI_PListEntry_Rank(_id);
				_entryRank ctrlSetText str (_index + 1);
				_entryRank ctrlSetTextColor _textColor;

				_entryName = _display displayCtrl scoreGUI_PListEntry_Name(_id);
				_entryName ctrlSetText name _player;
				_entryName ctrlSetTextColor _textColor;

				_entryPKills = _display displayCtrl scoreGUI_PListEntry_PKills(_id);
				_entryPKills ctrlSetText str (([_player, "playerKills"] call fn_getScore) - ([_player, "teamKills"] call fn_getScore));
				_entryPKills ctrlSetTextColor _textColor;

				_entryAIKills = _display displayCtrl scoreGUI_PListEntry_AIKills(_id);
				_entryAIKills ctrlSetText str ([_player, "aiKills"] call fn_getScore);
				_entryAIKills ctrlSetTextColor _textColor;

				_entryDeaths = _display displayCtrl scoreGUI_PListEntry_Deaths(_id);
				_entryDeaths ctrlSetText str ([_player, "deathCount"] call fn_getScore);
				_entryDeaths ctrlSetTextColor _textColor;

				_entryRevives = _display displayCtrl scoreGUI_PListEntry_Revives(_id);
				_entryRevives ctrlSetText str ([_player, "reviveCount"] call fn_getScore);
				_entryRevives ctrlSetTextColor _textColor;

				_entryCaptures = _display displayCtrl scoreGUI_PListEntry_Captures(_id);
				_entryCaptures ctrlSetText str ([_player, "captureCount"] call fn_getScore);
				_entryCaptures ctrlSetTextColor _textColor;

				_entry ctrlShow true;
			}
			else
			{
				_entry ctrlShow false;
			};
		};

		_teams = [];

		{
			_grp = group _x;
			_side = side _grp;

			if (_side in [BLUFOR,OPFOR]) then
			{
				if !(_side in _teams) then
				{
					_teams pushBack _side;
				};
			}
			else
			{
				if !(_grp in _teams) then
				{
					_teams pushBack _grp;
				};
			};
		} forEach _allPlayers;

		_scoreOrdering = { [_x, "playerKills"] call fn_getTeamScore };
		_teams = [_teams, [], _scoreOrdering, "DESCEND"] call BIS_fnc_sortBy;
		_teamCount = count _teams;
		_playerTeam = if (playerSide in [BLUFOR,OPFOR]) then { playerSide } else { group player };
		_playerTeamIndex = _teams find _playerTeam;

		_iStart = A3W_scoreboard_tScrollIndex min (_teamCount - scoreGUI_TList_Length) max 0;
		A3W_scoreboard_tScrollIndex = _iStart;

		for "_i" from 1 to scoreGUI_TList_Length do
		{
			_id = _i - 1;
			_index = _id + _iStart;
			_entry = _display displayCtrl scoreGUI_TListEntry(_id);

			if (_teamCount >= _i) then
			{
				if ((_playerTeamIndex < _index && _i == 1) || (_playerTeamIndex > _index && _i == scoreGUI_TList_Length)) then { _index = _playerTeamIndex };
				_team = if (_index != -1) then { _teams select _index };
				if (isNil "_team") then { _team = sideUnknown };
				_isPlayerTeam = _team isEqualTo _playerTeam;
				_isGroup = _team isEqualType grpNull;

				_bgColor = if (_i % 2 == 0) then { [scoreGUI_Entry_BGColor_Default2] } else { [scoreGUI_Entry_BGColor_Default] };

				_entryBG = _display displayCtrl scoreGUI_TListEntry_BG(_id);
				_entryBG ctrlSetBackgroundColor _bgColor;

				_entryTColor = _display displayCtrl scoreGUI_TListEntry_TColor(_id);
				_entryTColor ctrlSetBackgroundColor (switch (if (_isGroup) then { side _team } else { _team }) do
				{
					case BLUFOR:      { _bluforColor };
					case OPFOR:       { _opforColor };
					case INDEPENDENT: { _indieColor };
					case CIVILIAN:    { _civColor };
					default           { _defColor };
				});

				_textColor = switch (true) do
				{
					case (_isPlayerTeam): { [0.45, 0.85, 0.35, 1] }; // Green group color
					default               { [1, 1, 1, 1] };
				};

				_entryRank = _display displayCtrl scoreGUI_TListEntry_Rank(_id);
				_entryRank ctrlSetText str (_index + 1);
				_entryRank ctrlSetTextColor _textColor;

				_teamName = if (_isGroup) then
				{
					format ["%1's group", name leader _team]
				}
				else
				{
					switch (_team) do
					{
						case BLUFOR: { "BLUFOR" };
						case OPFOR:  { "OPFOR" };
						default      { "Aliens" };
					};
				};

				_entryName = _display displayCtrl scoreGUI_TListEntry_Name(_id);
				_entryName ctrlSetText _teamName;
				_entryName ctrlSetTextColor _textColor;

				_entryPKills = _display displayCtrl scoreGUI_TListEntry_PKills(_id);
				_entryPKills ctrlSetText str ([_team, "playerKills"] call fn_getTeamScore);
				_entryPKills ctrlSetTextColor _textColor;

				_entryDeaths = _display displayCtrl scoreGUI_TListEntry_Deaths(_id);
				_entryDeaths ctrlSetText str ([_team, "deathCount"] call fn_getTeamScore);
				_entryDeaths ctrlSetTextColor _textColor;

				_entryTerritories = _display displayCtrl scoreGUI_TListEntry_Territories(_id);
				_entryTerritories ctrlSetText str ([_team, "territoryCount"] call fn_getTeamScore);
				_entryTerritories ctrlSetTextColor _textColor;

				_entry ctrlShow true;
			}
			else
			{
				_entry ctrlShow false;
			};
		};
	};
};

private "_display";
_display = uiNamespace getVariable ["ScoreGUI", displayNull];

if (!isNull _display) then
{
	if (alive player) then
	{
		_timerCtrl = _display displayCtrl scoreGUI_PRespawnTimer;
		_timerCtrl ctrlSetFade 1;
		_timerCtrl ctrlCommit 0;
	}
	else
	{
		["onLoad", [_display]] call fn_respawnTimer;
	};
};

A3W_scoreboard_pScrollIndex = 0;
A3W_scoreboard_tScrollIndex = 0;

call _code;

_code spawn
{
	disableSerialization;
	A3W_scoreboard_indexChange = false;

	_scrollEH = (findDisplay 46) displayAddEventHandler ["MouseZChanged",
	{
		_change = [-1,1] select (_this select 1 < 0);
		A3W_scoreboard_pScrollIndex = A3W_scoreboard_pScrollIndex + _change;
		A3W_scoreboard_tScrollIndex = A3W_scoreboard_tScrollIndex + _change;
		A3W_scoreboard_indexChange = true;
	}];

	_display = uiNamespace getVariable ["ScoreGUI", displayNull];
	_time = 0;

	while {!isNull _display} do
	{
		if (A3W_scoreboard_indexChange || diag_tickTime - _time >= 1) then
		{
			A3W_scoreboard_indexChange = false;
			_time = diag_tickTime;
			call _this;
		};

		uiSleep 0.01;
	};

	(findDisplay 46) displayRemoveEventHandler ["MouseZChanged", _scrollEH];
};
