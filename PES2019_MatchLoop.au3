#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


#include "IncludeCommon.au3"


; update log:
;

if @ScriptName == "PES2019_MatchLoop.au3" then
    CheckPic($g_IMG_MATCH_END)
    CheckPic($g_IMG_SQUAD_INVALID)
	CheckPic($g_IMG_GAME_REPLAY)
endif


global $g_match_end = false

func on_match_main_loop()
    _log4a_Info("on_match_main_loop")
    $g_match_end = false
    Sleep(5000)
    _KeyPress($g_KEY_ID_CIRCLE)
    AdlibRegister("in_match_checking",2000)
endfunc

func on_match_end_loop()
    AdlibUnRegister("in_match_checking")
    AdlibRegister("after_match_checking",1000)
    SetFuocusWindow()
    $path = ScreenCapture()
    send_email("PES2019 SIM Match REPORTED by AUTOSIM","PES2019 SIM Match REPORT",$g_log_path&";"&$path)
    reset_watch_dog()
	reset_log_file()
    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(2000)
    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(2000)
    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(2000)
endfunc

func in_match_checking()


    ; 跳过动画
    $bok = CheckPic($g_IMG_GAME_REPLAY)
    if $bok then
        _KeyPress($g_KEY_ID_OPTION)
        Sleep(1000)
        return
    endif


    ; 跳过动画
    $bok = CheckPic($g_IMG_GAME_REPLAY_2)
    if $bok then
        _KeyPress($g_KEY_ID_OPTION)
        Sleep(1000)
        return
    endif

    ; 手柄选择菜单
    $bok = CheckPic($g_IMG_USER_SELECT_MENU)
    if $bok then
        _KeyPress($g_KEY_ID_CROSS)
        Sleep(1000)
        return
    endif

    ; 暂停菜单
    $bok = CheckPic($g_IMG_PAUSE_MENU)
    if $bok then
        _KeyPress($g_KEY_ID_CROSS)
        Sleep(1000)
        return
    endif

    ; 比赛结束界面
    $bok = CheckPic($g_IMG_MATCH_END)
    if $bok then
        on_match_end_loop()
        return
    endif

    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(1000)

endfunc

func move_to_yes_button_and_press()
    _log4a_Info("move_to_yes_button_and_press")
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(1000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(1000)
    _KeyPress($g_KEY_ID_RIGHT)
    Sleep(1000)
    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(1000)
endfunc 

func after_match_checking()
    local static $is_renew_manager = false
    local static $is_renew_player = false
    
    ; 球员合约更新
    $bok = CheckPic($g_IMG_PLAYER_CONTRACT_EXPIRED)
    if $bok then
        $is_renew_player = true
        _log4a_Info("start renew player contract")
        ; 重复按右键三次,确保选中合约更新
        move_to_yes_button_and_press()
        $is_renew_manager = true
        return
    endif
    
    ; 主教练合约更新
    $bok = CheckPic($g_IMG_RECONTRACT_MANAGER_NOTIFY)
    if $bok then
        _log4a_Info("start renew manager contract")
        ; 重复按右键三次,确保选中合约更新
        move_to_yes_button_and_press()
        $is_renew_manager = true
        return
    endif
    
    ; 跳出支付界面,如果高亮区域在NO,则向右并且点击确认.
    if $is_renew_manager or $is_renew_player then
        $bok = CheckPic($g_IMG_HIGHLIGHT_NO)
        _log4a_Info("find highlight no button,should move to yes.")
        if $bok then
            move_to_yes_button_and_press()
            if $is_renew_manager then 
                $is_renew_manager = false
            endif
            
            if $is_renew_player then 
                $is_renew_player = false
            endif
            return
        endif
        
    endif

    ; 是否在小队管理界面
    for $i = 0 to 3
        $bok = find_in_mainmenu()
        if $bok then
            _log4a_Info("find in mainnenu, exit")
            on_match_end()
            return
        endif
        Sleep(1000)
    next
    
    
    $bok = CheckPic($g_IMG_TEAM_MANAGER_MAIN)
    if $bok then
        _log4a_Info("find in squad editor window, back to main menu")
        _KeyPress($g_KEY_ID_CROSS)
        Sleep(5000)
        return
    endif

    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(3000)
endfunc


func on_match_end()
    $g_match_end = true
    AdlibUnRegister("after_match_checking")
endfunc

func is_match_end()
    return $g_match_end
endfunc



