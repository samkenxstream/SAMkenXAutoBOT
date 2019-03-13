#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once



#include "IncludeCommon.au3"

;start_tcp_server()

;_PS4_GameWindow_StartUp()
_log4a_Info("Start to play games")

;初始状态:主菜单
; 1.移动到小队管理菜单,选择小队
; 2.移动到SIM比赛菜单,选择比赛
; 3.等待比赛结束回到主菜单
; 4.选择下一个SIM小队


While(1)
    SetFuocusWindow()
    Sleep(5000)
    back_to_top_menu()
    move_to_squad_menu()
    Sleep(1000)
    select_sim_squad()
    Sleep(1000)
    move_to_sim_match_menu()
    Sleep(1000)

    ; press start key
    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(1000)
    $ok = CheckPic($g_IMG_SQUAD_INVALID)
    if $ok then
        _KeyPress($g_KEY_ID_CIRCLE)
        Sleep(1000)
        set_current_squad_invalid()
        continueLoop
    endif
    send_email("SIM MATCH STARTED at "& _NowTime(),"SIM Match STARTED at "& _NowTime())

    on_match_main_loop()
    ; wait for match exit
    while not is_match_end()
        Sleep(3000)
    wend
    $is_maintains = get_is_maintenance_time()

    _log4a_Info("on_match_end:is_maintains="&$is_maintains)
    squad_list_on_match_finished()
    if $is_maintains then
        ExitLoop
    endif
WEnd

_OpenCV_Shutdown();Closes DLLs





