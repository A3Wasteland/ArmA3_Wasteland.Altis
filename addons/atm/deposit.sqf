	private ["_playerMoney","_bankMoney","_atmMoney"];

	_playerMoney = player getVariable ["cmoney", 0];
	_bankMoney = player getVariable ["bmoney", 0];
	_atmMoney = parseNumber(ctrlText 2702);

	
	if((player getVariable "cmoney" < _atmMoney) OR (player getVariable "cmoney" < 0)) exitwith {hint format["You don't have $%1 to deposit", [_atmMoney] call fn_numbersText];};
    if(_atmMoney < 0) exitwith {hint "You can't deposit negative values.";};
	_bankMoney = _bankMoney + _atmMoney;
    _playerMoney = _playerMoney - _atmMoney;
	
	player setVariable ["cmoney", _playerMoney, true];
	player setVariable ["bmoney", _bankMoney, true];
	hint format["You deposited $%1", [_atmMoney] call fn_numbersText];
	call fn_savePlayerData;
	closeDialog 0;