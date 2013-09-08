#include "defs.hpp"
_idc = _this select 0;

_selection = (lbSelection GET_CTRL(_idc) select 0);
if (isNil {_selection}) then {_selection = 0};
(GET_CTRL(_idc) lbData _selection)