#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

global const $SQUADLIST_POX_X = 173
global const $SQUADLIST_POX_Y = [187,337,488]
global const $SQUADLIST_POX_W = 941
global const $SQUADLIST_POX_H = 142


global const $SQUADLIST_UN_SELECT_COLOR = 0Xe7e2d9
global const $SQUADLIST_UN_SELECT_COLOR_2 = 0Xada8a3


#include "IncludeCommon.au3"




if @ScriptName == "PES2019_SquadSelect.au3" then
	SetFuocusWindow()
	$index = get_squad_list_hight_index()
	_log4a_Info("get_squad_list_hight_index:"&$index)
	get_sim_squad_in_list()
endif

func get_sim_squad_in_list()
	for $i = 1 To UBound($SQUADLIST_POX_Y) - 1
		local $rect = CreateRectEx($SQUADLIST_POX_X,$SQUADLIST_POX_Y[$i],$SQUADLIST_POX_W,$SQUADLIST_POX_H)
		local $bfound = CheckPic($g_IMG_STRING_SIM)
		
	next
endfunc


func get_squad_list_hight_index()
	for $i = 0 To UBound($SQUADLIST_POX_Y) - 1
		local $rect = CreateRectEx($SQUADLIST_POX_X,$SQUADLIST_POX_Y[$i],$SQUADLIST_POX_W,$SQUADLIST_POX_H)
		Local $aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$SQUADLIST_UN_SELECT_COLOR,$IMAGE_SEARCH_SV)
		If not @error then
			continueLoop
		endif
		$aCoord = PixelSearch($rect[0],$rect[1],$rect[2],$rect[3],$SQUADLIST_UN_SELECT_COLOR_2,$IMAGE_SEARCH_SV)
		If not @error then
			continueLoop
		endif

		; find it
		$index = $i + 1
		return $index
	next

	return -1
endfunc


func load_squad_list()
	_KeyPress($g_KEY_ID_LEFT)
	Sleep(500)

	while (1)

		$index = get_squad_list_hight_index()

		if $index == -1 then
			_log4a_Info("load_squad_list failed")
			cancel_watch_dog()
			on_watch_dog_timeout()
			exitloop
		endif

		if $index <> 1 then
			_KeyPress($g_KEY_ID_LEFT)
			Sleep(500)
			continueLoop
		endif

		;查找当前页的小队名称
		for $i = 1 To UBound($SQUADLIST_POX_Y) - 1

		next
	wend


endfunc

