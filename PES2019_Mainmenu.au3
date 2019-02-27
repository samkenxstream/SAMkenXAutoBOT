#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

;主菜单的三个选项卡，比赛/CLUBHOUSE/签约
global const $MAINMENU_TOPTAB_MATCH 		= 1 ; 比赛菜单
global const $MAINMENU_TOPTAB_CLUBHOUSE 	= 2 ; club house
global const $MAINMENU_TOPTAB_SIGN 		    = 3 ; 签约
global const $MAINMENU_TOPTAB_RECORD 		= 4 ; 记录
global const $MAINMENU_TOPTAB_OPTION 		= 5 ; 选项

;中间菜单
global const $MAINMENU_MIDCARD_NONE     = 0
global const $MAINMENU_MIDCARD_LEFT     = 1
global const $MAINMENU_MIDCARD_MID      = 2
global const $MAINMENU_MIDCARD_RIGHT    = 3


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
    Sleep(1000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(1000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(1000)
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
