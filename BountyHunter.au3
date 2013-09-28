;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Main file
;
;------------------------------------------------------------------------------

#include <Tesseract.au3>
#include <ImageSearch.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

; project related includes
#include <PersonalConfiguration.au3>
#include <Utilities.au3>
#include <Actions.au3>
#include <Checks.au3>
#include <Globals.au3>
#include <Windows.au3>


#Region Config
    ; Change to False if you want application running
    Global $bSingleRun = True
    Global $iScale = 3
   
    ; Local window position
    Global $iLocalBeginX = 1176
    Global $iLocalBeginY = 39
    Global $iLocalEndX   = 1358
    Global $iLocalEndY   = 724
   
    ; Overview window position
    Global $iOverviewBeginX = 789
    Global $iOverviewBeginY = 350
    Global $iOverviewEndX   = 1105
    Global $iOverviewEndY   = 724

    Global $bExitFlag = False;
	
	; Login related data
	Global $strEveLauncherPath = ""
	Global $strPassword = ""
#EndRegion

;------------------------------------------------------------------------------
; GUI
;------------------------------------------------------------------------------
GUICreate("Bounty Hunter", 300, 400)
$btnStartBountyHunter = GUICtrlCreateButton("StartBountyHunter", 5, 5, 290, 20)
$btnDockToStation = GUICtrlCreateButton("Dock to the Station", 5, 35, 290, 20)
$btnWarpToSafePos = GUICtrlCreateButton("Warp to the Safe POS", 5, 65, 290, 20)
$btnUndockFromStation = GUICtrlCreateButton("Undock from the station", 5, 95, 290, 20)
$btnAcquireNewTask = GUICtrlCreateButton("Acquire new task", 5, 125, 290, 20)
$btnEnableTank = GUICtrlCreateButton("Enable Tank", 5, 155, 290, 20)
$btnExpandDroneWindow = GUICtrlCreateButton("Expand Drone Window", 5, 185, 290, 20)
$btnLaunchSentryEm = GUICtrlCreateButton("Launch Sentry EM", 5, 215, 290, 20)
$btnDronesEngage = GUICtrlCreateButton("Drones Engage", 5, 245, 290, 20)
$btnScoopDrones = GUICtrlCreateButton("Scoop Drones", 5, 275, 290, 20)
$btnStart = GUICtrlCreateButton("Start EVE Online Client", 5, 305, 290, 20)


;------------------------------------------------------------------------------
; Event Sequence Handling
;------------------------------------------------------------------------------
Global $nextEvent = $eventSystemNoneEvent

;------------------------------------------------------------------------------
; WaitForConfirmation Handling
;------------------------------------------------------------------------------
Global $wfcParamImage = ""
Global $wfcParamEventOnSuccess = 0
Global $wfcParamEventOnFailure = 0
Global $wfcParamAllowedWaitTime = 0

Global $wfcTimerHandler = 0

;------------------------------------------------------------------------------
; Quick Debug Placeholder
;------------------------------------------------------------------------------
;ActionTurnTankOn()
;ActionPrepareDroneWindow()
;WaitForShipStoppingToComplete()
;ActionFindNewAnomaly()
;Exit

;------------------------------------------------------------------------------
; Main Loop
; 	Generates Event based on Periodical Checks
;	Generates Event based on users imput via GUI
;	Forwards Event to BountyHunterStateMachine()
;------------------------------------------------------------------------------
GUISetState(@SW_SHOW)
While 1
	Local $currentEvent = $eventSystemNoneEvent
	
	; GUI
	If $currentEvent = $eventSystemNoneEvent Then
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				$currentEvent = $eventGuiExit
			Case $btnStartBountyHunter
				$currentEvent = $eventGuiStartBountyHunter
			
			; NOTE: input from GUI should not break logic of State Machine
			;	make sure to follow/maintain current state, flags, etc.
#cs				
			Case $btnStart
				StartEveOnline()
			Case $btnDockToStation
				DockToStation()
			Case $btnWarpToSafePos
				WarpToSafePos()
			Case $btnUndockFromStation
				UndockFromStation()
			Case $btnAcquireNewTask
				AcquireNewTask()
			Case $btnEnableTank
				EnableTank()
			Case $btnExpandDroneWindow
				ExpandDroneWindow()
			Case $btnLaunchSentryEm
				LaunchSentryEm()
			Case $btnDronesEngage
				DronesEngage()
			Case $btnScoopDrones
				ScoopDrones()
