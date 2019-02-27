#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


global const $MAINMENU_TOPCARD_X_ARRAY[5] = [80,315,550,780,1016]
global const $MAINMENU_TOPCARD_Y = 150
global const $MAINMENU_TOPCARD_W = 190
global const $MAINMENU_TOPCARD_H = 40
global const $MAINMENU_TOP_CARD_HIGHLIGHT_COLOR = [0x352059]

;选项卡各个区域坐标
global const $MAINMENU_MIDCARD_X1 = 130
global const $MAINMENU_MIDCARD_X2 = 480
global const $MAINMENU_MIDCARD_X3 = 837
global const $MAINMENU_MIDCARD_Y = 440
global const $MAINMENU_MIDCARD_W = 320
global const $MAINMENU_MIDCARD_H = 160
global const $MAINMENU_MIDCARD_UNSELECT_COLOR = 0xdcd8d1

global const $MAINMENU_MIDCARD_NONE     = 0
global const $MAINMENU_MIDCARD_LEFT     = 1
global const $MAINMENU_MIDCARD_MID      = 2
global const $MAINMENU_MIDCARD_RIGHT    = 3






;主菜单的三个选项卡，比赛/CLUBHOUSE/签约
global const $MAINMENU_TOPTAB_MATCH 		= 1 ; 比赛菜单
global const $MAINMENU_TOPTAB_CLUBHOUSE 	= 2 ; club house
global const $MAINMENU_TOPTAB_SIGN 		    = 3 ; 签约
global const $MAINMENU_TOPTAB_RECORD 		= 4 ; 记录
global const $MAINMENU_TOPTAB_OPTION 		= 5 ; 选项


#include "IncludeCommon.au3"

local const $gp_team_number = 2
local const $gp_team_list[] = [$g_IMG_GP_TEAM_1,$g_IMG_GP_TEAM_2]


if @ScriptName == "PES2019_SCENES.au3" then
    ;GetTabIndex()
    CheckInMatchingStage()
endif


Func CreateRectEx($x,$y,$w,$h)
    local $aPos = GetPS4WindowPos()
    local $rect[4]
    local $x1,$y1,$x2,$y2

    $x1 = $aPos[0] + $x
    $y1 = $aPos[1] + $y
    $x2 = $x1 + $w - 1
    $y2 = $y1 + $h - 1

    $rect[0] = $x1
	$rect[1] = $y1
	$rect[2] = $x2
	$rect[3] = $y2
	;_log4a_Info("CreateRectEx:x1="&$x1&",y1="&$y1&",x2="&$x2&",y2="&$y2)
    return $rect
EndFunc

Func GetTopTabIndex()
    For $i = 0 To UBound($MAINMENU_TOPCARD_X_ARRAY) - 1
        local $rect = CreateRectEx($MAINMENU_TOPCARD_X_ARRAY[$i],$MAINMENU_TOPCARD_Y,$MAINMENU_TOPCARD_W,$MAINMENU_TOPCARD_H)
        For $j = 0 to UBound($MAINMENU_TOP_CARD_HIGHLIGHT_COLOR) - 1
            Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$MAINMENU_TOP_CARD_HIGHLIGHT_COLOR[$j],$IMAGE_SEARCH_SV)
            If not @error then
                $index = ($i + 1)
                _log4a_Info("GetTopTabIndex,find index:"&$index)
                return $index
            endif
		next
	next

    _log4a_Info("GetTopTabIndex,find table card failed.")
    return -1
EndFunc

Func GetMidTabIndex()
    local $x_array[3] = [$MAINMENU_MIDCARD_X1,$MAINMENU_MIDCARD_X2,$MAINMENU_MIDCARD_X3]

    For $i = 0 To UBound($x_array) - 1
        local $rect = CreateRectEx($x_array[$i],$MAINMENU_MIDCARD_Y,$MAINMENU_MIDCARD_W,$MAINMENU_MIDCARD_H)
        Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$MAINMENU_MIDCARD_UNSELECT_COLOR,$IMAGE_SEARCH_SV)
        If @error then
            $index = ($i + 1)
            _log4a_Info("GetMidTabIndex,find index:"&$index)
            return $index
        endif
    next

    _log4a_Info("GetMidTabIndex,find table card failed.")
	return -1
EndFunc


;是否在比赛界面,判断依据
;按Option,出现暂停菜单,就是比赛中
Func CheckInMatchingStage()
    local $bok = false
    local $count = 0
    $bok = CheckPic($g_IMG_PAUSE_MENU)
    while not $bok
        _KeyPress($g_KEY_ID_OPTION)
		Sleep(1000)
		$bok = CheckPic($g_IMG_PAUSE_MENU)
        $count += 1
        if $count > 5 then
            exitloop
        endif

        if $bok then
            _KeyPress($g_KEY_ID_CROSS)
            exitloop
        endif
    wend

    _log4a_Info("CheckInMatchingStage:"&$bok)

    return $bok
EndFunc


Func find_in_mainmenu()
	local $index_toptab = GetTopTabIndex()
	local $index_midtab = GetMidTabIndex()
	if $index_toptab <> -1 and $index_midtab <> -1 then
		return true
	endif
	
	return false
EndFunc

