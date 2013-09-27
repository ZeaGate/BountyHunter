#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Action routines
;
;------------------------------------------------------------------------------

; TODO: review ALL action routines and add "Action" prefix to its name


;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionStartEveOnline()
	ApplyPersonalSettings()
	Run($strEveLauncherPath)
	
	Local $x, $y
	Local Const $WaitInSeconds = 60
	
	Local $res = _WaitForImageSearch("Images\Launcher_LoginButton.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
		Die("Login Failed: Launcher window not found");
	EndIf
	
	RndSleep(1000, 300)
	Send($strPassword)
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,10), 1, RandomizeIt(20,5) )
EndFunc	
	
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionSelectCharacter()
	Local $x, $y
	Local Const $WaitInSeconds = 120
	
	; wait for Select Character window
	Local $res = _WaitForImageSearch("Images\SelectCharacter_EnterGame.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
		Die("Login Failed: Select Character window not found");
	EndIf
	
	RndSleep(1000, 300)
	MouseClick("left", RandomizeIt($x,10), RandomizeIt($y,10), 1, RandomizeIt(20,5) )
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func DockToStation()
	
	WinActivate ( "EVE" )
	
	OpenPeopleAndPlaces()
	
	Local $x, $y
	Local Const $WaitInSeconds = 15
	
	; locate Station Bookmark
	local $res = _WaitForImageSearch("Images\PeopleAndPlaces_Station.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Station bookmark not found");
	EndIf
 
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )

	; locate Dock in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_Dock.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Dock"" menu entry not found");
	EndIf
	
	; select Dock from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	Sleep( RandomizeIt(3000,1000) )
	ClosePeopleAndPlaces()
	
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionUndockFromTheStation()
	ActivateEveWindow()
	; Alt+U
	Send("{ALTDOWN}")
	RndSleep(200,50)
	Send("u")
	RndSleep(200,50)
	Send("{ALTUP}")
	RndSleep(200,50)
	
	WaitForUndockToComplete()
EndFunc

Func WaitForUndockToComplete()
	;Debug("WaitForUndockToComplete()")
	;ActivateEveWindow()
	
	Local $x, $y
	Local Const $WaitInSeconds = 30
	
	; prepare array 
	Local $DronesInBay[3] ; size + munber of images
	$DronesInBay[0] = 2 ; number of images
	$DronesInBay[1] = "Images\Drones_DronesInBayClosed.bmp"
	$DronesInBay[2] = "Images\Drones_DronesInBayOpen.bmp"
	
	; locate 
	Local $res = _WaitForImagesSearch($DronesInBay, $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Drones_DronesInBay* not found");
	EndIf
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func WarpToSafePos()
	
	WinActivate ( "EVE" )
	
	OpenPeopleAndPlaces()
	
	Local $x, $y
	Local Const $WaitInSeconds = 15
	
	; locate Station Bookmark
	local $res = _WaitForImageSearch("Images\PeopleAndPlaces_SafePos.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Safe Pos bookmark not found");
	EndIf
 
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )

	; locate Warp to location... in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_WarpToLocation.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Warp to location..."" menu entry not found");
	EndIf
	
	; select Warp to location from context menu
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	; save Y coord for next step 
	Local $oldY = $y
	
	; locate Within 10km in context menu
	$res = _WaitForImageSearch("Images\ContextMenu_Within10km.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Within 10km"" menu entry not found");
	EndIf
	
	; select Within 10km from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseMove(RandomizeIt($x,5), RandomizeIt($oldY,2), RandomizeIt(20,5))
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	Sleep( RandomizeIt(3000,1000) )
	ClosePeopleAndPlaces()
	
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionFindNewAnomaly()
	ActivateEveWindow()

	OpenScanner()
	
	Local $anomaly_x, $anomaly_y
	Local Const $WaitInSeconds = 10
	
	; prepare array with anomaly names
	Local $anomalies[3] ; size + munber of images
	$anomalies[0] = 2 ; number of images
	$anomalies[1] = "Images\Scanner_SanshaForsakenHub.bmp"
	$anomalies[2] = "Images\Scanner_SanshaForsakenRallyPoint.bmp"
	
	; locate anomaly
	local $res = _WaitForImagesSearch($anomalies, $WaitInSeconds, $ImageSearch_ResultPosition_Center, $anomaly_x, $anomaly_y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("No anomaly found");
	EndIf
 
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )

	; locate Warp to location... in context menu
	Local $warpTo_x, $warpTo_y
	$res = _WaitForImageSearch("Images\ContextMenu_WarpToWithin.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $warpTo_x, $warpTo_y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Warp to location..."" menu entry not found");
	EndIf
	
	; select Warp to location from context menu
	MouseClick("left", RandomizeIt($warpTo_x,5), RandomizeIt($warpTo_y,2), 1, RandomizeIt(20,5) )
	
	; locate Within 70km in context menu
	Local $x, $y
	$res = _WaitForImageSearch("Images\ContextMenu_Within70km.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Within 70km"" menu entry not found");
	EndIf
	
	; select Within 70km from context menu
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseMove(RandomizeIt($x,5), RandomizeIt($warpTo_y,2), RandomizeIt(20,5))
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	; Close Anomaly Info Window
	RndSleep(2000,500)
	Send("{ENTER}")
	
	; ignore that anomaly
	RndSleep(2000,500)
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )
	
	$res = _WaitForImageSearch("Images\ContextMenu_IgnoreResult.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Ignore Result"" menu entry not found");
	EndIf
	
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	RndSleep(3000,1000)
	CloseScanner()
	
	WaitForShipStoppingToComplete()
