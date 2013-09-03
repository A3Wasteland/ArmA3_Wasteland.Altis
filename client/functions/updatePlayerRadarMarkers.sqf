//	@file Version: 1.0
//	@file Name: updatePlayerRadarMarkers.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:

{deleteMarkerLocal _x;} forEach currentRadarMarkers;
currentRadarMarkers = [];

{   
    private ["_marker", "_colorEmpty", "_colorEnemy", "_colorFriendly", "_colorBoth", "_playerSide", "_markerState", "_colorSelected", "_textSelected"]; 
     
    _playerSide = str(playerSide);
    if(_playerSide != (_x select 2)) exitWith {diag_log "faction mis-match, exiting loop";};
    
    _markerState = _x select 3;
    
    _colorEmpty = "ColorBlue";
	_colorEnemy = "ColorRed";
	_colorFriendly = "ColorGreen";
	_colorBoth = "ColorOrange";
    
    _colorSelected = _colorEmpty;
    _textSelected = "";
    
	switch (_markerState) do {
    	case 0:{ // No one - default
        	 _colorSelected = _colorEmpty;
        };
        case 1:{ // Friendly NO enemy
        	_colorSelected = _colorFriendly;
            _textSelected = "Player detected : Friendly";
        };
        case 2:{ // Enemy NO friendly
        	_colorSelected = _colorEnemy;
            _textSelected = "Player detected : Enemy";
            hintSilent parseText format ["<t size='2' color='#E01B1B'>%1</t><br/><br/>%2.","ATTENTION!","Enemy player detected the radar proximity!"];
        };
        case 3:{ // Enemy AND friendly
        	_colorSelected = _colorBoth;
            _textSelected = "Players detected : Mixed";
            hintSilent parseText format ["<t size='2' color='#E01B1B'>%1</t><br/><br/>%2.","ATTENTION!","Enemy and Friendly players detected the radar proximity!"];
        };
    };
    
	_markerZone = createMarkerLocal [_x select 0, _x select 1];
	_markerZone setMarkerShapeLocal "ELLIPSE";
    _markerZone setMarkerColorLocal _colorSelected;
	_markerZone setMarkerSizeLocal [350, 350];
	_markerZone setMarkerBrushLocal "Grid";
	_markerZone setMarkerAlphaLocal 0.5; 

	currentRadarMarkers = currentRadarMarkers + [_x select 0];
} forEach clientRadarMarkers;