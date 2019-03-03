#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


;主菜单的三个选项卡，比赛/CLUBHOUSE/签约
global const $MAINMENU_TOPTAB_MATCH         = 1 ; 比赛菜单
global const $MAINMENU_TOPTAB_CLUBHOUSE     = 2 ; club house
global const $MAINMENU_TOPTAB_SIGN          = 3 ; 签约
global const $MAINMENU_TOPTAB_RECORD        = 4 ; 记录
global const $MAINMENU_TOPTAB_OPTION        = 5 ; 选项

;中间菜单
global const $MAINMENU_MIDCARD_NONE     = 0
global const $MAINMENU_MIDCARD_LEFT     = 1
global const $MAINMENU_MIDCARD_MID      = 2
global const $MAINMENU_MIDCARD_RIGHT    = 3


;顶部选项卡坐标
global const $MAINMENU_TOPCARD_X_ARRAY[5] = [80,315,550,780,1016]
global const $MAINMENU_TOPCARD_Y = 150
global const $MAINMENU_TOPCARD_W = 190
global const $MAINMENU_TOPCARD_H = 40
global const $MAINMENU_TOP_CARD_HIGHLIGHT_COLOR = 0x352059


;中间选项卡各个区域坐标
global const $MAINMENU_MIDCARD_X1 = 130
global const $MAINMENU_MIDCARD_X2 = 480
global const $MAINMENU_MIDCARD_X3 = 837
global const $MAINMENU_MIDCARD_Y = 440
global const $MAINMENU_MIDCARD_W = 320
global const $MAINMENU_MIDCARD_H = 160
global const $MAINMENU_MIDCARD_UNSELECT_COLOR = 0xdcd8d1



#include "IncludeCommon.au3"


if @ScriptName == "PES2019_Mainmenu.au3" then
    SetFuocusWindow()
    ;move_to_squad_menu()
    ;Sleep(5000)
    move_to_sim_match_menu()
    ;back_to_top_menu()
endif


func move_to_squad_menu()
    _log4a_Info("move_to_squad_menu")
    while GetTopTabIndex() <> $MAINMENU_TOPTAB_CLUBHOUSE
        move_top_tab($MAINMENU_TOPTAB_CLUBHOUSE)
        Sleep(1000)
    wend
    _log4a_Info("move_to_squad_menu success")
endfunc


func move_to_sim_match_menu()
    _log4a_Info("move_to_sim_match_menu")
    while GetTopTabIndex() <> $MAINMENU_TOPTAB_MATCH
        move_top_tab($MAINMENU_TOPTAB_MATCH)
        Sleep(1000)
    wend
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(2000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(2000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(2000)
    _log4a_Info("move_to_sim_match_menu success")
endfunc

func move_top_tab($targe_tab)
    local $index_toptab = GetTopTabIndex()
    local $diff = $targe_tab - $index_toptab
    local $move_key
    if $diff == 0 then
        reset_mid_tab()
        return
    endif

    if $diff < 0 then
        $diff = $diff*(-1)
        $move_key = $g_KEY_ID_L1
    else
        $move_key = $g_KEY_ID_R1
    endif

    for $i = 1 to $diff
        _KeyPress($move_key)
        Sleep(1000)
    next

endfunc


func reset_mid_tab()
    _KeyPress($g_KEY_ID_L1)
    Sleep(1000)
    _KeyPress($g_KEY_ID_R1)
    Sleep(1000)
endfunc

func back_to_top_menu()
    while (1)
        if GetTopTabIndex()  == -1 then
            _KeyPress($g_KEY_ID_CROSS)
            Sleep(15000)
        else
            exitLoop
        endif
    wend
endfunc


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
    $bFound = CheckPic($g_IMG_MAINMENU_FEATURE_ICON)
    
    if not $bFound then 
        return -1
    endif
    
    
    For $i = 0 To UBound($MAINMENU_TOPCARD_X_ARRAY) - 1
        local $rect = CreateRectEx($MAINMENU_TOPCARD_X_ARRAY[$i],$MAINMENU_TOPCARD_Y,$MAINMENU_TOPCARD_W,$MAINMENU_TOPCARD_H)
        Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$MAINMENU_TOP_CARD_HIGHLIGHT_COLOR,$IMAGE_SEARCH_SV)
        If not @error then
            $index = ($i + 1)
            _log4a_Info("GetTopTabIndex,find index:"&$index)
            return $index
        endif
    next

    _log4a_Info("GetTopTabIndex,find table card failed.")
    return -1
EndFunc

Func GetMidTabIndex()
    local $x_array[3] = [$MAINMENU_MIDCARD_X1,$MAINMENU_MIDCARD_X2,$MAINMENU_MIDCARD_X3]

    $bFound = CheckPic($g_IMG_MAINMENU_FEATURE_ICON)
    if not $bFound then 
        return -1
    endif
    
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

Func find_in_mainmenu()
    local $index_toptab = GetTopTabIndex()
    if $index_toptab <> -1 then
        return true
    endif

    return false
EndFunc

