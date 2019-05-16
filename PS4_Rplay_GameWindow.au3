#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
Global $g_hwnd_rplay = 0
Global $g_rplay_started = False
Global const $g_WindowPosX = 291
Global const $g_WindowPosY = 141
Global const $g_WindowWidth = 1306
Global const $g_WindowHight = 779


#include "IncludeCommon.au3"

if @ScriptName == "PS4_Rplay_GameWindow.au3" then
	CheckGameExitWindow()
endif



Func _PS4_GameWindow_StartUp()
    if Not WinExists($g_RPLAY_WIN_TITLE) Then
        If ProcessExists($g_RPLAY_EXE) then
            ProcessClose($g_RPLAY_EXE)
            Sleep(2000)
        endif
    endif

    ;如果RPLAY没有打开
    If Not ProcessExists($g_RPLAY_EXE) Then
        ProcessClose($g_PS4Macro_EXE)
        Sleep(1000)
        Run($g_RPLAY_EXE_PATH)
        $hWnd = WinWaitActive($g_RPLAY_WIN_TITLE,$g_RPLAY_BTN_START,120)
        If $hWnd == 0 Then
            _log4a_Info("Open PS4 remote timeout")
            Exit 0
        EndIf
    EndIf

    _log4a_Info("PS4 Game Window Starting")

    AdlibRegister("GameWindowCheck",5*1000)

    If WinExists($g_RPLAY_WIN_TITLE,$g_RPLAY_BTN_START) Then
		$hWnd = WinActivate($g_RPLAY_WIN_TITLE)
        Sleep(1*1000)
        _log4a_Info("Waiting for the start button press")
        ControlClick($hWnd, "",$g_RPLAY_BTN_START)
        Sleep(1*1000)
    endif

    $hCtrl = ControlGetHandle($g_RPLAY_WIN_TITLE, "", $g_RPLAY_GAME_CONTROL_CLASS)
    If Not $hCtrl Then
        AdlibRegister("onViewPanelCheck",1*1000)
        While not $g_rplay_started
            Sleep(1*1000)
        WEnd
        AdlibUnRegister("onViewPanelCheck")
    Endif

    Sleep(10*1000)
    $g_rplay_started = True
    SetFocusWindow()
    $g_hwnd_rplay = WinWaitActive($g_RPLAY_WIN_TITLE,"",120)
    WinMove($g_RPLAY_WIN_TITLE,"",$g_WindowPosX,$g_WindowPosY,$g_WindowWidth,$g_WindowHight)
    _log4a_Info("PS4 Game Window Start compelete,hwnd="&$g_hwnd_rplay)
EndFunc

Func onViewPanelCheck()
	_log4a_Info("onViewPanelCheck");
	If not $g_rplay_started And WinExists($g_RPLAY_WIN_TITLE) Then
		$hCtrl = ControlGetHandle($g_RPLAY_WIN_TITLE, "", $g_RPLAY_GAME_CONTROL_CLASS)
		If $hCtrl Then
			; we got the handle, so the button is there
			; now do whatever you need to do
			_log4a_Info("Find Viewpanel!!!");
			$g_rplay_started = True
		EndIf
	EndIf
EndFunc

Func checkViewPannelExist()
    if not WinExists($g_RPLAY_WIN_TITLE) then
        return
    endif
    $hCtrl = ControlGetHandle($g_RPLAY_WIN_TITLE, "", $g_RPLAY_GAME_CONTROL_CLASS)
    If $hCtrl Then
        return true
    EndIf    
    return false
EndFunc


Func GameWindowCheck()
    Local static $now = _NowCalc()

    If not ProcessExists($g_RPLAY_EXE) Then
		_log4a_Info("Process exited,stop!!!!")
		exit 0
	endif
    CheckInvalidWindow()
    Local $aPos = WinGetPos($g_RPLAY_WIN_TITLE)
    ;_log4a_Info("X-Pos: "&$aPos[0]&"Y-Pos: "&$aPos[1]&"Width: "&$aPos[2]&"Height: "&$aPos[3])
    Local $time_diff = _NowCalc() - $now
    WinMove($g_RPLAY_WIN_TITLE,"",$aPos[0],$aPos[1],$g_WindowWidth,$g_WindowHight)
    if $time_diff > 60 then
        $now = _NowCalc()
        WinActivate($g_RPLAY_WIN_TITLE)
    endif
