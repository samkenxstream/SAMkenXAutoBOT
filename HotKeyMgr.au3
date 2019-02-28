#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


Local const $Screen_Shot_path = @MyDocumentsDir & "\pes2019\screenshot\"

#include "IncludeCommon.au3"


if @ScriptName == "HotKeyMgr.au3" then
	_PS4_HotKey_Init()
    While True
		Sleep(500)
    WEnd
endif


Func _PS4_HotKey_Init()
	_log4a_Info("_PS4_HotKey_Init")
	DirCreate($Screen_Shot_path)
	HotKeySet("!p", "onScreenCapture") 	; ctrl+1
	HotKeySet("!w", "PrintWindowSize") 	; ctrl+2
	HotKeySet("!e", "SetWindowPos") 	; ctrl+3
	HotKeySet("!q", "QuitScript") 	    ; ctrl+4
EndFunc


Func PrintWindowSize(); alt+k
    SetFuocusWindow()
	Local $aPos = WinGetPos($g_RPLAY_WIN_TITLE)
	_log4a_Info("screen_width="&@DeskTopWidth&",screen_hight="&@DeskTopHeight)
	_log4a_Info("win pos:x="&$aPos[0]&",y="&$aPos[1]&",w="&$aPos[2]&",h="&$aPos[3])
	Local $aClientSize = WinGetClientSize($g_RPLAY_WIN_TITLE)
    _log4a_Info("client size:w="&$aClientSize[0]&",h="&$aClientSize[1])
    Local $mousePos = MouseGetPos()
    _log4a_Info("Mouse pos:x="&$mousePos[0]&",y="&$mousePos[1])
    Local $iColor = PixelGetColor($mousePos[0],$mousePos[1])
    _log4a_Info("Current color is "&Hex($iColor, 6))

EndFunc

Func onScreenCapture()
	ScreenCapture("bmp")
EndFunc

Func ScreenCapture($pic_suffix = "jpg")
	_log4a_Info("ScreenCapture")
    SetFuocusWindow()
    WinActivate($g_RPLAY_WIN_TITLE)
    $hwnd = WinWaitActive($g_RPLAY_WIN_TITLE,"",120)
	Local $hBitmap = _ScreenCapture_CaptureWnd("", $hwnd)
	Local $_suffix = $pic_suffix
    Local $saved_screen_path = $Screen_Shot_path&"image_"&@MON&"_"&@MDAY&"_"&@HOUR&"_"&@MIN&"_"&@SEC&"."&$_suffix
	_ScreenCapture_SaveImage($saved_screen_path,$hBitmap)
    return $saved_screen_path
EndFunc

Func SetWindowPos()
    _log4a_Info("SetWindowPos")
    SetFuocusWindow()
	WinMove($g_RPLAY_WIN_TITLE,"",$g_WindowPosX,$g_WindowPosY,$g_WindowWidth,$g_WindowHight)
EndFunc



Func QuitScript()
	exit 0
EndFunc