/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

; 操作模式，0自动，1手动，设置为手动来在关闭时切换回手动模式
OPERATE_MODE = 1
; 应用是顶栏的"首页"后的第几个窗口
APP_INDEX = 1
; 票预留上限，0~10，建议小于9以免浪费浪费票
TICKET_LIMIT = 8
; 生涯用车顺序，第一排1、3、5、7，第二排2、4、6、8。都不可用时，会等待到有可用车辆为止
CAREER_CARS := [5, 6, 4, 7, 10, 12, 13]
; 脚本在哪些小时运行，范围0~23
RUN_HOURS := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

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

WaitWin() ; 等待模拟器运行
{
	global EMU_AHK_CLASS, EMU_AHK_EXE, EMU_AHK_ID
	if EMU_AHK_CLASS
		WinWait ahk_class %EMU_AHK_CLASS%
	else if EMU_AHK_EXE
		WinWait ahk_exe %EMU_AHK_EXE%
	else
		MsgBox 配置有误
	WinGet EMU_AHK_ID
}

ActivateWin() ; 激活模拟器窗口
{
	global EMU_AHK_ID
	IfWinNotActive ahk_id %EMU_AHK_ID%
	{
		WinActivate
		WinWaitActive
	}
}

CalcWin() ; 发现窗口大小变化后，重新计算AX AY AW AH
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, AX, AY, AW, AH, VW, VH, EMU_AHK_ID
	ActivateWin()
	WinGetPos ,,, winW, winH
	static lastW = 0, lastH = 0 ; 上次检测的窗口大小，用于判断窗口大小是否变化
	if winW != lastW || winH != lastH
	{
		lastW := winW
		lastH := winH
		if ((winH - TOP_HEIGHT - BOTTOM_HEIGHT) * VW > (winW - LEFT_WIDTH - RIGHT_WIDTH) * VH) ; 过高
		{
			AW := winW - LEFT_WIDTH - RIGHT_WIDTH
			AH := AW * VH / VW
			AX := LEFT_WIDTH
			AY := (winH - TOP_HEIGHT - BOTTOM_HEIGHT - AH) / 2 + TOP_HEIGHT
		}
		else ; 过宽
		{
			AH := winH - TOP_HEIGHT - BOTTOM_HEIGHT
			AW := AH * VW / VH
			AY := TOP_HEIGHT
			AX := (winW - LEFT_WIDTH - RIGHT_WIDTH - AW) / 2 + LEFT_WIDTH
		}
	}
}

