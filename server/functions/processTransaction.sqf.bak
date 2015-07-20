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

			if (!isNil "fn_saveWarchestMoney") then
			{
				[] spawn fn_saveWarchestMoney;
			};

			if (!local _player) then
			{
				_player setVariable ["cmoney", (_player getVariable ["cmoney", 0]) - _amount, false]; // do NOT set to true, this is only a temporary server-side change
			};

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

			if (!isNil "fn_manualObjectSave") then
			{
				_crate spawn fn_manualObjectSave;
			};

			if (!local _player) then
			{
				_player setVariable ["cmoney", (_player getVariable ["cmoney", 0]) - _amount, false]; // do NOT set to true, this is only a temporary server-side change
			};

			_result = _amount;
		};

		pvar_playerEventServer = ["transaction", _result];
		(owner _player) publicVariableClient "pvar_playerEventServer";
	};

	case "atm":
	{
		_player = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
		_amount = [_this, 2, 0, [0]] call BIS_fnc_param;

		_result = 0;

		if (_amount != 0) then
		{
			_wallet = _player getVariable ["cmoney", 0];

			if (_amount > 0 && _wallet < _amount) exitWith {}; // player has not enough funds for deposit

			_balance = _player getVariable ["bmoney", 0];

			if (_amount < 0 && _balance < abs _amount) exitWith {}; // player has not enough funds for withdrawal

			_newBalance = _balance + _amount;

			if (_newBalance > ["A3W_atmMaxBalance", 1000000] call getPublicVar) exitWith {}; // account would exceed or has reached max balance

			_player setVariable ["bmoney", _newBalance, true];

			if (!local _player) then
			{
				_player setVariable ["cmoney", _wallet - _amount, false]; // do NOT set to true, this is only a temporary server-side change
			};

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[getPlayerUID _player, [["BankMoney", _newBalance]], []] call fn_saveAccount;
			};

			_result = _amount;
		};

		pvar_playerEventServer = ["transaction", _result];
		(owner _player) publicVariableClient "pvar_playerEventServer";
	};

	case "atmtranfer":
	{
		_sender = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
		_recipient = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
		_amount = [_this, 3, 0, [0]] call BIS_fnc_param;
		_feeAmount = [_this, 4, 0, [0]] call BIS_fnc_param;
		_transferKey = [_this, 5, "", [""]] call BIS_fnc_param;

		_result = 0;
		_total = _amount + _feeAmount;
		_sBalance = _sender getVariable ["bmoney", 0];

		if (_total > 0) then
		{
			if (!isPlayer _sender || !isPlayer _recipient || _sender == _recipient) exitWith {}; // invalid sender or recipient
			if (_sBalance < _total) exitWith {}; // sender has not enough funds for transfer

			_rBalance = _recipient getVariable ["bmoney", 0];

			if (_rBalance + _amount > ["A3W_atmMaxBalance", 1000000] call getPublicVar) exitWith {}; // recipient would exceed or has reached max balance

			_sBalance = _sBalance - (if (!local _sender) then { _total } else { 0 });
			_rBalance = _rBalance + _amount;

			_sender setVariable ["bmoney", _sBalance, true];
			_recipient setVariable ["bmoney", _rBalance, true];

			_senderUID = getPlayerUID _sender;
			_recipientUID = getPlayerUID _recipient;

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[_senderUID, [["BankMoney", _sBalance]], []] call fn_saveAccount;
				[_recipientUID, [["BankMoney", _rBalance]], []] call fn_saveAccount;
			};

			_result = _amount;

			pvar_playerEventServer = ["atmTransferReceived", _result, name _sender];
			(owner _recipient) publicVariableClient "pvar_playerEventServer";

			if (!isNil "fn_logBankTransfer") then
			{
				[name _sender, _senderUID, side group _sender, name _recipient, _recipientUID, side group _recipient, _amount, _feeAmount] call fn_logBankTransfer;
			};
		};

		pvar_playerEventServer = ["atmTransferSent", _result, name _recipient];
		(owner _sender) publicVariableClient "pvar_playerEventServer";

		// Reset client-side player balance to previous value if transfer failed
		if (_result == 0) then
		{
			_sender setVariable ["bmoney", _sBalance + (if (local _sender) then { _total } else { 0 }), true];
		};

		_sender setVariable [_transferKey, nil, true];
	};
};
