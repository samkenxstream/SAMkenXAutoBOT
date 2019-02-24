#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=c:\users\simon\downloads\koda_1.7.3.0\forms\image_search_checker.kxf
$Form1_1 = GUICreate("Image Search Checker", 484, 187, 192, 124)
$Input1 = GUICtrlCreateInput("Input1", 32, 40, 289, 21)
$Button1 = GUICtrlCreateButton("image", 336, 40, 75, 25)
$Input2 = GUICtrlCreateInput("Input2", 32, 72, 289, 21)
$Button2 = GUICtrlCreateButton("sub image", 336, 72, 73, 25)
$Button3 = GUICtrlCreateButton("compare", 120, 128, 195, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#include "IncludeCommon.au3"

GUICtrlSetOnEvent($Button1, "onLoadImage")
GUICtrlSetOnEvent($Button2, "onLoadSubImage")


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


Func onLoadImage()
	_log4a_Info("onLoadImage")
	Local $sFileOpenDialog = FileOpenDialog("Select Image", @WindowsDir & "\", "Images (*.jpg;*.bmp",BitOR($FD_FILEMUSTEXIST, $FD_MULTISELECT))
	If @error Then
        ; Display the error message.
        MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")

        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)
    Else
        ; Change the working directory (@WorkingDir) back to the location of the script directory as FileOpenDialog sets it to the last accessed folder.
        FileChangeDir(@ScriptDir)

        ; Replace instances of "|" with @CRLF in the string returned by FileOpenDialog.
        $sFileOpenDialog = StringReplace($sFileOpenDialog, "|", @CRLF)

        ; Display the list of selected files.
        MsgBox($MB_SYSTEMMODAL, "", "You chose the following files:" & @CRLF & $sFileOpenDialog)
    EndIf
EndFunc

Func onLoadSubImage()
	_log4a_Info("onLoadSubImage")
EndFunc