EndFunc   

Func WaitForShipStoppingToComplete()
	; NOT WORKING!!
	Local $x, $y
	Local Const $WaitInSeconds = 90
	
	; locate 
	Local $res = _WaitForImageSearch("Images\Hud_ShipStopping.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Hud_ShipStopping not found");
	EndIf
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionTurnTankOn()
	ActivateEveWindow()
	; Ctrl+F1, Ctrl+F2, Ctrl+F3, Ctrl+F4
	Send("{CTRLDOWN}")
	RndSleep(200,50)
	Send("{F1}")
	RndSleep(200,50)
	Send("{F2}")
	RndSleep(200,50)
	Send("{F3}")
	RndSleep(200,50)
	Send("{F4}")
	RndSleep(200,50)
	Send("{CTRLUP}")
	RndSleep(200,50)
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActionPrepareDroneWindow()
	ActivateEveWindow()	
	MoveMouseToTheParkingSpot()
	
	Local $x, $y
	;Local Const $WaitInSeconds = 5
	
	; locate 
	Local $res = _ImageSearch("Images\Drones_DronesInBayClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
	
	; locate 
	$res = _ImageSearch("Images\Drones_DronesInLocalSpaceClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, 4 ) ; note tolerance here
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
	
	; locate 
	$res = _ImageSearch("Images\Drones_SentryEmClosed.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
		RndSleep(1000,100)
	EndIf
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func LaunchSentryEm()
   
	WinActivate ( "EVE" )
	
	Local $x, $y
	Local Const $WaitInSeconds = 5
	
	
	; locate 
	Local $res = _WaitForImageSearch("Images\Drones_SentryEmOpen.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Drones_SentryEmOpen not found");
	EndIf
 
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	Sleep( RandomizeIt(200,50) )
	
	; locate 
	$res = _WaitForImageSearch("Images\ContextMenu_LaunchDrones.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, 1 )
	If $res = $ImageSearch_Failure Then
	   Die("ContextMenu_LaunchDrones not found");
	EndIf
 
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	Sleep( RandomizeIt(200,50) )
	
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func DronesEngage()
	WinActivate ( "EVE" )   
	; Ctrl+Shift+A
	Send("{CTRLDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("{SHIFTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("a")
	Sleep( RandomizeIt(200,50) )
	Send("{SHIFTUP}")
	Sleep( RandomizeIt(200,50) )
	Send("{CTRLUP}")
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ScoopDrones()
	WinActivate ( "EVE" )      
	; Ctrl+Shift+D
	Send("{CTRLDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("{SHIFTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("d")
	Sleep( RandomizeIt(200,50) )
	Send("{SHIFTUP}")
	Sleep( RandomizeIt(200,50) )
	Send("{CTRLUP}")
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func OpenPeopleAndPlaces()
	; Alt+E
	Send("{ALTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("e")
	Sleep( RandomizeIt(200,50) )
	Send("{ALTUP}")
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ClosePeopleAndPlaces()
	; Alt+E
	OpenPeopleAndPlaces()
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func OpenScanner()
	; Alt+d
	Send("{ALTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("d")
	Sleep( RandomizeIt(200,50) )
	Send("{ALTUP}")
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CloseScanner()
	; Alt+d
	OpenScanner()
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------