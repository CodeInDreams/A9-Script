/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
	
	名称：A9 Script
	作者：CodeInDreams
	适用于：MuMu模拟器
	分辨率：2160×1080
	使用说明：
		1. 安装最新版的AutoHotKey(官网下载地址：https://www.autohotkey.com/download/ahk-install.exe)
		2. 安装MuMu模拟器，启动后一键安装Google环境，同时自行安装好科学上网软件和Play游戏
		3. 用apk文件安装好A9，将A9图标置于安卓桌面左上的第一个位置
		4. 根据需要自行修改配置项(Ctrl+F搜索配置项，都附有明确的注释)：APP_INDEX、TICKET_LIMIT、CAREER_CARS、RUN_HOURS
		5. 启动模拟器至首页，双击脚本运行即可
		6. 快捷键：Ctrl+F10 暂停/恢复、Ctrl+F11 重置、Ctrl+F12 退出
	注意事项：
		1. 如果模拟器是以管理员身份运行，那么本脚本也需要以管理员身份运行
		2. 不要超出屏幕，不要有其他窗口置顶遮挡，以免影响点击和坐标计算
		3. 保持显示顶栏和底栏，不要显示侧栏等，以免影响坐标计算
*/
#NoEnv
#SingleInstance Ignore
#Persistent
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode Pixel, Client
CoordMode Mouse, Client

AHK_CLASS = Qt5QWindowIcon ; MuMu模拟器的ahk_class
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
APP_INDEX = 2 ; 应用是MuMu顶栏的首页后的第几个窗口
APP_CLOSE_X := 257 + APP_INDEX * 142 ; 应用关闭按钮X坐标
APP_CLOSE_Y = 16 ; 应用关闭按钮Y坐标
NEMU_HOME_X = 205 ; MuMu首页X坐标
NEMU_HOME_Y = 16 ; MuMu首页X坐标
AX = ; 游戏左上角相对模拟器窗口的X坐标
AY = ; 游戏左上角相对模拟器窗口的Y坐标
AW = ; 实际游戏宽度
AH = ; 实际游戏高度
VW = 2160 ; 100%游戏宽度，实际可能会放缩
VH = 1080 ; 100%游戏高度，实际可能会放缩
DELY_VERY_SHORT = 200 ; 等待时间，很短
DELY_SHORT = 500 ; 等待时间，短
DELY_MIDDLE = 1000 ; 等待时间，中等
DELY_LONG = 2000 ; 等待时间，长
DELY_VERY_LONG = 3000 ; 等待时间，很长
DELY_SUPER_LONG = 15000 ; 等待时间，超级长

TrayTip A9 Script, 脚本开始运行`n可以自由调整窗口大小位置，但不要超出屏幕, 1, 17
WinWait ahk_class %AHK_CLASS%
CalcWin()

CalcWin() ; 发现窗口大小变化后，重新计算AX AY AW AH
{
	global AHK_CLASS, TOP_HEIGHT, BOTTOM_HEIGHT, AX, AY, AW, AH, VW, VH
	IfWinNotActive ahk_class %AHK_CLASS%
	{
		WinActivate ahk_class %AHK_CLASS%
		WinWaitActive ahk_class %AHK_CLASS%
	}
	WinGetPos ,,, winW, winH
	static lastW = 0, lastH = 0 ; 上次检测的窗口大小，用于判断窗口大小是否变化
	if winW != lastW || winH != lastH
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

ResizeWin() ; 用于设置窗口位置以便于debug
{
	global AHK_CLASS, TOP_HEIGHT, BOTTOM_HEIGHT, VW, VH
	WinMove ahk_class %AHK_CLASS%, , 0, 0, VW, VH + TOP_HEIGHT + BOTTOM_HEIGHT
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

RandomClick(x, y, timePrepare:=0, timeAppend:=0, mode:=0) ; 坐标附近随机点击。timePrepare>0时点击前等待一定时间，timeAppend>0时点击后等待一定时间，mode可指定哪些坐标随机偏移，0：偏移xy、1：只偏移x、2：只偏移y、其他：都不偏移
{
	CalcWin()
	global AW, AH
	if (mode = 0 || mode = 1)
		Random dx, -0.003 * AW, 0.003 * AW
	else
		dx := 0
	if (mode = 0 || mode = 2)
		Random dy, -0.003 * AH, 0.003 * AH
	else
		dy := 0
	resultX := GetX(x) + dx
	resultY := GetY(y) + dy
	IfGreater timePrepare, 0, Sleep timePrepare
	Click %resultX%, %resultY%
	IfGreater timeAppend, 0, Sleep timeAppend
}

Swipe(fromX, fromY, toX, toY) ; 滑动
{
	CalcWin()
	global AW, AH, VW, VH, AX, AY, DELY_VERY_SHORT
	dragFromX := fromX * AW / VW + AX
	dragFromY := fromY * AH / VH + AX
	dragToX := toX * AW / VW + AX
	dragToY := toY * AH / VH + AY
	SendEvent {Click %dragFromX%, %dragFromY%, down}
	Sleep DELY_VERY_SHORT
	SendEvent {Click %dragToX%, %dragToY%, up}
}

WaitColor(x, y, color*) ; 等待目标位置出现指定颜色的像素，检测10次后仍不出现就重置脚本
{
	global HOME_X, HOME_Y, DELY_SHORT, DELY_MIDDLE, DELY_LONG, DELY_VERY_LONG
	dt = DELY_SHORT
	Loop 10
	{
		For k, v in color
			if CheckPixel(x, y, v)
				return
		if A_Index > 5
			dt += DELY_MIDDLE
		Sleep dt
	}
	TrayTip A9 Script, 检测不到特征值，脚本即将重置, 1, 17
	Sleep DELY_LONG
	Reload
	Sleep DELY_VERY_LONG
	TrayTip A9 Script, 重置失败，脚本即将退出, 1, 17
	Sleep DELY_LONG
	ExitApp
}

; 2160×1080下的A9专用常量

; A9图标
APP_OPEN_X = 340
APP_OPEN_Y = 217
; 网络错误
NETWORK_ERROR_X = 940
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
RACING_CHECK_X = 158
RACING_CHECK_Y = 104
RACING_CHECK_COLOR = 0xFFFFFF
; 比赛结束检测
RACE_FINISH_X = 158
RACE_FINISH_Y = 104
RACE_FINISH_COLOR = 0x4200F5
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
; 票预留上限，0~9
TICKET_LIMIT = 8
; 生涯用车顺序，第一排1、3、5、7，第二排2、4、6、8。都不可用时，会等待到有可用车辆为止
CAREER_CARS := [5, 6, 10, 6, 18, 13, 15, 17]
; 脚本在哪些小时运行，范围0~23
RUN_HOURS := [0, 1, 7, 9, 10, 11, 14, 15, 16, 17, 21, 22, 23]

; A9专用函数

CheckTime() ; 用于限制脚本运行时间，时间范围外退出A9，回到时间范围内时启动A9
{
	global RUN_HOURS, DELY_SUPER_LONG
	current := A_Hour
	For k, hour in RUN_HOURS
		if (hour - current = 0)
			return
	CloseApp()
	Loop
	{
		Sleep DELY_SUPER_LONG
		current := A_Hour
		For k, hour in RUN_HOURS
			if (hour - current = 0)
			{
				current = 
				OpenApp()
				RunDailyRace()
				return
			}
	}
}

WaitUser() ; 显示开始运行的提示
{
	global DELY_SHORT
	TrayTip A9 Script, 3秒内自动开始运行, 1, 17
	countdown = 15
	while countdown > 0
	{
		Sleep DELY_SHORT
		countdown -= 1
	}
}

CloseApp() ; 关闭Asphalt 9
{
	global AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

OpenApp() ; 启动AspHalt 9
{
	global
	WinActivate ahk_class %AHK_CLASS%
	Click %NEMU_HOME_X%, %NEMUNEMU_HOME_Y%
	RandomClick(APP_OPEN_X, APP_OPEN_Y, DELY_SHORT, DELY_SUPER_LONG)
	Loop
	{
		if A_Index > 120
			Reload
		local runningCheckPixel := GetPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y)
		if (runningCheckPixel = GAME_RUNNING_CHECK_COLOR_NORMAL)
			Break
		else if (runningCheckPixel = GAME_RUNNING_CHECK_COLOR_DARK)
		{
			RandomClick(SALE_AD_X, SALE_AD_Y, DELY_VERY_LONG, DELY_MIDDLE)
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y, , DELY_VERY_LONG)
		else
			Sleep DELY_LONG
	}
}

GoHome() ; 回到A9首页(比赛中不可用)
{
	global BACK_X, BACK_Y, BACK_COLOR, HOME_X, HOME_Y, DELY_LONG, DELY_MIDDLE
	while (CheckPixel(BACK_X, BACK_Y, BACK_COLOR))
	{
		IfGreater A_Index, 5, RandomClick(BACK_X, BACK_Y, , DELY_LONG)
		RandomClick(HOME_X, HOME_Y, , DELY_MIDDLE)
	}
	Sleep DELY_MIDDLE
}

RunDailyRace() ; 从A9首页打开每日车辆战利品赛事。只要票大于预留值，就开始比赛；在票消耗到预留值时，开始跑生涯
{
	global
	GoHome()
	lastDailyRaceTime := A_TickCount
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_MIDDLE)
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_LONG)
	local isTicketsFull := !CheckPixel(TICKET_X, TICKET_Y, TICET_COLOR)
	static tickets = 10
	if (tickets > TICKET_LIMIT || isTicketsFull) ; 当前票大于预留值(也就是还有票可用)或者满票
	{
		if isTicketsFull
			tickets := 10
		else
			tickets -= 1
		RandomClick(DAILY_CAR_CLICK_X, DAILY_CAR_CLICK_Y, , DELY_MIDDLE) ; 这里为了让图标缩小到同样大小，便于匹配图像。如果被点击的赛事是要找的目标(有时会出现乱序现象)，那就匹配不到，直接下次再说
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
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			while (tickets > TICKET_LIMIT)
			{
				tickets -= 1
				lastDailyRaceTime := A_TickCount
				local finished := 0
				while finished = 0
				{
					local carIndex := Mod(A_Index - 1, 6) + 1
					finished := StartRace(carIndex)
				}
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
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_LONG)
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, , DELY_SHORT, 2)
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELY_VERY_LONG)
	while (lastDailyRaceTime + 600000 > A_TickCount)
	{
		Loop 5
		{
			Swipe(1424, 167, 1415, 965)
			Sleep DELY_SHORT
		}
		local euroRaceYAfterSwipe := EURO_RACE_Y - 5 * (965 - 167)
		RandomClick(EURO_RACE_X, euroRaceYAfterSwipe, DELY_SHORT)
		local carArraySize := CAREER_CARS.MaxIndex()
		local finished := 0
		while finished = 0
		{
			local carArrayIndex := Mod(A_Index - 1, carArraySize) + 1
			finished := StartRace(CAREER_CARS[carArrayIndex])
		}
		StartRace(careerCarIndex)
	}
	RunDailyRace()
}

StartRace(indexOfCar) ; 开始比赛，需要指定用第几辆车，目前仅适用于多车可选的赛事
{
	global
	CheckTime()
	WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
	RandomClick(NEXT_X, NEXT_Y, DELY_VERY_SHORT, DELY_LONG)
	Loop 3
		Swipe(123, 503, 1985, 511)
	Sleep DELY_MIDDLE
	local relativePos := indexOfCar
	while relativePos > 6
	{
		Swipe(1830, 520, 239, 521)
		relativePos -= 6
	}
	local carX := (relativePos - 1) // 2 * CAR_GAP_W + CAR_FIRST_OIL_X 
	local carY := (Mod(relativePos, 2) = 0 ? CAR_LOWER_OIL_Y : CAR_UPPER_OIL_Y)
	if !CheckPixel(carX, carY, CAR_RUNABLE_COLOR)
	{
		RandomClick(BACK_X, BACK_Y, , DELY_LONG)
		return false
	}
	RandomClick(carX - 220, carY - 150, , DELY_LONG)
	RandomClick(NEXT_X, NEXT_Y, , DELY_SUPER_LONG)
	WaitColor(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR)
	local dt
	Loop
	{
		Random dt, -200, 500
		IfLess dt, 0, dt := 0
		if dt < 50
			RandomClick(NITRO_X, NITRO_Y, dt)
		if dt < 450
			RandomClick(NITRO_X, NITRO_Y, dt, DELY_LONG)
		else
			RandomClick(BRAKE_X, BRAKE_Y, dt, DELY_LONG)
		if CheckPixel(RACE_FINISH_X, RACE_FINISH_Y, RACE_FINISH_COLOR)
			Break
	}
	while (!CheckPixel(BACK_X, BACK_Y, BACK_COLOR))
		RandomClick(NEXT_X, NEXT_Y, , DELY_MIDDLE)
	return true
}

; 脚本主逻辑

ResizeWin()
WaitUser()
CloseApp()
OpenApp()
RunDailyRace()

; 热键
	
^F10::Pause ; 暂停/恢复
^F11::Reload ; 重置
^F12::ExitApp ; 退出