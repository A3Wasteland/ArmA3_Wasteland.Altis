_objects = nearestobjects [player, [MF_ITEMS_WARCHEST_OBJECT_TYPE],  3];
_object = objNull;
if (count _objects > 0) then {_object = _objects select 0;};
_object;