/*
=======================================================================================================================

	downloadData - script to download data from a laptop and because of this complete a task (as example)

	File:		downloadData.sqf
	Author:		T-800a

=======================================================================================================================
*/

_filesizeamountrandomizer = [123804,165072,206340];
_filesize = _filesizeamountrandomizer call BIS_fnc_SelectRandom;

T8_varFileSize = _filesize;  								// Filesize ... smaller files will take shorter time to download!

T8_varTLine01 = "Download cancelled!";				// download aborted
T8_varTLine02 = "Download already in progress by someone else!";			// download already in progress by someone else
T8_varTLine03 = "Download started!";					// download started
T8_varTLine04 = "Download finished! The money is added to your inventory!";				// download finished
T8_varTLine05 = "##  Download Bank Account Data  ##";				// line for the addaction

T8_varDiagAbort = false;
T8_varDownSucce = false;

downloadActionId = nil;



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (isDedicated) exitWith {};

"AddLaptopHandler" addPublicVariableEventHandler {
	private [  "_cDT" ];
	_laptop = _this select 1;
	_cDT = _laptop getVariable [ "Done", false ];
	if ( _cDT ) exitWith {};
	if(isNil "downloadActionId") then {
		downloadActionId = _laptop addAction [ T8_varTLine05, { call T8_fnc_ActionLaptop; }, [], 10, true, false ];
	};
};

T8_fnc_abortActionLaptop =
{
	if ( T8_varDownSucce ) then 
	{
		// hint "DEBUG - DONE";
		T8_varDiagAbort = false;
		T8_varDownSucce = false;		
	
	} else { 
		player sideChat T8_varTLine01; 
		T8_varDiagAbort = true; 
		T8_varDownSucce = false; 
	};
};

"RemoveLaptopHandler" addPublicVariableEventHandler
{
	_laptop = _this select 1;
	_laptop removeAction downloadActionId;
	downloadActionId = nil;
};


T8_fnc_ActionLaptop =
{
	private [ "_laptop", "_caller", "_id", "_cIU" ];
	_laptop = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	
	
	_cIU = _laptop getVariable [ "InUse", false ];
	if ( _cIU ) exitWith { player sideChat T8_varTLine02; };
	
	player sideChat T8_varTLine03;
	
	T8_varDiagAbort = false;
	
	_laptop setVariable [ "InUse", true, true ];
		
	[ _laptop, _id] spawn 
	{
		private [ "_laptop", "_id", "_newFile", "_dlRate" ];
		
		_laptop		= _this select 0;
		_id			= _this select 1;
		
		_newFile = 0;
		
		createDialog "T8_DataDownloadDialog";
		
		sleep 0.5;
		ctrlSetText [ 8001, "Connecting ..." ];
		sleep 0.5;
		ctrlSetText [ 8001, "Connected:" ];		
		ctrlSetText [ 8003, format [ "%1 kb", T8_varFileSize ] ];		
		ctrlSetText [ 8004, format [ "%1 kb", _newFile ] ];		
		
		while { !T8_varDiagAbort && alive player && (player getVariable ["FAR_isUnconscious", 0] == 0)} do
		{
			_dlRate = 1000 + random 400;
			_newFile = _newFile + _dlRate;

			if ( _newFile > T8_varFileSize ) then 
			{
				_dlRate = 0;		
				_newFile = T8_varFileSize;
				ctrlSetText [ 8001, "Download finished!" ];	
				T8_varDiagAbort = true;
				player sideChat T8_varTLine04;
				T8_varDownSucce = true;
				
				_laptop setVariable [ "Done", true, true ];
				
				_cashamountrandomizer = [10000,15000,20000,25000];
				_cashamount = _cashamountrandomizer call BIS_fnc_SelectRandom;
				
				player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _cashamount, true];
				
				axeDiagLog = format ["%1 hacked laptop for %2 money", player, _cashamount];
				publicVariableServer "axeDiagLog";
			};
			
			ctrlSetText [ 8002, format [ "%1 kb/s", _dlRate ] ];		
			ctrlSetText [ 8004, format [ "%1 kb", _newFile ] ];				
			
			sleep 1;
		};
		
		T8_varDiagAbort = false;
		
		closeDialog 0;

		_laptop setVariable [ "InUse", false, true];	
	};
};

downloadDataDONE = true;
