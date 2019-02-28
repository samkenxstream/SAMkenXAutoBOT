#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "IncludeCommon.au3"

Func send_email($sSubject,$sBody,$sAttachFiles = "")
    Local $sSmtpServer = "smtp.ym.163.com" ; address for the smtp-server to use - REQUIRED
	Local $iIPPort = 994 ; port used for sending the mail
    Local $sFromName = "Simon" ; name from who the email was sent
    Local $sFromAddress = "stock@zl-fm.com" ; address from where the mail should come
    Local $sToAddress = "lashwang@outlook.com" ; destination address of the email - REQUIRED
	Local $sCcAddress = "" ; address for cc - leave blank if not needed
    Local $sBccAddress = "" ; address for bcc - leave blank if not needed
    Local $sImportance = "Normal" ; Send message priority: "High", "Normal", "Low"
    Local $sUsername = "stock@zl-fm.com" ; username for the account used from where the mail gets sent - REQUIRED
    Local $sPassword = "992154" ; password for the account used from where the mail gets sent - REQUIRED
    Local $bSSL = True ; enables/disables secure socket layer sending - set to True if using httpS
    ; Local $iIPPort = 465  ; GMAIL port used for sending the mail
    ; Local $bSSL = True   ; GMAIL enables/disables secure socket layer sending - set to True if using httpS

    Local $bIsHTMLBody = False

    Local $rc = _SMTP_SendEmail($sSmtpServer,$sUsername, $sPassword, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles, $sCcAddress, $sBccAddress, $sImportance,  $iIPPort, $bSSL, $bIsHTMLBody)
    If @error Then
        _log4a_Info("send email failed."&@extended);
    EndIf

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

