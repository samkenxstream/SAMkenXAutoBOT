#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

;球探星级区域
global const $SCOUTS_LEVEL_W = 30
global const $SCOUTS_LEVEL_H = 30
global const $SCOUTS_LEVEL_Y = 238
global const $SCOUTS_LEVEL_X1 = 979
global const $SCOUTS_LEVEL_X2 = 1017
global const $SCOUTS_LEVEL_X3 = 1053
global const $SCOUTS_LEVEL_X4 = 1088
global const $SCOUTS_HIGHT_COLOR = 0xFFB423
global const $SCOUTS_UNHIGHT_COLOR = 0x5E5F58


;请求谈判高亮区域
global const $SCOUTS_CONFIRM_X = 74
global const $SCOUTS_CONFIRM_Y = 487
global const $SCOUTS_CONFIRM_W = 200
global const $SCOUTS_CONFIRM_H = 57
global const $SCOUTS_CONFIRM_UNHIGHT_COLOR = 0xF2F0EC


;确认菜单高亮区域
global const $CONFIRM_UNHIGHT_COLOR = 0xfefefe
global const $CONFIRM_BTN_W = 100
global const $CONFIRM_BTN_H = 53
global const $CONFIRM_BTN_Y = 460
global const $CONFIRM_BTN_CANCEL_X = 292
global const $CONFIRM_BTN_OK_X = 666


global const $MAX_STATE_CHECK_COUNT = 100

;状态定义
global const $SCOUTS_STATE_INIT 			= 1 ; 初始状态，回到主菜单
global const $SCOUTS_STATE_FOUND_SCOUTS 	= 2 ; 选择球探界面
global const $SCOUTS_STATE_MOVE_TO_REQUEST 	= 3	; 移动到请求谈判按钮
global const $SCOUTS_STATE_CONFIRM_REQUEST 	= 4	; 确定按钮
global const $SCOUTS_STATE_REQUEST_WAITING 	= 5	; 或者球员等待动画
global const $SCOUTS_STATE_DONE 			= 6 ; 状态结束
global const $BACK_TO_MAIN					= 7 ; 退回到主菜单

global const $SCOUTS_START_KEEP				= 5 ; 需要保留的球探星级


#include "IncludeCommon.au3"


global $g_scouts_loop_state


if @ScriptName == "PES2019_ScoutsSold.au3" then
    SetFuocusWindow()
	start_scouts_sold_main_loop()
    ;GetTopTabIndex()
    ;GetMidTabIndex()
    ;find_scout_star()
    ;check_scout_request_highted()
    ;check_confirm_button()
    ;find_scout_screen()
    ;check_scout_request_highted()
endif


func handle_process_error()
	cancel_watch_dog()
	on_watch_dog_timeout()
	exit 0
endfunc


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



func find_scouts_menu()
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
			_log4a_Info("success found to scouts menu")
            ExitLoop
        endif

        Sleep(500)
    wend
endfunc


func scouts_move_to_next_state($state)

	switch($state)
		case $SCOUTS_STATE_FOUND_SCOUTS
			return $SCOUTS_STATE_MOVE_TO_REQUEST
		case $SCOUTS_STATE_MOVE_TO_REQUEST
			return $SCOUTS_STATE_CONFIRM_REQUEST
		case $SCOUTS_STATE_CONFIRM_REQUEST
			return $SCOUTS_STATE_REQUEST_WAITING
		case $SCOUTS_STATE_REQUEST_WAITING
			return $SCOUTS_STATE_FOUND_SCOUTS
		case $SCOUTS_STATE_DONE
			return $BACK_TO_MAIN
		case $BACK_TO_MAIN
			return $SCOUTS_STATE_INIT
		case Else
			return $state
	endswitch

	return $state
endfunc

