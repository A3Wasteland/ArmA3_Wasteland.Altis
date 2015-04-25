// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerEventServer.sqf
//	@file Author: AgentRev

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (toLower _type) do
{
	case "pickupmoney":
	{
		_amount = [_this, 1, 0, [0]] call BIS_fnc_param;

		if (_amount > 0) then
		{
			[format ["You have picked up $%1", [_amount] call fn_numbersText], 5] call mf_notify_client;

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[] spawn fn_savePlayerData;
			};
		};
	};

	case "transaction":
	{
		_amount = [_this, 1, 0, [0]] call BIS_fnc_param;

		if (_amount != 0) then
		{
			// temporarily offloaded to server due to negative wallet glitch
			//player setVariable ["cmoney", (player getVariable ["cmoney", 0]) - _amount, true];

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[] spawn fn_savePlayerData;
			};

			playSound "defaultNotification";
			call mf_items_warchest_refresh;
			call mf_items_cratemoney_refresh;
			true call mf_items_atm_refresh;
		}
		else
		{
			playSound "FD_CP_Not_Clear_F";
			["Invalid transaction, please try again.", 5] call mf_notify_client;
		};
	};

	case "atmtransfersent":
	{
		_amount = [_this, 1, 0, [0]] call BIS_fnc_param;
		_name = [_this, 2, "", [""]] call BIS_fnc_param;

		if (_amount != 0) then
		{
			_message = if (isStreamFriendlyUIEnabled) then {
				"You have successfully transferred $%1"
			} else {
				"You have successfully transferred $%1 to %2"
			};

			playSound "defaultNotification";
			[format [_message, [_amount] call fn_numbersText, _name], 5] call mf_notify_client;
			true call mf_items_atm_refresh;
		}
		else
		{
			playSound "FD_CP_Not_Clear_F";
			["Invalid transaction, please try again.", 5] call mf_notify_client;
			true call mf_items_atm_refresh;
		};
	};

	case "atmtransferreceived":
	{
		_amount = [_this, 1, 0, [0]] call BIS_fnc_param;
		_name = [_this, 2, "", [""]] call BIS_fnc_param;

		_message = if (isStreamFriendlyUIEnabled) then {
			"You have received $%1 from a bank transfer" 
		} else {
			"%2 has transferred $%1 to your bank account"
		};

		playSound "FD_Finish_F";
		[format [_message, [_amount] call fn_numbersText, _name], 5] call mf_notify_client;
		true call mf_items_atm_refresh;
	};
};
