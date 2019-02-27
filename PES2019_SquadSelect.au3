#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

global const $SQUADLIST_POX_X = 173
global const $SQUADLIST_POX_Y = [185,334,485]
global const $SQUADLIST_POX_W = 550
global const $SQUADLIST_POX_H = 142


global const $SQUADLIST_UN_SELECT_COLOR = 0Xe7e2d9
global const $SQUADLIST_UN_SELECT_COLOR_2 = 0Xada8a3

global const $SQUADLIST_CONFIG_PATH = @ScriptDir&"\squad_list_config.ini"
global $g_white_ball_squad_array[0]
global $g_exp_earn_squad_array[0]
global $g_total_squad_array[0]
global $g_current_squad_index = -1


#include "IncludeCommon.au3"





if @ScriptName == "PES2019_SquadSelect.au3" then

	; SetFuocusWindow()
	; $index = get_squad_list_hight_index()
	; _log4a_Info("get_squad_list_hight_index:"&$index)
	; get_sim_squad_in_list()
    select_sim_squad()
endif

func _squad_select_startup()
	$white_ball_index_list = IniRead($SQUADLIST_CONFIG_PATH,"white_ball_squad","index","-1")
	$exp_earn_index_list = IniRead($SQUADLIST_CONFIG_PATH,"exp_earn_squad","index","-1")

	$temp_array = StringSplit($white_ball_index_list,",")

	for $i = 1 to  $temp_array[0]
		$number = Int($temp_array[$i])
		if $number > 0 then
			_ArrayAdd($g_white_ball_squad_array, $number)
		endif
	next

	$temp_array = StringSplit($exp_earn_index_list,",")

	for $i = 1 to  $temp_array[0]
		$number = Int($temp_array[$i])
		if $number > 0 then
			_ArrayAdd($g_exp_earn_squad_array, $number)
		endif
	next

	_ArrayAdd($g_total_squad_array,$g_white_ball_squad_array)
	_ArrayAdd($g_total_squad_array,$g_exp_earn_squad_array)
    $g_current_squad_index = 0
	;_ArrayDisplay($g_total_squad_list)
endfunc

func select_sim_squad()
    $active_squad_index = $g_total_squad_array[$g_current_squad_index]

    while not find_squad_list_title()
        _KeyPress($g_KEY_ID_SQUARE)
        Sleep(1500)
    wend

    _log4a_Info("select_sim_squad,active_squad_index:"&$active_squad_index)

    for $i = 1 to $active_squad_index
        _KeyPress($g_KEY_ID_DOWN)
        Sleep(1500)
    next

    _KeyPress($g_KEY_ID_CIRCLE)
    Sleep(5000)

    while not find_in_mainmenu()
        Sleep(5000)
    wend

endfunc


func squad_list_on_match_finished()
    $total_squad = UBound($g_total_squad_array)
    $g_current_squad_index += 1
    $g_current_squad_index = $g_current_squad_index/$total_squad
    _log4a_Info("squad_list_on_match_finished,index="&$g_current_squad_index)
endfunc

func find_squad_list_title()
    $bFound = CheckPic($g_IMG_SQUAD_LIST_TITLE)
    return $bFound
endfunc

func set_current_squad_invalid()
    _log4a_Info("set_current_squad_invalid")
    _ArrayDelete($g_total_squad_array, $g_current_squad_index)
    if UBound($g_total_squad_array) == 0 then
        _log4a_Info("No valid squad found, exit script")
        send_email("All squad used","All squad used, scipt end")
        exit 0
    endif

endfunc