#ce				
		EndSwitch
	EndIf

	; Periodical Checks
	Select
		Case $flagPerformLocalCheck = True AND $currentEvent = $eventSystemNoneEvent
			Local $checkResult = CheckIsMinusInLocal()
			Select
				Case $checkResult = True AND $flagMinusInLocal = False
					$flagMinusInLocal = True
					$currentEvent = $eventCheckMinusInLocal
				Case $checkResult = False AND $flagMinusInLocal = True
					$flagMinusInLocal = False
					$currentEvent = $eventCheckLocalIsClear					
			EndSelect
	EndSelect
	
	; Event Sequence Handling
	If $currentEvent = $eventSystemNoneEvent Then
		$currentEvent = GetNextEvent()
	EndIf
	
	; Forward Event
	If NOT ($currentEvent = $eventSystemNoneEvent) Then
		BountyHunterStateMachine($currentEvent)
	EndIf
WEnd

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func BountyHunterStateMachine($event)
	Switch $event
	; System events -----------------------------------------------------------
		Case $eventGuiExit
			Debug("$eventGuiExit")
			Beep()
			Exit
			
	; GUI events --------------------------------------------------------------
		Case $eventGuiStartBountyHunter
			Debug("$eventGuiStartBountyHunter")
			If bIsEveClientRunning() = True Then
				ActivateEveWindow()
				InitializeWaitForConfirmation($imageConfirmStation, $eventInternalBountyHunterReadyToGo, $eventGuiExit, 3000)
			Else
				SetNextEvent($eventInternalStartEve)
			EndIf

	; Check events ------------------------------------------------------------
		Case $eventCheckMinusInLocal
			Debug("$eventCheckMinusInLocal")
			If $flagOnStation = True Then
				SetNextEvent($eventInternalWaitForClearLocal)
			Else
				SetNextEvent($eventInternalEvacuation)
			EndIf
			
		Case $eventCheckLocalIsClear
			Debug("$eventCheckLocalIsClear")
			If $flagOnStation = True Then
				SetNextEvent($eventInternalUndock)
			Else
				SetNextEvent($eventInternalFindNewAnomaly)
			EndIf
	
	; Internal events ---------------------------------------------------------
		Case $eventInternalWaitForConfirmation
			If $flagWfcEnabled = False Then 
				Die("WTF am I doing in $eventInternalWaitForConfirmation?")
			EndIf
			
			Local $diff = TimerDiff($wfcTimerHandler)
			Debug("$eventInternalWaitForConfirmation: " & $diff)
			
			Local $bFound = False
			If $diff < $wfcParamAllowedWaitTime Then
				$bFound = IsImageOnDesktopNow($wfcParamImage)
				If $bFound Then
					Debug("Confirmation (" & $wfcParamImage & ") Found!")
					SetNextEvent($wfcParamEventOnSuccess)
				Else
					SetNextEvent($eventInternalWaitForConfirmation)
				EndIf
			Else
				SetNextEvent($wfcParamEventOnFailure)
				FreeWaitForConfirmation()
			EndIf
			
		Case $eventInternalStartEve
			Debug("$eventInternalStartEve")
			ActionStartEveOnline()
			SetNextEvent($eventInternalSelectCharacter)
			
		Case $eventInternalSelectCharacter
			Debug("$eventInternalSelectCharacter")
			ActionSelectCharacter()
			InitializeWaitForConfirmation($imageConfirmStation, $eventInternalBountyHunterReadyToGo, $eventGuiExit, 30000)
			
		Case $eventInternalBountyHunterReadyToGo
			; can get here only if we are on station
			$flagPerformLocalCheck = True
			$flagOnStation = True
			SetNextEvent($eventInternalUndock)
		
		Case $eventInternalWaitForClearLocal
			Debug("$eventInternalWaitForClearLocal")
			; do nothing. event will come and system will react
			
		Case $eventInternalUndock
			Debug("$eventInternalUndock")
			ActionUndockFromTheStation()
			InitializeWaitForConfirmation($imageConfirmSpace, $eventInternalJustUndocked, $eventGuiExit, 30000)
			
		Case $eventInternalJustUndocked
			Debug("$eventInternalJustUndocked")
			$flagOnStation = False
			SetNextEvent($eventInternalTurnTankOn)
			
		Case $eventInternalTurnTankOn
			Debug("$eventInternalTurnTankOn")
			ActionTurnTankOn()
			; there is no simple way to check if Tank is ON yet
			SetNextEvent($eventInternalPrepareDroneWindow)
			
		Case $eventInternalPrepareDroneWindow
			Debug("$eventInternalPrepareDroneWindow")
			ActionPrepareDroneWindow()
			SetNextEvent($eventInternalFindNewAnomaly)
			
		Case $eventInternalFindNewAnomaly
			Debug("$eventInternalFindNewAnomaly")
			ActionFindNewAnomaly()
			SetNextEvent($eventInternalLaunchSentryEm)
		
		Case $eventInternalLaunchSentryEm
			Debug("$eventInternalLaunchSentryEm")
			ActionLaunchSentryEm()
			$flagDronesDeployed = True
			SetNextEvent($eventInternalAnomalyFarming)
			
		Case $eventInternalAnomalyFarming
			Debug("$eventInternalAnomalyFarming")
			; do nothing. event will come and system will react
			
		Case $eventInternalEvacuation
			Debug("$eventInternalEvacuation")
			ActionWarpToSafePos()
			SetNextEvent($eventInternalWaitForClearLocal)
			
		
	; Unknown event -----------------------------------------------------------
		Case Else
			Die("Unknown Event: " & $event)
	EndSwitch
