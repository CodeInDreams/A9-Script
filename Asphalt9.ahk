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
CoordMode Pixel, Client
CoordMode Mouse, Client

A9_AHK_CLASS = Qt5QWindowIcon ; MuMu模拟器的ahk_class
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
APP_INDEX = 2 ; A9是首页后的第几个窗口
APP_CLOSE_X := 257 + APP_INDEX * 142 ; A9关闭按钮X坐标
APP_CLOSE_Y = 16 ; A9关闭按钮Y坐标
MEMU_HOME_X = 205 ; MuMu首页X坐标
MEMU_HOME_Y = 16 ; MuMu首页X坐标
AX = ; 游戏左上角相对模拟器窗口的X坐标
AY = ; 游戏左上角相对模拟器窗口的Y坐标
AW = ; 实际游戏宽度
AH = ; 实际游戏高度
VW = 2160 ; 100%游戏宽度，实际可能会放缩
VH = 1080 ; 100%游戏高度，实际可能会放缩

TrayTip A9 Script, 脚本开始运行`n可以自由调整窗口大小位置，但不要超出屏幕, 1, 17
WinWait ahk_class %A9_AHK_CLASS%
CalcWin()

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
	PixelGetColor pixel, GetX(x), GetY(y)
	return pixel
}

CheckPixel(x, y, color) ; 验证像素颜色
{
	pixel := GetPixel(x, y)
	return (pixel = color ? true : false)
}

RandomClick(x, y, delay:=0) ; 坐标附近随机点击，点击后休眠一定时间，delay不传或传0时默认1秒
{
	CalcWin()
	global AW, AH, DELY_LONG
	Random dx, -0.003 * AW, 0.003 * AW
	Random dy, -0.003 * AH, 0.003 * AH
	resultX := GetX(x) + dx
	resultY := GetY(y) + dy
	Click %resultX%, %resultY%
	if delay = 0
		delay = DELY_LONG
	Sleep delay
}

RandomClickWithDelay(x, y, delay:=0) ; 随机延迟后，坐标附近随机点击
{	
	Random dt, -200, 500 ; 2/7的概率不延迟，5/7的概率发生至多500ms的延迟
	if dt > 0
		Sleep dt
	RandomClick(x, y, delay)
}

Swipe(fromX, fromY, toX, toY) ; 滑动
{
	CalcWin()
	global AW, AH, VW, VH, AX, AY
	dragFromX := fromX * AW / VW + AX
	dragFromY := fromY * AH / VH + AX
	dragToX := toX * AW / VW + AX
	dragToY := toY * AH / VH + AY
	MouseClickDrag L, dragFromX, dragFromY, dragToX, dragToY
}

WaitColor(x, y, color) ; 等待目标位置出现指定颜色的像素，检测10次后仍不出现就重置脚本
{
	global HOME_X, HOME_Y, DELY_LONG
	dt = 500
	Loop 10
	{
		if CheckPixel(x, y, color)
		{
			return
		}
		else
		{
			if A_Index > 5
				dt := dt + 1000
			Sleep dt
		}
	}
	TrayTip 检测不到特征值，脚本即将重置
	Reload
	Sleep DELY_LONG
	TrayTip 重置失败，脚本即将退出
	ExitApp
}

; 2160×1080下的A9专用常量

; A9图标
APP_OPEN_X = 340
APP_OPEN_Y = 217
; 网络错误
NETWORK_ERROR_X = 1220
NETWORK_ERROR_Y = 765
NETWORK_ERROR_COLOR = 0xFFFFFF
; 每日赛事
DAILY_RACE_X = 500
DAILY_RACE_Y = 973
DAILY_RACE_COLOR = 0xFFFFFF
; 我的生涯
CAREER_RACE_X = 1530
CAREER_RACE_Y = 973
CAREER_RACE_COLOR = 0xFFFFFF
; 返回
BACK_X = 45
BACK_Y = 100
BACK_COLOR = 0xFFFFFF
; 主页
HOME_X = 2075
HOME_Y = 45
HOME_COLOR = 0xEEE7E3
; 下一步
NEXT_X = 1650
NEXT_Y = 973
NEXT_COLOR_GREEN = 0x12FBC3
NEXT_COLOR_BLACK = 0xA09692
NEXT_COLOR_WHITE = 0xFFFFFF
NEXT_COLOR_RED = 0x6412FB
; 促销广告
SALE_AD_X = 1744
SALE_AD_Y = 210
; 氮气
NITRO_X = 1830
NITRO_Y = 559
; 刹车
BRAKE_X = 345
BRAKE_Y = 480
; 欧洲赛事
EURO_CHAPTER_X = 1815
EURO_CHAPTER_Y = 1025
EURO_SEASON_X = 1075
EURO_SEASON_Y = 277
EURO_RACE_X = 766
EURO_RACE_Y = 
; A9运行检测
GAME_RUNNING_CHECK_X = 637
GAME_RUNNING_CHECK_Y = 53
GAME_RUNNING_CHECK_COLOR_DARK = 0x191919
GAME_RUNNING_CHECK_COLOR_NORMAL = 0xFFFFFF
; 比赛中检测
RACING_CHECK_X = 
RACING_CHECK_Y = 
RACING_CHECK_COLOR = 
; 油，用于选车
CAR_FIRST_OIL_X = 566
CAR_UPPER_OIL_Y = 627
CAR_LOWER_OIL_Y = 985
CAR_GAP_W = 514
CAR_RUNABLE_COLOR = 0x12FBC3
; 票，用于判断票券是否已满
TICKET_X = 1812
TICKET_Y = 204
TICKET_COLOR = 0x5400FF
; 每日车辆战利品搜索区域
DAILY_CAR_FROM_X = 105
DAILY_CAR_FROM_Y = 712
DAILY_CAR_TO_X = 658
DAILY_CAR_TO_Y = 1037
DAILY_CAR_CLICK_X = 1675
DAILY_CAR_CLICK_Y = 905
; 每日车辆战利品图片
DAILY_CAR_IMG = %A_WorkingDir%\resources\daily_race.png
DAILY_CAR_IMG_W = 74
; 点击后延迟
DELY_SHORT = 200
DELY_MIDDLE = 500
DELY_LONG = 1000
DELY_VERY_LONG = 1500
; 票预留上限，0~9
TICKET_LIMIT = 8
; 生涯用车顺序，第一排1、3、5、7，第二排2、4、6、8。都不可用时，会等待到有可用车辆为止
CAREER_CARS := [5, 6, 10, 6, 18, 13, 15, 17]

; A9专用函数

ResizeWin() ; 用于设置窗口位置以便于debug
{
	global A9_AHK_CLASS, TOP_HEIGHT, BOTTOM_HEIGHT
	WinMove ahk_class %A9_AHK_CLASS%, , 0, 0, 2160, 1080 + TOP_HEIGHT + BOTTOM_HEIGHT
}

WaitUser() ; 显示开始运行的提示
{
	global DELY_SHORT
	TrayTip A9 Script, 3秒内自动开始运行, 1, 17
	countdown = 15
	while countdown > 0
	{
		Sleep DELY_SHORT
		countdown := countdown - 1
	}
}

CloseApp() ; 关闭Asphalt 9
{
	global A9_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %A9_AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

OpenApp() ; 启动AspHalt 9
{
	global
	Click %MEMU_HOME_X%, %MEMU_HOME_Y%
	Sleep DELY_SHORT
	RandomClick(APP_OPEN_X, APP_OPEN_Y)
	Sleep 15000
	Loop
	{
		if A_Index > 120
			Reload
		local runningCheckPixel := GetPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y)
		if (runningCheckPixel = GAME_RUNNING_CHECK_COLOR_NORMAL)
			Break
		else if (runningCheckPixel = GAME_RUNNING_CHECK_COLOR_DARK)
		{
			Sleep DELY_VERY_LONG
			RandomClick(SALE_AD_X, SALE_AD_Y)
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y)
		else
			Sleep DELY_LONG
	}
}

GoHome() ; 回到A9首页(比赛中不可用)
{
	global BACK_X, BACK_Y, BACK_COLOR, HOME_X, HOME_Y, DELY_LONG
	while (CheckPixel(BACK_X, BACK_Y, BACK_COLOR))
		RandomClick(HOME_X, HOME_Y)
	Sleep DELY_LONG
}

RunDailyRace() ; 从A9首页打开每日车辆战利品赛事。只要票大于预留值，就开始比赛；在票消耗到预留值时，开始跑生涯
{
	global
	GoHome()
	lastDailyRaceTime := A_TickCount
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
	{
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y)
		Sleep DELY_LONG
	}
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y)
	Sleep DELY_VERY_LONG
	local isTicketsFull := !CheckPixel(TICKET_X, TICKET_Y, TICKET_COLOR)
	if (tickets > TICKET_LIMIT || isTicketsFull) ; 当前票大于预留值(也就是还有票可用)或者满票
	{
		if isTicketsFull
			tickets := 10
		else
			tickets := tickets - 1
		RandomClick(DAILY_CAR_CLICK_X, DAILY_CAR_CLICK_Y) ; 这里为了让图标缩小到同样大小，便于匹配图像。如果被点击的赛事是要找的目标(有时会出现乱序现象)，那就匹配不到，直接下次再说
		Sleep DELY_LONG
		scaledImageWidth := DAILY_CAR_IMG_W * AW / VW
		Loop
		{
			local dailyCarFromX := GetX(DAILY_CAR_FROM_X)
			local dailyCarFromY := GetY(DAILY_CAR_FROM_Y)
			local dailyCarToX := GetX(DAILY_CAR_TO_X)
			local dailyCarToY := GetY(DAILY_CAR_TO_Y)
			ImageSearch dailyRaceX, dailyRaceY, dailyCarFromX, dailyCarFromY, dailyCarToX, dailyCarToY, *100 *w%imageScaleWidth% *h-1 %DAILY_CAR_IMG%
			if (ErrorLevel = 0 || A_Index > 1)
				Break
			Sleep DELY_VERY_LONG
			Sleep DELY_VERY_LONG ; 有时候刚进游戏加载不出来，需要等一会儿
		}
		if ErrorLevel = 0
		{
			RandomClick(dailyRaceX, dailyRaceY)
			RandomClick(dailyRaceX, dailyRaceY)
			while (tickets > TICKET_LIMIT)
			{
				ToolTip img success
				tickets := tickets - 1
				lastDailyRaceTime := A_TickCount
				StartRace(1)
			}
		}
	}
	RunCareerRace()
}

RunCareerRace() ; 从首页打开并开始生涯EURO赛季的第12个赛事，如果超过10min没跑赛事，会检查一次每日赛事
{
	global
	GoHome()
	if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
	{
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y)
		Sleep DELY_LONG
	}
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y)
	Sleep DELY_VERY_LONG
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y)
	Sleep DELY_SHORT
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y)
	Sleep DELY_VERY_LONG
	Loop 5
		Swipe(1424, 167, 1415, 965)
	local euroRaceYAfterSwipe := EURO_RACE_Y - 5 * (965 - 167)
	;RandomClick(EURO_RACE_X, euroRaceYAfterSwipe)
	local careerCarSize := CAREER_CARS.MaxIndex()
	while (lastDailyRaceTime + 600000 > A_TickCount)
	{
		local careerCarIndex := Mod(A_Index, careerCarSize)
		local careerCar := CAREER_CARS[careerCarIndex]
		StartRace(1)
	}
	RunDailyRace()
}

StartRace(indexOfCar) ; 开始比赛，需要指定用哪辆车，目前仅适用于多车可选的赛事
{
	global
	ToolTip start race
	Sleep DELY_VERY_LONG
	ToolTip finish race
}

; 脚本主逻辑

;ResizeWin()
;WaitUser()
;CloseApp()
;OpenApp()
RunDailyRace()

; 热键

^F10::Pause ; 暂停/恢复
^F11::Reload ; 重置
^F12::ExitApp ; 结束