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

GetX(x) ; 获取实际位置X坐标
{
	global AW, VW, AX
	return x * AW / VW + AX
}

GetY(y) ; 获取实际位置Y坐标
{
	global AH, VH, AY
	return y * AH / VH + AY
}

GetPixel(x, y) ; 获取像素
{
	CalcWin()
	PixelGetColor color, GetX(x), GetY(y)
	return color
}

RandomClick(x, y) ; 坐标附近随机点击
{
	CalcWin()
	global AW, AH
	Random dx, -0.003 * AW, 0.003 * AW
	Random dy, -0.003 * AH, 0.003 * AH
	resultX := GetX(x) + dx
	resultY := GetY(y) + dy
	Click %resultX%, %resultY%
}

RandomClickWithDelay(x, y) ; 随机延迟后，坐标附近随机点击
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

WaitColor(x, y, color) ; 等待目标位置出现指定颜色的像素，检测10次后仍不出现就直接退出脚本
{
	dt = 500
	Loop 10
	{
		pixel = GetPixel(x, y)
		if pixel = color
		{
			return
		}
		else
		{
			if A_Index > 5
				dt := dt + 2000
			Sleep dt
		}
	}
	MsgBox 检测不到特征值，脚本即将从A9主页重新开始
	RandomClick(HOME_X, HOME_Y)
	Sleep 1000
	Goto appHome
}

; 以下是2160×1080下A9的坐标
; A9图标
APP_OPEN_X = 
APP_OPEN_Y = 
; A9关闭按钮，窗口绝对位置
APP_CLOSE_X = 
APP_CLOSE_Y = 
; 每日赛事
DAILY_RACE_X = 558
DAILY_RACE_Y = 1009
; 我的生涯
CAREER_RACE_X = 1588
CAREER_RACE_Y = 1009
; 返回
BACK_X = 45
BACK_Y = 135
BACK_COLOR = 0xFFFFFF
; 主页
HOME_X = 2075
HOME_Y = 80
HOME_COLOR = 
; 下一步
NEXT_X = 
NEXT_Y = 
NEXT_COLOR_GREEN = 
NEXT_COLOR_DEEP_GREEN = 
NEXT_COLOR_WHITE = 
NEXT_COLOR_RED = 
; 促销广告
SALE_AD_X = 1744
SALE_AD_Y = 210
; 氮气
NITRO_X = 
NITRO_Y = 
; 刹车
BRAKE_X = 
BRAKE_Y = 
; 欧洲赛事
EURO_CHAPTER_X = 
EURO_CHAPTER_Y = 
EURO_SEASON_X = 
EURO_SEASON_Y =  
EURO_RACE_X = 
EURO_RACE_Y =
; A9运行检测
GAME_RUNNING_CHECK_X = 
GAME_RUNNING_CHECK_Y = 
GAME_RUNNING_CHECK_COLOR = 
; 比赛中检测
RACING_CHECK_X = 
RACING_CHECK_Y = 
RACING_CHECK_COLOR = 
; 油，用于选车
CAR_UPPER_OIL_Y = 
CAR_LOWER_OIL_Y = 
CAR_FIRST_OIL_X =
CAR_GAP_W = 
; 票，用于判断票券是否已满
TICKET_X = 
TICKET_Y = 
TICKET_COLOR = 
; 每日车辆战利品搜索区域
DAILY_CAR_FROM_X = 
DAILY_CAR_FROM_Y = 
DAILY_CAR_TO_X = 
DAILY_CAR_TO_Y = 
; 每日车辆战利品图片
DAILY_CAR_IMG = 

WinMove ahk_class %A9_AHK_CLASS%, , 0, 0, 2160, 1080 + TOP_HEIGHT + BOTTOM_HEIGHT ; 用于设置窗口位置以便于debug

TrayTip A9 Script, 20秒后自动开始运行，或按Ctrl+F1立即开始
countdown = 100
Loop
{
	if countdown > 0
		Sleep 200
	countdown--
}
^F1:: countdown = 0

; 从模拟器主页开始
Label labelAppClose
Click(APP_CLOSE_X, APP_CLOSE_Y)
Sleep 200

Label labelAppOpen
RandomClick(APP_OPEN_X, APP_OPEN_Y)
WaitColor(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR)
Sleep 1000
RandomClick(SALE_AD_X, SALE_AD_Y)

Label labelAppHome
Loop
{
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y)
	pixel = GetPixel(DAILY_RACE_X, DAILY_RACE_Y)
	if pixel = NEXT_COLOR_WHITE
		Break
	Sleep 200
}
RandomClick(DAILY_RACE_X, DAILY_RACE_Y)
Sleep 1500
ticketColor = GetPixel(TICKET_X, TICKET_Y)
if ticketColor = TICKET_COLOR
{
	ImageSearch dailyRaceX, dailyRaceY, DAILY_CAR_FROM_Y, DAILY_CAR_FROM_Y, DAILY_CAR_TO_X, DAILY_CAR_TO_Y, DAILY_CAR_IMG
	if ErrorLevel = 0
		Click dailyRaceX, dailyRaceY
}

Label labelCareer

