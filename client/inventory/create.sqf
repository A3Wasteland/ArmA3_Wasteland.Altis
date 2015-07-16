// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/** Create and Register a new Item in the Inventory System
 *
 * This function the initial setup of each item, allowing the Inventory
 * to automate most of it.
 *
 * To see a simple example, see the init.sqf
 *
 * @author MercyfulFate
 * @param [id, name, use, object, icon, max]
 *      id {string} - a unique item id.
 *      name {string} - the Text that the player sees.
 *      use {function} - the function that is called when the item is used.
 *          Note: MUST return true or false... see "use.sqf" for details.
 *      object {string} - the object type to place on the gound when dropped.
 *      icon {string} - the icon to use for the item
 *      max {integer | function} - the maximum qty of this item a player can
 *          carry, either a number or a function returning a number.
 *          see "is_full.sqf" for details.
 */

#include "define.sqf"
private ["_item", "_label", "_condition", "_action"];
_item = [];
_item set [ID, _this select 0];
_item set [QTY, 0];
_item set [NAME, _this select 1];
_item set [USE, _this select 2];
_item set [OBJECT, _this select 3];
_item set [ICON, _this select 4];
_item set [MAX, _this select 5];
_item call mf_inventory_set;

_label = format ['<img image="%1" /> Take %2', _item select 5, _item select 2];
_condition = format['not isNull ("%1" call mf_inventory_takeable);', _item select 0];
_action = [_label, mf_inventory_take, _item select 0, 4, true, false, "", _condition];
[format["take-%1", _this select 0], _action] call mf_player_actions_set;
