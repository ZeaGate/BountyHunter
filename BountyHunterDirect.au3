;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Direct implementation
;
;------------------------------------------------------------------------------

; project related includes
#include <Globals.au3>
#include <Utilities.au3>
#include <Actions.au3>
#include <Checks.au3>
#include <Windows.au3>
#include <PersonalConfiguration.au3>

#include <GUIConstantsEx.au3>
#include <ImageSearch.au3>

;ActionManualTargeting("Images\Overview_SmallNpc.bmp")
;ActionDronesEngage()
;Exit

;------------------------------------------------------------------------------
; GUI
;------------------------------------------------------------------------------
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 

GUICreate("Bounty Hunter", 300, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "OnClose")
GUISetState(@SW_SHOW)

Global $bExitFlag = False
Global $bAtSafePos = False

Func OnClose()
	Debug("OnClose() event")
	$bExitFlag = True;
EndFunc


;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
BountyHunterStraight()

Func BountyHunterStraight()
	Debug("BountyHunterStraight() Started")
	MsgBox(0, "GUI Event", "You will have 10 seconds to move BH GUI")
	Sleep(10000)
	
	If bIsEveClientRunning() = True Then
		Debug("Eve Client is Running already. Connecting...")
		ActivateEveWindow()
	Else
		ActionStartEveOnline()
		ActionSelectCharacter()
	EndIf
	
	; make sure that we are docked in station
	Debug("Wait for Station Environment...")
	If WaitForImage("Images\WindowHeader_StationServices.bmp", 30) = True Then
		Debug("Station Confirmed!")
	Else
		Die("We are not docked at the Station?")
	EndIf	
	
	; check local
	WaitForClearLocal()
	
	; undock
	ActionUndockFromTheStation()
	
	; confirm that we are in space
	Debug("Wait for Space...")
	If WaitForImage("Images\WindowHeader_Drones.bmp", 30) = True Then
		Debug("Space Confirmed!")
	Else
		Die("We are not in Space?")
	EndIf	
		
	; stop ship
	ActionStopShip()
	
	Local $bInitInSpace = True
	
	; New Task Loop
	While $bExitFlag = False
		Debug("New Task Loop: iteration started")
		
		Local $bLocalIsRed = CheckLocal()
		If $bLocalIsRed = True Then
			Debug("Red in local!")
			Evacuation()
			WaitForClearLocal()
			ContinueLoop
		EndIf
		
		; initialization
		If $bInitInSpace = True Then
			Debug("In Space Initialization...")
			
			; enable tank
			ActionTurnTankOn()
			
			; prepare drone window
			ActionPrepareDroneWindow()
			
			Debug("In Space Initialization done!")
			$bInitInSpace = False
		EndIf
		
		; find new anomaly
		If ActionFindNewAnomaly() = False Then
			Debug("No Anomaly Found...")

			; warp to safe pos
			Evacuation()
				
			Debug("Waiting at Safe Pos...")
			Sleep(60000)
			ContinueLoop
		EndIf
		
		; wait for warp in
		ActionWaitForWarpFinished()
		
		Local $bNpcPresent = True
		Local $bPlayerPresenceCheckRequired = True
		Local $bInitInAnomaly = True
		
		Local $timerInAnomaly = TimerInit()
		
		; In Anomaly Loop
		While $bNpcPresent
			Debug("In Anomaly Loop: iteration started (" & TimerDiff($timerInAnomaly) & ")")
			
			Local $bLocalIsRed = CheckLocal()
			If $bLocalIsRed = True Then
				Debug("Red in local!")
				ActionScoopDrones()
				Evacuation()
				WaitForClearLocal()
				ContinueLoop 2
			EndIf
			
			If $bPlayerPresenceCheckRequired = True Then
				Local $bPlayerPresent = CheckPlayerOverview()
				If $bPlayerPresent = True Then
					Debug("Anomaly is occupied!")
					Evacuation()
					WaitForClearLocal()
					ContinueLoop 2
				EndIf
				
				$bPlayerPresenceCheckRequired = False
			EndIf
			
			; initialization
			If $bInitInAnomaly = True Then
				Debug("In Anomaly: Initialization")
				
				; deploy sentries
				ActionLaunchSentryEm()
				
				$bInitInAnomaly = False
			EndIf
			
			Local $bSmallNpcPresent = CheckSmallNpc()
			If $bSmallNpcPresent = True Then
				; manual targeting
				ActionManualTargeting("Images\Overview_SmallNpc.bmp")
				ActionDronesEngage()
			EndIf
			
			Sleep(1000)
			$bNpcPresent = CheckNpc()
		WEnd
		
		; scoop drones
		ActionScoopDrones()
		
		Debug("Anomaly finished! Time spent: " & TimerDiff($timerInAnomaly))
	WEnd
EndFunc

Func WaitForClearLocal()
	Debug("Wait for clear local...")
	While CheckLocal() = True
		Debug("... still waiting")
		Sleep(60000)
	WEnd
	Debug("Local is clear!")
EndFunc

Func Evacuation()
	Debug("Evacuation()...")
	
	If $bAtSafePos = False Then
		ActionWarpToSafePos()
		ActionWaitForWarpFinished()
		$bAtSafePos = True
	EndIf
	
	Debug("Evacuation() done!")
EndFunc

Func CheckLocal() 
	Return CheckIsMinusInLocal()
EndFunc

Func CheckPlayerOverview()
	ActionActivateOverviewTab("Pilots")
	Return CheckIsAnyPilotInOverview()
EndFunc

Func CheckSmallNpc()
	ActionActivateOverviewTab("Npc")
	Return CheckIsSmallNpcInOverview()
EndFunc

Func CheckNpc()
	ActionActivateOverviewTab("Npc")
	Return CheckIsAnyNpcInOverview()
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------