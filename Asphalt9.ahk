/*	
	A9 Script by CodeInDreams
	适用于：MuMu模拟器
	分辨率：2160×1080
	注意事项：
		不要超出屏幕，不要有其他窗口置顶遮挡，以免影响点击和坐标计算
		保持显示顶栏和底栏，不要显示其他侧栏等，以免影响坐标计算
*/
#NoEnv
#SingleInstance Ignore
#Persistent
SendMode Input
SetWorkingDir %A_ScriptDir%

A9_AHK_CLASS = Qt5QWindowIcon
TOP_HEIGHT = 34 ; 标题栏高度
BOTTOM_HEIGHT = 52 ;底栏高度
AX = ; 游戏左上角相对模拟器窗口的X坐标
AY = ; 游戏左上角相对模拟器窗口的Y坐标
AW = ; 实际游戏宽度
AH = ; 实际游戏高度
VW = 2160 ; 100%游戏宽度，实际可能会放缩
VH = 1080 ; 100%游戏高度，实际可能会放缩
WinWait ahk_class %A9_AHK_CLASS%
TrayTip A9 Script, 脚本开始运行`n可以自由调整窗口大小位置，但不要超出屏幕, 5, 17
CalcWin()
CoordMode Pixel, Client
CoordMode Mouse, Client

CalcWin() ; 发现窗口大小变化后，重新计算AX AY AW AH
{
	IfWinNotActive ahk_class %A9_AHK_CLASS%
		WinActivate ahk_class %A9_AHK_CLASS%
	WinGetPos ,, winW, winH, ahk_class %A9_AHK_CLASS%
	static lastW = 0, lastH = 0 ; 上次检测的窗口大小，用于判断窗口大小是否变化
	if winW <> lastW || winH <> lastH
	{
		lastW := winW
		lastH := winH
		if ((winH - TOP_HEIGHT - BOTTOM_HEIGHT) * VW > winW * VH) ; 过高
		{
			AW := winW
			AH := winW * VH / VW
			AX := 0
			AY := (winH - TOP_HEIGHT - BOTTOM_HEIGHT - AH) / 2 + TOP_HEIGHT
		}
		else ; 过宽
		{
			AH := winH - TOP_HEIGHT - BOTTOM_HEIGHT
			AW := winH * VW / VH
			AY := TOP_HEIGHT
			AX := (winW - AW) / 2
		}
	}
}

GetPixel(x, y) ; 获取像素，(x, y)基于(VW, VH)，不判断超出窗口的情况
{
	global AW, AH, VW, VH
	PixelGetColor color, x * AW / VW, y * AH / VH
	return color
}

RandomClick(x, y) ; 坐标附近随机点击，(x, y)基于(VW, VH)，不判断超出窗口的情况
{
	global AW, AH, VW, VH
	Random dx, -0.003 * AW, 0.003 * AW
	Random dy, -0.003 * AH, 0.003 * AH
	Click %(x * AW / VW + dx)%, %(y * AH / VH + dy)%
}

RandomClickWithDelay(x, y) ; 随机延迟后，坐标附近随机点击，(x, y)基于(VW, VH)，不判断超出窗口的情况
{
	global AW, AH, VW, VH
	Random dx, -0.003 * AW, 0.003 * AW
	Random dy, -0.003 * AH, 0.003 * AH
	Random dt, -200, 500 ; 2/7的概率不延迟，5/7的概率发生至多500ms的延迟
	if dt > 0
		Sleep %dt%
	Click %(x * AW / VW + dx)%, %(y * AH / VH + dy)%
}

; 启动后限时包弹窗1744, 211