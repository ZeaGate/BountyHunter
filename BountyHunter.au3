

#include-once
#include <Tesseract.au3>
#include <ImageSearch.au3>
#include <GUIConstantsEx.au3>
#include <PersonalConfiguration.au3>
#include <Array.au3>


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

; GUI
GUICreate("Bounty Hunter", 300, 400)
$btnStart = GUICtrlCreateButton("Start EVE Online Client", 5, 5, 290, 20)
$btnDockToStation = GUICtrlCreateButton("Dock to the Station", 5, 35, 290, 20)
$btnWarpToSafePos = GUICtrlCreateButton("Warp to the Safe POS", 5, 65, 290, 20)
$btnUndockFromStation = GUICtrlCreateButton("Undock from the station", 5, 95, 290, 20)
$btnAcquireNewTask = GUICtrlCreateButton("Acquire new task", 5, 125, 290, 20)
$btnEnableTank = GUICtrlCreateButton("Enable Tank", 5, 155, 290, 20)
$btnExpandDroneWindow = GUICtrlCreateButton("Expand Drone Window", 5, 185, 290, 20)
$btnLaunchSentryEm = GUICtrlCreateButton("Launch Sentry EM", 5, 215, 290, 20)
$btnDronesEngage = GUICtrlCreateButton("Drones Engage", 5, 245, 290, 20)
$btnScoopDrones = GUICtrlCreateButton("Scoop Drones", 5, 275, 290, 20)

; GUI MESSAGE LOOP
While 1
	GUISetState(@SW_SHOW)
	Switch GUIGetMsg()
	   Case $GUI_EVENT_CLOSE
		  Exit
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
    EndSwitch
	
	; Checks place holder
	
WEnd

Func StartEveOnline()
    ApplyPersonalSettings()
	Run($strEveLauncherPath)
	
	Local $x, $y
	Local Const $WaitInSeconds = 60
	
	; wait for Launcher window
	local $res = _WaitForImageSearch("Images\Launcher_LoginButton.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Login Failed: Launcher window not found");
    EndIf
	
	Sleep(RandomizeIt(1000, 300))
	Send($strPassword)
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,15), 1, RandomizeIt(20,5) )
	
	; wait for Select Character window
	$res = _WaitForImageSearch("Images\SelectCharacter_EnterGame.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Login Failed: Select Character window not found");
    EndIf
	
	Sleep(RandomizeIt(1000, 300))
	MouseClick("left", RandomizeIt($x,10), RandomizeIt($y,10), 1, RandomizeIt(20,5) )
	
EndFunc
 
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

Func UndockFromStation()
    WinActivate ( "EVE" )
    ; Alt+U
	Send("{ALTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("u")
	Sleep( RandomizeIt(200,50) )
	Send("{ALTUP}")
EndFunc

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

Func AcquireNewTask()
#cs
  - Select Anomaly
  - Warp to Anomaly at 70km
  - Close Anomaly Info Window (by Pressing Enter)
  - Save info about anomaly, to make sure to not consider it again 
    OR
    Ignore result, so anomaly would not be considered again
  - Close scaner    
#ce

    WinActivate ( "EVE" )

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
	Sleep( RandomizeIt(2000,500) )
	Send("{ENTER}")
	
	; ignore that anomaly
	Sleep( RandomizeIt(2000,500) )
	; move mouse cursor to found anomaly and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($anomaly_x,20), RandomizeIt($anomaly_y,2), 1, RandomizeIt(20,5) )
	
	$res = _WaitForImageSearch("Images\ContextMenu_IgnoreResult.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("""Ignore Result"" menu entry not found");
    EndIf
	
	MouseClick("left", RandomizeIt($x,5), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	
	Sleep( RandomizeIt(3000,1000) )
	CloseScanner()
	
EndFunc   

Func EnableTank()
    WinActivate ( "EVE" )   
    ; Ctrl+F1, Ctrl+F2, Ctrl+F3, Ctrl+F4
	Send("{CTRLDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("{F1}")
	Sleep( RandomizeIt(200,50) )
	Send("{F2}")
	Sleep( RandomizeIt(200,50) )
	Send("{F3}")
	Sleep( RandomizeIt(200,50) )
	Send("{F4}")
	Sleep( RandomizeIt(200,50) )
	Send("{CTRLUP}")
EndFunc

Func ExpandDroneWindow()
   
    WinActivate ( "EVE" )
	
	Local $x, $y
	Local Const $WaitInSeconds = 5
	
	
	; locate 
	Local $res = _WaitForImageSearch("Images\Drones_DronesInBayClosed.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Drones_DronesInBayClosed not found");
    EndIf
 
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
    Sleep( RandomizeIt(200,50) )
	
	
	; locate 
	$res = _WaitForImageSearch("Images\Drones_DronesInLocalSpaceClosed.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, 1 ) ; note tolerance here
	If $res = $ImageSearch_Failure Then
	   Die("Drones_DronesInLocalSpaceClosed not found");
    EndIf
 
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	Sleep( RandomizeIt(200,50) )

    
	; locate 
	$res = _WaitForImageSearch("Images\Drones_SentryEmClosed.bmp", $WaitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $ImageSearch_Tolerance_Zero )
	If $res = $ImageSearch_Failure Then
	   Die("Drones_SentryEmClosed not found");
    EndIf
 
	MouseClick("left", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )
	Sleep( RandomizeIt(200,50) )
	
EndFunc

Func LaunchSentryEm()
   
    WinActivate ( "EVE" )

	Die("Not implemented");
	
EndFunc

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


Func OpenPeopleAndPlaces()
    ; Alt+E
	Send("{ALTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("e")
	Sleep( RandomizeIt(200,50) )
	Send("{ALTUP}")
EndFunc

Func ClosePeopleAndPlaces()
    ; Alt+E
	OpenPeopleAndPlaces()
EndFunc

Func OpenScanner()
    ; Alt+d
	Send("{ALTDOWN}")
	Sleep( RandomizeIt(200,50) )
	Send("d")
	Sleep( RandomizeIt(200,50) )
	Send("{ALTUP}")
EndFunc

Func CloseScanner()
    ; Alt+d
	OpenScanner()
EndFunc
 


Func RandomizeIt($valueToRandomize, $delta)
    Local $r = Random(0, $delta * 2 - 1, 1) - $delta
	Debug("RandomizeIt(" & $valueToRandomize & ", " & $delta & "): " & $r)
	$valueToRandomize += $r
	Return $valueToRandomize
EndFunc
 
; Utils
; ToDo: move utility routines to separate file
Func Die($message = "")
	ConsoleWrite($message & @CRLF)
	Exit
EndFunc

Func Debug($message = "")
	ConsoleWrite($message & @CRLF)
EndFunc








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

; MouseMove
; Random


