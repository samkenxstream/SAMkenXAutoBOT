#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "IncludeCommon.au3"

Global $g_watchdog_timeout_count = 0
Global const $g_watchdog_max_allowed_count = 5


if @ScriptName == "PES2019_WatchDog.au3" then
	on_watch_dog_timeout()
endif



func start_watch_dog()
    AdlibRegister("on_watch_dog_timeout",$g_GameLoop_WatchDogTime*1000)
    $g_watchdog_timeout_count = 0
endfunc


func reset_watch_dog()
    AdlibUnRegister("on_watch_dog_timeout")
    AdlibRegister("on_watch_dog_timeout",$g_GameLoop_WatchDogTime*1000)
    $g_watchdog_timeout_count = 0
endfunc


func cancel_watch_dog()
    AdlibUnRegister("on_watch_dog_timeout")
endfunc


func on_watch_dog_timeout()
    SetFuocusWindow()
    $path = ScreenCapture()
    send_email("PES2019 Watch Dog Timeout","Watch Dog Timeout",$g_log_path&";"&$path)
    $g_watchdog_timeout_count = $g_watchdog_timeout_count + 1
    if $g_watchdog_timeout_count > $g_watchdog_max_allowed_count then
        exit 0
    endif
endfunc