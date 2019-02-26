#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "IncludeCommon.au3"


if @ScriptName == "PES2019_ScoutsSold.au3" then
    SetFuocusWindow()
	;start_scouts_sold_main_loop()
    GetMidTabIndex()
    
endif


func scouts_sold_watch_dog_time_out()
    _log4a_Info("scouts_sold_watch_dog_time_out")
endfunc

func start_scouts_sold_main_loop()
    AdlibRegister("scouts_sold_watch_dog_time_out",$g_GameLoop_WatchDogTime*1000)
	while (1)
        ; 首先移动到签约窗口
        local $index_toptab = GetTopTabIndex()
        local $index_midtab = GetMidTabIndex()

        if $index_toptab <> $MAINMENU_TOPTAB_SIGN then
            move_to_sign_menu($index_toptab)
            ContinueLoop
        endif
        _log4a_Info("success move to sign menu")
        if $index_midtab <> $MAINMENU_MIDCARD_MID then
            move_to_scouts_menu($index_midtab)
            ContinueLoop
        endif
        _log4a_Info("success move to scouts menu")

        $bFound = CheckPic($g_IMG_SCOUT_ICON_SELECTED)

        if not $bFound then
            _KeyPress($g_KEY_ID_L1)
        else
            ExitLoop
        endif

        Sleep(100)
    wend

    _log4a_Info("success foud to scouts menu")


EndFunc


func move_to_scouts_menu($index)
    switch $index
        case $MAINMENU_MIDCARD_NONE
            _KeyPress($g_KEY_ID_UP)
        case $MAINMENU_MIDCARD_LEFT
            _KeyPress($g_KEY_ID_RIGHT)
        case $MAINMENU_MIDCARD_RIGHT
            _KeyPress($g_KEY_ID_LEFT)
    endswitch
    Sleep(500)

endfunc

func move_to_sign_menu($index)
    switch $index
        case $MAINMENU_TOPTAB_MATCH
            _KeyPress($g_KEY_ID_R1)
            Sleep(200)
            _KeyPress($g_KEY_ID_R1)
        case $MAINMENU_TOPTAB_CLUBHOUSE
            _KeyPress($g_KEY_ID_R1)
        case $MAINMENU_TOPTAB_RECORD
            _KeyPress($g_KEY_ID_L1)
        case $MAINMENU_TOPTAB_OPTION
            _KeyPress($g_KEY_ID_L1)
            Sleep(200)
            _KeyPress($g_KEY_ID_L1)
    endswitch
endfunc




