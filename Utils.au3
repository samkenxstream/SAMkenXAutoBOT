#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once

Global const $g_SERVER_NAME_INDEX   = 0
Global const $g_SERVER_PORT_INDEX   = 1
Global const $g_ADDRESS_INDEX       = 2
Global const $g_PASSWORD_INDEX      = 3
Global const $g_IF_SSL_INDEX        = 4

Global $g_email_settings_default[10]
Global $g_email_settings_backup[10]
Global $g_email_settings_backup2[10]


$g_email_settings_default[$g_SERVER_NAME_INDEX] = "smtp.ym.163.com"
$g_email_settings_default[$g_SERVER_PORT_INDEX] = 25
$g_email_settings_default[$g_ADDRESS_INDEX] = "stock@zl-fm.com"
$g_email_settings_default[$g_PASSWORD_INDEX] = "992154"
$g_email_settings_default[$g_IF_SSL_INDEX] = False



$g_email_settings_backup[$g_SERVER_NAME_INDEX] = "smtp.163.com"
$g_email_settings_backup[$g_SERVER_PORT_INDEX] = 25
$g_email_settings_backup[$g_ADDRESS_INDEX] = "18106576207@163.com"
$g_email_settings_backup[$g_PASSWORD_INDEX] = "meimei1985"
$g_email_settings_backup[$g_IF_SSL_INDEX] = False


$g_email_settings_backup2[$g_SERVER_NAME_INDEX] = "smtp.ym.163.com"
$g_email_settings_backup2[$g_SERVER_PORT_INDEX] = 25
$g_email_settings_backup2[$g_ADDRESS_INDEX] = "zheng.wang@zl-fm.com"
$g_email_settings_backup2[$g_PASSWORD_INDEX] = "992154"
$g_email_settings_backup2[$g_IF_SSL_INDEX] = False


Global $g_email_configs[] = [$g_email_settings_default,$g_email_settings_backup2,$g_email_settings_backup]


#include "IncludeCommon.au3"

if @ScriptName == "Utils.au3" then
    send_email("SIM MATCH STARTED","SIM MATCH STARTED")
	;while (1)
        ;Local $saved_screen_path = $Screen_Shot_path&"image_"&@MON&"_"&@MDAY&"_"&@HOUR&"_"&@MIN&"_"&@SEC&".jpg"
        ;_ScreenCapture_Capture($saved_screen_path)
        ;$saved_screen_path = ScreenCapture("bmp")
        ;_log4a_Info("do ScreenCapture to:"&$saved_screen_path)
		;Sleep(200)
        ;send_email("Test test","Test test")
	;WEnd
endif

Func send_email($sSubject,$sBody,$sAttachFiles = "")
    Local $sFromName = "Simon" ; name from who the email was sent
    Local $sToAddress = "lashwang@outlook.com;18106576207@163.com" ; destination address of the email - REQUIRED
	Local $sCcAddress = "" ; address for cc - leave blank if not needed
    Local $sBccAddress = "" ; address for bcc - leave blank if not needed
    Local $sImportance = "High" ; Send message priority: "High", "Normal", "Low"
    ; Local $iIPPort = 465  ; GMAIL port used for sending the mail
    ; Local $bSSL = True   ; GMAIL enables/disables secure socket layer sending - set to True if using httpS
    Local $bIsHTMLBody = False

    for $index = 0 to UBound($g_email_configs) - 1
        Local $email_config = $g_email_configs[$index]
        Local $sSmtpServer  = $email_config[$g_SERVER_NAME_INDEX] ; address for the smtp-server to use - REQUIRED
        Local $iIPPort      = $email_config[$g_SERVER_PORT_INDEX] ; port used for sending the mail
        Local $sUsername    = $email_config[$g_ADDRESS_INDEX] ; username for the account used from where the mail gets sent - REQUIRED
        Local $sPassword    = $email_config[$g_PASSWORD_INDEX] ; password for the account used from where the mail gets sent - REQUIRED
        Local $bSSL         = $email_config[$g_IF_SSL_INDEX] ; enables/disables secure socket layer sending - set to True if using httpS
        Local $sFromAddress = $sUsername        ; address from where the mail should come
        Local $rc = _SMTP_SendEmail($sSmtpServer,$sUsername, $sPassword, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles, $sCcAddress, $sBccAddress, $sImportance,  $iIPPort, $bSSL, $bIsHTMLBody)
        If @error Then
            _log4a_Info("send email failed for :"&$sUsername);
        else
            ExitLoop
        EndIf
    next 
    
    

EndFunc   ;==>_Example

Func CheckInvalidWindow()
    Local $tv_title = "发起会话"
    Local $tv_btn = "确定"
    Local $tv_Wnd = WinExists($tv_title,$tv_btn)
    If $tv_Wnd Then
	  _log4a_Info("Find team view window")
	  $tv_Wnd = WinActivate($tv_title)
	  WinWaitActive($tv_title,"",10)
	  ControlClick($tv_Wnd, "",$tv_btn)
      return
    EndIf
EndFunc

; Get timestamp for input datetime (or current datetime).
Func _GetUnixTime($sDate = 0);Date Format: 2013/01/01 00:00:00 ~ Year/Mo/Da Hr:Mi:Se

    Local $aSysTimeInfo = _Date_Time_GetTimeZoneInformation()
    Local $utcTime = ""

    If Not $sDate Then $sDate = _NowCalc()

    If Int(StringLeft($sDate, 4)) < 1970 Then Return ""

    If $aSysTimeInfo[0] = 2 Then ; if daylight saving time is active
        $utcTime = _DateAdd('n', $aSysTimeInfo[1] + $aSysTimeInfo[7], $sDate) ; account for time zone and daylight saving time
    Else
        $utcTime = _DateAdd('n', $aSysTimeInfo[1], $sDate) ; account for time zone
    EndIf

    Return _DateDiff('s', "1970/01/01 00:00:00", $utcTime)
EndFunc   ;==>_GetUnixTime


; 是否为维护时间, 每周四上午10点开始维护
Func get_is_maintenance_time()
	Local $iWeekday = _DateToDayOfWeek(@YEAR, @MON, @MDAY)
	if $iWeekday <> 4 then
		return false
	endif

	; 周四上午9点半以后不允许开比赛了
	if @HOUR == 9 and @MIN >= 30 then
		return true
	endif

	return false
EndFunc

