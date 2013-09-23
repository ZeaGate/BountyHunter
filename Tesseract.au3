; Tesseract related code is based on "Tesseract UDF Library for AutoIt3" from seangriffin

#include-once
#include <File.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>

#Region Config
Global $strTesseractTempPath = "C:\temp\"

#EndRegion

; #FUNCTION# ;===============================================================================
;
; Name...........:	_TesseractScreenCapture()
; Description ...:	Captures text from the screen.
; Syntax.........:	_TesseractScreenCapture($delimiter = "", $cleanup = 1, $scale = 2, $rect_begin_x = 0, $rect_begin_y = 0, $rect_end_x = 0, $rect_end_y = 0, $show_capture = 0)
; Parameters ....:	$delimiter			- Optional: The string that delimits elements in the text.
;											A string of text will be returned if this isn't provided.
;											An array of delimited text will be returned if this is provided.
;											Eg. Use @CRLF to return the items of a listbox as an array.
;					$cleanup			- Optional: Remove invalid text recognised
;											0 = do not remove invalid text
;											1 = remove invalid text (default)
;					$scale				- Optional: The scaling factor of the screenshot prior to text recognition.
;											Increase this number to improve accuracy.
;											The default is 2.
;					$rect_begin_x		- todo.
;					$rect_begin_y		- todo.
;					$rect_end_x			- todo.
;					$rect_end_y			- todo.
;					$show_capture		- Display screenshot and text captures
;											(for debugging purposes).
;											0 = do not display the screenshot taken (default)
;											1 = display the screenshot taken and exit
; Return values .: 	On Success	- Returns an array of text that was captured. 
;                 	On Failure	- Returns an empty array.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	Use the default values for first time use.  If the text recognition accuracy is low,
;					I suggest setting $show_capture to 1 and rerunning.  If the screenshot of the
;					window or control includes borders or erroneous pixels that may interfere with
;					the text recognition process, then use $left_indent, $top_indent, $right_indent and
;					$bottom_indent to adjust the portion of the screen being captured, to
;					exclude these non-textural elements.
;					If text accuracy is still low, increase the $scale parameter.  In general, the higher
;					the scale the clearer the font and the more accurate the text recognition.
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _TesseractScreenCapture($delimiter = "", $cleanup = 1, $scale = 2, $rect_begin_x = 0, $rect_begin_y = 0, $rect_end_x = 0, $rect_end_y = 0, $show_capture = 0)

	dim $aArray, $final_ocr[1]

	$capture_filename = _TempFile($strTesseractTempPath, "~", ".tif")
	$ocr_filename = StringLeft($capture_filename, StringLen($capture_filename) - 4)
	$ocr_filename_and_ext = $ocr_filename & ".txt"

	CaptureToTIFF($capture_filename, $scale, $rect_begin_x, $rect_begin_y, $rect_end_x, $rect_end_y)
	
	ShellExecuteWait(@ProgramFilesDir & "\Tesseract-OCR\tesseract.exe", $capture_filename & " " & $ocr_filename)

	; If no delimter specified, then return a string
	if StringCompare($delimiter, "") = 0 Then
		
		$final_ocr = FileRead($ocr_filename_and_ext)
	Else
	
		_FileReadToArray($ocr_filename_and_ext, $aArray)
		_ArrayDelete($aArray, 0)

		; Append the recognised text to a final array
		_ArrayConcatenate($final_ocr, $aArray)
	EndIf

	; If the captures are to be displayed
	if $show_capture = 1 Then
	
		DebugShowImageFromFile($capture_filename );

		; if IsArray($final_ocr) Then
		; 
		; 	_ArrayDisplay($aArray, "Tesseract Text Capture")
		; Else
		; 	
		; 	MsgBox(0, "Tesseract Text Capture", $final_ocr)
		; EndIf

	EndIf

	FileDelete($ocr_filename & ".*")