EndFunc

;------------------------------------------------------------------------------
; Event Sequence Handling
;------------------------------------------------------------------------------
Func GetNextEvent()
	Local $retVal = $nextEvent
	$nextEvent = $eventSystemNoneEvent
	Return $retVal
EndFunc

Func SetNextEvent($event)
	$nextEvent = $event
EndFunc

;------------------------------------------------------------------------------
; WaitForConfirmation Handling
;------------------------------------------------------------------------------
Func InitializeWaitForConfirmation($image, $eventOnSuccess, $eventOnFailure, $allowedWaitTime)
	Debug("InitializeWaitForConfirmation (" & $image & ") " & $allowedWaitTime)
	
	$wfcParamImage = $image
	$wfcParamEventOnSuccess = $eventOnSuccess
	$wfcParamEventOnFailure = $eventOnFailure
	$wfcParamAllowedWaitTime = $allowedWaitTime

	$wfcTimerHandler = TimerInit()
	
	$flagWfcEnabled = True
	
	SetNextEvent($eventInternalWaitForConfirmation)
EndFunc

Func FreeWaitForConfirmation()
	Debug("FreeWaitForConfirmation")
	
	$wfcParamImage = ""
	$wfcParamEventOnSuccess = 0
	$wfcParamEventOnFailure = 0
	$wfcParamAllowedWaitTime = 0

	$wfcTimerHandler = 0
	
	$flagWfcEnabled = False
EndFunc




;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
 



 
; obsolete code
; remove 01.10.2013
#cs
While 1
    
    Local $x = 0, $y = 0
	Local $search = _ImageSearchArea("Images\ColorTag_NoStand.bmp", 1, $iLocalBeginX-30, $iLocalBeginY, $iLocalEndX, $iLocalEndY, $x, $y, 0)
	If $search = 1 Then
	   MouseMove($x, $y, 100);
    EndIf
WEnd

; Main Loop
While $bExitFlag = False
   
    WinActivate ( "EVE" )
   
    ; Capture Local window
    Local $strLocalText = _TesseractScreenCapture("", 0, $iScale, $iLocalBeginX, $iLocalBeginY, $iLocalEndX, $iLocalEndY, 0)
    MsgBox(0, "Local", $strLocalText)
	
	; Capture Overview window
    Local $strOverviewText = _TesseractScreenCapture("", 0, $iScale, $iOverviewBeginX, $iOverviewBeginY, $iOverviewEndX, $iOverviewEndY, 0)
    MsgBox(0, "Local", $strOverviewText)

#cs
    if IsArray($captured_text) Then
	   _ArrayDisplay($captured_text, "Tesseract Text Capture")
    Else
	   MsgBox(0, "Tesseract Text Capture", $captured_text)
    EndIf   
#ce
 
    ; Single Run
    If $bSingleRun = True Then
	   $bExitFlag = True
    EndIf
    
WEnd
#ce


