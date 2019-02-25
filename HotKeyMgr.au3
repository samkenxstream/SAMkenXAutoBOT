#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "IncludeCommon.au3"

Local const $Screen_Shot_path = @MyDocumentsDir & "\pes2019\screenshot\"


if @ScriptName == "HotKeyMgr.au3" then
    _log4a_SetEnable()
    _PS4_HotKey_Init()
    While True
		Sleep(500)
    WEnd
endif


Func _PS4_HotKey_Init()
	DirCreate($Screen_Shot_path)
	HotKeySet("!p", "ScreenCapture") ; alt+p
	HotKeySet("!k", "PrintWindowSize") ; alt+k
	HotKeySet("!l", "SetWindowPos") ; alt+l
EndFunc


Func PrintWindowSize(); alt+k
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

Func ScreenCapture()
	_log4a_Info("ScreenCapture")
	WinActivate($g_RPLAY_WIN_TITLE)
    $hwnd = WinWaitActive($g_RPLAY_WIN_TITLE,"",120)
	Local $hBitmap = _ScreenCapture_CaptureWnd("", $hwnd)
	_ScreenCapture_SaveImage($Screen_Shot_path&"image_"&@HOUR&"_"&@MIN&"_"&@SEC&".bmp",$hBitmap)
EndFunc

Func SetWindowPos()
    _log4a_Info("SetWindowPos")
	WinMove($g_RPLAY_WIN_TITLE,"",$g_WindowPosX,$g_WindowPosY,$g_WindowWidth,$g_WindowHight)
EndFunc