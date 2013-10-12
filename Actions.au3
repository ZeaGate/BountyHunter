#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Action routines
;
; Code Agreements:
; Routine name starts from A (i.e. Action)
; Action should start with ActivateEveWindow() call
;------------------------------------------------------------------------------

Func AStartEve()
	;Debug("AStartEve()...")
	
	; this call here only until all Setting is related to AStartEveOnline()
	ApplyPersonalSettings()
	
	; start Eve Client
	Run($strEveLauncherPath)
	
	; wait for Login button
	Local $x, $y
	If WaitForImage_XY("Images\Launcher_LoginButton.bmp", 60, $x, $y) = False Then
		Die("Login Failed: Launcher window not found");
	EndIf
	
	; password
	RndSleep(2000, 300)
	Send($strPassword)
	
	; click on Login button
	RndSleep(1000, 300)
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,10), 1, RandomizeIt(20,5) )
	
	; wait for Select Character window
	If WaitForImage_XY("Images\SelectCharacter_EnterGame.bmp", 120, $x, $y) = False Then
		Die("Login Failed: Select Character window not found");
	EndIf
	
	; click on button
	RndSleep(2000, 300)
	MouseClick("left", RandomizeIt($x,10), RandomizeIt($y,10), 1, RandomizeIt(20,5) )
	
	;Debug("AStartEve() done!")
EndFunc	
	
