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
	
	; locate
	Local $res = _ImagesSearch($minuses, $ImageSearch_ResultPosition_Center, $x, $y, 16 )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsAnyPilotInOverview()
	Local $x, $y
	
	; prepare array with player ships images
	Local $ships[5] ; size + munber of images
	$ships[0] = 4 ; number of images
	$ships[1] = "Images\Overview_BigPlayer.bmp"
	$ships[2] = "Images\Overview_MediumPlayer.bmp"
	$ships[3] = "Images\Overview_SmallPlayer.bmp"
	$ships[4] = "Images\Overview_Capsule.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($ships, $ImageSearch_ResultPosition_Center, $x, $y, 16 )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsAnyNpcInOverview()
	Local $x, $y
	
	; prepare array with player ships images
	Local $npc[4] ; size + munber of images
	$npc[0] = 3 ; number of images
	$npc[1] = "Images\Overview_BigNpc.bmp"
	$npc[2] = "Images\Overview_MediumNpc.bmp"
	$npc[3] = "Images\Overview_SmallNpc.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, 16 )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CheckIsSmallNpcInOverview()
	Local $x, $y
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImageSearch("Images\Overview_SmallNpc.bmp", $ImageSearch_ResultPosition_Center, $x, $y, 16 )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
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