; return value:
; true - move to the next state
; false - keep current state
func scouts_sold_loop()
	_log4a_Info("scouts_sold_loop,state = "&$g_scouts_loop_state)

	switch $g_scouts_loop_state
		case $SCOUTS_STATE_FOUND_SCOUTS
			$star = find_scout_star()
			if $star == 0 then
				_KeyPress($g_KEY_ID_CIRCLE)
				Sleep(1000)
				return false
			endif

			if $star >= $SCOUTS_START_KEEP then
				$g_scouts_loop_state = $SCOUTS_STATE_DONE
                send_email("PES2019 SIM SCOUTS SOLD DONE","PES2019 SIM SCOUTS SOLD DONE, time:"& _NowTime())
				return true
			endif

			return true

		case $SCOUTS_STATE_MOVE_TO_REQUEST
            while not check_scout_request_highted()
                _KeyPress($g_KEY_ID_DOWN)
                Sleep(1000)
            wend
            Sleep(2000)
            _KeyPress($g_KEY_ID_CIRCLE)
            Sleep(2000)
            return true

		case $SCOUTS_STATE_CONFIRM_REQUEST
            _KeyPress($g_KEY_ID_RIGHT)
			Sleep(1000)
            _KeyPress($g_KEY_ID_RIGHT)
			Sleep(1000)
            _KeyPress($g_KEY_ID_RIGHT)
			Sleep(1000)
            _KeyPress($g_KEY_ID_CIRCLE)
            Sleep(2000)
            return true

		case $SCOUTS_STATE_REQUEST_WAITING
			if not find_scout_screen() then
				_KeyPress($g_KEY_ID_CIRCLE)
				Sleep(1000)
				_KeyPress($g_KEY_ID_OPTION)
				Sleep(1000)
				return false
			else
				return true
			endif
		case $BACK_TO_MAIN
			if find_in_mainmenu() then
				return true
			endif
			_KeyPress($g_KEY_ID_CROSS)
			Sleep(500)
			return false
		Case Else
			return false

	endswitch

	return false

endfunc


func scouts_state_check()
	$bStateFinished = scouts_sold_loop()

	if $bStateFinished then
		$g_scouts_loop_state = scouts_move_to_next_state($g_scouts_loop_state)
	endif
endfunc


;使用此函数前，需要手动将球探的等级作为升序排列（默认为降序排列）
func start_scouts_sold_main_loop()
	$g_scouts_loop_state = $SCOUTS_STATE_INIT
	find_scouts_menu()

    ;进入设定球探界面
    ; TODO: do the loop for all the below 3 scouts.
	$g_scouts_loop_state = $SCOUTS_STATE_FOUND_SCOUTS
	AdlibRegister("scouts_state_check",500)
	while (1)
		if $g_scouts_loop_state == $SCOUTS_STATE_INIT then
			ExitLoop
		endif
    wend
	AdlibUnRegister("scouts_state_check")
EndFunc



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


func find_scout_star()
    local $x_array[4] = [$SCOUTS_LEVEL_X1,$SCOUTS_LEVEL_X2,$SCOUTS_LEVEL_X3,$SCOUTS_LEVEL_X4]
    local $star = 0;

    For $i = 0 To UBound($x_array) - 1
        local $rect = CreateRectEx($x_array[$i],$SCOUTS_LEVEL_Y,$SCOUTS_LEVEL_W,$SCOUTS_LEVEL_H)
        Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$SCOUTS_HIGHT_COLOR,$IMAGE_SEARCH_SV)
        If not @error then
            $star += 1
        endif
    next

    _log4a_Info("find_scout_star:"&$star)
    return $star
endfunc


func find_scout_screen()
    local $rect = CreateRectEx($SCOUTS_LEVEL_X1,$SCOUTS_LEVEL_Y,$SCOUTS_LEVEL_W,$SCOUTS_LEVEL_H)
    Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$SCOUTS_UNHIGHT_COLOR,$IMAGE_SEARCH_SV)
    If not @error then
        _log4a_Info("find_scout_screen found")
        return true
    else
        _log4a_Info("find_scout_screen not found")
        return false
    endif
endfunc

func check_scout_request_highted()
    $bfound = CheckPic($g_IMG_MAINMENU_SET_SCOUT_TITLE)

    if not $bfound then
        return false
    endif

    local $rect = CreateRectEx($SCOUTS_CONFIRM_X,$SCOUTS_CONFIRM_Y,$SCOUTS_CONFIRM_W,$SCOUTS_CONFIRM_H)
    Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$SCOUTS_CONFIRM_UNHIGHT_COLOR,$IMAGE_SEARCH_SV)
    If @error then
        _log4a_Info("check_scout_request_highted,found highted.")
        return true
    else
        _log4a_Info("check_scout_request_highted,not found highted.")
        return false
    endif
endfunc

func check_confirm_button()
    local $rect = CreateRectEx($CONFIRM_BTN_OK_X,$CONFIRM_BTN_Y,$CONFIRM_BTN_W,$CONFIRM_BTN_H)
    Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$CONFIRM_UNHIGHT_COLOR,$IMAGE_SEARCH_SV)
    If @error then
        _log4a_Info("check_confirm_button,confirm selected")
        return true
    else
        _log4a_Info("check_confirm_button,confirm not selected")
        return false
    endif

endfunc