#cs
	; Cleanup
	if IsArray($final_ocr) And $cleanup = 1 Then

		; Cleanup the items
		for $final_ocr_num = 1 to (UBound($final_ocr)-1)

			; Remove erroneous characters
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], ".", "")
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], "'", "")
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], ",", "")
			$final_ocr[$final_ocr_num] = StringStripWS($final_ocr[$final_ocr_num], 3)
		Next

		; Remove duplicate and blank items
		for $each in $final_ocr
		
			$found_item = _ArrayFindAll($final_ocr, $each)
			
			; Remove blank items
			if IsArray($found_item) Then
				if StringCompare($final_ocr[$found_item[0]], "") = 0 Then
					
					_ArrayDelete($final_ocr, $found_item[0])
				EndIf
			EndIf

			; Remove duplicate items
			for $found_item_num = 2 to UBound($found_item)
				
				_ArrayDelete($final_ocr, $found_item[$found_item_num-1])
			Next
		Next
	EndIf
#ce
	Return $final_ocr
 EndFunc
 
 ; #FUNCTION# ;===============================================================================
;
; Name...........:	CaptureToTIFF()
; Description ...:	Captures an image of the screen and saves it to a TIFF file.
; Syntax.........:	CaptureToTIFF($sOutImage = "", $scale = 1, $rect_begin_x = 0, $rect_begin_y = 0, $rect_end_x = 0, $rect_end_y = 0)
; Parameters ....:	$sOutImage		- The filename to store the image in.
;					$scale			- Optional: The scaling factor of the capture.
;					$rect_begin_x		- todo.
;					$rect_begin_y		- todo.
;					$rect_end_x			- todo.
;					$rect_end_y			- todo.
; Return values .: 	None
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
Func CaptureToTIFF($sOutImage = "", $scale = 1, $rect_begin_x = 0, $rect_begin_y = 0, $rect_end_x = 0, $rect_end_y = 0)
    
	Local $giTIFColorDepth = 24
	Local $giTIFCompression = $GDIP_EVTCOMPRESSIONNONE
	
	Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
	
	
	$hBitmapCapture = _ScreenCapture_Capture("", $rect_begin_x, $rect_begin_y, $rect_end_x, $rect_end_y, False)
	
	; let's scale
	_GDIPlus_Startup ()
	
	$hImageCapture = _GDIPlus_BitmapCreateFromHBITMAP ($hBitmapCapture)
	
	;DebugShowImage($hImageCapture)

    $width = $rect_end_x - $rect_begin_x;
	$height = $rect_end_y - $rect_begin_y;

	$hWnd = _WinAPI_GetDesktopWindow()
    $hDC = _WinAPI_GetDC($hWnd)	
	
    $hBitmapScaled = _WinAPI_CreateCompatibleBitmap($hDC, $width * $scale, $height * $scale)
	
	_WinAPI_ReleaseDC($hWnd, $hDC)
	
    $hImageScaled = _GDIPlus_BitmapCreateFromHBITMAP ($hBitmapScaled)
	
	;DebugShowImage($hImageScaled)
	
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImageScaled)
    _GDIPLus_GraphicsDrawImageRect($hGraphic, $hImageCapture, 0, 0, $width * $scale, $height * $scale)
	
	DebugShowImage($hImageScaled)
	
	; Set TIFF parameters
	$tParams = _GDIPlus_ParamInit(2)
	$tData = DllStructCreate("int ColorDepth;int Compression")
	DllStructSetData($tData, "ColorDepth", $giTIFColorDepth)
	DllStructSetData($tData, "Compression", $giTIFCompression)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth"))
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
	If IsDllStruct($tParams) Then $pParams = DllStructGetPtr($tParams)

	; Save TIFF and cleanup
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)
	_GDIPlus_ImageSaveToFileEx($hImageScaled, $sOutImage, $CLSID, $pParams)
    _GDIPlus_ImageDispose($hImageScaled)
    _GDIPlus_ImageDispose($hImageCapture)
    _GDIPlus_GraphicsDispose ($hGraphic)
    _WinAPI_DeleteObject($hBitmapScaled)
	_WinAPI_DeleteObject($hBitmapCapture)
    _GDIPlus_Shutdown()
	
EndFunc

Func DebugShowImageFromFile($filename)
    RunWait( "rundll32.exe ""c:\Program Files\Windows Photo Viewer\PhotoViewer.dll"" ImageView_Fullscreen " & $filename );
EndFunc
 
Func DebugShowImage($hImage)
    ; note: GDIPlus has to be preinitialized
    Local $filename = $strTesseractTempPath & "DebugShowImage.tif"
    _GDIPlus_ImageSaveToFile($hImage, $filename)
	DebugShowImageFromFile($filename)
EndFunc	