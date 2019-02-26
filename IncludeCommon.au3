#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

#include <Timers.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
;#include <ImageSearch.au3>
#include <Date.au3>
#include <Array.au3>
#include <StringConstants.au3>
#include "log4a.au3"
#include "OpenCV-Match_UDF.au3"
#include "PS4_RPLAY_CONST.au3"
#include "PS4_KeyAPI.au3"
#include "Utils.au3"
#include "PS4_Rplay_GameWindow.au3"
#include "PES2019_GameResource.au3"
#include "HotKeyMgr.au3"
#include "SmtpMailer.au3"
#include "PES2019_SCENES.au3"
#include "PES2019_WatchDog.au3"


_log4a_SetEnable()
_log4a_SetOutput($LOG4A_OUTPUT_BOTH)
DllCall("User32.dll","bool","SetProcessDPIAware")
_OpenCV_Startup();loads opencv DLLs
_GameResource_Startup()
_KeyMap_Startup()
_PS4_HotKey_Init()
_log4a_SetLogFile($g_log_path)
start_watch_dog()
