//	@file Version: 1.0
//	@file Name: sellCrateItems.sqf
//	@file Author: AgentRev
//	@file Created: 31/12/2013 22:12
//	@file Args:

#define PRICE_DEBUGGING false
#define CARGO_STRING(OBJ) (str getWeaponCargo OBJ + str getMagazineCargo OBJ + str getItemCargo OBJ + str getBackpackCargo OBJ)
#define CONTAINER_SELL_PRICE 50 // price for the crate itself (do not price higher than "Empty Ammo Crate" from general store)

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

_params = [_this, 3, [], [[]]] call BIS_fnc_param;
_storeSellBox = [_params, 0, false, [false]] call BIS_fnc_param;
_forceSell = [_params, 1, false, [false]] call BIS_fnc_param;
_deleteObject = [_params, 2, false, [false]] call BIS_fnc_param;

_crate = if (_storeSellBox) then
{
	[_this, 0, objNull, [objNull]] call BIS_fnc_param
}
else
{
	missionNamespace getVariable ["R3F_LOG_joueur_deplace_objet", objNull]
};

/*if !(_crate isKindOf "ReammoBox_F") then
{
	hint "You aren't holding a valid crate!";
}
else
{*/
	storeSellingHandle = [_crate, _forceSell, _deleteObject] spawn
	{
		_crate = _this select 0;
		_forceSell = _this select 1;
		_deleteObject = _this select 2;
		_sellValue = 0;

		_originalCargo = CARGO_STRING(_crate);

		// Get all the items
		_allCrateItems = _crate call getSellPriceList;

		_objectClass = typeOf _crate;
		_objectName = getText (configFile >> "CfgVehicles" >> _objectClass >> "displayName");

		// Include crate in item list if it's to be deleted
		if (_deleteObject) then
		{
			_objectClass = typeOf _crate;
			_allCrateItems = [[_objectClass, 1, _objectName, CONTAINER_SELL_PRICE]] + _allCrateItems;
		};

		if (count _allCrateItems == 0) exitWith
		{
			if (!_forceSell) then
			{
				playSound "FD_CP_Not_Clear_F";
				["This object does not contain valid items to sell.", "Error"] call BIS_fnc_guiMessage;
			};
		};

		// Calculate total value
		{
			if (count _x > 3) then
			{
				_sellValue = _sellValue + (_x select 3);
			};
		} forEach _allCrateItems;

		if (_forceSell) then
		{
			clearBackpackCargoGlobal _crate;
			clearMagazineCargoGlobal _crate;
			clearWeaponCargoGlobal _crate;
			clearItemCargoGlobal _crate;

			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
			hint format [format ['The inventory of "%1" was sold for $%2', _objectName, _sellValue]];
			playSound "FD_Finish_F";
		}
		else
		{
			// Add total sell value to confirm message
			_confirmMsg = format ["You will obtain $%1 for:<br/>", _sellValue];

			// Add item quantities and names to confirm message
			{
				_item = _x select 0;
				_itemQty = _x select 1;

				if (_itemQty > 0 && {count _x > 2}) then
				{
					_itemName = _x select 2;

					_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>%1</t> x %2%3", _itemQty, _itemName, if (PRICE_DEBUGGING) then { format [" ($%1)", _x select 3] } else { "" }];
				};

			} forEach _allCrateItems;

			// Display confirmation
			if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
			{
				// Check if somebody else manipulated the cargo since the start
				if (CARGO_STRING(_crate) == _originalCargo) then
				{
					// Have to spawn clearing commands due to mysterious game crash...
					_clearing = _crate spawn
					{
						clearBackpackCargoGlobal _this;
						clearMagazineCargoGlobal _this;
						clearWeaponCargoGlobal _this;
						clearItemCargoGlobal _this;
					};

					waitUntil {scriptDone _clearing};

					if (_deleteObject) then
					{
						if (_crate getVariable ["R3F_LOG_est_deplace_par", objNull] == player) then
						{
							[_crate, player, -1, false] execVM "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\relacher.sqf";
							waitUntil {_crate getVariable ["R3F_LOG_est_deplace_par", objNull] != player};
						};

						if (isNull (_crate getVariable ["R3F_LOG_est_deplace_par", objNull])) then
						{
							deleteVehicle _crate;
						};
					};

					player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];

					_hintMsg = if (_deleteObject) then { 'You sold "%1" for $%2' } else { 'You sold the inventory of "%1" for $%2' };
					hint format [_hintMsg, _objectName, _sellValue];
					playSound "FD_Finish_F";
				}
				else
				{
					playSound "FD_CP_Not_Clear_F";
					[format ['The contents of "%1" have changed, please restart the selling process.', _objectName], "Error"] call BIS_fnc_guiMessage;
				};
			};
		};
	};

	if (typeName storeSellingHandle == "SCRIPT") then
	{
		private "_storeSellingHandle";
		_storeSellingHandle = storeSellingHandle;
		waitUntil {scriptDone _storeSellingHandle};
	};

	storeSellingHandle = nil;
//};
