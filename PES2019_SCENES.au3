#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

global $IMAGE_SEARCH_SV =5
global $MAINMENU_TOP_CARD_AREA[4] = [64,150,1220,190]
global $MAINMENU_TOP_CARD_HIGHLIGHT_COLOR = 0x352059


#include "IncludeCommon.au3"

if @ScriptName == "PES2019_SCENES.au3" then
    $hwnd = GetPS4RemoteWindowHandler()
    $hbitmap = GetScreenSnapshot($hwnd)
    $card_area = CalcRect($MAINMENU_TOP_CARD_AREA)

	Local $aCoord = PixelSearch($card_area[0],$card_area[1],$card_area[2],$card_area[3],$MAINMENU_TOP_CARD_HIGHLIGHT_COLOR,$IMAGE_SEARCH_SV)
	If @error then
		_log4a_Info("PixelSearch failed")
		Local $iColor = PixelGetColor(629,305)
		_log4a_Info("Current color is "&Hex($iColor, 6))
	Else
		_log4a_Info("PixelSearch found x="&$aCoord[0]&",y="&$aCoord[1])
	EndIf
endif

Func CheckInMainMenu()

EndFunc

Func CalcRect($area)
	local $aPos = GetPS4WindowPos()
	local $x1,$y1,$x2,$y2
	local $rect[4]
	if $area[0] == -1 then
	  $x1 = $aPos[0]
	else
	  $x1 = $aPos[0] + $area[0]
	endif

	if $area[1] == -1 then
	  $y1 = $aPos[1]
	else
	  $y1 = $aPos[1] + $area[1]
	endif

	if $area[2] == -1 then
	  $x2 = $aPos[0] + $aPos[2] - 1
	else
	  $x2 = $aPos[0] + $area[2]
	endif

	if $area[3] == -1 then
	  $y2 = $aPos[1] + $aPos[3] - 1
	else
	  $y2 = $aPos[1] + $area[3]
	endif

	$rect[0] = $x1
	$rect[1] = $y1
	$rect[2] = $x2
	$rect[3] = $y2
	_log4a_Info("CalcRect:x1="&$x1&",y1="&$y1&",x2="&$x2&",y2="&$y2)
	return $rect
EndFunc

