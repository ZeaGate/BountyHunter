

#include-once
#include <Tesseract.au3>
#include <ImageSearch.au3>


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
#EndRegion

WinActivate ( "EVE" )

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


