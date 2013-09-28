#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Periodical Checks routines
;
;------------------------------------------------------------------------------

#include <Globals.au3>

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsMinusInLocal()
	Local $x, $y
	
	; prepare array with "reds" images
	Local $minuses[5] ; size + munber of images
	$minuses[0] = 4 ; number of images
	$minuses[1] = "Images\ColorTag_MinusRed.bmp"
	$minuses[2] = "Images\ColorTag_MinusYellow.bmp"
	$minuses[3] = "Images\ColorTag_Neut.bmp"
	$minuses[4] = "Images\ColorTag_NoStand.bmp"
	
	ActivateEveWindow()
	
	; locate anomaly
	Local $res = _ImagesSearch($minuses, $ImageSearch_ResultPosition_Center, $x, $y, 16 )
	If $res > $ImageSearch_Failure Then
		;Debug("Minus in local")
		Return True;
	EndIf
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsAnyPilotInOverview()
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsAnyNpcInOverview()
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsDroneTakesDamage()
	Return False
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------