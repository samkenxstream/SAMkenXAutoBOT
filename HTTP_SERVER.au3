#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once
#include "IncludeCommon.au3"

Local $sServerName = "ManadarX/1.1 (" & @OSVersion & ") AutoIt " & @AutoItVersion


if @ScriptName == "HTTP_SERVER.au3" then
    start_tcp_server()
    While 1
        Sleep(100)
    WEnd
endif

func start_tcp_server()
    _TCPServer_OnReceive("received")

    _TCPServer_DebugMode(True)
    _TCPServer_SetMaxClients(10)

    _TCPServer_Start($g_HTTP_SERVER_PORT)
endfunc




Func received($iSocket, $sIP, $sData, $sParam)

#cs
	_TCPServer_Send($iSocket, "HTTP/1.0 200 OK" & @CRLF & _
					"Content-Type: text/html" & @CRLF & @CRLF & _
					"<h1>It works!</h1>" & @CRLF & _
					"<p>This is the default web page for this server.</p>" & @CRLF & _
					"<p>However this server is just a 26-lines example.</p>")
	_TCPServer_Close($iSocket)
#ce
    $path = ScreenCapture()
    _HTTP_SendFile($iSocket,$path,"image/jpeg")
    FileDelete($path)
EndFunc   ;==>received

Func _HTTP_SendFile($hSocket, $sFileLoc, $sMimeType, $sReply = "200 OK") ; Sends a file back to the client on X socket, with X mime-type
    Local $hFile, $sImgBuffer, $sPacket, $a

	ConsoleWrite("Sending " & $sFileLoc & @CRLF)

    $hFile = FileOpen($sFileLoc,16)
    $bFileData = FileRead($hFile)
    FileClose($hFile)

    _HTTP_SendData($hSocket, $bFileData, $sMimeType, $sReply)
EndFunc

Func _HTTP_SendData($hSocket, $bData, $sMimeType, $sReply = "200 OK")
	$sPacket = Binary("HTTP/1.1 " & $sReply & @CRLF & _
    "Server: " & $sServerName & @CRLF & _
	"Connection: close" & @CRLF & _
	"Content-Lenght: " & BinaryLen($bData) & @CRLF & _
    "Content-Type: " & $sMimeType & @CRLF & _
    @CRLF)
    TCPSend($hSocket,$sPacket) ; Send start of packet

    While BinaryLen($bData) ; Send data in chunks (most code by Larry)
        $a = TCPSend($hSocket, $bData) ; TCPSend returns the number of bytes sent
        $bData = BinaryMid($bData, $a+1, BinaryLen($bData)-$a)
    WEnd

    $sPacket = Binary(@CRLF & @CRLF) ; Finish the packet
    TCPSend($hSocket,$sPacket)

	TCPCloseSocket($hSocket)
EndFunc


