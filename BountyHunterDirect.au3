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

; AutoIt includes
#include <GUIConstantsEx.au3>
#include <ImageSearch.au3>

;------------------------------------------------------------------------------
; GUI
;------------------------------------------------------------------------------
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 

GUICreate("Bounty Hunter", 300, 400)
GUISetOnEvent($GUI_EVENT_CLOSE, "OnClose")
GUISetState(@SW_SHOW)

;------------------------------------------------------------------------------
; GUI Event Processing
;------------------------------------------------------------------------------
Func OnClose()
	Debug("OnClose() event")
	Exit
EndFunc
;------------------------------------------------------------------------------
; Global Flags
;------------------------------------------------------------------------------
Global $bAtSafePos = False

;------------------------------------------------------------------------------
; Entry Point
;------------------------------------------------------------------------------

; placeholder for small debug routines 
Main()
Exit

Func Main()
	Debug("BountyHunter() Started")
	MsgBox(0, "GUI Event", "You will have 5 seconds to move BH GUI")
	Sleep(5000)
	
	Initialization()

	; Main Loop aka "New Task Loop"
	While True ; consider end of loop condition / variable / flag
		Debug("New Task Loop: iteration started")
		
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
		AWaitForWarpFinished(10000)
		
		; we are not at the safe pos anymore
		$bAtSafePos = False
		
		Local $bPlayerPresenceCheckRequired = True
		Local $bInitInAnomaly = True
		
		
			Local $bLocalIsRed = CIsLocalRed()
			If $bLocalIsRed = True Then
				Debug("Red in local!")
				ActionScoopDrones()
				Evacuation()
				WaitForClearLocal()
				ContinueLoop 1
			EndIf
			
			If $bPlayerPresenceCheckRequired = True Then
				ActionActivateOverviewTab("Pilots")
				Local $bPlayerPresent = CheckPlayerOverview()
				If $bPlayerPresent = True Then
					Debug("Anomaly is occupied!")
					Evacuation()
					WaitForClearLocal()
					ContinueLoop 2
				EndIf
				
				ActionActivateOverviewTab("Npc")
				$bPlayerPresenceCheckRequired = False
			EndIf
			
			; initialization
			If $bInitInAnomaly = True Then
				Debug("In Anomaly: Initialization")
				
				; deploy sentries
				ActionLaunchSentryEm()
				
				$bInitInAnomaly = False
			EndIf		
		
		
		Local $timerInAnomaly = TimerInit()
		
		; "In Anomaly" Loop
		Local $bNpcPresent = True
		Local $npcPresentTimer = 0
		While $bNpcPresent
			Debug("In Anomaly Loop: iteration started (" & TimerDiff($timerInAnomaly) & ")")
			
			Local $bLocalIsRed = CIsLocalRed()
			If $bLocalIsRed = True Then
				Debug("Red in local!")
				ActionScoopDrones()
				Evacuation()
				WaitForClearLocal()
				ContinueLoop 2
			EndIf
			
			
			Debug("Before Manual ""Switch"": " & TimerDiff($timerInAnomaly))
			Local $bIsSmallTargeted = CheckSpecificTargetedNpc("Small")
			Local $bIsMediumTargeted = CheckSpecificTargetedNpc("Medium")
			Local $bIsBigTargeted = CheckSpecificTargetedNpc("Big")
			
			; fix targeting that was done by mistake
			If $bIsSmallTargeted = True AND $bIsMediumTargeted = True Then
				ActionManualUnTargeting("Medium")
			EndIf
			If ($bIsSmallTargeted = True OR $bIsMediumTargeted = True) AND $bIsBigTargeted = True Then
				ActionManualUnTargeting("Big")
			EndIf
			
			If $bIsSmallTargeted = True OR $bIsMediumTargeted = True OR $bIsBigTargeted = True Then
				Debug("...Targeted NPC Found... ")
				If CheckEngagement() = False Then
					Debug("...Targeted NPC Found... engaging " & TimerDiff($timerInAnomaly))
					ActionDronesEngage()
				EndIf
			EndIf
				
			If CheckSpecificNpc("Small") Then
				Debug("...Small NPC Found, targeting " & TimerDiff($timerInAnomaly))
				ActionManualTargeting("Small")
			ElseIf $bIsSmallTargeted = False AND CheckSpecificNpc("Medium") Then
				Debug("...Medium NPC Found, targeting " & TimerDiff($timerInAnomaly))
				ActionManualTargeting("Medium")
			ElseIf $bIsSmallTargeted = False AND $bIsMediumTargeted = False AND CheckSpecificNpc("Big") Then
				Debug("...Big NPC Found, targeting " & TimerDiff($timerInAnomaly))
				ActionManualTargeting("Big")
			Else
				; nothing to target
			EndIf
			
			;Sleep(1000)
			;$bNpcPresent = CheckNpc()
			
			; make sure that there is no NPC in site
			If CheckNpc() = False Then
				If $npcPresentTimer = 0 Then
					; first time? - setup a timer
					$npcPresentTimer = TimerInit()
				EndIf
				
				Local $noNpcDiff = TimerDiff($npcPresentTimer)
				Debug("No NPC Timer: " & $noNpcDiff)
				If $noNpcDiff > 30000 Then
					$bNpcPresent = False
				EndIf
			Else
				$npcPresentTimer = 0
			EndIf
		WEnd
		
		; scoop drones
		ActionScoopDrones()
		
		Debug("Anomaly finished! Time spent: " & TimerDiff($timerInAnomaly))
	WEnd
