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
;TestImages()

;InnerLoop()
;Evacuation()
Exit

Func Main()
	Debug("BountyHunter() Started")
	MsgBox(0, "GUI Event", "You will have 5 seconds to move BH GUI")
	Sleep(5000)
	
	Initialization()

	; Main Loop aka "New Task Loop"
	While True ; consider end of loop condition / variable / flag
		Debug("New Task Loop: iteration started")
		
		If TryGetIntoNewAnomaly() = False Then
			ContinueLoop
		EndIf
		
		; deploy sentries
		ALaunchSentryEm()
		
		InnerLoop()
	WEnd
EndFunc

Func Initialization()
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
		Debug("InitializationInSpace(): Red in local!")
		Evacuation()
		WaitForClearLocal()
	EndIf
		
	ATankEnable()
	APrepareDroneWindow()
EndFunc

Func TryGetIntoNewAnomaly()
	; find new anomaly
	If AFindAnomaly() = False Then
		Debug("No Anomaly Found...")

		; warp to safe pos
		Evacuation()
				
		Debug("Waiting at Safe Pos...")
		Sleep(60000)
			
		Return False
	EndIf
		
	; wait for warp in
	AWaitForWarpFinished(10000)				
		
	; we are not at the safe pos anymore
	$bAtSafePos = False
		
	If CIsLocalRed() = True Then
		Debug("New Task Loop: Red in local!")
		AScoopDrones()
		Evacuation()
		WaitForClearLocal()
			
		Return False
	EndIf
	
	; check if anomaly is pre-ocupied 
	AActivateOverviewTab("Pilots")
	If CIsAnyPilotInOverview() = True Then
		Debug("Anomaly is occupied!")
		Evacuation()
		WaitForClearLocal()
			
		Return False
	EndIf
	AActivateOverviewTab("Npc")
			
	Return True	
EndFunc

Func InnerLoop()
	ActivateEveWindow()
	
	Local $timerInAnomaly = TimerInit()
		
	; "In Anomaly" Loop
	Local $bNpcPresent = True
	Local $npcPresentTimer = 0
		
	While $bNpcPresent
		Debug("In Anomaly Loop: iteration started (" & TimerDiff($timerInAnomaly) & ")")
			
		Local $bLocalIsRed = CIsLocalRed()
		If $bLocalIsRed = True Then
			Debug("In Anomaly Loop: Red in local!")
			AScoopDrones()
			Evacuation()
			WaitForClearLocal()
			Return
		EndIf
			
		ManualTargeting()
			
		; make sure that there is no NPC in site
		If CIsAnyNpcInOverview() = False Then
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
	AScoopDrones()
		
	Debug("Anomaly finished! Time spent: " & TimerDiff($timerInAnomaly))
EndFunc

Func ManualTargeting()
	Debug("Before Manual ""Switch"": ")
	Local $bIsSmallTargeted = 	CIsSpecificTargetedNpcInOverview("Small")
	Local $bIsMediumTargeted = 	CIsSpecificTargetedNpcInOverview("Medium")
	Local $bIsBigTargeted = 	CIsSpecificTargetedNpcInOverview("Big")

	; fix targeting that was done by mistake
	If $bIsSmallTargeted = True AND $bIsMediumTargeted = True Then
		AManualUnTargeting("Medium")
	EndIf
	If ($bIsSmallTargeted = True OR $bIsMediumTargeted = True) AND $bIsBigTargeted = True Then
		AManualUnTargeting("Big")
	EndIf
			
	If $bIsSmallTargeted = True OR $bIsMediumTargeted = True OR $bIsBigTargeted = True Then
		Debug("...Targeted NPC Found... ")
		If CIsActiveDroneEngagement() = False Then
			Debug("...Targeted NPC Found... engaging with Drones")
			ADronesEngage()
		EndIf
		
		; Tachyons for Dominix
		If $bDominix AND CIsActiveLargeBeamEngagement() = False Then
			Debug("...Targeted NPC Found... engaging with Tachyons")
			AEngageMainWeapon()
		EndIf
	EndIf
	
	; Cruise for Rattlesnake
	If $bRattlesnake AND ($bIsBigTargeted = True OR $bIsMediumTargeted = True) Then
		If CIsActiveCruiseEngagement() = False Then
			Debug("...Targeted NPC Found... engaging with Cruise")
			AEngageMainWeapon()
		EndIf
	EndIf
				
	If CIsSpecificNotTargetedNpcInOverview("Small") Then
		Debug("...Small NPC Found, targeting ")
		AManualTargeting("Small")
	ElseIf $bIsSmallTargeted = False AND CIsSpecificNotTargetedNpcInOverview("Medium") Then
		Debug("...Medium NPC Found, targeting ")
		AManualTargeting("Medium")
	ElseIf $bIsSmallTargeted = False AND $bIsMediumTargeted = False AND CIsSpecificNotTargetedNpcInOverview("Big") Then
		Debug("...Big NPC Found, targeting ")
		AManualTargeting("Big")
	Else
		; nothing to target
	EndIf
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
		AWarpToSafePos()
		AWaitForWarpFinished(0)
		$bAtSafePos = True
	EndIf
	
	Debug("Evacuation() done!")
EndFunc
 
Func TestImages()
	ActivateEveWindow()
	
	Local $droneWindow[7] ; size + munber of images
	$droneWindow[0] = 6 ; number of images
	$droneWindow[1] = "Images\Drones_DronesInBayClosed.bmp"
	$droneWindow[2] = "Images\Drones_DronesInBayOpen.bmp"
	$droneWindow[3] = "Images\Drones_DronesInLocalSpaceClosed.bmp"
	$droneWindow[4] = "Images\Drones_DronesInLocalSpaceOpen.bmp"
	$droneWindow[5] = "Images\Drones_SentryEmClosed.bmp"
	$droneWindow[6] = "Images\Drones_SentryEmOpen.bmp"
	
	TestImages_impl($droneWindow)
EndFunc

Func TestImages_impl($images)
	For $i = 1 to $images[0]
		If IsImageOnDesktop($images[$i]) Then
			Debug("[ GOOD ]" & $images[$i])
		Else
			Debug("[ BAD  ]" & $images[$i])
		EndIf
    Next
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------