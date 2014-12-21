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
		}
		else
		{
			["The money was counterfeit!", 5] call mf_notify_client;
		};
	};

	case "transaction":
	{
		_amount = [_this, 1, 0, [0]] call BIS_fnc_param;

		if (_amount != 0) then
		{
			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) - _amount, true];

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[] spawn fn_savePlayerData;
			};

			playSound "defaultNotification";
		}
		else
		{
			playSound "FD_CP_Not_Clear_F";
			["Invalid transaction, please try again.", 5] call mf_notify_client;
		};
	};
};