EndFunc

Func PS4MacroWindowStart()
    If ProcessExists($g_PS4Macro_EXE) Then
        ProcessClose($g_PS4Macro_EXE)
        Sleep(2000)
    endif
    Run($g_PS4Macro_EXE_PATH)
    Sleep(1000)
EndFunc


Func SetFocusWindow()
    if not checkViewPannelExist() then
        _log4a_Info("set focus window, the view pannel not exist")
		Quit()
        return
    endif
    
    WinActivate($g_RPLAY_WIN_TITLE)
    Sleep(200)
    if CheckWinNeedMove() then
        WinMove($g_RPLAY_WIN_TITLE,"",$g_WindowPosX,$g_WindowPosY,$g_WindowWidth,$g_WindowHight)
    endif
    CheckMousePosition()
    CheckInvalidWindow()
	
	if CheckGameExitWindow() then
		$path = ScreenCapture()
        send_email("Game window exited","Game window exited",$g_log_path&";"&$path)
		exit 0
	endif
	
EndFunc

Func GetScreenSnapshot($hwnd = 0)
    Local $hBitmap
    if hwnd == 0 then
        $hBitmap = _ScreenCapture_CaptureWnd("", $g_hwnd_rplay)
    else
        $hBitmap = _ScreenCapture_CaptureWnd("", $hwnd)
    endif
    return $hBitmap
EndFunc


Func GetPS4RemoteWindowHandler()
    Local $hwnd
    SetFocusWindow()
    $hwnd = WinWaitActive($g_RPLAY_WIN_TITLE,"",120)

    return $hwnd
EndFunc

Func GetPS4WindowPos()
    Local $aPos = WinGetPos($g_RPLAY_WIN_TITLE)
    ;_log4a_Info("GetPS4WindowPos,x="&$aPos[0]&",y="&$aPos[1])
    return $aPos
EndFunc

Func CheckWinNeedMove()
    Local $aPosWindow = WinGetPos($g_RPLAY_WIN_TITLE)
    Local $aSizeWindow = WinGetClientSize($g_RPLAY_WIN_TITLE)
    
    if $aPosWindow[0] <> $g_WindowPosX then
        return true
    endif
    
    if $aPosWindow[1] <> $g_WindowPosY then
        return true
    endif
    
    if $aSizeWindow[0] <> $g_WindowWidth then
        return true
    endif
    
    if $aSizeWindow[1] <> $g_WindowHight then
        return true
    endif
    
    return false
EndFunc

Func CheckMousePosition()
    Local $aPosMouse = MouseGetPos()
    Local $aPosWindow = WinGetPos($g_RPLAY_WIN_TITLE)
    Local $aSizeWindow = WinGetClientSize($g_RPLAY_WIN_TITLE)
    Local $x1,$y1,$x2,$y2
    Local $x0,$y0
    
    $x0 = $aPosMouse[0]
    $y0 = $aPosMouse[1]
    $x1 = $aPosWindow[0]
    $y1 = $aPosWindow[1]
    $x2 = $x1 + $aSizeWindow[0]
    $y2 = $y1 + $aSizeWindow[1]
    
    if $x0 >= $x1 and $y0 >= $y1 then
        if $x0 <= $x2 and $y0 <= $y2 then
            _log4a_Info("Find mouse in window")
            MouseMove(0,0)
            return false
        endif
    endif
    
    return true
     
EndFunc

Func Quit()
	;$path = ScreenCapture()
    ;send_email("PES2019 Script quit","PES2019 Script quit",$g_log_path&";"&$path)
	ProcessClose($g_RPLAY_EXE)
	sleep(500)
	ProcessClose($g_PS4Macro_EXE)
	sleep(500)
	exit 0
EndFunc

Func CheckGameExitWindow()
	$hCtrl = ControlGetHandle($g_RPLAY_WIN_TITLE, "", $g_RPLAY_GAME_EXIT_CONTROL_CLASS)
	
	If Not $hCtrl Then
		return false
	else
		_log4a_Info("Find game exit window")
		return true
	endif
EndFunc

