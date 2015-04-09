
--------------
| Mag Repack |
--------------

	- Version: 3.1.0
	- Created: 7 March 2013
	- Updated: 5 February 2014

----------
| Author |
----------

	- Outlawled (outlawled@gmail.com)

---------------
| Description |
---------------

	- Allows the player to repack the ammo in his magazines.
	- Default keybinding to open the Mag Repack dialog is "Ctrl+R", this can be customized via the options menu in the Mag Repack dialog.
	- Pressing "Alt+Shift+Ctrl+Backspace" will reset the keybinding to the default setting (in case the player forgets what he changed his keybinding to).
	- The player may choose a magazine from a list of all of his magazines to be the "Source" magazine and then he may choose a magazine from a list of all of his magazines of the same ammo type as the Source magazine to be the "Target" magazine (or vice versa). As soon as the Source and Target are both defined, bullets from the Source magazine will automatically start repacking into the Target magazine.

---------
| Notes |
---------

	- You can change the repack times for individual bullets and belt magazines via the outlw_MR_bulletTime and outlw_MR_beltTime variables located in the MagRepack_init_sv.sqf.

----------------
| Installation |
----------------

	- Place the "outlw_magRepack" folder into your mission folder.

	- Add the following to your init.sqf
		- [] execVM "addons\outlw_magRepack\MagRepack_init_sv.sqf";

	- Add the following to your description.ext
		- #include "addons\outlw_magRepack\MagRepack_config.hpp"

-------------
| Changelog |
-------------
	- 3.1.0
		- Fixed: Error dialogs popping up about the scrollbars.
		- Removed: Mag Repack logo from the bottom left of the main dialog.
		- Overhauled keybinding system. It now allows just one key and any combination of Shift, Ctrl, and Alt modifiers. For example: "Ctrl+R", "Alt+J", "Shift+Ctrl+N", "Shift+Alt+Ctrl+Space", etc.
		- Redesigned Keybinding dialog based on the new keybinding system.
		- Magazine type (i.e. whether the magazine is a belt magazine or a regular magazine) is determined by the magazine's "nameSound" config entry instead of just being based on the magazine's capacity.
		- Rewrote 40mm grenade conversion system so it no longer uses a predefined list.

	- 3.0.2
		- Fixed: Updated UI classnames to be unique so as to avoid possible conflicts.
		- Fixed: An issue with the keybinding not being recognized if another key wasn't pressed between keybinding presses.
		- Changed "MagRepack_config.cpp" file extension to ".hpp".

	- 3.0.1
		- New: Pressing the keybinding while the dialog is open will now close the dialog.
		- Back-end optimizations.
		- Adjusted size of the Mag Repack logo to be slightly smaller.
		- Fixed: Now uses the keyName command to get the Strings associated with each keyboard key instead of having them hardcoded like an idiot.
		- New: Can now change the bullet and belt repack times via outlw_MR_bulletTime and outlw_MR_beltTime variables (script version).
		- All default repack times slightly increased.
		- Fixed: Changed script version init file name to "MagRepack_init_sv.sqf" to avoid conflict when user has the addon version installed while playing on a server running the script version.

	- 3.0.0
		- Removed: Everything.
		- New: Added a GUI.
		- New: Players may now repack bullets from different types of magazines as long as both magazines use the same ammo.
		- New: Players may now convert 1rnd 40mm magazines into 3rnd 40mm magazines and vice versa.
		- New: Players may now change their keybinding.
		- New: Optional debug info.
		- Fixed: Added animations for prone, launchers, and no weapon.

	- 2.1.4
		- Reverted back to 2.1.2.

	- 2.1.3
		- Fixed: Now uses CBA's Extended Pre-Init EventHandlers instead of the Post-Init ones which were broken with the ArmA 3 Beta update.

	- 2.1.2
		- Fixed: Uses "hintSilent" instead of "hint" for most cases.
		- Fixed: The sorting function is now a proper function available in the player's function library.

	- 2.1.1
		- Fixed: Now works with latest ArmA 3 Alpha Development Build
	
	- 2.1
		- Fixed: Changed a global variable to be less likely to cause mod incompatibility.

	- 2.0
		- New: Animation changed to 'Gear' animation. 
		- New: Magazine types are now repacked one by one.
		- New: How long it takes to repack each magazine type depends on how many bullets of that magazine type need to be repacked.
		- New: A magazine type can be skipped by pressing the 'Space' key.
		- New: Repack can be exited by moving (if player is inside a vehicle, getting out will exit, pressing movement keys will do nothing).
		- Fixed: Player can no longer repack magazines while in the driver, gunner, or commander seat of a vehicle.
		- New: Informational hint after repacking now displays each individual magazine ammo count from before and after the repack. E.G. [15,16,12,5,3] >> [20,20,11]
		- New: While repacking, a hint displays which magazine type is being repacked and the current ammo counts of each individual magazine of the current magazine type.
		- Fixed: Vaulting and reloading are now disabled during repack.

	- 1.3
		- Initial release.

