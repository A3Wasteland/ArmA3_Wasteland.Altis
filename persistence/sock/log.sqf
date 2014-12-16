diag_log format["loading log library ..."];

//Log levels (from highest to lowest)
LOG_SEVERE_LEVEL=6;
LOG_WARNING_LEVEL=5;
LOG_INFO_LEVEL=4;
LOG_CONFIG_LEVEL=3;
LOG_FINE_LEVEL=2;
LOG_FINER_LEVEL=1;
LOG_FINEST_LEVEL=0;

//Default system-wide log level
SYS_LOG_LEVEL = LOG_SEVERE_LEVEL;

/**
* Sets the logging level for a component
*
* @param _component_name (String) - Name of the component
* @param _component_level (int) - Logging level for the component
*
* @return
* On success, returns the logging level that was just set
* On failure, returns nil
*/
log_set_level = {
  if (isNil "_this") exitWith {};
  if (typeName _this != typeName []) exitWith {};
  if (count _this < 2) exitWith {};

  private["_component_name"];
  _component_name = _this select 0;
  _component_level = _this select 1;

  if (isNil "_component_name" || {typeName _component_name != typeName ""}) exitWith {};
  if (isNil "_component_level" || {typeName _component_level != typeName 0}) exitWith {};

  missionNamespace setVariable [format["%1_LOG_LEVEL", _component_name], _component_level];

  _component_level
};

/**
* Gets the logging level of a component
*
* @param _component_name (String) - Name of the component
*
* @return
* On success returns the logging level of the specified component.
* On failure, if the specified component does not exist, it returns the system wide log-level
*/
log_get_level = {
  private["_component_name"];
  if (isNil "_this") exitWith {SYS_LOG_LEVEL};
  _component_name = _this;
  if (typeName _component_name != typeName "") exitWith {SYS_LOG_LEVEL};

  private["_component_level"];
  _component_level = missionNamespace getVariable [format["%1_LOG_LEVEL", toUpper(_component_name)], SYS_LOG_LEVEL];
  _component_level
};


/**
* Converts a logging level value to string
*
* @param _level (String) - The logging level value to convert
*
* @return
* On success, returns the string for the specified logging @{code _level}
* On failure, returns empty string.
*
*/
log_get_level_name = {
  private["_level"];
  if (isNil "_this") exitWith {""};
  if (typeName _this != typeName 0) exitWith {""};

  private["_level"];
  _level = _this;

  if (_level == LOG_SEVERE_LEVEL) exitWith {"severe"};
  if (_level == LOG_WARNING_LEVEL) exitWith {"warning"};
  if (_level == LOG_INFO_LEVEL) exitWith {"info"};
  if (_level == LOG_CONFIG_LEVEL) exitWith {"config"};
  if (_level == LOG_FINE_LEVEL) exitWith {"fine"};
  if (_level == LOG_FINER_LEVEL) exitWith {"finer"};
  if (_level == LOG_FINEST_LEVEL) exitWith {"finest"};

  ""
};

/**
* Prints a logging string to the game's RPT file
*
* @param _level (int) - Logging level at which to log the message
* @param _component (String) - Name of the component that is logging the message
* @param _message (String) - Message to print in the RPT file
*/
log_rpt = {
  private["_level", "_component", "_message"];
  if (isNil "_this") exitWith {};
  if (count _this < 3) exitWith {};

  _level = _this select 0;
  _component = _this select 1;
  _message = _this select 2;

  if (isNil "_level" || {typeName _level != typeName 0}) exitWith {};
  if (isNil "_component" || {typeName _message != typeName ""}) exitWith {};
  if (isNil "_message" || {typeName _message != typeName ""}) exitWith {};

  private["_component_level"];
  _component_level = _component call log_get_level;
  if (_level < _component_level) exitWith {};

  private["_level_str"];
  _level_str = _level call log_get_level_name;

  diag_log (_component + ": " + _level_str + ": " + _message);
};


/**
* Prints a logging message at SEVERE level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_severe = {
  ([LOG_SEVERE_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at WARNING level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_warning = {
  ([LOG_WARNING_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at INFO level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_info = {
  ([LOG_INFO_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at CONFIG level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_config = {
  ([LOG_CONFIG_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at FINE level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_fine = {
  ([LOG_FINE_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at FINER level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_finer = {
  ([LOG_FINER_LEVEL] + _this) call log_rpt
};

/**
* Prints a logging message at FINEST level for the specified component
* @param _component_name (String) - Name of the component that is logging the message
* @param _message (String) - Message to be logged
*/
log_finest = {
  ([LOG_FINEST_LEVEL] + _this) call log_rpt
};


diag_log format["loading log library complete"];