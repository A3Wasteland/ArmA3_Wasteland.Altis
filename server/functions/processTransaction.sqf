// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processTransaction.sqf
//	@file Author: AgentRev

if (!isServer) exitWith { _this remoteExecCall ["A3W_fnc_processTransaction", 2] };

params [["_type","",[""]], ["_player",objNull,[objNull]]];

if (isNull _player) exitWith {};
if (isRemoteExecuted && remoteExecutedOwner != clientOwner && (remoteExecutedOwner != owner _player || !(_player isKindOf "Man"))) exitWith
{
	["forged processTransaction", _this] call A3W_fnc_remoteExecIntruder;
};

_result = 0;
_event = [];

switch (toLower _type) do
{
	case "pickupmoney":
	{
		params ["", "", ["_moneyObj",objNull,["",objNull]]];

		if (_moneyObj isEqualType "") then { _moneyObj = objectFromNetId _moneyObj };

		if (alive _player && _moneyObj isKindOf "Land_Money_F" && _moneyObj getVariable ["owner","world"] == "world") then
		{
			_moneyObj setVariable ["owner", getPlayerUID _player];
			_result = (_moneyObj getVariable ["cmoney", 0]) max 0;
			deleteVehicle _moneyObj;
		};

		[_player, +_result] call A3W_fnc_setCMoney; // always resync cmoney regardless of transaction status
		_event = [_type, _result];
	};
	case "dropmoney":
	{
		params ["", "", ["_amount",0,[0]]];
		_amount = _amount max 0;

		if (_amount > 0 && _player getVariable ["cmoney", 0] >= _amount) then
		{
			_moneyObj = createVehicle ["Land_Money_F", [_player, [0,1,0]] call relativePos, [], 0, "CAN_COLLIDE"];
			_moneyObj setVariable ["cmoney", _amount, true];
			_moneyObj setVariable ["owner", "world", true];
			[_moneyObj] spawn A3W_fnc_setItemCleanup;

			_result = _amount;
		};

		[_player, -_result] call A3W_fnc_setCMoney; // always resync cmoney regardless of transaction status
		_event = [_type, _result];
	};
	case "warchest":
	{
		params ["", "", ["_amount",0,[0]]];

		_side = side group _player;

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

			_result = _amount;
		};

		[_player, -_result] call A3W_fnc_setCMoney; // always resync cmoney regardless of transaction status
		_event = ["transaction", _result];
	};

	case "cratemoney":
	{
		params ["", "", ["_crate",objNull,["",objNull]], ["_amount",0,[0]]];

		if (_crate isEqualType "") then { _crate = objectFromNetId _crate };

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

			_result = _amount;
		};

		[_player, -_result] call A3W_fnc_setCMoney; // always resync cmoney regardless of transaction status
		_event = ["transaction", _result];
	};

	case "atm":
	{
		params ["", "", ["_amount",0,[0]]];

		if (_amount != 0) then
		{
			if (_amount > 0 && _player getVariable ["cmoney", 0] < _amount) exitWith {}; // player has not enough funds for deposit

			_balance = _player getVariable ["bmoney", 0];

			if (_amount < 0 && _balance < abs _amount) exitWith {}; // player has not enough funds for withdrawal

			_newBalance = _balance + _amount;

			if (_newBalance > ["A3W_atmMaxBalance", 1000000] call getPublicVar) exitWith {}; // account would exceed or has reached max balance

			_player setVariable ["bmoney", _newBalance, true];

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[getPlayerUID _player, [["BankMoney", _newBalance]], []] call fn_saveAccount;
			};

			_result = _amount;
		};

		[_player, -_result] call A3W_fnc_setCMoney; // always resync cmoney regardless of transaction status
		_event = ["transaction", _result];
	};

	case "atmtranfer":
	{
		params ["", "", ["_recipient",objNull,[objNull]], ["_amount",0,[0]], ["_feeAmount",0,[0]], ["_transferKey","",[""]]];
		_sender = _player;

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

			["atmTransferReceived", _result, name _sender] remoteExecCall ["A3W_fnc_playerEventServer", _recipient];

			if (!isNil "fn_logBankTransfer") then
			{
				[name _sender, _senderUID, side group _sender, name _recipient, _recipientUID, side group _recipient, _amount, _feeAmount] call fn_logBankTransfer;
			};
		};

		// Reset client-side player balance to previous value if transfer failed
		if (_result == 0) then
		{
			_sender setVariable ["bmoney", _sBalance + ([0,_total] select local _sender), true];
		};

		_sender setVariable [_transferKey, nil, true];
		_event = ["atmTransferSent", _result, name _recipient];
	};
};

_event remoteExecCall ["A3W_fnc_playerEventServer", _player];
