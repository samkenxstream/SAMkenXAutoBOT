#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

global const $IMAGE_SEARCH_SV = 5
global const $MAINMENU_TOP_CARD_AREA[4] = [64,150,1220,190]
global const $MAINMENU_TOP_CARD_HIGHLIGHT_COLOR = 0x352059
global const $TAB_MATCH_START_X = 65
global const $TAB_MATCH_END_X = 287
global const $TAB_CLUBHOUSE_START_X = 298
global const $TAB_CLUBHOUSE_END_X = 522
global const $TAB_SIGN_START_X = 531
global const $TAB_SIGN_END_X = 754

global const $GAME_STAGE_MAINMENU = 1
global const $GAME_STAGE_MATCHING = 2
global const $GAME_STAGE_AFTER_MATCH = 3

global const $MAINMENU_MIDCARD_HIGHT_LEFT 	= 1
global const $MAINMENU_MIDCARD_HIGHT_MID 	= 2
global const $MAINMENU_MIDCARD_HIGHT_RIGHT 	= 3


;选项卡各个区域坐标
global const $MAINMENU_MIDCARD_X1 = 442
global const $MAINMENU_MIDCARD_X2 = 481
global const $MAINMENU_MIDCARD_X3 = 837
global const $MAINMENU_MIDCARD_Y = 442
global const $MAINMENU_MIDCARD_W = 320
global const $MAINMENU_MIDCARD_H = 133
global const $MAINMENU_HIGHT_COLOR = 0x0C77EB 

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
global const $MAINMENU_TAB_MATCH 		= 1 ; 比赛菜单
global const $MAINMENU_TAB_CLUBHOUSE 	= 2 ; club house
global const $MAINMENU_TAB_SIGN 		= 3 ; 签约
global const $MAINMENU_TAB_OTHER 		= 4 ; 其他菜单


#include "IncludeCommon.au3"

local const $gp_team_number = 2
local const $gp_team_list[] = [$g_IMG_GP_TEAM_1,$g_IMG_GP_TEAM_2]


if @ScriptName == "PES2019_SCENES.au3" then
    ;GetTabIndex()
    CheckInMatchingStage()
endif


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

Func GetTabIndex()
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

	local $tabIndex = GetMainmenuTab($aCoord)

	_log4a_Info("Find tab index="&$tabIndex)

    return $tabIndex
EndFunc


Func GetMainmenuTab($aCoord)
	local $aPos = GetPS4WindowPos()
	local $x = $aCoord[0] - $aPos[0]

	_log4a_Info("CheckMainmenuTab,x="&$x)

	if $x >= $TAB_MATCH_START_X and $x <= $TAB_MATCH_END_X then
		return $MAINMENU_TAB_MATCH
	endif
	if $x >= $TAB_CLUBHOUSE_START_X and $x <= $TAB_CLUBHOUSE_END_X then
		return $MAINMENU_TAB_CLUBHOUSE
	endif
	if $x >= $TAB_SIGN_START_X and $x <= $TAB_SIGN_END_X then
		return $MAINMENU_TAB_SIGN
	endif

	return $MAINMENU_TAB_OTHER
EndFunc

Func GetMainmenuMidTab()
	
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


