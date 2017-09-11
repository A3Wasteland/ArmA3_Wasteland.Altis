// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_encodeText.sqf
//	@file Author: AgentRev

// convert special characters to their XML entities for subsequent use with parseText
// https://en.wikipedia.org/wiki/Character_encodings_in_HTML#XML_character_references

_this splitString "" apply {["&amp;","&lt;","&gt;","&quot;","&apos;",_x] select (["&","<",">",'"',"'",_x] find _x)} joinString ""
