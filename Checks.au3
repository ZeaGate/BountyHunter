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
	Local $res = _ImagesSearch($minuses, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
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
	Local $res = _ImagesSearch($ships, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
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
	
	; prepare array with NPC ships images
	Local $npc[13] ; size + munber of images
	$npc[0] = 12 ; number of images
	$npc[1] = "Images\Overview_BigNpc.bmp"
	$npc[2] = "Images\Overview_MediumNpc.bmp"
	$npc[3] = "Images\Overview_SmallNpc.bmp"
	$npc[4] = "Images\Overview_BigNpcTargeted.bmp"
	$npc[5] = "Images\Overview_MediumNpcTargeted.bmp"
	$npc[6] = "Images\Overview_SmallNpcTargeted.bmp"
	$npc[7] = "Images\Overview_BigNpcTargetedSelected.bmp"
	$npc[8] = "Images\Overview_MediumNpcTargetedSelected.bmp"
	$npc[9] = "Images\Overview_SmallNpcTargetedSelected.bmp"
	$npc[10] = "Images\Overview_BigNpcSelected.bmp"
	$npc[11] = "Images\Overview_MediumNpcSelected.bmp"
	$npc[12] = "Images\Overview_SmallNpcSelected.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _WaitForImagesSearch($npc, 5, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

Func CheckIsAnyTargetedNpcInOverview()
	Local $x, $y
	
	; prepare array with NPC ships images
	Local $npc[7] ; size + munber of images
	$npc[0] = 6 ; number of images
	$npc[1] = "Images\Overview_BigNpcTargeted.bmp"
	$npc[2] = "Images\Overview_MediumNpcTargeted.bmp"
	$npc[3] = "Images\Overview_SmallNpcTargeted.bmp"
	$npc[4] = "Images\Overview_BigNpcTargetedSelected.bmp"
	$npc[5] = "Images\Overview_MediumNpcTargetedSelected.bmp"
	$npc[6] = "Images\Overview_SmallNpcTargetedSelected.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

Func CheckIsSpecificNpcInOverview($targetTemplate)
	Local $x, $y
	
	; prepare array with NPC ships images
	Local $npc[3] ; size + munber of images
	$npc[0] = 2 ; number of images
	$npc[1] = "Images\Overview_" & $targetTemplate & "Npc.bmp"
	$npc[2] = "Images\Overview_" & $targetTemplate & "NpcSelected.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
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
	Local $res = _ImageSearch("Images\Overview_SmallNpc.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
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

Func CheckIsActiveEngagement()
	Local $x, $y
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImageSearch("Images\EngagedBy_Drones.bmp", $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------