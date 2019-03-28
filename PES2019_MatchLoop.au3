#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


global $INGAME_CHECKPIC_X = 601
global $INGAME_CHECKPIC_Y = 138
global $INGAME_CHECKPIC_W = 85
global $INGAME_CHECKPIC_H = 23


#include "IncludeCommon.au3"




; update log:
;

if @ScriptName == "PES2019_MatchLoop.au3" then
	while (1)
		;local $rect = CreateRectEx($INGAME_CHECKPIC_X,$INGAME_CHECKPIC_Y,$INGAME_CHECKPIC_W,$INGAME_CHECKPIC_H)
		;CheckPic($g_IMG_MATCH_END)
		;CheckPic($g_IMG_SQUAD_INVALID)
		;CheckPic($g_IMG_GAME_REPLAY)
		;CheckPic($g_IMG_SHORT_GAME_SCREEN,$rect)
		;CheckPic($g_IMG_BUTTON_OK)
		;is_loading_screen()
        CheckPic($g_IMG_HIGHLIGHT_NO)
		Sleep(200)
	wend
endif


global $g_match_end = false
global $g_match_started = false



func on_match_main_loop()
    _log4a_Info("on_match_main_loop")
    $g_match_end = false
    $g_match_started = false
    Sleep(5000)
    _KeyPress($g_KEY_ID_CIRCLE)
    AdlibRegister("in_match_checking",1000)
endfunc

func on_match_end_loop()
    local $squad_index = get_active_squad_index()
    local $email_content = StringFormat("SIM MATCH END FOR %d at %s",$squad_index,_NowTime())
    AdlibUnRegister("in_match_checking")
    AdlibRegister("after_match_checking",1000)
    SetFuocusWindow()
    _KeyPress($g_KEY_ID_R1)
    Sleep(2000)
    $path = ScreenCapture()
    send_email($email_content ,$email_content ,$g_log_path&";"&$path)
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

    ; 下半场
    $bok = CheckPic($g_IMG_HALF_TIME)
    if $bok then
        _KeyPress($g_KEY_ID_CIRCLE)
        Sleep(1000)
        return
    endif

    ; 如果在比赛缩略图界面,直接返回.
    local $rect = CreateRectEx($INGAME_CHECKPIC_X,$INGAME_CHECKPIC_Y,$INGAME_CHECKPIC_W,$INGAME_CHECKPIC_H)
    $bok = CheckPic($g_IMG_SHORT_GAME_SCREEN,$rect)
    if $bok then
        $g_match_started = true
        Sleep(1000)
        return
    else
        _KeyPress($g_KEY_ID_TRIANGLE)
        Sleep(1000)
    endif

    if not $g_match_started then
        _KeyPress($g_KEY_ID_CIRCLE)
        Sleep(1000)
    endif

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

    ; 球员合约更新
    $bok = CheckPic($g_IMG_PLAYER_CONTRACT_EXPIRED)
    if $bok then
        $is_renew_player = true
        _log4a_Info("start renew player contract")
        ; 重复按右键三次,确保选中合约更新
        move_to_yes_button_and_press()
        return
    endif

    ; 主教练合约更新
    $bok = CheckPic($g_IMG_RECONTRACT_MANAGER_NOTIFY)
    if $bok then
        _log4a_Info("start renew manager contract")
        $path = ScreenCapture()
        send_email("PES2019:RENEW MANAGER's contract","start to renew manager's contract",$g_log_path&";"&$path)
        ; 重复按右键三次,确保选中合约更新
        move_to_yes_button_and_press()
        return
    endif

    $bok = CheckPic($g_IMG_HIGHLIGHT_NO)
    if $bok then
        _log4a_Info("find highlight no button,should move to yes.")
        move_to_yes_button_and_press()
        return
    endif

    $bok = CheckPic($g_IMG_TEAM_MANAGER_MAIN)
    if $bok then
        _log4a_Info("find in squad editor window, back to main menu")
        _KeyPress($g_KEY_ID_CROSS)
        Sleep(5000)
        return
    endif

    $bok = CheckPic($g_IMG_BUTTON_OK)
    if $bok then
        _KeyPress($g_KEY_ID_CIRCLE)
        Sleep(1000)
        return
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

    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(10000)
endfunc


func on_match_end()
    $g_match_end = true
    AdlibUnRegister("after_match_checking")
endfunc

func is_match_end()
    return $g_match_end
endfunc



