#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Periodical Checks routines
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------ 
; Events Declaration
;------------------------------------------------------------------------------
; System events
Global Const $eventSystemNoneEvent 				= 1000
Global Const $eventSystemNotImplemented			= 1001
; GUI events
Global Const $eventGuiExit	 					= 2000
Global Const $eventGuiStartBountyHunter			= 2001
; Checks events
Global Const $eventCheckMinusInLocal			= 3000
Global Const $eventCheckLocalIsClear			= 3001
; Internal events
Global Const $eventInternalStartEve				= 4000
Global Const $eventInternalUndock				= 4001
Global Const $eventInternalSelectCharacter		= 4002
Global Const $eventInternalWaitForClearLocal	= 4003
Global Const $eventInternalEvacuation			= 4004
Global Const $eventInternalTurnTankOn			= 4005
Global Const $eventInternalPrepareDroneWindow	= 4006
Global Const $eventInternalFindNewAnomaly		= 4007


;------------------------------------------------------------------------------ 
; Flags Declaration
;------------------------------------------------------------------------------
Global $flagPerformLocalCheck 			= False
Global $flagPerformPilotOverviewCheck 	= False
Global $flagPerformNpcOverviewCheck 	= False
Global $flagPerformDronesCheck 			= False
Global $flagOnStation					= False
Global $flagMinusInLocal				= False

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------