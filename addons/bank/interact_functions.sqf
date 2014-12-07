#include "macro.h"
#include "defines.h"

if (!undefined(interact_functions_defined)) exitWith {};
diag_log format["Loading interact functions ..."];

interact_deposit_receive = {
	ARGVX3(0,_player,objNull);
	ARGVX3(1,_sender,objNull);
	ARGVX3(2,_amount,0);

	if (not([_player] call player_human)) exitWith {};
	if (not([_sender] call player_human)) exitWith {};
	if (_player != player) exitWith {};
	if (_amount <= 0) exitWith {};

	[_player,_amount] call bank_transaction;

	player groupChat format["You received $%1 from %2 on your bank account",strM(_amount),(name _sender)];
};

//setup the bank deposit receive handler
format["bank_deposit_receive_%1", getPlayerUID player] addPublicVariableEventHandler { (_this select 1) call interact_deposit_receive;};


interact_deposit_other = {
	ARGVX3(0,_player,objNull);
	ARGVX3(1,_target,objNull);
	ARGVX3(2,_amount,0);

	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_player != player) exitWith {};


	if (_amount <= 0) exitWith {};


	private["_player_variable","_player_variable_name","_bank_amount"];
	private["_tax_fee","_total_due","_bank_tax"];
	_bank_tax = bank_transaction_tax;
	_tax_fee = round(_amount * (_bank_tax/100));
	_total_due = _tax_fee + _amount;
	_bank_amount = [_player] call bank_get_value;

	if (_bank_amount < _total_due) exitWith {
		player groupChat format["You do not have enough money in your account to send $%1, with tax fee $%2",strM(_amount),strM(_tax_fee)];
	};

  private["_target_bank_amount"];
  _target_bank_amount = [_target] call bank_get_value;
	if ([_amount, _target_bank_amount] call interact_check_trx_maximum) exitWith {};

	[_player,-(_total_due)] call bank_transaction;

	player groupChat format["You have sent $%1 to %2,your tax fee was $%3",strM(_amount),(name _target),strM(_tax_fee)];

	_receive_handler_name = format["bank_deposit_receive_%1", getPlayerUID _target];
	missionNamespace setVariable[_receive_handler_name, [_target,_player,_amount]];
	publicVariable _receive_handler_name;
};



interact_check_trx_minimum = {
	ARGV2(0,_amount);
	private["_minimum"];
	_minimum = 10;
	if (_amount < _minimum) exitWith {
		player groupChat format["The minimum about for a bank transaction is $%1",strM(_minimum)];
		true
	};
	false
};

interact_check_trx_maximum = {
	ARGVX3(0,_amount,0);
	ARGVX3(1,_balance,0);
	private["_max"];
	_max = bank_maximum_balance;
	if ((_amount + _balance) > _max) exitWith {
		player groupChat format["This transaction would put the bank account over the $%1 maximum.",strM(_max)];
		true
	};
	false
};



interact_deposit_self ={
	ARGVX3(0,_player,objNull);
	ARGVX3(1,_target,objNull);
	ARGVX3(2,_amount,0);

	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};
	if (_player != player) exitWith {};

	if (_amount <= 0) exitWith {};

	if ([_amount] call interact_check_trx_minimum) exitWith {};


	private["_money", "_balance"];
	_money = [_player] call cash_get_value;
	_balance = [_player] call bank_get_value;

	if ([_amount, _balance] call interact_check_trx_maximum) exitWith {};

	if (_money < _amount) exitWith {
		player groupChat format["You do not have enough money in your inventory to deposit $%1",strM(_amount)];
	};

	player groupChat format["You have deposited $%1 into your bank account",strM(_amount)];
	[_player,_amount] call bank_transaction;
	[_player,-(_amount)] call cash_transaction;

};

interact_deposit = {
	ARGVX3(0,_player,objNull);
	ARGVX3(1,_target,objNull);
	ARGVX3(2,_amount,0);

	if (not([_player] call player_human)) exitWith {};
	if (not([_target] call player_human)) exitWith {};

	if (_player != player) exitWith {};

	if (_amount <= 0) exitWith {};

	if ([_amount] call interact_check_trx_minimum) exitWith {};

	if (_player == _target) exitWith {
		(_this call interact_deposit_self)
	};

	(_this call interact_deposit_other)
};

interact_withdraw = {
	ARGVX3(0,_player,objNull);
	ARGVX3(1,_amount,0);

	if (not([_player] call player_human)) exitWith {};
	if (_player != player) exitWith {};


	if (_amount <= 0) exitWith {};

	if ([_amount] call interact_check_trx_minimum) exitWith {};

	private["_bank_amount"];
	_bank_amount = [_player] call bank_get_value;

	if (_amount > _bank_amount) exitWith {
		player groupChat format["You do not have enough money on your bank account to withdraw $%1",strM(_amount)];
	};

	[_player,-(_amount)] call bank_transaction;
  [_player, _amount] call cash_transaction;


	player groupChat format["You have withdrawn $%1 from your bank account",strM(_amount)];
};

interact_functions_defined = true;
diag_log format["Loading interact functions complete"];
