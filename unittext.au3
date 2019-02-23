#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "log4a.au3"
#include "SmtpMailer.au3"
#include "PS4_KeyAPI.au3"
#include <MsgBoxConstants.au3>


;_log4a_SetEnable()
;checkInvalidWindow()
;send_email()
OpenFileDialog()






Func OpenFileDialog()
    ; Create a constant variable in Local scope of the message to display in FileSelectFolder.
    Local Const $sMessage = "Select a folder"

    ; Display an open dialog to select a file.
    Local $sFileSelectFolder = FileSelectFolder($sMessage, "")
    If @error Then
        ; Display the error message.
        MsgBox($MB_SYSTEMMODAL, "", "No folder was selected.")
    Else
        ; Display the selected folder.
        MsgBox($MB_SYSTEMMODAL, "", "You chose the following folder:" & @CRLF & $sFileSelectFolder)
    EndIf
EndFunc   ;==>Example