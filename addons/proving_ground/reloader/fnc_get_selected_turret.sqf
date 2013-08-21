#include "defs.hpp"
_selection = (lbSelection GET_CTRL(balca_loader_turret_list_IDC) select 0);
if (isNil {_selection}) then {_selection = 0};
_index_turret = [(GET_CTRL(balca_loader_turret_list_IDC) lbvalue _selection)];
if (_index_turret select 0 <= -2) then {
	_i = _index_turret select 0;
	_index_turret = [round(-(_i+2)/10),(-(_i+2)+10*round((_i+2)/10))];
};
_index_turret