ResizeWin() ; 用于设置窗口位置以便于debug
{
	global TOP_HEIGHT, BOTTOM_HEIGHT, LEFT_WIDTH, RIGHT_WIDTH, VW, VH, EMU_AHK_ID
	WinMove ahk_id %EMU_AHK_ID%, , 0, 0, VW + LEFT_WIDTH + RIGHT_WIDTH, VH + TOP_HEIGHT + BOTTOM_HEIGHT
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

CheckPixel(x, y, colors*) ; 验证像素颜色
{
	pixel := GetPixel(x, y)
	For k, color in colors
		if (pixel = color)
			return true
	return false
}

CheckPixelWithDeviation(x, y, color, deviation:=100) ; 验证像素颜色，允许误差
{
	pixel := GetPixel(x, y)
	pr := pixel & 0xFF
	pg := (pixel & 0xFF00) >> 8
	pb := pixel >> 16
	cr := color & 0xFF
	cg := (color & 0xFF00) >> 8
	cb := color >> 16
	return (Abs(pr - cr) < deviation && Abs(pb - cg) < deviation && Abs(pb - cb) < deviation)
}

WaitColor(x, y, color*) ; 等待目标位置出现指定颜色的像素，检测10次后仍不出现就重置脚本
{
	global HDELY_SHORT, DELY_MIDDLE, DELY_LONG, DELY_VERY_LONG
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
	ShowTrayTip("检测不到特征值，脚本即将重置", DELY_LONG)
	Sleep DELY_LONG
	Reload
	Sleep DELY_VERY_LONG
	ShowTrayTip("重置失败，脚本即将退出", DELY_LONG)
	Sleep DELY_LONG
	ExitApp
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

Swipe(fromX, fromY, toX, toY, mode:=0) ; 滑动，mode，0：快速但不保证精确，1：精确但不够快
{
	CalcWin()
	global AH, VH, DELY_SHORT
	dragFromX := GetX(fromX)
	dragFromY := GetY(fromY)
	dragToX := GetX(toX)
	dragToY := GetY(toY)
	Click %dragFromX%, %dragFromY%, D
	dx := Abs(dragToX - dragFromX)
	dy := Abs(dragToY - dragFromY)
	part := (dx > dy ? dx : dy)
	dxPart := dx // part
	if (dragFromX > dragToX)
		dxPart := -dxPart
	dyPart := dy // part
	if (dragFromY > dragToY)
		dyPart := -dyPart
	Loop %part%
	{
		MouseMove dxPart, dyPart, , R
		if (A_Index & 0xF = 0 && mode = 1) ; 减少二进制位1的个数，来提高精度，但会增加延迟
			Sleep 1
	}
	MouseMove dragToX, dragToY
	Sleep DELY_SHORT
	Click %dragToX%, %dragToY%, U
}

ShowTrayTip(text, period:=1000) ; 显示period毫秒的托盘区提示
{
	TrayTip A9 Script, %text%, , 16
	SetTimer HideTrayTip, -%period%
}

HideTrayTip() ; 隐藏托盘区提示
{
	TrayTip
}

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

EMU_AHK_CLASS = Qt5QWindowIcon ; 模拟器的ahk_class
EMU_AHK_EXE = ; 模拟器的ahk_exe
TOP_HEIGHT = 35 ; 标题栏高度
BOTTOM_HEIGHT = 53 ; 底栏高度
LEFT_WIDTH = 0 ; 左侧宽度
RIGHT_WIDTH = 0 ; 右侧宽度
APP_CLOSE_X := 257 + APP_INDEX * 142 ; 应用关闭按钮X坐标
APP_CLOSE_Y = 16 ; 应用关闭按钮Y坐标
EMU_HOME_X = 205 ; 首页X坐标
EMU_HOME_Y = 16 ; 首页X坐标
APP_OPEN_X = 340 ; A9图标X坐标
APP_OPEN_Y = 217 ; A9图标Y坐标

CloseApp() ; 关闭A9
{
	global EMU_AHK_CLASS, APP_CLOSE_X, APP_CLOSE_Y
	WinActivate ahk_class %EMU_AHK_CLASS%
	Click %APP_CLOSE_X%, %APP_CLOSE_Y%
}

RunApp() ; 启动A9
{
	global EMU_AHK_CLASS, APP_INDEX, EMU_HOME_X, EMU_HOME_Y, APP_OPEN_X, APP_OPEN_Y, DELY_SHORT, DELY_SUPER_LONG
	WinActivate ahk_class %EMU_AHK_CLASS%
	if APP_INDEX > 1
		Click %EMU_HOME_X%, %EMU_HOME_Y%
	RandomClick(APP_OPEN_X, APP_OPEN_Y, DELY_SHORT, DELY_SUPER_LONG)
}

/*	
	This project is licensed under the terms of the GPL license. See full license in LICENSE.TXT.
	本项目遵守GPL开源协议，协议内容请见LICENSE.TXT。
*/

#NoEnv
#SingleInstance Force
#Persistent
Process Priority, , High
SendMode Input
SetWorkingDir %A_ScriptDir%
;Icon 
CoordMode Pixel, Client
CoordMode Mouse, Client

; 2160×1080下的A9专用常量

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
NEXT_X_2 = 1850
NEXT_X_3 = 911
NEXT_Y = 973
NEXT_COLOR_GREEN = 0x12FBC3
NEXT_COLOR_BLACK = 0xA09692
NEXT_COLOR_WHITE = 0xFFFFFF
NEXT_COLOR_RED = 0x6412FB
; 促销广告
SALE_AD_X = 1744
SALE_AD_Y = 186
; 氮气
NITRO_X = 1830
NITRO_Y = 559
; 刹车
BRAKE_X = 345
BRAKE_Y = 480
; 欧洲赛事
EURO_CHAPTER_X = 1816
EURO_CHAPTER_Y = 1025
EURO_SEASON_X = 908
EURO_SEASON_Y = 277
EURO_RACE_X = 761
EURO_RACE_Y = 640
EURO_RACE_Y_DEVIATION = 65
EURO_RACE_COLOR = 0x12FBC3
; A9运行检测
GAME_RUNNING_CHECK_X = 637
GAME_RUNNING_CHECK_Y = 53
GAME_RUNNING_CHECK_COLOR_DARK = 0x191919
GAME_RUNNING_CHECK_COLOR_GRAY = 0x343434
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
CAR_FIRST_OIL_X = 630
CAR_UPPER_OIL_Y = 633
CAR_LOWER_OIL_Y = 993
CAR_GAP_W = 514
CAR_RUNABLE_COLOR_MIN = 0x12260C
CAR_RUNABLE_COLOR_MAX = 0x39FBC3
; 选车滑动检测
CAR_HEAD_1_X = 101
CAR_HEAD_1_Y = 927
CAR_HEAD_1_COLOR = 0x230E04
CAR_HEAD_2_X = 140
CAR_HEAD_2_Y = 870
CAR_HEAD_2_COLOR = 0x230E04
CAR_TAIL_X = 2068
CAR_TAIL_Y = 355
CAR_TAIL_COLOR = 0x230E04
CAR_FEATURE_1_X = 184
CAR_FEATURE_1_Y = 432
CAR_FEATURE_2_X = 247
CAR_FEATURE_2_Y = 432
CAR_FEATURE_COLOR_NORMAL = 0xFFFFFF
CAR_FEATURE_COLOR_LOCKED = 0x7F7F7F
; 票，用于判断票券是否已满
TICKET_X = 1812
TICKET_Y = 205
TICKET_COLOR = 0x5400FF
; 每日车辆战利品搜索相关
DAILY_CAR_FEATURE_1_X = 221
DAILY_CAR_FEATURE_1_Y = 888
DAILY_CAR_FEATURE_1_COLOR = 0xD2D2D2
DAILY_CAR_FEATURE_2_X = 200
DAILY_CAR_FEATURE_2_Y = 853
DAILY_CAR_FEATURE_2_COLOR = 0x5300FF
DAILY_CAR_FEATURE_3_X = 240
DAILY_CAR_FEATURE_3_Y = 866
DAILY_CAR_FEATURE_3_COLOR = 0xD7D7D7
DAILY_CAR_FEATURE_4_X = 231
DAILY_CAR_FEATURE_4_Y = 879
DAILY_CAR_FEATURE_4_COLOR = 0xC76529
DAILY_CAR_GAP_W = 280
DAILY_CAR_CLICK_X = 1920
DAILY_CAR_CLICK_Y = 905
; 自动/手动判断相关
OPERATE_MODE_X = 2003
OPERATE_MODE_Y = 840
OPERATE_MODE_RANGE = 12

; A9专用函数

CheckTime() ; 用于限制脚本运行时间，时间范围外退出A9，回到时间范围内时启动A9
{
	global RUN_HOURS, DELY_SUPER_LONG
	current := A_Hour
	For k, hour in RUN_HOURS
		if (hour - current = 0)
			return
	ShowTrayTip("当前时段不运行游戏")
	CloseApp()
	Loop
	{
		Sleep DELY_SUPER_LONG
		current := A_Hour
		For k, hour in RUN_HOURS
			if (hour - current = 0)
				Reload
	}
}

WaitUser() ; 显示开始运行的提示
{
	global DELY_SHORT
	ShowTrayTip("3秒内自动开始运行")
	countdown = 15
	while countdown > 0
	{
		Sleep DELY_SHORT
		countdown -= 1
	}
}

OpenApp() ; 启动A9
{
	global
	RunApp()
	Loop
	{
		if A_Index > 120
			Reload
		if CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y,GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
		{
			Sleep DELY_LONG
			Break
		}
		if CheckPixel(NETWORK_ERROR_X, NETWORK_ERROR_Y, NETWORK_ERROR_COLOR)
			RandomClick(NETWORK_ERROR_X, NETWORK_ERROR_Y, , DELY_VERY_LONG)
		else
			Sleep DELY_LONG
	}
}

GoHome() ; 回到A9首页(比赛中不可用)，
{
	global
	while CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
	{
		IfGreater A_Index, 5, RandomClick(BACK_X, BACK_Y, , DELY_LONG)
		IfGreater A_Index, 10, Reload
		RandomClick(HOME_X, HOME_Y, , DELY_MIDDLE)
	}
	Sleep DELY_MIDDLE
	while CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
	{
		IfGreater A_Index, 10, Reload
		RandomClick(SALE_AD_X, SALE_AD_Y, , DELY_MIDDLE)
	}
}

RunDailyRace() ; 从A9首页打开每日车辆战利品赛事。只要票大于预留值，就开始比赛；在票消耗到预留值时，开始跑生涯
{
	global
	GoHome()
	lastDailyRaceTime := A_TickCount
	if !CheckPixel(DAILY_RACE_X, DAILY_RACE_Y, DAILY_RACE_COLOR)
		RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_MIDDLE)
	RandomClick(DAILY_RACE_X, DAILY_RACE_Y, , DELY_LONG)
	static tickets = 0
	if (!CheckPixel(TICKET_X, TICKET_Y, TICKET_COLOR))
		tickets := 10
	if (tickets > TICKET_LIMIT) ; 当前票大于预留值(也就是还有票可用)
	{
		RandomClick(DAILY_CAR_CLICK_X, DAILY_CAR_CLICK_Y, , DELY_MIDDLE) ; 这里为了让图标缩小到同样大小，便于匹配特征点。如果被点击的赛事是要找的目标(有时会出现乱序现象)，那就匹配不到，直接下次再说
		Loop 2 ; 有时候刚进游戏加载不出来，所以搜索两次
		{
			local findDailyCar := false
			Loop 6
			{
				local dx := (A_Index - 1) * DAILY_CAR_GAP_W
				local feature1 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_1_X + dx, DAILY_CAR_FEATURE_1_Y, DAILY_CAR_FEATURE_1_COLOR)
				local feature2 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_2_X + dx, DAILY_CAR_FEATURE_2_Y, DAILY_CAR_FEATURE_2_COLOR)
				local feature3 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_3_X + dx, DAILY_CAR_FEATURE_3_Y, DAILY_CAR_FEATURE_3_COLOR)
				local feature4 = CheckPixelWithDeviation(DAILY_CAR_FEATURE_4_X + dx, DAILY_CAR_FEATURE_4_Y, DAILY_CAR_FEATURE_4_COLOR)
				if (feature1 && feature2 && feature3 && feature4)
				{
					findDailyCar := true
					local dailyRaceX := DAILY_CAR_FEATURE_4_X + dx
					local dailyRaceY := DAILY_CAR_FEATURE_4_Y
					Break
				}
			}
			if (findDailyCar)
				Break
			Sleep DELY_VERY_LONG
			Sleep DELY_VERY_LONG
		}
		if (findDailyCar)
		{
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			RandomClick(dailyRaceX, dailyRaceY, , DELY_MIDDLE)
			while (tickets > TICKET_LIMIT)
			{
				tickets -= 1
				lastDailyRaceTime := A_TickCount
				WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
				RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
				local carIndex := 1
				while (!StartRace(carIndex)) ; 这里都没油就等着
					carIndex := Mod(A_Index, 6) + 1
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
	RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
	WaitColor(BACK_X, BACK_Y, BACK_COLOR)
	RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELY_SHORT, DELY_SHORT, 2)
	RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELY_MIDDLE, 2)
	local carArraySize := CAREER_CARS.MaxIndex()
	while (lastDailyRaceTime + 600000 > A_TickCount)
	{
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED) ; 等待进入
		Loop 6
			Swipe(1424, 200, 1415, 950)
		Sleep DELY_VERY_SHORT
		Loop 4 ; 解决滑动误差，当前屏幕找不到EURO 12，就继续滑动，重复4次找不到就放弃
		{
			local foundEuroRace := false
			while (!foundEuroRace) ; 解决滑动误差，在当前屏幕内查找EURO 12
			{
				local yDevition := (A_Index - 1) * EURO_RACE_Y_DEVIATION
				if CheckPixel(EURO_RACE_X, EURO_RACE_Y + yDevition, EURO_RACE_COLOR)
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y + yDevition, DELY_SHORT)
					foundEuroRace := true
				}
				else if (A_Index > 1 && CheckPixel(EURO_RACE_X, EURO_RACE_Y - yDevition, EURO_RACE_COLOR))
				{
					RandomClick(EURO_RACE_X, EURO_RACE_Y - yDevition, DELY_SHORT)
					foundEuroRace := true
				}
				else if A_Index > 6
					Break
			}
			if (foundEuroRace)
				Break
			Swipe(1424, 200, 1415, 950)
		}
		if (!foundEuroRace)
			RunDailyRace()
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
		local carArrayIndex := 1
		while (!StartRace(CAREER_CARS[carArrayIndex]))
		{
			carArrayIndex := Mod(A_Index, carArraySize) + 1
			if (A_Index > carArraySize * 2)
			{
				ShowTrayTip("无可用车辆")
				Break
			}
		}
		ShowTrayTip("+2400")
	}
	Sleep DELY_MIDDLE
	RunDailyRace()
}

