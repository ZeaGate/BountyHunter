#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Utility routines
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

Func Debug($message = "")
	ConsoleWrite($message & @CRLF)
	ToolTip($message, @DesktopWidth/2, @DesktopHeight-20)
EndFunc
 
Func RandomizeIt($valueToRandomize, $delta)
    Local $r = Random(0, $delta * 2 - 1, 1) - $delta
	;Debug("RandomizeIt(" & $valueToRandomize & ", " & $delta & "): " & $r)
	$valueToRandomize += $r
	Return $valueToRandomize
EndFunc 

; Zea: done
Func RndSleep($delay, $delta)
	Sleep(RandomizeIt($delay, $delta))
EndFunc

Func RndMouseSpeed()
	Return RandomizeIt($cMouseSpeedBase, $cMouseSpeedDelta)
EndFunc

; Zea: done
Func ActivateEveWindow()
	If NOT WinActive("EVE") Then
		Sleep(5000) ; give me some time, please
		WinActivate("EVE")
	EndIf
EndFunc		

Func MoveMouseToTheParkingSpot()
	MouseMove(RandomizeIt(2,2), RandomizeIt(2,2), RndMouseSpeed() ) 
EndFunc

Func MoveMouseToLocalHeader()
	Local $x, $y
	
	Local $res = _ImageSearch("Images\WindowHeader_Local.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseMove(RandomizeIt($x,2), RandomizeIt($y,2), RndMouseSpeed() ) 
	Else
		Die("MoveMouseToLocalHeader(): " &  "Images\WindowHeader_Local.bmp" & " not found")
	EndIf
	
	Return False
EndFunc

Func ClickOnLocalHeader()
	Local $x, $y
	
	Local $res = _ImageSearch("Images\WindowHeader_Local.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Success Then
		MouseClick("left", RandomizeIt($x,2), RandomizeIt($y,2), 1, RndMouseSpeed() ) 
	Else
		Die("ClickOnLocalHeader(): " &  "Images\WindowHeader_Local.bmp" & " not found")
	EndIf
	
	Return False
EndFunc

; Zea: done
Func IsImageOnDesktop($image)
	Local $x, $y
	Return IsImageOnDesktop_XY($image, $x, $y)
EndFunc

Func IsImageOnDesktop_XY($image, ByRef $x, ByRef $y)
	If $ImageSearch_Success = _ImageSearch($image, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance ) Then
		Return True
	EndIf
	
	Return False
EndFunc

Func IsAnyImageOnDesktop($arrImages)
	Local $x, $y
	Return IsAnyImageOnDesktop_XY($arrImages, $x, $y)
EndFunc

Func IsAnyImageOnDesktop_XY($arrImages, ByRef $x, ByRef $y)
	If _ImagesSearch($arrImages, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance ) > $ImageSearch_Failure Then
		Return True
	Else
		Return False	
	EndIf
EndFunc


;------------------------------------------------------------------------------
; Returns True if $image was found on desktop within $waitInSeconds
;------------------------------------------------------------------------------
; Zea: done
Func WaitForImage($image, $waitInSeconds)
	Local $x, $y
	Return WaitForImage_XY($image, $waitInSeconds, $x, $y)
EndFunc

; Zea: done
Func WaitForImage_XY($image, $waitInSeconds, ByRef $x, ByRef $y)
	Local $res = _WaitForImageSearch($image, $waitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res = $ImageSearch_Failure Then
		Return False
	Else
		Return True
	EndIf
EndFunc


Func WaitForImages($images, $waitInSeconds)
	Local $x, $y
	Return WaitForImages_XY($images, $waitInSeconds, $x, $y)
EndFunc

; Zea: done
Func WaitForImages_XY($images, $waitInSeconds, ByRef $x, ByRef $y)
	Local $res = _WaitForImagesSearch($images, $waitInSeconds, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
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
		$bFound = IsImageOnDesktop($image)
		$diff = TimerDiff($timer)
		
		Debug("WaitForImageGone(): " & $image & " " & $diff & " " & $bFound)
	WEnd
	
	Return NOT $bFound
EndFunc


Func LocateAndClick($image, $lookupWaitDelayInSeconds, $mouseButton, $mouseClickDelay = 0)
	Local $x, $y
	LocateAndClick_XY($image, $lookupWaitDelayInSeconds, $mouseButton, $x, $y, $mouseClickDelay)
EndFunc

Func LocateAndClick_XY($image, $lookupWaitDelayInSeconds, $mouseButton, ByRef $x, ByRef $y, $mouseClickDelay = 0)
	If WaitForImage_XY($image, $lookupWaitDelayInSeconds, $x, $y) = False Then
		Die("LocateAndClick() " & $image & " not found");
	EndIf
	
	If NOT (0 = $mouseClickDelay) Then 
		RndSleep($mouseClickDelay, $mouseClickDelay/10)
	EndIf
	
	MouseClick($mouseButton, RandomizeIt($x,2), RandomizeIt($y,2), 1, RndMouseSpeed() )
EndFunc

Func LocateAnyAndClick($images, $lookupWaitDelayInSeconds, $mouseButton, $mouseClickDelay = 0)
	Local $x, $y
	LocateAnyAndClick_XY($images, $lookupWaitDelayInSeconds, $mouseButton, $x, $y, $mouseClickDelay)
EndFunc

Func LocateAnyAndClick_XY($images, $lookupWaitDelayInSeconds, $mouseButton, ByRef $x, ByRef $y, $mouseClickDelay = 0)
	If WaitForImages_XY($images, $lookupWaitDelayInSeconds, $x, $y) = False Then
		Die("LocateAndClick() " & $images & " not found");
	EndIf
	
	If NOT (0 = $mouseClickDelay) Then 
		RndSleep($mouseClickDelay, $mouseClickDelay/10)
	EndIf
	
	MouseClick($mouseButton, RandomizeIt($x,2), RandomizeIt($y,2), 1, RndMouseSpeed() )
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------