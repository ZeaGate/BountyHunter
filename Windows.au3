#include-once
;------------------------------------------------------------------------------
;
; Bounty Hunter Project
; Eve Window routines
;
;------------------------------------------------------------------------------
Global Const $cWindowCommandOpen = 0
Global Const $cWindowCommandClose = 1

Func WindowPeopleAndPlaces($command)
	Debug("WindowPeopleAndPlaces(" & $command & ")")
	
	Local Const $headerImage = "Images\WindowHeader_PeopleAndPlaces.bmp"
	Local Const $checkIfOpenDelay = 1 		; in seconds
	Local Const $waitForOpeningDelay = 15	; in seconds
	
	; make sure (in caller routine) that cursor will not interfere
	
	; Is window already open?
	Local $bAlreadyOpen = WaitForImage($headerImage, $checkIfOpenDelay)
	
	; send shortcut for Open
	If ($command = $cWindowCommandOpen AND $bAlreadyOpen = False) OR ($command = $cWindowCommandClose AND $bAlreadyOpen = True) Then
		; Alt+E
		Send("{ALTDOWN}")
		RndSleep(500,50)
		Send("e")
		RndSleep(500,50)
		Send("{ALTUP}")
		RndSleep(500,50)
	EndIf
	
	; wait for window
	Local $result = False
	If $command = $cWindowCommandOpen Then
		$result = WaitForImage($headerImage, $waitForOpeningDelay)
	Else
		$result = WaitForImageGone($headerImage, $waitForOpeningDelay)
	EndIf
		
	If $result = False Then
		Die("WindowPeopleAndPlaces(" & $command & ") failed")
	EndIf
	 
	Sleep(1000) 
EndFunc

Func WindowScanner($command)
	Debug("WindowScanner(" & $command & ")")
	
	Local Const $headerImage = "Images\WindowHeader_Scanner.bmp"
	Local Const $checkIfOpenDelay = 1 		; in seconds
	Local Const $waitForOpeningDelay = 5	; in seconds
	
	; Is window already open?
	Local $bAlreadyOpen = WaitForImage($headerImage, $checkIfOpenDelay)
	
	; send shortcut for Open
	If ($command = $cWindowCommandOpen AND $bAlreadyOpen = False) OR ($command = $cWindowCommandClose AND $bAlreadyOpen = True) Then
		; Alt+D
		Send("{ALTDOWN}")
		RndSleep(500,50)
		Send("d")
		RndSleep(500,50)
		Send("{ALTUP}")
		RndSleep(500,50)
	EndIf
	
	; wait for window
	Local $result = False
	If $command = $cWindowCommandOpen Then
		$result = WaitForImage($headerImage, $waitForOpeningDelay)
	Else
		$result = WaitForImageGone($headerImage, $waitForOpeningDelay)
	EndIf
		
	If $result = False Then
		Die("WindowScanner(" & $command & ") failed")
	EndIf
EndFunc

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------