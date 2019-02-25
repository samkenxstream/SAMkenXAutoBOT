#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

global $MAINMENU_TOP_CARD_AREA[2] = [140,195]
global $MAINMENU_TOP_CARD_HIGHLIGHT_COLOR = 0x37225B

#include "IncludeCommon.au3"

if @ScriptName == "PES2019_SCENES.au3" then
    $hwnd = GetPS4RemoteWindowHandler()
    $hbitmap = GetScreenSnapshot($hwnd)
    ;PixelSearch()
endif

Func CheckInMainMenu()

EndFunc



