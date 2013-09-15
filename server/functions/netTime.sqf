//@file Author: [404] Pulse
//@file Description: Updates the arma2net based time.

_dateTime = "Arma2Net.Unmanaged" callExtension "DateTime ['now', 'HH:mm:ss dd']";
_timeArray = toArray _dateTime;
_hour = parseNumber format["%1%2",toString [_timeArray select 1], toString [_timeArray select 2]];
_min = parseNumber format["%1%2",toString [_timeArray select 4], toString [_timeArray select 5]];
_sec = parseNumber format["%1%2",toString [_timeArray select 7], toString [_timeArray select 8]];
_day = parseNumber format["%1%2",toString [_timeArray select 10], toString [_timeArray select 11]];
_netTimeInSecs = (_day * 86400) +(_hour * 3600) + (_min * 60) + _sec;
netTime = _netTimeInSecs - missionStartTime;