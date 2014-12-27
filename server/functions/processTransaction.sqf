// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processTransaction.sqf
//	@file Author: AgentRev

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (toLower _type) do
{
	case "warchest":
	{
		_player = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
		_amount = [_this, 2, 0, [0]] call BIS_fnc_param;

		_side = side group _player;
		_result = 0;

		if (_amount != 0) then
		{
			if (_amount > 0 && _player getVariable ["cmoney", 0] < _amount) exitWith {}; // player has not enough funds for deposit

			_var = switch (_side) do
			{
				case BLUFOR: { "pvar_warchest_funds_west" };
				case OPFOR:  { "pvar_warchest_funds_east" };
				default      { "" };
			};

			if (_var == "") exitWith {}; // invalid side

			_balance = [_var, 0] call getPublicVar;

			if (_amount < 0 && _balance < abs _amount) exitWith {}; // warchest has not enough funds for withdrawal

			missionNamespace setVariable [_var, _balance + _amount];
			publicVariable _var;
			_player setVariable ["cmoney", (_player getVariable ["cmoney", 0]) - _amount, false]; // do NOT set to true, this is only a temporary server-side change

			_result = _amount;
		};

		pvar_playerEventServer = ["transaction", _result];
		(owner _player) publicVariableClient "pvar_playerEventServer";
	};

	case "cratemoney":
	{
		_player = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
		_crate = [_this, 2, objNull, ["",objNull]] call BIS_fnc_param;
		_amount = [_this, 3, 0, [0]] call BIS_fnc_param;

		if (typeName _crate == "STRING") then { _crate = objectFromNetId _crate };

		_result = 0;

		if (!isPlayer _crate && _amount != 0) then
		{
			if (_amount > 0 && _player getVariable ["cmoney", 0] < _amount) exitWith {}; // player has not enough funds for deposit

			_balance = _crate getVariable ["cmoney", 0];

			if (_amount < 0 && _balance < abs _amount) exitWith {}; // crate has not enough funds for withdrawal

			_crate setVariable ["cmoney", _balance + _amount, true];
			_player setVariable ["cmoney", (_player getVariable ["cmoney", 0]) - _amount, false]; // do NOT set to true, this is only a temporary server-side change

			_result = _amount;
		};

		pvar_playerEventServer = ["transaction", _result];
		(owner _player) publicVariableClient "pvar_playerEventServer";
	};
};