Func ADock()
	;Debug("ADock()...")
	
	ActivateEveWindow()

	MoveMouseToLocalHeader()
	WindowPeopleAndPlaces($cWindowCommandOpen)
	
	Local $x, $y
	Local Const $WaitInSeconds = 15
	
	; locate Station Bookmark
	WaitForImage_XY("Images\PeopleAndPlaces_Station.bmp", 5, $x, $y)
	local $res = _WaitForImageSearch("Images\PeopleAndPlaces_Station.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
	   Die("Station bookmark not found");
	EndIf
 
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )

	; locate Dock in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_Dock.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
	   Die("""Dock"" menu entry not found");
	EndIf
	
	; select Dock from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	Sleep( RandomizeIt(3000,1000) )
	ClosePeopleAndPlaces()
	
EndFunc

Func AUndock()
	;Debug("AUndock()...")
	
	ActivateEveWindow()
	
	; Alt+U
	Send("{ALTDOWN}")
	RndSleep(500,50)
	Send("u")
	RndSleep(500,50)
	Send("{ALTUP}")
	RndSleep(500,50)
	
	;Debug("AUndock() done!")
EndFunc

Func AShipStop()
	;Debug("AShipStop()...")
	
	ActivateEveWindow()
	
	; Ctrl+Space
	Send("{CTRLDOWN}")
	RndSleep(500,50)
	Send("{SPACE}")
	RndSleep(500,50)
	Send("{CTRLUP}")
	RndSleep(500,50)
	
	;Debug("AShipStop() done!")
EndFunc

Func AWarpToSafePos()
	Debug("AWarpToSafePos()...")
	ActivateEveWindow()
	
	MoveMouseToLocalHeader()
	WindowPeopleAndPlaces($cWindowCommandOpen)
	
	Local $x, $y
	Local Const $WaitInSeconds = 5
	
	; locate Station Bookmark
	local $res = _WaitForImageSearch("Images\PeopleAndPlaces_SafePos.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("Safe Pos bookmark not found");
	EndIf
 
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )

	; locate Warp to location... in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_WarpToLocation.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("""Warp to location..."" menu entry not found");
	EndIf
	
	; select Warp to location from context menu
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	; save Y coord for next step 
	Local $oldY = $y
	
	; locate Within 10km in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_Within10km.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("""Within 10km"" menu entry not found");
	EndIf
	
	; select Within 10km from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseMove(RandomizeIt($x,5), RandomizeIt($oldY,2), RandomizeIt(20,5))
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	Sleep( RandomizeIt(3000,1000) )
	WindowPeopleAndPlaces($cWindowCommandClose)
	
	Debug("AWarpToSafePos() done")
EndFunc

Func AFindAnomaly()
	Debug("AFindAnomaly()...")
	ActivateEveWindow()

	MoveMouseToLocalHeader()
	WindowScanner($cWindowCommandOpen)
	
	Local $anomaly_x, $anomaly_y
	Local Const $WaitInSeconds = 5
	
	; prepare array with anomaly names
	Local $anomalies[3] ; size + munber of images
	$anomalies[0] = 2 ; number of images
	$anomalies[1] = "Images\Scanner_SanshaForsakenHub.bmp"
	$anomalies[2] = "Images\Scanner_SanshaForsakenRallyPoint.bmp"
	
	; locate anomaly
	local $res = _WaitForImagesSearch($anomalies, $WaitInSeconds, $ImageSearch_ResultPosition_Center, $anomaly_x, $anomaly_y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		WindowScanner($cWindowCommandClose)
		; Die("No anomaly found");
		Return False
	EndIf
 
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )

	; locate Warp to location... in context menu
	Local $warpTo_x, $warpTo_y
	$res = _WaitForImageSearch("Images\ContextMenu_WarpToWithin.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $warpTo_x, $warpTo_y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		;ClickOnLocalHeader()
		;WindowScanner($cWindowCommandClose)
		Die("""Warp to location..."" menu entry not found");
	EndIf
	
	; select Warp to location from context menu
	MouseClick("left", RandomizeIt($warpTo_x,5), RandomizeIt($warpTo_y,2), 1, RandomizeIt(20,5) )
	
	; locate Within 70km in context menu
	Local $x, $y
	$res = _WaitForImageSearch("Images\ContextMenu_Within70km.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		;ClickOnLocalHeader()
		;WindowScanner($cWindowCommandClose)
		Die("""Within 70km"" menu entry not found");
	EndIf
	
	; select Within 70km from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseMove(RandomizeIt($x,5), RandomizeIt($warpTo_y,2), RandomizeIt(20,5))
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	; Close Anomaly Info Window
	RndSleep(2000,500)
	Send("{ENTER}")
	
	; save bookmark
	RndSleep(2000,500)
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )
	
	$res = _WaitForImageSearch("Images\ContextMenu_SaveLocation.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("""Save Location"" menu entry not found");
	EndIf
	
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	; specify bookmark name
	RndSleep(2000,500)
	Send("BH.zAnomaly")
	RndSleep(500,50)
	Send("{ENTER}")
	
	
	; ignore that anomaly
	RndSleep(2000,500)
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )
	
	$res = _WaitForImageSearch("Images\ContextMenu_IgnoreResult.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		;ClickOnLocalHeader()
		;WindowScanner($cWindowCommandClose)
		Die("""Ignore Result"" menu entry not found");
	EndIf
	
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	RndSleep(3000,1000)
	MoveMouseToLocalHeader()
	WindowScanner($cWindowCommandClose)
	Debug("AFindAnomaly() done!")
	
	Return True
	
	;WaitForShipStoppingToComplete()
EndFunc   

Func AWaitForWarpFinished($minimalWaitTime = 0)
	Debug("AWaitForWarpFinished()...")
	ActivateEveWindow()
	Sleep($minimalWaitTime)
		
	MoveMouseToLocalHeader()
	WindowPeopleAndPlaces($cWindowCommandOpen)
	
	; locate Station Bookmark
	Local $bm_x, $bm_y
	Local Const $WaitInSeconds = 5
	Local $res = _WaitForImageSearch("Images\PeopleAndPlaces_Dummy.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $bm_x, $bm_y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		;WindowPeopleAndPlaces($cWindowCommandClose)
		Die("Dummy bookmark not found");
	EndIf
 
	$bm_x = RandomizeIt($bm_x, 20)
	$bm_y = RandomizeIt($bm_y, 2)
	
	Local $bFound = False
	Local Const $iterations = 90
	For $i = 0 To $iterations
		Debug("iteration: " & $i)
		
		; move mouse cursor to that bookmark and make a right mouse click for context menu
		MouseClick("right", $bm_x, $bm_y, 1, RandomizeIt(20,5) )
		
		If IsImageOnDesktop("Images\ContextMenu_WarpToLocation.bmp") Then
			Debug("Warp Finished!")
			$bFound = True
			ExitLoop
		EndIf
		
		Sleep(1000)
	Next
	
	; clean up
	ClickOnLocalHeader() ; get rid of open context menu
	WindowPeopleAndPlaces($cWindowCommandClose)
	
	If $bFound = False Then
		Die("AWaitForWarpFinished failed")
	EndIf	
	
	Debug("AWaitForWarpFinished() done!")
EndFunc

Func ATankEnable()
	;Debug("ATankEnable()...")
	
	ActivateEveWindow()
	
	If $bDominix Then
		; armor tank
		; Ctrl+F1, Ctrl+F2, Ctrl+F3, Ctrl+F4
		Send("{CTRLDOWN}")
		RndSleep(500,50)
		Send("{F1}")
		RndSleep(500,50)
		Send("{F2}")
		RndSleep(500,50)
		Send("{F3}")
		RndSleep(500,50)
		Send("{F4}")
		RndSleep(500,50)
		Send("{CTRLUP}")
		RndSleep(500,50)
	
		; sensor booster
		; Alt+F1
		Send("{ALTDOWN}")
		RndSleep(500,50)
		Send("{F1}")
		RndSleep(500,50)
		Send("{ALTUP}")
		RndSleep(500,50)
	EndIf
	
	If $bRattlesnake Then
		; shield tank
		; Alt+F1
		Send("{ALTDOWN}")
		RndSleep(500,50)
		Send("{F3}")
		RndSleep(500,50)
		Send("{F4}")
		RndSleep(500,50)
		Send("{F5}")
		RndSleep(500,50)
		Send("{ALTUP}")
		RndSleep(500,50)
	EndIf
		
	;Debug("ATankEnable() done!")
EndFunc

Func APrepareDroneWindow()
	;Debug("APrepareDroneWindow()...")
	
	ActivateEveWindow()	
	
	MoveMouseToTheParkingSpot()
	
	Local $x, $y
	;Local Const $WaitInSeconds = 5
	
	; locate 
	Local $res = _ImageSearch("Images\Drones_DronesInBayClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
	
	; locate 
	$res = _ImageSearch("Images\Drones_DronesInLocalSpaceClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance ) ; note tolerance here
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
	
	; locate 
	$res = _ImageSearch("Images\Drones_SentryEmClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
	
	; self check
	Local $resInBay 	= IsImageOnDesktop("Images\Drones_DronesInBayOpen.bmp")
	Debug("$resInBay=" & $resInBay)
	Local $resInSpace 	= IsImageOnDesktop("Images\Drones_DronesInLocalSpaceOpen.bmp")
	Debug("$resInSpace=" & $resInSpace)
	Local $resSentryEm 	= IsImageOnDesktop("Images\Drones_SentryEmOpen.bmp")
	Debug("$resSentryEm=" & $resSentryEm)
	
	If Not ($resInBay AND $resInSpace AND $resSentryEm) Then
		Die("Drone Window Self Check Failed")
	EndIf	
	
	;Debug("APrepareDroneWindow() done!")
EndFunc

Func ALaunchSentryEm()
	Debug("ALaunchSentryEm()...")
	ActivateEveWindow()	

	Local $x, $y
	Local Const $WaitInSeconds = 5
	
	; locate 
	Local $res = _WaitForImageSearch("Images\Drones_SentryEmOpen.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("Drones_SentryEmOpen not found");
	EndIf
 
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	RndSleep(500,50)
	
	; locate 
	$res = _WaitForImageSearch("Images\ContextMenu_LaunchDrones.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Die("ContextMenu_LaunchDrones not found");
	EndIf
 
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	RndSleep(500,50)
	Debug("ALaunchSentryEm() done!")
EndFunc

Func ADronesEngage()
	Debug("ADronesEngage()...")
	ActivateEveWindow()	
	
	; Ctrl+Shift+A
	Send("{CTRLDOWN}")
	RndSleep(500,50)
	Send("{SHIFTDOWN}")
	RndSleep(500,50)
	Send("a")
	RndSleep(500,50)
	Send("{SHIFTUP}")
	RndSleep(500,50)
	Send("{CTRLUP}")
	RndSleep(500,50)
	
	Debug("ADronesEngage() done!")
EndFunc

Func AEngageMainWeapon()
	;Debug("AEngageMainWeapon()...")
	ActivateEveWindow()	
	
	; F1
	Send("{F1}")
	RndSleep(500,50)
	
	;Debug("AEngageMainWeapon() done!")
EndFunc

Func AScoopDrones()
	Debug("AScoopDrones()...")
	ActivateEveWindow()	
    
	; Ctrl+Shift+D
	Send("{CTRLDOWN}")
	RndSleep(500,50)
	Send("{SHIFTDOWN}")
	RndSleep(500,50)
	Send("d")
	RndSleep(500,50)
	Send("{SHIFTUP}")
	RndSleep(500,50)
	Send("{CTRLUP}")
	RndSleep(500,50)
	Debug("AScoopDrones() done!")
EndFunc

Func AActivateOverviewTab($tabName)
	;Debug("AActivateOverviewTab()...")
	ActivateEveWindow()
	
	; I suppose tab is inactive
	Local $x, $y
	If _WaitForImageSearch("Images\OverviewTab_" & $tabName & "Inactive.bmp", 5, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance ) = $ImageSearch_Success Then
		MouseClick("left", $x, $y, 1, RandomizeIt(20,5) )
	EndIf
	
	; check if tab is active now
	If _WaitForImageSearch("Images\OverviewTab_" & $tabName & "Active.bmp", 5, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance ) = $ImageSearch_Failure Then
		Die("AActivateOverviewTab(): " & $tabName & " not found!")
	EndIf
	
	;Debug("AActivateOverviewTab() done!")
EndFunc

Func AManualTargeting($targetTemplate)
	Debug("AManualTargeting()...")
	
	Local $x, $y
	If CIsSpecificNotTargetedNpcInOverview_XY($targetTemplate, $x, $y) Then
		Debug("Target found at " & $x & ", " & $y)
		; let's target
		Send("{CTRLDOWN}")
		RndSleep(500,50)
		MouseClick("left", $x, $y, 1, RandomizeIt(10,5) )
		RndSleep(500,50)
		Send("{CTRLUP}")
		RndSleep(500,50)			
	EndIf
	
	; move cursor down a bit
	If $x > 0 Then
		MouseMove(RandomizeIt($x,4), RandomizeIt($y+400,5), RandomizeIt(10,5) )
	EndIf
	
	Debug("AManualTargeting() done")
EndFunc

Func AManualUnTargeting($targetTemplate)
	Debug("AManualUnTargeting(" & $targetTemplate & ")...")
	
	Local $x, $y
	
	If CIsSpecificTargetedNpcInOverview_XY($targetTemplate, $x, $y) Then
		Debug("Target found at " & $x & ", " & $y)
		; let's un-target
		Send("{CTRLDOWN}")
		RndSleep(500,50)
		Send("{SHIFTDOWN}")
		RndSleep(500,50)
		MouseClick("left", $x, $y, 1, RandomizeIt(10,5) )
		RndSleep(500,50)
		Send("{SHIFTUP}")
		RndSleep(500,50)
		Send("{CTRLUP}")
		RndSleep(500,50)
	EndIf
	
	; move cursor down a bit
	If $x > 0 Then
		MouseMove(RandomizeIt($x,4), RandomizeIt($y+400,5), RandomizeIt(10,5) )
	EndIf
	
	Debug("AManualUnTargeting() done")
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
