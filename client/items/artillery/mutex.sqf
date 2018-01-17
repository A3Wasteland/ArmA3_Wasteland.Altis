// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define ERR_MUTEX_LOCKED localize "STR_WL_Errors_InProgress"
#define MUTEX_LOCK_OR_FAIL \
	if mutexScriptInProgress exitWith {hint ERR_MUTEX_LOCKED;}; \
	mutexScriptInProgress = true;
#define MUTEX_UNLOCK mutexScriptInProgress = false;

/* IMPORTANT
 *
 * this only provides psudo mutual exclusion.
 *
 * there is still a race condition as the if is not using atomic test and set.
 * If you dont know what im talking about, its not incredibly important, but if
 * ocasssionaly it may stuff up and let two scripts run at the same time. Im not
 * familiar enough with the preprocessor (and how much c we can use) to create
 * a proper algorithm. that and it isnt THAT important at the end of the day.
 *
 * TLDR: It MAY let two scripts one at the same time.
 */
