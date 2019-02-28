#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include-once


global $PLAYER_CARD_W = 66
global $PLAYER_CARD_H = 66


#include "IncludeCommon.au3"


#comments-start
; 根据配置文件获得每个位置的坐标(x,y)
[localtion]
GK=
CB=
CB=
LB=
RB=
DMF=
CMF=
LMF=
RMF=
AMF=
SS=
CF=

;从后备球员列表里面获得每张球员卡的信息
;包括 - 位置/颜色
;找到对应的球员,确定鼠标位置,然后移到对应的区域
;选择球员
;在小队管理中替换对应球员
;完成替换


#comments-end

if @ScriptName == "PES2019_AutoChangePlayer.au3" then
    
endif
