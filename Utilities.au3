#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Utility routines
;
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func Die($message = "")
	Debug($message)
	Beep()
	If WinExists("EVE") = 1 Then
		; ProcessClose("exefile.exe")
	EndIf
	Exit
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func Debug($message = "")
	ConsoleWrite($message & @CRLF)
EndFunc
 
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func RandomizeIt($valueToRandomize, $delta)
    Local $r = Random(0, $delta * 2 - 1, 1) - $delta
	;Debug("RandomizeIt(" & $valueToRandomize & ", " & $delta & "): " & $r)
	$valueToRandomize += $r
	Return $valueToRandomize
EndFunc 

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func RndSleep($delay, $delta)
	Sleep(RandomizeIt($delay, $delta))
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func bIsEveClientRunning()
	If WinExists("EVE") Then
		Return True
	Else
		Return False
	EndIf
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func ActivateEveWindow()
	If NOT WinActive("EVE") Then
		Sleep(5000) ; give me some time, please
		WinActivate("EVE")
	EndIf
EndFunc		

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func MoveMouseToTheParkingSpot()
	MouseMove(0, 0) ; randomize coords?
EndFunc

Func MoveMouseToLocalHeader()
	Local $x, $y
	
	Local $res = _ImageSearch("Images\WindowHeader_Local.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseMove($x, $y, RandomizeIt(20,5) ) ; randomize coords?
	Else
		Die("MoveMouseToLocalHeader(): " &  "Images\WindowHeader_Local.bmp" & " not found")
	EndIf
	
	Return False
EndFunc

Func ClickOnLocalHeader()
	Local $x, $y
	
	Local $res = _ImageSearch("Images\WindowHeader_Local.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseClick("left", $x, $y, 1, RandomizeIt(20,5) ) ; randomize coords?
	Else
		Die("ClickOnLocalHeader(): " &  "Images\WindowHeader_Local.bmp" & " not found")
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func IsImageOnDesktopNow($image)
	Local $x, $y
	
	Local $res = _ImageSearch($image, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		Return True
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
; Returns True if $image was found on desktop within $waitInSeconds
;------------------------------------------------------------------------------
Func WaitForImage($image, $waitInSeconds)
	Local $x, $y
	$res = _WaitForImageSearch($image, $waitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Return False
	Else
		Return True
	EndIf
EndFunc
	
;------------------------------------------------------------------------------
; Returns True if $image not found on desktop within $waitInSeconds
;------------------------------------------------------------------------------
Func WaitForImageGone($image, $waitInSeconds)
	Local $bFound = True
	Local $allowedTime = $waitInSeconds * 1000
	Local $timer = TimerInit()
	Local $diff = TimerDiff($timer)
	
	While $bFound = True AND $diff < $allowedTime
		$bFound = IsImageOnDesktopNow($image)
		$diff = TimerDiff($timer)
		
		Debug("WaitForImageGone(): " & $image & " " & $diff & " " & $bFound)
	WEnd
	
	Return NOT $bFound
EndFunc



;------------------------------------------------------------------------------
;------------------------------------------------------------------------------