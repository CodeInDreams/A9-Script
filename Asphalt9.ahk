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
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
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
	global A9_AHK_CLASS, TOP_HEIGHT, BOTTOM_HEIGHT, AX, AY, AW, AH, VW, VH
	IfWinNotActive ahk_class %A9_AHK_CLASS%
	{
		WinActivate ahk_class %A9_AHK_CLASS%
		WinWaitActive ahk_class %A9_AHK_CLASS%
	}
	WinGetPos ,,, winW, winH
	static lastW = 0, lastH = 0 ; 上次检测的窗口大小，用于判断窗口大小是否变化
	if winW <> lastW || winH <> lastH
	{
		lastW := winW
		lastH := winH
		if ((winH - TOP_HEIGHT - BOTTOM_HEIGHT) * VW > winW * VH) ; 过高
		{
			AW := winW
			AH := AW * VH / VW
			AX := 0
			AY := (winH - TOP_HEIGHT - BOTTOM_HEIGHT - AH) / 2 + TOP_HEIGHT
		}
		else ; 过宽
		{
			AH := winH - TOP_HEIGHT - BOTTOM_HEIGHT
			AW := AH * VW / VH
			AY := TOP_HEIGHT
			AX := (winW - AW) / 2
		}
	}
}

GetX(x)
{
	global AW, VW, AX
	return x * AW / VW + AX
}

GetY(y)
{
	global AH, VH, AY
	return y * AH / VH + AY
}

GetPixel(x, y) ; 获取像素，(x, y)基于(VW, VH)，不判断超出窗口的情况
{
	CalcWin()
	PixelGetColor color, GetX(x), GetY(y)
	return color
}

RandomClick(x, y) ; 坐标附近随机点击，(x, y)基于(VW, VH)，不判断超出窗口的情况
{
	CalcWin()
	global AW, AH
	Random dx, -0.003 * AW, 0.003 * AW
	Random dy, -0.003 * AH, 0.003 * AH
	resultX := GetX(x) + dx
	resultY := GetY(y) + dy
	Click %resultX%, %resultY%
}

RandomClickWithDelay(x, y) ; 随机延迟后，坐标附近随机点击，(x, y)基于(VW, VH)，不判断超出窗口的情况
{	
	Random dt, -200, 500 ; 2/7的概率不延迟，5/7的概率发生至多500ms的延迟
	if dt > 0
		Sleep dt
	RandomClick(x, y)
}

Swipe(fromX, fromY, toX, toY)
{
	CalcWin()
	global AW, AH, VW, VH, AX, AY
	MouseClickDrag L, fromX * AW / VW + AX, fromY * AH / VH + AX, toX * AW / VW + AX, toY * AH / VH + AY, 
}

; 以下是2160×1080下A9的坐标
DAILY_RACE_X = 558
DAILY_RACE_Y = 1009
CARIER_RACE_X = 1588
CARIER_RACE_Y = 1009
BACK_X = 45
BACK_Y = 135
BACK_COLOR = 0xFFFFFF
HOME_X = 2075
HOME_Y = 80
HOME_COLOR = 
NEXT_X = 
NEXT_Y = 
NEXT_COLOR_GREEN = 
NEXT_COLOR_WHITE = 
NEXT_COLOR_RED = 
SALE_AD_X = 1744
SALE_AD_Y = 210

WinMove ahk_class %A9_AHK_CLASS%, , 0, 0, 2160, 1080 + TOP_HEIGHT + BOTTOM_HEIGHT ; 用于设置窗口位置以便于debug

; 启动后限时包弹窗
RandomClick(SALE_AD_X, SALE_AD_Y)