StartRace(indexOfCar, waitTime:=20) ; 开始比赛，需要指定用第几辆车，目前仅适用于多车可选的赛事，waitTime：检测赛事开始与否的操作超时时间，默认20秒
{
	global
	CheckTime()
	while (!CheckPixel(CAR_HEAD_1_X, CAR_HEAD_1_Y, CAR_HEAD_1_COLOR) ; 重置车辆位置，如果滑动次数超过10次，那么说明不正常，就要重置脚本
		|| !CheckPixel(CAR_HEAD_2_X, CAR_HEAD_2_Y, CAR_HEAD_2_COLOR))
	{
		if A_Index > 10
			Reload
		Swipe(239, 503, 1837, 511)
	}
	ToolTip 正在检查第%indexOfCar%辆车
	Sleep DELY_SHORT
	local relativePos := indexOfCar
	while relativePos > 6
	{
		Swipe(1837, 520, 239, 521, 1)
		relativePos -= 6
		if (releativePos > 6 && CheckPixel(CAR_TAIL_X, CAR_TAIL_Y, CAR_TAIL_COLOR))
			return false
	}
	local carX := (relativePos - 1) // 2 * CAR_GAP_W + CAR_FIRST_OIL_X
	local carY := (relativePos & 1 = 0 ? CAR_LOWER_OIL_Y : CAR_UPPER_OIL_Y)
	local oilColor := GetPixel(carX, carY)
	local oilR := oilColor & 0xFF
	local oilG := (oilColor & 0xFF00) >> 8
	local oilB := oilColor >> 16
	local minR := CAR_RUNABLE_COLOR_MIN & 0xFF
	local minG := (CAR_RUNABLE_COLOR_MIN & 0xFF00) >> 8
	local minB := CAR_RUNABLE_COLOR_MIN >> 16
	local maxR := CAR_RUNABLE_COLOR_MAX & 0xFF
	local maxG := (CAR_RUNABLE_COLOR_MAX & 0xFF00) >> 8
	local maxB := CAR_RUNABLE_COLOR_MAX >> 16
	if (oilR < minR || oilR > maxR || oilG < minG || oilG > maxG || oilB < minB || oilB > maxB)
		return false
	ToolTip
	RandomClick(carX - 220, carY - 150, , DELY_LONG)
	if !CheckOperateMode()
		RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELY_LONG, 3)
	RandomClick(NEXT_X, NEXT_Y, , DELY_SUPER_LONG)
	while (!CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR)) ; 检测比赛是否已开始，或者超过设定值强制视为已开始
	{
		if (A_Index > waitTime)
		{
			ShowTrayTip("无法检测比赛是否已经开始，现在按照已开始处理")
			Break
		}
		Sleep DELY_MIDDLE
	}
	local maxRaceTime := A_TickCount + 300000 ; 设定比赛超时时间5分钟，超时后重置脚本
	local dt
	Loop
	{
		Random dt, -200, 500
		IfLess dt, 0, dt := 0
		if dt < 50
			RandomClick(NITRO_X, NITRO_Y, dt)
		if dt < 400
			RandomClick(NITRO_X, NITRO_Y, dt, DELY_MIDDLE)
		else if dt < 450
			RandomClick(BRAKE_X, BRAKE_Y, dt, DELY_LONG)
		if (dt > 0 && dt < 100) ; 1/7 选右边
			Swipe(1825, 530, 1884, 532)
		else if (dt > 0 && dt < 200) ; 1/7 选左边
			Swipe(1884, 530, 1825, 532)
		if CheckPixel(RACE_FINISH_X, RACE_FINISH_Y, RACE_FINISH_COLOR)
			Break
		if (A_TickCount > maxRaceTime)
			Reload
	}
	local successCount = 0
	while (successCount < 3 || A_Index > 100)
	{
		local checkBack := CheckPixel(BACK_X, BACK_Y, BACK_COLOR)
		local checkNext := CheckPixel(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK)
		local checkNext2 := checkNext ? false : CheckPixel(NEXT_X_2, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; 有时继续按钮位置比较远，多加了个位置判断
		local checkNext3 := checkNext2 ? false : CheckPixel(NEXT_X_3, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_WHITE, NEXT_COLOR_BLACK) ; 达到俱乐部里程碑，暂不领取
		if (checkBack) ; 同时出现返回按钮和继续按钮时说明已经回到选车前页面，这里加3次是为了避免领奖励引发误判
		{
			successCount++
			Sleep DELY_SHORT
		}
		else if (checkNext)
			RandomClick(NEXT_X, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else if (checkNext2)
			RandomClick(NEXT_X_2, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else if (checkNext3)
			RandomClick(NEXT_X_3, NEXT_Y, DELY_VERY_SHORT, DELY_MIDDLE)
		else
			Sleep DELY_SHORT
	}
	return true
}

CheckOperateMode() ; 检查操作模式是否是自动挡
{
	global OPERATE_MODE_X, OPERATE_MODE_Y, OPERATE_MODE_RANGE
	operateModeX := OPERATE_MODE_X
	operateModeY := OPERATE_MODE_Y
	Loop %OPERATE_MODE_RANGE% ; 判断操作模式是否为手动
	{
		operateModeColor := GetPixel(operateModeX, operateModeY)
		if ((operateModeColor & 0xFF00) > 0x7FFF) ; 即：绿色 > 127
			return true
	}
	return false
}

Init() ; 脚本主逻辑
{
	OnExit RevertControlSetting
	ShowTrayTip("脚本开始运行`n可以自由调整窗口大小位置")
	WaitWin()
	CalcWin()
	ResizeWin()
	;WaitUser()
	;CloseApp()
	;OpenApp()
	RunDailyRace()
}

Init()
return

; 热键

^F9::Pause ; 暂停/恢复
^F10::Reload ; 重置
^F11::ExitApp ; 退出
^F12:: ; 关闭A9并退出
Gosub RevertControlSetting
CloseApp()
ExitApp
return

; 事件处理

RevertControlSetting: ; 退出时，如果是
if A_ExitReason in Logoff,Shutdown,Close,Menu,Exit ; 在这行语句中, 注意不要在逗号周围含有空格
{
	if (OPERATE_MODE = 1)
	{
		if CheckPixel(RACING_CHECK_X, RACING_CHECK_Y, RACING_CHECK_COLOR) ; 比赛中则先退出比赛，如果比赛中检测失效，那这里不会正确改回操作模式
		{
			RandomClick(RACING_CHECK_X, RACING_CHECK_Y, , DELY_MIDDLE, 3)
			RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_MIDDLE, 3)
		}
		else if !CheckPixel(GAME_RUNNING_CHECK_X, GAME_RUNNING_CHECK_Y, GAME_RUNNING_CHECK_COLOR_NORMAL, GAME_RUNNING_CHECK_COLOR_DARK, GAME_RUNNING_CHECK_COLOR_GRAY)
			return
		GoHome()
		if !CheckPixel(CAREER_RACE_X, CAREER_RACE_Y, CAREER_RACE_COLOR)
			RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
		RandomClick(CAREER_RACE_X, CAREER_RACE_Y, , DELY_MIDDLE)
		WaitColor(BACK_X, BACK_Y, BACK_COLOR)
		RandomClick(EURO_CHAPTER_X, EURO_CHAPTER_Y, DELY_SHORT, DELY_SHORT, 2)
		RandomClick(EURO_SEASON_X, EURO_SEASON_Y, , DELY_MIDDLE)
		WaitColor(NEXT_X, NEXT_Y, NEXT_COLOR_GREEN, NEXT_COLOR_RED, NEXT_COLOR_BLACK)
		RandomClick(NEXT_X, NEXT_Y, DELY_SHORT, DELY_LONG)
		RandomClick(CAR_FIRST_OIL_X - 220, CAR_UPPER_OIL_Y - 150, , DELY_LONG)
		if CheckOperateMode()
			RandomClick(OPERATE_MODE_X, OPERATE_MODE_Y, , DELY_LONG, 3)
	}
}
return