EndFunc

;------------------------------------------------------------------------------
; Initialize 
;------------------------------------------------------------------------------
Func Initialization()
	; There can be next "Starting Point":
	; - No Client
	; - Docked on Station
	; - In Space
	
	; Do we have running Eve Client already?
	If CIsEveClientRunning() = False Then
		AStartEve()
	EndIf
	
	ActivateEveWindow()
	
	; We can be on Station or in Space
	Local $timer = TimerInit();
	Local $bStation = False
	Local $bSpace = False
	
	While TimerDiff($timer) < 60000
		$bStation = CIsStation()
		$bSpace = CIsSpace()
		
		If $bStation OR $bSpace Then
			ExitLoop
		EndIf
	WEnd
	
	If (NOT $bStation) AND (NOT $bSpace) Then
		Die("Station or Space not found!")
	EndIf
		
	If $bStation = True Then
		Debug("Station Confirmed!")
		
		; make sure that local is friendly
		WaitForClearLocal()
		
		AUndock()
		
		If WaitForUndock() = True Then
			Debug("Undock Confirmed!")
		Else
			Die("Undock failed!")
		EndIf	
		
		; stop ship
		AShipStop()
	EndIf
	
	If $bSpace = True Then
		Debug("Space Confirmed!")
		
		AWaitForWarpFinished(0)
		
		$bAtSafePos = CIsOnPos()
		If $bAtSafePos = False Then
			Evacuation()
		EndIf
	EndIf
	
	InitializationInSpace()
EndFunc
	
Func InitializationInSpace()
	If CIsLocalRed() = True Then
		Evacuation()
		WaitForClearLocal()
	EndIf
		
	ATankEnable()
	APrepareDroneWindow()
EndFunc

Func WaitForClearLocal() ; move to actions
	Debug("Wait for clear local...")
	While CIsLocalRed() = True
		Debug("... still waiting")
		Sleep(60000)
	WEnd
	Debug("Local is clear!")
EndFunc

Func WaitForUndock() ; move to actions
	Debug("Wait for Undock...")
	Return WaitForImage("Images\WindowHeader_Overview.bmp", 30)
EndFunc

Func Evacuation()
	Debug("Evacuation()...")
	
	If $bAtSafePos = False Then
		ActionWarpToSafePos()
		AWaitForWarpFinished(0)
		$bAtSafePos = True
	EndIf
	
	Debug("Evacuation() done!")
EndFunc



Func CheckPlayerOverview()
	;ActionActivateOverviewTab("Pilots")
	Return CheckIsAnyPilotInOverview()
EndFunc

Func CheckNpc()
	;ActionActivateOverviewTab("Npc")
	Return CheckIsAnyNpcInOverview()
EndFunc

Func CheckTargetedNpc()
	;ActionActivateOverviewTab("Npc")
	Return CheckIsAnyTargetedNpcInOverview()
EndFunc

Func CheckSpecificTargetedNpc($targetTemplate)
	Return CheckIsSpecificTargetedNpcInOverview($targetTemplate)
EndFunc

Func CheckSpecificNpc($targetTemplate)
	;ActionActivateOverviewTab("Npc")
	Return CheckIsSpecificNotTargetedNpcInOverview($targetTemplate)
EndFunc

Func CheckEngagement()
	Return CheckIsActiveEngagement()
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------