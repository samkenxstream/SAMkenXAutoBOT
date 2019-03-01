#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
Global const $g_IMG_HIGHLIGHT_YES               = 1
Global const $g_IMG_HIGHLIGHT_NO                = 2
Global const $g_IMG_START_GAME                  = 3
Global const $g_IMG_USER_SELECT_MENU            = 4
Global const $g_IMG_HALF_TIME                   = 5
Global const $g_IMG_PAUSE_MENU                  = 6
Global const $g_IMG_MATCH_END                   = 7
Global const $g_IMG_TEAM_MANAGER_ITEM           = 8
Global const $g_IMG_TEAM_MANAGER_MAIN           = 9
Global const $g_IMG_RECONTRACT_MANAGER_NOTIFY   = 10
Global const $g_IMG_RENEW_CONTRACT_SUCCESS      = 11
Global const $g_IMG_GAME_REPLAY                 = 12
Global const $g_IMG_GAME_REPLAY_2               = 13
Global const $g_IMG_GP_TEAM_1                   = 14
Global const $g_IMG_GP_TEAM_2                   = 15
Global const $g_IMG_SCOUT_ICON_SELECTED         = 16
Global const $g_IMG_STRING_SIM                  = 17
Global const $g_IMG_STRING_WHITE_BALL           = 18
Global const $g_IMG_STRING_TRAINING             = 19
Global const $g_IMG_SQUAD_LIST_TITLE            = 20
Global const $g_IMG_SQUAD_INVALID               = 21
Global const $g_IMG_MAINMENU_FEATURE_ICON       = 22
Global const $g_IMG_MAINMENU_SET_SCOUT_TITLE    = 23
Global const $g_IMG_PLAYER_CONTRACT_EXPIRED     = 24

Global const $g_IMG_NUM_MAX = 100
Global $g_GAME_PIC_ARRAY[$g_IMG_NUM_MAX]

#include "IncludeCommon.au3"



if @ScriptName == "PES2019_GameResource.au3" then
    CheckPic($g_IMG_TEAM_MANAGER_MAIN)
endif



Func _GameResource_Startup()
    For $i = 0 To UBound($g_GAME_PIC_ARRAY) - 1
        $g_GAME_PIC_ARRAY[$i] = ""
    next
    $g_GAME_PIC_ARRAY[$g_IMG_HIGHLIGHT_YES] = "highlight_yes.png"
    $g_GAME_PIC_ARRAY[$g_IMG_HIGHLIGHT_NO] = "highlight_no.png"
    $g_GAME_PIC_ARRAY[$g_IMG_START_GAME] = "start_game.png"
    $g_GAME_PIC_ARRAY[$g_IMG_USER_SELECT_MENU] = "user_select_menu.png"
    $g_GAME_PIC_ARRAY[$g_IMG_HALF_TIME] = "half_time.png"
    $g_GAME_PIC_ARRAY[$g_IMG_PAUSE_MENU] = "pause_menu.png"
    $g_GAME_PIC_ARRAY[$g_IMG_MATCH_END] = "match_end.png"
    $g_GAME_PIC_ARRAY[$g_IMG_TEAM_MANAGER_ITEM] = "team_manager_item.png"
    $g_GAME_PIC_ARRAY[$g_IMG_TEAM_MANAGER_MAIN] = "team_manager_main.png"
    $g_GAME_PIC_ARRAY[$g_IMG_RECONTRACT_MANAGER_NOTIFY] = "recontract_manager_notify.png"
    $g_GAME_PIC_ARRAY[$g_IMG_RENEW_CONTRACT_SUCCESS] = "renew_contract_success.png"
    $g_GAME_PIC_ARRAY[$g_IMG_GAME_REPLAY] = "game_replay.png"
    $g_GAME_PIC_ARRAY[$g_IMG_GAME_REPLAY_2] = "game_replay_2.png"
    $g_GAME_PIC_ARRAY[$g_IMG_GP_TEAM_1] = "gp_team_1.png"
    $g_GAME_PIC_ARRAY[$g_IMG_GP_TEAM_2] = "gp_team_2.png"
    $g_GAME_PIC_ARRAY[$g_IMG_SCOUT_ICON_SELECTED] = "mainmenu_scout_icon_selected.bmp"
    $g_GAME_PIC_ARRAY[$g_IMG_STRING_SIM] = "squad_list_string_sim.png"
    $g_GAME_PIC_ARRAY[$g_IMG_STRING_WHITE_BALL] = "squad_list_string_whiteball.png"
    $g_GAME_PIC_ARRAY[$g_IMG_STRING_TRAINING] = "squad_list_string_training.png"
    $g_GAME_PIC_ARRAY[$g_IMG_SQUAD_LIST_TITLE] = "squad_list_title.png"
    $g_GAME_PIC_ARRAY[$g_IMG_SQUAD_INVALID] = "squad_invalid.png"
    $g_GAME_PIC_ARRAY[$g_IMG_MAINMENU_FEATURE_ICON] = "mainmenu_feature_icon.png"
    $g_GAME_PIC_ARRAY[$g_IMG_MAINMENU_SET_SCOUT_TITLE] = "set_scout_title.png"
    $g_GAME_PIC_ARRAY[$g_IMG_MAINMENU_SET_SCOUT_TITLE] = "set_scout_title.png"
    $g_GAME_PIC_ARRAY[$g_IMG_PLAYER_CONTRACT_EXPIRED] = "player_contract_expired.png"
EndFunc


Func CheckGameState($hBitmap,$Threshold,$onMatched)
    For $i = 0 To UBound($g_GAME_PIC_ARRAY) - 1
        $pic_name = $g_GAME_PIC_ARRAY[$i]
        if $pic_name == "" then
            ContinueLoop
        endif
        ; Do Pic match compare
        $Match_Pic = @ScriptDir&"\pes2019_img_search\"&$pic_name
        $Match = _MatchPicture($Match_Pic,$hBitmap, $Threshold)
        If Not @error Then
            ;Find match pic
            _log4a_Info("match success for "&$pic_name)
            if $i == $g_IMG_GAME_REPLAY or $i == $g_IMG_GAME_REPLAY_2 then
                _KeyPress($g_KEY_ID_OPTION)
            endif
            call($onMatched,$i,$hBitmap)
        else
            ;_log4a_Info("match faied for "&$pic_name)
        EndIf
    next


EndFunc

Func CheckPic($img_id,$area = False)
    Local $hBitmap
    
    $pic_name = $g_GAME_PIC_ARRAY[$img_id]
    if $pic_name == "" then
        _log4a_Info("CheckPic, the pic name is null,img_id="&$img_id)
    endif
    
    $Match_Pic = @ScriptDir&"\pes2019_img_search\"&$pic_name
    $hwnd = GetPS4RemoteWindowHandler()
    If IsArray($area) Then
        $hBitmap = _ScreenCapture_Capture("", $area[0],$area[1],$area[2],$area[3])
    else
        $hBitmap = _ScreenCapture_CaptureWnd("", $hwnd)
    endif

    $Match = _MatchPicture($Match_Pic,$hBitmap, $g_PicMatch_Threshold)
    If Not @error Then
        ;Find match pic
        _log4a_Info("CheckPic,match success for "&$pic_name)
        _log4a_Info("match area is:x1="&$Match[0]&",y1="&$Match[1]&",x2="&$Match[2]&",y2="&$Match[3])
        _WinAPI_DeleteObject($hBitmap)
        return true
    else
        _log4a_Info("CheckPic,match faied for "&$pic_name)
        _WinAPI_DeleteObject($hBitmap)
        return false
    EndIf
EndFunc



