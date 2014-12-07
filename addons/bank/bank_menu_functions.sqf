#include "constants.h"
#include "macro.h"
#include "defines.h"

if (not(undefined(bank_menu_functions_defined))) exitWith {};


bank_menu_dialog = { _this spawn {
	disableSerialization;
	private["_player"];
	_player = _this select 0;

	if (not([_player] call player_human)) exitWith {};
	if (_player != player) exitWith {};


	if (not(createDialog "bank_menu")) exitWith {
		player groupChat format["ERROR: Could not create bank menu dialog"];
	};

	private["_list"];
	_list = [] call bank_menu_setup;
	[_player] spawn bank_menu_loop;

	private["_my_index"];
	_my_index = 0;

	{if(true)then {
		private["_unit"];
		_unit = _x;
		if (not([_unit] call player_human)) exitWith {0};


		private["_index", "_uid"];
		_index = _list lbAdd (format["%1 - (%2)",(side _unit),(name _unit)]);
		_uid = getPlayerUID _unit;

		_variable_name = format["unit_%1",_uid];
		missionNamespace setVariable [_variable_name, _uid];

		lbSetData [(ctrlIDC _list),_index,_variable_name];
		lbSetValue [(ctrlIDC _list),_index,_variable_name];

		if (_unit == _player) then {
			_my_index = _index;
		};

	}} forEach allUnits;

	if (_my_index >= 0) then {
		_list lbSetCurSel _my_index;
	};

	//Deposit button
	buttonSetAction [
	bank_menu_button_deposit_idc,
	(
		'	private["_variable_name","_amount"];' +
		'	_variable_name  = (lbData [bank_menu_destination_field_idc,lbCurSel bank_menu_destination_field_idc]);' +
		'	_amount = ([ctrlText bank_menu_amount_field_idc] call parse_number);' +
		'	[ ( [' + str(getPlayerUID _player) + '] call uid_to_player), ([(missionNamespace getVariable _variable_name)] call uid_to_player),_amount] call interact_deposit;'+
		'closedialog 0;'
	)];

	//withdraw button
	buttonSetAction [
	bank_menu_button_withdraw_idc,
	(
		'	private["_amount"];' +
		'	_amount = ([ctrlText bank_menu_amount_field_idc] call parse_number);' +
		'	[( [' + str(getPlayerUID _player) + '] call uid_to_player),_amount] call interact_withdraw;'+
		'closedialog 0;'
	)];

};};


bank_menu_loop = {
	ARGVX3(0,_player,objNull);

	private["_bank_tax"];
	_bank_tax = bank_transaction_tax;

	private["_my_variable"];
	_my_variable = format["unit_%1", getPlayerUID _player];

	waitUntil {
		private["_money","_bank"];
		_money = [_player] call cash_get_value;
		_bank = [_player] call bank_get_value;

		ctrlSetText [bank_menu_balance_cash_field_idc,format ["$%1",strM(_money)]];
		ctrlSetText [bank_menu_balance_field_idc,format ["$%1",strM(_bank)]];

		private["_amount"];
		_amount = [ctrlText bank_menu_amount_field_idc] call parse_number;
		if (!isSCALAR(_amount) || {_amount < 0}) then {_amount = 0};

		if ((lbData[bank_menu_destination_field_idc,(lbCurSel bank_menu_destination_field_idc)]) == _my_variable) then {
			ctrlSetText [bank_menu_transaction_fee_field_idc,"$0"];
			ctrlEnable [bank_menu_button_withdraw_idc, true];
		}
		else {
			ctrlSetText [bank_menu_transaction_fee_field_idc,format ["$%1",strM(round(_amount * (_bank_tax/100)))]];
			ctrlEnable [bank_menu_button_withdraw_idc, false];
		};
		not(ctrlVisible bank_menu_header_idc);
	};
};
bank_menu_combo_focus = {
	ARGVX3(0,_control,controlNull);
	_control ctrlSetBackgroundColor [0.1,0.1,0.1,1];
};

