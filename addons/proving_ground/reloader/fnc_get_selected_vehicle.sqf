#include "defs.hpp"
_selection = (lbSelection GET_CTRL(balca_loader_vehicle_list_IDC) select 0);
if (isNil {_selection}) then {_selection = 0};
((uiNamespace GetVariable "balca_reloader_vehlist") select _selection)