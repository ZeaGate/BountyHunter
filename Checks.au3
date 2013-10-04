#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Periodical Checks routines
; 
; Code Agreements:
; Routine name starts from C (i.e. Check)
; Check should start with ActivateEveWindow() call
;------------------------------------------------------------------------------

#include <Globals.au3>

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
; Zea: done
Func CIsEveClientRunning()
	If WinExists("EVE") Then
		Return True
	Else
		Return False
	EndIf
EndFunc

; Zea: done
Func CIsStation()
	ActivateEveWindow()
	Return IsImageOnDesktop("Images\WindowHeader_StationServices.bmp")
EndFunc

; Zea: done
Func CIsSpace()
	ActivateEveWindow()
	Return IsImageOnDesktop("Images\WindowHeader_Overview.bmp")
EndFunc

Func CIsOnPos()
	; Note: the Check is based on the idea that close to the SafePos there will be no "Warp to location" context menu command
	
	ActivateEveWindow()
	
	WindowPeopleAndPlaces($cWindowCommandOpen)

	; locate Station Bookmark
	Local $x, $y
	If WaitForImageXY("Images\PeopleAndPlaces_SafePos.bmp", 5, $x, $y) = False Then
		Die("SafePos bookmark not found");
	EndIf
 
	; move mouse cursor to that bookmark and make a right mouse click for context menu
	MouseClick("right", RandomizeIt($x,20), RandomizeIt($y,2), 1, RandomizeIt(20,5) )

	; locate "Warp to location" in context menu
	Local $ret = (WaitForImage("Images\ContextMenu_WarpToLocation.bmp", 5) = False)
	
	; clean up
	ClickOnLocalHeader() ; get rid of open context menu
	WindowPeopleAndPlaces($cWindowCommandClose)
	
	Return $ret;
EndFunc

;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
Func CIsLocalRed() ; CheckIsMinusInLocal()
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
	Local $npc[19] ; size + munber of images
	$npc[0] = 18 ; number of images
	$npc[1] = "Images\Overview_NpcBigSelectedFalseTargetedActive.bmp"
	$npc[2] = "Images\Overview_NpcBigSelectedFalseTargetedNone.bmp"
	$npc[3] = "Images\Overview_NpcBigSelectedFalseTargetedPassive.bmp"
	$npc[4] = "Images\Overview_NpcBigSelectedTrueTargetedActive.bmp"
	$npc[5] = "Images\Overview_NpcBigSelectedTrueTargetedNone.bmp"
	$npc[6] = "Images\Overview_NpcBigSelectedTrueTargetedPassive.bmp"
	$npc[7] = "Images\Overview_NpcMediumSelectedFalseTargetedActive.bmp"
	$npc[8] = "Images\Overview_NpcMediumSelectedFalseTargetedNone.bmp"
	$npc[9] = "Images\Overview_NpcMediumSelectedFalseTargetedPassive.bmp"
	$npc[10] = "Images\Overview_NpcMediumSelectedTrueTargetedActive.bmp"
	$npc[11] = "Images\Overview_NpcMediumSelectedTrueTargetedNone.bmp"
	$npc[12] = "Images\Overview_NpcMediumSelectedTrueTargetedPassive.bmp"
	$npc[13] = "Images\Overview_NpcSmallSelectedFalseTargetedActive.bmp"
	$npc[14] = "Images\Overview_NpcSmallSelectedFalseTargetedNone.bmp"
	$npc[15] = "Images\Overview_NpcSmallSelectedFalseTargetedPassive.bmp"
	$npc[16] = "Images\Overview_NpcSmallSelectedTrueTargetedActive.bmp"
	$npc[17] = "Images\Overview_NpcSmallSelectedTrueTargetedNone.bmp"
	$npc[18] = "Images\Overview_NpcSmallSelectedTrueTargetedPassive.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _WaitForImagesSearch($npc, 1, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		;Debug("CheckIsAnyNpcInOverview(): " & $npc[$res] & " was found!")
		Return True
	EndIf
	
	Return False
