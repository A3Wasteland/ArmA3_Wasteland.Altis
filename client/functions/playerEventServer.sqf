//	@file Name: playerEventServer.sqf
//	@file Author: AgentRev

private ["_type", "_money"];

_type = [_this, 0, "", [""]] call BIS_fnc_param;

switch (_type) do
{
	case "pickupMoney":
	{
		_money = [_this, 1, 0, [0]] call BIS_fnc_param;

		if (_money > 0) then
		{
			[format ["You have picked up $%1", [_money] call fn_numbersText], 5] call mf_notify_client;
			[] spawn fn_savePlayerData;
		}
		else
		{
			["The money was counterfeit!", 5] call mf_notify_client;
		};
	};
};
