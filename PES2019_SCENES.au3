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
global const $MAINMENU_MIDCARD_HIGHT_COLOR = [0x0C77EB,0x1980f3]

global const $MAINMENU_MIDCARD_NONE     = 0
global const $MAINMENU_MIDCARD_LEFT     = 1
global const $MAINMENU_MIDCARD_MID      = 2
global const $MAINMENU_MIDCARD_RIGHT    = 3


;球探星级区域
global const $SCOUTS_LEVEL_W = 30
global const $SCOUTS_LEVEL_H = 30
global const $SCOUTS_LEVEL_Y = 238
global const $SCOUTS_LEVEL_X1 = 979
global const $SCOUTS_LEVEL_X2 = 1017
global const $SCOUTS_LEVEL_X3 = 1053
global const $SCOUTS_LEVEL_X4 = 1088
global const $SCOUTS_HIGHT_COLOR = 0xFFB423

;请求谈判高亮区域
global const $SCOUTS_CONFIRM_X = 74
global const $SCOUTS_CONFIRM_Y = 487
global const $SCOUTS_CONFIRM_W = 556
global const $SCOUTS_CONFIRM_H = 57
global const $SCOUTS_CONFIRM_HIGHT_COLOR = 0x2790ff


;确认菜单高亮区域
global const $CONFIRM_HIGHT_COLOR = 0x258eff
global const $CONFIRM_BTN_W = 336
global const $CONFIRM_BTN_H = 53
global const $CONFIRM_BTN_Y = 460
global const $CONFIRM_BTN_CANCEL_X = 292
global const $CONFIRM_BTN_OK_X = 666

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
	_log4a_Info("CreateRectEx:x1="&$x1&",y1="&$y1&",x2="&$x2&",y2="&$y2)
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
    ScreenCapture()
    exit 0
EndFunc

Func GetMidTabIndex()
    local $x_array[3] = [$MAINMENU_MIDCARD_X1,$MAINMENU_MIDCARD_X2,$MAINMENU_MIDCARD_X3]

    For $i = 0 To UBound($x_array) - 1
        local $rect = CreateRectEx($x_array[$i],$MAINMENU_MIDCARD_Y,$MAINMENU_MIDCARD_W,$MAINMENU_MIDCARD_H)
        For $j = 0 to UBound($MAINMENU_MIDCARD_HIGHT_COLOR) - 1
            Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$MAINMENU_MIDCARD_HIGHT_COLOR,$IMAGE_SEARCH_SV)
            If not @error then
                $index = ($i + 1)
                _log4a_Info("GetMidTabIndex,find index:"&$index)
                return $index
            endif
        next
    next

    _log4a_Info("GetMidTabIndex,find table card failed.")
    ScreenCapture()
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