EndFunc

Func CheckIsAnyTargetedNpcInOverview()
	Local $x, $y
	
	; prepare array with NPC ships images
	Local $npc[13] ; size + munber of images
	$npc[0] = 12 ; number of images
	$npc[1] = "Images\Overview_NpcBigSelectedFalseTargetedActive.bmp"
	$npc[2] = "Images\Overview_NpcBigSelectedFalseTargetedPassive.bmp"
	$npc[3] = "Images\Overview_NpcBigSelectedTrueTargetedActive.bmp"
	$npc[4] = "Images\Overview_NpcBigSelectedTrueTargetedPassive.bmp"
	$npc[5] = "Images\Overview_NpcMediumSelectedFalseTargetedActive.bmp"
	$npc[6] = "Images\Overview_NpcMediumSelectedFalseTargetedPassive.bmp"
	$npc[7] = "Images\Overview_NpcMediumSelectedTrueTargetedActive.bmp"
	$npc[8] = "Images\Overview_NpcMediumSelectedTrueTargetedPassive.bmp"
	$npc[9] = "Images\Overview_NpcSmallSelectedFalseTargetedActive.bmp"
	$npc[10] = "Images\Overview_NpcSmallSelectedFalseTargetedPassive.bmp"
	$npc[11] = "Images\Overview_NpcSmallSelectedTrueTargetedActive.bmp"
	$npc[12] = "Images\Overview_NpcSmallSelectedTrueTargetedPassive.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Return True
	EndIf
	
	Return False
EndFunc
 
Func CheckIsSpecificTargetedNpcInOverview($targetTemplate)
	Local $x, $y
	return CheckIsSpecificTargetedNpcInOverview_XY($targetTemplate, $x, $y)
EndFunc	

Func CheckIsSpecificTargetedNpcInOverview_XY($targetTemplate, ByRef $x, ByRef $y)
	; prepare array with NPC ships images
	Local $npc[5] ; size + munber of images
	$npc[0] = 4 ; number of images
	$npc[1] = "Images\Overview_Npc" & $targetTemplate & "SelectedFalseTargetedActive.bmp"
	$npc[2] = "Images\Overview_Npc" & $targetTemplate & "SelectedFalseTargetedPassive.bmp"
	$npc[3] = "Images\Overview_Npc" & $targetTemplate & "SelectedTrueTargetedActive.bmp"
	$npc[4] = "Images\Overview_Npc" & $targetTemplate & "SelectedTrueTargetedPassive.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Debug("CheckIsSpecificTargetedNpcInOverview(): " & $npc[$res] & " was found!")
		Return True
	EndIf
	
	Debug("CheckIsSpecificTargetedNpcInOverview(): " & $targetTemplate & " was NOT found!")
	Return False
EndFunc

Func CheckIsSpecificNotTargetedNpcInOverview($targetTemplate)
	Local $x, $y
	Return CheckIsSpecificNotTargetedNpcInOverview_XY($targetTemplate, $x, $y)
EndFunc

Func CheckIsSpecificNotTargetedNpcInOverview_XY($targetTemplate, ByRef $x, ByRef $y)
	; prepare array with NPC ships images
	Local $npc[3] ; size + munber of images
	$npc[0] = 2 ; number of images
	$npc[1] = "Images\Overview_Npc" & $targetTemplate & "SelectedFalseTargetedNone.bmp"
	$npc[2] = "Images\Overview_Npc" & $targetTemplate & "SelectedTrueTargetedNone.bmp"
	
	ActivateEveWindow()
	
	; locate
	Local $res = _ImagesSearch($npc, $ImageSearch_ResultPosition_Center, $x, $y, $cISTolerance )
	If $res > $ImageSearch_Failure Then
		Debug("CheckIsSpecificNotTargetedNpcInOverview(): " & $npc[$res] & " was found!")
		Return True
	EndIf
	
	Debug("CheckIsSpecificNotTargetedNpcInOverview(): " & $targetTemplate & " was NOT found!")
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