bank_menu_combo_blur = {
	ARGVX3(0,_control,controlNull);
	_control ctrlSetBackgroundColor [1,1,1,0.08];
};

bank_menu_setup = {
	disableSerialization;

	private["_display"];
	_display = uiNamespace getVariable "BANK_MENU";

	_bank_menu_header = _display displayCtrl bank_menu_header_idc;
	_bank_menu_background = _display displayCtrl bank_menu_background_idc;
	_bank_menu_balance_label = _display displayCtrl bank_menu_balance_label_idc;
	_bank_menu_balance_field = _display displayCtrl bank_menu_balance_field_idc;
	_bank_menu_balance_cash_label = _display displayCtrl bank_menu_balance_cash_label_idc;
	_bank_menu_balance_cash_field = _display displayCtrl bank_menu_balance_cash_field_idc;
	_bank_menu_amount_label = _display displayCtrl bank_menu_amount_label_idc;
	_bank_menu_amount_field = _display displayCtrl bank_menu_amount_field_idc;
	_bank_menu_destination_label = _display displayCtrl bank_menu_destination_label_idc;
	_bank_menu_destination_field = _display displayCtrl bank_menu_destination_field_idc;
	_bank_menu_transaction_fee_label = _display displayCtrl bank_menu_transaction_fee_label_idc;
	_bank_menu_transaction_fee_field = _display displayCtrl bank_menu_transaction_fee_field_idc;
	_bank_menu_button_deposit = _display displayCtrl bank_menu_button_deposit_idc;
	_bank_menu_button_withdraw = _display displayCtrl bank_menu_button_withdraw_idc;
	_bank_menu_button_close = _display displayCtrl bank_menu_button_close_idc;


	_bank_menu_destination_field ctrlAddEventHandler ["SetFocus","(_this) call bank_menu_combo_focus"];
	_bank_menu_destination_field ctrlAddEventHandler ["KillFocus","(_this) call bank_menu_combo_blur"];

	private["_x","_y","_ysep","_sep","_bank_title","_w","_h"];
	_x = 0.14;
	_y = 0.14;
	_w = 0.55;
	_h = 0.40;
	_ysep = 0.006;
	_sep = 0.01;
	_bank_title = "BANK MENU";

	private["_button_font_height","_font_family"];
	_button_font_height = MENU_TITLE_FONT_HEIGHT;
	_font_family = "PuristaMedium";

	//bank header
	private["_bhx","_bhy","_bhw","_bhh"];
	_bhx = _x;
	_bhy = _y;
	_bhw = _w;
	_bhh = 0.045;

	_bank_menu_header ctrlSetPosition [_bhx,_bhy,_bhw,_bhh];
	_bank_menu_header ctrlSetFontHeight _button_font_height;
	_bank_menu_header ctrlSetText _bank_title;
	_bank_menu_header ctrlSetFont _font_family;
	_bank_menu_header ctrlCommit 0;

	//bank close button
	private["_bcx","_bcy","_bcw","_bch"];
	_bcw = 0.14;
	_bch = _bhh;
	_bcx = _bhx + _bhw - _bcw;
	_bcy = _bhy + _h - _bch;

	_bank_menu_button_close ctrlSetText "Close";
	_bank_menu_button_close ctrlSetPosition [_bcx,_bcy,_bcw,_bch];
	buttonSetAction [(ctrlIDC _bank_menu_button_close),"closeDialog 0"];
	_bank_menu_button_close ctrlCommit 0;

	//bank background
	private["_bbx","_bby","_bbw","_bbh"];
	_bbx = _bhx;
	_bby = _bhy + _bhh + _ysep;
	_bbw = _w;
	_bbh = (_bcy ) - (_bhy ) - _bch - _ysep - _ysep;

	_bank_menu_background ctrlSetPosition [_bbx,_bby,_bbw,_bbh];
	_bank_menu_background ctrlSetBackgroundColor [0,0,0,0.65];
	_bank_menu_background ctrlCommit 0;

	//bank deposit button
	private["_bdx","_bdy" ,"_bdw","_bdh"];
	_bdx = _bhx;
	_bdy = _bby + _bbh + _ysep;
	_bdw = 0.11 ;
	_bdh = _bch;

	_bank_menu_button_deposit ctrlSetText "Deposit";
	_bank_menu_button_deposit ctrlSetPosition [_bdx,_bdy,_bdw,_bdh];
	_bank_menu_button_deposit ctrlCommit 0;

	//bank withdraw button
	private["_bwx","_bwy" ,"_bww","_bwh"];
	_bwx = _bdx + _bdw + _sep;
	_bwy = _bdy; + _bbh + _ysep;
	_bww = _bcw;
	_bwh = _bdh;

	_bank_menu_button_withdraw ctrlSetText "Withdraw";
	_bank_menu_button_withdraw ctrlSetPosition [_bwx,_bwy,_bww,_bwh];
	_bank_menu_button_withdraw ctrlCommit 0;

	//bank balance label
	private["_bblx","_bbly","_bblw","_bblh"];
	_bblx = _bbx + _sep * 2;
	_bbly = _bby + _sep * 2;
	_bblw = (_bbw - _sep *6) / 2;
	_bblh = 0.04;

	_bank_menu_balance_label ctrlSetText "Account balance: ";
	_bank_menu_balance_label ctrlSetPosition [_bblx,_bbly,_bblw,_bblh];
	_bank_menu_balance_label ctrlSetFontHeight _button_font_height - 0.003;
	_bank_menu_balance_label ctrlCommit 0;

	//bank balance field
	private["_bbfx","_bbfy","_bbfw","_bbfh"];
	_bbfx = _bblx + _bblw + _sep * 2 ;
	_bbfy = _bbly;
	_bbfw = _bblw;
	_bbfh = _bblh;

	_bank_menu_balance_field ctrlSetFontHeight _button_font_height - 0.003;;
	_bank_menu_balance_field ctrlSetFont _font_family;
	_bank_menu_balance_field ctrlSetPosition [_bbfx,_bbfy,_bbfw,_bbfh];
	_bank_menu_balance_field ctrlSetBackgroundColor [1,1,1,0.08];
	_bank_menu_balance_field ctrlCommit 0;

	//bank cash balance label
	private["_bclx","_bcly","_bclw","_bclh"];
	_bclx = _bblx;
	_bcly = _bbly + _bblh + _ysep * 2;
	_bclw = _bblw;
	_bclh = _bblh;

	_bank_menu_balance_cash_label ctrlSetText "Inventory balance: ";
	_bank_menu_balance_cash_label ctrlSetPosition [_bclx,_bcly,_bclw,_bclh];
	_bank_menu_balance_cash_label ctrlSetFontHeight _button_font_height - 0.003;
	_bank_menu_balance_cash_label ctrlCommit 0;

	//bank cash balance field
	private["_bcfx","_bcfy","_bcfw","_bcfh"];
	_bcfx = _bclx + _bclw + _sep * 2 ;
	_bcfy = _bcly;
	_bcfw = _bclw;
	_bcfh = _bclh;

	_bank_menu_balance_cash_field ctrlSetFontHeight _button_font_height - 0.003;;
	_bank_menu_balance_cash_field ctrlSetFont _font_family;
	_bank_menu_balance_cash_field ctrlSetPosition [_bcfx,_bcfy,_bcfw,_bcfh];
	_bank_menu_balance_cash_field ctrlSetBackgroundColor [1,1,1,0.08];
	_bank_menu_balance_cash_field ctrlCommit 0;


	//bank transaction subject label
	private["_btlx","_btly","_btlw","_btlh"];
	_btlx = _bclx;
	_btly = _bcly + _bclh + _ysep * 2;
	_btlw = _bclw;
	_btlh = _bclh;

	_bank_menu_destination_label ctrlSetText "Transaction destination: ";
	_bank_menu_destination_label ctrlSetPosition [_btlx,_btly,_btlw,_btlh];
	_bank_menu_destination_label ctrlSetFontHeight _button_font_height - 0.003;
	_bank_menu_destination_label ctrlCommit 0;

	//bank transaction subject field
	private["_btfx","_btfy","_btfw","_btfh"];
	_btfx = _btlx + _btlw + _sep * 2 ;
	_btfy = _btly;
	_btfw = _btlw;
	_btfh = _btlh;

	_bank_menu_destination_field ctrlSetFontHeight _button_font_height - 0.003;;
	_bank_menu_destination_field ctrlSetFont _font_family;
	_bank_menu_destination_field ctrlSetPosition [_btfx,_btfy,_btfw,_btfh];
	_bank_menu_destination_field ctrlSetBackgroundColor [1,1,1,0.08];
	_bank_menu_destination_field ctrlCommit 0;

	//bank transaction amount label
	private["_balx","_baly","_balw","_balh"];
	_balx = _btlx;
	_baly = _btly + _btlh + _ysep * 2;
	_balw = _btlw;
	_balh = _btlh;

	_bank_menu_amount_label ctrlSetText "Transaction amount: ";
	_bank_menu_amount_label ctrlSetPosition [_balx,_baly,_balw,_balh];
	_bank_menu_amount_label ctrlSetFontHeight _button_font_height - 0.003;
	_bank_menu_amount_label ctrlCommit 0;

	//bank transaction amount field
	private["_bafx","_bafy","_bafw","_bafh"];
	_bafx = _balx + _balw + _sep * 2 ;
	_bafy = _baly;
	_bafw = _balw;
	_bafh = _balh;

	_bank_menu_amount_field ctrlSetFontHeight _button_font_height - 0.003;;
	_bank_menu_amount_field ctrlSetFont _font_family;
	_bank_menu_amount_field ctrlSetPosition [_bafx,_bafy,_bafw,_bafh];
	_bank_menu_amount_field ctrlSetBackgroundColor [1,1,1,0.08];
	_bank_menu_amount_field ctrlCommit 0;

	//bank transaction fee label
	private["_bflx","_bfly","_bflw","_bflh"];
	_bflx = _balx;
	_bfly = _baly + _balh + _ysep * 2;
	_bflw = _balw;
	_bflh = _balh;

	//player groupChat format["_bank_menu_transaction_fee_label = %1",_bank_menu_transaction_fee_label];
	_bank_menu_transaction_fee_label ctrlSetText "Transaction fee: ";
	_bank_menu_transaction_fee_label ctrlSetPosition [_bflx,_bfly,_bflw,_bflh];
	_bank_menu_transaction_fee_label ctrlSetFontHeight _button_font_height - 0.003;
	_bank_menu_transaction_fee_label ctrlCommit 0;

	//bank transaction fee field
	private["_bafx","_bafy","_bafw","_bafh"];
	_bffx = _bflx + _bflw + _sep * 2 ;
	_bffy = _bfly;
	_bffw = _bflw;
	_bffh = _bflh;

	_bank_menu_transaction_fee_field ctrlSetFontHeight _button_font_height - 0.003;;
	_bank_menu_transaction_fee_field ctrlSetFont _font_family;
	_bank_menu_transaction_fee_field ctrlSetPosition [_bffx,_bffy,_bffw,_bffh];
	_bank_menu_transaction_fee_field ctrlSetBackgroundColor [1,1,1,0.08];
	_bank_menu_transaction_fee_field ctrlCommit 0;

	_bank_menu_destination_field
};

bank_menu_functions_defined = true;